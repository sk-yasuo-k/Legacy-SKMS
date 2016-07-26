package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 職務手当リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MManagerialAllowanceListDto
	{
		private var mManagerialAllowanceList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MManagerialAllowanceListDto(object:Object)
		{
			var array:Array = new Array();
			
			for each(var mManagerialAllowanceDto:MManagerialAllowanceDto in object)
			{
				array.push(mManagerialAllowanceDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mManagerialAllowanceList = new ArrayCollection(array);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MManagerialAllowanceList():ArrayCollection
		{
			// リストを取得元に返す	
			return mManagerialAllowanceList;
		}
	}	
}
