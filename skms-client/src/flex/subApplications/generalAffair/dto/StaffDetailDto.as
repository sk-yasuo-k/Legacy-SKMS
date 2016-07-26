package subApplications.generalAffair.dto
{
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	public class StaffDetailDto
	{
		public function StaffDetailDto()
		{
		}
		/** 学歴日付 */
		public var AcademicBackgroundDate:Date;
		/** 備考 */
		public var AcademicBackgroundDatenote:String;
	
		/**
		 * 登録時の入力値チェック.
		 */
		public function checkEntry():Boolean
		{
			// 入力値チェック.
			if (isValueDate(this.AcademicBackgroundDate))		return true;
			if (isValueString(this.AcademicBackgroundDatenote))		return true;

			// 入力値なし.
			return false;
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
		 * String データ有無チェック.
		 *
		 * @param value チェックデータ.
		 * @return データ有無.
		 */
		private function isValueString(value:String):Boolean {
			if (value == null)							return false;
			return true;
		}
		/**
		 * 日付の申請入力値チェック.
		 */
		public function checkApply_StaffDate():Boolean
		{
			if (isValueDate(this.AcademicBackgroundDate))	return true;
			return false;
		}

		/**
		 * 備考の申請入力値チェック.
		 */
		public function checkApply_note():Boolean
		{
			// 入力必須でない.
			return true;
		}

	}
}