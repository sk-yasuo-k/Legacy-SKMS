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
	import subApplications.accounting.web.OverheadEntry;
	import subApplications.accounting.web.OverheadEntryWithdraw;
	import subApplications.accounting.web.OverheadRequest;


	/**
	 * 諸経費申請のLogicクラスです.
	 */
	public class OverheadRequestLogic extends Logic
	{
		/** リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
		    = new ArrayCollection([
		    	{label:"新規",			func:"onClick_linkList_new",														enabled:true},
				{label:"変更",			func:"onClick_linkList_update",														enabled:false,	enabledCheck:OverheadNextActionId.UPDATE},
				{label:"削除",			func:"onClick_linkList_delete",			prepare:"onClick_linkList_delete_confirm",	enabled:false,	enabledCheck:OverheadNextActionId.DELETE},
				{label:"複製",			func:"onClick_linkList_copy",														enabled:false,  enabledCheck:OverheadNextActionId.COPY},
				{label:"申請",			func:"onClick_linkList_apply",														enabled:false,	enabledCheck:OverheadNextActionId.APPLY},
				{label:"申請取り下げ",	func:"onClick_linkList_applyWithdraw",												enabled:false,	enabledCheck:OverheadNextActionId.APPLY_CANCEL},
				{label:"受領",			func:"onClick_linkList_accept",			prepare:"onClick_linkList_accept_confirm",	enabled:false,	enabledCheck:OverheadNextActionId.ACCEPT},
				{label:"受領取り消し",	func:"onClick_linkList_acceptCancel",												enabled:false,	enabledCheck:OverheadNextActionId.ACCEPT_CANCEL}
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
		public function OverheadRequestLogic()
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
			var staff:StaffDto = Application.application.indexLogic.loginStaff;
			if (staff.isProjectPositionPM() || staff.isDepartmentHeadGA()) {
				view.authorizeApproval = true;
			}

			// 動作モードを設定する.
			view.overheadSearch.actionMode = view.actionMode;

	    	// リンクボタンを設定する.
	    	view.rpLinkList.dataProvider = RP_LINKLIST;

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
	     * リンクボタン選択 新規.<br>
	     *
	     */
		protected function onClick_linkList_new():void
		{
			var pop:OverheadEntry = new OverheadEntry();
			pop.actionMode = AccountingLogic.ACTION_NEW;
			pop.authorizeApproval = view.authorizeApproval;
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadEntry);
		}

	    /**
	     * リンクボタン選択 変更.<br>
	     *
	     */
		protected function onClick_linkList_update():void
		{
			var pop:OverheadEntry = new OverheadEntry();
			pop.actionMode = AccountingLogic.ACTION_UPDATE;
			pop.authorizeApproval = view.authorizeApproval;
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, {overhead:_selectedOverhead});
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadEntry);
		}

		/**
		 * リンクボタン選択 削除.<br>
		 *
		 */
		protected function onClick_linkList_delete_confirm():void
		{
			Alert.show("削除してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		protected function onClick_linkList_delete():void
		{
			view.srv.getOperation("deleteOverhead").send(Application.application.indexLogic.loginStaff, _selectedOverhead);
		}

	    /**
	     * リンクボタン選択 複製.<br>
	     *
	     */
//		protected function onClick_linkList_copy_confirm():void
//		{
//			Alert.show("複製してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
//		}
		protected function onClick_linkList_copy():void
		{
			var pop:OverheadEntry = new OverheadEntry();
			pop.actionMode = AccountingLogic.ACTION_COPY;
			pop.authorizeApproval = view.authorizeApproval;
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, {overhead:_selectedOverhead});
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadEntry);
		}

	    /**
	     * リンクボタン選択 申請.<br>
	     *
	     */
		protected function onClick_linkList_apply():void
		{
			var pop:OverheadEntry = new OverheadEntry();
			pop.actionMode = "apply";
			pop.authorizeApproval = view.authorizeApproval;
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, {overhead:_selectedOverhead});
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadApply);
		}

	    /**
	     * リンクボタン選択 申請取り下げ.<br>
	     *
	     */
		protected function onClick_linkList_applyWithdraw():void
		{
			var obj:Object = new Object();
			obj.entry      = "申請";
			obj.withdraw   = "取り下げ";
			obj.actionMode = AccountingLogic.ACTION_APPLY_WITHDRAW;
			obj.overhead   = _selectedOverhead;
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(OverheadEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadApplyWithdraw);
		}

	    /**
	     * リンクボタン選択 受領確認.
	     *
	     * @param e Event
	     */
		protected function onClick_linkList_accept_confirm():void
		{
			Alert.show("受領扱いとしてもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		protected function onClick_linkList_accept():void
		{
			// 受領する.
			view.srv.getOperation("acceptOverhead").send(Application.application.indexLogic.loginStaff, _selectedOverhead);
		}

	    /**
	     * リンクボタン選択 受領取り消し.<br>
	     *
	     */
		protected function onClick_linkList_acceptCancel():void
		{
			var obj:Object = new Object();
			obj.entry      = "受領";
			obj.withdraw   = "取り消し";
			obj.actionMode = AccountingLogic.ACTION_ACCEPT_CANCEL;
			obj.overhead   = _selectedOverhead;
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(OverheadEntryWithdraw, view.parentApplication as DisplayObject, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadAcceptCancel);
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
		 * 諸経費登録P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadEntry(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY || e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}

		/**
		 * 諸経費登録P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadApply(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY) {
				AccountingLogic.info_applyOverhead();
				requestOverheads();
			}
			else if (e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}

		/**
		 * 諸経費登録取り下げP.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadApplyWithdraw(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY) {
				AccountingLogic.info_applyWithdrawOverhead();
				requestOverheads();
			}
			else if (e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}

		/**
		 * 諸経費受領取り消しP.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_overheadAcceptCancel(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY || e.detail == PopUpWindow.RELOAD) {
				requestOverheads();
			}
		}


		/**
		 * getRequestOverheadsの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getRequestOverheads(e:ResultEvent):void
		{
			// 一覧データを設定する.
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
//						onChangeDataGrid_overheadList(new ListEvent("onResult_getRequestOverheads"));
						view.overheadList.scrollToIndex(index);
						break;
					}
				}
			}
			onChangeDataGrid_overheadList(new ListEvent("onResult_getRequestOverheads"));
//			_selectedOverhead = view.overheadList.selectedItem;
		}

		/**
		 * deleteOverheadの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_deleteOverhead(e:ResultEvent):void
		{
			requestOverheads();
		}

		/**
		 * copyOverheadの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_copyOverhead(e:ResultEvent):void
		{
			requestOverheads();
		}

		/**
		 * acceptOverheadの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_acceptOverhead(e:ResultEvent):void
		{
			requestOverheads();
		}


		/**
		 * getRequestOverheadsの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getRequestOverheads(e:FaultEvent):void
		{
			AccountingLogic.alert_getRequestOverheads(e);
		}

		/**
		 * deleteOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_deleteOverhead(e:FaultEvent):void
		{
			//trace ("deleteOverhead error!! " + e.toString());
			var conflict:Boolean = AccountingLogic.alert_deleteOverhead(e);
			if (conflict)
				requestOverheads();
		}

		/**
		 * copyOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_copyOverhead(e:FaultEvent):void
		{
			//trace ("copyOverhead error!! " + e.toString());
			var conflict:Boolean = AccountingLogic.alert_copyOverhead(e);
		}

		/**
		 * acceptOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_acceptOverhead(e:FaultEvent):void
		{
			//trace ("acceptOverhead error!! " + e.toString());
			var conflict:Boolean = AccountingLogic.alert_acceptOverhead(e);
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
	    public var _view:OverheadRequest;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():OverheadRequest
	    {
	        if (_view == null) {
	            _view = super.document as OverheadRequest;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:OverheadRequest):void
	    {
	        _view = view;
	    }

	}
}

