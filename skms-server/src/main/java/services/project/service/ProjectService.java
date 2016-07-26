package services.project.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

//import org.seasar.extension.jdbc.where.ComplexWhere;
import org.apache.log4j.Logger;
import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import dto.LabelDto;

import enumerate.ProjectPositionId;
import enumerate.WorkStatusId;

import services.accounting.entity.Transportation;
import services.generalAffair.entity.MProjectPosition;
import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.MStaffProjectPosition;
import services.project.dto.ProjectBillDto;
import services.project.dto.ProjectBillItemDto;
import services.project.dto.ProjectDto;
import services.project.dto.ProjectMemberDto;
import services.project.dto.ProjectSearchDto;
import services.project.dto.ProjectSituationDto;
import services.project.dxo.LabelDxo;
import services.project.dxo.ProjectBillDxo;
import services.project.dxo.ProjectBillItemDxo;
import services.project.dxo.ProjectDxo;
import services.project.dxo.ProjectMemberDxo;
import services.project.dxo.ProjectSituationDxo;
import services.project.entity.MBankAccount;
import services.project.entity.MCustomer;
import services.project.entity.Project;
import services.project.entity.ProjectBill;
import services.project.entity.ProjectBillItem;
import services.project.entity.ProjectMember;
import services.project.entity.ProjectSituation;
/**
 * プロジェクトを扱うアクションです。


 *
 * @author yasuo-k
 *
 */
public class ProjectService {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * ログです.
	 */
	public Logger logger;

	/**
	 * プロジェクト情報変換Dxoです.
	 */
	public ProjectDxo projectDxo;

	/**
	 * プロジェクトメンバー情報変換Dxoです.
	 */
	public ProjectMemberDxo projectMemberDxo;

	/**
	 * プロジェクト請求情報Dxoです.
	 */
	public ProjectBillDxo projectBillDxo;

	/**
	 * プロジェクト請求項目情報Dxoです.
	 */
	public ProjectBillItemDxo projectBillItemDxo;

	/**
	 * プロジェクト状況情報Dxoです.
	 */
	public ProjectSituationDxo projectSituationDxo;

	/**
	 * ラベルDxoです.
	 */
	public LabelDxo labelDxo;


	/**
	 * プロジェクトメンバー候補リストを返します.
	 *
	 * @return プロジェクトメンバー候補のリスト.
	 */
	public List<ProjectMemberDto> getProjectStaffList() throws Exception
	{
		// データベースに問い合わせる.
		List<MStaff> staffList = getStaffList();

		// Dxoで変換する.
		List<ProjectMemberDto> projectStaffList = projectMemberDxo.convert(staffList);
		return projectStaffList;
	}

	/**
	 * 社員リストを返します.
	 *
	 * @return 社員リスト.
	 */
	public List<MStaff> getStaffList() throws Exception
	{
		// データベースに問い合わせる.
		List<MStaff> staffList = jdbcManager
									.from(MStaff.class)
									.innerJoin("staffName")
									.innerJoin("currentStaffWorkStatus",
											new SimpleWhere().ne("currentStaffWorkStatus.workStatusId", WorkStatusId.RETIRED))
									.orderBy("staffId")
									.getResultList();

		return staffList;
	}

