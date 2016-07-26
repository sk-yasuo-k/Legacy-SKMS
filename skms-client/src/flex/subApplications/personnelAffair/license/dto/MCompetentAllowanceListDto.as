package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 主務手当リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MCompetentAllowanceListDto
	{
		private var mCompetentAllowanceList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MCompetentAllowanceListDto(object:Object)
		{
			var array:Array = new Array();
			
			for each(var mCompetentAllowanceDto:Object in object)
			{
				array.push(mCompetentAllowanceDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mCompetentAllowanceList = new ArrayCollection(array);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MCompetentAllowanceList():ArrayCollection
		{
			// リストを取得元に返す	
			return mCompetentAllowanceList;
		}
	}	
}
