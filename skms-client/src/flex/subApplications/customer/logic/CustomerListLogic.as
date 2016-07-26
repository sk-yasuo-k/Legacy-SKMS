package subApplications.customer.logic
{
	import components.PopUpWindow;

	import dto.StaffDto;

	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.DataEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.core.UITextField;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.customer.dto.CustomerDto;
	import subApplications.customer.dto.CustomerMemberDto;
	import subApplications.customer.web.CustomerEntry;
	import subApplications.customer.web.CustomerList;
	import subApplications.customer.web.CustomerSortOrder;
	import subApplications.customer.web.Message;

	/**
	 * CustomerListのLogicクラスです.
	 */
	public class CustomerListLogic extends Logic
	{
		/** 顧客リスト */
		private var _customerList:ArrayCollection;

		/** 選択した顧客情報 */
		private var _selectedCustomer:CustomerDto;

		/** 選択したリンクボタン */
		private var _selectedLinkObject:Object;

		/** 顧客情報登録権限 */
		private var _customerEntryAuthorisation:Boolean = false;


		/** アップロードファイル情報 */
		private var _uploadFileRf:FileReference;
		/** アップロードservlet */
		private const SERVLET_UPLOAD:String = "/skms-server/fileUpload";
		/** 読み込んだ顧客リスト */
		private var _uploadCustomerInfoList:ArrayCollection;


		/** ダウンロードファイル情報 */
		private var _downloadFileRf:FileReference;
		/** ダウンロードservlet */
		private const SERVLET_DOWNLOAD:String = "/skms-server/fileDownload";
		/** ダウンロードファイルのデフォルト名称 */
		private const DOWNLOAD_FILE_NAME:String = "取引先情報.xlsx";
		/** ダウンロードファイルのデフォルト名称 */
		private const DOWNLOAD_FILE_TEMPLATE:String = "取引先情報Template.xlsx";


		/** メッセージ */
		private var _popMessage:Message = null;


		/** 顧客一覧 リンクボタンアイテム（登録権限あり） */
		[Bindable]
		private var _rpLinkListAuthrisation:ArrayCollection
			= new ArrayCollection([
				{label:"新規",	func:"onClick_linkList_customer_new",		enabled:true,	enabledCheck:false  },
				{label:"変更",	func:"onClick_linkList_customer_update",	enabled:false,	enabledCheck:true,	reqSelect:true},
				{label:"複製",	func:"onClick_linkList_customer_copy",		enabled:false,	enabledCheck:true,	reqSelect:true},
				{label:"削除",	func:"onClick_linkList_customer_delete",	prepare:"onClick_linkList_customer_delete_confirm",	enabled:false,	enabledCheck:true,	reqSelect:true},
				{label:"表示順を変更する",      func:"onClick_linkList_customer_sort",       enabled:true,	enabledCheck:false},
				{label:"取引先情報を読み込む",  func:"onClick_linkList_customer_readExcel",  enabled:true,  enabledCheck:false},
				{label:"取引先情報を出力する",  func:"onClick_linkList_customer_outputDxcel",enabled:false, enabledCheck:true, reqSelect:true, reqSelects:true},
				{label:"取引先情報ﾃﾝﾌﾟﾚｰﾄを取得する",func:"onClick_linkList_customer_template",enabled:true,enabledCheck:false}
			]);
		/** 顧客一覧 リンクボタンアイテム（登録権限なし） */
		[Bindable]
		private var _rpLinkList:ArrayCollection
			= new ArrayCollection([
				{label:"参照", func:"onClick_linkList_customer_ref",	enabled:false,	enabledCheck:true,	reqSelect:true}
			]);

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CustomerListLogic()
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
			// 登録権限を確認する.
			var staff:StaffDto = Application.application.indexLogic.loginStaff;
			_customerEntryAuthorisation = staff.isAuthorisationCustomerEntry();
			view.authorize = _customerEntryAuthorisation;

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

			// メニューを設定する.
			setRpLinkList_customerList();
			setContextMenu_customerList();
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 顧客リストの選択.
		 *
		 * @param e Event
		 */
		public function onChange_customerList(e:Event):void
		{
			// メニューを設定する.
			setEnabledRpLinkList_customerList ();
			setEnabledContextMenu_customerList();

			// 選択した顧客から担当者リストを取得する.
			var indices:Array = view.customerList.selectedIndices;
			indices.sort(Array.NUMERIC);
			if (indices && indices.length > 0) {
				if (indices.length == 1)	_selectedCustomer = view.customerList.selectedItem as CustomerDto;
				else						_selectedCustomer = null;

				// 担当者を追加する.
				var list:ArrayCollection = new ArrayCollection();
				for (var k:int = 0; k < indices.length; k++) {
					var index:int = indices[k];
					var customer:CustomerDto = view.customerList.dataProvider.getItemAt(index) as CustomerDto;
					if (!customer.customerMembers)	continue;
					for (var j:int = 0; j < customer.customerMembers.length; j++) {
						var member:CustomerMemberDto = customer.customerMembers.getItemAt(j) as CustomerMemberDto;
						if (!member)	continue;
						list.addItem(member);
					}
				}
				view.customerMemberList.dataProvider = list;
			}
			else {
				_selectedCustomer = null;
				view.customerMemberList.dataProvider = null;
			}
		}

		/**
		 * 顧客リストの選択（ダブルクリック）.
		 *
		 * @param e MouseEvent
		 */
		public function onDubleClick_customerList(e:MouseEvent):void
		{
			// 選択行でダブルクリックしたとき.
			if (e.target is DataGridItemRenderer || e.target is UITextField) {
				// 顧客情報編集を表示する.
				open_customerEntry(_selectedCustomer);
			}
		}

		/**
		 * 顧客リンクリストの選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList(e:MouseEvent):void
		{
			_selectedLinkObject = view.rpLinkList.dataProvider.getItemAt(e.target.instanceIndex);
			// 選択したリンクボタンの処理を呼び出す.
			if (_selectedLinkObject.hasOwnProperty("prepare")) {
				this[_selectedLinkObject.prepare]();
			}
			else {
				this[_selectedLinkObject.func]();
			}
		}
	    /**
	     * リンクボタン選択 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		public function onClick_linkList_confirmResult(e:CloseEvent):void
		{
			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.YES) {
				this[_selectedLinkObject.func]();
			}
		}


		/**
		 * リンクボタン選択 新規作成.
		 *
		 */
		public function onClick_linkList_customer_new():void
		{
			// 顧客情報編集を表示する.
			open_customerEntry();
		}

		/**
		 * リンクボタン選択 変更.
		 *
		 */
		public function onClick_linkList_customer_update():void
		{
			// 顧客情報編集を表示する.
			open_customerEntry(_selectedCustomer);
		}

		/**
		 * リンクボタン選択 複製.
		 *
		 */
		public function onClick_linkList_customer_copy():void
		{
			// 顧客情報登録P.U.を表示する.
			var customer:CustomerDto = _selectedCustomer.copy();
			open_customerEntry(customer);
		}

		/**
		 * リンクボタン選択 削除.
		 *
		 */
		public function onClick_linkList_customer_delete_confirm():void
		{
			Alert.show("削除してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		public function onClick_linkList_customer_delete():void
		{
			view.srv.getOperation("deleteCustomer").send(Application.application.indexLogic.loginStaff, _selectedCustomer);
		}

		/**
		 * リンクボタン選択 表示順変更.
		 *
		 */
		public function onClick_linkList_customer_sort():void
		{
			// 顧客情報表示順変更P.U.を表示する.
			open_customerSortOrder();
		}

		/**
		 * リンクボタン選択 Excel読みこみ.
		 *
		 */
		public function onClick_linkList_customer_readExcel():void
		{
			_uploadFileRf = new FileReference();
			_uploadFileRf.addEventListener(Event.SELECT, onSelect_readCustomerFile);				// ファイル選択.
			_uploadFileRf.addEventListener(Event.CANCEL, onCancel_readCustomerFile);				// ファイル選択キャンセル.
			_uploadFileRf.addEventListener(ProgressEvent.PROGRESS, onProgress_readCustomerFile);	// ファイル送受信中.
			_uploadFileRf.addEventListener(Event.COMPLETE, onComplete_readCustomerFile);			// ファイル送受信完了.
			_uploadFileRf.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onDone_readCustomerFile);// ファイル送信完了の応答受信.
			_uploadFileRf.addEventListener(IOErrorEvent.IO_ERROR,IOError_readCustomerFile);		// ファイル送受信エラー.
			_uploadFileRf.browse();
 		}

		/**
		 * リンクボタン選択 Excel出力.
		 * ※FileReference.upload() or download() のとき ByteArray データはサポートされていない.
		 *
		 */
		public function onClick_linkList_customer_outputDxcel():void
		{
			// 顧客情報を取得する.
			var indices:Array = view.customerList.selectedIndices;
			indices.sort(Array.NUMERIC);
			var list:ArrayCollection = new ArrayCollection();
			for (var i:int = 0; i < indices.length; i++) {
				var customer:CustomerDto = _customerList.getItemAt(indices[i]) as CustomerDto;
				list.addItem(customer);
			}
			var xml:XML = CustomerDto.convert2(list);


			// request を設定する.
			var req:URLRequest = new URLRequest();
			req.url    = SERVLET_DOWNLOAD;
			req.contentType = "text/xml; charset=UTF-8";
			var requv:URLVariables = new URLVariables();
			requv.xml      = xml;
			req.data   = requv;
			req.method = URLRequestMethod.POST;


			// ダウンロードする.
			_downloadFileRf = new FileReference();
			_downloadFileRf.addEventListener(Event.SELECT, onSelect_outputCustomerFile);				// ファイル保存.
			_downloadFileRf.addEventListener(Event.CANCEL, onCancel_outputCustomerFile);				// ファイル保存キャンセル.
			_downloadFileRf.addEventListener(ProgressEvent.PROGRESS, onProgress_outputCustomerFile);	// ファイル送受信中.
			_downloadFileRf.addEventListener(Event.COMPLETE, onComplete_outputCustomerFile);			// ファイル送受信完了.
			_downloadFileRf.addEventListener(IOErrorEvent.IO_ERROR,IOError_outputCustomerFile);		// ファイル送受信エラー.
			_downloadFileRf.download(req, DOWNLOAD_FILE_NAME);
		}

		/**
		 * リンクボタン選択 テンプレート.
		 * ※FileReference.upload() or download() のとき ByteArray データはサポートされていない.
		 *
		 */
		public function onClick_linkList_customer_template():void
		{
			// request を設定する.
			var req:URLRequest = new URLRequest();
			req.url    = SERVLET_DOWNLOAD;
			req.method = URLRequestMethod.GET;

			// ダウンロードする.
			_downloadFileRf = new FileReference();
			_downloadFileRf.addEventListener(Event.SELECT, onSelect_templateCustomerFile);				// ファイル保存.
			_downloadFileRf.addEventListener(Event.CANCEL, onCancel_templateCustomerFile);				// ファイル保存キャンセル.
			_downloadFileRf.addEventListener(ProgressEvent.PROGRESS, onProgress_templateCustomerFile);	// ファイル送受信中.
			_downloadFileRf.addEventListener(Event.COMPLETE, onComplete_templateCustomerFile);			// ファイル送受信完了.
			_downloadFileRf.addEventListener(IOErrorEvent.IO_ERROR,IOError_templateCustomerFile);		// ファイル送受信エラー.
			_downloadFileRf.download(req, DOWNLOAD_FILE_TEMPLATE);
		}

		/**
		 * リンクボタン選択 参照.
		 *
		 */
		public function onClick_linkList_customer_ref():void
		{
			// 顧客情報編集を表示する.
			open_customerEntry(_selectedCustomer);
		}


		/**
		 * ContextMenu「変更」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_update(e:ContextMenuEvent):void
		{
			// プロジェクト情報編集を表示する.
			_selectedLinkObject = _rpLinkListAuthrisation.getItemAt(1);
			this[_selectedLinkObject.func]();
		}

		/**
		 * ContextMenu「複製」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_copy(e:ContextMenuEvent):void
		{
			// プロジェクト情報編集を表示する.
			_selectedLinkObject = _rpLinkListAuthrisation.getItemAt(2);
			this[_selectedLinkObject.func]();
		}

		/**
		 * ContextMenu「削除」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_delete(e:ContextMenuEvent):void
		{
			// プロジェクト情報編集を表示する.
			_selectedLinkObject = _rpLinkListAuthrisation.getItemAt(3);
			this[_selectedLinkObject.prepare]();
		}

		/**
		 * ContextMenu「参照」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_ref(e:ContextMenuEvent):void
		{
			// プロジェクト情報編集を表示する.
			_selectedLinkObject = _rpLinkList.getItemAt(0);
			this[_selectedLinkObject.func]();
		}


		/**
		 * getCustomerList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_customerSearch(e:ResultEvent):void
		{
			// 結果を取得する.
			_customerList = e.result as ArrayCollection;

			// 顧客一覧に設定する.
			view.customerList.dataProvider = _customerList;

			// 選択行を表示する.
	        if (_selectedCustomer && _customerList) {
				for (var index:int = 0; index < _customerList.length; index++) {
				var cusomer:CustomerDto = _customerList.getItemAt(index) as CustomerDto;
					if (CustomerDto.compare(_selectedCustomer, cusomer)) {
						view.customerList.selectedIndex = index;
						onChange_customerList(new Event("onResult_customerSearch"));
						view.customerList.scrollToIndex(index);
						break;
					}
				}
			}
			_selectedCustomer = view.customerList.selectedItem as CustomerDto;
		}

		/**
		 * deleteCustomer処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_deleteCustomer(e:ResultEvent):void
		{
			// 最新データを取得する.
			requestCustomerList();
		}


		/**
		 * getCustomerListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_customerSearch(e:FaultEvent):void
		{
			//trace ("fault! getCustomerList()" + " : " + e.toString());
			clearDisplayData();
			CustomerLogic.alert_xxxx("取引先情報取得");
		}

		/**
		 * deleteCustomerの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_deleteCustomer(e:FaultEvent):void
		{
			//trace ("fault! deleteCustomer()" + " : " + e.toString());
			// 削除エラー.
			if (CustomerLogic.isDeleteFault(e)) {
				var projects:String = CustomerLogic.getDeleteFault_project(e);
				if (projects && projects.length > 0) {
					// 削除エラーメッセージを表示する.
					CustomerLogic.alert_delteProject(projects);
				}
				else {
					CustomerLogic.alert_xxxx("取引先削除");
				}
			}
			// 排他エラー.
			else if (CustomerLogic.isConflictFault(e)) {
				// 排他エラーメッセージを表示する.
				CustomerLogic.alert_conflictCustomer();
				requestCustomerList();
			}
			else {
				CustomerLogic.alert_xxxx("取引先削除");
			}
		}


		/**
		 * 顧客情報登録P.U.のクローズイベント.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_customerEntry(e:CloseEvent):void
		{
			if (e.detail == PopUpWindow.ENTRY) {
				// 登録したら、最新データを取得する.
				requestCustomerList();
			}
		}

		/**
		 * 顧客情報登録P.U.のクローズイベント.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_customerFileEntry(e:CloseEvent):void
		{
			// 登録終了のとき.
			if (e.detail == PopUpWindow.STOP) {
				// 取引先ファイル情報を初期化する.
				_uploadCustomerInfoList = null;
			}
			// 変換した取引先ファイル情報を読み込む.
			readCustomerFileList();
		}

		/**
		 * 顧客情報表示順変更P.U.のクローズイベント.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_customerSortOrder(e:CloseEvent):void
		{
			if (e.detail == PopUpWindow.ENTRY) {
				// 登録したら、最新データを取得する.
				requestCustomerList();
			}
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 顧客リストの取得.
		 */
		private function requestCustomerList():void
		{
			view.customerSearch.getCustomerList();
		}

		/**
		 * 顧客情報登録P.U.の表示.
		 *
		 * @param customer 登録する顧客情報.
		 * @param closefunction クローズイベント処理関数.
		 * @param batchentry    連続登録するかどうか.
		 */
		private function open_customerEntry(customer:CustomerDto = null, closefunction:Function = null, batchentry:Boolean = false):void
		{
			// window を作成する.
			var pop:CustomerEntry = new CustomerEntry();
			pop.authorize = _customerEntryAuthorisation;
			pop.batchentry= batchentry;

			// 引き継ぐデータを作成する.
			var obj:Object   = new Object();
			obj.customer      = ObjectUtil.copy(customer);

			// window を表示する.
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, obj);

			// window close イベントを登録する.
			if (closefunction != null)	pop.addEventListener(CloseEvent.CLOSE, closefunction);
			else 						pop.addEventListener(CloseEvent.CLOSE, onClose_customerEntry);
		}

		/**
		 * 顧客情報表示順変更P.U.の表示.
		 *
		 */
		 private function open_customerSortOrder():void
		 {
			// window を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(CustomerSortOrder, view.parentApplication as DisplayObject);

			// window close イベントを登録する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_customerSortOrder);
		 }

		/**
		 * メッセージP.U.の表示.
		 *
		 * @param msg メッセージ.
		 */
		 private function open_message(msg:String):void
		 {
		 	if (_popMessage) {
		 		_popMessage.message = msg;
		 	}
		 	else {
				// Message（メッセージ）を作成する.
				_popMessage = new Message();
				_popMessage.message = msg;
				PopUpManager.addPopUp(_popMessage, view.parentApplication as DisplayObject, true);

				// Messageを表示する.
				PopUpManager.centerPopUp(_popMessage);
		 	}
		 }

		/**
		 * メッセージP.U.のクローズ.
		 *
		 */
		 private function close_message():void
		 {
		 	if (_popMessage) {
			 	// Messageをクローズする.
			 	PopUpManager.removePopUp(_popMessage);
			 }
			 _popMessage = null;
		 }


		/**
		 * 取引先一覧 リンクボタン設定.
		 *
		 */
		private function setRpLinkList_customerList():void
		{
			view.rpLinkList.dataProvider = createRpLinkList_customerList();
			setEnabledRpLinkList_customerList();
		}

		/**
		 * 取引先一覧 リンクボタン取得.
		 *
		 * @return リンクボタンリスト.
		 */
		private function createRpLinkList_customerList():ArrayCollection
		{
			// 登録権限に応じたメニューを作成する.
			var rplist:ArrayCollection;
			if (_customerEntryAuthorisation) {
				rplist = _rpLinkListAuthrisation;
			}
			else {
				rplist = _rpLinkList;
			}
			return rplist;
		}

		/**
		 * 取引先一覧 リンクボタン取得.
		 *
		 * @param enable リンクボタン有効.
		 */
		private function setEnabledRpLinkList_customerList(enable:Boolean = true):void
		{
			// リンクボタンの有効/無効を設定する.
			var rplist:ArrayCollection = view.rpLinkList.dataProvider as ArrayCollection;
			var selectCnt:int = view.customerList.selectedItems ? view.customerList.selectedItems.length : 0;
			for (var index:int = 0; index < rplist.length; index++) {
				var linkObject:Object = rplist.getItemAt(index);
				// 有効無効設定のとき.
				if (enable) {
					if (linkObject.enabledCheck) {
						if (linkObject.reqSelect && selectCnt == 1)
							linkObject.enabled = true;
						else if (linkObject.reqSelects && selectCnt > 0)
							linkObject.enabled = true;
						else
							linkObject.enabled = false;
					}
					else {
						linkObject.enabled = true;
					}
				}
				// 無効設定のとき.
				else {
					linkObject.enabled = false;
				}
				rplist.setItemAt(linkObject, index);
			}
		}


		/**
		 * 取引先一覧 コンテキストメニュー設定.
		 *
		 */
		private function setContextMenu_customerList():void
		{
			view.customerList.contextMenu = createContextMenu_customerList();
			setEnabledContextMenu_customerList();
		}

		/**
		 * 取引先一覧 コンテキストメニューの作成.
		 *
		 */
		private function createContextMenu_customerList():ContextMenu
		{
			// コンテキストメニューを作成する.
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// 登録権限に応じたメニューを作成する.
			if (_customerEntryAuthorisation) {
				// コンテキストメニュー：変更
				var cmItem_update:ContextMenuItem = new ContextMenuItem(_rpLinkListAuthrisation.getItemAt(1).label);
				cmItem_update.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_update);
				contextMenu.customItems.push(cmItem_update);

				// コンテキストメニュー：複製
				var cmItem_copy:ContextMenuItem = new ContextMenuItem(_rpLinkListAuthrisation.getItemAt(2).label);
				cmItem_copy.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_copy);
				contextMenu.customItems.push(cmItem_copy);

				// コンテキストメニュー：削除
				var cmItem_delete:ContextMenuItem = new ContextMenuItem(_rpLinkListAuthrisation.getItemAt(3).label);
				cmItem_delete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_delete);
				contextMenu.customItems.push(cmItem_delete);
			}
			else {
				// コンテキストメニュー：参照
				var cmItem_ref:ContextMenuItem = new ContextMenuItem(_rpLinkList.getItemAt(0).label);
				cmItem_ref.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_ref);
				contextMenu.customItems.push(cmItem_ref);
			}

			// コンテキストメニューを返す.
			return contextMenu;
		}

		/**
		 * 取引先一覧 コンテキストメニューの有効/無効設定.
		 * ※リンクメニューの enabled によりコンテキストメニューの enabled を設定しているため.
		 *   リンクメニューの enabled を設定したあとで、呼び出すこと.
		 *
		 * @param enable     メニュー有効（未使用）.
		 */
		private function setEnabledContextMenu_customerList(enable:Boolean = true):void
		{
			var contextMenu:ContextMenu = view.customerList.contextMenu as ContextMenu;
			var link:ArrayCollection = view.rpLinkList.dataProvider as ArrayCollection;
			if (contextMenu && contextMenu.customItems && link) {
				// コンテキストメニューを取得する.
				for (var i:int = 0; i < contextMenu.customItems.length; i++) {
					var item:ContextMenuItem = contextMenu.customItems[i];
					// リンクメニューの有効/無効と同様に設定する.
					for (var k:int = 0; k < link.length; k++) {
						if (ObjectUtil.compare(item.caption, link.getItemAt(k).label) == 0) {
							item.enabled = link.getItemAt(k).enabled;
							break;
						}
					}
				}
			}
		}


		/**
		 * 取引先一覧表示のクリア.
		 *
		 */
		 private function clearDisplayData():void
		 {
			// 取引先一覧をクリアする.
			view.customerList.dataProvider = null;

			// メニューをクリアする.
			setEnabledRpLinkList_customerList (false);
			setEnabledContextMenu_customerList(false);

			// 担当者一覧をクリアする.
	        view.customerMemberList.dataProvider = null;
		 }


		/**
		 * ファイル選択.
		 * ※upload or downloadファイルをファイル参照ダイアログボックスから選択したときに送出される.
		 *
		 * @param event Event
		 */
		private function onSelect_readCustomerFile(event:Event):void
		{
			// 処理中メッセージを表示する.
			open_message("取引先情報読み込みを開始します。");

			// Requestを設定する.
			var req:URLRequest = new URLRequest();
			req.url    = SERVLET_UPLOAD;
			req.method = URLRequestMethod.POST;

			// アップロードする.
			_uploadFileRf = FileReference(event.target);
			_uploadFileRf.upload(req);
		}

		/**
		 * ファイル選択キャンセル.
		 * ※upload or download するファイルをファイル参照ダイアログボックスからキャンセルしたときに送出される.
		 *
		 * @param event Event
		 */
		private function onCancel_readCustomerFile(event:Event):void
		{
			//trace("取引先ファイル読み込みをキャンセルしました。");
			// 処理中メッセージをクローズする.
			close_message();

			// ファイル読み込みイベントを削除する.
			removeEvent_readCustomerFile();
		}

		/**
		 * ファイル送受信中.
		 * ※ファイルの upload or download 中に定期的に送出されます.
		 *
		 * @param event ProgressEvent
		 */
		private function onProgress_readCustomerFile(event:ProgressEvent):void
		{
			// trace("読み込んだバイト数：" + event.bytesLoaded + "、 全体のバイト数：" + event.bytesTotal);
			// 処理中メッセージを表示する.
			var prog:int = event.bytesLoaded / event.bytesTotal * 100;
			open_message("取引先情報読み込み処理中です。。。" + prog + "%");
		}

		/**
		 * ファイル送受信完了.
		 * ※download 完了 or upload で HTTPステータスコード 200 が生成された場合に送出される.
		 *
		 * @param event Event
		 */
		private function onComplete_readCustomerFile(event:Event):void
		{
			// Alert.show("取引先情報ファイルの読み込み完了です。");
		}

		/**
		 * ファイル送信完了の応答受信.
		 * ※upload 正常終了後、サーバーからデータを受信したときに送出される.
		 *   サーバーからデータが返されないと、このイベントは送出されない.
		 *
		 * @param event DataEvent
		 */
		private function onDone_readCustomerFile(event:DataEvent):void
		{
			// ファイル読み込みイベントを削除する.
			removeEvent_readCustomerFile();

			// trace (event.data);
			var xml:XML = new XML(event.data);
			// 取引先情報ファイルを変換する.
			_uploadCustomerInfoList = CustomerDto.convert(xml);
			if (_uploadCustomerInfoList && _uploadCustomerInfoList.length > 0) {
				// 変換した取引先ファイル情報を読み込む.
				readCustomerFileList();
			}
			else {
				// 取引先情報なしのメッセージを表示する..
				CustomerLogic.info_readCustomerFile_nothing();
			}
		}

		/**
		 * ファイル送受信エラー.
		 * ※upload or download が失敗したときに送出される.
		 *
		 * @param event IOErrorEvent
		 */
		private function IOError_readCustomerFile(event:IOErrorEvent):void
		{
			// ファイル読み込みイベントを削除する.
			removeEvent_readCustomerFile();

			// 取引先ファイル読み込み失敗のメッセージを表示する..
			CustomerLogic.alert_readCustomerFile();
		}

		/**
		 * 取引先ファイル読み込み終了処理.
		 */
		 private function removeEvent_readCustomerFile():void
		 {
			// 処理中メッセージをクローズする.
			close_message();

			// ファイルアップロードイベントを削除する.
		 	_uploadFileRf.removeEventListener(Event.SELECT, onSelect_readCustomerFile);					// ファイル選択.
		 	_uploadFileRf.removeEventListener(Event.CANCEL, onCancel_readCustomerFile);					// ファイル選択キャンセル.
			_uploadFileRf.removeEventListener(ProgressEvent.PROGRESS, onProgress_readCustomerFile);		// ファイル送受信中.
			_uploadFileRf.removeEventListener(Event.COMPLETE, onComplete_readCustomerFile);				// ファイル送受信完了.
			_uploadFileRf.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onDone_readCustomerFile);	// ファイル送信完了の応答受信.
			_uploadFileRf.removeEventListener(IOErrorEvent.IO_ERROR,IOError_readCustomerFile);			// ファイル送受信エラー.
		 }

		/**
		 * 取引先ファイル情報読込処理.
		 *
		 */
		private function readCustomerFileList():void
		{
			if (_uploadCustomerInfoList) {
				// 取引先ファイル情報を読み込む.
				for (var i:int = 0; i < _uploadCustomerInfoList.length; i++) {
					var customer:CustomerDto = _uploadCustomerInfoList.getItemAt(i) as CustomerDto;
					// 顧客情報登録P.U.を表示する.
					open_customerEntry(customer, onClose_customerFileEntry, true);
					// 顧客情報を削除する.
					_uploadCustomerInfoList.removeItemAt(i);
					return;
				}
			}

			requestCustomerList();
			// 取引先ファイル読み込み終了のメッセージを表示する..
			CustomerLogic.info_readCustomerFile();
		}


		/**
		 * ファイル保存場所選択.
		 * ※upload or downloadファイルをファイル参照ダイアログボックスから選択したときに送出される.
		 *
		 * @param event Event
		 */
		private function onSelect_outputCustomerFile(event:Event):void
		{
			open_message("取引先情報出力を開始します。");
		}

		/**
		 * ファイル保存場所選択キャンセル.
		 * ※upload or download するファイルをファイル参照ダイアログボックスからキャンセルしたときに送出される.
		 *
		 * @param event Event
		 */
		private function onCancel_outputCustomerFile(event:Event):void
		{
			//trace("取引先ファイル読み込みをキャンセルしました。");
			// ファイル書き込みイベントを削除する.
			removeEvent_outputCustomerFile();
		}

		/**
		 * ファイル送受信中.
		 * ※ファイルの upload or download 中に定期的に送出されます.
		 *
		 * @param event ProgressEvent
		 */
		private function onProgress_outputCustomerFile(event:ProgressEvent):void
		{
			//trace("読み込んだバイト数：" + event.bytesLoaded + "、 全体のバイト数：" + event.currentTarget.size);
			var prog:int = event.bytesLoaded / event.currentTarget.size * 100;
			open_message("取引先情報出力処理中です。。。" + prog + "%");
		}

		/**
		 * ファイル送受信完了.
		 * ※download 完了 or upload で HTTPステータスコード 200 が生成された場合に送出される.
		 *
		 * @param event Event
		 */
		private function onComplete_outputCustomerFile(event:Event):void
		{
			// ファイル書き込みイベントを削除する.
			removeEvent_outputCustomerFile();

			// 取引先情報出力の終了メッセージを表示する.
			CustomerLogic.info_outputCustomerFile();
		}
		/**
		 * ファイル送受信エラー.
		 * ※upload or download が失敗したときに送出される.
		 *
		 * @param event IOErrorEvent
		 */
		private function IOError_outputCustomerFile(event:IOErrorEvent):void
		{
			//trace ("i/o error! download" + event.toString());
			// ファイル読み込みイベントを削除する.
			removeEvent_outputCustomerFile();

			// 取引先ファイル読み込み失敗のメッセージを表示する..
			CustomerLogic.alert_outputCustomerFile();
		}

		/**
		 * 取引先ファイル出力終了処理.
		 */
		 private function removeEvent_outputCustomerFile():void
		 {
			// 処理中メッセージをクローズする.
			close_message();

			// ファイルダウンロードベントを削除する.
		 	_downloadFileRf.removeEventListener(Event.SELECT, onSelect_outputCustomerFile);					// ファイル選択.
		 	_downloadFileRf.removeEventListener(Event.CANCEL, onCancel_outputCustomerFile);					// ファイル選択キャンセル.
			_downloadFileRf.removeEventListener(ProgressEvent.PROGRESS, onProgress_outputCustomerFile);		// ファイル送受信中.
			_downloadFileRf.removeEventListener(Event.COMPLETE, onComplete_outputCustomerFile);				// ファイル送受信完了.
			_downloadFileRf.removeEventListener(IOErrorEvent.IO_ERROR,IOError_outputCustomerFile);			// ファイル送受信エラー.
		 }


		/**
		 * templateファイル保存場所選択.
		 * ※upload or downloadファイルをファイル参照ダイアログボックスから選択したときに送出される.
		 *
		 * @param event Event
		 */
		private function onSelect_templateCustomerFile(event:Event):void
		{
			open_message("取引先情報テンプレート取得を開始します。");
		}

		/**
		 * templateファイル保存場所選択キャンセル.
		 * ※upload or download するファイルをファイル参照ダイアログボックスからキャンセルしたときに送出される.
		 *
		 * @param event Event
		 */
		private function onCancel_templateCustomerFile(event:Event):void
		{
			//trace("取引先ファイル読み込みをキャンセルしました。");
			// ファイル書き込みイベントを削除する.
			removeEvent_templateCustomerFile();
		}

		/**
		 * templateファイル送受信中.
		 * ※ファイルの upload or download 中に定期的に送出されます.
		 *
		 * @param event ProgressEvent
		 */
		private function onProgress_templateCustomerFile(event:ProgressEvent):void
		{
			//trace("読み込んだバイト数：" + event.bytesLoaded + "、 全体のバイト数：" + event.currentTarget.size);
			var prog:int = event.bytesLoaded / event.currentTarget.size * 100;
			open_message("取引先情報テンプレート取得中です。。。" + prog + "%");
		}

		/**
		 * templateファイル送受信完了.
		 * ※download 完了 or upload で HTTPステータスコード 200 が生成された場合に送出される.
		 *
		 * @param event Event
		 */
		private function onComplete_templateCustomerFile(event:Event):void
		{
			// ファイル書き込みイベントを削除する.
			removeEvent_templateCustomerFile();

			// 取引先情報出力の終了メッセージを表示する.
			CustomerLogic.info_templateCustomerFile();
		}
		/**
		 * templateファイル送受信エラー.
		 * ※upload or download が失敗したときに送出される.
		 *
		 * @param event IOErrorEvent
		 */
		private function IOError_templateCustomerFile(event:IOErrorEvent):void
		{
			//trace ("i/o error! download" + event.toString());
			// ファイル読み込みイベントを削除する.
			removeEvent_templateCustomerFile();

			// 取引先ファイル読み込み失敗のメッセージを表示する..
			CustomerLogic.alert_templateCustomerFile();
		}

		/**
		 * template取引先ファイル出力終了処理.
		 */
		 private function removeEvent_templateCustomerFile():void
		 {
			// 処理中メッセージをクローズする.
			close_message();

			// ファイルダウンロードベントを削除する.
		 	_downloadFileRf.removeEventListener(Event.SELECT, onSelect_templateCustomerFile);					// ファイル選択.
		 	_downloadFileRf.removeEventListener(Event.CANCEL, onCancel_templateCustomerFile);					// ファイル選択キャンセル.
			_downloadFileRf.removeEventListener(ProgressEvent.PROGRESS, onProgress_templateCustomerFile);		// ファイル送受信中.
			_downloadFileRf.removeEventListener(Event.COMPLETE, onComplete_templateCustomerFile);				// ファイル送受信完了.
			_downloadFileRf.removeEventListener(IOErrorEvent.IO_ERROR,IOError_templateCustomerFile);			// ファイル送受信エラー.
		 }


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CustomerList;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CustomerList
	    {
	        if (_view == null) {
	            _view = super.document as CustomerList;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CustomerList):void
	    {
	        _view = view;
	    }
	}
}