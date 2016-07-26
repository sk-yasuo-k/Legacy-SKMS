package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;

	/**
	 * 基本給【号】リストDtoです。
	 *
	 * @author t-ito
	 *
	 */	
	public class MBasicRankListDto
	{
		private var mBasicRankList:ArrayCollection;
		
		public function MBasicRankListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var mBasicRankDto:MBasicRankDto in object)
			{	
				tmpArray.push(mBasicRankDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mBasicRankList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MBasicRankList():ArrayCollection
		{
			// リストを取得元に返す	
			return mBasicRankList;
		}		
	}
}