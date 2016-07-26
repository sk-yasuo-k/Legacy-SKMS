package subApplications.accounting.dto
{

	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	import dto.StaffDto;

	[Bindable]
	[RemoteClass(alias="services.accounting.entity.Commutation")]

	public class CommutationDto
	{
		public function CommutationDto()
		{
		}

		/** 社員ID */
		public var staffId:int;

		/** 通勤費月コード */
		public var commutationMonthCode:String;
		
		/** 登録日時 */
		public var registrationTime:Date;
		
		/** 登録者ID */
		public var registrantId:int;

		/** 登録バージョン */
		public var registrationVer:Number;

		/** 合計金額 */
		public var expenseTotal:String;

		/** 払戻金額 */
		public var repayment:String;

		/** 差引支給金額 */
		public var payment:String;

		/** 備考 */
		public var note:String;

		/** 担当者備考 */
		public var noteCharge:String;

		/** 通勤費詳細リスト */
		public var commutationDetails:ArrayCollection;
		
		/** 通勤費手続き履歴情報です.*/
		public var commutationHistories:ArrayCollection;

	}
}