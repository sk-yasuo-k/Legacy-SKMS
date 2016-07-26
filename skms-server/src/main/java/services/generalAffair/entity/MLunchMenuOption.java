package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

/**
 * ランチメニュー_オプション対応情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MLunchMenuOption implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * メニュー_オプション対応IDです。
	 */
	@Id
	@GeneratedValue
	public int menuOptionId;

	/**
	 * メニューIDです。
	 */
	public Integer menuId;

	/**
	 * オプションIDです。
	 */
	public Integer optionId;

	/**
	 * メニュー情報です。
	 */
    @ManyToOne
	@JoinColumn(name="menu_id")
    public MLunchMenu lunchMenu;

	/**
	 * オプション情報です。
	 */
    @OneToOne
	@JoinColumn(name="option_id")
    public MLunchOption option;

	/**
	 * 表示順です。
	 */
	public Integer sortOrder;

}