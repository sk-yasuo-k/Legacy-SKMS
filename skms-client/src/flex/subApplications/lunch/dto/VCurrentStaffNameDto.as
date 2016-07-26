package subApplications.lunch.dto
{
	[Bindable]
	[RemoteClass(alias="services.lunch.dto.VCurrentStaffNameDto")]
	public class VCurrentStaffNameDto
	{
		/**社員IDです。*/
		public var staffId:int;
		
		/** 姓です。*/
		public var lastName:String;
	
		/** 名です。*/
		public var firstName:String;
	
		/** 姓(かな)です。*/
		public var lastNameKana:String;
	
		/** 名(かな)です。*/
		public var firstNameKana:String;
		
		/** 姓名です。*/
		public var fullName:String;
	
		/** 姓名(かな)です。*/
		public var fullNameKana:String;	

	}
}