	/**
	 * プロジェクトのリストを返します.
	 *
	 * @param  search プロジェクト検索情報.
	 * @return プロジェクトのリスト.
	 */
	public List<ProjectDto> getProjectList(ProjectSearchDto search) throws Exception
	{
		// 未設定は Exception とする.
		ProjectUtil.checkData_search(search);

		// 検索条件を作成する.

		// プロジェクト


		String projectCode = search.projectCode != null ? "%" + search.projectCode + "%" : "";
		String projectName = search.projectName != null ? "%" + search.projectName + "%" : "";

		// 期間
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String actualStartDateFrom = search.actualStartDateFrom != null ?  sdf.format(search.actualStartDateFrom): "";
		String actualStartDateTo = search.actualStartDateTo != null ?  sdf.format(search.actualStartDateTo): "";
		String actualFinishDateFrom = search.actualFinishDateFrom != null ?  sdf.format(search.actualFinishDateFrom): "";
		String actualFinishDateTo = search.actualFinishDateTo != null ?  sdf.format(search.actualFinishDateTo): "";

		// PM.
		Integer pmStaff = search.pmStaffId > 0 ? search.pmStaffId : 0;

		// プロジェクトメンバー名


		String projectMemberName = search.projectMemberName != null ? "%" + search.projectMemberName + "%" : "";

		// データベースに問い合わせる.
		List<Project> projectList =
			jdbcManager.from(Project.class)
				.leftOuterJoin("customer")
				.leftOuterJoin("projectmembers")
				.leftOuterJoin("projectmembers.staff")
				.leftOuterJoin("projectmembers.projectPosition")
				.leftOuterJoin("projectmembers.staff.staffName")
				.leftOuterJoin("projectBills")
				.leftOuterJoin("projectBills.projectBillItems")
				.leftOuterJoin("projectSituations")
				.leftOuterJoin("projectSituations.staff")
				.leftOuterJoin("projectSituations.staff.staffName")
				//.leftOuterJoin("projectBills.bankAcount")
				.where("projectType = ?"
						+ " and deleteFlg = false"
						+ " and (projectCode like ? or ? = '')"
						+ " and (projectName like ? or ? = '')"
						+ " and ((actualStartDate is null and ? = true) or (actualStartDate is not null and (actualStartDate >= to_date(?, 'YYYYMMDD') or ? = '')))"
						+ " and ((actualStartDate is null and ? = true) or (actualStartDate is not null and (actualStartDate <= to_date(?, 'YYYYMMDD') or ? = '')))"
						+ " and ((actualFinishDate is null and ? = true) or (actualFinishDate is not null and (actualFinishDate >= to_date(?, 'YYYYMMDD') or ? = '')))"
						+ " and ((actualFinishDate is null and ? = true) or (actualFinishDate is not null and (actualFinishDate <= to_date(?, 'YYYYMMDD') or ? = '')))"
						+ " and ((exists (select project_member.staff_id from project_member"
						+ " where project_id = projectmembers.projectId"
						+ " and project_member.staff_id = ?)) or (? = 0))"
						+ " and ((exists (select project_member.staff_id from project_member"
						+ " where project_id = projectmembers.projectId"
						+ " and project_member.staff_id = ? and project_member.project_position_id = ?)) or (? = 0))"
						+ " and ((exists (select project_member.staff_id from project_member"
						+ " inner join m_staff_name on project_member.staff_id = m_staff_name.staff_id"
						+ " where project_member.project_id = projectmembers.projectId"
						+ " and (m_staff_name.last_name || m_staff_name.first_name like translate(?, ' 　','')"
						+ " or  m_staff_name.last_name_kana || m_staff_name.first_name_kana like translate(?, ' 　','')))) or (? = ''))",
						Project.PROJECT_TYPE_PROJECT,
						projectCode,
						projectCode,
						projectName,
						projectName,
						search.actualStartDateNone,
						actualStartDateFrom,
						actualStartDateFrom,
						search.actualStartDateNone,
						actualStartDateTo,
						actualStartDateTo,
						search.actualFinishDateNone,
						actualFinishDateFrom,
						actualFinishDateFrom,
						search.actualFinishDateNone,
						actualFinishDateTo,
						actualFinishDateTo,
						search.staffId,
						search.staffId,
						pmStaff,
						ProjectPositionId.PM,
						pmStaff,
						projectMemberName,
						projectMemberName,
						projectMemberName
				)
				.orderBy("projectId, projectmembers.projectPositionId, projectmembers.staffId"
						+ ", projectBills.billDate, projectBills.projectBillItems.itemNo, projectBills.projectBillItems.taxFlg"
						+ ", projectSituations.situationNo desc")
				.getResultList();

		List<ProjectDto> dtoList = new ArrayList<ProjectDto>();

		// Dxoで変換
		for (Project p : projectList) {
			ProjectDto dto = new ProjectDto();
			projectDxo.convert(p, dto);
			dtoList.add(dto);
		}
		return dtoList;
	}

