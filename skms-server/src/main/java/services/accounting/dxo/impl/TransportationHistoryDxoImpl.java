package services.accounting.dxo.impl;

import org.seasar.extension.jdbc.JdbcManager;

import services.accounting.dto.HistoryDto;
import services.accounting.dto.TransportationDto;
import services.accounting.dxo.TransportationHistoryDxo;
import services.accounting.entity.Transportation;
import services.accounting.entity.TransportationHistory;
import services.generalAffair.entity.MStaff;


/**
 * 交通費申請履歴情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class TransportationHistoryDxoImpl implements TransportationHistoryDxo {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * 更新回数の初期値
	 */
	public static final int INIT_UPDATECOUNT = 1;



	/**
	 * 交通費申請情報エンティティから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src 交通費申請情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertMake(Transportation src)
	{
		TransportationHistory dst  = convert(src);
		dst.transportationStatusId = HistoryDto.getStatus_make();
		dst.comment                = HistoryDto.getComment_make();
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src   交通費申請情報Dto
	 * @param staff 社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApply(TransportationDto src, MStaff staff)
	{
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_apply();
		dst.comment                = HistoryDto.getComment_apply();
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApplyWithdraw(TransportationDto src, MStaff staff, String reason)
	{
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_applyWithdraw();
		dst.comment                = HistoryDto.getComment_applyWithdraw(reason);
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src   交通費申請情報Dto
	 * @param staff 承認社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApproval(TransportationDto src, MStaff staff)
	{
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_approval(src);
		dst.comment                = HistoryDto.getComment_approval(src, staff);
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApprovalCancel(TransportationDto src, MStaff staff, String reason)
	{
		// XX承認済み、支払済み→申請済み、XX承認済み
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_approvalCancel(src);
		dst.comment                = HistoryDto.getComment_approvalCancel(src, reason, staff);
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApprovalWithdraw(TransportationDto src, MStaff staff, String reason)
	{
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_approvalWithdraw();
		dst.comment                = HistoryDto.getComment_approvalWithdraw(reason, staff);
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertPayment(TransportationDto src, MStaff staff)
	{
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_payment();
		dst.comment                = HistoryDto.getComment_payment(staff);
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertPaymentCancel(TransportationDto src, MStaff staff, String reason)
	{
		// 支払済み→AF承認済み
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_paymentCancel();
		dst.comment                = HistoryDto.getComment_paymentCancel(reason, staff);
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertAccept(TransportationDto src, MStaff staff)
	{
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_accept();
		dst.comment                = HistoryDto.getComment_accept();
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertAcceptCancel(TransportationDto src, MStaff staff, String reason)
	{
		// 受領済み→支払済み
		TransportationHistory dst  = convert(src, staff);
		dst.transportationStatusId = HistoryDto.getStatus_acceptCancel();
		dst.comment                = HistoryDto.getComment_acceptCancel(reason);
		return dst;
	}

	/**
	 * 交通費申請情報エンティティから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src 交通費申請情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	private TransportationHistory convert(Transportation src)
	{
		TransportationHistory dst = new TransportationHistory(src);
		dst.updateCount = nextval_updateCount(dst.transportationId);
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	private TransportationHistory convert(TransportationDto src, MStaff staff)
	{
		TransportationHistory dst = new TransportationHistory(src, staff);
		dst.updateCount = nextval_updateCount(dst.transportationId);
		return dst;
	}

	/**
	 * Next交通費申請履歴連番の発行.
	 *
	 * @param  transId 交通費申請ID
	 * @return int Next交通費申請履歴連番
	 */
	private int nextval_updateCount(int transId)
	{
		// 交通費申請履歴連番のレコード数を取得する。
		long cnt = jdbcManager.from(TransportationHistory.class).where("transportation_id = ?", transId).getCount();
		if (cnt == 0)		return INIT_UPDATECOUNT;

		// 採番済みの交通費申請履歴連番を取得する。
		String maxSql = "select max(update_count) from transportation_history where transportation_id =" + transId;
		int currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		return (currval + 1);
	}
}
