package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;

	/**
	 * 技能手当ラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MTechnicalSkillAllowanceLabelDto
	{
		private var mTechnicalSkillAllowanceLabel:ArrayCollection;	
		
		/**
		 * コンストラクタ
		 */
		public function MTechnicalSkillAllowanceLabelDto(object:Object)
		{
			var array:Array = new Array();
			var nullFalg:Boolean = true;

			for each(var mTechnicalSkillAllowanceDto:MTechnicalSkillAllowanceDto in object)
			{				
				var tmp:LabelDto = new LabelDto();			
				var Label:String = "" + mTechnicalSkillAllowanceDto.classNo;
					
				tmp.label = Label;
				tmp.data = mTechnicalSkillAllowanceDto.technicalSkillId;
				tmp.data3 = mTechnicalSkillAllowanceDto.monthlySum;	

				array.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			mTechnicalSkillAllowanceLabel = new ArrayCollection(array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get MTechnicalSkillAllowanceLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return mTechnicalSkillAllowanceLabel;
		}
	}	
}
