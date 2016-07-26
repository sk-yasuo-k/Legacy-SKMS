package services.accounting.dxo.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.seasar.extension.jdbc.JdbcManager;

import enumerate.AccountItemId;
import enumerate.PaymentId;

import services.accounting.dto.OverheadDetailDto;
import services.accounting.dxo.OverheadDetailDxo;
import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadDetail;


/**
 * 諸経費申請明細情報変換Dxo実装クラスです.
 *
 * @author yasuo-k
 *
 */
public class OverheadDetailDxoImpl implements OverheadDetailDxo {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @param seqNo  シーケンス番号.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertCreate(OverheadDetailDto src, Overhead parent, int seqNo)
	{
		OverheadDetail dst = convert(src, parent);
		dst.overheadNo = seqNo;
		return dst;
	}

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertUpdate(OverheadDetailDto src, Overhead parent)
	{
		OverheadDetail dst = convert(src, parent);
		dst.overheadNo = src.overheadNo;
		return dst;
	}

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApply(OverheadDetailDto src, Overhead parent)
	{
		OverheadDetail dst = convert(src, parent);
		dst.overheadNo = src.overheadNo;
		// 領収書Noを発行する.
		dst.receiptNo = makeReceiptNo(dst);
		return dst;
	}

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApproval(OverheadDetailDto src, Overhead parent)
	{
		OverheadDetail dst = convert(src, parent);
		dst.overheadNo = src.overheadNo;
		return dst;
	}

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApplyWithdraw(OverheadDetailDto src, Overhead parent)
	{
		OverheadDetail dst = convert(src, parent);
		dst.overheadNo = src.overheadNo;
		// 領収書Noを破棄する.
		dst.receiptNo = null;
		return dst;
	}

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto.
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApprovalCancel(OverheadDetailDto src, Overhead parent)
	{
		OverheadDetail dst = convert(src, parent);
		dst.overheadNo = src.overheadNo;
		// 勘定科目を破棄する.
		dst.accountItemId = null;
		return dst;
	}

	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto.
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	public OverheadDetail convertApprovalWithdraw(OverheadDetailDto src, Overhead parent)
	{
		OverheadDetail dst = convert(src, parent);
		dst.overheadNo = src.overheadNo;
		// 領収書Noを破棄する.
		dst.receiptNo = null;
		// 勘定科目を破棄する.
		dst.accountItemId = null;
		return dst;
	}


	/**
	 * 諸経費申請明細情報Dtoから諸経費申請明細情報エンティティへ変換.<br>
	 *
	 * @param src    諸経費申請明細情報Dto
	 * @param parent 諸経費申請エンティティ.
	 * @return 諸経費申請明細情報エンティティ
	 */
	private OverheadDetail convert(OverheadDetailDto src, Overhead parent)
	{
		OverheadDetail dst = new OverheadDetail();
		dst.overheadId     = parent.overheadId;
		//dst.overheadNo
		dst.overheadTypeId = src.overheadTypeId;
		dst.content        = src.content;
		dst.contentA       = src.contentA;
		dst.contentB       = src.contentB;
		dst.contentC       = src.contentC;
		dst.overheadDate   = src.overheadDate;
		if (AccountItemId.exist(src.accountItemId))
			dst.accountItemId  = src.accountItemId;
		dst.paymentId      = src.paymentId;
		if (src.paymentId == PaymentId.CARD) {
			dst.paymentCreditCardNo = src.paymentInfo;
		}
		dst.expense        = Integer.parseInt(src.expense);
		dst.receiptNo      = src.receiptNo;
		dst.note           = src.note;
		dst.registrantId   = parent.registrantId;
		dst.registrationVer= src.registrationVer;
		return dst;
	}

//	/**
//	 * Next諸経費申請明細連番の発行.
//	 *
//	 * @return int Next諸経費申請明細連番.
//	 */
//	private int nextval_serialNo(int serialId)
//	{
//		String maxSql = "select max(overhead_no) from overhead_detail where overhead_id =" + serialId;
//		Integer currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
//		return currval == null ? 1 : currval + 1;
//	}

	/**
	 * 領収書番号の発行.
	 *
	 * @return 領収書番号.
	 */
	private String makeReceiptNo(OverheadDetail overhead)
	{
		String retRep = null;
		int    retRepNo = 0;
		String lastRep = null;
		String receipt = overhead.receiptNo;
		Date date = overhead.overheadDate;
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");

		// 領収書番号 発行済みのとき.
		if (receipt != null && receipt.length() > 0) {

		}
		// 領収書番号 未発行のとき.
		else {
			// 最新の領収書番号を取得する.
			String sql = "select max(receipt_no) from overhead_detail"
							+ " where overhead_date = to_date('" + sdf.format(date) +   "', 'YYMMDD')"
							+ "	 and substr(receipt_no, 1, 6) = '" + sdf.format(date) + "'";
			lastRep = jdbcManager.selectBySql(String.class, sql).getSingleResult();
		}

		// 領収書番号を作成する.
		if (lastRep == null)	retRepNo = 1;
		else					retRepNo = Integer.parseInt(lastRep.substring(7, 10)) + 1;
		retRep = sdf.format(date) + "-" + String.format("%03d", retRepNo);
		return retRep;
	}

}