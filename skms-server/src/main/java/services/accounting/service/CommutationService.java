package services.accounting.service;


import java.lang.reflect.Method;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.persistence.OptimisticLockException;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.ComplexWhere;
import org.seasar.extension.jdbc.where.SimpleWhere;
import org.seasar.framework.beans.util.Beans;
import org.seasar.framework.container.SingletonS2Container;
import org.seasar.framework.container.annotation.tiger.Binding;

import dto.LabelDto;
import enumerate.WorkStatusId;
import enumerate.DepartmentId;
import enumerate.ProjectPositionId;
import enumerate.CommutationActionId;
import enumerate.CommutationStatusId;
import enumerate.StaffAddressStatusId;
import enumerate.WorkingHoursActionId;


import services.accounting.entity.Commutation;
import services.accounting.entity.CommutationDetail;
import services.accounting.entity.CommutationItem;
import services.accounting.entity.CommutationHistory;
import services.accounting.entity.MCommutationStatus;
import services.accounting.dto.CommutationSummaryDto;
import services.accounting.dxo.LabelDxo;


import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.MStaffDepartmentHead;
import services.generalAffair.entity.VCurrentStaffName;
import services.generalAffair.service.StaffService;
import services.generalAffair.service.WorkingHoursService;
import services.generalAffair.address.entity.VStaffAddressMoveDate;


import services.mail.mai.MailCommutationDto;
import services.mail.mai.SkmsMai;
import services.project.entity.Project;
import services.project.entity.ProjectMember;
import services.system.entity.StaffSetting;
import services.system.service.SystemService;

/**
 * 通勤費を扱うサービスです.
 *
 * @author yasuo-k
 *
 */

