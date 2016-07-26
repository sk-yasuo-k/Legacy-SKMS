package services.generalAffair.service;

import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import javax.persistence.OptimisticLockException;

import org.apache.commons.lang.time.DateUtils;
import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.ComplexWhere;
import org.seasar.extension.jdbc.where.SimpleWhere;
import org.seasar.framework.container.SingletonS2Container;
import org.seasar.framework.container.annotation.tiger.Binding;

import dto.LabelDto;

import enumerate.DepartmentId;
import enumerate.ProjectPositionId;
import enumerate.WorkStatusId;
import enumerate.WorkingHoursActionId;
import enumerate.WorkingHoursStatusId;

import services.generalAffair.dto.StaffWorkingHoursDto;
import services.generalAffair.dto.StaffWorkingHoursSearchDto;
import services.generalAffair.dxo.LabelDxo;
import services.generalAffair.dxo.StaffWorkingHoursDxo;
import services.generalAffair.entity.MAbsenceCode;
import services.generalAffair.entity.Holiday;
import services.generalAffair.entity.MHolidayWorkType;
import services.generalAffair.entity.MLateDeduction;
import services.generalAffair.entity.MRecessHours;
import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.MStaffDepartmentHead;
import services.generalAffair.entity.VCurrentStaffName;
import services.generalAffair.entity.StaffWorkingHours;
import services.generalAffair.entity.WorkingHoursDaily;
import services.generalAffair.entity.WorkingHoursHistory;
import services.generalAffair.entity.WorkingHoursMonthly;
import services.generalAffair.entity.MWorkingHoursStatus;
import services.mail.mai.MailWorkingHoursDto;
import services.mail.mai.SkmsMai;
import services.project.entity.Project;
import services.project.entity.ProjectMember;

/**
 * 勤務時間を扱うサービスです。
 *
 * @author yasuo-k
 *
 */
public class WorkingHoursService {

	/**
	 * JDBCマネージャです。
	 */
	@Binding("jdbcManagerA")
	public JdbcManager jdbcManager;

	/**
	 * La!cooda用のJDBCマネージャです。
	 */
	@Binding("jdbcManagerB")
	public JdbcManager jdbcManagerWiz;

	/**
	 * ラベルDxoです。
	 */
	public LabelDxo labelDxo;

	/**
	 * 社員別勤務管理Dxoです。
	 */
	public StaffWorkingHoursDxo staffWorkDxo;

	/**
	 * メール送信オブジェクトです。
	 */
    public SkmsMai skmsMai;

	/**
	 * 例外エラーを作成します。
	 *
	 * @param  func		関数名
	 * @return 		例外エラー
	 */
	protected static Exception createException(String func, String msg)
	{
		String message = "WorkingHoursServiceException." + func + " : ";
		if (msg != null)	message += "(" + msg + ")";
		return new Exception(message);
	}


	/**
	 * 検索条件 勤務管理表手続状態リストを返します。
	 *
	 * @return 勤務管理表手続状態のラベルリスト
	 */
	public List<LabelDto> getWorkingHoursStatusList() throws Exception
	{
		// データベースに問い合わせる。
		List<MWorkingHoursStatus> statuslist =
			jdbcManager.from(MWorkingHoursStatus.class)
				.orderBy("workingHoursStatusId")
				.getResultList();
		return labelDxo.convertStatus(statuslist);
	}

