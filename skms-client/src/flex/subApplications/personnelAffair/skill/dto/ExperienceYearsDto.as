package subApplications.personnelAffair.skill.dto
{
	/**
	 * 経験年数Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	public class ExperienceYearsDto
	{
		/**
		 * 制御系です。
		 */
		public var control:Number;
		
		/**
		 * 業務系です。
		 */
		public var open:Number;
		
		/**
		 * 保守です。
		 */
		public var maintenance:Number;
		
		public function ExperienceYearsDto()
		{
			control = 0.0;
			open = 0.0;
			maintenance = 0.0;
		}

	}
}