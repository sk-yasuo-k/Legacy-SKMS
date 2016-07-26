package subApplications.customer.dto
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="services.customer.dto.CustomerSearchDto")]
	public class CustomerSearchDto
	{
		public function CustomerSearchDto()
		{
		}

		/**
		 * 顧客区分リストです。
		 */
	    public var customerTypeList:ArrayCollection;

		/**
		 * 顧客区分リストです。
		 */
	    public var customerType:String;

		/**
		 * 顧客番号です。
		 */
		public var customerNo:String;

		/**
		 * 顧客名称です。
		 */
		public var customerName:String;

		/**
		 * 顧客略称です。
		 */
		public var customerAlias:String;

		/**
		 * 顧客コードです。（顧客種別＋顧客番号）
		 */
		public var customerCode:String;
	}
}