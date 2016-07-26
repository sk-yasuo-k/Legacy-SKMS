package subApplications.accounting.dto
{
	[Bindable]
	[RemoteClass(alias="services.accounting.dto.HistoryDto")]
	public class HistoryDto
	{
		public function HistoryDto()
		{
		}

		/**
		 * 交通費申請IDです。
		 */
		public var transportationId:int;

		/**
		 * 更新回数です。
		 */
		public var updateCount:int;

		/**
		 * 更交通費申請状況IDです。
		 */
		public var transportationStatusId:int;

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

	}
}