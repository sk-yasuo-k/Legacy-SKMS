package subApplications.customer.logic
{
	import components.PopUpWindow;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import subApplications.customer.dto.CustomerSearchDto;
	import subApplications.customer.web.CustomerSortOrder;

	public class CustomerSortOrderLogic extends Logic
	{
		/** 顧客リスト */
		private var _customerList:ArrayCollection;

		/** ドロップIndex */
		private var _dropIndices:Array;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function CustomerSortOrderLogic()
		{
			super();
		}

//--------------------------------------
//  Initialization
//--------------------------------------
		/**
		 * onCreationCompleteHandler
		 */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// 初期設定する.
			view.btnEntry.enabled = false;

			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();
	    }

		/**
		 * 表示データの設定.
		 */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
			// 顧客リストを取得する.
			requestCustomerList();
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 登録ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:MouseEvent):void
		{
			Alert.show("登録してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);				// 登録.
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// 登録する.
			var entryList:ArrayCollection = view.customerList.dataProvider as ArrayCollection;
			view.srv.getOperation("changeCustomerSort").send(Application.application.indexLogic.loginStaff, entryList);
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_close(e:MouseEvent):void
		{
			view.closeWindow();
		}

		/**
		 * ヘルプボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			opneHelpWindow("CustomerSortChange");
		}


		/**
		 * getCustomerList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getCustomerList(e:ResultEvent):void
		{
			// 結果を取得する.
			_customerList = e.result as ArrayCollection;

			// 顧客一覧に設定する.
			view.customerList.dataProvider = _customerList;
			view.btnEntry.enabled = true;
		}

		/**
		 * changeCustomerSort処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_changeCustomerSort(e:ResultEvent):void
		{
			// 顧客一覧画面に戻る.
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * getCustomerListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getCustomerList(e:FaultEvent):void
		{
			//trace ("fault! service.getCustomerList()" + " : " + e.toString());
			// 顧客一覧画面に戻る.
			CustomerLogic.alert_xxxx("最新の取引先情報取得");
			view.closeWindow();
		}

		/**
		 * changeCustomerSortの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_changeCustomerSort(e:FaultEvent):void
		{
			//trace ("fault! service.changeCustomerSort()" + " : " + e.toString());
			// 排他エラー.
			if (CustomerLogic.isConflictFault(e)) {
				// 排他エラーメッセージを表示する.
				CustomerLogic.alert_conflictCustomer();
			}
			// その他エラー.
			else {
				// エラーメッセージを表示する.
				CustomerLogic.alert_xxxx("取引先表示順変更");
			}
		}


		/**
		 * 取引先一覧 DragEnter.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_customerList(e:DragEvent):void
		{
			_dropIndices = null;
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}

		/**
		 * 取引先一覧 DragDrop.
		 *
		 * @param e DragEvent
		 */
		public function onDragDrop_customerList(e:DragEvent):void
		{
			// ドラッグIndexを取得する.
			var indices:Array = view.customerList.selectedIndices;
			indices.sort(Array.NUMERIC);

			// ドロップ先Indexを取得する.
			var dropIndex:int = view.customerList.calculateDropIndex(e);
			var upCnt:int = 0;
			var dnCnt:int = 0;
			_dropIndices = new Array();
			for (var i:int = 0; i < indices.length; i++) {
				// Dropを計算する.
				var index:int = -1;
				if (dropIndex > indices[i]) {							// 下に移動.
					index = dropIndex + i - dnCnt -1;
					dnCnt++;
				}
				else {													// 上に移動.
					index = dropIndex + i - dnCnt;
					upCnt++;
				}
				_dropIndices.push(index);
			}
		}

		/**
		 * 取引先一覧 DragComplete.
		 *
		 * @param e DragEvent
		 */
		public function onDragComplete_customerList(e:DragEvent):void
		{
			if (_dropIndices) {
				view.customerList.selectedIndices = _dropIndices;
			}
		}

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 顧客リストの取得.
		 */
		public function requestCustomerList():void
		{
			// 顧客リストを取得する.
			var search:CustomerSearchDto = new CustomerSearchDto();
			view.srv.getOperation("getCustomerList").send(search);
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CustomerSortOrder;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CustomerSortOrder
	    {
	        if (_view == null) {
	            _view = super.document as CustomerSortOrder;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:CustomerSortOrder):void
	    {
	        _view = view;
	    }

	}
}