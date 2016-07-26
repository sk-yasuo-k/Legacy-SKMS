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
public class MLateDeduction implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 遅刻控除IDです。
	 */
	@Id
	public int deductionId;

	/**
	 * 遅刻時間(超過)です。
	 */
	public float fromHours;

	/**
	 * 遅刻時間(以下)です。
	 */
	public float toHours;

	/**
	 * 控除日数です。
	 */
	public float deductionDays;


}