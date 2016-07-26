package services.accounting.service;

import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.seasar.extension.jdbc.where.ComplexWhere;
import org.seasar.extension.jdbc.where.SimpleWhere;
import org.seasar.framework.container.SingletonS2Container;

import dto.LabelDto;

import enumerate.DepartmentId;
import enumerate.ProjectPositionId;

import services.accounting.dto.ProjectTransportationDto;
import services.accounting.dto.ProjectTransportationMonthlySearchDto;
import services.accounting.dto.TransportationDetailDto;
import services.accounting.dto.TransportationDto;
import services.accounting.entity.*;
import services.generalAffair.entity.MStaff;
import services.system.entity.StaffSetting;
import services.system.service.SystemService;
import services.generalAffair.service.StaffService;
import services.mail.mai.MailTransportationDto;
import services.project.entity.Project;
import services.project.entity.ProjectMember;
import services.project.service.ProjectService;
import services.mail.mai.SkmsMai;


/**
 * 交通費を扱うサービスです。


 *
 * @author yasuo-k
 *
 */
public class TransportationService extends AccountingService {

	/**
	 * メール送信オブジェクト.
	 */
    public SkmsMai skmsMai;

	/**
	 * 所属プロジェクトのリストを返します.
	 *
	 * @return 所属プロジェクトのラベルリスト.
	 */
	public List<Project> getBelongProjectList(MStaff staff) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);

		// データベースに問い合わせる.
		List<Project> projectList = jdbcManager
										.from(Project.class)
										.leftOuterJoin("projectmembers")
										.leftOuterJoin("projectmembers.projectPosition")
										.innerJoin("projectmembers.staff")
										.innerJoin("projectmembers.staff.staffName")
										.where(new SimpleWhere()
											.eq("projectmembers.staffId", staff.staffId)
											.le("projectmembers.actualJoinDate", Calendar.getInstance().getTime())
											.eq("deleteFlg", false)
											.le("actualStartDate", Calendar.getInstance().getTime()))
										.orderBy("actualFinishDate desc, actualStartDate desc, projectId asc")
										.getResultList();

//		// Dxoで変換
//		List<LabelDto> labelList = labelDxo.convertProject(projectList);
		return projectList;
	}

	/**
	 * 申請対象の交通費申請のリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @param projectList プロジェクトIDリスト.
	 * @param statusList 申請状態リスト.
	 * @param subordinateOnly 部下のみ検索有無(不使用).
	 * @return 交通費申請のリスト.
	 */
	public  List<TransportationDto> getRequestTransportations(MStaff staff, List<Integer> projectList, List<Integer> statusList, boolean subordinateOnly) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_projectList(projectList);
		checkData_statusList(statusList);


		// データベースに問い合わせる.
		List<Transportation> searchlist = jdbcManager
											.from(Transportation.class)
											.innerJoin("projectInfo")
											.innerJoin("staff")
											.innerJoin("staff.staffName")
											.leftOuterJoin("transportationDetails")
											.innerJoin("transportationHistorys", "transportationHistorys.updateCount = (select max(H1_.update_count) from transportation_history H1_ where H1_.transportation_id = transportationId)")
											.innerJoin("transportationHistorys.transportationStatus")
											.where(new SimpleWhere().eq("staffId", staff.staffId)
																	.in("projectId", projectList.toArray())
																	.in("transportationHistorys.transportationStatus.transportationStatusId", statusList.toArray()))
											.getResultList();

		// 申請対象のtransportationがないときは Dxo変換して返す.
		if (!(searchlist.size() > 0)) {
			return transDxo.convertGetTransportations(searchlist, DATA_REAUEST, staff);
		}
		// transportationIdリストを作成する.
		ArrayList<Integer> searchIdItems = new ArrayList<Integer>();
		for (Transportation search : searchlist) {
			searchIdItems.add(search.transportationId);
		}

		// データベースに問い合わせる.
		return getTransportations_transportId(staff, DATA_REAUEST, searchIdItems);
	}

/* 2009.02.12 最新データチェックを Entity@version で行なうためコメントアウト	*/
//	/**
//	 * 申請対象の指定した交通費申請IDの交通費申請を返します.
//	 *
//	 * @param  staff    ログイン社員情報
//	 * @param  transDto 交通費申請情報
//	 * @return 交通費申請のリスト

