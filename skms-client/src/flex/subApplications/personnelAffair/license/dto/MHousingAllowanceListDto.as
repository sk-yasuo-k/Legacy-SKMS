package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 住宅手当リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MHousingAllowanceListDto
	{
		private var mHousingAllowanceList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MHousingAllowanceListDto(object:Object)
		{
			var array:Array = new Array();
			
			for each(var mHousingAllowanceDto:MHousingAllowanceDto in object)
			{
				array.push(mHousingAllowanceDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mHousingAllowanceList = new ArrayCollection(array);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MHousingAllowanceList():ArrayCollection
		{
			// リストを取得元に返す	
			return mHousingAllowanceList;
		}
	}	
}
