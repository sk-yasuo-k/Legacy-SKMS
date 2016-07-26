package subApplications.lunch.dto  
{
	import mx.collections.ArrayCollection;
	/**
	 * ...
	 * @author ...
	 */
	public class MShopAdminDtoList
	{
		private var _staffList:ArrayCollection;
		
		public function MShopAdminDtoList(obj:Object) 
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:MShopAdminDto in obj) {
				tmpArray.push(tmp);
			}
			_staffList = new ArrayCollection(tmpArray);			
		}
			
		public function get staffList():ArrayCollection { return _staffList; }
	}
			
}