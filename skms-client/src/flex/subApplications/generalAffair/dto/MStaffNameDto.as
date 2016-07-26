package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.MStaffNameDto")]
	public class MStaffNameDto
	{
		/**
		 * 社員ID
		 */
		public var staffId:int;
		
		/**
		 * 更新回数
		 */
		public var updateCount:int;
		
		/**
		 * 適用開始日
		 */
		public var applyDate:Date;
		
		/**
		 * 姓(漢字)
		 */
		public var lastName:String;
		
		/**
		 * 名(漢字)
		 */
		public var firstName:String;
		
		/**
		 * 姓(フリガナ)
		 */
		public var lastNameKana:String;
				
		/**
		 * 名(フリガナ)
		 */
		public var firstNameKana:String;
						
		/**
		 * 登録日時
		 */
		public var registrationTime:Date;
		
		/**
		 * 登録ID
		 */
		public var registrantId:int;	
	}
}