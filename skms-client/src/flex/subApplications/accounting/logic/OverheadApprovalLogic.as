package subApplications.accounting.logic
{
	import components.PopUpWindow;

	import dto.StaffDto;

	import enum.OverheadNextActionId;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import subApplications.accounting.dto.OverheadDto;
	import subApplications.accounting.web.OverheadApproval;
	import subApplications.accounting.web.OverheadEntry;
	import subApplications.accounting.web.OverheadEntryWithdraw;


	/**
	 * 諸経費申請のLogicクラスです.
	 */
	public class OverheadApprovalLogic extends Logic
	{
		/** リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
		    = new ArrayCollection([
		    	{label:"承認",				func:"onClick_linkList_approval",													 	enabled:false,	enabledCheck:OverheadNextActionId.APPROVAL_PM},
				{label:"承認前に戻す",		func:"onClick_linkList_approvalCancel",													enabled:false,	enabledCheck:OverheadNextActionId.APPROVAL_CANCEL_PM},
				{label:"申請者に差し戻す",	func:"onClick_linkList_approvalWithdraw",												enabled:false,	enabledCheck:OverheadNextActionId.APPROVAL_REJECT_PM},
				{label:"支払",				func:"onClick_linkList_payment",			prepare:"onClick_linkList_payment_confirm",	enabled:false,	enabledCheck:OverheadNextActionId.PAY},
				{label:"支払前に戻す",		func:"onClick_linkList_paymentCancel",													enabled:false,	enabledCheck:OverheadNextActionId.PAY_CANCEL}
			]);
		private const RP_LINKLIST_AF:ArrayCollection
		    = new ArrayCollection([
		    	{label:"承認",				func:"onClick_linkList_approvalAf",													 	enabled:false,	enabledCheck:OverheadNextActionId.APPROVAL_GA},
				{label:"承認前に戻す",		func:"onClick_linkList_approvalCancel",													enabled:false,	enabledCheck:OverheadNextActionId.APPROVAL_CANCEL_GA},
				{label:"申請者に差し戻す",	func:"onClick_linkList_approvalWithdraw",												enabled:false,	enabledCheck:OverheadNextActionId.APPROVAL_REJECT_GA},
				{label:"支払",				func:"onClick_linkList_payment",			prepare:"onClick_linkList_payment_confirm",	enabled:false,	enabledCheck:OverheadNextActionId.PAY},
				{label:"支払前に戻す",		func:"onClick_linkList_paymentCancel",													enabled:false,	enabledCheck:OverheadNextActionId.PAY_CANCEL}
			]);

		/** 選択されたリンクバー */
		protected var _selectedLinkObject:Object;

		/** 選択された一覧データ */
		protected var _selectedOverhead:Object;



//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function OverheadApprovalLogic()
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
			// 承認権限（PM or 総務）を確認する.
			view.authorizeApproval = true;

			// 動作モードを設定する.
			var staff:StaffDto = Application.application.indexLogic.loginStaff;
			if (staff.isDepartmentHeadGA()) {
				view.rpLinkList.dataProvider = RP_LINKLIST_AF;
				view.actionMode = AccountingLogic.ACTION_VIEW_APPROVAL_AF;
			}
			else {
				view.rpLinkList.dataProvider = RP_LINKLIST;
				view.actionMode = AccountingLogic.ACTION_VIEW_APPROVAL;
			}

			view.overheadSearch.actionMode = view.actionMode;
			view.overheadList.actionMode   = view.actionMode;

			// 諸経費リストを取得する.
			requestOverheads();
	    }



//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList(e:MouseEvent):void
		{
			// 選択したリンクボタンの処理を呼び出す.
			_selectedLinkObject = view.rpLinkList.dataProvider.getItemAt(e.target.instanceIndex);
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
	     * @param e ItemClickEvent
	     */
		protected function onClick_linkList_confirmResult(e:CloseEvent):void
		{
			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.YES) {
				this[_selectedLinkObject.func]();
			}
		}

	    /**
	     * リンクボタン選択 承認.<br>
	     *
	     */
		protected function onClick_linkList_approval():void
		{
			var pop:OverheadEntry = new OverheadEntry();
			pop.actionMode = AccountingLogic.ACTION_APPROVAL;
			pop.authorizeApproval = view.authorizeApproval;
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, {overhead:_selectedOverhead});
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadApproval);
		}
		protected function onClick_linkList_approvalAf():void
		{
			var pop:OverheadEntry = new OverheadEntry();
			pop.actionMode = AccountingLogic.ACTION_APPROVAL_AF;
			pop.authorizeApproval = view.authorizeApproval;
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, {overhead:_selectedOverhead});
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadApprovalAf);
		}

	    /**
	     * リンクボタン選択 承認取り消し.<br>
	     *
	     */
		protected function onClick_linkList_approvalCancel():void
		{
			var obj:Object = new Object();
			obj.entry      = "承認";
			obj.withdraw   = "取り消し";
			obj.actionMode = AccountingLogic.ACTION_APPROVAL_CANCEL;
			obj.overhead   = _selectedOverhead;
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(OverheadEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadApprovalCancel);
		}

	    /**
	     * リンクボタン選択 承認取り下げ.<br>
	     *
	     */
		protected function onClick_linkList_approvalWithdraw():void
		{
			var obj:Object = new Object();
			obj.entry      = "承認";
			obj.withdraw   = "取り下げ";
			obj.actionMode = AccountingLogic.ACTION_APPROVAL_WITHDRAW;
			obj.overhead   = _selectedOverhead;
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(OverheadEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadApprovalWithdraw);
		}

	    /**
	     * リンクボタン選択 支払.<br>
	     *
	     */
		protected function onClick_linkList_payment_confirm():void
		{
			Alert.show("支払扱いとしてもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		protected function onClick_linkList_payment():void
		{
			view.srv.getOperation("paymentOverhead").send(Application.application.indexLogic.loginStaff, _selectedOverhead);
		}

	    /**
	     * リンクボタン選択 支払取り消し.<br>
	     *
	     */
		protected function onClick_linkList_paymentCancel():void
		{
			var obj:Object = new Object();
			obj.entry      = "支払";
			obj.withdraw   = "取り消し";
			obj.actionMode = AccountingLogic.ACTION_PAYMENT_CANCEL;
			obj.overhead   = _selectedOverhead;
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(OverheadEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadPaymentCancel);
		}


		/**
		 * 諸経費一覧リストの選択.
		 *
		 * @param e ListEvent.
		 */
		public function onChangeDataGrid_overheadList(e:ListEvent):void
		{
			// 一覧リストを設定する.
			_selectedOverhead = view.overheadList.selectedItem;
			if (_selectedOverhead) {
				view.overheadDetail.dataProvider  = _selectedOverhead.overheadDetails;
				view.overheadHistory.dataProvider = _selectedOverhead.overheadHistorys;
			}
			else {
				view.overheadDetail.dataProvider  = null;
				view.overheadHistory.dataProvider = null;
			}

			// リンクボタンを設定する.
			setRpLinkList_overheadList();
		}


		/**
		 * 諸経費承認P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadApproval(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY || e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}
		private function onClose_overheadApprovalAf(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY || e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}

		/**
		 * 諸経費承認取り消しP.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadApprovalCancel(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY || e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}

		/**
		 * 諸経費承認取り下げP.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadApprovalWithdraw(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY || e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}

		/**
		 * 諸経費支払取り消しP.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadPaymentCancel(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY || e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}


		/**
		 * getApprovaltOverheadsの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getApprovalOverheads(e:ResultEvent):void
		{
			view.overheadList.dataProvider = e.result as ArrayCollection;
			view.overheadDetail.dataProvider  = null;
			view.overheadHistory.dataProvider = null;


			// 選択行を表示する.
			var list:ArrayCollection = e.result as ArrayCollection;
	        if (_selectedOverhead && list) {
				for (var index:int = 0; index < list.length; index++) {
				var overhead:Object = list.getItemAt(index);
					if (OverheadDto.compare(_selectedOverhead, overhead)) {
						view.overheadList.selectedIndex = index;
						onChangeDataGrid_overheadList(new ListEvent("onResult_getApprovalOverheads"));
						view.overheadList.scrollToIndex(index);
						break;
					}
				}
			}
			_selectedOverhead = view.overheadList.selectedItem;

			// リンクボタンを設定する.
			setRpLinkList_overheadList();
		}

		/**
		 * paymentOverheadの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_paymentOverhead(e:ResultEvent):void
		{
			requestOverheads();
		}


		/**
		 * getApprovaltOverheadsの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getApprovalOverheads(e:FaultEvent):void
		{
			AccountingLogic.alert_getApprovalOverheads(e);
		}

		/**
		 * paymentOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_paymentOverhead(e:FaultEvent):void
		{
			var conflict:Boolean = AccountingLogic.alert_paymentOverhead(e);
			if (conflict)
				requestOverheads();
		}



//--------------------------------------
//  Function
//--------------------------------------
		/**
	     * 諸経費一覧 リンクボタン設定.
	     *
	     * @param enable リンクボタン有効.
	     * @return リンクボタンリスト.
	     */
	     private function setRpLinkList_overheadList(enable:Boolean = true):void
	     {
			// リンクボタンの数分繰り返し.
			for(var i:int = 0; i < view.rpLinkList.dataProvider.length; i++) {
				// リンクボタンオブジェクトの取得.
				var linkObject:Object = view.rpLinkList.dataProvider.getItemAt(i);
				if (enable) {
					// 可否チェック用プロパティが定義されていたら.
					if (linkObject.hasOwnProperty("enabledCheck")) {
						// 可否チェック.
						linkObject.enabled = false;
						var overhead:Object = view.overheadList.selectedItem;
						if (overhead) {
							linkObject.enabled = OverheadNextActionId.check(linkObject.enabledCheck, overhead.overheadNextActions);
						}
					}
					else {
						linkObject.enabled = true;
					}
				}
				else {
					linkObject.enabled = false;
				}
			}
			// リンクボタンリストを更新する.
			view.rpLinkList.dataProvider.refresh();
	     }


		/**
		 * 諸経費の問合せ.
		 *
		 */
		public function requestOverheads():void
		{
			view.overheadSearch.requestOverheads();
		}

		/**
		 * 諸経費の問い合わせ中.
		 *
		 * @param e Event.
		 */
		public function onRequestingOverheads(e:Event):void
		{
			setRpLinkList_overheadList(false);
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:OverheadApproval;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():OverheadApproval
	    {
	        if (_view == null) {
	            _view = super.document as OverheadApproval;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:OverheadApproval):void
	    {
	        _view = view;
	    }

	}
}

