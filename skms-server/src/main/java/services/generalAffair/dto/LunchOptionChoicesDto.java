package services.generalAffair.dto;

import java.io.Serializable;

/**
 * ランチオプション選択肢情報です。
 * 
 * @author yasuo-k
 * 
 */
public class LunchOptionChoicesDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 選択肢名です。
	 */
	public String choiceName;

	/**
	 * 価格です。
	 */
	public int price;

}