public class CommutationService {

	
	/**
	 * JDBCマネージャです。
	 */
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
		String message = "CommutationServiceException." + func + " : ";
		if (msg != null)	message += "(" + msg + ")";
		return new Exception(message);
	}
	
	/**
	 * 検索条件 通勤費手続状態リストを返します。
	 *
	 * @return 通勤費手続状態のラベルリスト
	 */
	public List<LabelDto> getCommutationStatusList() throws Exception
	{
		// データベースに問い合わせる。
		List<MCommutationStatus> statuslist =
			jdbcManager.from(MCommutationStatus.class)
				.orderBy("commutationStatusId")
				.getResultList();
		return labelDxo.convertCommutationStatus(statuslist);
	}
	
	
	
	
	
	/**
	 * 通勤費情報を取得します。
	 *
	 * @param  staffId					社員ID
	 * @param  commutationMonthCode		勤務月コード
	 * @return 						通勤費情報
	 */
	public Commutation getCommutation(Integer staffId, String commutationMonthCode)
	{
		Commutation comm = jdbcManager
		.from(Commutation.class)
		.innerJoin("commutationDetails")
		.leftOuterJoin("commutationDetails.commutationItems")
		.leftOuterJoin("commutationHistories")
		.leftOuterJoin("commutationHistories.commutationAction")
		.where(new SimpleWhere().eq("staffId", staffId).eq("commutationMonthCode", commutationMonthCode))
		.orderBy("commutationDetails.commutationStartDate, commutationDetails.commutationItems.itemNo, commutationHistories.registrationTime desc")
		.getSingleResult();

		
		// レコード未生成ならば
		if (comm == null) {
			// 通勤費レコードの生成
			comm = createCommutation(staffId, commutationMonthCode);
		}
		return comm;
	}
	
	/**
	 * 複製する通勤費情報を取得します。
	 *
	 * @param  staffId						社員ID
	 * @param  	commutationMonthCode		複製先の勤務月コード
	 * @param  lastCommutationMonthCode		複製元の勤務月コード
	 * @return 							通勤費情報
	 */
	public Commutation getCommutationCopy(Integer staffId, 
											String commutationMonthCode, 
											String lastCommutationMonthCode)
	{
		// 通勤開始日が最終の通勤情報を取得
		Commutation lastComm = jdbcManager
		.from(Commutation.class)
		.innerJoin("commutationDetails")
		.leftOuterJoin("commutationDetails.commutationItems")
		.where("staffId = ?"
			+ " and commutationMonthCode = ?"
			+ " and commutationDetails.commutationStartDate = "
			+ "(select max(commutation_start_date) from commutation_detail " +
					"where staff_id = staffId and commutation_month_code = ?)"
			, staffId, lastCommutationMonthCode,lastCommutationMonthCode)
		.orderBy("commutationDetails.commutationStartDate, commutationDetails.commutationItems.itemNo")
		.getSingleResult();
		
		// レコード未生成ならば
		if (lastComm == null) {
			// 通勤費レコードの生成
			lastComm = createCommutation(staffId, commutationMonthCode);
		}
		else{
			Integer totalExpenseVal = 0;
			
			// 勤務月コードを当月とする.
			lastComm.commutationMonthCode = commutationMonthCode;
			
			// 最新のバージョン番号を取得する.
			Commutation comm = getCommutation(staffId,commutationMonthCode);
			lastComm.registrationVer = comm.registrationVer;
			
			// 通勤費詳細情報を編集する.
			for (CommutationDetail cd : lastComm.commutationDetails){
				cd.commutationMonthCode = commutationMonthCode;
				cd.detailNo = 1;
				
				// 前月の通勤開始日+1か月とする
//				Calendar cal = Calendar.getInstance();
//				cal.setTime(cd.commutationStartDate);
//				cal.add(Calendar.MONTH, 1);
//				cd.commutationStartDate = cal.getTime();
				
				try
				{
					DateFormat dfm = new SimpleDateFormat("yyyyMMdd");
					cd.commutationStartDate = dfm.parse(commutationMonthCode+"01");
				}
		        catch(ParseException e){
		        }
		        
				// 金額を取得する
				for (CommutationItem ci : cd.commutationItems){
					totalExpenseVal += ci.expense;
				}
			}
			// 金額を編集する.
			lastComm.expenseTotal = totalExpenseVal;
			lastComm.repayment = 0;
			lastComm.payment = totalExpenseVal;
			
		}
		
		
		// 今月の履歴を取得する.
		List<CommutationHistory> cmhList = jdbcManager
			.from(CommutationHistory.class)
			.leftOuterJoin("commutationAction")
			.where(new SimpleWhere()
			 .eq("staffId", staffId)
			 .eq("commutationMonthCode", commutationMonthCode)
			)
			.orderBy("registrationTime desc")
			.getResultList();
		
		// レコード未生成ならば
		if (cmhList == null) {
			lastComm.commutationHistories = null;
		}
		else{
			lastComm.commutationHistories = cmhList ;
		}
		return lastComm;
	}

	/**
	 * 通勤費情報を生成します。
	 *
	 * @param  staffId				社員ID
	 * @param  commutationMonthCode	勤務月コード
	 * @return 					通勤費情報
	 */
	private Commutation createCommutation(int staffId, String commutationMonthCode)
	{
		Commutation comm = new Commutation();
		comm.staffId = staffId;
		comm.commutationMonthCode = commutationMonthCode;
		comm.commutationDetails = new ArrayList<CommutationDetail>();
		
		Integer year = Integer.parseInt(commutationMonthCode.substring(0, 4));
		Integer month = Integer.parseInt(commutationMonthCode.substring(4, 6)) - 1;
		Calendar cal = Calendar.getInstance();
		cal.set(year, month, 1, 0, 0, 0);
		
		CommutationDetail cd = new CommutationDetail();
		cd.staffId = staffId;
		cd.commutationMonthCode = commutationMonthCode;
		cd.detailNo = 1;
		cd.commutationStartDate = cal.getTime();
		comm.commutationDetails.add(cd);

		return comm;
	}	
	
	
	/**
	 * 現在の勤務管理表手続き状態を取得します。
	 *
	 * @param  loginStaff				ログインユーザ情報
	 * @param  commutationMonthCode		通勤月コード
	 * @param  isSubordinateOnly		部下のみ
	 * @param  statusList				通勤費手続状態リスト
	 * @return 						現在の通勤費手続き状態
	 */
	public List<CommutationSummaryDto> getSubordinateCurrentCommutationStatus(MStaff loginStaff,
			String commutationMonthCode, Boolean isSubordinateOnly, List<Integer> statusList)
	{

		// 勤務月の年月データ取得
		Integer year = Integer.parseInt(commutationMonthCode.substring(0, 4));
		Integer month = Integer.parseInt(commutationMonthCode.substring(4, 6)) - 1;

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
						, startDate
						, WorkStatusId.WORKING
						, startDate
						, endDate
						, WorkStatusId.WORKING
					)
				.orderBy("staffId")
				.getResultList();

			for (MStaff staff : staffList) {
				staffIdList.add(staff.staffId);
			}
		
		} else {

			// 当該月に存在したプロジェクトでログインユーザがPM/PLのプロジェクト一覧を取得
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

		List<CommutationSummaryDto> cmhList = new ArrayList<CommutationSummaryDto>();
		for (Integer staffId : staffIdList) {

			// 当月通勤費状態の取得
			CommutationSummaryDto cmh = getCurrentCommutationStatus(staffId, commutationMonthCode);

			// 勤務月の開始日、最終日を取得する。
			Calendar lastMonth = Calendar.getInstance();
			lastMonth.set(year, month, 1, 0, 0, 0);
			lastMonth.add(Calendar.MONTH, -1);

			String lastMonthCode = String.format("%04d%02d", lastMonth.get(Calendar.YEAR), lastMonth.get(Calendar.MONTH) + 1);

			// 前月通勤費状態の取得
			CommutationSummaryDto lcmh = getCurrentCommutationStatus(staffId, lastMonthCode);

			// 未作成ならば
			if (cmh == null) {
				cmh = new CommutationSummaryDto();
				cmh.staffId = staffId;
				cmh.commutationMonthCode = commutationMonthCode;
				VCurrentStaffName staffName = jdbcManager.from(VCurrentStaffName.class)
									.where( new SimpleWhere()
										.eq("staffId", staffId)
										)
									.getSingleResult();
				cmh.fullName = staffName.fullName;
				cmh.updateCount = 0;
				cmh.commutationStatusId = CommutationStatusId.NONE;
				MCommutationStatus commutationStatus = jdbcManager.from(MCommutationStatus.class)
											.where( new SimpleWhere()
												.eq("commutationStatusId", CommutationStatusId.NONE)
											)
											.getSingleResult();
				cmh.commutationStatusName = commutationStatus.commutationStatusName;
				cmh.commutationStatusColor = commutationStatus.commutationStatusColor;
			}
			for (Integer status : statusList) {
				if (status.equals(cmh.commutationStatusId)) {
					if (lcmh != null) {
						cmh.lastPayment = lcmh.payment;
						if (!cmh.lastPayment.equals(cmh.payment)) {
							cmh.paymentColor = 16058376;
						}
					}
					cmhList.add(cmh);
					break;
				}
			}
		}
		return cmhList;		
		
		
	}
	
	/**
	 * 現在の通勤費手続き状態を取得します。
	 *
	 * @param  staffId					社員ID
	 * @param  commutationMonthCode		通勤月コード
	 * @return 						現在の通勤費手続き状態
	 */
	public CommutationSummaryDto getCurrentCommutationStatus(Integer staffId, String commutationMonthCode)
	{

		// 勤務管理表手続き状態の取得
		CommutationHistory cmh = jdbcManager
			.from(CommutationHistory.class)
			.innerJoin("staffName")
			.innerJoin("commutation")
			.innerJoin("commutationStatus")
			.where("staffId = ?"
				+ " and commutationMonthCode = ?"
				+ " and updateCount = "
				+ "(select max(update_count) from commutation_history where staff_id = staffId and commutation_month_code = commutationMonthCode)"
				, staffId, commutationMonthCode)
			.getSingleResult();

		if (cmh != null) {
			CommutationSummaryDto dto = new CommutationSummaryDto();
			Beans.copy(cmh, dto).execute();
			dto.fullName = cmh.staffName.fullName;
			dto.commutationStatusName = cmh.commutationStatus.commutationStatusName;
			dto.commutationStatusColor = cmh.commutationStatus.commutationStatusColor;
			if (cmh.commutationAction != null) {
				dto.commutationActionName = cmh.commutationAction.commutationActionName;
			}
			if (cmh.commutation != null) {
				dto.payment = cmh.commutation.payment;
			}
	
			return dto;
		} else {
			return null;
		}
	}
	
	/**
	 * 通勤費を作成します。
	 *
	 * @param  commutation	通勤費情報
	 */
	public void insertCommutation(Commutation commutation) throws Exception
	{
		// 通勤費の挿入
		jdbcManager.insert(commutation).execute();
		int i = 1;
		for (CommutationDetail commutationDetail : commutation.commutationDetails){
			// 通勤費詳細の挿入
			commutationDetail.detailNo = i;
			jdbcManager.insert(commutationDetail).execute();
			i++;
			int j = 1;
			for (CommutationItem commutationItem : commutationDetail.commutationItems){
				// 通勤費項目の挿入
				commutationItem.staffId = commutation.staffId;
				commutationItem.commutationMonthCode = commutation.commutationMonthCode;
				commutationItem.detailNo = commutationDetail.detailNo;
				commutationItem.itemNo = j;
				jdbcManager.insert(commutationItem).execute();
				j++;
			}
		}
	}
	
	/**
	 * 通勤費を更新します。
	 *
	 * @param  commutation	通勤費情報
	 */
	public void updateCommutation(Commutation commutation) throws Exception
	{
		// 通勤費情報の取得
		Commutation com = jdbcManager
			.from(Commutation.class)
			.where(
					new SimpleWhere()
					.eq("staffId", commutation.staffId)
					.eq("commutationMonthCode", commutation.commutationMonthCode)
				)
				.getSingleResult();
		
		if (com != null) {
			// 通勤費の更新
			jdbcManager.update(commutation).execute();
			
			// 通勤費詳細の削除
			List<CommutationDetail> cdList = jdbcManager
			.from(CommutationDetail.class)
			.where(
			new SimpleWhere()
			.eq("staffId", commutation.staffId)
			.eq("commutationMonthCode", commutation.commutationMonthCode)
			)
			.getResultList();
			if (cdList != null) {
				for (CommutationDetail cd : cdList) {
					if (cd.detailNo > 0) {
						jdbcManager.delete(cd).execute();
					}
				}
			}
		} else {
			// 通勤費の挿入
			jdbcManager.insert(commutation).execute();
		}
		
		int i = 1;
		for (CommutationDetail commutationDetail : commutation.commutationDetails){
			// 通勤費詳細の挿入
			commutationDetail.detailNo = i;
			jdbcManager.insert(commutationDetail).execute();
			i++;

			int j = 1;
			for (CommutationItem commutationItem : commutationDetail.commutationItems){
				// 通勤費項目の挿入
				commutationItem.staffId = commutation.staffId;
				commutationItem.commutationMonthCode = commutation.commutationMonthCode;
				commutationItem.detailNo = commutationDetail.detailNo;
				commutationItem.itemNo = j;
				jdbcManager.insert(commutationItem).execute();
				j++;
			}
		}

		// 通勤費履歴の取得
		CommutationHistory ch  = jdbcManager
		.from(CommutationHistory.class)
		.where(
			new SimpleWhere()
			.eq("staffId", commutation.staffId)
			.eq("commutationMonthCode", commutation.commutationMonthCode)
			.eq("updateCount", 1)
			)
		.getSingleResult();
		// レコードなしならば
		if (ch == null) {
			// 通勤費手続き履歴の生成
			CommutationHistory cmh = new CommutationHistory();
			cmh.updateCount = 1;
			cmh.staffId = commutation.staffId;
			cmh.commutationMonthCode = commutation.commutationMonthCode;
			cmh.commutationStatusId = CommutationStatusId.ENTERED;
			cmh.commutationActionId = CommutationActionId.ENTER;
			cmh.registrantId = commutation.registrantId;
			// 通勤費手続き履歴の挿入
			jdbcManager.insert(cmh).execute();
		}			
	}

	
	
	/**
	 * 	通勤費を申請します。
	 *
	 * @param  commutation			通勤費情報
	 * @param  commutationHistory	通勤費手続履歴
	 */
	public boolean applyCommutation(
			Commutation commutation,
			CommutationHistory commutationHistory) throws Exception
	{
		try{
			// 通勤費を更新します。
			updateCommutation(commutation);

			// 通勤費手続き履歴を追加します。
			insertCommutationHistory(commutation, commutationHistory);

			// 通勤費申請時のメールを送信します。
			sendMailApplyCommutation(commutation, commutationHistory.comment, "applyCommutation");
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
	 * 通勤費の申請を取り消します。
	 *
	 * @param  commutation			通勤費情報
	 * @param  commutationHistory	通勤費手続履歴
	 */
	public boolean applyCancelCommutation(
			Commutation commutation,
			CommutationHistory commutationHistory) throws Exception
	{
		try{
			// 通勤費手続き履歴を追加します。
			insertCommutationHistory(commutation, commutationHistory);

			// 通勤費申請時のメールを送信します。
			sendMailApplyCommutation(commutation, commutationHistory.comment, "applyCancelCommutation");
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
	 * 通勤費を承認します。
	 *
	 * @param  registrant			登録者情報
	 * @param  commutation			通勤費情報
	 * @param  commutationHistory	通勤費手続履歴
	 */
	public boolean approvalCommutation(MStaff registrant,
			Commutation commutation,
			CommutationHistory commutationHistory) throws Exception
	{
		try{
			// 通勤費を更新します。
			jdbcManager.update(commutation).execute();
			
			// 通勤費手続き履歴を追加します。
			insertCommutationHistory(commutation, commutationHistory);

			// 通勤費承認時のメールを送信します。
			sendMailApprovalCommutation(registrant, commutationHistory.commutationActionId,
				commutation, commutationHistory.comment, "approvalCommutation");
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
	 * 通勤費の承認を取り消します。
	 *
	 * @param  registrant			登録者情報
	 * @param  commutation			通勤費情報
	 * @param  commutationHistory	通勤費手続履歴
	 */
	public boolean approvalCancelCommutation(MStaff registrant,
			Commutation commutation,
			CommutationHistory commutationHistory) throws Exception
	{
		try{
			// 通勤費手続き履歴を追加します。
			insertCommutationHistory(commutation, commutationHistory);

			// 通勤費承認時のメールを送信します。
			sendMailApprovalCommutation(registrant, commutationHistory.commutationActionId,
				commutation, commutationHistory.comment, "approvalCancelCommutation");

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
	 * 通勤費を差し戻します。
	 *
	 * @param  registrant			登録者情報
	 * @param  commutation			通勤費情報
	 * @param  commutationHistory	通勤費手続履歴
	 */
	public boolean approvalRejectCommutation(MStaff registrant,
			Commutation commutation,
			CommutationHistory commutationHistory) throws Exception
	{
		try{
			// 通勤費手続き履歴を追加します。
			insertCommutationHistory(commutation, commutationHistory);

			// 通勤費承認時のメールを送信します。
			sendMailApprovalCommutation(registrant, commutationHistory.commutationActionId,
				commutation, commutationHistory.comment, "approvalRejectCommutation");

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
	 * 通勤費手続き履歴を追加します。
	 *
	 * @param  commutation			通勤費情報
	 * @param  commutationHistory	通勤費手続履歴
	 */
	public void insertCommutationHistory(Commutation commutation,
			CommutationHistory commutationHistory) throws Exception
	{
		if (commutationHistory == null) {
			commutationHistory = new CommutationHistory();
			commutationHistory.staffId = commutation.staffId;
			commutationHistory.commutationMonthCode = commutation.commutationMonthCode;
			commutationHistory.commutationStatusId = CommutationStatusId.ENTERED;
			commutationHistory.commutationActionId = CommutationActionId.ENTER;
			commutationHistory.updateCount = 1;
			commutationHistory.registrantId = commutation.registrantId;
		} else {
			
			// 登録バージョンの更新
			// Seasar2 のバグ対応
//			jdbcManager.update(commutation).includes("registrationVer").execute();
			jdbcManager.update(commutation).excludes(
					"staffId","commutationMonthCode","registrantId",
					"expenseTotal","repayment","payment",
					"note","noteCharge"
					).execute();
		}
		// 通勤費手続き履歴の挿入
		jdbcManager.insert(commutationHistory).execute();
	}	
	
	/**
	 * プロジェクト役職を取得します。
	 *
	 * @param	staffId				社員ID
	 * @param	memberId			プロジェクトメンバーID
	 * @param	workingMonthCode	勤務月
	 * @return	プロジェクト役職
	 */
	public Integer getStaffProjectPositionId(int staffId, int memberId, String commutationMonthCode) throws Exception
	{
		// WorkingHoursServiceオブジェクトの取得
		WorkingHoursService workingHoursService = SingletonS2Container.getComponent(WorkingHoursService.class);
		return workingHoursService.getStaffProjectPositionId(staffId,memberId,commutationMonthCode);
	}
	
	
	/**
	 * 住所リストを返します.
	 *
	 * @return 住所リスト.
	 */
	public List<VStaffAddressMoveDate> getStaffAddressList(int staffId) throws Exception
	{
		// データベースに問い合わせる.
		List<VStaffAddressMoveDate> addressList = jdbcManager
			.from(VStaffAddressMoveDate.class)
			.where(new SimpleWhere()
			 .eq("staffId", staffId)
			 .eq("addressStatusId", StaffAddressStatusId.GA_APPROVED)
			)
			.getResultList();
		return addressList;
	}	
	
	/**
	 * 通勤費申請時のメール通知を行う。
	 *
	 * @param  commutation			通勤費情報
	 * @param  reason				理由(提出取り下げ時のみ使用)
	 * @param  methodName			メール送信メソッド名
	 */
	public void sendMailApplyCommutation(Commutation commutation, String reason, String methodName)  throws Exception
	{

		// メール送信メソッドの取得
		Method method = skmsMai.getClass().getMethod(methodName, MailCommutationDto.class);
		// 通勤費メール送信用DTO生成
		MailCommutationDto dto = new MailCommutationDto(commutation);
		// 理由のセット
		dto.setReason(reason);

		// 通勤月の年月データ取得
		Integer year = Integer.parseInt(commutation.commutationMonthCode.substring(0, 4));
		Integer month = Integer.parseInt(commutation.commutationMonthCode.substring(4, 6)) - 1;
		// 通勤月の開始日、最終日を取得する。
		Calendar startDate = Calendar.getInstance();
		startDate.set(year, month, 1, 0, 0, 0);
		Calendar endDate = Calendar.getInstance();
		endDate.set(year, month, startDate.getActualMaximum(Calendar.DATE), 0, 0, 0);

		// 提出者が当該月に所属したプロジェクトで、提出者より役職が高いメンバー(PM)を取得する。
		List<Integer> projectMemberList
			= jdbcManager.selectBySql(Integer.class,
				"select distinct pm.staff_id from project_member pm"
				+ " inner join (select * from project_member) as pm2"
				+ " on pm.project_id = pm2.project_id"
				+ " and pm2.staff_id = ?"
				+ " and pm2.actual_join_date <= ?"
				+ " and (pm2.actual_retire_date is null or pm2.actual_retire_date >= ?)"
				+ " and pm.project_position_id = ?"
				+ " and (pm.project_position_id < pm2.project_position_id"
				+ " or (pm.project_position_id is not null and pm2.project_position_id is null))"
				+ " inner join project p on pm.project_id = p.project_id"
				+ " and p.actual_start_date <= ?"
				+ " and (p.actual_finish_date is null or p.actual_finish_date >= ?)"
				+ " and p.delete_flg = false"
				, commutation.staffId
				, endDate
				, startDate
				, ProjectPositionId.PM
				, endDate
				, startDate)
			.getResultList();

		// PMが存在するならば
		if (projectMemberList.size() > 0) {
			// PMの情報取得
			List<MStaff> staffList = jdbcManager
				.from(MStaff.class)
				.innerJoin("staffName")
				.innerJoin("staffSetting")
				.where(new ComplexWhere().in("staffId", projectMemberList.toArray()))
				.getResultList();

			for (MStaff staff : staffList) {
				// 通知有りならば
				if (staff.staffSetting.sendMailTransportation) {
					// 通勤費申請時メール通知
					dto.setTo(staff.email);
					dto.setToName(staff.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
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
	 * 通勤費承認時のメール通知を行う。
	 *
	 * @param  registrant			登録者情報
	 * @param  commutationActionId	手続動作種別ID
	 * @param  commutation			通勤費情報
	 * @param  reason				理由(承認取り消し・差し戻し時のみ使用)
	 * @param  methodName			メール送信メソッド名
	 */
	public void sendMailApprovalCommutation(MStaff registrant, int commutationActionId,
			Commutation commutation, String reason, String methodName)  throws Exception
	{
		// 社員サービスオブジェクトの取得
		StaffService staffService = SingletonS2Container.getComponent(StaffService.class);

		// メール送信メソッドの取得
		Method method = skmsMai.getClass().getMethod(methodName, MailCommutationDto.class);
		// 通勤費メール送信用DTO生成
		MailCommutationDto dto = new MailCommutationDto(commutation);
		// 理由のセット
		dto.setReason(reason);
		// 承認者のセット
		dto.setApprovalName(registrant.staffName.fullName);
		// 承認種別のセット
		switch (commutationActionId) {
			case CommutationActionId.PM_APPROVAL:
			case CommutationActionId.PM_APPROVAL_CANCEL:
			case CommutationActionId.PM_APPROVAL_REJECT:
				dto.setApprovalType("PM");
				break;
			case CommutationActionId.GA_APPROVAL:
			case CommutationActionId.GA_APPROVAL_CANCEL:
			case CommutationActionId.GA_APPROVAL_REJECT:
				dto.setApprovalType("経理");
				break;
		}
		
		// 承認種別のセット
		switch (commutationActionId) {
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
						&& accountingManager.staffSetting.sendMailTransportation) {
						// 通勤費承認時メール通知
						dto.setTo(accountingManager.email);
						dto.setToName(accountingManager.staffName.fullName);
						method.invoke(skmsMai, dto);
					}
				}
				break;
		}

		// 申請者の環境設定取得
		SystemService systemService = SingletonS2Container.getComponent( SystemService.class );
		StaffSetting staffSetting = systemService.getStaffSetting(commutation.staffId);

		// 申請者の社員情報取得
		MStaff applicant = staffService.getStaffInfo(commutation.staffId);

		// 申請者に対するメール送信
		if (Boolean.TRUE.equals(staffSetting.sendMailTransportation)) {
			// 通勤費承認時メール通知
			dto.setTo(applicant.email);
			dto.setToName(applicant.staffName.fullName);
			method.invoke(skmsMai, dto);
		}
	}

}
