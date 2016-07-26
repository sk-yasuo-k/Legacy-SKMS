package subApplications.generalAffair.dto
{
	import dto.StaffNameDto;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.WorkingHoursHistory")]
	
	public class WorkingHoursHistoryDto
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
		 * 更新回数です.
		 */
		public var updateCount:int;

		/**
		 * 勤務管理表手続き状態IDです.
		 */
		public var workingHoursStatusId:int;

		/**
		 * 勤務管理表手続き状態です.
		 */
		public var workingHoursStatus:MWorkingHoursStatusDto;

		/**
		 * 勤務管理表手続き動作IDです.
		 */
		public var workingHoursActionId:int;

		/**
		 * 勤務管理表手続き動作です.
		 */
		public var workingHoursAction:MWorkingHoursActionDto;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです.
		 */
		public var registrantId:int;

		/**
		 * 登録者氏名です.
		 */
		public var registrantName:String;

		/**
		 * コメントです.
		 */
		public var comment:String;

		/**
		 * 勤務時間(月別)情報です。
		 */
	    public var workingHoursMonthly:WorkingHoursMonthlyDto;

	}
}