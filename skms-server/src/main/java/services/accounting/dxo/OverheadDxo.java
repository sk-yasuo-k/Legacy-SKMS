package services.accounting.dxo;

import services.accounting.dto.OverheadDto;
import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadHistory;
import services.generalAffair.entity.MStaff;


/**
 * 諸経費申請情報変換Dxoです.
 *
 * @author yasuo-k
 *
 */
public interface OverheadDxo {

	/**
	 * 諸経費申請情報エンティティから諸経費申請情報Dtoへ変換.
	 *
	 * @param src 諸経費申請情報エンティティ
	 * @param staff 社員情報.
	 * @param 諸経費申請情報Dto
	 */
	public OverheadDto convert(Overhead src, MStaff staff);

	/**
	 * 諸経費申請情報Dtoから諸経費申請情報エンティティへ変換.<br>
	 *
	 * @param src   諸経費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return 諸経費申請情報エンティティ
	 */
	public Overhead convertCreate(OverheadDto src, MStaff staff);

	/**
	 * 諸経費申請情報Dtoから諸経費申請情報エンティティへ変換.<br>
	 *
	 * @param src 諸経費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 諸経費申請情報エンティティ
	 */
	public Overhead convertUpdate(OverheadDto src, MStaff staff);

	/**
	 * 諸経費申請情報Dtoから諸経費申請情報エンティティへ変換.<br>
	 *
	 * @param src 諸経費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 諸経費申請情報エンティティ
	 */
	public Overhead convertWithdraw(OverheadDto src, MStaff staff);



	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryMake(Overhead src);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApply(Overhead src);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param staff 社員情報.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApproval(Overhead src, MStaff staff);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param staff 社員情報.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApprovalAf(Overhead src, MStaff staff);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param staff 社員情報.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryPayment(Overhead src, MStaff staff);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryAccept(Overhead src);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApplyWithdraw(Overhead src, String reason);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApprovalCancel(Overhead src, String reason, MStaff staff);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryApprovalWithdraw(Overhead src, String reason, MStaff staff);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryPaymentCancel(Overhead src, String reason, MStaff staff);

	/**
	 * 諸経費申請情報エンティティから諸経費申請履歴エンティティへ変換.
	 *
	 * @oaram src 諸経費申請情報エンティティ.
	 * @param reason 理由.
	 * @param staff ユーザ.
	 * @return 諸経費申請履歴エンティティ.
	 */
	public OverheadHistory convertHistoryAcceptCancel(Overhead src, String reason, MStaff staff);

}
