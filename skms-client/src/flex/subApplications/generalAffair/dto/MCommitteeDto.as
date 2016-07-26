package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.MCommitteeDto")]
	public class MCommitteeDto
	{				
		/**
		 * 委員会ID
		 */
		public var committeeId:int;
				
		/**
		 * 委員会名
		 */
		public var committeeName:String;
						
		/**
		 * 備考
		 */
		public var note:String;
	}
}