	/**
	 * プロジェクト情報を返します.
	 *
	 * @param  projectId プロジェクトID.
	 * @return プロジェクトのエンティティ.
	 */
	public Project getProjectInfo(int projectId) throws Exception
	{
		// データベースに問い合わせる.
		Project project = jdbcManager
									.from(Project.class)
									.leftOuterJoin("projectMembers")
									.leftOuterJoin("projectMembers.staff")
									.leftOuterJoin("projectMembers.projectPosition")
									.leftOuterJoin("projectMembers.staff.staffName")
									.leftOuterJoin("projectMembers.staff.staffSetting")
									.where(new SimpleWhere().eq("projectId", projectId))
									.getSingleResult();
		return project;

	}

	/**
	 * プロジェクトを更新する.
	 *
	 * @param  staff   登録する社員情報.
	 * @param  project 登録するプロジェクト情報.
	 * @return 更新結果.
	 */
	public int createProject(MStaff staff, ProjectDto prjDto) throws Exception
	{
		// 未設定は Exception とする.
		ProjectUtil.checkData_staff(staff);
		ProjectUtil.checkData_project(prjDto);

		int retnum = 0;
		Project project = null;
		// 新規追加のとき.
		if (prjDto.isNew()) {
			// projectの追加.
			project = projectDxo.convertCreate(prjDto, staff);
			retnum += jdbcInsertProject(project);

			// project_memberの追加.
			for (ProjectMember member : project.projectMembers) {
				retnum += jdbcInsertProjectMember(member);
			}
		}
		// 更新のとき.
		else if (prjDto.isUpdate()) {
			// projectの更新.
			project = projectDxo.convertUpdate(prjDto, staff);
			retnum += jdbcUpdateProject(project);

			// project_memberの更新.
			for (ProjectMemberDto memDto : prjDto.projectMembers) {
				ProjectMember member;
				if (memDto.isUpdate()) {
					member = projectMemberDxo.convertUpdate(memDto, project);
					retnum += jdbcUpdateProjectMember(member);
					continue;
				}
				else if (memDto.isNew()) {
					member = projectMemberDxo.convertCreate(memDto, project);
					retnum += jdbcInsertProjectMember(member);
					continue;
				}
				else if (memDto.isDelete()) {
					// 関連データがあるときは削除しない.
					member = projectMemberDxo.convertDelete(memDto, project);
					checkRelatedData_projectMember(member);
					retnum += jdbcDeleteProjectMember(member);
					continue;
				}
			}
		}

		// project_billの追加.
		for (ProjectBillDto prjbillDto : prjDto.projectBills) {
			ProjectBill bill;
			if (prjbillDto.isNew()) {
				bill = projectBillDxo.convertCreate(prjbillDto, project);
				retnum += jdbcInsertProjectBill(bill);
			}
			else if (prjbillDto.isUpdate()) {
				bill = projectBillDxo.convertUpdate(prjbillDto, project);
				retnum += jdbcUpdateProjectBill(bill);
			}
			else if (prjbillDto.isDelete()) {
				bill = projectBillDxo.convertUpdate(prjbillDto, project);
				retnum += jdbcDeleteProjectBill(bill);
				continue;
			}
			else {
				continue;
			}

			// project_bill_item（課税対象）の追加.
			for (ProjectBillItemDto itemDto : prjbillDto.projectBillItems) {
				if (itemDto.isNew()) {
					ProjectBillItem item = projectBillItemDxo.convertCreate(itemDto, bill, true);
					retnum += jdbcInsertProjectBillItem(item);
				}
				else if (itemDto.isUpdate()) {
					ProjectBillItem item = projectBillItemDxo.convertUpdate(itemDto, bill, true);
					retnum += jdbcUpdateProjectBillItem(item);
				}
				else if (itemDto.isDelete()) {
					ProjectBillItem item = projectBillItemDxo.convertUpdate(itemDto, bill, true);
					retnum += jdbcDeleteProjectBillItem(item);
				}
				else {
					continue;
				}
			}
			// project_bill_item（課税対象外）の追加.
			for (ProjectBillItemDto itemDto : prjbillDto.projectBillOthers) {
				if (itemDto.isNew()) {
					ProjectBillItem item = projectBillItemDxo.convertCreate(itemDto, bill, false);
					retnum += jdbcInsertProjectBillItem(item);
				}
				else if (itemDto.isUpdate()) {
					ProjectBillItem item = projectBillItemDxo.convertUpdate(itemDto, bill, false);
					retnum += jdbcUpdateProjectBillItem(item);
				}
				else if (itemDto.isDelete()) {
					ProjectBillItem item = projectBillItemDxo.convertUpdate(itemDto, bill, false);
					retnum += jdbcDeleteProjectBillItem(item);
				}
				else {
					continue;
				}
			}
		}
		return retnum;
	}

