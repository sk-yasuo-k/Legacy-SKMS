package subApplications.generalAffair.dto
{
	public class ChangeAddressApprovalDto
	{
		
		/**
		 * 状態
		 */
		public var statusName:String;
		
		/**
		 * 提出ID
		 */
		public var staffId:int;

		/**
		 * 提出者
		 */
		public var fullName:String;
		
		/**
		 * 提出日
		 */
		public var presentTime:Date;
		
		/**
		 * 新住所
		 */
		public var newAddress:String;		
		
		/**
		 * 状態ID
		 */
		public var statusId:int;		
			
	}
}