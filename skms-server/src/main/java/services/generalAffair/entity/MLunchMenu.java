package services.generalAffair.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

/**
 * ランチメニュー情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MLunchMenu implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * メニューIDです。
	 */
	@Id
	@GeneratedValue
	public int menuId;

	/**
	 * メニュー_オプション対応情報です。
	 */
	@OneToMany(mappedBy = "lunchMenu")
	public List<MLunchMenuOption> menuOptions;

	/**
	 * ショップIDです。
	 */
	public int shopId;

	/**
	 * ショップ情報です。
	 */
    @ManyToOne
	@JoinColumn(name="shop_id")
    public MLunchShop lunchShop;

	/**
	 * メニュー名です。
	 */
	public String menuName;

	/**
	 * 価格です。
	 */
	public int price;

	/**
	 * 表示順です。
	 */
	public int sortOrder;

}