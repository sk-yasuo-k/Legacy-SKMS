package services.accounting.dxo.impl;

import org.seasar.extension.jdbc.JdbcManager;

import services.accounting.dto.TransportationDetailDto;
import services.accounting.dxo.TransportationDetailDxo;
import services.accounting.entity.Transportation;
import services.accounting.entity.TransportationDetail;


/**
 * 交通費申請明細情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class TransportationDetailDxoImpl implements TransportationDetailDxo {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * 連番の初期値です。
	 */
	public static final int INIT_SEQNO = 1;


	/**
	 * 交通費申請明細情報Dtoから交通費申請明細情報エンティティへ変換.
	 *
	 * @param src    交通費申請明細情報Dto
	 * @param parent 交通費申請エンティティー
	 * @return TransportationDetail 交通費申請明細情報エンティティ
	 */
	public TransportationDetail convertCreate(TransportationDetailDto src, Transportation parent)
	{
		TransportationDetail dst = new TransportationDetail(src);
		dst.transportationId     = parent.transportationId;
		dst.sequenceNo           = nextval_transportationSeq(dst.transportationId);
		dst.registrantId         = parent.registrantId;
		return dst;
	}

	/**
	 * 交通費申請明細情報Dtoから交通費申請明細情報エンティティへ変換.
	 *
	 * @param src    交通費申請明細情報Dto
	 * @param parent 交通費申請エンティティー
	 * @return TransportationDetail 交通費申請明細情報エンティティ
	 */
	public TransportationDetail convertUpdate(TransportationDetailDto src, Transportation parent)
	{
		TransportationDetail dst = new TransportationDetail(src);
		dst.registrantId         = parent.registrantId;
		return dst;
	}

	/**
	 * 交通費申請明細情報Dtoから交通費申請明細情報エンティティへ変換.
	 *
	 * @param src    交通費申請明細情報Dto
	 * @return TransportationDetail 交通費申請明細情報エンティティ
	 */
	public TransportationDetail convertDelete(TransportationDetailDto src)
	{
		TransportationDetail dst = new TransportationDetail(src);
		return dst;
	}


	/**
	 * Next交通費申請明細連番の発行.
	 *
	 * @param  transId 交通費申請ID
	 * @return int Next交通費申請明細連番
	 */
	private int nextval_transportationSeq(int transId) {
		// 交通費申請明細連番のレコード数を取得する。
		long cnt = jdbcManager.from(TransportationDetail.class).where("transportation_id = ?", transId).getCount();
		if (!(cnt > 0))		return INIT_SEQNO;

		// 採番済みの交通費申請明細連番を取得する。
		String maxSql = "select max(sequence_no) from transportation_detail where transportation_id =" + transId;
		int currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		return (currval + 1);
	}

}