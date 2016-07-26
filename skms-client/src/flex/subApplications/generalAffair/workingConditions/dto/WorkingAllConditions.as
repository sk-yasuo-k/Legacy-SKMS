package subApplications.generalAffair.workingConditions.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class WorkingAllConditions
	{
		public function WorkingAllConditions()
		{
			//選択
			this.show = false;
			//社員名
			this.staffFullName = true;
			//差引時間
			this.balanceHours = false;
			//私用時間
			this.privateHours = false;
			//勤務時間
			this.workingHours = true;
			//休憩時間
			this.recessHours = false;
			//実働時間
			this.realWorkingHours = true;
			//控除数
			this.deductionCount = true;
			//欠勤日数
			this.absenceCount = true;
			//無断欠勤日数
			this.absenceWithoutLeaveCount = true;
			//深夜勤務日数
			this.nightWorkCount = true;
			//休日出勤日数
			this.holidayWorkCount = true;
			//有給繰越日数
			this.lastPaidVacationCount = false;
			//有給今月発生日数
			this.givenPaidVacationCount = false;
			//有給今月消滅日数
			this.lostPaidVacationCount = false;
			//有給今月使用日数
			this.takenPaidVacationCount = true;
			//有給今月残日数
			this.currentPaidVacationCount = true;
			//特別休暇繰越日数
			this.lastSpecialVacationCount = false;
			//特別休暇今月発生日数
			this.givenSpecialVacationCount = false;
			//特別休暇今月消滅日数
			this.lostSpecialVacationCount = false;
			//特別休暇今月使用日数
			this.takenSpecialVacationCount = true;
			//特別休暇今月残日数
			this.currentSpecialVacationCount = true;
			//代休繰越日数
			this.lastCompensatoryDayOffCount = false;
			//代休今月発生日数
			this.givenCompensatoryDayOffCount = false;
			//代休今月消滅日数
			this.lostCompensatoryDayOffCount = false;
			//代休今月使用日数
			this.takenCompensatoryDayOffCount = true;
			//代休今月残日数
			this.currentCompensatoryDayOffCount = true;
			
			//集計開始日
			this.startDate = new Date();
			//集計終了日
			this.finishDate = new Date();
			
			//1ヶ月のみにするかどうか
			this.isOnlyOneMonth = true;
			
			//表示している社員IDを格納
			this.showStaffList = new ArrayCollection();
			
		}
		
		//選択		
		public var show:Boolean;
		//社員名
		public var staffFullName:Boolean;
		//差引時間
		public var balanceHours:Boolean;
		//私用時間
		public var privateHours:Boolean;
		//勤務時間
		public var workingHours:Boolean;
		//休憩時間
		public var recessHours:Boolean;
		//実働時間
		public var realWorkingHours:Boolean;
		//控除数
		public var deductionCount:Boolean;
		//欠勤日数
		public var absenceCount:Boolean;
		//無断欠勤日数
		public var absenceWithoutLeaveCount:Boolean;
		//深夜勤務日数
		public var nightWorkCount:Boolean;
		//休日出勤日数
		public var holidayWorkCount:Boolean;
		//有給繰越日数
		public var lastPaidVacationCount:Boolean;
		//有給今月発生日数
		public var givenPaidVacationCount:Boolean;
		//有給今月消滅日数
		public var lostPaidVacationCount:Boolean;
		//有給今月使用日数
		public var takenPaidVacationCount:Boolean;
		//有給今月残日数
		public var currentPaidVacationCount:Boolean;
		//特別休暇繰越日数
		public var lastSpecialVacationCount:Boolean;
		//特別休暇今月発生日数
		public var givenSpecialVacationCount:Boolean;
		//特別休暇今月消滅日数
		public var lostSpecialVacationCount:Boolean;
		//特別休暇今月使用日数
		public var takenSpecialVacationCount:Boolean;
		//特別休暇今月残日数
		public var currentSpecialVacationCount:Boolean;
		//代休繰越日数
		public var lastCompensatoryDayOffCount:Boolean;
		//代休今月発生日数
		public var givenCompensatoryDayOffCount:Boolean;
		//代休今月消滅日数
		public var lostCompensatoryDayOffCount:Boolean;
		//代休今月使用日数
		public var takenCompensatoryDayOffCount:Boolean;
		//代休今月残日数
		public var currentCompensatoryDayOffCount:Boolean;
		
		//集計開始日
		public var startDate:Date;
		//集計終了日
		public var finishDate:Date;
		
		//1ヶ月のみにするかどうか
		public var isOnlyOneMonth:Boolean;
		
		//表示している社員IDを格納
		public var showStaffList:ArrayCollection;
		
	}
	//必要に応じて値設定用関数作成
}