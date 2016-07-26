package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MTechnicalSkillAllowanceDto")]
	public class MTechnicalSkillAllowanceDto
	{	
		/**
		 * 技能手当ID
		 */
		public var technicalSkillId:int;
				
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