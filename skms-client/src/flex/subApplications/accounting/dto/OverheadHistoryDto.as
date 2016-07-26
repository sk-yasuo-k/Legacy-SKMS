package subApplications.accounting.dto
{
	[Bindable]
	[RemoteClass(alias="services.accounting.entity.OverheadHistory")]
	public class OverheadHistoryDto
	{
		public function OverheadHistoryDto()
		{
		}

		/**
		 * 諸経費申請IDです。
		 */
		public var overheadId:int;

		/**
		 * 更新回数です。
		 */
		public var updateCount:int;

		/**
		 * 諸経費申請状況IDです。
		 */
		public var overheadStatusId:int;

		/**
		 * 登録日時です。
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです。
		 */
		public var  registrantId:int;

		/**
		 * コメントです。
		 */
		public var comment:String;

		/**
		 *
		 */
		public var overhead:Object;

		/**
		 *
		 */
		public var overheadStatus:Object;
	}
}