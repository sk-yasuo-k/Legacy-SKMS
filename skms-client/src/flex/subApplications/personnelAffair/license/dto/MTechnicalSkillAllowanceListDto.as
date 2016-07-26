package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 技能手当リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MTechnicalSkillAllowanceListDto
	{
		private var mTechnicalSkillAllowanceList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MTechnicalSkillAllowanceListDto(object:Object)
		{
			var array:Array = new Array();
			
			for each(var mTechnicalSkillAllowanceDto:MTechnicalSkillAllowanceDto in object)
			{
				array.push(mTechnicalSkillAllowanceDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mTechnicalSkillAllowanceList = new ArrayCollection(array);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MTechnicalSkillAllowanceList():ArrayCollection
		{
			// リストを取得元に返す	
			return mTechnicalSkillAllowanceList;
		}
	}	
}
