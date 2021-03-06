package subApplications.accounting.logic
{
	import components.PopUpWindow;
	
	import flash.events.Event;
	
	import logic.Logic;
	
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ValidationResultEvent;
	
	import subApplications.accounting.web.CommutationEntryWithdraw;



	/**
	 * CommutationEntryWithdrawのLogicクラスです.
	 */
	public class CommutationEntryWithdrawLogic extends Logic
	{

		/** 登録状態 */
		private var _entry:String;

		/** 登録状態解除 */
		private var _withdraw:String;

		/** 取り消し理由 */
		private var _reason:String;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function CommutationEntryWithdrawLogic()
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


			// windowをcompleteしたときに左上に表示されここでvalidateするとカーソル位置により
			// エラーメッセージが左上に表示されることがあるため、中央表示されたときにvalidateするようにする.
	    	// view.validator.validate();
	    	view.addEventListener(MoveEvent.MOVE, onWindowMove);
	    }



	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		protected function onCreationCompleteHandler_setSuceedData():void
		{
	    	_entry			= view.data.entry;
	    	_withdraw		= view.data.withdraw;
	    	_reason			= view.data.reason;
		}

	    /**
	     * 表示データの設定.
	     *
	     */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
			view.title = _entry + _withdraw;
			view.btnEntry.label = _withdraw;
			view.reasonName.label = _withdraw + "理由";
			view.reason.text = _reason;
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
			view.closeWindow(PopUpWindow.ENTRY);
		}


		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_close(e:Event):void
		{
			view.closeWindow();
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
	    public var _view:CommutationEntryWithdraw;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CommutationEntryWithdraw
	    {
	        if (_view == null) {
	            _view = super.document as CommutationEntryWithdraw;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CommutationEntryWithdraw):void
	    {
	        _view = view;
	    }
	}
}