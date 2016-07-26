package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.StaffWorkingHoursDto")]

	public class StaffWorkingHoursDto
	{
		/**
		 * 社員IDです.
		 */
		public var staffId:int;

		/**
		 * 社員氏名です.
		 */
		public var staffName:String;

		/**
		 * 就労状況種別IDです.
		 */
		public var workStatusId:int;

		/**
		 * 月別集計リストです.
		 */
		public var monthlyList:ArrayCollection;
	}
}