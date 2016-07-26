package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;


/**
 * 社員別勤務管理エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity
public class StaffWorkingHours implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	public int staffId;

	/**
	 * 社員氏名です。
	 */
	public String fullName;

	/**
	 * 就労状況種別IDです。
	 */
	public int workStatusId;

	/**
	 * 勤務月コードです。
	 */
	@Id
	public String workingMonthCode;

//	/**
//	 * 差引時間です。
//	 */
//	public float balanceHours;
//
//	/**
//	 * 私用時間です。
//	 */
//	public float privateHours;

	/**
	 * 勤務時間です。
	 */
	public float workingHours;

//	/**
//	 * 休憩時間です。
//	 */
//	public float recessHours;

	/**
	 * 実働時間です。
	 */
	public float realWorkingHours;

	/**
//	 * 控除数です。
//	 */
//	public float deductionCount;
//
//	/**
//	 * 欠勤日数です。
//	 */
//	public Integer absenceCount;
//
//	/**
//	 * 無断欠勤日数です。
//	 */
//	public Integer absenceWithoutLeaveCount;
//
//	/**
//	 * 深夜勤務日数です。
//	 */
//	public Integer nightWorkCount;
//
//	/**
//	 * 休日出勤日数です。
//	 */
//	public Integer holidayWorkCount;
//
//	/**
//	 * 有給繰越日数です。
//	 */
//	public Integer lastPaidVacationCount;
//
//	/**
//	 * 有給今月発生日数です。
//	 */
//	public Integer givenPaidVacationCount;
//
//	/**
//	 * 有給今月使用日数です。
//	 */
//	public Integer takenPaidVacationCount;
//
//	/**
//	 * 有給今月残日数です。
//	 */
//	public Integer currentPaidVacationCount;
//
//	/**
//	 * 特別休暇繰越日数です。
//	 */
//	public Integer lastSpecialVacationCount;
//
//	/**
//	 * 特別休暇今月発生日数です。
//	 */
//	public Integer givenSpecialVacationCount;
//
//	/**
//	 * 特別休暇今月使用日数です。
//	 */
//	public Integer takenSpecialVacationCount;
//
//	/**
//	 * 特別休暇今月残日数です。
//	 */
//	public Integer currentSpecialVacationCount;
//
//	/**
//	 * 代休繰越日数です。
//	 */
//	public Integer lastCompensatoryDayOffCount;
//
//	/**
//	 * 代休今月発生日数です。
//	 */
//	public Integer givenCompensatoryDayOffCount;
//
//	/**
//	 * 代休今月使用日数です。
//	 */
//	public Integer takenCompensatoryDayOffCount;
//
//	/**
//	 * 代休今月残日数です。
//	 */
//	public Integer currentCompensatoryDayOffCount;
//
//	/**
//	 * 勤務時間(日別)情報です。
//	 */
//	@OneToMany(mappedBy = "workingHoursMonthly")
//	public List<WorkingHoursDaily> workingHoursDailies;
//
//	/**
//	 * 勤務管理表手続き履歴情報です。
//	 */
//	@OneToMany(mappedBy = "workingHoursMonthly")
//	public List<WorkingHoursHistory> workingHoursHistories;
//
//	/**
//	 * 登録日時です。
//	 */
//	@Temporal(TemporalType.TIMESTAMP)
//	@Column(insertable=false, updatable=false)
//	public Date registrationTime;
//
//	/**
//	 * 登録者IDです。
//	 */
//	public int registrantId;
//
//	/**
//	 * 登録バージョンです.
//	 */
//	@Version
//	public int registrationVer;
//
}