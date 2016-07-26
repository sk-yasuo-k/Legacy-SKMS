package subApplications.lunch.logic
{
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.formatters.CurrencyFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import subApplications.generalAffair.workingConditions.web.components.CheckBoxDataGridHeaderRenderer;
	import subApplications.lunch.dto.MLunchShopDto;
	import subApplications.lunch.dto.MLunchShopDtoList;
	import subApplications.lunch.dto.MenuOrderDto;
	import subApplications.lunch.dto.MenuOrderDtoList;
	import subApplications.lunch.web.*;

	/**
	 * みんなの注文ロジッククラス
	 * 
	 * @author t-ito
	 */	
	public class LunchAggregateLogic extends Logic
	{
		/**店舗一覧*/
		[Bindable]
		public var _shopList:ArrayCollection;

		/** MenuOrderDtoList */
		public var _menuOrderList:MenuOrderDtoList = new MenuOrderDtoList(null);

		/** 注文一覧 */
		[Bindable]
		public var _orderList:ArrayCollection;
		
		/** 注文集計一覧 */
		[Bindable]
		public var _orderTotal:ArrayCollection;
		
		/** HeaderRenderer */
		[Bindable]
		public var _headerRenderer:ClassFactory;			

		/** 全選択・全選択解除 */
		public var _allCheck:Boolean = false;

		/** 注文合計金額 */
		[Bindable]
		public var _orderPrice:String;
						
		public function LunchAggregateLogic()
		{
			super();

			//選択フィールド作成
			this.InitHeaderRender();			
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.shopList, "dataProvider", this, "_shopList");
			BindingUtils.bindProperty(this.view.order, "dataProvider", this, "_orderList");
			BindingUtils.bindProperty(this.view.orderTotal, "dataProvider", this, "_orderTotal");
			BindingUtils.bindProperty(this.view.orderPrice, "text", this, "_orderPrice");		
		}

		/**
		 * 選択フィールド作成 
		 */
		public function InitHeaderRender():void
		{
			this._headerRenderer = new ClassFactory(CheckBoxDataGridHeaderRenderer);
			this._headerRenderer.properties = { parentObject:this, state:"_allCheck" };
		}
		
		/**
		 * 注文一覧クリック処理
		 *   目的はHeaderのCheckBoxのClick処理
		 */
		public function onClick_DataGrid(e:MouseEvent):void
		{
			//CheckBoxをClickした時
			if(e.target is CheckBoxDataGridHeaderRenderer){
				this._menuOrderList.changeCheckBox(_allCheck);
				this._orderList.refresh();
			}			
		}

		/**
		 * 一覧データ取得処理
		 */
		public function getLunchAggregateList():void
		{
			view.lunchService.getOperation("getShopList").send();
			_allCheck = false;
		}

		/**
		 * 弁当業者マスタ取得成功
		 */
		public function onResult_getShopList(e:ResultEvent):void
		{
			trace("onResult_getShopList...");
			var mLunchShopDtoList:MLunchShopDtoList = new MLunchShopDtoList(e.result);
			this._shopList = mLunchShopDtoList.shopList;
			getOrderList();
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
		 * 弁当業者別注文一覧取得処理
		 */
		public function getOrderList():void
		{
			var shopData:MLunchShopDto = view.shopList.selectedItem as MLunchShopDto;	
			view.lunchService.getOperation("getLunchAggregateList").send(shopData.shopId);
		}

		/**
		 * 注文一覧取得成功
		 * */
		public function onResult_getLunchAggregateList(e:ResultEvent):void
		{
			trace("onResult_getLunchAggregateList...");
			_menuOrderList = new MenuOrderDtoList(e.result);
			this._orderList = _menuOrderList.menuOrderList;	
			this._orderPrice = expense(priceTotal(this._orderList));
			orderTotalList();	
			//注文CheckBoxの部分
			this.view.checkColumn.headerRenderer = this._headerRenderer;						
		}
		
		/**
		 * 注文一覧取得失敗
		 * */
		public function onFault_getLunchAggregateList(e:FaultEvent):void
		{
			trace("onFault_getLunchAggregateList...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);			
		}

		/**
		 * 弁当業者選択処理
		 */
		public function onChange_shopList(e:ListEvent):void
		{
			getOrderList();
		}
		
		/**
		 * 注文集計処理
		 */
		public function orderTotalList():void
		{	
			var tmpArray:Array = new Array();
			
			for each(var tmp:MenuOrderDto in this._orderList){
				if(tmp.orderState != ""){
					var bool:Boolean = true;
					for each(var tmp2:MenuOrderDto in tmpArray){
						if(tmp.orderMenuName == tmp2.orderMenuName){
							tmp2.number += tmp.number;
							bool = false;
						}
					}
					
					if(bool){
						tmpArray.push(ObjectUtil.copy(tmp));
					}
				}	
			}
			this._orderTotal = new ArrayCollection(tmpArray);
		}

		/**
		 * 確定ボタン押下処理
		 */
		public function onClick_confirmed(e:MouseEvent):void
		{
			Alert.show("確定してもよろしいですか？", "", 3, view, updateOrder);
		}

		/**
		 * 注文一覧更新処理
		 */
		public function updateOrder(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				var updateOrder:ArrayCollection = new ArrayCollection();
				var tmpArray:Array = new Array();
				for each(var tmp:MenuOrderDto in this._orderList){
					if(tmp.checkBox){
						tmp.checkBox = false;
						tmp.cancel = false;
						tmpArray.push(tmp);
					}
				}
				updateOrder = new ArrayCollection(tmpArray);
				
				view.lunchService.getOperation("updateOrder").send(updateOrder);
			}
		}

		/**
		 * 更新処理成功
		 */
		public function onResult_updateOrder(e:ResultEvent):void
		{
			trace("onResult_updateOrder...");
			this._orderList.refresh();
			orderTotalList();
			_allCheck = false;
		}	

		/**
		 * 更新処理失敗
		 */
		public function onFault_updateOrder(e:FaultEvent):void
		{
			trace("onFault_updateOrder...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("確定処理に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);
		}

		/**
		 * 合計金額算出処理
		 */
		public function priceTotal(order:ArrayCollection):int
		{
			var _price:int = 0;
			
			for each(var tmp:MenuOrderDto in order){
				_price += tmp.orderPrice;
			}			
			return _price;
		}

		/**
		 * 金額フォーマット処理(\あり).
		 *
		 * @param expense 金額.
		 * @return フォーマット後の金額.
		 */
		 public static function expense(expense:Object):String
		 {
			var formatter:CurrencyFormatter = new CurrencyFormatter();
			formatter.useThousandsSeparator = true;
			formatter.useNegativeSign       = true;
			var fmdata:String = formatter.format(expense);
			return fmdata;
		 }
				
		/** 画面 */
	    public var _view:LunchAggregate;

	    /**
	     * 画面を取得します
	     */
	    public function get view():LunchAggregate
	    {
	        if (_view == null) {
	            _view = super.document as LunchAggregate;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:LunchAggregate):void
	    {
	        _view = view;
	    }

	}
}