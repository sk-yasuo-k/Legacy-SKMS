package subApplications.personnelAffair.skill.dto
{
	/**
	 * ラベルDtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.SkillLabelDto")]
	public class SkillLabelDto
	{
		/**
		 * データ
		 */
		public var data:int;
		
		/**
		 * 表示名
		 */
		public var label:String;
		
		/**
		 * ID
		 */
		public var id:String;
	
		/**
		 * コード
		 */
		public var code:String;
	
		/**
		 * 名称
		 */
		public var name:String;
	}
}
