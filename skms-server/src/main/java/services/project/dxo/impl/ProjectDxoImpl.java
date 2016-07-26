package services.project.dxo.impl;

import java.util.ArrayList;

import org.seasar.extension.jdbc.JdbcManager;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectBillDto;
import services.project.dto.ProjectBillItemDto;
import services.project.dto.ProjectDto;
import services.project.dto.ProjectMemberDto;
import services.project.dto.ProjectSituationDto;
import services.project.dxo.ProjectDxo;
import services.project.entity.Project;
import services.project.entity.ProjectBill;
import services.project.entity.ProjectBillItem;
import services.project.entity.ProjectMember;
import services.project.entity.ProjectSituation;

/**
 * プロジェクト情報変換Dxo実装クラスです.
 *
 * @author yasuo-k
 *
 */
public abstract class ProjectDxoImpl implements ProjectDxo {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * プロジェクト情報エンティティからプロジェクト情報Dtoへ変換.
	 *
	 * @param src プロジェクト情報エンティティ
	 * @param dst プロジェクト情報Dto
	 */
	public void convert(Project src, ProjectDto dst)
	{
		dst.projectId = src.projectId;
		dst.actualFinishDate = src.actualFinishDate;
		dst.actualStartDate = src.actualStartDate;
		if (src.customer != null) {
			dst.customerAlias = src.customer.customerAlias;
			dst.customerId = src.customerId;
			dst.customerName = src.customer.customerName;
			dst.customerNo = src.customer.customerNo;
			dst.customerType = src.customer.customerType;
		}
		dst.note = src.note;
		dst.orderName = src.orderName;
		dst.orderNo = src.orderNo;
		dst.planedFinishDate = src.planedFinishDate;
		dst.planedStartDate = src.planedStartDate;
		dst.projectCode = src.projectCode;
		dst.projectId = src.projectId;
		dst.projectName = src.projectName;
		dst.registrationVer = src.registrationVer;
		dst.projectMembers = new ArrayList<ProjectMemberDto>();

		if (src.projectMembers != null) {
			for (ProjectMember pm : src.projectMembers) {
				ProjectMemberDto mdto = new ProjectMemberDto();
				mdto.projectId = pm.projectId;
				mdto.staffId = pm.staffId;
				mdto.firstName = pm.staff.staffName.firstName;
				mdto.lastName = pm.staff.staffName.lastName;
				mdto.staffName = pm.staff.staffName.fullName;
				mdto.firstNameKana = pm.staff.staffName.firstNameKana;
				mdto.lastNameKana = pm.staff.staffName.lastNameKana;
				mdto.projectPositionId = pm.projectPositionId;
				if (pm.projectPosition != null) {
					mdto.projectPositionAlias = pm.projectPosition.projectPositionAlias;
					mdto.projectPositionName = pm.projectPosition.projectPositionName;
				}
				mdto.planedStartDate  = pm.planedJoinDate;
				mdto.planedFinishDate = pm.planedRetireDate;
				mdto.actualStartDate  = pm.actualJoinDate;
				mdto.actualFinishDate = pm.actualRetireDate;
				mdto.registrationVer  = pm.registrationVer;
				dst.projectMembers.add(mdto);
			}
		}
		dst.setProjectManager();

		dst.projectBills = new ArrayList<ProjectBillDto>();
		if (src.projectBills != null) {
			for (ProjectBill pb : src.projectBills) {
				ProjectBillDto bdto = new ProjectBillDto();
				bdto.projectId = pb.projectId;
				bdto.billNo    = pb.billNo;
				bdto.billDate  = pb.billDate;
				bdto.accountId = pb.accountId;
				bdto.registrationVer = pb.registrationVer;
				bdto.projectBillItems = new ArrayList<ProjectBillItemDto>();		// 請求項目リスト.
				bdto.projectBillOthers= new ArrayList<ProjectBillItemDto>();		// その他請求項目リスト.
				if (pb.projectBillItems != null) {
					for (ProjectBillItem pbi : pb.projectBillItems) {
						ProjectBillItemDto bidto = new ProjectBillItemDto();
						bidto.projectId = pbi.projectId;
						bidto.billNo    = pbi.billNo;
						bidto.itemNo    = pbi.itemNo;
						bidto.orderNo   = pbi.orderNo;
						bidto.title     = pbi.title;
						bidto.billAmount= pbi.billAmount == null ? null : Long.toString(pbi.billAmount);
						if (pbi.taxFlg) 		bdto.projectBillItems.add(bidto);
						else					bdto.projectBillOthers.add(bidto);
					}
				}
				dst.projectBills.add(bdto);
			}
		}

		dst.projectSituations = new ArrayList<ProjectSituationDto>();
		if (src.projectSituations != null) {
			for (ProjectSituation ps : src.projectSituations) {
				ProjectSituationDto psdto = new ProjectSituationDto();
				psdto.projectId        = ps.projectId;
				psdto.situationNo      = ps.situationNo;
				psdto.situation        = ps.situation;
				psdto.registrationTime = ps.registrationTime;
				psdto.registrantId     = ps.registrantId;
				psdto.registrationVer  = ps.registrationVer;
				psdto.registrationName = ps.staff.staffName.fullName;
			
				dst.projectSituations.add(psdto);
				
				//追加 @auther maruta
				if(dst.reportingDate == null)
				{
					dst.reportingDate = ps.registrationTime;
				}
				//
			}
			
		}
		
	}

	
	
	
	
	/**
	 * プロジェクト情報Dtoからプロジェクト情報エンティティへ変換.<br>
	 * プロジェクトメンバリストの変換あり.
	 *
	 * @param src   プロジェクト情報Dto
	 * @param staff ログイン社員情報
	 * @return プロジェクト情報エンティティ
	 */
	public Project convertCreate(ProjectDto src, MStaff staff)
	{
		// projectを作成する.
		Project dst = new Project(src, staff);
		int projectId = nextval_projectId();
		dst.projectId = projectId;

		// project_memberを作成する.
		dst.projectMembers = new ArrayList<ProjectMember>();
		for (ProjectMemberDto member : src.projectMembers) {
			ProjectMember prjmember = new ProjectMember(member, staff.staffId);
			prjmember.projectId = projectId;
			dst.projectMembers.add(prjmember);
		}
		return dst;
	}

	/**
	 * プロジェクト情報Dtoからプロジェクト情報エンティティへ変換.<br>
	 * プロジェクトメンバリストの変換なし.
	 *
	 * @param src   プロジェクト情報Dto
	 * @param staff ログイン社員情報
	 * @return プロジェクト情報エンティティ
	 */
	public Project convertUpdate(ProjectDto src, MStaff staff)
	{
		// projectを作成する.
		Project dst = new Project(src, staff);
		return dst;
	}

	/**
	 * プロジェクト情報Dtoからプロジェクト情報エンティティへ変換.<br>
	 * プロジェクトメンバリストの変換なし.
	 *
	 * @param src   プロジェクト情報Dto
	 * @param staff ログイン社員情報
	 * @return プロジェクト情報エンティティ
	 */
	public Project convertDelete(ProjectDto src, MStaff staff)
	{
		// projectを作成する.
		Project dst = new Project(src, staff);
		dst.deleteFlg = true;
		return dst;
	}

	/**
	 * NextプロジェクトIDの発行.
	 *
	 * @return int NextプロジェクトID
	 */
	private int nextval_projectId() {
		return jdbcManager.selectBySql(Integer.class, "select nextval('project_project_id_seq')").getSingleResult();
	}

}