package subApplications.personnelAffair.skill.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * ラベルリストDtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	public class SkillLabelListDto
	{
		/**
		 * ラベルリスト
		 */
		private var _labelList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function SkillLabelListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:SkillLabelDto in object){
				tmpArray.push(tmp);
			} 
			_labelList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * ラベルリスト取得
		 */
		public function get LabelList():ArrayCollection
		{
			return _labelList;
		}
	}
}