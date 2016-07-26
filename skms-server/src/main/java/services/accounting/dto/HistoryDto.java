package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;

import enumerate.TransportationStatusId;

import services.accounting.entity.Transportation;
import services.accounting.entity.TransportationHistory;
import services.generalAffair.entity.MStaff;


/**
 * 交通費申請履歴情報です.
 *
 * @author yasuo-k
 *
 */
public class HistoryDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * (entity)交通費申請IDです.
	 */
	public int transportationId;

	/**
	 * (entity)更新回数です.
	 */
	public int updateCount;

	/**
	 * (entity)交通費申請状況IDです.
	 */
	public int transportationStatusId;

	/**
	 * (entity)登録日時です.	 */
	public Date registrationTime;

	/**
	 * (entity)登録者IDです.
	 */
	public int registrantId;

	/**
	 * (entity)コメントです.
	 */
	public String comment;

	/** 申請の履歴コメント 新規作成 */
	public static final String COMMENT_MAKED       = "作成";
	/** 申請の履歴コメント 申請 */
	public static final String COMMENT_APPLIED     = "申請";
	/** 申請の履歴コメント PL承認済 */
	public static final String COMMENT_APPROVED_PL = "PL承認";
	/** 申請の履歴コメント PM承認済 */
	public static final String COMMENT_APPROVED_PM = "PM承認";
	/** 申請の履歴コメント 経理承認済 */
	public static final String COMMENT_APPROVED_AF = "経理承認";
	/** 申請の履歴コメント 支払済 */
	public static final String COMMENT_PAID        = "支払";
	/** 申請の履歴コメント 受領済 */
	public static final String COMMENT_ACCEPTED    = "受領";
	/** 申請の履歴コメント 取り下げ */
	public static final String COMMENT_PRE_WITHDRAW = "取り下げ";
	/** 申請の履歴コメント 取り消し */
	public static final String COMMENT_PRE_CANCEL   = "取り消し";
	/** 申請の履歴コメント 差し戻し */
	public static final String COMMENT_PRE_BACK     = "差し戻し";
	/** 申請の履歴コメントリスト */
	public static final String[] COMMENT_LIST = {	"",				 		// 0
													COMMENT_MAKED,			// 1
													COMMENT_APPLIED,		// 2
													COMMENT_APPROVED_PL,	// 3
													COMMENT_APPROVED_PM,	// 4
													COMMENT_APPROVED_AF,	// 5
													COMMENT_PAID,			// 6
													COMMENT_ACCEPTED		// 7
												};

	/**
	 * コンストラクタ
	 */
	public HistoryDto() {
	}

	/**
	 * コンストラクタ Transportationを設定.
	 */
	public HistoryDto(Transportation trans)
	{
		this.transportationId = trans.transportationId;
		this.registrantId     = trans.registrantId;
		this.registrationTime = trans.registrationTime;
	}

	/**
	 * コンストラクタ TransportationHistoryを設定.
	 */
	public HistoryDto(TransportationHistory history)
	{
		this.transportationId       = history.transportationId;
		this.updateCount            = history.updateCount;
		this.transportationStatusId = history.transportationStatusId;
		this.registrantId           = history.registrantId;
		this.registrationTime       = history.registrationTime;
		this.comment                = history.comment;
	}



	/**
	 * 新規作成IDの取得.
	 */
	public static int getStatus_make()
	{
		return TransportationStatusId.ENTERED;
	}
	/**
	 * 新規作成コメントの取得.
	 */
	public static String getComment_make()
	{
		return COMMENT_LIST[TransportationStatusId.ENTERED];
	}



	/**
	 * 申請IDの取得.
	 */
	public static int getStatus_apply()
	{
		return TransportationStatusId.APPLIED;
	}
	/**
	 * 申請コメントの取得.
	 */
	public static String getComment_apply()
	{
		return COMMENT_LIST[TransportationStatusId.APPLIED];
	}



	/**
	 * 申請取り下げIDの取得.
	 */
	public static int getStatus_applyWithdraw()
	{
		return TransportationStatusId.ENTERED;
	}
	/**
	 * 申請取り下げコメントの取得.
	 */
	public static String getComment_applyWithdraw(String reason)
	{
		String preComment = COMMENT_LIST[TransportationStatusId.APPLIED] + HistoryDto.COMMENT_PRE_WITHDRAW;
		preComment += " : " + reason;
		return preComment;
	}



	/**
	 * 承認IDの取得.
	 */
	public static int getStatus_approval(TransportationDto trans)
	{
		String statusId = getData_approval("statusId", trans);
		return Integer.parseInt(statusId);
	}
	/**
	 * 承認コメントの取得.
	 */
	public static String getComment_approval(TransportationDto trans, MStaff staff)
	{
		String comment = getData_approval("comment", trans);
		comment += getApplicant(staff);
		return comment;
	}
	/**
	 * 承認データの取得.
	 *
	 * @param mode  取得モード.
	 */
	private static String getData_approval(String mode, TransportationDto trans)
	{
		int statusId = TransportationStatusId.APPROVED_PM;
		// PL承認可能のとき,
		if (trans.isEnabledApprovalPL) {
			statusId = TransportationStatusId.APPROVED_PL;
		}
		// PM承認可能のとき,
		else if (trans.isEnabledApprovalPM) {
			statusId = TransportationStatusId.APPROVED_PM;
		}
		// AF承認可能のとき,
		else if (trans.isEnabledApprovalAF) {
			statusId = TransportationStatusId.APPROVED_AF;
		}

		// モードに応じた値を返す,
		if (mode.equals("statusId")) {
			return Integer.toString(statusId);
		}
		else if (mode.equals("comment")) {
			return COMMENT_LIST[statusId];
		}
		else {
			return null;
		}
	}



	/**
	 * 承認取り消しIDの取得.
	 */
	public static int getStatus_approvalCancel(TransportationDto trans)
	{
		String statusId = getData_approvalCancel("statusId", trans);
		return Integer.parseInt(statusId);
	}
	/**
	 * 承認取り消しコメントの取得.
	 */
	public static String getComment_approvalCancel(TransportationDto trans, String reason, MStaff staff)
	{
		String preComment = getData_approvalCancel("preComment", trans);
		preComment += getApplicant(staff) + " : " + reason;
		return preComment;
	}
	/**
	 * 承認取り消しデータの取得.
	 */
	private static String getData_approvalCancel(String mode, TransportationDto trans)
	{
		int statusId = TransportationStatusId.APPLIED;
		String preComment = "承認取り消し";

		if (trans.transportationHistorys != null && trans.transportationHistorys.size() > 0)
		{
			// 現在の承認状態を取得する.
			HistoryDto nowHistory = trans.transportationHistorys.get(0);
			preComment = COMMENT_LIST[nowHistory.transportationStatusId] + HistoryDto.COMMENT_PRE_CANCEL;

			// 承認前の状態を取得する.
			for (int i = 1; i < trans.transportationHistorys.size(); i++) {
				HistoryDto history = trans.transportationHistorys.get(i);
				if (nowHistory.transportationStatusId != history.transportationStatusId &&
					(history.transportationStatusId == TransportationStatusId.APPROVED_PM ||
					 history.transportationStatusId == TransportationStatusId.APPROVED_PL ||
					 history.transportationStatusId == TransportationStatusId.APPLIED     )  ){
					statusId   = history.transportationStatusId;
					break;
				}
			}
		}

		// モードに応じた値を返す.
		if (mode.equals("statusId")) {
			return Integer.toString(statusId);
		}
		else if (mode.equals("preComment")) {
			return preComment;
		}
		else {
			return null;
		}
	}



	/**
	 * 承認取り下げIDの取得.	 */
	public static int getStatus_approvalWithdraw()
	{
		return TransportationStatusId.REJECTED;
	}
	/**
	 * 承認取り下げコメントの取得.
	 */
	public static String getComment_approvalWithdraw(String reason, MStaff staff)
	{
		String comment = HistoryDto.COMMENT_PRE_BACK;
		comment += getApplicant(staff) + " : " + reason;
		return  comment;
	}


	/**
	 * 支払IDの取得.
	 */
	public static int getStatus_payment()
	{
		return TransportationStatusId.PAID;
	}
	/**
	 * 支払コメントの取得.
	 */
	public static String getComment_payment(MStaff staff)
	{
		String comment = COMMENT_LIST[TransportationStatusId.PAID];
		comment += getApplicant(staff);
		return comment;
	}



	/**
	 * 支払取り消しIDの取得.
	 */
	public static int getStatus_paymentCancel()
	{
		return TransportationStatusId.APPROVED_AF;
	}
	/**
	 * 支払取り消しコメントの取得.
	 */
	public static String getComment_paymentCancel(String reason, MStaff staff)
	{
		String preComment = COMMENT_LIST[TransportationStatusId.PAID] + HistoryDto.COMMENT_PRE_CANCEL;
		preComment += getApplicant(staff) + " : " + reason;
		return  preComment;
	}



	/**
	 * 受領IDの取得.
	 */
	public static int getStatus_accept()
	{
		return TransportationStatusId.ACCEPTED;
	}
	/**
	 * 受領コメントの取得.
	 */
	public static String getComment_accept()
	{
		return COMMENT_LIST[TransportationStatusId.ACCEPTED];
	}



	/**
	 * 受領取り消しIDの取得.
	 */
	public static int getStatus_acceptCancel()
	{
		return TransportationStatusId.PAID;
	}
	/**
	 * 受領取り消しコメントの取得.
	 */
	public static String getComment_acceptCancel(String reason)
	{
		String preComment = COMMENT_LIST[TransportationStatusId.ACCEPTED] + HistoryDto.COMMENT_PRE_CANCEL;
		preComment += " : " + reason;
		return preComment;
	}


	/**
	 * 申請者名の取得.
	 *
	 */
	private static String getApplicant(MStaff staff)
	{
		String name = "";
		if (staff != null && staff.staffName != null) {
			String staffName = staff.staffName.fullName;
//			String staffName = staff.staffName.lastName;
			name += "(" + staffName +")";
		}
		return name;
	}

}