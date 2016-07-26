package subApplications.accounting.logic
{
	import components.PopUpWindow;

	import flash.events.Event;

	import logic.Logic;

	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ValidationResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.OverheadDto;
	import subApplications.accounting.web.OverheadEntryWithdraw;



	/**
	 * OverheadEntryWithdrawのLogicクラスです.
	 */
	public class OverheadEntryWithdrawLogic extends Logic
	{
		/** 動作モードリスト */
		private const ACTION_MODE_ITEMS:Array = new Array ( {mode:AccountingLogic.ACTION_APPROVAL_CANCEL,   rpc:"approvalCancelOverhead"},
															{mode:AccountingLogic.ACTION_APPROVAL_WITHDRAW, rpc:"approvalWithdrawOverhead"},
															{mode:AccountingLogic.ACTION_PAYMENT_CANCEL,    rpc:"paymentCancelOverhead"},
															{mode:AccountingLogic.ACTION_APPLY_WITHDRAW,    rpc:"applyWithdrawOverhead"},
															{mode:AccountingLogic.ACTION_ACCEPT_CANCEL,     rpc:"acceptCancelOverhead"}
															);

		/** 動作モード */
		private var _actionModeItem:Object;

		/** 最新表示 */
		private var _reload:Boolean = false;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function OverheadEntryWithdrawLogic()
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
	    	var entry:String	= view.data.entry;
	    	var withdraw:String	= view.data.withdraw;
	    	var reason:String	= view.data.reason;
			var action:String   = view.data.actionMode;

			// 表示データを設定する.
			view.title            = entry + withdraw;
			view.btnEntry.label   = withdraw;
			view.reasonName.label = withdraw + "理由";
			view.reason.text      = reason;

	    	// 動作モードを確認する.
	    	for each (var item:Object in ACTION_MODE_ITEMS) {
	    		if (ObjectUtil.compare(action, item.mode) == 0) {
	    			_actionModeItem = item;
	    			break;
	    		}
	    	}

			// windowをcompleteしたときに左上に表示されここでvalidateするとカーソル位置により
			// エラーメッセージが左上に表示されることがあるため、中央表示されたときにvalidateするようにする.
	    	// view.validator.validate();
	    	view.addEventListener(MoveEvent.MOVE, onWindowMove);
	    }


//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 取り下げボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_entry(e:Event):void
		{
			// 取り下げを行なう.
	    	view.srv.getOperation(_actionModeItem.rpc).send(Application.application.indexLogic.loginStaff, view.data.overhead as OverheadDto, view.reason.text);
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_close(e:Event):void
		{
			if (_reload)	view.closeWindow(PopUpWindow.RELOAD);
			else			view.closeWindow();

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
			var conflict:Boolean = AccountingLogic.alert_withdrawOverhead(e, view.title);
			if (conflict)	_reload = true;
		}


//--------------------------------------
//  Function
//--------------------------------------




//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:OverheadEntryWithdraw;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():OverheadEntryWithdraw
	    {
	        if (_view == null) {
	            _view = super.document as OverheadEntryWithdraw;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:OverheadEntryWithdraw):void
	    {
	        _view = view;
	    }
	}
}