	/**
	 * プロジェクトを削除する.
	 *
	 * @param  staff   登録する社員情報.
	 * @param  project 登録するプロジェクト情報.
	 * @return 更新結果.
	 */
	public int deleteProject(MStaff staff, ProjectDto prjDto) throws Exception
	{
		// 未設定は Exception とする.
		ProjectUtil.checkData_staff(staff);
		ProjectUtil.checkData_project(prjDto);


		// 関連データがあるときは Exception とする.
		Project project = projectDxo.convertDelete(prjDto, staff);
		checkRelatedData_project(project);
		return jdbcDeleteProject(project);
	}

	/**
	 * プロジェクトを登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcInsertProject(Project entity)
	{
		// projectの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * プロジェクトを更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateProject(Project entity)
	{
		// projectの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * プロジェクトを削除で更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcDeleteProject(Project entity)
	{
		// projectの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * プロジェクトメンバを登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcInsertProjectMember(ProjectMember entity)
	{
		// project_memberの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * プロジェクトメンバを更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateProjectMember(ProjectMember entity)
	{
		// project_memberの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * プロジェクトメンバを削除します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcDeleteProjectMember(ProjectMember entity)
	{
		// project_memberの更新.
		return jdbcManager.delete(entity).execute();
	}

	/**
	 * 指定プロジェクトに関連するデータの有無を確認する.
	 *
	 * @param  entity
	 * @return 確認結果.
	 */
	private boolean checkRelatedData_project(Project entity) throws Exception
	{
		// 検索条件を設定する。


		List<Integer> projectList = new ArrayList<Integer>();
		projectList.add(entity.projectId);
		List<Integer> staffList   = new ArrayList<Integer>();

		// 交通費申請があるかどうか確認する。


		checkExistTransportation(projectList, staffList);
		return false;
	}

	/**
	 * 指定プロジェクトに関連するデータの有無を確認する.
	 *
	 * @param  entity
	 * @return 削除可否.
	 */
	private boolean checkRelatedData_projectMember(ProjectMember entity) throws Exception
	{
		// 検索条件を設定する。


		List<Integer> projectList = new ArrayList<Integer>();
		projectList.add(entity.projectId);

		List<Integer> staffList   = new ArrayList<Integer>();
		staffList.add(entity.staffId);

		// 交通費申請があるかどうか確認する。


		checkExistTransportation(projectList, staffList);
		return false;
	}

	/**
	 * 指定プロジェクトに関連する交通費申請データの有無を確認する.
	 *
	 * @param projectList プロジェクトIDリスト


	 * @param staffList   プロジェクトメンバIDリスト


	 * @return 確認結果
	 */
	private boolean checkExistTransportation(List<Integer> projectList, List<Integer> staffList) throws Exception
	{
		// 交通費申請データを問い合わせる.
		List<Transportation> translist = jdbcManager
												.from(Transportation.class)
												.innerJoin("staff")
												.innerJoin("staff.staffName")
												.where(new SimpleWhere().in("projectId", projectList.toArray())
																		.in("staffId",   staffList.toArray()))
												.getResultList();

		// 申請者を取得する.
		TreeMap<Integer, String> map = new TreeMap<Integer, String>();
		for (Transportation trans : translist) {
			map.put(trans.staff.staffId, trans.staff.staffName.fullName);
		}
		if (map.size() > 0)		throw ProjectUtil.createDeleteExceptionTrans(map);
		return false;
	}

	/**
	 * プロジェクト役職リストを返します.
	 *
	 * @return プロジェクト役職リスト.
	 */
	public List<LabelDto> getProjectPositionList() throws Exception
	{
		// データベースに問い合わせる.
		List<MProjectPosition> positionList = jdbcManager.from(MProjectPosition.class).orderBy("projectPositionId").getResultList();
		return labelDxo.convertProjectPosition(positionList);
	}

