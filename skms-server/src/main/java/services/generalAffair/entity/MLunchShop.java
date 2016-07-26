package services.generalAffair.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * ランチショップ情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MLunchShop implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * ショップIDです。
	 */
	@Id
	@GeneratedValue
	public int shopId;

	/**
	 * メニュー情報です。
	 */
	@OneToMany(mappedBy = "lunchShop")
	public List<MLunchMenu> lunchMenus;

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
	 * 表示順です。
	 */
	public int sortOrder;

}