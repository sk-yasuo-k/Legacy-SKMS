package subApplications.personnelAffair.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.dto.MStaffDto")]
	public class MStaffDto
	{
		/**
		 * 社員ID
		 */
		public var staffId:int;
		
		/**
		 * 社員名(フル)です。
		 */
		public var fullName:String;
		
//		/**
//		 * 社員所持認定資格です。
//		 */
//		public var mStaffAuthorizedLicence:ArrayCollection;
//		
//		/**
//		 * 社員所持その他資格です。
//		 */
//		public var mStaffOtherLocence:ArrayCollection;
	}
}