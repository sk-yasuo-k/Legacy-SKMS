package subApplications.accounting.logic
{
	import components.PopUpWindow;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationDto;
	import subApplications.accounting.web.TransportApproval;
	import subApplications.accounting.web.TransportEntryWithdraw;

	/**
	 * TransportApprovalのLogicクラスです.
	 */
	public class TransportApprovalLogic extends AccountingLogic
	{
		/** 申請・承認一覧で取得した交通費申請情報リスト */
		protected var _getTransList:ArrayCollection;

		/** Viewモード */
		private var _actionViewItem:Object;
		/** Viewモードリスト */
		private const ACTION_VIEW_ITEMS:Array = new Array({mode:ACTION_VIEW_APPROVAL,    link:"getRpLinkList"},
														  {mode:ACTION_VIEW_APPROVAL_AF, link:"getRpLinkList_AF"}
														  );
		/** 交通費一覧 通常リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
			= new ArrayCollection([
				{label:"承認",			action:ACTION_APPROVAL,			func:"onClick_linkList_approval",			prepare:"onClick_linkList_approval_confirm",	enabled:false,	enabledCheck:true},
				{label:"承認前に戻す",	action:ACTION_APPROVAL_CANCEL,	func:"onClick_linkList_approvalCancel",														enabled:false,	enabledCheck:true},
				{label:"申請者に差し戻す",	action:ACTION_APPROVAL_WITHDRAW,func:"onClick_linkList_approvalWithdraw",												enabled:false,	enabledCheck:true},
				{label:"支払",			action:ACTION_PAYMENT,			func:"onClick_linkList_payment",			prepare:"onClick_linkList_payment_confirm",		enabled:false,	enabledCheck:true},
				{label:"支払前に戻す",	action:ACTION_PAYMENT_CANCEL,	func:"onClick_linkList_paymentCancel",														enabled:false,	enabledCheck:true}
			]);
		/** 交通費一覧 承認リンクボタンリスト */
		private const RP_LINKLIST_AF:ArrayCollection
			= new ArrayCollection([
				{label:"承認",			action:ACTION_APPROVAL,			func:"onClick_linkList_approval",			prepare:"onClick_linkList_approval_confirm",	enabled:false,	enabledCheck:true},
				{label:"承認前に戻す",	action:ACTION_APPROVAL_CANCEL,	func:"onClick_linkList_approvalCancel",														enabled:false,	enabledCheck:true},
				{label:"申請者に差し戻す",	action:ACTION_APPROVAL_WITHDRAW,func:"onClick_linkList_approvalWithdraw",												enabled:false,	enabledCheck:true},
				{label:"支払",			action:ACTION_PAYMENT,			func:"onClick_linkList_payment",			prepare:"onClick_linkList_payment_confirm",		enabled:false,	enabledCheck:true},
				{label:"支払前に戻す",	action:ACTION_PAYMENT_CANCEL,	func:"onClick_linkList_paymentCancel",														enabled:false,	enabledCheck:true}
			]);

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function TransportApprovalLogic()
		{
			super();
//			Alert.show("経理モードで表示しますか？", "暫定処理です。", 3, view, aaaaa);
		}

		private var debugaction:String = ACTION_VIEW_APPROVAL;
//		private function aaaaa(event:CloseEvent):void {
//			if (event.detail == Alert.YES) {
//				debugaction = ACTION_VIEW_APPROVAL_AF;
//				onCreationCompleteHandler(new FlexEvent("aaaaa"));
//			}
//		}

//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * onCreationCompleteHandler
	     */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
	    {

	    	if (Application.application.indexLogic.loginStaff.staffDepartmentHead != null
	    		&& Application.application.indexLogic.loginStaff.staffDepartmentHead.length > 0
	    		&& Application.application.indexLogic.loginStaff.staffDepartmentHead[0].departmentId == 2) {
					debugaction = ACTION_VIEW_APPROVAL_AF;
	    		}

	    	// 引き継ぎデータを取得する.
	    	onCreationCompleteHandler_setSuceedData();

			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
			// debug.
			_actionView = debugaction;

			// viewモードを確認する.
			_actionViewItem = ACTION_VIEW_ITEMS[0];
			for (var i:int = 0; i < ACTION_VIEW_ITEMS.length; i++) {
				if (ObjectUtil.compare(_actionView, ACTION_VIEW_ITEMS[i].mode) == 0) {
					_actionViewItem = ACTION_VIEW_ITEMS[i];
					break;
				}
			}
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

			// 承認リストを取得する.
			view.transportationSearch.actionMode = _actionView;
			view.transportationSearch.initTransportations();
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

			// 交通費明細一覧を設定する.
			if (index >= 0)
		        view.transportationDetail.dataProvider = _getTransList.getItemAt(index).transportationDetails;
			else
		        view.transportationDetail.dataProvider = new ArrayCollection();

			// 交通費申請履歴一覧を設定する.
			if (index >= 0)
				view.transportationHistory.dataProvider = _getTransList.getItemAt(index).transportationHistorys;
			else
				view.transportationHistory.dataProvider = new ArrayCollection();
		}

		/**
		 * リンクボタン選択.
		 *
		 * @param e ItemClickEvent.
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
		 * リンクボタン選択 承認確認.
		 *
		 * @param e Event
		 */
		protected function onClick_linkList_approval_confirm(e:Event):void
		{
			Alert.show("承認してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		/**
		 * リンクボタン選択 承認.
		 *
		 */
		protected function onClick_linkList_approval():void
		{
			// 承認する.
			view.srv.getOperation("approvalTransportation").send(Application.application.indexLogic.loginStaff, _selectedTransportDto);
		}

	    /**
	     * リンクボタン選択 承認取り消し.
	     *
	     */
		protected function onClick_linkList_approvalCancel():void
		{
//			// TransportEntryWithdraw（交通費承認取り消し）を作成する.
//			var pop:TransportEntryWithdraw = new TransportEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = makeSucceedData_withdraw("", "承認前に戻す");
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApprovalCancel);
//
//			// TransportEntryWithdrawを表示する.
//			PopUpManager.centerPopUp(pop);
			// TransportEntryWithdraw（交通費承認取り消し）を表示する.
			var obj:Object = makeSucceedData_withdraw("", "承認前に戻す");
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApprovalCancel);
		}

	    /**
	     * リンクボタン選択 承認取り下げ.
	     *
	     */
		protected function onClick_linkList_approvalWithdraw():void
		{
//			// TransportEntryWithdraw（交通費承認取り下げ）を作成する.
//			var pop:TransportEntryWithdraw = new TransportEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = makeSucceedData_withdraw("", "申請者に差し戻す");
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApprovalWithdraw);
//
//			// TransportEntryWithdrawを表示する.
//			PopUpManager.centerPopUp(pop);
			// TransportEntryWithdraw（交通費承認取り下げ）を表示する.
			var obj:Object = makeSucceedData_withdraw("", "申請者に差し戻す");
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportApprovalWithdraw);
		}

		/**
		 * リンクボタン選択 支払確認.
		 *
		 * @param e Event
		 */
		protected function onClick_linkList_payment_confirm(e:Event):void
		{
			Alert.show("支払扱いとしてもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		/**
		 * リンクボタン選択 支払.
		 *
		 */
		protected function onClick_linkList_payment():void
		{
			// 支払をする.
			view.srv.getOperation("paymentTransportation").send(Application.application.indexLogic.loginStaff, _selectedTransportDto);
		}

		/**
		 * リンクボタン選択 支払取り消し.
		 *
		 */
		protected function onClick_linkList_paymentCancel():void
		{
//			// TransportEntryWithdraw（交通費支払取り消し）を作成する.
//			var pop:TransportEntryWithdraw = new TransportEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = makeSucceedData_withdraw("", "支払前に戻す");
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_transportPaymentCancel);
//
//			// TransportEntryWithdrawを表示する.
//			PopUpManager.centerPopUp(pop);
			// TransportEntryWithdraw（交通費支払取り消し）を表示する.
			var obj:Object = makeSucceedData_withdraw("", "支払前に戻す");
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportPaymentCancel);
		}

		/**
		 * getApprovalTransportations／getApprovalTransportations_AF(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_transportationSearch(e:ResultEvent):void
		{
			// 結果を取得する.
			_getTransList = e.result as ArrayCollection;

			// 承認一覧を作成する.
			view.transportationList.dataProvider = _getTransList;
			setRpLinkList_transportationList();

			// 交通費明細一覧を作成する.
	        view.transportationDetail.dataProvider  = new ArrayCollection();
	        view.transportationDetail.selectedIndex = INDEX_INVALID;

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
		 * approvalTransportation(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_approvalTransportation(e:ResultEvent):void
		{
			// 最新の交通費情報を取得する.
			onCreationCompleteHandler_setDisplayData();
		}

		/**
		 * paymentTransportation(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_paymentTransportation(e:ResultEvent):void
		{
			// 最新の交通費情報を取得する.
			onCreationCompleteHandler_setDisplayData();
		}

		/**
	     * getApprovalTransportations／getApprovalTransportations_AF(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_transportationSearch(e:FaultEvent):void
		{
			super.onFault_getXxxxx(e, true, "交通費承認データ");
			// 表示データをクリアする.
			clearDisplayData();
		}

		/**
	     * approvalTransportation(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_approvalTransportation(e:FaultEvent):void
		{
			super.onFault_updateXxxxx(e, true, "承認");
		}

		/**
	     * paymentTransportation(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_paymentTransportation(e:FaultEvent):void
		{
			super.onFault_updateXxxxx(e, true, "支払処理");
		}

		/**
		 * TransportApprovalCancel（交通費承認取り消し）のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		public function onClose_transportApprovalCancel(e:CloseEvent):void
		{
			// 最新データを取得する.
			if (e.detail == PopUpWindow.ENTRY) {
		    	onCreationCompleteHandler_setDisplayData();
			}
		}

		/**
		 * TransportApprovalWithdraw（交通費承認取り下げ）のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		public function onClose_transportApprovalWithdraw(e:CloseEvent):void
		{
			// 最新データを取得する.
			if (e.detail == PopUpWindow.ENTRY) {
		    	onCreationCompleteHandler_setDisplayData();
			}
		}

		/**
		 * TransportPaymentCancel（交通費支払取り消し）のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		public function onClose_transportPaymentCancel(e:CloseEvent):void
		{
			// 最新データを取得する.
			if (e.detail == PopUpWindow.ENTRY) {
		    	onCreationCompleteHandler_setDisplayData();
			}
		}


		/**
	     * 交通費一覧 リンクボタン設定.
	     *
	     * @return リンクボタンリスト.
	     */
		private function setRpLinkList_transportationList():void
		{
			view.rpLinkList.dataProvider = this[_actionViewItem.link]();
		}

		/**
	     * 交通費一覧 通常リンクボタン取得.
	     *
	     * @return リンクボタンリスト.
	     */
		private function getRpLinkList():ArrayCollection
		{
			var rplist:ArrayCollection = getRpLinkList_transportationList(ObjectUtil.copy(RP_LINKLIST) as ArrayCollection);
			return rplist;
		}

		/**
	     * 交通費一覧 経理リンクボタン取得.
	     *
	     * @return リンクボタンリスト.
	     */
		private function getRpLinkList_AF():ArrayCollection
		{
			var rplist:ArrayCollection = getRpLinkList_transportationList(ObjectUtil.copy(RP_LINKLIST_AF) as ArrayCollection);
			return rplist;
		}

		/**
	     * 交通費一覧 リンクボタン取得.
	     *
	     * @return リンクボタンリスト.
	     */
		private function getRpLinkList_transportationList(rplist:ArrayCollection):ArrayCollection
		{
			// 実行可能なリンクボタンを設定する.
			var transport:TransportationDto = view.transportationList.selectedItem as TransportationDto;
			if (transport) {
				for (var index:int = 0; index < rplist.length; index++) {
					// リンクボタンのリストを取得する.
					var linkObject:Object   = rplist.getItemAt(index);
					// 各状態を確認する.
					if (!linkObject.enabledCheck)	continue;
					var msg:String = transport.updateTransportation(linkObject.action);
					if (msg) 	linkObject.enabled = false;
					else		linkObject.enabled = true;
					// リンクボタンのリストを設定する.
					rplist.setItemAt(linkObject, index);
				}
			}
			return rplist;
		}

		/**
		 * 交通費承認一覧表示のクリア.
		 *
		 */
		 private function clearDisplayData():void
		 {
			// 交通費一覧をクリアする.
			view.transportationList.dataProvider = null;
			setRpLinkList_transportationList();

			// 交通費明細一覧をクリアする.
	        view.transportationDetail.dataProvider = null;
	        view.transportationDetail.selectedIndex = INDEX_INVALID;

			// 交通費申請履歴一覧をクリアする.
			view.transportationHistory.dataProvider = null;
	        view.transportationHistory.selectedIndex = INDEX_INVALID;
		 }

//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:TransportApproval;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():TransportApproval
	    {
	        if (_view == null) {
	            _view = super.document as TransportApproval;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:TransportApproval):void
	    {
	        _view = view;
	    }
	}
}