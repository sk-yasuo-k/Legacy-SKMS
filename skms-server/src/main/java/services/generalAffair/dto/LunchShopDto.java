package services.generalAffair.dto;

import java.io.Serializable;
import java.util.List;

/**
 * ランチショップ情報です。
 * 
 * @author yasuo-k
 * 
 */
public class LunchShopDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * ショップIDです。
	 */
	public int shopId;

	/**
	 * ショップ名です。
	 */
	public String shopName;

	/**
	 * ショップURLです。
	 */
	public String shopUrl;

	/**
	 * オーダー締切時間です。
	 */
	public String orderLimitTime;

	/**
	 * メニュー情報一覧です。
	 */
	public List<LunchMenuDto> menus;

}