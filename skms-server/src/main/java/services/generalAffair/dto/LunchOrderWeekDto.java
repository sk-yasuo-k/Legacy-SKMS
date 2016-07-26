package services.generalAffair.dto;

import java.io.Serializable;
import java.util.List;

/**
 * 週間ランチ注文情報です。
 * 
 * @author yasuo-k
 * 
 */
public class LunchOrderWeekDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 注文情報です。
	 */
	public List<LunchOrderDto> lunchOrders;

}