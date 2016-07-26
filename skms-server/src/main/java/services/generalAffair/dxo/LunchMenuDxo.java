package services.generalAffair.dxo;

import services.generalAffair.dto.LunchMenuDto;
import services.generalAffair.entity.MLunchMenu;

/**
 * ランチメニュー情報変換Dxoです。
 * 
 * @author yasuo-k
 * 
 */
public interface LunchMenuDxo {

	/**
	 * ランチメニュー情報エンティティからランチメニュー情報Dtoへ変換.
	 *
	 * @param src ランチメニュー情報エンティティ
	 * @param dst ランチメニュー情報Dto
	 */
	public void convert(MLunchMenu src, LunchMenuDto dst);
}
