package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 * ランチオプション選択肢情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MLunchOptionChoices implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * オプションIDです。
	 */
	@Id
	@GeneratedValue
	public int optionId;

	/**
	 * オプション情報です。
	 */
    @ManyToOne
	@JoinColumn(name="option_id")
    public MLunchOption option;

	/**
	 * 表示順です。
	 */
	@Id
	@GeneratedValue
	public int sortOrder;

	/**
	 * 選択肢名です。
	 */
	public String choiceName;

	/**
	 * 価格です。
	 */
	public int price;

}