package subApplications.accounting.dto
{
	
	import dto.StaffNameDto;
	
	[Bindable]
	[RemoteClass(alias="services.accounting.entity.CommutationHistory")]
	
	public class CommutationHistoryDto
	{

		/**
		 * 社員IDです.
		 */
		public var staffId:int;
	
		/**
		 * 社員名です.
		 */
		public var staffName:StaffNameDto;
		
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
		 * 通勤費手続き状態です.
		 */
		public var commutationStatus:MCommutationStatusDto;
		
		/**
		 * 通勤費手続き動作IDです.
		 */
		public var commutationActionId:int;

		/**
		 * 通勤費手続き動作です.
		 */
		public var commutationAction:MCommutationActionDto;
		
		
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
		 * 通勤費情報です。
		 */
	    public var commutation:CommutationDto;


		public function CommutationHistoryDto()
		{
		}

	}
}