package subApplications.personnelAffair.skill.dto
{
	/**
	 * 社員スキルシート作業フェーズDtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.StaffSkillSheetPhaseDto")]
	public class StaffSkillPhaseDto
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
		 * 作業フェーズIDです。
		 */
		public var phaseId:int;
		
		/**
		 * 作業フェーズコードです。
		 */
		public var phaseCode:String;
		
		/**
		 * 作業フェーズ名です。
		 */
		public var phaseName:String;
		
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