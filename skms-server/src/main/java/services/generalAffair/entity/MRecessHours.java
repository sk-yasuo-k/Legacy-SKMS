package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 休憩時間規定です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MRecessHours implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 休憩時間IDです。
	 */
	@Id
	public int recessId;

	/**
	 * 勤務時間(以上)です。
	 */
	public float fromHours;

	/**
	 * 勤務時間(未満)です。
	 */
	public float toHours;

	/**
	 * 休憩時間です。
	 */
	public float recessHours;


}