package subApplications.accounting.dto
{
	
	import dto.StaffNameDto;
	
	[Bindable]
	[RemoteClass(alias="services.accounting.dto.CommutationSummaryDto")]
	
	public class CommutationSummaryDto
	{

		/**
		 * 社員IDです.
		 */
		public var staffId:int;
	
		/**
		 * 社員名です.
		 */
		public var fullName:String;
		
		/**
		 * 通勤月コードです.
		 */
		public var commutationMonthCode:String;
		
		/**
		 * 更新回数です.
		 */
		public var updateCount:int;
		
		/**
		 * 通勤費手続き状態IDです.
		 */
		public var commutationStatusId:int;
		
		/**
		 * 通勤費手続き状態種別名です.
		 */
		public var commutationStatusName:String;
		
		/**
		 * 通勤費手続き状態表示色です.
		 */
		public var commutationStatusColor:int;
		
		/**
		 * 通勤費手続き動作IDです.
		 */
		public var commutationActionId:int;

		/**
		 * 通勤費手続き動作種別名です.
		 */
		public var commutationActionName:String;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです.
		 */
		public var registrantId:int;

		/**
		 * 登録者氏名です.
		 */
		public var registrantName:String;

		/**
		 * コメントです.
		 */
		public var comment:String;
		
		/**
		 * 差引支給金額です。
		 */
	    public var payment:int;

		/**
		 * 前月差引支給金額です。
		 */
	    public var lastPayment:int;

		/**
		 * 差引支給金額表示色です。
		 */
	    public var paymentColor:int;

	}
}