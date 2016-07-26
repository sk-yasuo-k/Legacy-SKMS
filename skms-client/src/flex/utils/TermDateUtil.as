package utils
{
	import mx.controls.DateField;
	import mx.utils.ObjectUtil;

	/**
	 * xx期を扱うときに使用する静的なクラスです。
	 *
	 */
	public class TermDateUtil
	{
		/** xx期の定義 */
		private static var TERM_BEGINNING_YEAR:int  = 1984				// 会社設立.
		private static var TERM_BEGINNING_MONTH:int = 10;				// XX期開始月.

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * Date から xx期への変換.
		 *
		 * @param  date 日時.
		 * @return xx期.
		 */
		 public static function convertTerm(date:Date):String
		 {
			if (!date)		return null;

		 	// term を計算する.
		 	var term:int = 0;
			if (date.getMonth() + 1 >= TERM_BEGINNING_MONTH)
				term = date.getFullYear() - TERM_BEGINNING_YEAR + 1;
			else
				term = date.getFullYear() - TERM_BEGINNING_YEAR;

			return term.toString();
		 }

		/**
		 * Date から xx上期/下期への変換.
		 *
		 * @param  date 日時.
		 * @return 上期/下期.
		 */
		 public static function convertTermHalf(date:Date):String
		 {
			if (!date)		return null;

		 	// term を計算する.
		 	var term:String = convertTerm(date);
		 	var half:String = convertHalf(date);

			return term + half;
		 }

		 /**
		  * Date から 上期/下期への変換.
		  *
		 * @param  term 日時.
		 * @return 上期/下期.
		  */
		 private static function convertHalf(date:Date):String
		 {
		 	var month:int = date.getMonth() + 1;
		 	var half:String = "上";
		 	if (month <  TERM_BEGINNING_MONTH && month >= TERM_BEGINNING_MONTH - 6)		half = "下";
	 		return half;
		 }

		/**
		 * yyyymm から xx期への変換.
		 *
		 * @param  yyyymm 日時.
		 * @return xx期.
		 */
		 public static function convertTermFromYYYYMM(yyyymm:String):String
		 {
		 	// day が未設定だと変換されないため "01" を付加する.
		 	var date:Date;
		 	if (yyyymm.indexOf("/") > 0) 	date = DateField.stringToDate(yyyymm + "/01", "YYYY/MM/DD");
		 	else 					 		date = DateField.stringToDate(yyyymm + "01",  "YYYYMMDD");
		 	if (!date)		return null;

		 	return convertTerm(date);
		 }

		/**
		 * yyyymm から xx上期/下期への変換.
		 *
		 * @param  yyyymm 日時.
		 * @return xx期.
		 */
		 public static function convertTermHalfFromYYYYYMM(yyyymm:String):String
		 {
		 	// day が未設定だと変換されないため "01" を付加する.
		 	var date:Date;
			if (yyyymm.indexOf("/") > 0) 	date = DateField.stringToDate(yyyymm + "/01", "YYYY/MM/DD");
			else 					 		date = DateField.stringToDate(yyyymm + "01",  "YYYYMMDD");
		 	if (!date)		return null;

		 	var term:String = convertTerm(date);
		 	var half:String = convertHalf(date);
			return term + half;
		 }


		/**
		 * 今期の開始日時の取得.
		 *
		 * @return xx期の開始日時.
		 */
		public static function getStartDateCurrent():Date
		{
			var term:String = convertTerm(new Date());
			return convertStartDate(term);
		}

		/**
		 * 今期の終了日時の取得.
		 *
		 * @return xx期の終了日時.
		 */
		public static function getFinishDateCurrent():Date
		{
			var term:String = convertTerm(new Date());
			return convertFinishDate(term);
		}


		/**
		 * xx期からxx期の開始日時への変換.
		 *
		 * @param term xx期.
		 * @return 開始日時.
		 */
		public static function convertStartDate(term:String):Date
		{
			if (isNaN(Number(term)))	return null;

			var year:int  = TERM_BEGINNING_YEAR + int(term) - 1;
			var date:Date = new Date(year, TERM_BEGINNING_MONTH - 1, 1);
			return date;
		}

		/**
		 * xx上/下期からxx上/下期の開始日時への変換.
		 *
		 * @param term xx期上/下.
		 * @return 開始日時.
		 */
		public static function convertStartDate2(termhalf:String):Date
		{
			var firstTerm:String = termhalf.replace("上", "");
			var lastTerm:String  = termhalf.replace("下", "");

			var term:String = null;
			var firstFlg:Boolean = false;
			if (ObjectUtil.compare(termhalf, firstTerm) == 0) {
				term = String(lastTerm);
				firstFlg = false;
			}
			else if (ObjectUtil.compare(termhalf, lastTerm) == 0) {
				term = String(firstTerm);
				firstFlg = true;
			}
			if (isNaN(Number(term)))	return null;

			var year:int  = TERM_BEGINNING_YEAR + int(term) - 1;
			var date:Date = new Date(year, TERM_BEGINNING_MONTH - 1 + (firstFlg ? 0 : 6), 1);
			return date;
		}

		/**
		 * xx期からxx期の終了日時への変換.
		 *
		 * @param term xx期.
		 * @return 終了日時.
		 */
		public static function convertFinishDate(term:String):Date
		{
			if (isNaN(Number(term)))	return null;

//			// 今期かどうか確認する.
//			var nowterm:String = convertTerm(new Date());
//			if (ObjectUtil.compare(nowterm, term) == 0) {
//				return getFinishDateCurrent(true);
//			}
//			else {
				var sdate:Date = convertStartDate(term);
				var date:Date  = new Date(sdate.getFullYear() +  1, sdate.getMonth(), sdate.getDate() - 1);
				return date;
//			}
		}

		/**
		 * xx上/下期からxx上/下期の終了日時への変換.
		 *
		 * @param term xx上/下期.
		 * @return 終了日時.
		 */
		public static function convertFinishDate2(termhalf:String):Date
		{
			var firstTerm:String = termhalf.replace("上", "");
			var lastTerm:String  = termhalf.replace("下", "");

			var term:String = null;
			var firstFlg:Boolean = false;
			if (ObjectUtil.compare(termhalf, firstTerm) == 0) {
				term = String(lastTerm);
				firstFlg = false;
			}
			else if (ObjectUtil.compare(termhalf, lastTerm) == 0) {
				term = String(firstTerm);
				firstFlg = true;
			}
			if (isNaN(Number(term)))	return null;

			var sdate:Date = convertStartDate(term);
			var date:Date  = new Date(sdate.getFullYear() +  1, sdate.getMonth() - (firstFlg ? 6 : 0), sdate.getDate());
			date.setMonth(sdate.getMonth(), sdate.getDate() - 1);
			return date;
		}

//		/**
//		 * 開始日時から開始日時への変換.
//		 *
//		 * @param date 開始日時.
//		 * @return 開始日時.
//		 */
//		public static function convertStartDate22222(date:Date):Date
//		{
//			if (date)		return date;
//
//			// 未設定の時は 1期 の日時を設定する.
//			var sdate:Date = convertStartDate("1");
//			return sdate;
//		}
//
//		/**
//		 * 終了日時から終了日時への変換.
//		 *
//		 * @param date 終了日時.
//		 * @return 終了日時.
//		 */
//		public static function convertFinishDate22222(date:Date):Date
//		{
//			if (date)		return date;
//
//			// 未設定の時は 現在日時を設定する.
//			var fdate:Date = getCurrentTermFinishDate();
//			return fdate;
//		}

	}
}