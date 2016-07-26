package subApplications.accounting.dto
{
	import mx.collections.ArrayCollection;


	[Bindable]
	[RemoteClass(alias="services.accounting.dto.ProjectTransportationMonthlySearchDto")]
	public class TransportationMonthlySearchDto
	{
		public function TransportationMonthlySearchDto()
		{
			;
		}

		/**
		 * 集計期間 開始 です.
		 */
	    public var startDate:Date;

		/**
		 * 集計期間 終了 です.
		 */
	    public var finishDate:Date;

		/**
		 * 集計状態リスト です.
		 */
		public var statusList:ArrayCollection;

		/**
		 * 集計基準日 です.
		 */
	    public var baseDateType:int;

		/**
		 * 集計基準 プロジェクト です.
		 */
		public var isProjectMonthly:Boolean;

		/**
		 * (詳細)オブジェクトIDです.
		 */
		public var objectId:String;

		/**
		 * (詳細)オブジェクト種別です。
		 */
		public var objectType:int;

		/**
		 * (詳細)オブジェクトコードです.
		 */
		public var objectCode:String;

		/**
		 * (詳細)オブジェクト名です.
		 */
		public var objectName:String;

		/**
		 * (詳細)集計開始日付です.
		 */
		public var objectStartDate:Date;

		/**
		 * (詳細)集計終了日付です.
		 */
		public var objectFinishDate:Date;
	}
}