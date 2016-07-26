package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MCompetentAllowanceDto")]
	public class MCompetentAllowanceDto
	{	
		/**
		 * 主務手当ID
		 */
		public var competentId:int;
				
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