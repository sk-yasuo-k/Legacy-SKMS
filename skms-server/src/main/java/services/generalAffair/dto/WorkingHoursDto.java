package services.generalAffair.dto;

import java.io.Serializable;
import java.sql.Time;
import java.util.Date;

/**
 * 勤務時間情報です。
 * 
 * @author yasuo-k
 * 
 */
public class WorkingHoursDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	public int staffId;

	/**
	 * 勤務日です。
	 */
	public Date workingDate;

	/**
	 * 時差勤務開始時間です。
	 */
	public Time staggeredStartTime;

	/**
	 * 開始時間です。
	 */
	public Time startTime;

	/**
	 * 終了時間です。
	 */
	public Time quittingTime;

	/**
	 * 私用時間です。
	 */
	public float privateHour;

	/**
	 * 休憩時間です。
	 */
	public Time recess;


}