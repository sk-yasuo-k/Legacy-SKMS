package services.generalAffair.dxo;

import services.generalAffair.dto.LunchShopDto;
import services.generalAffair.entity.MLunchShop;

/**
 * ランチショップ情報変換Dxoです。
 * 
 * @author yasuo-k
 * 
 */
public interface LunchShopDxo {

	/**
	 * ランチショップ情報エンティティからランチショップ情報Dtoへ変換.
	 *
	 * @param src ランチショップ情報エンティティ
	 * @param dst ランチショップ情報Dto
	 */
	public void convert(MLunchShop src, LunchShopDto dst);
}
