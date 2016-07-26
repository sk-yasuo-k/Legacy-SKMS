package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

/**
 * 勤務時間(月別)情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class WorkingHoursMonthly implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 社員名です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public VCurrentStaffName staffName;

	/**
	 * 勤務月コードです。
	 */
	@Id
	public String workingMonthCode;

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
	 * 欠勤日数です。
	 */
	public int absenceCount;
	
	/**
	 * 無断欠勤日数です。
	 */
	public int absenceWithoutLeaveCount;
	
	/**
	 * 深夜勤務日数です。
	 */
	public int nightWorkCount;
	
	/**
	 * 休日出勤日数です。
	 */
	public int holidayWorkCount;
	
	/**
	 * 有給繰越日数です。
	 */
	public float lastPaidVacationCount;
	
	/**
	 * 有給今月発生日数です。
	 */
	public float givenPaidVacationCount;
	
	/**
	 * 有給今月消滅日数です。
	 */
	public float lostPaidVacationCount;
	
	/**
	 * 有給今月使用日数です。
	 */
	public float takenPaidVacationCount;
	
	/**
	 * 有給今月残日数です。
	 */
	public float currentPaidVacationCount;
	
	/**
	 * 特別休暇繰越日数です。
	 */
	public int lastSpecialVacationCount;
	
	/**
	 * 特別休暇今月発生日数です。
	 */
	public int givenSpecialVacationCount;
	
	/**
	 * 特別休暇今月消滅日数です。
	 */
	public int lostSpecialVacationCount;
	
	/**
	 * 特別休暇今月使用日数です。
	 */
	public int takenSpecialVacationCount;
	
	/**
	 * 特別休暇今月残日数です。
	 */
	public int currentSpecialVacationCount;
	
	/**
	 * 代休繰越日数です。
	 */
	public float lastCompensatoryDayOffCount;
	
	/**
	 * 代休今月発生日数です。
	 */
	public float givenCompensatoryDayOffCount;
	
	/**
	 * 代休今月消滅日数です。
	 */
	public float lostCompensatoryDayOffCount;
	
	/**
	 * 代休今月使用日数です。
	 */
	public float takenCompensatoryDayOffCount;
	
	/**
	 * 代休今月残日数です。
	 */
	public float currentCompensatoryDayOffCount;
	
	/**
	 * 勤務時間(日別)情報です。
	 */
	@OneToMany(mappedBy = "workingHoursMonthly")
	public List<WorkingHoursDaily> workingHoursDailies;

	/**
	 * 勤務管理表手続き履歴情報です。
	 */
	@OneToMany(mappedBy = "workingHoursMonthly")
	public List<WorkingHoursHistory> workingHoursHistories;

	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(insertable=false, updatable=false)
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	@Version
	public int registrationVer;
	
}