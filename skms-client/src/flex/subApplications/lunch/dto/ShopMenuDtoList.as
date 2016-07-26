package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * ショップメニュー一覧Dto
	 * @author t-ito
	 */		
	public class ShopMenuDtoList
	{
		private var _shopMenuDtoList:ArrayCollection;
		private var _menuData:MenuDto = new MenuDto();
		
		public function ShopMenuDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
					
			for each(var tmp:ShopMenuDto in obj) {
				var menuList:MenuDto = new MenuDto();

				menuList.menuId = tmp.id;
				menuList.menuName = tmp.mMenu.menuName;
				menuList.price = tmp.mMenu.price;
				menuList.limit = tmp.finishDate;
				menuList.menuCategoryId = tmp.mMenu.menuCategoryId;

				_menuData.menuId = tmp.id;
				_menuData.menuName = tmp.mMenu.menuName;
				_menuData.price = tmp.mMenu.price;
				_menuData.photo = tmp.mMenu.photo;				
				_menuData.comment = tmp.mMenu.comment;
				_menuData.limit = tmp.finishDate;
				_menuData.menuCategoryId = tmp.mMenu.menuCategoryId;

				if(tmp.mMenu.mOptionSet != null){
					var optionSet:OptionSetDtoList = new OptionSetDtoList(tmp.mMenu.mOptionSet.optionSetList);				
					var mOptionKind:MOptionKindDtoList = new MOptionKindDtoList(optionSet.optionKindList);				
					_menuData.optionKindList = mOptionKind.optionKindList;
				}	
				
				tmpArray.push(menuList);
			}
			
			_shopMenuDtoList = new ArrayCollection(tmpArray);
		}

		public function get shopMenuDtoList():ArrayCollection
		{
			return _shopMenuDtoList; 
		}
		
		public function get menuList():MenuDto
		{
			return _menuData; 
		}
		
	}
}