package subApplications.generalAffair.dto
{
	import dto.StaffNameDto;

	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.StaffWorkingHoursSearchDto")]

	public class StaffWorkingHoursSearchDto
	{
		/**
		 * プロジェクトコードです.
		 */
		public var projectCode:String;

		/**
		 * プロジェクト名です.
		 */
		public var projectName:String;

		/**
		 * 社員名です.
		 */
		public var staffName:String;

		/**
		 * 集計期間 開始 です.
		 */
	    public var startDate:Date;

		/**
		 * 集計期間 終了 です.
		 */
	    public var finishtDate:Date;

	}
}