package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 店舗一覧Dto
	 * @author t-ito
	 */
	public class MLunchShopDtoList
	{
		private var _shopList:ArrayCollection;
		
		public function MLunchShopDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:MLunchShopDto in obj) {
				tmpArray.push(tmp);
			}
			
			_shopList = new ArrayCollection(tmpArray);
		}

		public function get shopList():ArrayCollection
		{
			return _shopList; 
		}
	}
}