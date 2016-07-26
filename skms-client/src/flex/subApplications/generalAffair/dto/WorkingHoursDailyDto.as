package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.utils.StringUtil;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.WorkingHoursDaily")]
	
	public class WorkingHoursDailyDto
	{
		/**
		 * 社員IDです.
		 */
		public var staffId:int;
	
		/**
		 * 勤務月コードです.
		 */
		public var workingMonthCode:String;
	
		/**
		 * 勤務日です.
		 */
		public var workingDate:Date;
	
		/**
		 * 休日名称(休日でない場合はnull)です.
		 */
		public var holidayName:String;
	
		/**
		 * スタイル名です.
		 */
		public var styleName:String;
	
		/**
		 * 時差勤務開始時刻です.
		 */
		public var staggeredStartTime:Date;
	
		/**
		 * 開始時刻です.
		 */
		public var startTime:Date;
	
		/**
		 * 終了時刻です.
		 */
		public var quittingTime:Date;
	
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
		 * 勤休コードです.
		 */
		public var absenceCode:int;

		/**
		 * 休日出勤タイプです.
		 */
		public var holidayWorkType:int

		/**
		 * 深夜勤務フラグです.
		 */
		public var nightWorkFlg:Boolean

		/**
		 * 備考です.
		 */
		public var note:String;

		/**
		 * 控除数です.
		 */
		public var deductionCount:Number;


		/**
		 * String データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueString(value:String):Boolean {
			if (value == null)							return false;
			if (!(StringUtil.trim(value).length > 0))	return false;
			return true;
		}
		
		/**
		 * Date データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueDate(value:Date):Boolean {
			if (value == null)							return false;
			return true;
		}


		/**
		 * 提出時の入力値チェック.
		 */
		public function checkSubmit():Boolean
		{
			var isSubmit:Boolean = true;
			// 開始時刻
			if (!checkSubmit_startTime(true)) {
				isSubmit = false;
			}
			// 終了時刻
			if (!checkSubmit_quittingTime(true)) {
				isSubmit = false;
			}
			// 私用時間
			if (!checkSubmit_privateHours()) {
				isSubmit = false;
			}
			// 休憩時間
			if (!checkSubmit_recessHours()) {
				isSubmit = false;
			}
			return isSubmit;
		}



		/**
		 * 開始時刻の入力値チェック.
		 */
		public function checkSubmit_startTime(checkAll:Boolean):Boolean
		{
			// 空白の場合
			if (this.startTime == null)
			{
				// 本日以降のデータは空白可
				var now:Date = new Date();
				if(this.workingDate > now && !checkAll) return true;
				
				//  終了時刻が入力済みの場合はエラー
				if(this.quittingTime != null) return false;

				// 休日出勤の場合はエラー
				if(this.holidayWorkType != 0) return false;
				
				// 平日で勤休コード未設定の場合はエラー
				if(this.holidayName == null
					&& this.workingDate.day != 0
					&& this.workingDate.day != 6
					&& this.absenceCode == 0 ) return false; 	
			}
			else
			{
				// 日付型でない場合はエラー
				if (!isValueDate(this.startTime)) return false;
			}
			return true;
		}
		/**
		 * 終了時刻の入力値チェック.
		 */
		public function checkSubmit_quittingTime(checkAll:Boolean):Boolean
		{
			// 空白の場合
			if (this.quittingTime == null)
			{
				// 本日以降のデータは空白可
				var now:Date = new Date();
				if(this.workingDate > now && !checkAll) return true;
				
				//  開始時刻が入力済みの場合はエラー
				if(this.startTime != null) return false;

				// 休日出勤の場合はエラー
				if(this.holidayWorkType != 0) return false;
				
				// 平日で勤休コード未設定の場合はエラー
				if(this.styleName =="DateWeekday"
					&& this.absenceCode == 0 ) return false; 	
			}
			else
			{
				// 日付型でない場合はエラー
				if (!isValueDate(this.quittingTime)) return false; 
			}
			return true;
		}
		
		
		/**
		 * 私用時間の入力値チェック.
		 */
		public function checkSubmit_privateHours():Boolean
		{
			// 勤務時間がマイナス値ならばエラー
			if ( this.startTime != null
				&& this.quittingTime != null 
				&& this.workingHours < 0) return false; 	

			return true; 
		}

		/**
		 * 休憩時間の入力値チェック.
		 */
		public function checkSubmit_recessHours():Boolean
		{
			// 実動時間がマイナス値ならばエラー
			if ( this.startTime != null
				&& this.quittingTime != null 
				&& this.realWorkingHours < 0
				&& this.workingHours >= 0) return false; 	

			return true; 
		}

		/**
		 * 日別勤務時間の集計.
		 */
		public function calculateDailyTotal():void
		{
			// ログイン時に取得した既定値を利用
			var recessHoursList:ArrayCollection = Application.application.indexLogic.recessHoursList;
			var lateDeductionList:ArrayCollection = Application.application.indexLogic.lateDeductionList;
			
			// 初期化
			this.balanceHours = 0;
			this.workingHours = 0;
			this.realWorkingHours = 0;
			this.deductionCount = 0;
			this.nightWorkFlg = false;

			// 遅刻控除数の計算
    		// 平日で勤休コード未設定、開始時刻が入力済みならば
    		var lateHours:Number = 0;
    		if (this.holidayName == null
    		    && this.absenceCode == 0
    			&& this.workingDate.day != 0
    			&& this.workingDate.day != 6
    			&& this.startTime) {
    			// 遅刻判定基準時刻の取得
    			var lateTime:Date;
    			// 時差勤務ならば時差開始時刻
    			if (this.staggeredStartTime) {
    				lateTime = new Date(this.staggeredStartTime);
    			} else {
    				// 通常ならば 9:30
    				// TODO:データベースから取得
    				lateTime = new Date(this.startTime);
    				lateTime.setHours(9,30,0,0);
    			}    			
    			// 遅刻ならば
    			if (this.startTime > lateTime) {
    				// 遅刻時間の計算
					// 2010.06.20 chg start 早退したとき 控除時間を考慮する
    				//var lateHours:Number
    				//	= (this.startTime.getTime() - lateTime.getTime()) / (60 * 60 * 1000);
	        		//for each(var lateDeduction:Object in lateDeductionList) {
	        		//	// 勤務時間が範囲内ならば
	        		//	if (lateDeduction.fromHours < lateHours
	        		//		&& lateHours <= lateDeduction.toHours) {
	        		//		this.deductionCount = lateDeduction.deductionDays;
	        		//		break;
	        		//	}
	        		//}
    				lateHours
    					= (this.startTime.getTime() - lateTime.getTime()) / (60 * 60 * 1000);
					// 2010.06.20 chg end   早退したとき 控除時間を考慮する
				}
			}
			
    		// 開始時刻、終了時刻が入力済みならば
    		if (this.startTime && this.quittingTime) {
    			// 差引時間の計算
        		this.balanceHours = (this.quittingTime.getTime() - this.startTime.getTime())
	    			/ (60 * 60 * 1000);
	    		// 私用時間が入力済みならば
        		if (this.privateHours) {
        			// 勤務時間の計算
        			this.workingHours = this.balanceHours - this.privateHours;
        		} else {
        			this.workingHours = this.balanceHours;
        		}
        		
        		// 休憩時間の計算
        		for each(var recessHours:Object in recessHoursList) {
        			// 勤務時間が範囲内ならば
        			if (recessHours.fromHours <= this.workingHours
        				&& this.workingHours < recessHours.toHours) {
        				if (this.recessHours < recessHours.recessHours) {
	        				this.recessHours = recessHours.recessHours;
	        			}
        				break;
        			}
        		}
				// 2010.06.20 add start 昼休憩時間の計算
				if (this.recessHours < 1
					&& this.holidayName == null
	    		    && (this.absenceCode == 0 || this.absenceCode == 7 || this.absenceCode == 8)
	    			&& this.workingDate.day != 0
    				&& this.workingDate.day != 6 ) {
					this.recessHours = calculateLunchHours(this.startTime, this.quittingTime);
				}
				// 2010.06.20 add end   昼休憩時間の計算
        		// 休憩時間が入力済みならば
        		if (this.recessHours) {
        			// 実働時間の計算
        			this.realWorkingHours = this.workingHours - this.recessHours;
        		} else {
        			this.realWorkingHours = this.workingHours;
        		}
        		
        		// 深夜勤務の判定
				var nightTime:Date = new Date(this.startTime);
				// TODO:時間はマスタから取得する
				nightTime.setHours(23,0,0,0);
				
				// TODO:時間はマスタから取得する
        		if (this.quittingTime >= nightTime
        			&& this.realWorkingHours >= 10.5) {
        			this.nightWorkFlg = true;
        		} else {
        			this.nightWorkFlg = false;
        		}
	    	} else {
	    		this.recessHours = 0;
	    	}
	    	
			// 早退控除数の計算
    		// 平日で勤休コード未設定、開始・終了時刻が入力済みならば
			var earlyHours:Number = 0;
    		if (this.holidayName == null
    		    && this.absenceCode == 0
    			&& this.workingDate.day != 0
    			&& this.workingDate.day != 6
    			&& this.startTime
    			&& this.quittingTime) {
				
    			// 早退判定基準時刻の取得
    			var earlyTime:Date = new Date(startTime);
    			earlyTime.setHours(14,30,0,0);
    			var baseTime:Date = new Date(startTime);
    			baseTime.setHours(9,30,0,0);
    			if (this.staggeredStartTime)
    			{
    				var addTimes:Number = (this.staggeredStartTime.getTime() - baseTime.getTime());
    				earlyTime = new Date(earlyTime.getTime() + addTimes);
    			}
				if (this.quittingTime < earlyTime) {
					// 昼休憩時間の計算
					var lunchHours:Number = calculateLunchHours(this.startTime, this.quittingTime);
					// 早退時間の計算
					earlyHours = (earlyTime.getTime() - this.quittingTime.getTime()) / (60 * 60 * 1000);
					// 補正
					var lunchTerms:Number = (this.LunchEndTime.getTime() - this.LunchStartTime.getTime()) / (60 * 60 * 1000);
					if (lunchHours < lunchTerms)
					{
						earlyHours -= (lunchTerms - lunchHours);
					}
					//trace (" lunchHours : " + lunchHours);
					//trace (" earlyHours : " + earlyHours);
					//trace (" ");					
				}
				// 実働が4時間以上ならば早退とはみなさない。
				// 9:30より前に出社した場合は14:30以前に帰宅しても早退にはならない。
				if (this.realWorkingHours >= 4)
				{
					earlyHours = 0;
				}
				else
				{
//					if (earlyHours > 4 - this.realWorkingHours)
//					{
//						earlyHours = 4 - this.realWorkingHours;
//					}
				}
			}
    			
			// 私用時間控除数の計算
			// 当面。私用時間は控除しない
//			if (this.holidayName == null
//				&& this.workingDate.day != 0
//				&& this.workingDate.day != 6
//				&& this.privateHours > 0) {
//				var privateHoursDeduction:Number = 0;
//				for each(var lateDeduction2:Object in lateDeductionList) {
//					// 私用時間が範囲内ならば
//					if (lateDeduction2.fromHours < this.privateHours
//						&& this.privateHours <= lateDeduction2.toHours) {
//						privateHoursDeduction = lateDeduction2.deductionDays;
//						break;
//					}
//				}
//				this.deductionCount += privateHoursDeduction;
//    		}
			var myHours:Number = 0;
			if (this.holidayName == null
				&& this.absenceCode == 0
				&& this.workingDate.day != 0
    			&& this.workingDate.day != 6){
				myHours = this.privateHours;
			}
			

			// 控除数の計算（遅刻＋早退＋私用）
			var deductionHours:Number = lateHours + earlyHours + myHours;
       		for each(var lateDeduction:Object in lateDeductionList) {
       			// 勤務時間が範囲内ならば
       			if (lateDeduction.fromHours < deductionHours
       				&& deductionHours <= lateDeduction.toHours) {
       				this.deductionCount = lateDeduction.deductionDays;
       				break;
       			}
       		}
		
		}
		
		/**
		 * 昼休憩時間の計算
		 * 
		 * @param sTime 勤務開始時間
		 * @param qTime 勤務終了時間
		 */
		private function calculateLunchHours(sTime:Date, qTime:Date):Number
		{
			// 勤務時間が未設定ならば
			if (!(sTime && qTime))	return 0;
			// 勤務時間がねじれならば
			if (sTime >= qTime)		return 0;
			// 勤務中に昼休憩をとっていないならば
			if (qTime <= this.LunchStartTime)	return 0;
			if (sTime >= this.LunchEndTime)		return 0;		
		
			// 昼休憩時間の計算
			var lunchStart:Number = this.LunchStartTime.getTime();
			var lunchEnd:Number   = this.LunchEndTime.getTime();
			if (sTime > this.LunchStartTime)
			{	
				lunchStart = sTime.getTime();
			}
			if (qTime < this.LunchEndTime)		
			{
				lunchEnd = qTime.getTime();
			}
			
			return (lunchEnd - lunchStart) / (60 * 60 * 1000);
		}
		// 昼休憩開始時間		
		private function get LunchStartTime():Date
		{
			var time:Date = new Date(this.startTime);
			time.setHours(12,0,0,0);
			return time;
		}
		// 昼休憩終了時間		
		private function get LunchEndTime():Date
		{
			var time:Date = new Date(this.startTime);
			time.setHours(13,0,0,0);
			return time;
		}
	}
	
}