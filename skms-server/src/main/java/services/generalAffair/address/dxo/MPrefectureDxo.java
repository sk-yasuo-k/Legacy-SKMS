package services.generalAffair.address.dxo;

import java.util.List;

import services.generalAffair.address.dto.MPrefectureDto;
import services.generalAffair.address.entity.MPrefecture;

/**
 * 都道府県名変換Dxo
 * 
 * 
 * @author t-ito
 *
 */

public interface MPrefectureDxo {

	/**
	 * 都道府県マスタエンティティから都道府県名Dtoへ変換.
	 *
	 * @param src 都道府県マスタエンティティ
	 * @return 都道府県名Dtoリスト
	 */
	public List<MPrefectureDto> convert(List<MPrefecture> src); 
}
