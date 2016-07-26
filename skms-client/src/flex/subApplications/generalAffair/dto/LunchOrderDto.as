package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;


	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.LunchOrderDto")]
	public class LunchOrderDto
	{
		public function LunchOrderDto()
		{
		}

		/** 注文日 */
		public var orderDate:Date

		/** 社員ID */
		public var staffId:int;

		/** 社員名 */
		public var staffName:String;

	}
}