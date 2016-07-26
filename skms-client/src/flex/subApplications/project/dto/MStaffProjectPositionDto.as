package subApplications.project.dto
{
	import dto.StaffDto;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.MStaffProjectPosition")]
	public class MStaffProjectPositionDto
	{
		public function MStaffProjectPositionDto()
		{
		}
		/**
		 * 社員IDです。
		 */
		public var staffId:int;

		/**
		 * 社員情報です。
		 */
	    public var staff:StaffDto;

		/**
		 * 更新回数です。
		 */
		public var updateCount:int;

		/**
		 * プロジェクト役職IDです。
		 */
		public var projectPositionId:int;

		/**
		 * 適用開始日です。
		 */
		public var applyDate:Date;

		/**
		 * 適用解除日です。
		 */
		public var cancelDate:Date;

		/**
		 * 登録日時です。
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです。
		 */
		public var registrantId:int;
	}
}