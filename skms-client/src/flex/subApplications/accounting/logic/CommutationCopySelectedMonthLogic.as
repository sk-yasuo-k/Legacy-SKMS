package subApplications.accounting.logic
{
	import components.PopUpWindow;
	
	import flash.events.Event;
	
	import logic.Logic;
	
	import mx.events.FlexEvent;
	
	import subApplications.accounting.web.CommutationCopySelectedMonth;

	/**
	 * CommutationCopySelectedMonthのLogicクラスです.
	 */
	public class CommutationCopySelectedMonthLogic extends Logic
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
		public function CommutationCopySelectedMonthLogic()
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
	    	var now:Date = new Date();
	    	view.stpYear.value = now.getFullYear();
	    	view.stpMonth.value = now.getMonth();
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 複製ボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_entry(e:Event):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}


		/**
		 * 戻るボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_close(e:Event):void
		{
			view.closeWindow();
		}



//--------------------------------------
//  Function
//--------------------------------------




//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CommutationCopySelectedMonth;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CommutationCopySelectedMonth
	    {
	        if (_view == null) {
	            _view = super.document as CommutationCopySelectedMonth;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CommutationCopySelectedMonth):void
	    {
	        _view = view;
	    }
	}
}