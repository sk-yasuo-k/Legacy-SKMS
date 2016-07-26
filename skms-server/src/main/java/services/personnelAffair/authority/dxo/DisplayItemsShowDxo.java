package services.personnelAffair.authority.dxo;

import services.personnelAffair.authority.dto.DisplayItemsShowDto;
import services.personnelAffair.authority.entity.MProfileListChoices;


/**
 * 表示項目表示可否変換Dxo
 * 
 * 
 * @author t-ito
 *
 */
public interface DisplayItemsShowDxo {

	/**
	 * リスト表示可否エンティティクラスから表示項目表示可否Dtoへ変換.
	 *
	 * @param src リスト表示可否エンティティ
	 * @return 表示項目表示可否Dto
	 */
	public DisplayItemsShowDto convert(MProfileListChoices src);
	
	
	/**
	 * 表示項目表示可否Dtoからリスト表示可否エンティティクラスへ変換.
	 *
	 * @param src リスト表示可否Dto
	 * @return 表示項目表示可否エンティティ
	 */	
	public MProfileListChoices convertMProfileListChoices(DisplayItemsShowDto src);
}
