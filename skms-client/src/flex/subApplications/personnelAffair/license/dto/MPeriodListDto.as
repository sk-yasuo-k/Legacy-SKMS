package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
		
	/**
	 * 期リストDtoです。
	 *
	 * @author n-sumi
	 *
	 */	
	public class MPeriodListDto
	{	
		private var mPeriodList:ArrayCollection;
				
		public function MPeriodListDto(object:Object)
		{
			var array:Array = new Array();
			
			for each(var mPeriodDto:MPeriodDto in object)
			{	
				array.push(mPeriodDto);
			} 
			// DTOの型に変換したものを、リストに追加する
			mPeriodList = new ArrayCollection(array);
		}
		
		/**
		 * リスト取得
		 */	
		public function get MPeriodList():ArrayCollection
		{
			// リストを取得元に返す	
			return mPeriodList;
		}		

	}
}