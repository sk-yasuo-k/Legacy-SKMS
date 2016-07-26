package services.generalAffair.workingConditions.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class WorkingAllConditions {

	//選択		
	//public boolean show;
	//社員名
	//public boolean staffFullName;
	//差引時間
	public boolean balanceHours;
	//私用時間
	public boolean privateHours;
	//勤務時間
	public boolean workingHours;
	//休憩時間
	public boolean recessHours;
	//実働時間
	public boolean realWorkingHours;
	//控除数
	public boolean deductionCount;
	//深夜勤務日数
	public boolean nightWorkCount;
	//休日出勤日数
	public boolean holidayWorkCount;
	//欠勤日数
	public boolean absenceCount;
	//無断欠勤日数
	public boolean absenceWithoutLeaveCount;	
	//有給繰越日数
	public boolean lastPaidVacationCount;
	//有給今月発生日数
	public boolean givenPaidVacationCount;
	//有給今月消滅日数
	public boolean lostPaidVacationCount;
	//有給今月使用日数
	public boolean takenPaidVacationCount;
	//有給今月残日数
	public boolean currentPaidVacationCount;
	//代休繰越日数
	public boolean lastCompensatoryDayOffCount;
	//代休今月発生日数
	public boolean givenCompensatoryDayOffCount;
	//代休今月消滅日数
	public boolean lostCompensatoryDayOffCount;
	//代休今月使用日数
	public boolean takenCompensatoryDayOffCount;
	//代休今月残日数
	public boolean currentCompensatoryDayOffCount;
	//特別休暇繰越日数
	public boolean lastSpecialVacationCount;
	//特別休暇今月発生日数
	public boolean givenSpecialVacationCount;
	//特別休暇今月消滅日数
	public boolean lostSpecialVacationCount;
	//特別休暇今月使用日数
	public boolean takenSpecialVacationCount;
	//特別休暇今月残日数
	public boolean currentSpecialVacationCount;
	
	//集計開始日
	public Date startDate;
	//集計終了日
	public Date finishDate;
	
	//1ヶ月のみにするかどうか
	public Boolean isOnlyOneMonth;
	
	//表示している社員IDを格納
	public List<Integer> showStaffList = new ArrayList<Integer>();

	
}
