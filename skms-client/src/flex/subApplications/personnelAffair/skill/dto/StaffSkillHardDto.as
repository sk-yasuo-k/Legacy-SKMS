package subApplications.personnelAffair.skill.dto
{
	/**
	 * 社員スキルシートハードDtoです。
	 *
	 * @author kentaro-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.StaffSkillSheetHardDto")]
	public class StaffSkillHardDto
	{
		/**
		 * 社員IDです。
		 */
		public var staffId:int;
		
		/**
		 * スキルシート連番です。
		 */
		public var sequenceNo:int;
		
		/**
		 * ハードIDです。
		 */
		public var hardId:int;
		
//		/**
//		 * ハードコードです。
//		 */
//		public var hardCode:String;
		
		/**
		 * ハード名です。
		 */
		public var hardName:String;
		
		/**
		 * 登録日時です。
		 */
		public var registrationTime:Date;
		
		/**
		 * 登録者です。
		 */
		public var registrantId:int;
		

	}
}