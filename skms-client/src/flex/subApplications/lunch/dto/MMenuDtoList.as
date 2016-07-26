package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	
	/**
	 * メニュー一覧Dto
	 * @author t-ito
	 */	
	public class MMenuDtoList
	{
		private var _mMenuList:ArrayCollection;
		
		public function MMenuDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:MMenuDto in obj) {
				tmpArray.push(tmp);
			}
			
			_mMenuList = new ArrayCollection(tmpArray);			
		}
		
		public function get mMenuList():ArrayCollection
		{
			return _mMenuList; 
		}		
	}
}