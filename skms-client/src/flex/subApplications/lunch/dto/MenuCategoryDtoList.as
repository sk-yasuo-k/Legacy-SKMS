package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * メニューカテゴリー一覧Dto
	 * @author t-ito
	 */	
	public class MenuCategoryDtoList
	{
		private var _menuCategoryList:ArrayCollection;
		private var _menuCategory:ArrayCollection;
		
		public function MenuCategoryDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			var tmpMenuCategory:Array = new Array();
			var initialData:MenuCategoryDto = new MenuCategoryDto();
			initialData.id = 0;
			initialData.categoryName = "すべて";
			initialData.categoryDisplayName = "すべて";
			tmpArray.push(initialData);
			
			for each(var tmp:MenuCategoryDto in obj) {
				tmpArray.push(tmp);
				tmpMenuCategory.push(tmp);
			}
			
			_menuCategoryList = new ArrayCollection(tmpArray);
			_menuCategory = new ArrayCollection(tmpMenuCategory);
		}
			
		public function get menuCategoryList():ArrayCollection
		{
			return _menuCategoryList; 
		}
		
		public function get menuCategory():ArrayCollection
		{
			return _menuCategory; 
		}				
	}
}