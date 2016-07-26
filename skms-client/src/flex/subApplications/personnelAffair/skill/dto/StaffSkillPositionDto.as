package subApplications.personnelAffair.skill.dto
{
	/**
	 * 社員スキルシート参加形態Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.StaffSkillSheetPositionDto")]
	public class StaffSkillPositionDto
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
		 * 参加形態IDです。
		 */
		public var positionId:int;
		
		/**
		 * 参加形態コードです。
		 */
		public var positionCode:String;
		
		/**
		 * 参加形態名です。
		 */
		public var positionName:String;
		
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