	/**
	 * プロジェクト役職PM社員リストを返します.
	 *
	 * @return プロジェクト役職PM社員リスト.
	 */
	public List<LabelDto> getProjectPositionPMList() throws Exception
	{
		// データベースに問い合わせる.
		List<MStaffProjectPosition> positionList = jdbcManager
														.from(MStaffProjectPosition.class)
														.innerJoin("staff")
														.innerJoin("staff.staffName")
														.where("projectPositionId = ? " +
																"and updateCount = (select max(update_count) from m_staff_project_position where staffId = staff_id)" +
																"and applyDate < NOW()" +
																"and cancelDate is null",
																ProjectPositionId.PM)
														.orderBy("staffId")
														.getResultList();
		return labelDxo.convertProjectPositionPM(positionList);
	}

	/**
	 * 顧客リストを返します.
	 *
	 * @return 顧客リスト.
	 */
	public List<MCustomer> getCustomerList() throws Exception
	{
		// データベースに問い合わせる.
		List<MCustomer> customerList = jdbcManager
									.from(MCustomer.class)
									.where("deleteFlg = false")
									.orderBy("sortOrder")
									.getResultList();
		return customerList;
	}


//	/**
//	 * 所属プロジェクトのリストを返します.
//	 *
//	 * @return 所属プロジェクトのラベルリスト.
//	 */
//	public List<Project> getBelongProjectList(Staff staff) throws Exception
//	{
//		// 未設定は Exception とする。


//		checkData_staff(staff);
//
//		// データベースに問い合わせる。


//		List<Project> projectList = jdbcManager
//										.from(Project.class)
//										.innerJoin("projectmembers")
//										.where(new SimpleWhere().eq("projectmembers.staffId", staff.staffId)
//																)
//										.getResultList();
//		return projectList;
//	}

	/**
	 * 銀行リストを返します.
	 *
	 * @return 銀行リスト.
	 */
	public List<MBankAccount> getBankList() throws Exception
	{
		// データベースに問い合わせる.
		List<MBankAccount> bankList = jdbcManager
									.from(MBankAccount.class)
									.orderBy("account_id")
									.getResultList();
		return bankList;
	}

	/**
	 * プロジェクト請求情報を登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcInsertProjectBill(ProjectBill entity)
	{
		// project_billの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * プロジェクト請求情報を更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateProjectBill(ProjectBill entity)
	{
		// project_billの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * プロジェクト請求情報を削除します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcDeleteProjectBill(ProjectBill entity)
	{
		// project_billの削除.
		return jdbcManager.delete(entity).execute();
	}

	/**
	 * プロジェクト請求項目情報を登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcInsertProjectBillItem(ProjectBillItem entity)
	{
		// project_bill_itemの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * プロジェクト請求項目情報を更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateProjectBillItem(ProjectBillItem entity)
	{
		// project_bill_itemの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * プロジェクト請求項目情報を削除します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcDeleteProjectBillItem(ProjectBillItem entity)
	{
		// project_bill_itemの削除.
		return jdbcManager.delete(entity).execute();
	}


	/**
	 * プロジェクト状況を更新する.
	 *
	 * @param  staff     登録する社員情報.
	 * @param  situation 登録するプロジェクト状況.
	 * @return 更新結果.
	 */
	public int createProjectSituation(MStaff staff, ProjectSituationDto situationDto) throws Exception
	{
		// 未設定は Exception とする.
		ProjectUtil.checkData_staff(staff);
		ProjectUtil.checkData_situation(situationDto);


		int retnum = 0;
		ProjectSituation situation;

		// 新規のとき.
		if (situationDto.isNew()) {
			situation = projectSituationDxo.convertCreate(situationDto, staff);
			retnum += jdbcInsertProjectSituation(situation);
		}
		// 更新のとき.
		else if (situationDto.isUpdate()){
			situation = projectSituationDxo.convertUpdate(situationDto, staff);
			retnum += jdbcUpdateProjectSituation(situation);
		}
		return retnum;
	}

	/**
	 * プロジェクト状況情報を登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcInsertProjectSituation(ProjectSituation entity)
	{
		// project_situationの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * プロジェクト状況情報を更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateProjectSituation(ProjectSituation entity)
	{
		// project_situationの更新.
		return jdbcManager.update(entity).execute();
	}


}