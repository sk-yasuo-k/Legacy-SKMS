package subApplications.accounting.logic
{

	import components.PopUpWindow;

	import flash.events.Event;

	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ValidationResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.web.TransportEntryWithdraw;


	/**
	 * TransportEntryWithDrawのLogicクラスです.
	 */
	public class TransportEntryWithdrawLogic extends AccountingLogic
	{
		/** 登録状態 */
		private var _entry:String;

		/** 登録状態解除 */
		private var _withdraw:String;

		/** 動作モードリスト */
		private var _actionModeItem:Object;
		private const ACTION_MODE_ITEMS:Array = new Array ( {mode:ACTION_APPROVAL_CANCEL,   rpc:"approvalCancelTransportation"},
															{mode:ACTION_APPROVAL_WITHDRAW, rpc:"approvalWithdrawTransportation"},
															{mode:ACTION_PAYMENT_CANCEL,    rpc:"paymentCancelTransportation"},
															{mode:ACTION_APPLY_WITHDRAW,    rpc:"applyWithdrawTransportation"},
															{mode:ACTION_ACCEPT_CANCEL,     rpc:"acceptCancelTransportation"}
															);

		/** 最新表示 */
		private var _reload:Boolean = false;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function TransportEntryWithdrawLogic()
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

	    	// 初期設定を行なう.
	    	if (!_actionModeItem) {
	    		Alert.show(_entry + _withdraw + "できません。");
	    		view.closeWindow(PopUpWindow.ENTRY);
	    		return;
	    	}

			// windowをcompleteしたときに左上に表示されここでvalidateするとカーソル位置により
			// エラーメッセージが左上に表示されることがあるため、中央表示されたときにvalidateするようにする.
	    	// view.validator.validate();
	    	view.addEventListener(MoveEvent.MOVE, onWindowMove);
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
	    	_selectedTransportDto = view.data.transportDto;
	    	_actionMode = view.data.actionMode;
	    	_entry      = view.data.entry;
	    	_withdraw   = view.data.withdraw;
	    	_actionView = view.data.actionView;

	    	// 動作モードを確認する.
	    	var actionModeItems:Array = ACTION_MODE_ITEMS;
	    	for each (var actionMode:Object in actionModeItems) {
	    		if (ObjectUtil.compare(_actionMode, actionMode.mode) == 0) {
	    			_actionModeItem = actionMode;
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
			view.title = _entry + _withdraw;
			view.btnEntry.label = _withdraw;
			view.reasonName.label = _withdraw + "理由";
		}


//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 取り下げボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_entry_confirm(e:Event):void
		{
//			Alert.show(_entry + "を" + _withdraw + "てもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
			onButtonClick_entry(e);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) onButtonClick_entry(e);
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// 取り下げを行なう.
	    	view.srv.getOperation(_actionModeItem.rpc).send(Application.application.indexLogic.loginStaff, _selectedTransportDto, view.reason.text);
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e イベント.
		 */
//		public function onButtonClick_close_confirm(e:Event):void
//		{
//			if (view.btnEntry.enabled) 	Alert.show("編集中のデータは破棄されますがよろしいですか？", "", 3, view, onButtonClick_close_confirmResult);
//			else						onButtonClick_close(e);
//		}
//		protected function onButtonClick_close_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES) onButtonClick_close(e);
//		}
		public function onButtonClick_close(e:Event):void
		{
			if (_reload)			view.closeWindow(PopUpWindow.ENTRY);
			else					view.closeWindow();
		}


//		/**
//		 * approvalCancelTransportation(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_approvalCancelTransportation(e:ResultEvent):void
//		{
//			view.closeWindow(PopUpWindow.ENTRY);
//		}
//
//		/**
//		 * approvalWithdrawTransportation(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_approvalWithdrawTransportation(e:ResultEvent):void
//		{
//			view.closeWindow(PopUpWindow.ENTRY);
//		}
//
//		/**
//		 * paymentCancelTransportation(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_paymentCancelTransportation(e:ResultEvent):void
//		{
//			view.closeWindow(PopUpWindow.ENTRY);
//		}
//
//		/**
//		 * applyWithdrawTransportation(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_applyWithdrawTransportation(e:ResultEvent):void
//		{
//			view.closeWindow(PopUpWindow.ENTRY);
//		}
//
//		/**
//		 * acceptCancelTransportation(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_acceptCancelTransportation(e:ResultEvent):void
//		{
//			view.closeWindow(PopUpWindow.ENTRY);
//		}

		/**
	     * xxxxx(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_entryWithdraw(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
	     * xxxxx(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_entryWithdraw(e:FaultEvent):void
		{
			var conflict:Boolean = super.onFault_updateXxxxx(e, true, _entry + _withdraw);
			if (conflict)		_reload = true;
		}

		/**
		 * validator検証 OK.
		 *
		 * @param e ValidationResultEvent
		 */
		public function onValid_validator(e:ValidationResultEvent):void
		{
			view.btnEntry.enabled = true;
		}

		/**
		 * validator検証 NG.
		 *
		 * @param e ValidationResultEvent
		 */
		public function onInvalid_validator(e:ValidationResultEvent):void
		{
			view.btnEntry.enabled = false;
		}

		/**
		 * Window移動イベント.
		 *
		 * @param e MoveEvent
		 */
		public function onWindowMove(e:MoveEvent):void
		{
			//trace ("move");
			// validateを行なう.
	    	view.validator.validate();
	    	view.removeEventListener(MoveEvent.MOVE, onWindowMove);
		}

//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:TransportEntryWithdraw;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():TransportEntryWithdraw
	    {
	        if (_view == null) {
	            _view = super.document as TransportEntryWithdraw;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:TransportEntryWithdraw):void
	    {
	        _view = view;
	    }
	}
}