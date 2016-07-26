package subApplications.generalAffair.dto
{
	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.MWorkingHoursAction")]
	
	public class MWorkingHoursActionDto
	{
		/**
		 * 勤務管理表手続き動作種別IDです.
		 */
		public var workingHoursActionId:int;
	
		/**
		 * 勤務管理表手続き動作種別名です.
		 */
		public var workingHoursActionName:String;
	
	}
}