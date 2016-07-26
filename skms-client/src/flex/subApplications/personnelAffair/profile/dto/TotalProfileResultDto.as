package subApplications.personnelAffair.profile.dto
{
	/**
	 * プロフィール集計結果Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	public class TotalProfileResultDto
	{
		/**
		 * 社員数です。
		 */
		private var countStaff:int = 0;
		
		/**
		 * 合計年齢です。
		 */
		private var totalAge:int = 0;
		
		/**
		 * 平均年齢です。
		 */
		private var averageAge:Number = 0.0;
		
		/**
		 * A型人数です。
		 */
		private var countA:int = 0;
		
		/**
		 * B型人数です。
		 */
		private var countB:int = 0;
		
		/**
		 * O型人数です。
		 */
		private var countO:int = 0;
		
		/**
		 * AB型人数です。
		 */
		private var countAB:int = 0;
		
		//追加 @auther okamoto
		/**
		 * 血液型不明人数です。
		 */
		private var countUnknown:int = 0;
		
		
		/**
		 * コンストラクタ
		 */
		public function TotalProfileResultDto()
		{
		}
		
		/**
		 * 社員数の取得
		 * 
		 * @return 社員数
		 */
		public function get CountStaff():int
		{
			return countStaff;
		}
		
		/**
		 * 社員数の設定
		 * 
		 * @param 社員数
		 */
		public function set CountStaff(_countStaff:int):void
		{
			countStaff = _countStaff;
		}
		
		/**
		 * 合計年齢の取得
		 * 
		 * @return 合計年齢
		 */
		public function get TotalAge():int
		{
			return totalAge;
		}
		
		/**
		 * 合計年齢の設定
		 * 
		 * @param 合計年齢
		 */
		public function set TotalAge(_totalAge:int):void
		{
			totalAge = _totalAge;
		}
		
		/**
		 * 平均年齢の取得
		 * 
		 * @return 平均年齢
		 */
		public function get AverageAge():Number
		{
			return averageAge;
		}
		
		/**
		 * 平均年齢の設定
		 * 
		 * @param 平均年齢
		 */
		public function set AverageAge(_averageAge:Number):void
		{
			// 小数点以下2位で四捨五入する
			_averageAge = Math.round(_averageAge*100)/100;
			
			averageAge = _averageAge;
		}
		
		/**
		 * A型人数の取得
		 * 
		 * @return A型人数
		 */
		public function get CountA():int
		{
			return countA;
		}
		
		/**
		 * A型人数の設定
		 * 
		 * @param A型人数
		 */
		public function set CountA(_countA:int):void
		{
			countA = _countA;
		}
		
		/**
		 * B型人数の取得
		 * 
		 * @return B型人数
		 */
		public function get CountB():int
		{
			return countB;
		}
		
		/**
		 * B型人数の設定
		 * 
		 * @param B型人数
		 */
		public function set CountB(_countB:int):void
		{
			countB = _countB;
		}
		
		/**
		 * O型人数の取得
		 * 
		 * @return O型人数
		 */
		public function get CountO():int
		{
			return countO;
		}
		
		/**
		 * O型人数の設定
		 * 
		 * @param O型人数
		 */
		public function set CountO(_countO:int):void
		{
			countO = _countO;
		}
		
		/**
		 * AB型人数の取得
		 * 
		 * @return AB型人数
		 */
		public function get CountAB():int
		{
			return countAB;
		}
		
		/**
		 * AB型人数の設定
		 * 
		 * @param AB型人数
		 */
		public function set CountAB(_countAB:int):void
		{
			countAB = _countAB;
		}
		
		//追加 @auther okamoto
		/**
		 * 血液型不明人数の取得
		 * 
		 * @return 血液型不明人数
		 */
		public function get CountUnknown():int
		{
			return countUnknown;
		}
		
		//追加 @auther okamoto
		/**
		 * 血液型不明人数の設定
		 * 
		 * @param 血液型不明人数
		 */
		public function set CountUnknown(_countUnknown:int):void
		{
			countUnknown = _countUnknown;
		}
	}
}