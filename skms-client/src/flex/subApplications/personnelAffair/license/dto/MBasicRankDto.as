package subApplications.personnelAffair.license.dto
{	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MBasicPayDto")]
	public class MBasicRankDto
	{
		/**
		 * 基本給ID
		 */
		public var basicPayId:int;
	    
		/**
		 * 等級ID
		 */
		public var classNo:int;
		
		/**
		 * 号
		 */
		public var rankNo:int;
		
		/**
		 * 月額
		 */
		public var monthlySum:int;
	}
}