//	 */
//	public TransportationDto getRequestTransportation(Staff staff, TransportationDto transDto) throws Exception
//	{
//		return getTransportation(staff, DATA_REAUEST, transDto);
//	}

	/**
	 * 承認対象の交通費申請のリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @param projectList プロジェクトIDリスト.
	 * @param statusList 申請状態リスト.
	 * @param subordinateOnly 部下のみ検索有無.
	 * @return 交通費申請のリスト.
	 */
	public List<TransportationDto> getApprovalTransportations(MStaff staff, List<Integer> projectList, List<Integer> statusList, boolean subordinateOnly) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_projectList(projectList);
		checkData_statusList(statusList);


		// projectPositionIdリストを作成する.
		ArrayList<Integer> managerIdItems = new ArrayList<Integer>();
		managerIdItems.add(ProjectPositionId.PL);
		managerIdItems.add(ProjectPositionId.PM);

		// 承認対象のtransportationリストを取得する.
		//  ・PM＆PL承認済み（承認）.
		//  ・PM＆申請済み  （承認）.
		//  ・PL＆申請済み  （承認）.
		//  ・PM＆PM承認済み（取り消し）.
		//  ・PL＆PL承認済み（取り消し）.
		//  ・PM＆AF承認済み（支払）.
		//  ・PM＆支払済み  （支払取り消し）.
		//  ・PM＆受領済み.
		List<Transportation> searchlist = null;
		// 部下のみでなければ.
		if (!subordinateOnly) {
			searchlist = jdbcManager
							.from(Transportation.class)
							.innerJoin("projectInfo")
							.leftOuterJoin("projectInfo.projectMembers", new SimpleWhere().eq("projectInfo.projectMembers.staffId", staff.staffId)
																				  .in("projectInfo.projectMembers.projectPositionId", managerIdItems.toArray()))
							.innerJoin("transportationHistorys", "transportationHistorys.updateCount = (select max(H1_.update_count) from transportation_history H1_ where H1_.transportation_id = transportationId)")
							.innerJoin("transportationHistorys.transportationStatus")
							.where(new ComplexWhere().in("projectId", projectList.toArray())
													 .in("transportationHistorys.transportationStatus.transportationStatusId", statusList.toArray())
													)
							.orderBy("transportationId, transportationHistorys.updateCount desc")
							.getResultList();
		} else {
			searchlist = jdbcManager
							.from(Transportation.class)
							.innerJoin("transportationDetails")
							.innerJoin("projectInfo", new SimpleWhere().in("projectId", projectList.toArray()))
							.innerJoin("transportationHistorys",
									"transportationHistorys.updateCount = (select max(H1_.update_count) from transportation_history H1_ where H1_.transportation_id = transportationId)")
							.innerJoin("transportationHistorys.transportationStatus",
									new SimpleWhere().in("transportationHistorys.transportationStatus.transportationStatusId", statusList.toArray()))
							.where("projectInfo.projectType = 0 or exists"
									+ " ("
									+ 	" select project.project_id from project, project_member"
									+	" where project_member.staff_id = staffId"
									+	" and project.project_id = project_member.project_id"
									+	" and project.delete_flg = false"
									+	" and ("
									+			"transportationDetails.transportationDate >= actual_join_date"
									+			" and (transportationDetails.transportationDate <= actual_retire_date or actual_retire_date is null)"
									+		")"
									+	" and project.project_id in "
									+ 	" ("
									+		"select project_id from project_member where staff_id = ? and project_position_id = ?"
									+	" )"
									+ " )"
								, staff.staffId
								, ProjectPositionId.PM)
							.orderBy("transportationId, transportationHistorys.updateCount desc")
							.getResultList();
		}

		// 承認対象のtransportationがないときは Dxo変換して返す.
		if (!(searchlist.size() > 0)) {
			return transDxo.convertGetTransportations(searchlist, DATA_APPROVAL, staff);
		}
		// transportationIdリストを作成する.
		ArrayList<Integer> searchIdItems = new ArrayList<Integer>();
		for (Transportation search : searchlist) {
			searchIdItems.add(search.transportationId);
		}

		// データベースに問い合わせる.
		return getTransportations_transportId(staff, DATA_APPROVAL, searchIdItems);
	}

	/**
	 * 経理承認対象の交通費申請のリストを返します.
	 *
	 * @param  staff ログイン社員情報.
	 * @param projectList プロジェクトIDリスト.
	 * @param statusList 申請状態リスト.
	 * @param subordinateOnly 部下のみ検索有無(不使用).
	 * @return 交通費申請のリスト.
	 */
	public List<TransportationDto> getApprovalTransportations_AF(MStaff staff, List<Integer> projectList, List<Integer> statusList, boolean subordinateOnly) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_projectList(projectList);
		checkData_statusList(statusList);


		// projectPositionIdリストを作成する.
		ArrayList<Integer> managerIdItems = new ArrayList<Integer>();
		managerIdItems.add(ProjectPositionId.PL);
		managerIdItems.add(ProjectPositionId.PM);

		// 承認対象のtransportationリストを取得する.
		//  ・申請済み.
		//  ・PL承認済み.
		//  ・PM承認済み.
		//  ・AF承認済み.
		//  ・支払済み.
		//  ・受領済み.
		List<Transportation> searchlist = jdbcManager
											.from(Transportation.class)
											.innerJoin("projectInfo")
											.leftOuterJoin("projectInfo.projectMembers")
											.innerJoin("transportationHistorys", "transportationHistorys.updateCount = (select max(H1_.update_count) from transportation_history H1_ where H1_.transportation_id = transportationId)")
											.innerJoin("transportationHistorys.transportationStatus")
											.where(new ComplexWhere().in("projectId", projectList.toArray())
																	 .in("transportationHistorys.transportationStatus.transportationStatusId", statusList.toArray())
																	)
											.orderBy("transportationId, transportationHistorys.updateCount desc")
											.getResultList();

		// 経理承認対象のtransportationがないときは Dxo変換して返す.
		if (!(searchlist.size() > 0)) {
			return transDxo.convertGetTransportations(searchlist, DATA_APPROVAL_AF, staff);
		}
		// transportationIdリストを作成する.
		ArrayList<Integer> searchIdItems = new ArrayList<Integer>();
		for (Transportation search : searchlist) {
			searchIdItems.add(search.transportationId);
		}

		// データベースに問い合わせる.
		return getTransportations_transportId(staff, DATA_APPROVAL_AF, searchIdItems);
	}

