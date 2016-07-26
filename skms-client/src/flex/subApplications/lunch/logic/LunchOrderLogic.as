package subApplications.lunch.logic
{
	import components.PopUpWindow;
	
	import flash.events.Event;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import subApplications.lunch.dto.MLunchShopDto;
	import subApplications.lunch.dto.MLunchShopDtoList;
	import subApplications.lunch.dto.MenuCategoryDto;
	import subApplications.lunch.dto.MenuCategoryDtoList;
	import subApplications.lunch.dto.MenuDto;
	import subApplications.lunch.dto.ShopMenuDtoList;
	import subApplications.lunch.web.LunchOrder;
	import subApplications.lunch.web.Order;

	/**
	 * 注文ロジッククラス
	 * 
	 * @author t-ito
	 */	
	public class LunchOrderLogic extends Logic
	{
		/**店舗一覧*/
		[Bindable]
		public var _shopList:ArrayCollection;		

		/**メニューカテゴリ一覧*/
		[Bindable]
		public var _menuCategory:ArrayCollection;		

		/**メニュー一覧*/
		[Bindable]
		public var _menuList:ArrayCollection;
				
		public function LunchOrderLogic()
		{
			super();
		}

		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.shopList, "dataProvider", this, "_shopList");
			BindingUtils.bindProperty(this.view.searchComboBox, "dataProvider", this, "_menuCategory");
			BindingUtils.bindProperty(this.view.menuList, "dataProvider", this, "_menuList");
			
			view.lunchService.getOperation("getShopList").send();
		}
		
		/**
		 * メニュー選択処理
		 */		
		public function onClick_menuList(e:Event):void
		{
			if(view.menuList.selectedItem != null){
				var obj:Object = new Object();
				obj.menu = ObjectUtil.copy(view.menuList.selectedItem);
				obj.shop = ObjectUtil.copy(view.shopList.selectedItem);
				var pop:IFlexDisplayObject = PopUpWindow.openWindow(Order, view, obj);
			}	
		}

		/**
		 * 弁当業者別ショップデータ取得処理
		 */
		public function getMenuList():void
		{
			var shopData:MLunchShopDto = view.shopList.selectedItem as MLunchShopDto;	
			view.lunchService.getOperation("getMenuList").send(shopData.shopId);
		}
		
		/**
		 * ショップメニュー取得成功
		 */
		public function onResult_getShopMenuList(e:ResultEvent):void
		{
			trace("onResult_getShopMenuList...");
			var shopMenuDtoList:ShopMenuDtoList = new ShopMenuDtoList(e.result);
			this._menuList = shopMenuDtoList.shopMenuDtoList;
			this._menuList.filterFunction = menuListSearch;
			view.lunchService.getOperation("getMenuCategory").send();
		}
		
		/**
		 * ショップメニュー取得失敗
		 */
		public function onFault_getShopMenuList(e:FaultEvent):void
		{
			trace("onFault_getShopMenuList...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);						
		}

		/**
		 * メニューカテゴリーフィルター処理
		 */
		public function menuCategoryFilter(obj:Object):Boolean
		{
			for each(var tmp:MenuDto in this._menuList){
				if(obj.id == tmp.menuCategoryId || obj.id == 0){
					return true;
				}
			}
			return false;
		}

		/**
		 * メニューカテゴリー取得成功
		 */
		public function onResult_getMenuCategory(e:ResultEvent):void
		{
			trace("onResult_getMenuCategory...");
			var menuCategoryList:MenuCategoryDtoList = new MenuCategoryDtoList(e.result);
			this._menuCategory = menuCategoryList.menuCategoryList;
			this._menuCategory.filterFunction = menuCategoryFilter;
			this._menuCategory.refresh();
		}
		
		/**
		 * メニューカテゴリー取得失敗
		 */
		public function onFault_getMenuCategory(e:FaultEvent):void
		{
			trace("onFault_getMenuCategory...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);						
		}

		/**
		 * 弁当業者選択処理
		 */
		public function onChange_shopList(e:ListEvent):void
		{
			getMenuList();
		}

		/**
		 * 弁当業者マスタ取得成功
		 */
		public function onResult_getShopList(e:ResultEvent):void
		{
			trace("onResult_getShopList...");
			var mLunchShopDtoList:MLunchShopDtoList = new MLunchShopDtoList(e.result);
			this._shopList = mLunchShopDtoList.shopList;
			getMenuList();
		}
		
		/**
		 * 弁当業者マスタ取得失敗
		 */
		public function onFault_getShopList(e:FaultEvent):void
		{
			trace("onFault_getShopList...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);						
		}

		/**
		 * カテゴリー選択処理
		 */		
		public function onChange_categoryList(e:ListEvent):void
		{
			this._menuList.refresh();
		}

		/**
		 * 検索入力処理
		 */
		public function onChange_search():void
		{
			this._menuList.refresh();
		}
		
		/**
		 * 検索フィルター処理
		 */
		public function menuListSearch(obj:Object):Boolean
		{	
			var bool:Boolean = false;
			
			if(this._menuCategory.length != 0){
				var menuCategory:MenuCategoryDto = view.searchComboBox.selectedItem as MenuCategoryDto;
				if(menuCategory.id  == obj.menuCategoryId || menuCategory.id == 0){
					bool = true;
				}
			}
			
			if(view.searchText.length != 0){
				bool = false;
				
				if( obj.menuName.indexOf(view.searchText.text) >= 0 ){
					bool = true;
				}					
			}
			return bool;
		}
		

		/** 画面 */
		public var _view:LunchOrder;

		/**
		 * 画面を取得します.
		 */
		public function get view():LunchOrder
		{
			if (_view == null)
			{
				_view = super.document as LunchOrder;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします.
		 *
		 * @param view セットする画面
		 */
		public function set view(view:LunchOrder):void
		{
			_view = view;
		}
	
	}
}