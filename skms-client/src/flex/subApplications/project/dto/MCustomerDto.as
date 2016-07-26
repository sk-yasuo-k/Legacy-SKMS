package subApplications.project.dto
{
	[Bindable]
	[RemoteClass(alias="services.project.entity.MCustomer")]
	public class MCustomerDto
	{
		public function MCustomerDto()
		{
		}
		/**
		 * 顧客IDです。
		 */
		public var customerId:int;

		/**
		 * 顧客区分です。
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
		 * ダミーの作成.
		 *
		 * @return 顧客.
		 */
		 public static function createDummy():MCustomerDto
		 {
			var customer:MCustomerDto = new MCustomerDto();
			customer.customerId = -99;
			customer.customerType = "";
			customer.customerNo = "";
			customer.customerName = "";
		 	return customer;
		 }
	}
}