package services.system.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.system.dto.TreeDto;
import services.system.entity.MSkmsMenu;


/**
 * TreeDxoです。
 *
 * @author yasuo-k
 *
 */
public interface TreeDxo {

	/**
	 * メニューエンティティリストからメニューリストへ変換.
	 * 
	 * @param src メニューエンティティリスト
	 * @return メニューリスト
	 */
	public List<TreeDto> convertToAllMenu(List<MSkmsMenu> src);
	
	/**
	 * メニューエンティティリストからメニューリストへ変換.
	 * 
	 * @param src メニューエンティティリスト
	 * @return メニューリスト
	 */
	@ConversionRule("id : skmsMenuId, label : skmsMenuName, alias : skmsMenuAlias, url : skmsMenuUrl, enabled : skmsMenuId, urlRef : urlRef")
	public List<TreeDto> convertToMyMenu(List<MSkmsMenu> src);
	
}
