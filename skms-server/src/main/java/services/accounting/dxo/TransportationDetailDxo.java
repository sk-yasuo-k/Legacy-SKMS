package services.accounting.dxo;

import services.accounting.dto.TransportationDetailDto;
import services.accounting.entity.Transportation;
import services.accounting.entity.TransportationDetail;

/**
 * 交通費申請明細情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface TransportationDetailDxo {

	/**
	 * 交通費申請明細情報Dtoから交通費申請明細情報エンティティへ変換.
	 *
	 * @param src    交通費申請明細情報Dto
	 * @param parent 交通費申請エンティティー
	 * @return TransportationDetail 交通費申請明細情報エンティティ
	 */
	public TransportationDetail convertCreate(TransportationDetailDto src, Transportation parent);

	/**
	 * 交通費申請明細情報Dtoから交通費申請明細情報エンティティへ変換.
	 *
	 * @param src    交通費申請明細情報Dto
	 * @param parent 交通費申請エンティティー
	 * @return TransportationDetail 交通費申請明細情報エンティティ
	 */
	public TransportationDetail convertUpdate(TransportationDetailDto src, Transportation parent);

	/**
	 * 交通費申請明細情報Dtoから交通費申請明細情報エンティティへ変換.
	 *
	 * @param src    交通費申請明細情報Dto
	 * @return TransportationDetail 交通費申請明細情報エンティティ
	 */
	public TransportationDetail convertDelete(TransportationDetailDto src);
}
