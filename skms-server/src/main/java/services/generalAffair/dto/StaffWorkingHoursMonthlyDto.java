package services.generalAffair.dto;

import java.io.Serializable;


/**
 * 社員 月別勤務管理集計情報です.
 *
 * @author yasuo-k
 *
 */
public class StaffWorkingHoursMonthlyDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです.
	 */
	public int staffId;

	/**
	 * 勤務月コードです。
	 */
	public String yyyymm;

	/**
	 * 勤務時間です。
	 */
	public float workingHours;

	/**
	 * 実働時間です。
	 */
	public float realWorkingHours;

}