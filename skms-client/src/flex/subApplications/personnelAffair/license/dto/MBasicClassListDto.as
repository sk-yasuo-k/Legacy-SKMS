package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 基本給【等級】リストDtoです。
	 *
	 * @author t-ito
	 *
	 */	
	public class MBasicClassListDto
	{
		private var mBasicClassList:ArrayCollection;
		
		public function MBasicClassListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var basicClassDto:MBasicClassDto in object)
			{	
				tmpArray.push(basicClassDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mBasicClassList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MBasicClassList():ArrayCollection
		{
			// リストを取得元に返す	
			return mBasicClassList;
		}		
	}
}