package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 休日出勤タイプです。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MHolidayWorkType implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 休日出勤タイプです。
	 */
	@Id
	public int holidayWorkType;

	/**
	 * 休日出勤名称です。
	 */
	public String holidayWorkName;

	/**
	 * 表示順序です。
	 */
	public int dispOrder;


}