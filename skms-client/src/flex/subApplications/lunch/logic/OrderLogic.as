package subApplications.lunch.logic
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.dto.MenuDto;
	import subApplications.lunch.dto.MenuOrderDto;
	import subApplications.lunch.dto.MenuOrderOptionDto;
	import subApplications.lunch.dto.ShopMenuDtoList;
	import subApplications.lunch.web.Order;
	
	import utils.CommonIcon;

	/**
	 * メニュー注文ダイアログロジッククラス
	 * 
	 * @author t-ito
	 */			
	public class OrderLogic extends Logic
	{
		/** 合計金額 */
		[Bindable]
		public var _price:int;				

		/** オプション一覧*/
		[Bindable]
		public var _optionKindList:ArrayCollection;		
		
		public function OrderLogic()
		{
			super();
		}

		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.totalPrice, "text", this, "_price");
			BindingUtils.bindProperty(this.view.optionKind, "dataProvider", this, "_optionKindList");
	
			view.lunchService.getOperation("getShopMenuList").send(view.data.menu.menuId);

			_price = view.data.menu.price;			
			orderDatePreferences();		
		}

		/**
		 * ショップメニュー取得成功
		 */
		public function onResult_getShopMenuList(e:ResultEvent):void
		{
			trace("onResult_getShopMenuList...");
			var shopMenuDtoList:ShopMenuDtoList = new ShopMenuDtoList(e.result);
			var _menuList:MenuDto = shopMenuDtoList.menuList;
			
			view.menuName.text = _menuList.menuName;
			view.comment.text = _menuList.comment;
			if(_menuList.photo != null){
				view.currentState = "picture";
				view.photo.source = _menuList.photo;
				view.photo.load();
			}
			view.price.text = priceFormat(_menuList.price);
			_optionKindList = _menuList.optionKindList;
			qtyItems();
			view.orderButton.enabled = true;
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
		 * 注文ボタン押下処理
		 */				
		public function onClick_btnOrder(e:MouseEvent):void
		{	
			if(view.orderDate.text != ""){ 
				var orderData:MenuOrderDto = new MenuOrderDto();
				orderData.staffId = Application.application.indexLogic.loginStaff.staffId;
				orderData.orderDate = view.orderDate.selectedDate;
				orderData.shopMenuId = view.data.menu.menuId;
				orderData.registrationId = Application.application.indexLogic.loginStaff.staffId;
				orderData.number = view.qty.value;
				orderData.cancel = true;
				
				var tmpArray:Array = new Array();
				var tmpOption:MenuOrderOptionDto = new MenuOrderOptionDto();
				
				if(_optionKindList != null){
					for (var i:int = 0; i < _optionKindList.length; i++) {		
						for (var j:int = 0; j < _optionKindList[i].optionKindList.length; j++) {
							if(view.options[i].selectedIndex == j){
								tmpOption = new MenuOrderOptionDto();
								tmpOption.mOptionId = _optionKindList[i].optionKindList[j].option.id;
								tmpArray.push(tmpOption);
							}
						}
					}
				}else{
					tmpArray.push(tmpOption);
				}
				var orderOption:ArrayCollection = new ArrayCollection(tmpArray);
				
				view.lunchService.getOperation("insertOrder").send(orderData, orderOption, view.data.shop.orderLimitTime);
			}else{
				// 注文日が未入力だったらエラー
				Alert.show("注文日が未入力です。", null, Alert.OK, null, null, CommonIcon.exclamationIcon, Alert.OK);
			}
		}

		/**
		 * 新規登録処理成功
		 */
		public function onResult_insertOrder(e:ResultEvent):void
		{
			trace("onResult_insertOrder...");
			
			if(e.result){
				Alert.show(view.menuName.text + "を" + view.qty.value.toString() + "個" + "\n注文しました。", null, Alert.OK, null, null, null, Alert.OK);
				// 「連続して注文する」にチェックがついていたら
				if(view.orderCheck.selected == false){
					// 画面のクローズを行う
					var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
					PopUpManager.removePopUp(view);	
				}				
			}else{
				// エラーダイアログ表示
				Alert.show("注文時間が過ぎています。\n注文に失敗しました。", "Error", Alert.OK, null, null, CommonIcon.exclamationRedIcon, Alert.OK);			
			}
		}

		/**
		 * 新規登録処理失敗
		 */
		public function onFault_insertOrder(e:FaultEvent):void
		{
			trace("onFault_insertOrder...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの登録に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);						
		}	
			
		/**
		 * オプション表示処理
		 */		
		public function optionPriceLabel(item:Object):String
		{
			var price:String = "";
    		if (item.option.price >= 0) {
    			price = "(+" + item.option.price + "円)";
    		} else if(item.option.price < 0) {
    			price = "(" + item.option.price + "円)";
    		}
        	return item.option.optionDisplayName + " " + price;
		}

		/**
		 * 注文日初期設定処理
		 */
		public function orderDatePreferences():void
		{	
			var nowDate:Date = new Date();
			var nowHours:int = nowDate.hours;
			var nowMinutes:int = nowDate.minutes;
			var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
			
			var str:Array =view.data.shop.orderLimitTime.split(":");
			var limitHours:int = str[0];
			var limitMinutes:int = str[1];
			
			if(limitHours - nowHours >= 0){
				if(limitHours == nowHours){
					if(limitMinutes - nowMinutes < 0){
						view.orderDate.selectedDate = new Date(nowDate.getTime() + millisecondsPerDay);
					}
				}
				view.orderDate.selectedDate =nowDate;
			}else{
				view.orderDate.selectedDate = new Date(nowDate.getTime() + millisecondsPerDay);
			}	
		}
		/**
		 * 基本価格表示処理
		 */				
		public function priceFormat(item:Object):String
		{				
			return item.toString() + "円"	
		}

		/**
		 * 合計金額算出処理
		 */		
		public function calculatedTotalPrice():void
		{	
			if(_optionKindList != null){
				for (var i:int = 0; i < _optionKindList.length; i++) {		
					for (var j:int = 0; j < _optionKindList[i].optionKindList.length; j++) {
						if(view.options[i].selectedIndex == j){
							_price += _optionKindList[i].optionKindList[j].option.price;
							break;
						}
					}
				}
			}	
		}

		/**
		 * 個数処理
		 */		
		public function qtyItems():void{
			calculatedTotalPrice();
			_price *= view.qty.value;
		}

		/**
		 * オプション選択処理
		 */		
        public function onChange_cbOptionChoices(e:ListEvent):void {
        	_price = view.data.menu.price;
			qtyItems();
        }

		/**
		 * 個数選択処理
		 */		        
        public function onChange_qty(e:Event):void{
        	_price = view.data.menu.price;
			qtyItems();
        }

		/**
		 * 戻るボタン押下処理
		 */				
		public function onClick_btnCancel(e:MouseEvent):void
		{
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
			PopUpManager.removePopUp(view);
		}
		
		/**
		 * ポップアップクローズ処理
		 */				
		public function onClose_OrderDlg(e:CloseEvent):void
		{
			// 画面のクローズを行う
			PopUpManager.removePopUp(view);
		}

						
		/** 画面 */
		public var _view:Order;

		/**
		 * 画面を取得します.
		 */
		public function get view():Order
		{
			if (_view == null)
			{
				_view = super.document as Order;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします.
		 *
		 * @param view セットする画面
		 */
		public function set view(view:Order):void
		{
			_view = view;
		}
	}
}