package services.accounting.dxo;

import services.accounting.dto.TransportationDto;
import services.accounting.entity.Transportation;
import services.accounting.entity.TransportationHistory;
import services.generalAffair.entity.MStaff;


/**
 * 交通費申請履歴情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface TransportationHistoryDxo {

	/**
	 * 交通費申請情報エンティティから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src 交通費申請情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertMake(Transportation src);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src   交通費申請情報Dto
	 * @param staff 社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApply(TransportationDto src, MStaff staff);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApplyWithdraw(TransportationDto src, MStaff staff, String reason);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src   交通費申請情報Dto
	 * @param staff 社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApproval(TransportationDto src, MStaff staff);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApprovalCancel(TransportationDto src, MStaff staff, String reason);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertApprovalWithdraw(TransportationDto src, MStaff staff, String reason);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertPayment(TransportationDto src, MStaff staff);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertPaymentCancel(TransportationDto src, MStaff staff, String reason);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertAccept(TransportationDto src, MStaff staff);

	/**
	 * 交通費申請情報Dtoから交通費申請履歴情報へ変換.<br>
	 *
	 * @param src    交通費申請情報Dto
	 * @param staff  社員情報エンティティ
	 * @param reason 理由
	 * @return TransportationHistory 交通費申請履歴情報
	 */
	public TransportationHistory convertAcceptCancel(TransportationDto src, MStaff staff, String reason);

}
