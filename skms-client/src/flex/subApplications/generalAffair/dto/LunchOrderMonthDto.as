package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;


	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.LunchOrderMonthDto")]
	public class LunchOrderMonthDto
	{
		public function LunchOrderMonthDto()
		{
		}

		/** 注文情報 */
		public var lunchOrderWeeks:ArrayCollection;

	}
}