package subApplications.personnelAffair.profile.dto
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * プロフィール詳細Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.profile.dto.ProfileDetailDto")]	
	public class ProfileDetailDto
	{
		/**
		 * 社員IDです。
		 */
		public var staffId:int;

		/**
		 * 社員画像です。
		 */
		public	var staffImage:ByteArray;

		/**
		 * 勤務地名です。
		 */
		public var workPlaseName:String;	
			
		/**
		 * 社員所持認定資格です。
		 */
		public var mStaffAuthorizedLicence:ArrayCollection;
		
		/**
		 * 社員所持その他資格です。
		 */
		public var mStaffOtherLocence:ArrayCollection;

		/**
		 * セミナー受講履歴です。
		 */
		public var seminarParticipant:ArrayCollection;					
	}
}