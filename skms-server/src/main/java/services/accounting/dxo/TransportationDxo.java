package services.accounting.dxo;

import java.util.List;

import services.accounting.dto.TransportationDto;
import services.accounting.entity.Transportation;
import services.generalAffair.entity.MStaff;

/**
 * 交通費申請情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface TransportationDxo {

	/**
	 * 交通費申請情報Dtoから交通費申請情報エンティティへ変換.<br>
	 * 交通費申請明細情報リストの変換あり.
	 *
	 * @param src   交通費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 交通費申請情報エンティティ
	 */
	public Transportation convertCreate(TransportationDto src, MStaff staff);

	/**
	 * 交通費申請情報Dtoから交通費申請情報エンティティへ変換.<br>
	 * 交通費申請明細情報リストの変換なし.
	 *
	 * @param src 交通費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 交通費申請情報エンティティ
	 */
	public Transportation convertUpdate(TransportationDto src, MStaff staff);

	/**
	 * 交通費申請情報Dtoから交通費申請情報エンティティへ変換.<br>
	 * 交通費申請明細情報リストの変換なし.
	 *
	 * @param src   交通費申請情報Dto
	 * @return Transportation 交通費申請情報エンティティ
	 */
	public Transportation convertDelete(TransportationDto src);

	/**
	 * 交通費申請情報エンティティリストから交通費申請情報Dtoリストへ変換.<br>
	 * 交通費申請明細情報リストの変換あり.
	 *
	 * @param src   交通費申請情報エンティティリスト
	 * @param staff ログイン社員情報エンティティ
	 * @return List<TransportationDto> 交通費申請情報Dtoリスト
	 */
	public List<TransportationDto> convertGetTransportations(List<Transportation> src, int type, MStaff staff);

	/**
	 * 交通費申請情報エンティティから交通費申請情報Dtoへ変換.<br>
	 * 交通費申請明細情報リストの変換あり.
	 *
	 * @param src   交通費申請情報エンティティ
	 * @param staff ログイン社員情報エンティティ
	 * @return TransportationDto 交通費申請情報Dto
	 */
	public TransportationDto convertGetTransportation(Transportation src, int type, MStaff staff);

}
