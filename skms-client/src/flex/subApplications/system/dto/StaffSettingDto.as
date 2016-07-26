package subApplications.system.dto
{
	[Bindable]
	[RemoteClass(alias="services.system.entity.StaffSetting")]
	public class StaffSettingDto
	{
		public function StaffSettingDto()
		{
		}

		/**
		 * 社員IDです.
		 */
		public var staffId:int;

		/**
		 * 交通費に関するメール通知の有無です.
		 */
	    public var sendMailTransportation:Boolean;

		/**
		 * 勤務管理表に関するメール通知の有無です.
		 */
	    public var sendMailWorkingHours:Boolean;

		/**
		 * 時差勤務開始時刻既定値です。
	 	*/
		public var defaultStaggeredStartTime:String;

		/**
		 * 勤務開始時刻既定値です。
	 	*/
		public var defaultStartTime:String;

		/**
		 * 勤務終了時刻既定値です。
	 	*/
		public var defaultQuittingTime:String;

		/**
		 * 時差勤務開始時刻選択肢です。
	 	*/
		public var staggeredStartTimeChoices:String;
		/**
		 * 勤務開始時刻選択肢です。
	 	*/
		public var startTimeChoices:String;

		/**
		 * 勤務終了時刻選択肢です。
	 	*/
		public var quittingTimeChoices:String;
		
		/**
		 * 全メニューの表示可否です。
		 */
		public var allMenu:Boolean;
		
		/**
		 * マイメニューの表示可否です。
		 */
		public var myMenu:Boolean;

	}
}