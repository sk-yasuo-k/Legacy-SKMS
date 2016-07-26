package services.generalAffair.dto;

import java.io.Serializable;
import java.util.List;

/**
 * ランチメニュー情報です。
 * 
 * @author yasuo-k
 * 
 */
public class LunchMenuDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * メニューIDです。
	 */
	public int menuId;

	/**
	 * メニュー名です。
	 */
	public String menuName;

	/**
	 * 価格です。
	 */
	public int price;

	/**
	 * オプション情報一覧です。
	 */
	public List<LunchOptionDto> options;

	
}