package services.generalAffair.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * ランチオプション情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MLunchOption implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * オプションIDです。
	 */
	@Id
	@GeneratedValue
	public Integer optionId;

	/**
	 * オプション名です。
	 */
	public String optionName;

	/**
	 * デフォルト選択インデックスです。
	 */
	public Integer defaultIndex;

	/**
	 * オプション選択肢情報です。
	 */
	@OneToMany(mappedBy = "option")
	public List<MLunchOptionChoices> optionChoices;


}