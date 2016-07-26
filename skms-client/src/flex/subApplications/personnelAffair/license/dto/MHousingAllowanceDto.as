package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MHousingAllowanceDto")]
	public class MHousingAllowanceDto
	{	
		/**
		 * 住宅手当ID
		 */
		public var housingId:int;
				
		/**
		 * 住宅手当名
		 */
		public var housingName:String;
				
		/**
		 * 月額
		 */
		public var monthlySum:int;
	}
}