package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MManagerialAllowanceDto")]
	public class MManagerialAllowanceDto
	{	
		/**
		 * 職務手当ID
		 */
		public var managerialId:int;
				
		/**
		 * 等級
		 */
		public var classNo:int;
				
		/**
		 * 月額
		 */
		public var monthlySum:int;
	}
}