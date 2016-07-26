package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MInformationAllowanceDto")]
	public class MInformationAllowanceDto
	{	
		/**
		 * 情報処理手当ID
		 */
		public var informationPayId:int;
				
		/**
		 * 資格手当名
		 */
		public var informationPayName:String;
				
		/**
		 * 月額
		 */
		public var monthlySum:int;
		
		/**
		 * 備考
		 */
		public var note:String;			
	}
}