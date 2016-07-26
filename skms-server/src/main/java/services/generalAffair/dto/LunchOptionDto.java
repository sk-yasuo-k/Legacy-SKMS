package services.generalAffair.dto;

import java.io.Serializable;
import java.util.List;

/**
 * ランチオプション情報です。
 * 
 * @author yasuo-k
 * 
 */
public class LunchOptionDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * オプションIDです。
	 */
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
	 * オプション選択肢情報一覧です。
	 */
	public List<LunchOptionChoicesDto> optionChoices;

}