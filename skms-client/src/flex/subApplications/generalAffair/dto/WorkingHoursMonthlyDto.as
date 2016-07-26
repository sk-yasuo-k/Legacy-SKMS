package subApplications.generalAffair.dto
{
	import dto.StaffNameDto;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.WorkingHoursMonthly")]
	
	public class WorkingHoursMonthlyDto
	{
		/**
		 * 社員IDです.
		 */
		public var staffId:int;
	
		/**
		 * 社員名です.
		 */
		public var staffName:StaffNameDto;
	
		/**
		 * 勤務月コードです.
		 */
		public var workingMonthCode:String;
	
		/**
		 * 差引時間です.
		 */
		public var balanceHours:Number;

		/**
		 * 私用時間です.
		 */
		public var privateHours:Number;
	
		/**
		 * 勤務時間です.
		 */
		public var workingHours:Number;

		/**
		 * 休憩時間です.
		 */
		public var recessHours:Number;
	
		/**
		 * 実働時間です.
		 */
		public var realWorkingHours:Number;

		/**
		 * 控除数です.
		 */
		public var deductionCount:Number;

		/**
		 * 欠勤日数です.
		 */
		public var absenceCount:int

		/**
		 * 無断欠勤日数です.
		 */
		public var absenceWithoutLeaveCount:int

		/**
		 * 深夜勤務日数です.
		 */
		public var nightWorkCount:int;

		/**
		 * 休日出勤日数です.
		 */
		public var holidayWorkCount:int;

		/**
		 * 有給繰越日数です.
		 */
		public var lastPaidVacationCount:Number;

		/**
		 * 有給今月発生日数です.
		 */
		public var givenPaidVacationCount:Number;

		/**
		 * 有給今月消滅日数です.
		 */
		public var lostPaidVacationCount:Number;

		/**
		 * 有給今月使用日数です.
		 */
		public var takenPaidVacationCount:Number;

		/**
		 * 有給今月残日数です.
		 */
		public var currentPaidVacationCount:Number;

		/**
		 * 特別休暇繰越日数です.
		 */
		public var lastSpecialVacationCount:int;

		/**
		 * 特別休暇今月発生日数です.
		 */
		public var givenSpecialVacationCount:int;

		/**
		 * 特別休暇今月消滅日数です.
		 */
		public var lostSpecialVacationCount:int;

		/**
		 * 特別休暇今月使用日数です.
		 */
		public var takenSpecialVacationCount:int;

		/**
		 * 特別休暇今月残日数です.
		 */
		public var currentSpecialVacationCount:int;

		/**
		 * 代休繰越日数です.
		 */
		public var lastCompensatoryDayOffCount:Number;

		/**
		 * 代休今月発生日数です.
		 */
		public var givenCompensatoryDayOffCount:Number;

		/**
		 * 代休今月消滅日数です.
		 */
		public var lostCompensatoryDayOffCount:Number;

		/**
		 * 代休今月使用日数です.
		 */
		public var takenCompensatoryDayOffCount:Number;

		/**
		 * 代休今月残日数です.
		 */
		public var currentCompensatoryDayOffCount:Number;

		/**
		 * 勤務時間(日別)情報です.
		 */
		public var workingHoursDailies:ArrayCollection;

		/**
		 * 勤務管理表手続き履歴情報です.
		 */
		public var workingHoursHistories:ArrayCollection;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです.
		 */
		public var registrantId:int;

		/** 登録バージョン */
		public var registrationVer:Number;

		/**
		 * 勤務時間月間集計処理.
		 *
		 */
		public function calculateMonthlyTotal():void
		{
			// 初期化
			this.balanceHours = 0;
			this.privateHours = 0;
			this.workingHours = 0;
			this.recessHours = 0;
			this.realWorkingHours = 0;
			this.deductionCount = 0;
			this.absenceCount = 0;
			this.absenceWithoutLeaveCount = 0;
			this.nightWorkCount = 0;
			this.givenCompensatoryDayOffCount = 0;
			this.takenCompensatoryDayOffCount = 0;
			this.currentCompensatoryDayOffCount = 0;
			this.takenPaidVacationCount = 0;
			this.currentPaidVacationCount = 0;
			
    		for each(var whDto:WorkingHoursDailyDto in this.workingHoursDailies) {
    			// 差引時間の集計
    			this.balanceHours += whDto.balanceHours;
    			// 私用時間の集計
    			this.privateHours += whDto.privateHours;
    			// 勤務時間の集計
    			this.workingHours += whDto.workingHours;
    			// 休憩時間の集計
    			this.recessHours += whDto.recessHours;
    			// 実働時間の集計
    			this.realWorkingHours += whDto.realWorkingHours;
    			// 控除数の集計
    			this.deductionCount += whDto.deductionCount;
    			// 勤休コードによる分岐
    			switch (whDto.absenceCode) {
    				case 1:	// 有給
    					// 有給使用日数のインクリメント
    					this.takenPaidVacationCount+=1.0;
    					break;
    				case 2:	// 代休
    					// 代休使用日数のインクリメント
    					this.takenCompensatoryDayOffCount++;
    					break;
    				case 3:	// 特別休暇
    					break;
    				case 4:	// 欠勤
    					// 欠勤日数のインクリメント
    					this.absenceCount ++;
    					break;
    				case 5:	// 無断欠勤
    					// 無断欠勤日数のインクリメント
        				this.absenceWithoutLeaveCount++;
    					break;
    				case 7:	// 半有給
    					// 有給使用日数のインクリメント
    					this.takenPaidVacationCount+=0.5;
    					break;
    				case 8:	// 半代休
    					// 代休使用日数のインクリメント
    					this.takenCompensatoryDayOffCount+=0.5;
    					break;
    				case 9:	// 半代半有
    					// 有給使用日数のインクリメント
    					this.takenPaidVacationCount+=0.5;
    					// 代休使用日数のインクリメント
    					this.takenCompensatoryDayOffCount+=0.5;
    					break;
    			}
				// 休日出勤(代休取得)日数のインクリメント
				if (whDto.holidayWorkType == 1)
				{
					 this.givenCompensatoryDayOffCount = this.givenCompensatoryDayOffCount + 1;
				}
				else if (whDto.holidayWorkType == 2)
				{
					 this.givenCompensatoryDayOffCount = this.givenCompensatoryDayOffCount + 0.5;
				}
    			// 深夜勤務日数のインクリメント
    			if (whDto.nightWorkFlg) this.nightWorkCount++;
    		}
    		
    		// 有給残日数
			this.currentPaidVacationCount
				= this.lastPaidVacationCount + this.givenPaidVacationCount - this.lostPaidVacationCount - this.takenPaidVacationCount

    		// 代休残日数
			this.currentCompensatoryDayOffCount
				= this.lastCompensatoryDayOffCount + this.givenCompensatoryDayOffCount - this.lostCompensatoryDayOffCount - this.takenCompensatoryDayOffCount

		}

	}
}