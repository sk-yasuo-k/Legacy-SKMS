package dto
{
	[Bindable]
	[RemoteClass(alias="services.generalAffair.entity.VCurrentStaffName")]
	public class StaffNameDto
	{
		public function StaffNameDto()
		{
		}

		/**
		 * 社員IDです.
		 */
		public var staffId:int;

		/**
		 * 社員情報です.
		 */
	    public var staff:StaffDto;

		/**
		 * 更新回数です.
		 */
		public var updateCount:int;

		/**
		 * 適用開始日です.
		 */
		public var applyDate:Date;

		/**
		 * 姓です.
		 */
		public var lastName:String;

		/**
		 * 名です.
		 */
		public var firstName:String;

		/**
		 * 姓名です.
		 */
		public var fullName:String;

		/**
		 * 姓(かな)です.
		 */
		public var lastNameKana:String;

		/**
		 * 名(かな)です.
		 */
		public var firstNameKana:String;

		/**
		 * 姓名(かな)です.
		 */
		public var fullNameKana:String;

		/**
		 * 登録日時です.
		 */
		public var registrationTime:Date;

		/**
		 * 登録者IDです.
		 */
		public var registrantId:int;
	}
}