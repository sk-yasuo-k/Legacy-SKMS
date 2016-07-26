package subApplications.generalAffair.paidVacationMaintenance.dto
{
	import mx.collections.ArrayCollection;
	
	import subApplications.generalAffair.dto.WorkingHoursMonthlyDto;

	/**
	 * 勤務時間(月別)情報一覧Dtoです。
	 *
	 * @author t-ito
	 *
	 */	
	public class WorkingHoursMonthlyDtoList
	{		
		/** 勤務時間(月別)情報一覧 */
		private var _workingHoursMonthlyList:ArrayCollection;

		/**
		 * コンストラクタ
		 */				
		public function WorkingHoursMonthlyDtoList(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:WorkingHoursMonthlyDto in object){
				tmp.lastPaidVacationCount;
				tmp.lostPaidVacationCount;
				tmp.givenPaidVacationCount;
				tmp.takenPaidVacationCount;
				tmp.currentPaidVacationCount;
				tmp.lastCompensatoryDayOffCount;
				tmp.lostCompensatoryDayOffCount;
				tmp.givenCompensatoryDayOffCount;
				tmp.takenCompensatoryDayOffCount;
				tmp.currentCompensatoryDayOffCount;
				tmpArray.push(tmp);
			} 
			_workingHoursMonthlyList = new ArrayCollection(tmpArray);						
		}
		
		/**
		 * 勤務時間(月別)情報一覧取得
		 */
		public function get workingHoursMonthlyList():ArrayCollection
		{
			return _workingHoursMonthlyList;
		}		
	}
}