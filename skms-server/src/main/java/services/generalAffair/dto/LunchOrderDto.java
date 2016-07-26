package services.generalAffair.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * ランチ注文情報です。
 * 
 * @author yasuo-k
 * 
 */
public class LunchOrderDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 注文日です。
	 */
	public Date orderDate;

	/**
	 * 社員IDです。
	 */
	public Integer staffId;

	/**
	 * 社員名です。
	 */
	public String staffName;

}