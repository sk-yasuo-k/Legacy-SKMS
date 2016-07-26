package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;


	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.LunchOrderWeekDto")]
	public class LunchOrderWeekDto
	{
		public function LunchOrderWeekDto()
		{
		}

		/** 注文情報 */
		public var lunchOrders:ArrayCollection;

	}
}