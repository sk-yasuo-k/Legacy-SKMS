package subApplications.generalAffair.workingConditions.dto
{
	import dto.StaffNameDto;
	
	public class WorkingHoursMonthlyExtDto
	{
		
		/**
		 * 社員IDです.
		 */
		public var staffId:int;
	
		/**
		 * 社員名です.
		 */
		public var staffFullName:String;
	
		/**
		 * 勤務月コードです.
		 */
		public var workingMonthCode:String = "0000";
	
		/**
		 * 差引時間です.
		 */
		public var balanceHours:Number = 0.0;
		
		/**
		 * 私用時間です.
		 */
		public var privateHours:Number = 0.0;
			
		/**
		 * 勤務時間です.
		 */
		public var workingHours:Number = 0.0;

		/**
		 * 休憩時間です.
		 */
		public var recessHours:Number = 0.0;
	
		/**
		 * 実働時間です.
		 */
		public var realWorkingHours:Number = 0.0;

		/**
		 * 控除数です.
		 */
		public var deductionCount:Number = 0.0;

		public function get DeductionCount():Number
		{
			return this.getDecimalRound(deductionCount, 2);
		}		


		/**
		 * 欠勤日数です.
		 */
		public var absenceCount:int = 0;

		/**
		 * 無断欠勤日数です.
		 */
		public var absenceWithoutLeaveCount:int = 0;

		/**
		 * 深夜勤務日数です.
		 */
		public var nightWorkCount:int = 0;

		/**
		 * 休日出勤日数です.
		 */
		public var holidayWorkCount:int = 0;

		/**
		 * 有給繰越日数です.
		 */
		public var lastPaidVacationCount:Number = 0;

		/**
		 * 有給今月発生日数です.
		 */
		public var givenPaidVacationCount:Number = 0;

		/**
		 * 有給今月消滅日数です.
		 */
		public var lostPaidVacationCount:Number = 0;

		/**
		 * 有給今月使用日数です.
		 */
		public var takenPaidVacationCount:Number = 0;

		/**
		 * 有給今月残日数です.
		 */
		public var currentPaidVacationCount:Number = 0;

		/**
		 * 特別休暇繰越日数です.
		 */
		public var lastSpecialVacationCount:int = 0;

		/**
		 * 特別休暇今月発生日数です.
		 */
		public var givenSpecialVacationCount:int = 0;

		/**
		 * 特別休暇今月消滅日数です.
		 */
		public var lostSpecialVacationCount:int = 0;

		/**
		 * 特別休暇今月使用日数です.
		 */
		public var takenSpecialVacationCount:int = 0;

		/**
		 * 特別休暇今月残日数です.
		 */
		public var currentSpecialVacationCount:int = 0;

		/**
		 * 代休繰越日数です.
		 */
		public var lastCompensatoryDayOffCount:Number = 0;

		/**
		 * 代休今月発生日数です.
		 */
		public var givenCompensatoryDayOffCount:Number = 0;

		/**
		 * 代休今月消滅日数です.
		 */
		public var lostCompensatoryDayOffCount:Number = 0;

		/**
		 * 代休今月使用日数です.
		 */
		public var takenCompensatoryDayOffCount:Number = 0;

		/**
		 * 代休今月残日数です.
		 */
		public var currentCompensatoryDayOffCount:Number = 0;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです.
		 */
		public var registrantId:int = 0;

		/** 
		 * 登録バージョン
		 */
		public var registrationVer:Number = 0;

		/**
		 * 表示非表示のデータ
		 * */
		public var show:Boolean = true;
				
		/**
		 * デフォルトコンストラクタ
		 * */
		public function WorkingHoursMonthlyExtDto()
		{			
		}
		
		/**
		 * 初期化
		 * */
		public function init():void
		{
			//勤務月コード
			this.workingMonthCode = "0000";
			//差引時間
			this.balanceHours = 0.0;
			//私用時間
			this.privateHours = 0.0;
			//勤務時間
			this.workingHours = 0.0;
			//休憩時間
			this.recessHours = 0.0;
			//実働時間
			this.realWorkingHours = 0.0;
			//控除数
			this.deductionCount = 0.0;
			//欠勤日数
			this.absenceCount = 0;
			//無断欠勤日数
			this.absenceWithoutLeaveCount = 0;
			//深夜勤務日数
			this.nightWorkCount = 0;
			//休日出勤日数
			this.holidayWorkCount = 0;
			//有給繰越日数
			this.lastPaidVacationCount = 0;
			//有給今月発生日数
			this.givenPaidVacationCount = 0;
			//有給今月消滅日数
			this.lostPaidVacationCount = 0;
			//有給今月使用日数
			this.takenPaidVacationCount = 0;
			//有給今月残日数
			this.currentPaidVacationCount = 0;
			//特別休暇繰越日数
			this.lastSpecialVacationCount = 0;
			//特別休暇今月発生日数
			this.givenSpecialVacationCount = 0;
			//特別休暇今月消滅日数
			this.lostSpecialVacationCount = 0;
			//特別休暇今月使用日数
			this.takenSpecialVacationCount = 0;
			//特別休暇今月残日数
			this.currentSpecialVacationCount = 0;
			//代休繰越日数
			this.lastCompensatoryDayOffCount = 0;
			//代休今月発生日数
			this.givenCompensatoryDayOffCount = 0;
			//代休今月消滅日数
			this.lostCompensatoryDayOffCount = 0;
			//代休今月使用日数
			this.takenCompensatoryDayOffCount = 0;
			//代休今月残日数
			this.currentCompensatoryDayOffCount = 0;			
		}
		
		/**
		 * 任意小数点以下桁での四捨五入
		 * */
		private function getDecimalRound(num :Number, place :uint) :Number
		{   
			var i :uint = int(Math.pow(10, place));
			var n :Number = Math.round(num * i);
			return n / i;
		}
		
		/**
		 * 更新
		 * */
//		public function Update(src:WorkingHoursMonthlyExtDto):Boolean
		public function update(src:Object):Boolean
		{
			//社員IDが一致すれば更新
			if(this.staffId != src.staffId){
				return false;
			}
			//勤務月コード
			this.workingMonthCode = src.workingMonthCode;
			//差引時間
			this.balanceHours = src.balanceHours;
			//私用時間
			this.privateHours = src.privateHours;
			//勤務時間
			this.workingHours = src.workingHours;
			//休憩時間
			this.recessHours = src.recessHours;
			//実働時間
			this.realWorkingHours = src.realWorkingHours;
			//控除数
			this.deductionCount = src.deductionCount;
			//欠勤日数
			this.absenceCount = src.absenceCount;
			//無断欠勤日数
			this.absenceWithoutLeaveCount = src.absenceWithoutLeaveCount;
			//深夜勤務日数
			this.nightWorkCount = src.nightWorkCount;
			//休日出勤日数
			this.holidayWorkCount = src.holidayWorkCount;
			//有給繰越日数
			this.lastPaidVacationCount = src.lastPaidVacationCount;
			//有給今月発生日数
			this.givenPaidVacationCount = src.givenPaidVacationCount;
			//有給今月消滅日数
			this.lostPaidVacationCount = src.lostPaidVacationCount;
			//有給今月使用日数
			this.takenPaidVacationCount = src.takenPaidVacationCount;
			//有給今月残日数
			this.currentPaidVacationCount = src.currentPaidVacationCount;
			//特別休暇繰越日数
			this.lastSpecialVacationCount = src.lastSpecialVacationCount;
			//特別休暇今月発生日数
			this.givenSpecialVacationCount = src.givenSpecialVacationCount;
			//特別休暇今月消滅日数
			this.lostSpecialVacationCount = src.lostSpecialVacationCount;
			//特別休暇今月使用日数
			this.takenSpecialVacationCount = src.takenSpecialVacationCount;
			//特別休暇今月残日数
			this.currentSpecialVacationCount = src.currentSpecialVacationCount;
			//代休繰越日数
			this.lastCompensatoryDayOffCount = src.lastCompensatoryDayOffCount;
			//代休今月発生日数
			this.givenCompensatoryDayOffCount = src.givenCompensatoryDayOffCount;
			//代休今月消滅日数
			this.lostCompensatoryDayOffCount = src.lostCompensatoryDayOffCount;
			//代休今月使用日数
			this.takenCompensatoryDayOffCount = src.takenCompensatoryDayOffCount;
			//代休今月残日数
			this.currentCompensatoryDayOffCount = src.currentCompensatoryDayOffCount;
			
			return true;
		}
	}
}