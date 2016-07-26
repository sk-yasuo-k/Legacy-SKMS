package services.accounting.dxo;

import services.accounting.dto.OverheadDetailDto;
import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadDetail;


/**
 * 諸経費申請明細情報変換Dxoです.
 *
 * @author yasuo-k
 *
 */
public interface OverheadDetailDxo {

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @param seqNo  シーケンス番号.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertCreate(OverheadDetailDto src, Overhead parent, int seqNo);

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertUpdate(OverheadDetailDto src, Overhead parent);

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApply(OverheadDetailDto src, Overhead parent);

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApproval(OverheadDetailDto src, Overhead parent);

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApplyWithdraw(OverheadDetailDto src, Overhead parent);

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto.
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApprovalCancel(OverheadDetailDto src, Overhead parent);

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto.
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApprovalWithdraw(OverheadDetailDto src, Overhead parent);

}
