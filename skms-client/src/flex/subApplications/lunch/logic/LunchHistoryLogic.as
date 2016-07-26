package subApplications.lunch.logic
{
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.formatters.CurrencyFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.workingConditions.web.components.CheckBoxDataGridHeaderRenderer;
	import subApplications.lunch.dto.MenuOrderDto;
	import subApplications.lunch.dto.MenuOrderDtoList;
	import subApplications.lunch.dto.MenuOrderOptionDto;
	import subApplications.lunch.web.*;

	/**
	 * あなたの注文履歴ロジッククラス
	 * 
	 * @author t-ito
	 */		
	public class LunchHistoryLogic extends Logic
	{
		/** ログイン者ID */
		public var _staffId:int = Application.application.indexLogic.loginStaff.staffId;
		
		/** 注文履歴 */
		[Bindable]
		public var _order:ArrayCollection;
		
		/** 注文後履歴 */
		[Bindable]
		public var _orderHistory:ArrayCollection;		
		
		/** 注文前合計金額 */
		[Bindable]
		public var _orderPrice:String;

		/** 注文後月別合計金額 */
		[Bindable]
		public var _orderPriceHistory:String;

		/** 注文後月別金額 */
		[Bindable]
		public var _orderPriceMonth:int = 0;

		/** HeaderRenderer */
		[Bindable]
		public var _headerRenderer:ClassFactory;			

		/** 全選択・全選択解除 */
		public var _allCheck:Boolean = false;

		/** MenuOrderDtoList */
		public var _menuOrder:MenuOrderDtoList = new MenuOrderDtoList(null);
		
		/** 現在日時 */
		public var nowDate:Date = new Date;
	
		/** 検索年の値 */ 	
		public var dateYear:int = nowDate.fullYear;
		
		/** 検索月の値 */ 	
		public var dateMonth:int = (nowDate.month + 1);	
					
		public function LunchHistoryLogic()
		{
			super();
			
			//選択フィールド作成
			this.InitHeaderRender();			
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.order, "dataProvider", this, "_order");
			BindingUtils.bindProperty(this.view.orderHistory, "dataProvider", this, "_orderHistory");
			BindingUtils.bindProperty(this.view.orderPrice, "text", this, "_orderPrice");
			BindingUtils.bindProperty(this.view.orderPriceHistory, "text", this, "_orderPriceHistory");
		}

		/**
		 * 確定後注文一覧のフィルター
		 */
		 public function orderListFillter(obj:MenuOrderDto):Boolean
		 {
		 	if(dateYear == obj.orderDate.fullYear){
		 		if(dateMonth == obj.orderDate.month + 1){
		 			this._orderPriceMonth += obj.orderPrice;
		 			return true;
		 		}
		 	}
		 	return false;
		 }

		/**
		 * 検索日時算出処理
		 */
		public function searchDate():void
		{
			view.date.text = dateYear.toString() + "年" + dateMonth.toString() + "月"
		}

		/**
		 * 前月検索リンクボタン
		 */
		public function onClick_linkPreviousMonth(e:Event):void
		{	
			this._orderPriceMonth = 0;
			if(dateMonth == 1){
				dateYear = dateYear - 1;
				dateMonth = 12;
			}else{
				dateMonth = dateMonth - 1;	
			}
			searchDate();
			this._orderHistory.refresh();
			this._orderPriceHistory = expense(this._orderPriceMonth);
		}	

		/**
		 * 翌月検索リンクボタン
		 */
		public function onClick_linkNextMonth(e:Event):void
		{
			this._orderPriceMonth = 0;
			if(dateMonth == 12){
				dateYear = dateYear + 1;
				dateMonth = 1;
			}else{
				dateMonth = dateMonth + 1;
			}
			searchDate();
			this._orderHistory.refresh();
			this._orderPriceHistory = expense(this._orderPriceMonth);
		}
					
		/**
		 * 確定前注文一覧取得成功
		 */
		public function onResult_getLunchHistoryList(e:ResultEvent):void
		{
			trace("onResult_getLunchHistoryList...");
			_menuOrder = new MenuOrderDtoList(e.result);
			this._order = _menuOrder.menuOrderList;
			this._orderPrice = expense(priceTotal(this._order));
			//削除CheckBoxの部分
			this.view.checkColumn.headerRenderer = this._headerRenderer;					
		}
		
		/**
		 * 確定前注文一覧取得失敗
		 */
		public function onFault_getLunchHistoryList(e:FaultEvent):void
		{
			trace("onFault_getLunchHistoryList...");
			trace(e.message);
			// エラーダイアログ表示
			Alert.show("DB接続に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);			
		}

		/**
		 * 確定後注文一覧取得成功
		 */
		public function onResult_getLunchHistory(e:ResultEvent):void
		{	
			this._orderPriceMonth = 0;
			trace("onResult_getLunchHistory...");
			var _menuOrderAfter:MenuOrderDtoList = new MenuOrderDtoList(e.result);
			this._orderHistory = _menuOrderAfter.menuOrderList;
			this._orderHistory.filterFunction = orderListFillter;
			this._orderHistory.refresh();
			this._orderPriceHistory = expense(this._orderPriceMonth);
			view.previousMonth.enabled = true;
			view.nextMonth.enabled = true;
		}
		
		/**
		 * 確定後注文一覧取得失敗
		 */
		public function onFault_getLunchHistory(e:FaultEvent):void
		{
			trace("onFault_getLunchHistory...");
			trace(e.message);
			// エラーダイアログ表示
			Alert.show("DB接続に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);			
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

		/**
		 * 一覧データ取得処理
		 */
		public function getLunchHistoryList():void
		{
			view.lunchService.getOperation("getLunchHistoryList").send(_staffId);
			view.lunchService.getOperation("getLunchHistory").send(_staffId);
			searchDate();
			_allCheck = false;
		}

		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_deleteOrderHistory(e:MouseEvent):void
		{
			Alert.show("削除してもよろしいですか？", "", 3, view, deleteOrderHistory);
		}

			
		/**
		 * 削除処理
		 */
		public function deleteOrderHistory(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				var deleteOrder:ArrayCollection = new ArrayCollection();
				var deleteOrderOption:ArrayCollection = new ArrayCollection();
				var tmpArray:Array = new Array();
				var tmpArrayOption:Array = new Array();
				
				for each(var tmp:MenuOrderDto in this._order){
					if(tmp.checkBox){
						tmpArray.push(tmp);
						
						if(tmp.menuOrderOptionList.length > 0){
							for each(var tmpOption:MenuOrderOptionDto in tmp.menuOrderOptionList){
								tmpArrayOption.push(tmpOption);
							}
						}else{
							var tmpOptionNothing:MenuOrderOptionDto = new MenuOrderOptionDto();
							tmpArrayOption.push(tmpOptionNothing);
						}
					}	
				}
				deleteOrder = new ArrayCollection(tmpArray);
				deleteOrderOption = new ArrayCollection(tmpArrayOption);
				
				view.lunchService.getOperation("deleteOrder").send(deleteOrder, deleteOrderOption);				
			}
		}

		/**
		 * 削除処理成功
		 */
		public function onResult_deleteOrder(e:ResultEvent):void
		{
			trace("onResult_deleteOrder...");
			getLunchHistoryList();
		}	

		/**
		 * 削除処理失敗
		 */
		public function onFault_deleteOrder(e:FaultEvent):void
		{
			trace("onFault_deleteOrder...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("削除に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);
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
		 * 確定前一覧をクリックしたとき
		 *   目的はHeaderのCheckBoxのClick処理
		 */
		public function onClick_DataGrid(e:MouseEvent):void
		{
			//CheckBoxをClickした時
			if(e.target is CheckBoxDataGridHeaderRenderer){
				_menuOrder.changeCheckBox(_allCheck);
				this._order.refresh();
			}			
		}
				
		
		/** 画面 */
	    public var _view:LunchHistory;

	    /**
	     * 画面を取得します
	     */
	    public function get view():LunchHistory
	    {
	        if (_view == null) {
	            _view = super.document as LunchHistory;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:LunchHistory):void
	    {
	        _view = view;
	    }

	}
}