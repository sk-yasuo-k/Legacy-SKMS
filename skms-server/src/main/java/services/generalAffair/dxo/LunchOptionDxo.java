package services.generalAffair.dxo;

import services.generalAffair.dto.LunchOptionDto;
import services.generalAffair.entity.MLunchOption;

/**
 * ランチオプション情報変換Dxoです。
 * 
 * @author yasuo-k
 * 
 */
public interface LunchOptionDxo {

	/**
	 * ランチオプション情報エンティティからランチオプション情報Dtoへ変換.
	 *
	 * @param src ランチオプション情報エンティティ
	 * @param dst ランチオプション情報Dto
	 */
	public void convert(MLunchOption src, LunchOptionDto dst);
}
