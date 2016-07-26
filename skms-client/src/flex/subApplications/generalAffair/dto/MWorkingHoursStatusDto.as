package subApplications.generalAffair.dto
{
	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.MWorkingHoursStatus")]
	
	public class MWorkingHoursStatusDto
	{
		/**
		 * 勤務管理表手続き状態種別IDです.
		 */
		public var workingHoursStatusId:int;
	
		/**
		 * 勤務管理表手続き状態種別名です.
		 */
		public var workingHoursStatusName:String;
	
		/**
		 * 勤務管理表手続き状態表示色です.
		 */
		public var workingHoursStatusColor:int;
	
	}
}