	/**
	 * 勤務管理表を取得します。
	 *
	 * @param  staffId			社員ID
	 * @param  workingMonthCode	勤務月コード
	 * @return 					勤務管理表
	 */
	public WorkingHoursMonthly getWorkingHoursMonthly(Integer staffId, String workingMonthCode)
	{
		// 勤務時間(月別)の取得
		WorkingHoursMonthly whm = jdbcManager
			.from(WorkingHoursMonthly.class)
			.innerJoin("staffName")
			.innerJoin("workingHoursDailies")
			.leftOuterJoin("workingHoursHistories")
			.leftOuterJoin("workingHoursHistories.workingHoursAction")
			.where(new SimpleWhere().eq("staffId", staffId).eq("workingMonthCode", workingMonthCode))
			.orderBy("workingHoursDailies.workingDate, workingHoursHistories.registrationTime desc")
			.getSingleResult();

		// レコード未生成ならば
		if (whm == null) {
			// 勤務時間(月別)の生成
			whm = createWorkingHoursMonthly(staffId, workingMonthCode);
		}

		// 休日一覧の取得
		List<Holiday> holidaies = this.getHolidayList(workingMonthCode);
		for (WorkingHoursDaily whd : whm.workingHoursDailies) {
			Calendar cal1 = Calendar.getInstance();
			// 時間以下を切り捨て
			cal1.setTime(DateUtils.truncate(whd.workingDate, Calendar.HOUR));

			// 休日かどうかの判定
			for (Holiday holiday : holidaies) {
				Calendar cal2 = Calendar.getInstance();
				// 時間以下を切り捨て
				cal2.setTime(DateUtils.truncate(holiday.hdate, Calendar.HOUR));

				if (cal1.compareTo(cal2) == 0) {
					whd.holidayName = holiday.hname;
					break;
				}
			}
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

		// 当月の勤務時間(月別)の取得
		WorkingHoursMonthly whm3 = jdbcManager
			.from(WorkingHoursMonthly.class)
			.where("staff_id = ?"
					+ " and working_month_code = ?"
					, staffId
					, workingMonthCode
			)
			.getSingleResult();

		if (whm3 != null) {
			whm.registrationVer = whm3.registrationVer;
			whm.givenCompensatoryDayOffCount = whm3.givenCompensatoryDayOffCount;
			whm.givenPaidVacationCount = whm3.givenPaidVacationCount;
			whm.givenSpecialVacationCount = whm3.givenSpecialVacationCount;
			whm.lostCompensatoryDayOffCount = whm3.lostCompensatoryDayOffCount;
			whm.lostPaidVacationCount = whm3.lostPaidVacationCount;
			whm.lostSpecialVacationCount = whm3.lostSpecialVacationCount;
		}

		return whm;
	}

	/**
	 * 勤務管理表を生成します。
	 *
	 * @param  staffId			社員ID
	 * @param  workingMonthCode	勤務月コード
	 * @return 					勤務管理表
	 */
	public WorkingHoursMonthly createWorkingHoursMonthly(int staffId, String workingMonthCode)
	{
		WorkingHoursMonthly whm = new WorkingHoursMonthly();
		whm.staffId = staffId;
		// StaffServiceオブジェクトの取得
		StaffService staffService = SingletonS2Container.getComponent(StaffService.class);
		whm.staffName = staffService.getStaffInfo(staffId).staffName;
		whm.workingMonthCode = workingMonthCode;
		whm.workingHoursDailies = new ArrayList<WorkingHoursDaily>();

		Integer year = Integer.parseInt(workingMonthCode.substring(0, 4));
		Integer month = Integer.parseInt(workingMonthCode.substring(4, 6)) - 1;

		Calendar fromCal = Calendar.getInstance();
		fromCal.set(year, month, 1, 0, 0, 0);
		Calendar toCal = Calendar.getInstance();
		toCal.set(year, month, fromCal.getActualMaximum(Calendar.DATE), 0, 0, 0);
		Calendar nowCal = Calendar.getInstance();
		nowCal = fromCal;
		while (nowCal.getTimeInMillis() <= toCal.getTimeInMillis()) {
			WorkingHoursDaily workingHoursDaily = new WorkingHoursDaily();
			workingHoursDaily.staffId = staffId;
			workingHoursDaily.workingMonthCode = workingMonthCode;
			workingHoursDaily.workingDate = nowCal.getTime();
			whm.workingHoursDailies.add(workingHoursDaily);
			nowCal.add(Calendar.DATE, 1);
		}

		return whm;
	}

	/**
	 * 現在の勤務管理表手続き状態を取得します。
	 *
	 * @param  loginStaff			ログインユーザ情報
	 * @param  workingMonthCode		勤務月コード
	 * @param  isSubordinateOnly	部下のみ
	 * @param  statusList			勤務管理表手続状態リスト
	 * @return 						現在の勤務管理表手続き状態
	 */
	public List<WorkingHoursHistory> getSubordinateCurrentWorkingHoursStatus(MStaff loginStaff,
			String workingMonthCode, Boolean isSubordinateOnly, List<Integer> statusList)
	{
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

		List<WorkingHoursHistory> whhList = new ArrayList<WorkingHoursHistory>();
		for (Integer staffId : staffIdList) {

			// 勤務管理表手続き状態の取得
			WorkingHoursHistory whh = getCurrentWorkingHoursStatus(staffId, workingMonthCode);

			// 未作成ならば
			if (whh == null) {
				whh = new WorkingHoursHistory();
				whh.staffId = staffId;
				whh.workingMonthCode = workingMonthCode;
				whh.staffName = jdbcManager.from(VCurrentStaffName.class)
									.where( new SimpleWhere()
										.eq("staffId", staffId)
										)
									.getSingleResult();
				whh.updateCount = 0;
				whh.workingHoursStatusId = WorkingHoursStatusId.NONE;
				whh.workingHoursStatus = jdbcManager.from(MWorkingHoursStatus.class)
											.where( new SimpleWhere()
												.eq("workingHoursStatusId", WorkingHoursStatusId.NONE)
											)
											.getSingleResult();
			} else {
				// 月間勤務時間情報を取得する

//				whh.workingHoursMonthly = jdbcManager.from(WorkingHoursMonthly.class)
//											.where( new SimpleWhere()
//												.eq("staffId", staffId)
//												.eq("workingMonthCode", workingMonthCode)
//											)
//											.getSingleResult();

			}
			for (Integer status : statusList) {
				if (status.equals(whh.workingHoursStatusId)) {
					whhList.add(whh);
					break;
				}
			}
		}
		return whhList;
	}

	/**
	 * 現在の勤務管理表手続き状態を取得します。
	 *
	 * @param  staffId			社員ID
	 * @param  workingMonthCode	勤務月コード
	 * @return 					現在の勤務管理表手続き状態
	 */
	public WorkingHoursHistory getCurrentWorkingHoursStatus(Integer staffId, String workingMonthCode)
	{

		// 勤務管理表手続き状態の取得
		WorkingHoursHistory whh = jdbcManager
			.from(WorkingHoursHistory.class)
			.innerJoin("staffName")
			.innerJoin("workingHoursStatus")
			.where("staffId = ?"
				+ " and workingMonthCode = ?"
				+ " and updateCount = "
				+ "(select max(update_count) from working_hours_history where staff_id = staffId and working_month_code = workingMonthCode)"
				, staffId, workingMonthCode)
			.getSingleResult();

		return whh;
	}

	/**
	 * 勤務管理表を作成します。
	 *
	 * @param  workingHoursMonthly	勤務管理表
	 */
	public void insertWorkingHoursMonthly(WorkingHoursMonthly workingHoursMonthly) throws Exception
	{
		// 勤務時間(月別)の取得
		WorkingHoursMonthly whm = jdbcManager
			.from(WorkingHoursMonthly.class)
			.where(
				new SimpleWhere()
				.eq("staffId", workingHoursMonthly.staffId)
				.eq("workingMonthCode", workingHoursMonthly.workingMonthCode)
			)
			.getSingleResult();

		if (whm == null) {
			// 勤務時間(月別)の挿入
			jdbcManager.insert(workingHoursMonthly).execute();
		}

		for (WorkingHoursDaily workingHoursDaily : workingHoursMonthly.workingHoursDailies) {
			// 勤務時間(日別)の取得
			WorkingHoursDaily wh = jdbcManager
			.from(WorkingHoursDaily.class)
			.where(
				new SimpleWhere()
				.eq("staffId", workingHoursMonthly.staffId)
				.eq("workingMonthCode", workingHoursMonthly.workingMonthCode)
				.eq("workingDate", workingHoursDaily.workingDate)
			)
			.getSingleResult();
			if (wh == null) {
				// 勤務時間(日別)の挿入
				jdbcManager.insert(workingHoursDaily).execute();
			}
		}

	}

	/**
	 * 勤務管理表を更新します。
	 *
	 * @param  workingHoursMonthly	勤務管理表
	 */
	public void updateWorkingHoursMonthly(WorkingHoursMonthly workingHoursMonthly) throws Exception
	{
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

		for (WorkingHoursDaily workingHoursDaily : workingHoursMonthly.workingHoursDailies) {
			// 勤務時間(日別)の取得
			WorkingHoursDaily wh = jdbcManager
			.from(WorkingHoursDaily.class)
			.where(
				new SimpleWhere()
				.eq("staffId", workingHoursMonthly.staffId)
				.eq("workingMonthCode", workingHoursMonthly.workingMonthCode)
				.eq("workingDate", workingHoursDaily.workingDate)
			)
			.getSingleResult();
			// レコードありならば
			if (wh != null) {
				// 勤務時間(日別)の更新
				jdbcManager.update(workingHoursDaily).execute();
			} else {
				// 勤務時間(日別)の挿入
				jdbcManager.insert(workingHoursDaily).execute();
			}
		}

		// 勤務時間提出履歴の取得
		WorkingHoursHistory wh = jdbcManager
		.from(WorkingHoursHistory.class)
		.where(
			new SimpleWhere()
			.eq("staffId", workingHoursMonthly.staffId)
			.eq("workingMonthCode", workingHoursMonthly.workingMonthCode)
			.eq("updateCount", 1)
			)
		.getSingleResult();
		// レコードなしならば
		if (wh == null) {
			// 勤務表手続き履歴の生成
			WorkingHoursHistory whh = new WorkingHoursHistory();
			whh.staffId = workingHoursMonthly.staffId;
			whh.workingMonthCode = workingHoursMonthly.workingMonthCode;
			whh.workingHoursStatusId = WorkingHoursStatusId.ENTERED;
			whh.workingHoursActionId = WorkingHoursActionId.ENTER;
			whh.updateCount = 1;
			whh.registrantId = workingHoursMonthly.registrantId;
			// 勤務表手続き履歴の挿入
			jdbcManager.insert(whh).execute();
		}

	}

	/**
	 * 勤務管理表を提出します。
	 *
	 * @param  registrant			登録者情報
	 * @param  workingHoursMonthly	勤務管理表
	 * @param  workingHoursHistory	勤務管理表手続履歴
	 */
	public boolean submitWorkingHours(MStaff registrant,
			WorkingHoursMonthly workingHoursMonthly,
			WorkingHoursHistory workingHoursHistory) throws Exception
	{
		try{
			// 勤務管理表を更新します。
			updateWorkingHoursMonthly(workingHoursMonthly);

			// 勤務管理表手続き履歴を追加します。
			insertWorkingHoursHistory(workingHoursMonthly, workingHoursHistory);

			// 勤務管理表提出時のメールを送信します。
			sendMailSubmitWorkingHours(workingHoursMonthly, workingHoursHistory.comment, "submitWorkingHours");
		}
		catch(OptimisticLockException exception){
			return false;
		}
		catch (Exception e) {
			throw e;
		}
		return true;
	}

	/**
	 * 勤務管理表の提出を取り消します。
	 *
	 * @param  registrant			登録者情報
	 * @param  workingHoursMonthly	勤務管理表
	 * @param  workingHoursHistory	勤務管理表手続履歴
	 */
	public boolean submitCancelWorkingHours(MStaff registrant,
			WorkingHoursMonthly workingHoursMonthly,
			WorkingHoursHistory workingHoursHistory) throws Exception
	{
		try{
			// 勤務管理表手続き履歴を追加します。
			insertWorkingHoursHistory(workingHoursMonthly, workingHoursHistory);

			// 勤務管理表提出取り消し時のメールを送信します。
			sendMailSubmitWorkingHours(workingHoursMonthly, workingHoursHistory.comment, "submitCancelWorkingHours");

		}
		catch(OptimisticLockException exception){
			return false;
		}
		catch (Exception e) {
			throw e;
		}
		return true;
	}

	/**
	 * 勤務管理表を承認します。
	 *
	 * @param  registrant			登録者情報
	 * @param  workingHoursMonthly	勤務管理表
	 * @param  workingHoursHistory	勤務管理表手続履歴
	 */
	public boolean approvalWorkingHours(MStaff registrant,
			WorkingHoursMonthly workingHoursMonthly,
			WorkingHoursHistory workingHoursHistory) throws Exception
	{
		try{
			// 勤務管理表手続き履歴を追加します。
			insertWorkingHoursHistory(workingHoursMonthly, workingHoursHistory);

			// 勤務管理表承認時のメールを送信します。
			sendMailApprovalWorkingHours(registrant, workingHoursHistory.workingHoursActionId,
					workingHoursMonthly, workingHoursHistory.comment, "approvalWorkingHours");
		}
		catch(OptimisticLockException exception){
			return false;
		}
		catch (Exception e) {
			throw e;
		}
		return true;
	}

	/**
	 * 勤務管理表の承認を取り消します。
	 *
	 * @param  registrant			登録者情報
	 * @param  workingHoursMonthly	勤務管理表
	 * @param  workingHoursHistory	勤務管理表手続履歴
	 */
	public boolean approvalCancelWorkingHours(MStaff registrant,
			WorkingHoursMonthly workingHoursMonthly,
			WorkingHoursHistory workingHoursHistory) throws Exception
	{
		try{
			// 勤務管理表手続き履歴を追加します。
			insertWorkingHoursHistory(workingHoursMonthly, workingHoursHistory);

			// 勤務管理表承認時のメールを送信します。
			sendMailApprovalWorkingHours(registrant, workingHoursHistory.workingHoursActionId,
					workingHoursMonthly, workingHoursHistory.comment, "approvalCancelWorkingHours");

		}
		catch(OptimisticLockException exception){
			return false;
		}
		catch (Exception e) {
			throw e;
		}
		return true;
	}

	/**
	 * 勤務管理表を差し戻します。
	 *
	 * @param  registrant			登録者情報
	 * @param  workingHoursMonthly	勤務管理表
	 * @param  workingHoursHistory	勤務管理表手続履歴
	 */
	public boolean approvalRejectWorkingHours(MStaff registrant,
			WorkingHoursMonthly workingHoursMonthly,
			WorkingHoursHistory workingHoursHistory) throws Exception
	{
		try{
			// 勤務管理表手続き履歴を追加します。
			insertWorkingHoursHistory(workingHoursMonthly, workingHoursHistory);

			// 勤務管理表承認時のメールを送信します。
			sendMailApprovalWorkingHours(registrant, workingHoursHistory.workingHoursActionId,
					workingHoursMonthly, workingHoursHistory.comment, "approvalRejectWorkingHours");

		}
		catch(OptimisticLockException exception){
			return false;
		}
		catch (Exception e) {
			throw e;
		}
		return true;
	}

	/**
	 * 勤務管理表手続き履歴を追加します。
	 *
	 * @param  workingHoursMonthly	勤務管理表
	 * @param  workingHoursHistory	勤務管理表手続履歴
	 */
	public void insertWorkingHoursHistory(WorkingHoursMonthly workingHoursMonthly,
			WorkingHoursHistory workingHoursHistory) throws Exception
	{
		if (workingHoursHistory == null) {
			workingHoursHistory = new WorkingHoursHistory();
			workingHoursHistory.staffId = workingHoursMonthly.staffId;
			workingHoursHistory.workingMonthCode = workingHoursMonthly.workingMonthCode;
			workingHoursHistory.workingHoursStatusId = WorkingHoursStatusId.ENTERED;
			workingHoursHistory.workingHoursActionId = WorkingHoursActionId.ENTER;
			workingHoursHistory.updateCount = 1;
			workingHoursHistory.registrantId = workingHoursMonthly.registrantId;
		} else {
			// 登録バージョンの更新
			// Seasar2 のバグ対応のため全体を更新するように変更
//			jdbcManager.update(workingHoursMonthly).includes("registrationVer").execute();
			jdbcManager.update(workingHoursMonthly).execute();
		}
		// 勤務表手続き履歴の挿入
		jdbcManager.insert(workingHoursHistory).execute();

	}

	/**
	 * プロジェクト役職を取得します。
	 *
	 * @param	staffId				社員ID
	 * @param	memberId			プロジェクトメンバーID
	 * @param	workingMonthCode	勤務月
	 * @return	プロジェクト役職
	 */
	public Integer getStaffProjectPositionId(int staffId, int memberId, String workingMonthCode)
	{
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
		
		return jdbcManager.selectBySql(Integer.class,
			"select min(pm2.project_position_id)"
			+ " from project_member pm1"
			+ " inner join project"
			+ " on pm1.project_id = project.project_id"
			+ " and project.delete_flg = false"
			+ " inner join project_member pm2"
			+ " on pm1.project_id = pm2.project_id"
			+ " and pm1.staff_id = ? and pm2.staff_id = ?"
			+ " and project.actual_start_date <= ?"
			+ " and (project.actual_finish_date is null or project.actual_finish_date >= ?)"
			+ " and pm1.actual_join_date <= ?"
			+ " and (pm1.actual_retire_date is null or pm1.actual_retire_date >= ?)"
			,
			memberId, staffId, endDate, startDate, endDate, startDate)
			.getSingleResult();
	}


	/**
	 * 休憩時間定義一覧を取得します。
	 *
	 * @return	休憩時間定義一覧
	 */
	public List<MRecessHours> getRecessHoursList()
	{
		return jdbcManager
			.from(MRecessHours.class)
			.orderBy("fromHours")
			.getResultList();
	}

	/**
	 * 遅刻控除定義一覧を取得します。
	 *
	 * @return	遅刻控除定義一覧
	 */
	public List<MLateDeduction> getLateDeductionList()
	{
		return jdbcManager
			.from(MLateDeduction.class)
			.orderBy("fromHours")
			.getResultList();
	}

	/**
	 * 勤休コード定義一覧を取得します。
	 *
	 * @return	勤休コード定義一覧
	 */
	public List<MAbsenceCode> getAbsenceCodeList()
	{
		List<MAbsenceCode> list =  jdbcManager
			.from(MAbsenceCode.class)
			.orderBy("dispOrder")
			.getResultList();

		for (MAbsenceCode abs  : list) {
			if (abs.absenceName == null) abs.absenceName = "";
		}

		return list;
	}

	/**
	 * 休日定義一覧を取得します。
	 *
	 * @return	休日定義一覧
	 */
	public List<Holiday> getHolidayList(String workingMonthCode)
	{
		return jdbcManagerWiz
			.from(Holiday.class)
			.where("to_char(hdate,'yyyymm') = ?", workingMonthCode)
			.getResultList();
	}

	/**
	 * 勤務管理表提出時のメール通知を行う。
	 *
	 * @param  workingHoursMonthly	勤務管理表情報
	 * @param  reason				理由(提出取り下げ時のみ使用)
	 * @param  methodName			メール送信メソッド名
	 */
	public void sendMailSubmitWorkingHours(WorkingHoursMonthly workingHoursMonthly, String reason, String methodName)  throws Exception
	{
		// メール送信メソッドの取得
		Method method = skmsMai.getClass().getMethod(methodName, MailWorkingHoursDto.class);
		// 交通費メール送信用DTO生成
		MailWorkingHoursDto dto = new MailWorkingHoursDto(workingHoursMonthly);
		// 理由のセット
		dto.setReason(reason);

		// 勤務月の年月データ取得
		Integer year = Integer.parseInt(workingHoursMonthly.workingMonthCode.substring(0, 4));
		Integer month = Integer.parseInt(workingHoursMonthly.workingMonthCode.substring(4, 6)) - 1;
		// 勤務月の開始日、最終日を取得する。
		Calendar startDate = Calendar.getInstance();
		startDate.set(year, month, 1, 0, 0, 0);
		Calendar endDate = Calendar.getInstance();
		endDate.set(year, month, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);

		// 提出者が当該月に所属したプロジェクトで、提出者より役職が高いメンバーを取得する。
		List<Integer> projectMemberList
			= jdbcManager.selectBySql(Integer.class,
				"select distinct pm.staff_id from project_member pm"
				+ " inner join (select * from project_member) as pm2"
				+ " on pm.project_id = pm2.project_id"
				+ " and pm2.staff_id = ?"
				+ " and pm2.actual_join_date <= ?"
				+ " and (pm2.actual_retire_date is null or pm2.actual_retire_date >= ?)"
				+ " and (pm.project_position_id < pm2.project_position_id"
				+ " or (pm.project_position_id is not null and pm2.project_position_id is null))"
				+ " inner join project p on pm.project_id = p.project_id"
				+ " and p.actual_start_date <= ?"
				+ " and (p.actual_finish_date is null or p.actual_finish_date >= ?)"
				, workingHoursMonthly.staffId
				, endDate
				, startDate
				, endDate
				, startDate)
			.getResultList();

		// 上司が存在するならば
		if (projectMemberList.size() > 0) {
			// 上司の情報取得
			List<MStaff> staffList = jdbcManager
				.from(MStaff.class)
				.innerJoin("staffName")
				.innerJoin("staffSetting")
				.where(new ComplexWhere().in("staffId", projectMemberList.toArray()))
				.getResultList();

			for (MStaff staff : staffList) {
				// 通知有りならば
				if (staff.staffSetting.sendMailWorkingHours) {
					// 勤務管理表提出時メール通知
					dto.setTo(staff.email);
					dto.setToName(staff.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
		}

	}

	/**
	 * 勤務管理表承認時のメール通知を行う。
	 *
	 * @param  registrant			登録者情報
	 * @param  workingHoursActionId	手続動作種別ID
	 * @param  workingHoursMonthly	勤務管理表情報
	 * @param  reason				理由(承認取り消し・差し戻し時のみ使用)
	 * @param  methodName			メール送信メソッド名
	 */
	public void sendMailApprovalWorkingHours(MStaff registrant, int workingHoursActionId,
			WorkingHoursMonthly workingHoursMonthly, String reason, String methodName)  throws Exception
	{
		// 社員サービスオブジェクトの取得
		StaffService staffService = SingletonS2Container.getComponent(StaffService.class);

		// メール送信メソッドの取得
		Method method = skmsMai.getClass().getMethod(methodName, MailWorkingHoursDto.class);
		// 交通費メール送信用DTO生成
		MailWorkingHoursDto dto = new MailWorkingHoursDto(workingHoursMonthly);
		// 理由のセット
		dto.setReason(reason);
		// 承認者のセット
		dto.setApprovalName(registrant.staffName.fullName);

		// 承認種別のセット
		switch (workingHoursActionId) {
			case WorkingHoursActionId.PM_APPROVAL:
			case WorkingHoursActionId.PM_APPROVAL_CANCEL:
			case WorkingHoursActionId.PM_APPROVAL_REJECT:
				dto.setApprovalType("PM");
				break;
			case WorkingHoursActionId.PL_APPROVAL:
			case WorkingHoursActionId.PL_APPROVAL_CANCEL:
			case WorkingHoursActionId.PL_APPROVAL_REJECT:
				dto.setApprovalType("PL");
				break;
			case WorkingHoursActionId.SL_APPROVAL:
			case WorkingHoursActionId.SL_APPROVAL_CANCEL:
			case WorkingHoursActionId.SL_APPROVAL_REJECT:
				dto.setApprovalType("SL");
				break;
			case WorkingHoursActionId.TN_APPROVAL:
			case WorkingHoursActionId.TN_APPROVAL_CANCEL:
			case WorkingHoursActionId.TN_APPROVAL_REJECT:
				dto.setApprovalType("トレーナ");
				break;
			case WorkingHoursActionId.GA_APPROVAL:
			case WorkingHoursActionId.GA_APPROVAL_CANCEL:
			case WorkingHoursActionId.GA_APPROVAL_REJECT:
				dto.setApprovalType("総務");
				break;
		}
		
		// 承認種別のセット
		switch (workingHoursActionId) {
			case WorkingHoursActionId.PL_APPROVAL:
			case WorkingHoursActionId.PL_APPROVAL_CANCEL:
			case WorkingHoursActionId.PL_APPROVAL_REJECT:
			case WorkingHoursActionId.SL_APPROVAL:
			case WorkingHoursActionId.SL_APPROVAL_CANCEL:
			case WorkingHoursActionId.SL_APPROVAL_REJECT:
			case WorkingHoursActionId.TN_APPROVAL:
			case WorkingHoursActionId.TN_APPROVAL_CANCEL:
			case WorkingHoursActionId.TN_APPROVAL_REJECT:
				// 勤務月の年月データ取得
				Integer year = Integer.parseInt(workingHoursMonthly.workingMonthCode.substring(0, 4));
				Integer month = Integer.parseInt(workingHoursMonthly.workingMonthCode.substring(4, 6)) - 1;
				// 勤務月の開始日、最終日を取得する。
				Calendar startDate = Calendar.getInstance();
				startDate.set(year, month, 1, 0, 0, 0);
				Calendar endDate = Calendar.getInstance();
				endDate.set(year, month, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);

				// 提出者が当該月に所属したプロジェクトで、承認者より役職が高いメンバーを取得する。
				List<Integer> projectMemberList
					= jdbcManager.selectBySql(Integer.class,
						"select distinct pm.staff_id from project_member pm"
						+ " inner join (select * from project_member) as pm2"
						+ " on pm.project_id = pm2.project_id"
						+ " and pm2.staff_id = ?"
						+ " and pm2.actual_join_date <= ?"
						+ " and (pm2.actual_retire_date is null or pm2.actual_retire_date >= ?)"
						+ " inner join (select * from project_member) as pm3"
						+ " on pm.project_id = pm3.project_id"
						+ " and pm3.staff_id = ?"
						+ " and (pm.project_position_id < pm3.project_position_id"
						+ " or (pm.project_position_id is not null and pm3.project_position_id is null))"
						+ " inner join project p on pm.project_id = p.project_id"
						+ " and p.actual_start_date <= ?"
						+ " and (p.actual_finish_date is null or p.actual_finish_date >= ?)"
						, workingHoursMonthly.staffId
						, endDate
						, startDate
						, registrant.staffId
						, endDate
						, startDate)
					.getResultList();

				// 上司が存在するならば
				if (projectMemberList.size() > 0) {
					// 上司の情報取得
					List<MStaff> staffList = jdbcManager
						.from(MStaff.class)
						.innerJoin("staffName")
						.innerJoin("staffSetting")
						.where(new SimpleWhere().in("staffId", projectMemberList.toArray()))
						.getResultList();

					for (MStaff staff : staffList) {
						// 通知有りならば
						if (Boolean.TRUE.equals(staff.staffSetting.sendMailWorkingHours)) {
							// 勤務管理表提出時メール通知
							dto.setTo(staff.email);
							dto.setToName(staff.staffName.fullName);
							method.invoke(skmsMai, dto);
						}
					}
				}
				break;
			case WorkingHoursActionId.PM_APPROVAL:
			case WorkingHoursActionId.PM_APPROVAL_CANCEL:
			case WorkingHoursActionId.PM_APPROVAL_REJECT:
				// 総務部長一覧の取得
				List<MStaff> accountingManagerList
					= staffService.getDepartmentHeadList(DepartmentId.GENERAL_AFFAIR);

				// 総務部長に対してメール通知
				for (MStaff accountingManager : accountingManagerList) {
					// メール通知有りならば
					if (accountingManager.staffSetting != null
						&& accountingManager.staffSetting.sendMailWorkingHours) {
						// 勤務管理表承認時メール通知
						dto.setTo(accountingManager.email);
						dto.setToName(accountingManager.staffName.fullName);
						method.invoke(skmsMai, dto);
					}
				}
				break;
		}

		// 提出者の社員情報取得
		MStaff applicant = staffService.getStaffInfo(workingHoursMonthly.staffId);

		// 提出者に対するメール送信
		if (applicant.staffSetting.sendMailWorkingHours) {
			// 交通費承認時メール通知
			dto.setTo(applicant.email);
			dto.setToName(applicant.staffName.fullName);
			method.invoke(skmsMai, dto);
		}

	}


	/**
	 * 勤務管理表の月別集計リストを返します.
	 *
	 * @param staff  ログイン社員情報.
	 * @param search 検索条件.
	 * @return 集計リスト.
	 */
	public List<StaffWorkingHoursDto> getWorkingHoursMonthlyList(MStaff staff, StaffWorkingHoursSearchDto search)  throws Exception
	{
		// 絞込条件を作成する
		ComplexWhere op_where = new ComplexWhere();
		// 集計期間.
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		op_where.ge("wh_.working_month_code", sdf.format(search.startDate))
				.le("wh_.working_month_code", sdf.format(search.finishtDate));
		// 氏名.
		op_where.and(new ComplexWhere().contains("s_.full_name", search.staffName)
									   .or()
									   .contains("s_.full_name_kana", search.staffName));

		// プロジェクト.
		String joinProject = "";
		String grpProject  = "";
		if (search.checkProjectSearch()) {
			op_where.contains("p_.project_code", search.projectCode)
					.contains("p_.project_name", search.projectName);
			joinProject = "  inner join project_member ps_ on s_.staff_id = ps_.staff_id" +
						  "  inner join project p_ on ps_.project_id = p_.project_id and p_.delete_flg = false";
			grpProject  = " group by s_.staff_id, s_.full_name, sw_.work_status_id, wh_.working_month_code, wh_.working_hours, wh_.real_working_hours";
		}
		// 集計期間に働いたかどうか.
		op_where.gt("wh_.working_hours", 0);

		List<StaffWorkingHours>	list =
					jdbcManager.selectBySql(StaffWorkingHours.class,
					"select s_.staff_id, s_.full_name, sw_.work_status_id, wh_.working_month_code, wh_.working_hours, wh_.real_working_hours" +
					" from v_current_staff_name s_" +
					"  inner join v_current_staff_work_status sw_ on s_.staff_id = sw_.staff_id" +
					"  inner join working_hours_monthly wh_ on s_.staff_id = wh_.staff_id" +
					joinProject +
					" where " + op_where.getCriteria() +
					grpProject +
					" order by s_.staff_id, wh_.working_month_code", op_where.getParams())
					.getResultList();

		return staffWorkDxo.convert(list);
	}
	
	/**
	 * 休日出勤タイプ一覧を取得します。
	 *
	 * @return	休日出勤タイプ一覧
	 */
	public List<MHolidayWorkType> getHolidayWorkTypeList()
	{
		List<MHolidayWorkType> list =  jdbcManager
			.from(MHolidayWorkType.class)
			.orderBy("dispOrder")
			.getResultList();

		for (MHolidayWorkType hol  : list) {
			if (hol.holidayWorkName == null) hol.holidayWorkName = "";
		}

		return list;
	}


}