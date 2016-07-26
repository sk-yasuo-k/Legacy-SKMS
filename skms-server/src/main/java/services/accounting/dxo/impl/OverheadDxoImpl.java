package services.accounting.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;

import enumerate.OverheadNextActionId;
import enumerate.OverheadStatusId;

import services.accounting.dto.OverheadDetailDto;
import services.accounting.dto.OverheadDto;
import services.accounting.dxo.EquipmentDxo;
import services.accounting.dxo.OverheadDxo;
import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadDetail;
import services.accounting.entity.OverheadHistory;
import services.generalAffair.entity.MStaff;


/**
 * 諸経費申請情報変換Dxo実装クラスです.
 *
 * @author yasuo-k
 *
 */
public class OverheadDxoImpl implements OverheadDxo {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * 設備Dxoです.
	 */
	public EquipmentDxo equipmentDxo;


	/**
	 * 諸経費申請情報エンティティから諸経費申請情報Dtoへ変換.
	 *
	 * @param src 諸経費申請情報エンティティ.
	 * @param staff 社員情報.
	 * @param 諸経費申請情報Dto.
	 */
	public OverheadDto convert(Overhead src, MStaff staff)
	{
		OverheadDto dst = new OverheadDto();
		dst.overheadId = src.overheadId;
		dst.registrantId = src.registrantId;
		dst.registrationTime = src.registrationTime;
		dst.registrationVer  = src.registrationVer;

		// プロジェクト情報を設定する.
		dst.projectId  = src.projectId;
		if (src.projectE != null) {
			dst.projectCode = src.projectE.projectCode;
			dst.projectName = src.projectE.projectName;
		}

		// 申請者情報を設定する.
		dst.staffId    = src.staffId;
		if (src.staff != null && src.staff.staffName != null) {
			dst.staffName = src.staff.staffName.fullName;
		}

		// 手続き情報を設定する.
		dst.overheadHistorys = src.overheadHistorys;
		dst.overheadNextActions = new ArrayList<Integer>();
		for (OverheadHistory history : src.overheadHistorys) {
			dst.overheadStatusId = history.overheadStatusId;
			if (history.overheadStatus != null) {
				dst.overheadStatusName = history.overheadStatus.overheadStatusName;
			}

			switch (history.overheadStatusId) {
			// 作成・差し戻し中 → 変更 or 申請 or 削除.
			case OverheadStatusId.REJECTED:
			case OverheadStatusId.ENTERED:
				dst.overheadNextActions.add(OverheadNextActionId.UPDATE);
				dst.overheadNextActions.add(OverheadNextActionId.DELETE);
				if (src.overheadDetails != null && src.overheadDetails.size() > 0) {
					dst.overheadNextActions.add(OverheadNextActionId.APPLY);
				}
				break;

			// 申請 → 申請取り下げ or xx承認 or xx承認取り下げ.
			case OverheadStatusId.APPLIED:
				dst.overheadNextActions.add(OverheadNextActionId.APPLY_CANCEL);
				dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_PM);
				dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_REJECT_PM);
				dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_GA);
				dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_REJECT_GA);
				break;

			// PM承認 → PM承認取り消し or 総務承認 or 総務承認取り下げ.
			case OverheadStatusId.APPROVED_PM:
				// 自分が承認していたら取り消し可能とする.
				if (isCurrentStatusMyAction(src.overheadHistorys, staff, OverheadStatusId.APPROVED_PM, "PM承認")) {
					dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_CANCEL_PM);
				}
				dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_GA);
				dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_REJECT_GA);
				break;

			// 総務承認 → 支払 or 総務承認取り消し.
			case OverheadStatusId.APPROVED_GA:
				dst.overheadNextActions.add(OverheadNextActionId.PAY);
				dst.overheadNextActions.add(OverheadNextActionId.APPROVAL_CANCEL_GA);
				break;

			// 支払 → 受領 or 支払取り消し.
			case OverheadStatusId.PAID:
				// 自分が支払っていたら取り消し可能とする.
				if (isCurrentStatusMyAction(src.overheadHistorys, staff, OverheadStatusId.PAID, "支払")) {
					dst.overheadNextActions.add(OverheadNextActionId.PAY_CANCEL);
				}
				dst.overheadNextActions.add(OverheadNextActionId.ACCEPT);
				break;

			// 受領 → 受領取り消し.
			case OverheadStatusId.ACCEPTED:
				dst.overheadNextActions.add(OverheadNextActionId.ACCEPT_CANCEL);
				break;
			}

			// 複製は常にＯＫとする.
			dst.overheadNextActions.add(OverheadNextActionId.COPY);

			// 最新の手続き状態のみ確認する.
			break;
		}


		// 明細情報を設定する.
		dst.overheadDetails = new ArrayList<OverheadDetailDto>();
		for (OverheadDetail detail : src.overheadDetails) {
			OverheadDetailDto dto = new OverheadDetailDto();
			dto.overheadId = detail.overheadId;
			dto.overheadNo = detail.overheadNo;
			dto.registrantId = detail.registrantId;
			dto.registrationTime = detail.registrationTime;
			dto.registrationVer  = detail.registrationVer;

			dto.overheadDate = detail.overheadDate;						// 日付.
			if (detail.overheadTypeId != null) {
				dto.overheadTypeId = detail.overheadTypeId;				// 諸経費区分.
				dto.overheadTypeName = detail.type.overheadTypeName;
			}
			dto.content  = detail.content;								// 内訳.
			dto.contentA = detail.contentA;
			dto.contentB = detail.contentB;
			dto.contentC = detail.contentC;
			if (detail.accountItemId != null) {
				dto.accountItemId = detail.accountItemId;				// 勘定科目.
				dto.accountItemName = detail.account.accountItemName;
			}

			if (detail.paymentId != null) {
				dto.paymentId  = detail.paymentId;						// 支払方法.
				dto.paymentName = detail.payment.paymentName;
			}
			if (detail.paymentCreditCard != null) {
				dto.paymentInfo = detail.paymentCreditCardNo;
			}
			if (detail.expense != null) {								// 金額.
				dto.expense = detail.expense.toString();
			}
			dto.receiptNo = detail.receiptNo;							// 領収書No.
			dto.note      = detail.note;								// 備考.
			dto.equipment = equipmentDxo.convert(detail.equipment);		// 設備情報.

			// 明細情報を追加する.
			dst.overheadDetails.add(dto);
		}

		return dst;
	}

	/**
	 * 諸経費申請情報Dtoから諸経費申請情報エンティティへ変換.<br>
	 *
	 * @param src   諸経費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return 諸経費申請情報エンティティ
	 */
	public Overhead convertCreate(OverheadDto src, MStaff staff)
	{
		Overhead dst = new Overhead();
		dst.overheadId   = nextval_serialId();
		dst.projectId    = src.projectId;
		dst.staffId      = staff.staffId;
		dst.registrantId = staff.staffId;
		return dst;
	}

	/**
	 * 諸経費申請情報Dtoから諸経費申請情報エンティティへ変換.<br>
	 *
	 * @param src 諸経費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 諸経費申請情報エンティティ
	 */
	public Overhead convertUpdate(OverheadDto src, MStaff staff)
	{
		Overhead dst = new Overhead();
		dst.overheadId   = src.overheadId;
		dst.projectId    = src.projectId;
		dst.staffId      = src.staffId;
		dst.registrantId = staff.staffId;
		dst.registrationVer = src.registrationVer;
		return dst;
	}

	/**
	 * 諸経費申請情報Dtoから諸経費申請情報エンティティへ変換.<br>
	 *
	 * @param src 諸経費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 諸経費申請情報エンティティ
	 */
	public Overhead convertWithdraw(OverheadDto src, MStaff staff)
	{
		Overhead dst = convertUpdate(src, staff);
		// 申請状況履歴を設定する.
		dst.overheadHistorys = src.overheadHistorys;
		return dst;
	}




	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryMake(Overhead src)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= 1;
		dst.overheadStatusId = OverheadStatusId.ENTERED;
		dst.comment      = "作成";
		dst.registrantId = src.registrantId;
		return dst;
	}


	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApply(Overhead src)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.APPLIED;
		dst.comment      = "申請";
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param staff 社員情報.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApproval(Overhead src, MStaff staff)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.APPROVED_PM;
		dst.comment      = "PM承認" + "(" + staff.staffName.fullName +")";
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param staff 社員情報.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApprovalAf(Overhead src, MStaff staff)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.APPROVED_GA;
		dst.comment      = "総務承認" + "(" + staff.staffName.fullName +")";
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param staff 社員情報.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryPayment(Overhead src, MStaff staff)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.PAID;
		dst.comment      = "支払" + "(" + staff.staffName.fullName +")";
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryAccept(Overhead src)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.ACCEPTED;
		dst.comment      = "受領";
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApplyWithdraw(Overhead src, String reason)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.ENTERED;
		dst.comment      = "申請取り下げ" + " : " + reason;
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApprovalCancel(Overhead src, String reason, MStaff staff)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		int current = currentApproval(src.overheadHistorys);
		if (current == OverheadStatusId.APPROVED_PM) {
			dst.comment = "PM承認取り消し" + "(" + staff.staffName.fullName +")" + " : " + reason;
		}
		else if (current == OverheadStatusId.APPROVED_GA) {
			dst.comment = "総務承認取り消し" + "(" + staff.staffName.fullName +")" + " : " + reason;
		}
		dst.overheadStatusId = previousApproval(src.overheadHistorys);
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApprovalWithdraw(Overhead src, String reason, MStaff staff)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.REJECTED;
		dst.comment      = "差し戻し" + "(" + staff.staffName.fullName +")" + " : " + reason;
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryPaymentCancel(Overhead src, String reason, MStaff staff)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.APPROVED_GA;
		dst.comment      = "支払取り消し" + "(" + staff.staffName.fullName +")" + " : " + reason;
		dst.registrantId = src.registrantId;
		return dst;
	}

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryAcceptCancel(Overhead src, String reason, MStaff staff)
	{
		OverheadHistory dst = new OverheadHistory();
		dst.overheadId = src.overheadId;
		dst.updateCount= nextval_updateCount(dst.overheadId);
		dst.overheadStatusId = OverheadStatusId.PAID;
		dst.comment      = "受領取り消し" + " : " + reason;
		dst.registrantId = src.registrantId;
		return dst;
	}


	/**
	 * 現在の承認状態の取得.
	 *
	 * @param historys 履歴.
	 * @return 承認状態.
	 */
	private int currentApproval(List<OverheadHistory> historys)
	{
		for (OverheadHistory history : historys) {
			return history.overheadStatusId;
		}
		return -99;
	}

	/**
	 * 1つ前の承認状態の取得.
	 *
	 * @param historys 履歴.
	 * @return 承認状態.
	 */
	private int previousApproval(List<OverheadHistory> historys)
	{
		// 承認前の状態を定義する.
		ArrayList<Integer> previouslist = new ArrayList<Integer>();
		int current = currentApproval(historys);
		if (current == OverheadStatusId.APPROVED_PM) {
			previouslist.add(OverheadStatusId.APPLIED);
		}
		else if (current == OverheadStatusId.APPROVED_GA) {
			previouslist.add(OverheadStatusId.APPLIED);
			previouslist.add(OverheadStatusId.APPROVED_PM);
		}

		// 1つ前の承認状態を取得する.
		for (int index = 0; index < historys.size(); index++) {
			if (index == 0) 	continue;
			OverheadHistory history = historys.get(index);
			for (Integer status : previouslist) {
				if (status.equals(history.overheadStatusId)) {
					return history.overheadStatusId;
				}
			}
		}
		return -99;
	}

	/**
	 * 現在の申請状態が自操作によるものかどうか確認.
	 *
	 * @param historys 履歴.
	 * @param staff    操作者.
	 * @param current  申請状態.
	 * @param currentSts 申請状態名.
	 * @return 確認結果.
	 */
	private boolean isCurrentStatusMyAction(List<OverheadHistory> historys, MStaff staff, int current, String currentSts)
	{
		String checkStr = "取り消し";
		int index = 0;
		for (OverheadHistory history : historys) {
			// 最新が取り消しでないならば自操作かどうか確認する.
			if (index == 0) {
				if (history.comment.indexOf(checkStr) < 0) {
					if (history.registrantId == staff.staffId)	return true;
					else										return false;
				}
				index++;
				continue;
			}

			// 最新履歴が取り消しならば現申請状態が自操作によるものかどうか確認する.
			String searchStr = currentSts + "(";
			if (history.comment.indexOf(searchStr) == 0) {
				if (history.registrantId == staff.staffId)	return true;
				else										return false;
			}
			index++;
		}
		return false;
	}

//	/**
//	 * 指定の最新履歴状態の取得.
//	 *
//	 * @param historys 履歴.
//	 * @param status 指定履歴.
//	 * @return 履歴.
//	 */
//	private OverheadHistory searchHistory(List<OverheadHistory> historys, List<Integer> status)
//	{
//	}

	/**
	 * Next諸経費申請IDの発行.
	 *
	 * @return int Next諸経費申請ID
	 */
	private int nextval_serialId()
	{
		return jdbcManager.selectBySql(Integer.class, "select nextval('overhead_overhead_id_seq')").getSingleResult();
	}

	/**
	 * Next諸経費申請履歴IDの発行.
	 *
	 * @return int Next諸経費申請履歴ID
	 */
	private int nextval_updateCount(int serialId)
	{
		String maxSql = "select max(update_count) from overhead_history where overhead_id =" + serialId;
		Integer currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		return currval == null ? 1 : currval + 1;
	}
}