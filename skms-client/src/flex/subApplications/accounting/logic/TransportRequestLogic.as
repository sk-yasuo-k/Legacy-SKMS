package subApplications.accounting.logic
{
	import components.PopUpWindow;

	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationDto;
	import subApplications.accounting.web.RouteEntry;
	import subApplications.accounting.web.TransportApply;
	import subApplications.accounting.web.TransportEntry;
	import subApplications.accounting.web.TransportEntryWithdraw;
	import subApplications.accounting.web.TransportRequest;

	/**
	 * TransportRequesのLogicクラスです.
	 */
	public class TransportRequestLogic extends AccountingLogic
	{
		/** 申請・承認一覧で取得した交通費申請情報リスト */
		protected var _getTransList:ArrayCollection;

		/** RemoteObjectデータ取得失敗 */
		private var _remoteObjError:Boolean = false;

		/** 交通費一覧 リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
		    = new ArrayCollection([
		    	{label:"新規",		action:ACTION_NEW,				func:"onClick_linkList_create",														enabled:true,	enabledCheck:false},
				{label:"変更",		action:ACTION_UPDATE,			func:"onClick_linkList_create",														enabled:false,	enabledCheck:true,	transportCheck:"isEnabledUpdate"},
				{label:"削除",										func:"onClick_linkList_delete",			prepare:"onClick_linkList_delete_confirm",	enabled:false,	enabledCheck:true,	transportCheck:"isEnabledDelete"},
				{label:"複製",										func:"onClick_linkList_copy",			prepare:"onClick_linkList_copy_confirm",	enabled:false,	enabledCheck:true,	transportCheck:"isEnabledCopy"},
				{label:"申請",		action:ACTION_APPLY,			func:"onClick_linkList_apply",														enabled:false,	enabledCheck:true},
				{label:"申請取り下げ",action:ACTION_APPLY_WITHDRAW,	func:"onClick_linkList_applyWithdraw",												enabled:false,	enabledCheck:true},
				{label:"受領",		action:ACTION_ACCEPT,			func:"onClick_linkList_accept",			prepare:"onClick_linkList_accept_confirm",	enabled:false,	enabledCheck:true},
				{label:"受領取り消し",	action:ACTION_ACCEPT_CANCEL,	func:"onClick_linkList_acceptCancel",												enabled:false,	enabledCheck:true}
			]);

		/** 交通費明細一覧 リンクボタンリスト */
		private const RP_LINKLIST2:ArrayCollection
			= new ArrayCollection([
				{label:"よく使う経路として登録",	action:ACTION_ROUTE_ENTRY,		func:"onClick_linkList2_routeEntry",prepare:"onClick_linkList2_routeEntry_prepare",	enabled:false,	enabledCheck:true}
			]);


		/** 交通費一覧 コンテキストメニューアイテム：交通費変更 */
		private  const CMENU_TRANSPORT_UPDATE:String = "変更";
		/** 交通費一覧 コンテキストメニューアイテム：交通費削除 */
		private  const CMENU_TRANSPORT_DELETE:String = "削除";
		/** 交通費一覧 コンテキストメニューアイテム：交通費コピー */
		private  const CMENU_TRANSPORT_COPY:String   = "複製";

		/** 交通費明細一覧 コンテキストメニューアイテム：経路登録 */
		private  const CMENU_ROUTE_ENTRY:String = "よく使う経路として登録";

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function TransportRequestLogic()
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
	    	// 引き継ぎデータを取得する.
	    	onCreationCompleteHandler_setSuceedData();

			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();

			// コンテキストメニューを設定する.
			onCreationCompleteHandler_setContextMenu();

			// マスタを取得する.
			requestFacilityNameList();									// 交通機関リスト取得.
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
			_actionView = ACTION_VIEW_REQUEST;
		}

	    /**
	     * 表示データの設定.
	     *
	     */
		override protected function onCreationCompleteHandler_setDisplayData():void
		{
			// 交通費一覧の初期データを設定する.
			view.transportationList.actionMode   = _actionView;

			// 明細一覧の初期データを設定する.
			view.transportationDetail.actionMode = _actionView;

			// 申請リストを取得する.
			view.transportationSearch.actionMode = _actionView;
			view.transportationSearch.initTransportations();
		}

		/**
		 * コンテキストメニューの設定.
		 *
		 */
		override protected function onCreationCompleteHandler_setContextMenu():void
		{
			// 交通費一覧 コンテキストメニューを作成する.
			view.transportationList.contextMenu = createContextMenu_transportationList();

			// 交通費明細一覧 コンテキストメニューを作成する.
			view.transportationDetail.contextMenu = createContextMenu_transportationDetail();
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------
//		/**
//		 * キー押下 交通費申請一覧行の選択.
//		 *
//		 * @param e KeyboardEvent
//		 */
//		public function onKeyDown_transportationList(e:KeyboardEvent):void
//		{
//			if (e.target is DataGrid) {
//				switch (e.keyCode) {
//					case Keyboard.UP:
//					case Keyboard.DOWN:
//						onChange_transportationList(e);
//						break;
//				}
//			}
//		}

		/**
		 * クリック 交通費申請一覧行の選択変更.
		 * Multi選択はOFFのため、1行しか選択されない.
		 * →Multi選択をONにすると、交通費情報更新時などでどのデータを更新してよいか判断できない.
		 *
		 * @param e ListEvent or Event or KeyboardEvent
		 */
		public function onChange_transportationList(e:Event):void
		{
			// 選択した交通費情報を取得する.
			var index:int = view.transportationList.selectedIndex;
			_selectedTransportDto = view.transportationList.selectedItem as TransportationDto;

			// 交通費一覧を設定する.
			setRpLinkList_transportationList();
			setContextMenu_transportationList();

			// 交通費明細一覧を設定する.
			if (index >= 0)
	        	view.transportationDetail.dataProvider = _getTransList.getItemAt(index).transportationDetails;
			else
				view.transportationDetail.dataProvider = new ArrayCollection();
			setRpLinkList_transportationDetail();
			setContextMenu_transportationDetail();

			// 交通費申請履歴一覧を設定する.
			if (index >= 0)
				view.transportationHistory.dataProvider = _getTransList.getItemAt(index).transportationHistorys;
			else
				view.transportationHistory.dataProvider = new ArrayCollection();
		}

		/**
		 * 交通費申請一覧行の選択（ダブルクリック）.
		 *
		 * @param e MouseEvent
		 */
		public function onDoubleClick_transportationList(e:MouseEvent):void
		{
			// 選択行でダブルクリックしたとき.
			if (e.target is DataGridItemRenderer) {
				// 変更可能かどうか確認する.
				if (_selectedTransportDto.isEnabledUpdate()) {
					// リンクボタン選択と同じ処理にするためLinkObjectを設定する.

					_selectedLinkObject = RP_LINKLIST.getItemAt(1);
					onClick_linkList_create();
				}
			}
		}

		/**
		 * リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		override public function onClick_linkList(e:MouseEvent):void
		{
//			super.onClick_linkList(e);
//			_selectedLinkObject = RP_LINKLIST.getItemAt(e.target.instanceIndex);
			_selectedLinkObject = view.rpLinkList.dataProvider.getItemAt(e.target.instanceIndex);
			// 選択したリンクボタンの処理を呼び出す.
			if (_selectedLinkObject.hasOwnProperty("prepare")) {
				this[_selectedLinkObject.prepare](e);
			}
			else {
				this[_selectedLinkObject.func]();
			}
		}

	    /**
	     * リンクボタン選択 確認結果.<br>
	     *
	     * @param e ItemClickEvent
	     */
		override protected function onClick_linkList_confirmResult(e:CloseEvent):void
		{
			super.onClick_linkList_confirmResult(e);

			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.YES) {
				this[_selectedLinkObject.func]();
			}
		}

	    /**
	     * リンクボタン選択 新規作成・変更.<br>
	     *
	     */
		protected function onClick_linkList_create():void
		{
//			// TransportEntry（交通費登録）を作成する.
//			var pop:TransportEntry = new TransportEntry();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぎデータを設定する.
//			var obj:Object = makeSucceedData();
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_transportEntry);
//
//			// TransportEntryを表示する.
//			PopUpManager.centerPopUp(pop);
			var obj:Object = makeSucceedData();
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportEntry, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportEntry);
		}

		/**
		 * リンクボタン選択 削除確認.
		 *
		 * @param e Event
		 */
		protected function onClick_linkList_delete_confirm(e:Event):void
		{
			Alert.show("削除してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		/**
		 * リンクボタン選択 削除.
		 *
		 */
		protected function onClick_linkList_delete():void
		{
			// 選択した交通費情報を削除する.
			view.srv.getOperation("deleteTransportation").send(Application.application.indexLogic.loginStaff, _selectedTransportDto);
		}

		/**
		 * リンクボタン選択 コピー確認.
		 *
		 * @param e Event
		 */
		protected function onClick_linkList_copy_confirm(e:Event):void
		{
			Alert.show("複製してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		/**
		 * リンクボタン選択 コピー.
		 *
		 */
		protected function onClick_linkList_copy():void
		{
			// 登録データを作成する.
			var entryDto:TransportationDto = _selectedTransportDto.copyTransportation();

			// 交通費申請を登録する.
			view.srv.getOperation("createTransportation").send(Application.application.indexLogic.loginStaff, entryDto);
		}

	    /**
	     * リンクボタン選択 申請.
	     *
	     */
		protected function onClick_linkList_apply():void
		{
//			// TransportApply（交通費申請）を作成する.
//			var pop:TransportApply = new TransportApply();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぎデータを設定する.
//			var obj:Object = makeSucceedData();
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApply);
//
//			// TransportApplyを表示する.
//			PopUpManager.centerPopUp(pop);
			var obj:Object = makeSucceedData();
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportApply, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApply);
		}

	    /**
	     * リンクボタン選択 申請取り下げ.
	     *
	     */
		protected function onClick_linkList_applyWithdraw():void
		{
//			// TransportEntryWithdraw（交通費申請取り下げ）を作成する.
//			var pop:TransportEntryWithdraw = new TransportEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = makeSucceedData_withdraw("申請", "取り下げ");
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApplyWithdraw);
//
//			// TransportEntryWithdrawを表示する.
//			PopUpManager.centerPopUp(pop);
			var obj:Object = makeSucceedData_withdraw("申請", "取り下げ");
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApplyWithdraw);
		}

	    /**
	     * リンクボタン選択 受領確認.
	     *
	     * @param e Event
	     */
		protected function onClick_linkList_accept_confirm(e:Event):void
		{
			Alert.show("受領扱いとしてもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		/**
		 * リンクボタン選択 受領.
		 *
		 */
		protected function onClick_linkList_accept():void
		{
			// 受領する.
			view.srv.getOperation("acceptTransportation").send(Application.application.indexLogic.loginStaff, _selectedTransportDto);
		}


		/**
	     * リンクボタン選択 受領取り消し.
	     *
	     */
		protected function onClick_linkList_acceptCancel():void
		{
//			// TransportEntryWithdraw（交通費受領取り消し）を作成する.
//			var pop:TransportEntryWithdraw = new TransportEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = makeSucceedData_withdraw("受領", "取り消し");
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_transportAcceptCancel);
//
//			// TransportEntryWithdrawを表示する.
//			PopUpManager.centerPopUp(pop);
			var obj:Object = makeSucceedData_withdraw("受領", "取り消し");
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportAcceptCancel);
		}

		/**
		 * キー押下 交通費明細一覧行の選択.
		 *
		 * @param e KeyboardEvent
		 */
		public function onKeyDown_transportationDetail(e:KeyboardEvent):void
		{
			if (e.target is DataGrid) {
				switch (e.keyCode) {
					case Keyboard.UP:
					case Keyboard.DOWN:
						onChange_transportationDetail(e);
						break;
				}
			}
		}

		/**
		 * クリック 交通費明細一覧行の選択変更.
		 * Multi選択はONFのため、複数行選択される.
		 *
		 * @param e ListEvent or KeyboardEvent
		 */
		public function onChange_transportationDetail(e:Event):void
		{
			setRpLinkList_transportationDetail();
			setContextMenu_transportationDetail();
		}

		/**
		 * 交通費明細一覧 リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList2(e:MouseEvent):void
		{
//			_selectedLinkObject = RP_LINKLIST2.getItemAt(e.target.instanceIndex);
			_selectedLinkObject = view.rpLinkList2.dataProvider.getItemAt(e.target.instanceIndex);
			// 選択したリンクボタンの処理を呼び出す.
			if (_selectedLinkObject.hasOwnProperty("prepare")) {
				this[_selectedLinkObject.prepare](e);
			}
			else {
				this[_selectedLinkObject.func]();
			}
		}

		/**
		 * 交通費明細一覧 リンクボタン選択 経路登録 準備.
		 *
		 * @param e ItemClickEvent
		 */
		protected function onClick_linkList2_routeEntry_prepare(e:Event):void
		{
			// 引き継ぎデータを設定する.
			var indices:Array = view.transportationDetail.selectedIndices.sort(Array.NUMERIC);
			var items:Array = new Array();
			for each (var index:int in indices) {
				items.push(view.transportationDetail.dataProvider.getItemAt(index));
			}
			this[_selectedLinkObject.func](items);
		}
		/**
		 * 交通費明細一覧 リンクボタン選択 経路登録.
		 *
		 * @param items 経路リスト.
		 */
		protected function onClick_linkList2_routeEntry(items:Array):void
		{
//			// RouteEntry（ルート登録）を作成する.
//			var pop:RouteEntry = new RouteEntry();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぎデータを設定する.
//			var obj:Object = makeSucceedData_routeEntry(items);
//			IDataRenderer(pop).data = obj;
//
//			// RouteEntryのクローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_routeEntry);
//
//			// RouteEntryを表示する.
//			PopUpManager.centerPopUp(pop);
			var obj:Object = makeSucceedData_routeEntry(items);
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(RouteEntry, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_routeEntry);
		}

		/**
		 * TransportEntry（交通費登録）のクローズ.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_transportEntry(e:CloseEvent):void
		{
			// 最新データを取得する.
			if (e.detail == PopUpWindow.ENTRY) {
		    	onCreationCompleteHandler_setDisplayData();
			}
		}

		/**
		 * TransportApply（交通費申請）のクローズ.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_transportApply(e:CloseEvent):void
		{
			// 最新データを取得する.
			if (e.detail == PopUpWindow.ENTRY) {
		    	onCreationCompleteHandler_setDisplayData();
			}
		}

		/**
		 * TransportApplyWithdraw（交通費申請取り下げ）のクローズ.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_transportApplyWithdraw(e:CloseEvent):void
		{
			// 最新データを取得する.
			if (e.detail == PopUpWindow.ENTRY) {
		    	onCreationCompleteHandler_setDisplayData();
			}
		}

		/**
		 * TransportAcceptCancel（交通費受領取り消し）のクローズ.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_transportAcceptCancel(e:CloseEvent):void
		{
			// 最新データを取得する.
			if (e.detail == PopUpWindow.ENTRY) {
		    	onCreationCompleteHandler_setDisplayData();
			}
		}

		/**
		 * RouteEntry（ルート登録）のクローズ.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_routeEntry(e:CloseEvent):void
		{
			// 登録前の画面をそのまま表示するため 後処理は何もしない.
		}


	    /**
	     * getRequestTransportations処理の結果イベント.

	     *
	     * @param e ResultEvent
	     */
        public function onResult_transportationSearch(e:ResultEvent):void
        {
        	if (_remoteObjError) {
        		clearDisplayData();
        		return;
        	}

			// 結果を取得する.
			_getTransList = e.result as ArrayCollection;

			// 申請一覧を作成する.
			view.transportationList.dataProvider = _getTransList;
			setRpLinkList_transportationList();
			setContextMenu_transportationList();

			// 交通費明細一覧を作成する.
			view.transportationDetail.dataProvider  = new ArrayCollection();
			view.transportationDetail.selectedIndex = INDEX_INVALID;
			setRpLinkList_transportationDetail();
			setContextMenu_transportationDetail();

			// 交通費申請履歴一覧を作成する.
			view.transportationHistory.dataProvider = new ArrayCollection();
			view.transportationHistory.selectedIndex = INDEX_INVALID;

			// 選択行を表示する.
	        if (_selectedTransportDto && _getTransList) {
				for (var index:int = 0; index < _getTransList.length; index++) {
				var trans:TransportationDto = _getTransList.getItemAt(index) as TransportationDto;
					if (TransportationDto.compare(_selectedTransportDto, trans)) {
						view.transportationList.selectedIndex = index;
						onChange_transportationList(new Event("onResult_transportationSearch"));
						view.transportationList.scrollToIndex(index);
						break;
					}
				}
			}
			_selectedTransportDto = view.transportationList.selectedItem as TransportationDto;
		}

	    /**
	     * deleteTransportation(RemoteObject)の結果受信.
	     *
	     * @param e ResultEvent
	     */
		public function onResult_deleteTransportation(e:ResultEvent):void
		{
			// 最新の交通費申請情報を取得する.
	    	onCreationCompleteHandler_setDisplayData();
		}

		/**
		 * createTransportation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_createTransportation(e:ResultEvent):void
		{
			// 最新の交通費申請情報を取得する.
	    	onCreationCompleteHandler_setDisplayData();
		}

		/**
		 * acceptTransportation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_acceptTransportation(e:ResultEvent):void
		{
			// 最新の交通費申請情報を取得する.
	    	onCreationCompleteHandler_setDisplayData();
		}

		/**
		 * getFacilityNameList(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getFacilityNameList(e:ResultEvent):void
		{
			// 結果を取得する.
			_facilityNameList = e.result as ArrayCollection;
			if (!(_facilityNameList && _facilityNameList.length > 0))
				onFault_getFacilityNameList(new FaultEvent("onResult_getFacilityNameList"));
		}


		/**
	     * getRequestTransportations(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_transportationSearch(e:FaultEvent):void
		{
			super.onFault_getXxxxx(e, true, "交通費申請データ");
			// 表示データをクリアする.
			clearDisplayData();
			_remoteObjError = true;
		}

		/**
	     * deleteTransportation(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_deleteTransportation(e:FaultEvent):void
		{
			super.onFault_updateXxxxx(e, true, "削除");
		}

		/**
	     * deleteTransportation(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_createTransportation(e:FaultEvent):void
		{
			super.onFault_updateXxxxx(e, true, "複製");
		}

		/**
	     * acceptTransportation(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_acceptTransportation(e:FaultEvent):void
		{
			super.onFault_updateXxxxx(e, true, "受領処理");
		}

		/**
	     * getFacilityNameList(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_getFacilityNameList(e:FaultEvent):void
		{
			super.onFault_getXxxxx(e, true, "交通機関");
			clearDisplayData();
			_remoteObjError = true;
		}


		/**
		 * ContextMenu「変更」の選択.
		 *
	     * @param e ContextMenuEvent

		 */
		protected function onMenuSelect_batchUpdate(event:ContextMenuEvent):void
		{
			// リンクボタン選択と同じ処理にするためLinkObjectを設定する.
			_selectedLinkObject = RP_LINKLIST.getItemAt(1);
			onClick_linkList_create();
		}

		/**
		 * ContextMenu「削除」の選択.
		 *
	     * @param e ContextMenuEvent

		 */
		protected function onMenuSelect_batchDelete_confirm(event:ContextMenuEvent):void
		{
			_selectedLinkObject = RP_LINKLIST.getItemAt(2);
			Alert.show("削除するとデータは元に戻りませんが\n削除してもよろしいですか？", "", 3, view, onMenuSelect_batchDelete_confirmResult);
		}
		protected function onMenuSelect_batchDelete_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) {
				onClick_linkList_delete();
			}
		}

		/**
		 * ContextMenu「コピー」の選択.
		 *
	     * @param e ContextMenuEvent

		 */
		protected function onMenuSelect_batchEntry_confirm(event:ContextMenuEvent):void
		{
			_selectedLinkObject = RP_LINKLIST.getItemAt(3);
			Alert.show("複製してもよろしいですか？", "", 3, view, onMenuSelect_batchEntry_confirmResult);
		}
		protected function onMenuSelect_batchEntry_confirmResult(event:CloseEvent):void
		{
			if (event.detail == Alert.YES) {
				onClick_linkList_copy();
			}
		}

		/**
		 * ContextMenu「経路登録」の選択.
		 *
	     * @param e ContextMenuEvent
		 */
		protected function onMenuSelect_routeEntry(event:ContextMenuEvent):void
		{
			_selectedLinkObject = RP_LINKLIST2.getItemAt(0);
			// 選択したリンクボタンの処理を呼び出す.
			if (_selectedLinkObject.hasOwnProperty("prepare")) {
				this[_selectedLinkObject.prepare](event);
			}
		}

		/**
		 * 交通費一覧 コンテキストメニューの作成.
		 *
		 */
		private function createContextMenu_transportationList():ContextMenu
		{
			// コンテキストメニューを作成する.
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// コンテキストメニュー：変更
			var cmItem_update:ContextMenuItem = new ContextMenuItem(CMENU_TRANSPORT_UPDATE);
			cmItem_update.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_batchUpdate);
			contextMenu.customItems.push(cmItem_update);

			// コンテキストメニュー：削除
			var cmItem_delete:ContextMenuItem = new ContextMenuItem(CMENU_TRANSPORT_DELETE);
			cmItem_delete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_batchDelete_confirm);
			contextMenu.customItems.push(cmItem_delete);

			// コンテキストメニュー：コピー
			var cmItem_entry:ContextMenuItem = new ContextMenuItem(CMENU_TRANSPORT_COPY);
			cmItem_entry.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_batchEntry_confirm);
			contextMenu.customItems.push(cmItem_entry);

			// コンテキストメニューを返す.
			return contextMenu;
		}

		/**
		 * 交通費一覧 コンテキストメニューの有効／無効設定.
		 *
		 */
		private function setContextMenu_transportationList():void
		{
			// 有効メニューを作成する.
			var enabledItems:Array = new Array();

			// 選択された交通費情報に応じて有効/無効を設定する.
			var transport:TransportationDto = view.transportationList.selectedItem as TransportationDto;
			if (transport) {
				// 変更.
				if (transport.isEnabledUpdate()) {
					enabledItems.push(CMENU_TRANSPORT_UPDATE);
				}
				// 削除.
				if (transport.isEnabledDelete()) {
					enabledItems.push(CMENU_TRANSPORT_DELETE);
				}
				// コピー.
				if (transport.isEnabledCopy()) {
					enabledItems.push(CMENU_TRANSPORT_COPY);
				}
			}
			setEnabledContextMenu(view.transportationList.contextMenu as ContextMenu, enabledItems);
		}


		/**
	     * 交通費一覧 リンクボタン設定.
	     *
	     * @param enable リンクボタン有効.
	     * @return リンクボタンリスト.
	     */
	     private function setRpLinkList_transportationList(enable:Boolean = true):void
	     {
			view.rpLinkList.dataProvider = getRpLinkList_transportationList(enable);
	     }

		/**
	     * 交通費一覧 リンクボタン取得.
	     *
		 * @param enable リンクボタン有効.
	     * @return リンクボタンリスト.
	     */
		private function getRpLinkList_transportationList(enable:Boolean):ArrayCollection
		{
			// 実行可能なリンクボタンを設定する.
			var rplist:ArrayCollection = ObjectUtil.copy(RP_LINKLIST) as ArrayCollection;
			for (var index:int = 0; index < rplist.length; index++) {
				// リンクボタンを取得する.
				var linkObject:Object   = rplist.getItemAt(index);
				if (enable) {
					// 各状態を確認する.
					if (!linkObject.enabledCheck)	continue;

					var transport:TransportationDto = view.transportationList.selectedItem as TransportationDto;
					if (transport) {
						if (linkObject.transportCheck) {
							if (transport[linkObject.transportCheck]()) 	linkObject.enabled = true;
						}
						else {
							var msg:String = transport.updateTransportation(linkObject.action);
							if (msg) 	linkObject.enabled = false;
							else		linkObject.enabled = true;
						}
					}
				}
				else {
					linkObject.enabled = false;
				}
				// リンクボタンのリストを設定する.
				rplist.setItemAt(linkObject, index);
			}
			return rplist;
		}

		/**
		 * 交通費明細一覧 コンテキストメニューの作成.
		 *
		 */
		private function createContextMenu_transportationDetail():ContextMenu
		{
			// コンテキストメニューを作成する.
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// コンテキストメニュー：経路登録.
			var cmItem_route:ContextMenuItem = new ContextMenuItem(CMENU_ROUTE_ENTRY);
			cmItem_route.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_routeEntry);
			contextMenu.customItems.push(cmItem_route);

			// コンテキストメニューを返す.
			return contextMenu;
		}

		/**
		 * 交通費明細一覧 コンテキストメニューの有効／無効設定.
		 *
		 */
		private function setContextMenu_transportationDetail():void
		{
			// 有効メニューを作成する.
			var enabledItems:Array = new Array();

			// 選択された交通費情報に応じて有効/無効を設定する.
			var transportItems:Array = view.transportationDetail.selectedItems;
			if (transportItems && transportItems.length > 0) {
				// 経路登録.
				enabledItems.push(CMENU_ROUTE_ENTRY);
			}
			setEnabledContextMenu(view.transportationDetail.contextMenu as ContextMenu, enabledItems);
		}

		/**
	     * 交通費明細一覧 リンクボタン設定.
	     *
	     * @param enable リンクボタン有効.
	     * @return リンクボタンリスト.
	     */
	     private function setRpLinkList_transportationDetail(enable:Boolean = true):void
	     {
			view.rpLinkList2.dataProvider = getRpLinkList_transportationDetail(enable);
	     }

	    /**
	     * 交通費明細一覧 リンクボタン取得.
	     *
	     * @param enable リンクボタン有効.
	     * @return リンクボタンリスト.
	     */
		private function getRpLinkList_transportationDetail(enable:Boolean):ArrayCollection
		{
			// 実行可能なリンクボタンを設定する.
			var rplist:ArrayCollection = ObjectUtil.copy(RP_LINKLIST2) as ArrayCollection;
			var transportItems:Array = view.transportationDetail.selectedItems;
			if (transportItems && transportItems.length > 0) {
				for (var index:int = 0; index < rplist.length; index++) {
					if (enable) {
						// リンクボタンのリストを取得する.
						var linkObject:Object   = rplist.getItemAt(index);
						// 各状態を確認する.
						if (!linkObject.enabledCheck)	continue;
						linkObject.enabled = true;
						// リンクボタンのリストを設定する.
						rplist.setItemAt(linkObject, index);
					}
					else {
						linkObject.enabled = false;
					}
				}
			}
			return rplist;
		}

		/**
		 * 交通費申請一覧表示のクリア.
		 *
		 */
		 private function clearDisplayData():void
		 {
			// 交通費一覧をクリアする.
			view.transportationList.dataProvider = null;
	        view.transportationList.selectedIndex = INDEX_INVALID;
			setRpLinkList_transportationList(false);
			setContextMenu_transportationList();

			// 交通費明細一覧をクリアする.
	        view.transportationDetail.dataProvider = null;
	        view.transportationDetail.selectedIndex = INDEX_INVALID;
			setRpLinkList_transportationDetail(false);
			setContextMenu_transportationDetail();

			// 交通費申請履歴一覧をクリアする.
			view.transportationHistory.dataProvider = null;
	        view.transportationHistory.selectedIndex = INDEX_INVALID;

	        // 交通費申請検索不可とする.
	        view.transportationSearch.btnSearch.enabled = false;
			view.transportationSearch.swSearch.enabled  = false;
			view.transportationSearch.searchOpt.enabled = false;
		 }


		/**
		 * 交通機関マスタの取得.
		 *
		 */
		private function requestFacilityNameList():void
		{
			view.srv.getOperation("getFacilityNameList").send(Application.application.indexLogic.loginStaff);
		}

//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:TransportRequest;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():TransportRequest
	    {
	        if (_view == null) {
	            _view = super.document as TransportRequest;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:TransportRequest):void
	    {
	        _view = view;
	    }
	}
}