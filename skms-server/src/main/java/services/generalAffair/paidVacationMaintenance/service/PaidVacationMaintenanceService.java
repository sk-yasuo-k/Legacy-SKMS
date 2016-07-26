package services.generalAffair.paidVacationMaintenance.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.ComplexWhere;
import org.seasar.extension.jdbc.where.SimpleWhere;
import org.seasar.framework.container.SingletonS2Container;

import enumerate.DepartmentId;
import enumerate.ProjectPositionId;
import enumerate.WorkStatusId;

import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.MStaffDepartmentHead;
import services.generalAffair.entity.WorkingHoursMonthly;
import services.generalAffair.service.WorkingHoursService;
import services.project.entity.Project;
import services.project.entity.ProjectMember;

public class PaidVacationMaintenanceService {

	public JdbcManager jdbcManager;

	
	/**
	 * 有給・代休メンテナンス一覧取得
	 * @return 有給・代休メンテナンス一覧
	 */
	public List<WorkingHoursMonthly> getWorkingStaffNameList(MStaff loginStaff, String workingMonthCode, Boolean isSubordinateOnly){

		List<Integer> staffIdList = staffIdList(loginStaff, workingMonthCode, isSubordinateOnly);
				
		WorkingHoursService workingHoursService = SingletonS2Container.getComponent(WorkingHoursService.class);

		List<WorkingHoursMonthly> result = new ArrayList<WorkingHoursMonthly>();
		
		for (Integer staffId : staffIdList) {
			// 勤務時間(月別)の取得
			WorkingHoursMonthly whm = jdbcManager
				.from(WorkingHoursMonthly.class)
				.innerJoin("staffName")
				.where(new SimpleWhere().eq("staffId", staffId).eq("workingMonthCode", workingMonthCode))
				.orderBy("staffId")
				.getSingleResult();			

			// レコード未生成ならば
			if (whm == null) {
				// 勤務時間(月別)の生成
				whm = workingHoursService.createWorkingHoursMonthly(staffId, workingMonthCode);
			}

			// 前月の勤務時間(月別)の取得
			WorkingHoursMonthly whm2 = jdbcManager
				.from(WorkingHoursMonthly.class)
				.where("staff_id = ?"
						+ " and working_month_code = "
						+ " (select max(working_month_code) from working_hours_monthly"
						+ " where staff_id = ? and working_month_code < ?)"
						, staffId
						, staffId
						, workingMonthCode
				)
				.getSingleResult();

			if (whm2 != null) {
				whm.lastCompensatoryDayOffCount = whm2.currentCompensatoryDayOffCount;
				whm.lastPaidVacationCount = whm2.currentPaidVacationCount;
				whm.lastSpecialVacationCount = whm2.currentSpecialVacationCount;
			}
			
			result.add(whm);
		}
		
		return result;
	}

