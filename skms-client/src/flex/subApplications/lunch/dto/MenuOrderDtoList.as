package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	
	/**
	 * メニューオーダー一覧Dto
	 * @author t-ito
	 */		
	public class MenuOrderDtoList
	{
		private var _menuOrderDtoList:ArrayCollection;
		
		public function MenuOrderDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:MenuOrderDto in obj){
				tmpArray.push(tmp);
			}
			
			_menuOrderDtoList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * 状態の一括変更
		 *   引数の値ですべて変更
		 * */
		public function changeCheckBox(data:Boolean):void
		{
			for each( var tmp:MenuOrderDto in _menuOrderDtoList ){
				tmp.checkBox = data;
			}
		}

		public function get menuOrderList():ArrayCollection
		{
			return _menuOrderDtoList; 
		}
	}
}