/* 2009.02.12 最新データチェックを Entity@version で行なうためコメントアウト	*/
//	/**
//	 * 通常承認対象の指定した交通費申請IDの交通費申請を返します.
//	 *
//	 * @param  staff    ログイン社員情報.
//	 * @param  transDto 交通費申請情報.
//	 * @return 交通費申請のリスト.
//	 */
//	public TransportationDto getApprovalTransportation(Staff staff, TransportationDto transDto) throws Exception
//	{
//		return getTransportation(staff, DATA_APPROVAL, transDto);
//	}
//
//	/**
//	 * 経理承認対象の指定した交通費申請IDの交通費申請を返します.
//	 *
//	 * @param  staff    ログイン社員情報.
//	 * @param  transDto 交通費申請情報.
//	 * @return 交通費申請のリスト.
//	 */
//	public TransportationDto getApprovalTransportation_AF(Staff staff, TransportationDto transDto) throws Exception
//	{
//		return getTransportation(staff, DATA_APPROVAL_AF, transDto);
//	}
//
//	/**
//	 * 指定した交通費申請IDの交通費申請を返します.
//	 *
//	 * @param  staff    ログイン社員情報.
//	 * @param  transDto 交通費申請情報.
//	 * @return 交通費申請のリスト.
//	 */
//	private TransportationDto getTransportation(Staff staff, int type, TransportationDto transDto) throws Exception
//	{
//		// transportationIdリストを作成する.
//		ArrayList<Integer> searchIdItems = new ArrayList<Integer>();
//		searchIdItems.add(transDto.transportationId);
//
//		// データベースに問い合わせる.
//		List<TransportationDto> transDtoList = getTransportations_transportId(staff, type, searchIdItems);
//		if (!(transDtoList != null && transDtoList.size() > 0)) {
//			return null;
//		}
//		return transDtoList.get(0);
//	}

	/**
	 * 交通費申請のリストを返します.
	 *
	 * @param  staff        ログイン社員情報.
	 * @param  type         データ取得タイプ.
	 * @param  transportIdItems 交通費申請情報IDリスト.
	 * @return 交通費申請のリスト.
	 */
	private List<TransportationDto> getTransportations_transportId(MStaff staff, int type, ArrayList<Integer> transportIdItems)
	{
		// データベースに問い合わせる.
		List<Transportation> translist = jdbcManager
											.from(Transportation.class)
											.innerJoin("projectInfo")
											.leftOuterJoin("projectInfo.projectMembers")
											.leftOuterJoin("projectInfo.projectMembers.projectPosition")
											.leftOuterJoin("staff")
											.leftOuterJoin("staff.staffName")
											.leftOuterJoin("transportationDetails")
											.innerJoin("transportationHistorys")
											.innerJoin("transportationHistorys.transportationStatus")
											.where(new SimpleWhere().in("transportationId", transportIdItems.toArray()))
											.orderBy("transportationId, transportationDetails.sequenceNo, transportationHistorys.updateCount desc, staff.staffName.updateCount desc")
											.getResultList();
		// Dxoで変換する.
		return transDxo.convertGetTransportations(translist, type, staff);
	}

	/**
	 * 交通費申請と交通費申請明細を登録します.
	 *
	 * @param  ログイン社員情報.
	 * @param  交通費申請情報Dto.
	 * @return 登録件数.
	 */
	public int createTransportation(MStaff staff, TransportationDto transDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);


		int retnum = 0;
		Transportation trans = null;
		// 更新のとき.
		if (transDto.isUpdate()) {
			// transportationの更新.
			trans = transDxo.convertUpdate(transDto, staff);
			retnum += jdbcUpdateTransportation(trans);

			// transportation_detailの更新.
			for (TransportationDetailDto transDetailDto : transDto.transportationDetails) {
				TransportationDetail transdetail;

				// 削除または更新のとき.
				if (transDetailDto.isDelete() || transDetailDto.isUpdate()){
					transdetail = transDetailDxo.convertDelete(transDetailDto);
					retnum += jdbcDeleteTransportationDetail(transdetail);
					continue;
				}
			}

			int seqNo = 1;
			for (TransportationDetailDto transDetailDto : transDto.transportationDetails) {
				TransportationDetail transdetail;

				// 更新または追加のとき.
				if (transDetailDto.isUpdate() || transDetailDto.isNew()) {
					transdetail = transDetailDxo.convertCreate(transDetailDto, trans);
					transdetail.sequenceNo = seqNo++;
					retnum += jdbcInsertTransportationDetail(transdetail);
					continue;
				}
			}
		}
		// 追加のとき.
		else if (transDto.isNew()) {
			// transportationの追加.
			trans = transDxo.convertCreate(transDto, staff);
			retnum += jdbcInsertTransportation(trans);

			// transportation_detailの追加.
			for (TransportationDetail transdetail : trans.transportationDetails) {
				retnum += jdbcInsertTransportationDetail(transdetail);
			}

			// transportation_historyの追加.
			TransportationHistory history = historyDxo.convertMake(trans);
			retnum += jdbcCreateHistory(history);
		}

		return retnum;
	}


	/**
	 * 交通費申請と交通費申請明細を削除します.
	 *
	 * @param  staff        ログイン社員情報.
	 * @param  transDtoList 交通費情報Dtoリスト.
	 * @return 更新件数.
	 */
	public int deleteTransportations(MStaff staff, List<TransportationDto> transDtoList) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDtoList(transDtoList);


		int retnum = 0;
		// transportationの削除.
		for (TransportationDto transDto : transDtoList) {
			if (transDto.isDelete()) {
				Transportation trans = transDxo.convertDelete(transDto);
				retnum += jdbcDeleteTransportation(trans);
			}
		}
		return retnum;
	}

	/**
	 * 交通費申請と交通費申請明細を削除します.
	 *
	 * @param  staff    ログイン社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int deleteTransportation(MStaff staff, TransportationDto transDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);

		int retnum = 0;
		// transportationの削除.
		if (transDto.isDelete()) {
			Transportation trans = transDxo.convertDelete(transDto);
			retnum += jdbcDeleteTransportation(trans);
		}
		return retnum;
	}

	/**
	 * 交通費申請明細を削除します.
	 *
	 * @param  detailList 交通費申請明細リスト.
	 * @return 更新件数.
	 */
	public int deleteTransportationDetails(MStaff staff, List<TransportationDetailDto> transDetailDtoList) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDetailDtoList(transDetailDtoList);


		int retnum = 0;
		// transportation_detailの削除.
		for (TransportationDetailDto transDetailDto : transDetailDtoList) {
			if (transDetailDto.isDelete()) {
				TransportationDetail transDetail = transDetailDxo.convertDelete(transDetailDto);
				retnum += jdbcDeleteTransportationDetail(transDetail);
			}
		}
		return retnum;
	}

	/**
	 * 交通費申請バージョンを更新します.
	 *
	 * @param  ログイン社員情報.
	 * @param  交通費申請情報Dto.
	 * @return 登録件数.
	 */
	private int updateTransportation_version(MStaff staff, TransportationDto transDto)
	{
		int retnum = 0;
		if (transDto.isUpdate()) {
			// transportationの更新.
			Transportation trans = transDxo.convertUpdate(transDto, staff);
			retnum += jdbcUpdateTransportation_version(trans);
		}
		return retnum;
	}

	/**
	 * 交通費申請情報を申請する.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int applyTransportation(MStaff staff, TransportationDto transDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertApply(transDto, staff);
		retnum +=jdbcCreateHistory(history);

		// 交通費申請時メール通知.
		sendMailTransportationApply(transDto, "", "applyTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報を更新＆申請する.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int updateApplyTransportation(MStaff staff, TransportationDto transDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);


		int retnum = 0;
		// 交通費申請情報を更新する.
		retnum += createTransportation(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertApply(transDto, staff);
		retnum +=jdbcCreateHistory(history);

		// 交通費申請時メール通知.
		sendMailTransportationApply(transDto, "", "applyTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報の申請を取り下げる.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int applyWithdrawTransportation(MStaff staff, TransportationDto transDto, String reason) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);
		checkData_reason(reason);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertApplyWithdraw(transDto, staff, reason);
		retnum += jdbcCreateHistory(history);

		// 交通費申請取り下げ時メール通知.
		sendMailTransportationApply(transDto, reason, "applyWithdrawTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報を承認する.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int approvalTransportation(MStaff staff, TransportationDto transDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertApproval(transDto, staff);
		retnum += jdbcCreateHistory(history);

		// 交通費承認時メール通知.
		sendMailTransportationApproval(staff, transDto, "", "approvalTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報の承認を取り消す.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int approvalCancelTransportation(MStaff staff, TransportationDto transDto, String reason) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);
		checkData_reason(reason);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertApprovalCancel(transDto, staff, reason);
		retnum += jdbcCreateHistory(history);

		// 交通費承認取り消し時メール通知.
		sendMailTransportationApproval(staff, transDto, reason, "approvalCancelTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報の承認を取り下げる.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int approvalWithdrawTransportation(MStaff staff, TransportationDto transDto, String reason) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);
		checkData_reason(reason);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertApprovalWithdraw(transDto, staff, reason);
		retnum += jdbcCreateHistory(history);

		// 交通費差し戻し時メール通知.
		sendMailTransportationApproval(staff, transDto, reason, "approvalWithdrawTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報を支払う.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int paymentTransportation(MStaff staff, TransportationDto transDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertPayment(transDto, staff);
		retnum += jdbcCreateHistory(history);

		// 交通費支払時メール通知.
		sendMailTransportationPayment(staff, transDto, "", "paymentTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報を支払取り消しする.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int paymentCancelTransportation(MStaff staff, TransportationDto transDto, String reason) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);
		checkData_reason(reason);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertPaymentCancel(transDto, staff, reason);
		retnum += jdbcCreateHistory(history);

		// 交通費支払取り消し時メール通知.
		sendMailTransportationPayment(staff, transDto, reason, "paymentCancelTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報を受領する.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int acceptTransportation(MStaff staff, TransportationDto transDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertAccept(transDto, staff);
		retnum += jdbcCreateHistory(history);

		// 交通費受領時メール通知.
		sendMailTransportationAccept(transDto, "", "acceptTransportation");

		return retnum;
	}

	/**
	 * 交通費申請情報を受領取り消しする.
	 *
	 * @param  staff    社員情報.
	 * @param  transDto 交通費情報Dto.
	 * @return 更新件数.
	 */
	public int acceptCancelTransportation(MStaff staff, TransportationDto transDto, String reason) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_transDto(transDto);
		checkData_reason(reason);


		int retnum = 0;
		// transportationを更新する.
		retnum += updateTransportation_version(staff, transDto);

		// transportation_historyを追加する.
		TransportationHistory history = historyDxo.convertAcceptCancel(transDto, staff, reason);
		retnum += jdbcCreateHistory(history);

		// 交通費受領取り消し時メール通知.
		sendMailTransportationAccept(transDto, reason, "acceptCancelTransportation");

		return retnum;
	}

	/**
	 * 交通費履歴を登録します.
	 *
	 * @param  entity.
	 * @return 登録件数.
	 */
	private int jdbcCreateHistory(TransportationHistory entity)
	{
		// transportation_historyの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * 交通費申請を登録します.
	 *
	 * @param  entity.
	 * @return 登録件数.
	 */
	private int jdbcInsertTransportation(Transportation entity)
	{
		// transportationの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * 交通費申請を更新します.
	 *
	 * @param  entity.
	 * @return 更新件数.
	 */
	private int jdbcUpdateTransportation(Transportation entity)
	{
		// transportationの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * 交通費申請を更新します.
	 *
	 * @param  entity.
	 * @return 更新件数.
	 */
	private int jdbcUpdateTransportation_version(Transportation entity)
	{
		// transportationの更新.
		// →transportation のカラムが増えたら、プロパティを増やすこと!!
		return jdbcManager.update(entity).excludes("transportationId", "projectId", "staffId").execute();
	}

	/**
	 * 交通費申請を削除します.
	 *
	 * @param  entity
	 * @return 削除件数
	 */
	private int jdbcDeleteTransportation(Transportation entity)
	{
		// transportationの削除
		return jdbcManager.delete(entity).execute();
	}

	/**
	 * 交通費申請明細を登録します.
	 *
	 * @param  entity
	 * @return 登録件数
	 */
	private int jdbcInsertTransportationDetail(TransportationDetail entity)
	{
		// transportation_detailの追加
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * 交通費申請明細を更新します.
	 *
	 * @param  entity TransportationDetail（交通費申請明細）

	 * @return 更新件数
	 */
//	private int jdbcUpdateTransportationDetail(TransportationDetail entity)
//	{
//		// transportation_detailの更新
//		return jdbcManager.update(entity).execute();
//	}

	/**
	 * 交通費申請明細を削除する.
	 *
	 * @param  entity TransportationDetail（交通費申請明細）

	 * @return 削除
	 */
	private int jdbcDeleteTransportationDetail(TransportationDetail entity)
	{
		// transportation_detailの削除
		return jdbcManager.delete(entity).execute();
	}


	/**
	 * 検索条件 交通費状態リストを返します.
	 *
	 * @return 交通費状態のラベルリスト

	 */
	public List<LabelDto> getRequestTransportationStatusList() throws Exception
	{
		// データベースに問い合わせる.


		List<MTransportationStatus> statuslist = jdbcSelectTransportationHistoryStatus();
		return labelDxo.convertStatus(statuslist);
	}

	/**
	 * 検索条件 交通費状態リストを返します.
	 *
	 * @return 交通費状態のラベルリスト

	 */
	public List<LabelDto> getApprovalTransportationStatusList() throws Exception
	{
		// データベースに問い合わせる.
		List<MTransportationStatus> statuslist = jdbcSelectTransportationHistoryStatus();
		return labelDxo.convertApprovalStatus(statuslist);
	}

	/**
	 * 検索条件 交通費状態リストを返します.
	 *
	 * @return 交通費状態のラベルリスト.
	 */
	public List<LabelDto> getApprovalTransportationStatusList_AF() throws Exception
	{
		// データベースに問い合わせる.
		List<MTransportationStatus> statuslist = jdbcSelectTransportationHistoryStatus();
		return labelDxo.convertApprovalStatus_AF(statuslist);
	}

	/**
	 * 交通費申請状況定義リストを取得する.
	 *
	 * @return 交通費申請状況定義リスト

	 */
	private List<MTransportationStatus> jdbcSelectTransportationHistoryStatus()
	{
		List<MTransportationStatus> statuslist = jdbcManager
															.from(MTransportationStatus.class)
															.orderBy("transportationStatusId")
															.getResultList();
		return statuslist;
	}


	/**
	 * 検索条件 所属プロジェクトのリストを返します.
	 *
	 * @return 所属プロジェクトのラベルリスト

	 */
	public List<LabelDto> getRequestProjectList(MStaff staff) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);


		// データベースに問い合わせる.

		List<Project> projectList = getBelongProjectList(staff);
		return labelDxo.convertProject(projectList);
	}

	/**
	 * 検索条件 所属プロジェクトのリストを返します.
	 *
	 * @return 所属プロジェクトのラベルリスト.
	 */
	public List<LabelDto> getApprovalProjectList(MStaff staff) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);


		// projectPositionIdリストを作成する.
		ArrayList<Integer> managerIdItems = new ArrayList<Integer>();
		managerIdItems.add(ProjectPositionId.PL);
		managerIdItems.add(ProjectPositionId.PM);

		// データベースに問い合わせる.
		List<Project> projectList = jdbcSelectProject(staff.staffId, managerIdItems);
		return labelDxo.convertProject(projectList);
	}

	/**
	 * 検索条件 所属プロジェクトのリストを返します.


	 *
	 * @return 所属プロジェクトのラベルリスト


	 */
	public List<LabelDto> getApprovalProjectList_AF(MStaff staff) throws Exception
	{
		// 未設定は Exception とする.


		checkData_staff(staff);


		// データベースに問い合わせる.


		List<Project> projectList = jdbcSelectProject(null, new ArrayList<Integer>());
		return labelDxo.convertProject(projectList);
	}

	/**
	 * 所属プロジェクトリストを取得する.


	 *
	 * @return 交所属プロジェクトのリスト


	 */
	private List<Project> jdbcSelectProject(Integer staffId, ArrayList<Integer> mangerItems)
	{
		List<Project> projectList = jdbcManager
										.from(Project.class)
										.innerJoin("projectmembers", new SimpleWhere().eq("projectmembers.staffId", staffId)
																					  .in("projectmembers.projectPositionId", mangerItems.toArray()))
										.where(new SimpleWhere()
											.eq("deleteFlg", false)
											.le("actualStartDate", Calendar.getInstance().getTime()))
										.orderBy("actualFinishDate desc, actualStartDate desc, projectId asc")
										.getResultList();
		return projectList;
	}

	/**
	 * 交通費申請時のメール通知を行う.


	 *
	 * @param  transDto		交通費情報Dto
	 * @param  reason		理由(申請取り下げ時のみ使用)
	 * @param  methodName	メール送信メソッド名


	 */
	public void sendMailTransportationApply(TransportationDto transDto, String reason, String methodName) throws Exception
	{
		// メール送信メソッドの取得


		Method method = skmsMai.getClass().getMethod(methodName, MailTransportationDto.class);
		// 交通費メール送信用DTO生成
		MailTransportationDto dto = new MailTransportationDto(transDto);
		// 理由のセット
		dto.setReason(reason);

		// プロジェクト情報の取得


		ProjectService projectService = SingletonS2Container.getComponent(ProjectService.class);
		Project project = projectService.getProjectInfo(transDto.projectId);
		// プロジェクト交通費ならば
		if (project.projectType == Project.PROJECT_TYPE_PROJECT) {
			for (ProjectMember member : project.projectMembers) {
				// PMかつメール通知有りならば
				if (member.projectPositionId != null
					&& member.projectPositionId == ProjectPositionId.PM
					&& member.staff.staffSetting != null
					&& Boolean.TRUE.equals(member.staff.staffSetting.sendMailTransportation)) {
					// 交通費申請時メール通知
					dto.setTo(member.staff.email);
					dto.setToName(member.staff.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
		// 全社的業務交通費ならば
		} else {
			// 総務部長一覧の取得


			StaffService staffService = SingletonS2Container.getComponent(StaffService.class);
			List<MStaff> accountingManagerList
				= staffService.getDepartmentHeadList(DepartmentId.GENERAL_AFFAIR);
			for (MStaff accountingManager : accountingManagerList) {
				// メール通知有りならば
				if (accountingManager.staffSetting != null
					&& Boolean.TRUE.equals(accountingManager.staffSetting.sendMailTransportation)) {
					// 交通費申請時メール通知
					dto.setTo(accountingManager.email);
					dto.setToName(accountingManager.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
		}

	}

	/**
	 * 交通費承認時のメール通知を行う.


	 *
	 * @param  staff		承認者情報
	 * @param  transDto		交通費情報Dto
	 * @param  reason		理由(承認取り消し、差し戻し時のみ使用)
	 * @param  methodName	メール送信メソッド名


	 */
	public void sendMailTransportationApproval(MStaff staff, TransportationDto transDto, String reason, String methodName) throws Exception
	{
		// メール送信メソッドの取得


		Method method = skmsMai.getClass().getMethod(methodName, MailTransportationDto.class);

		// 交通費メール送信用DTO生成
		MailTransportationDto dto = new MailTransportationDto(transDto);

		// 理由のセット
		dto.setReason(reason);

		// 承認種別のセット
		if (staff.staffProjectPosition != null
				&& staff.staffProjectPosition.size() > 0
				&& staff.staffProjectPosition.get(0).projectPositionId == ProjectPositionId.PM) {
			dto.setApprovalType("PM");
		} else {
			dto.setApprovalType("経理");
		}
		// 承認者のセット
		dto.setApprovalName(staff.staffName.fullName);

		// 申請者の環境設定取得


		SystemService systemService = SingletonS2Container.getComponent( SystemService.class );
		StaffSetting staffSetting = systemService.getStaffSetting(transDto.staffId);

		// 申請者に対するメール送信
		if (Boolean.TRUE.equals(staffSetting.sendMailTransportation)) {
			// 交通費承認時メール通知
			dto.setTo(transDto.staff.email);
			dto.setToName(transDto.staff.staffName.fullName);
			method.invoke(skmsMai, dto);
		}

		// PM承認ならば
		if (staff.staffProjectPosition != null
				&& staff.staffProjectPosition.size() > 0
				&& staff.staffProjectPosition.get(0).projectPositionId == ProjectPositionId.PM) {

			// 総務部長一覧の取得


			StaffService staffService = SingletonS2Container.getComponent( StaffService.class );
			List<MStaff> accountingManagerList
				= staffService.getDepartmentHeadList(DepartmentId.GENERAL_AFFAIR);

			// 総務部長に対してメール通知
			for (MStaff accountingManager : accountingManagerList) {
				// メール通知有りならば
				if (accountingManager.staffSetting != null
					&& Boolean.TRUE.equals(accountingManager.staffSetting.sendMailTransportation)) {
					// 交通費承認時メール通知
					dto.setTo(accountingManager.email);
					dto.setToName(accountingManager.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
		}

	}

	/**
	 * 交通費支払時のメール通知を行う.


	 *
	 * @param  staff		支払者情報
	 * @param  transDto		交通費情報Dto
	 * @param  reason		理由(支払取り消し時のみ使用)
	 * @param  methodName	メール送信メソッド名


	 */
	public void sendMailTransportationPayment(MStaff staff, TransportationDto transDto, String reason, String methodName) throws Exception
	{
		// メール送信メソッドの取得


		Method method = skmsMai.getClass().getMethod(methodName, MailTransportationDto.class);
		// 交通費メール送信用DTO生成
		MailTransportationDto dto = new MailTransportationDto(transDto);
		// 理由のセット
		dto.setReason(reason);
		// 承認者のセット
		dto.setApprovalName(staff.staffName.fullName);

		// 申請者の環境設定取得


		SystemService systemService = SingletonS2Container.getComponent( SystemService.class );
		StaffSetting staffSetting = systemService.getStaffSetting(transDto.staffId);

		// 申請者に対するメール送信
		if (Boolean.TRUE.equals(staffSetting.sendMailTransportation)) {
			// 交通費支払時メール通知
			dto.setTo(transDto.staff.email);
			dto.setToName(transDto.staff.staffName.fullName);
			method.invoke(skmsMai, dto);
		}
	}

	/**
	 * 交通費受領時のメール通知を行う.


	 *
	 * @param  transDto		交通費情報Dto
	 * @param  reason		理由(受領取り消し時のみ使用)
	 * @param  methodName	メール送信メソッド名


	 */
	public void sendMailTransportationAccept(TransportationDto transDto, String reason, String methodName) throws Exception
	{
		// メール送信メソッドの取得


		Method method = skmsMai.getClass().getMethod(methodName, MailTransportationDto.class);
		// 交通費メール送信用DTO生成
		MailTransportationDto dto = new MailTransportationDto(transDto);
		// 理由のセット
		dto.setReason(reason);

		// 総務部長一覧の取得


		StaffService staffService = SingletonS2Container.getComponent( StaffService.class );
		List<MStaff> accountingManagerList
			= staffService.getDepartmentHeadList(DepartmentId.GENERAL_AFFAIR);

		// 総務部長に対してメール通知
		for (MStaff accountingManager : accountingManagerList) {
			// メール通知有りならば
			if (accountingManager.staffSetting != null
				&& Boolean.TRUE.equals(accountingManager.staffSetting.sendMailTransportation)) {
				// 交通費受領時メール通知
				dto.setTo(accountingManager.email);
				dto.setToName(accountingManager.staffName.fullName);
				method.invoke(skmsMai, dto);
			}
		}
	}


	/**
	 * 交通機関のリストを返します.
	 *
	 * @return 交通機関ラベルリスト.
	 */
	public List<LabelDto> getFacilityNameList(MStaff staff) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);

		// データベースに問い合わせる.
		List<TransportationFacility> facilityList = jdbcManager
										.from(TransportationFacility.class)
										.orderBy("facilityId")
										.getResultList();
		List<LabelDto> labelList = labelDxo.convertFacility(facilityList);
		return labelList;
	}



	/**
	 * 交通費申請のプロジェクト月別集計リストを返します.
	 *
	 * @param staff  ログイン社員情報.
	 * @param search 検索条件.
	 * @return 集計リスト.
	 */
	public List<ProjectTransportationDto> getTransportationMonthlyList(MStaff staff, ProjectTransportationMonthlySearchDto search) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_search(search);

		SimpleWhere h1_where = new SimpleWhere().in("h1_.transportation_status_id", search.statusList.toArray());
		//SimpleWhere t2_where = new SimpleWhere().ge("t2_.transportation_date", search.startDate)
		//										.le("t2_.transportation_date", search.finishtDate);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String t2_where = "t2_.transportation_date >= to_date('" + sdf.format(search.startDate) +   "', 'YYYYMMDD') and " +
						  "t2_.transportation_date <= to_date('" + sdf.format(search.finishDate) + "', 'YYYYMMDD')";

		List<ProjectTransportation> list = null;
		// プロジェクト集計.
		if (search.isProjectMonthly) {
			// 発生日で集計ならば
			if (search.baseDateType == BASE_OCCUR_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select p1_.project_id, p1_.project_code, p1_.project_name, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from project p1_ " +
							" inner join transportation t1_ on p1_.project_id = t1_.project_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							"group by p1_.project_id, p1_.project_code, p1_.project_name, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) " +
							"order by p1_.project_code, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			// 支払日で集計ならば
			} else if (search.baseDateType == BASE_PAY_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select p1_.project_id, p1_.project_code, p1_.project_name, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from project p1_ " +
							" inner join transportation t1_ on p1_.project_id = t1_.project_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							" inner join transportation_history h2_ on t1_.transportation_id = h2_.transportation_id and h2_.transportation_status_id = 6" +
							"group by p1_.project_id, p1_.project_code, p1_.project_name, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) " +
							"order by p1_.project_code, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			}
		}
		// 個人集計.
		else {
			// 発生日で集計ならば
			if (search.baseDateType == BASE_OCCUR_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select s_.staff_id, s_.full_name, sw_.work_status_id, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from v_current_staff_name s_ " +
							" inner join v_current_staff_work_status sw_ on s_.staff_id = sw_.staff_id " +
							" inner join transportation t1_ on s_.staff_id = t1_.staff_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							"group by s_.staff_id, s_.full_name, sw_.work_status_id, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) " +
							"order by s_.staff_id, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			// 支払日で集計ならば
			} else if (search.baseDateType == BASE_PAY_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select s_.staff_id, s_.full_name, sw_.work_status_id, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from v_current_staff_name s_ " +
							" inner join v_current_staff_work_status sw_ on s_.staff_id = sw_.staff_id " +
							" inner join transportation t1_ on s_.staff_id = t1_.staff_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							" inner join transportation_history h2_ on t1_.transportation_id = h2_.transportation_id and h2_.transportation_status_id = 6" +
							"group by s_.staff_id, s_.full_name, sw_.work_status_id, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) " +
							"order by s_.staff_id, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			}
		}

		List<ProjectTransportationDto> converlist = prjtransDxo.convert(list);

		return converlist;
	}

	/**
	 * 交通費申請のプロジェクト月別集計詳細リストを返します.
	 *
	 * @param staff  ログイン社員情報.
	 * @param search 検索条件.
	 * @return 集計リスト.
	 */
	public List<ProjectTransportationDto> getTransportationMonthlyDetailList(MStaff staff, ProjectTransportationMonthlySearchDto search) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_search(search);

		SimpleWhere h1_where = new SimpleWhere().in("h1_.transportation_status_id", search.statusList.toArray());
		//SimpleWhere t2_where = new SimpleWhere().ge("t2_.transportation_date", search.startDate)
		//										.le("t2_.transportation_date", search.finishtDate);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String t2_where = "t2_.transportation_date >= to_date('" + sdf.format(search.startDate) +   "', 'YYYYMMDD') and " +
						  "t2_.transportation_date <= to_date('" + sdf.format(search.finishDate) + "', 'YYYYMMDD')";

		List<ProjectTransportation> list = null;
		String where = null;
		// プロジェクト集計の個人詳細.
		if (!search.isProjectMonthly) {
			// 詳細条件を設定する.
			where = "where t1_.staff_id = " + Integer.parseInt(search.objectId) + " ";
			where += getWhereObjectDate(search);


			// 発生日で集計ならば
			if (search.baseDateType == BASE_OCCUR_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select p1_.project_id, p1_.project_code, p1_.project_name, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from project p1_ " +
							" inner join transportation t1_ on p1_.project_id = t1_.project_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							where +
							"group by p1_.project_id, p1_.project_code, p1_.project_name, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) " +
							"order by p1_.project_code, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			// 支払日で集計ならば
			} else if (search.baseDateType == BASE_PAY_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select p1_.project_id, p1_.project_code, p1_.project_name, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from project p1_ " +
							" inner join transportation t1_ on p1_.project_id = t1_.project_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							" inner join transportation_history h2_ on t1_.transportation_id = h2_.transportation_id and h2_.transportation_status_id = 6" +
							where +
							"group by p1_.project_id, p1_.project_code, p1_.project_name, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) " +
							"order by p1_.project_code, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			}
		}
		// 個人集計のプロジェクト詳細.
		else {
			// 詳細条件を設定する.
			where = "where t1_.project_id = " + Integer.parseInt(search.objectId) + " ";
			where += getWhereObjectDate(search);

			// 発生日で集計ならば
			if (search.baseDateType == BASE_OCCUR_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select s_.staff_id, s_.full_name, sw_.work_status_id, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from v_current_staff_name s_ " +
							" inner join v_current_staff_work_status sw_ on s_.staff_id = sw_.staff_id " +
							" inner join transportation t1_ on s_.staff_id = t1_.staff_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							where +
							"group by s_.staff_id, s_.full_name, sw_.work_status_id, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) " +
							"order by s_.staff_id, to_char(t2_.transportation_date::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			// 支払日で集計ならば
			} else if (search.baseDateType == BASE_PAY_DATE) {
				list =
					jdbcManager.selectBySql(ProjectTransportation.class,
							"select s_.staff_id, s_.full_name, sw_.work_status_id, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) AS yyyymm, sum(t2_.expense) AS expense " +
							"from v_current_staff_name s_ " +
							" inner join v_current_staff_work_status sw_ on s_.staff_id = sw_.staff_id " +
							" inner join transportation t1_ on s_.staff_id = t1_.staff_id " +
							" inner join transportation_detail t2_ on t1_.transportation_id = t2_.transportation_id and " +  t2_where + " " +
							" inner join v_current_transportation_history h1_ on h1_.transportation_id = t1_.transportation_id and " + h1_where.getCriteria() + " " +
							" inner join transportation_history h2_ on t1_.transportation_id = h2_.transportation_id and h2_.transportation_status_id = 6" +
							where +
							"group by s_.staff_id, s_.full_name, sw_.work_status_id, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) " +
							"order by s_.staff_id, to_char(h2_.registration_time::timestamp with time zone, 'yyyymm'::text) ", h1_where.getParams())
							.getResultList();
			}
		}

		List<ProjectTransportationDto> converlist = prjtransDxo.convert(list);

		return converlist;
	}

	/**
	 * 検索条件 日付を返します.
	 *
	 * @param search 検索条件.
	 * @return 開始日付条件.
	 */
	private String getWhereObjectDate(ProjectTransportationMonthlySearchDto search) throws Exception
	{
		// 条件を作成する.
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String where = "";
		if (search.baseDateType == BASE_OCCUR_DATE) {
			if (search.objectStartDate != null)
				where += "and t2_.transportation_date >= to_date('" + sdf.format(search.objectStartDate)  +  "', 'YYYYMMDD') ";
			if (search.objectFinishDate != null)
				where += "and t2_.transportation_date <= to_date('" + sdf.format(search.objectFinishDate) +  "', 'YYYYMMDD') ";
		}
		else if (search.baseDateType == BASE_PAY_DATE) {
			if (search.objectStartDate != null)
				where += "and h2_.registration_time >= to_date('" + sdf.format(search.objectStartDate) +   "', 'YYYYMMDD') ";
			if (search.objectFinishDate != null)
				where += "and h2_.registration_time <= to_date('" + sdf.format(search.objectFinishDate) +  "', 'YYYYMMDD') ";
		}
		return where;
	}


	/**
	 * 検索条件 交通費状態リストを返します.
	 *
	 * @return 交通費状態のラベルリスト.
	 */
	public List<LabelDto> getTransportationMonthlyStatusList() throws Exception
	{
		// データベースに問い合わせる.
		List<MTransportationStatus> statuslist = jdbcSelectTransportationHistoryStatus();
		return labelDxo.convertTransportationMonthly(statuslist);
	}

}