	/**
	 * 表示対象の社員リスト取得
	 * @return 表示対象の社員リスト
	 */
	public List<Integer> staffIdList(MStaff loginStaff, String workingMonthCode, Boolean isSubordinateOnly){
		
		// 勤務月の年月データ取得
		Integer year = Integer.parseInt(workingMonthCode.substring(0, 4));
		Integer month = Integer.parseInt(workingMonthCode.substring(4, 6)) - 1;
		// 勤務月の開始日、最終日を取得する。
		Calendar startDate = Calendar.getInstance();
		startDate.set(year, month, 1, 0, 0, 0);
		startDate.set(Calendar.MILLISECOND, 0);
		Calendar endDate = Calendar.getInstance();
		endDate.set(year, month, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);
		endDate.set(Calendar.MILLISECOND, 0);

		// 表示対象の社員リスト
		List<Integer> staffIdList = new ArrayList<Integer>();

		Boolean isGeneralAffairDepartmentHead = false;

		// 総務部長かどうかの判定
		if (loginStaff.staffDepartmentHead != null
			&& loginStaff.staffDepartmentHead.size() > 0) {
			for (MStaffDepartmentHead staffDepartmentHead : loginStaff.staffDepartmentHead) {
				if (staffDepartmentHead.departmentId == DepartmentId.GENERAL_AFFAIR) {
					isGeneralAffairDepartmentHead = true;
					break;
				}
			}
		}

		// 総務部長または部下のみでなければ
		if (isGeneralAffairDepartmentHead || !isSubordinateOnly) {
			// 当月に在籍していた社員の一覧を取得
			List<MStaff> staffList = jdbcManager
				.from(MStaff.class)
				.where(   "(exists"
						+ "(select staff_id"
						+ " from staff_work_history swh1"
						+ " where swh1.update_count ="
						+ " (select max(swh2.update_count) from staff_work_history swh2"
						+ " where swh1.staff_id = swh2.staff_id"
						+ " and swh2.occured_date <= ?)"
						+ " and swh1.staff_id = staffId"
						+ " and swh1.work_status_id = ?"
						+ ")"
						+ "or exists"
						+ "(select staff_id"
						+ " from staff_work_history"
						+ " where staff_work_history.staff_id = staffId"
						+ " and occured_date >= ?"
						+ " and occured_date <= ?"
						+ " and work_status_id = ?"
						+ ")"
						+ ")"
						+ "and"
						+ " not exists"
						+ " (select staff_id"
						+ "  from m_staff_project_position"
						+ "  where staff_id = staffId"
						+ "  and project_position_id = ?"
						+ "  and apply_date <= ?"
						+ "  and (cancel_date is null or cancel_date >= ?)"
						+ " )"
						+ "and"
						+ " not exists"
						+ " (select staff_id"
						+ "  from m_staff_department_head"
						+ "  where staff_id = staffId"
						+ "  and apply_date <= ?"
						+ "  and (cancel_date is null or cancel_date >= ?)"
						+ " )"
						, startDate
						, WorkStatusId.WORKING
						, startDate
						, endDate
						, WorkStatusId.WORKING
						, ProjectPositionId.PM
						, startDate
						, endDate
						, startDate
						, endDate
					)
				.orderBy("staffId")
				.getResultList();

			for (MStaff staff : staffList) {
				staffIdList.add(staff.staffId);
			}

		} else {

			// 当該月に存在したプロジェクトでログインユーザがPM/PL/SL/TNのプロジェクト一覧を取得
			List<Project> projectList = jdbcManager
				.from(Project.class)
				.innerJoin("projectMembers")
				.where(new ComplexWhere()
					.eq("deleteFlg", false)
					.eq("projectMembers.staffId", loginStaff.staffId)
					.le("actualStartDate", endDate)
					.and(new ComplexWhere()
					.ge("actualFinishDate", startDate)
						.or()
						.isNull("actualFinishDate", true)
						)
					.le("projectMembers.actualJoinDate", endDate)
					.and(new ComplexWhere()
					.ge("projectMembers.actualRetireDate", startDate)
						.or()
						.isNull("projectMembers.actualRetireDate", true)
						)
					.and(new ComplexWhere()
						.eq("projectMembers.projectPositionId", ProjectPositionId.PM)
						.or()
						.eq("projectMembers.projectPositionId", ProjectPositionId.PL)
						.or()
						.eq("projectMembers.projectPositionId", ProjectPositionId.SL)
						.or()
						.eq("projectMembers.projectPositionId", ProjectPositionId.TN)
						)
					)
				.getResultList();

			for (Project project : projectList) {
				// 自分の部下の一覧を取得
				List<ProjectMember> projectMemberList = jdbcManager
					.from(ProjectMember.class)
					.where(new ComplexWhere()
						.eq("projectId", project.projectId)
						.and(new ComplexWhere()
							.isNull("projectPositionId", true)
							.or()
							.gt("projectPositionId", project.projectMembers.get(0).projectPositionId)
						)
					.and(new SimpleWhere().le("actualJoinDate", endDate))
					.and(new ComplexWhere()
					.ge("actualRetireDate", startDate)
						.or()
						.isNull("actualRetireDate", true)
						)
					)
					.orderBy("staffId")
					.getResultList();
				for (ProjectMember projectMember : projectMemberList) {
					Boolean redundancy = false;
					for (Integer staffId : staffIdList) {
						if (staffId.equals(projectMember.staffId)) {
							redundancy = true;
							break;
						}
					}
					if (!redundancy) staffIdList.add(projectMember.staffId);
				}
			}
		}		
		return staffIdList;
	}
	
	/**
	 * 有給・代休メンテナンス一覧保存
	 * 
	 */
	public void storageWorkingHoursMonthly(List<WorkingHoursMonthly> workingHoursMonthlyList){
		
		for ( int i = 0; i < workingHoursMonthlyList.size(); i++ ){
			WorkingHoursMonthly workingHoursMonthly = workingHoursMonthlyList.get(i);

			// 勤務時間(月別)の取得
			WorkingHoursMonthly whm = jdbcManager
				.from(WorkingHoursMonthly.class)
				.where(
					new SimpleWhere()
					.eq("staffId", workingHoursMonthly.staffId)
					.eq("workingMonthCode", workingHoursMonthly.workingMonthCode)
				)
				.getSingleResult();

			if (whm != null) {
				// 勤務時間(月別)の更新
				jdbcManager.update(workingHoursMonthly).execute();
			} else {
				// 勤務時間(月別)の挿入
				jdbcManager.insert(workingHoursMonthly).execute();
			}
		}
	}
}
