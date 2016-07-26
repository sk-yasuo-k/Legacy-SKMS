package subApplications.accounting.dto
{
	import mx.collections.ArrayCollection;


	[Bindable]
	[RemoteClass(alias="services.accounting.dto.ProjectTransportationDto")]
	public class TransportationMonthlyDto
	{
		public function TransportationMonthlyDto()
		{
			;
		}

		/**
		 * オブジェクトIDです.
		 */
		public var objectId:int;

		/**
		 * オブジェクト種別です。
		 */
		public var objectType:int;

		/**
		 * オブジェクトコードです.
		 */
		public var objectCode:String;

		/**
		 * オブジェクト名です.
		 */
		public var objectName:String;

		/**
		 * 集計リストです.
		 */
		public var monthyList:ArrayCollection;
	}
}