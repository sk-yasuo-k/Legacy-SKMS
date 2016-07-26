package services.generalAffair.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

/**
 * 勤務時間(日別)情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class WorkingHoursDaily implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 勤務月コードです。
	 */
	@Id
	public String workingMonthCode;

	/**
	 * 勤務日です。
	 */
	@Id
	@Temporal(TemporalType.DATE)
	public Date workingDate;

	/**
	 * 休日名称(休日でない場合はnull)です。
	 */
	@Transient
	public String holidayName;

	/**
	 * 時差勤務開始時刻です。
	 */
	public Timestamp staggeredStartTime;

	/**
	 * 開始時刻です。
	 */
	public Timestamp startTime;

	/**
	 * 終了時刻です。
	 */
	public Timestamp quittingTime;

	/**
	 * 差引時間です。
	 */
	public float balanceHours;

	/**
	 * 私用時間です。
	 */
	public float privateHours;

	/**
	 * 勤務時間です。
	 */
	public float workingHours;

	/**
	 * 休憩時間です。
	 */
	public float recessHours;

	/**
	 * 実働時間です。
	 */
	public float realWorkingHours;

	/**
	 * 控除数です。
	 */
	public float deductionCount;

	/**
	 * 勤休コードです。
	 */
	public int absenceCode;
	
	/**
	 * 休日出勤タイプです。
	 */
	public int holidayWorkType;
	
	/**
	 * 深夜勤務フラグです。
	 */
	public boolean nightWorkFlg;
	
	/**
	 * 勤休・遅刻事由 その他です。
	 */
	public String note;

	/**
	 * 勤務時間(月別)情報です。
	 */
    @ManyToOne
	@JoinColumns({@JoinColumn(name="staff_id", referencedColumnName="staff_id"),
		@JoinColumn(name="working_month_code", referencedColumnName="working_month_code")})
    public WorkingHoursMonthly workingHoursMonthly;
	
}