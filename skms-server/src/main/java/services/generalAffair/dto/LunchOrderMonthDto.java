package services.generalAffair.dto;

import java.io.Serializable;
import java.util.List;

/**
 * 月間ランチ注文情報です。
 * 
 * @author yasuo-k
 * 
 */
public class LunchOrderMonthDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 週間注文情報です。
	 */
	public List<LunchOrderWeekDto> lunchOrderWeeks;

}