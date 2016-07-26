package subApplications.personnelAffair.logic
{
    import enum.WorkStatusId;
    
    import flash.events.*;
    import flash.net.*;
    
    import logic.Logic;
    
    import mx.controls.*;
    import mx.events.*;
    import mx.managers.*;
    import mx.states.*;
    
    import subApplications.personnelAffair.web.WorkStatusEntryDlg;
    
	/**
	 * WorkStatusEntryDlgのLogicクラスです。

	 */
	public class WorkStatusEntryDlgLogic extends Logic
	{
	    
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function WorkStatusEntryDlgLogic()
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
   			view.lblStaffName.text = view.data.staffName;
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * OKボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onClick_btnOk(e:Event):void
		{
			// PopUpのCloseイベントを作成する.
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);
		}


		/**
		 * キャンセルボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onClick_btnCancel(e:Event):void
		{
		 	// PopUpのCloseイベントを作成する.
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
			view.dispatchEvent(ce);
		}


		/**
		 * Closeボタンの押下.
		 *
		 * @param e Closeイベント.
		 */
		public function onClose_workingStatusEntryDlg(e:CloseEvent):void
		{
			// PopUpをCloseする.
			PopUpManager.removePopUp(view);
		}

	    
//--------------------------------------
//  Function
//--------------------------------------


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:WorkStatusEntryDlg;

	    /**
	     * 画面を取得します

	     */
	    public function get view():WorkStatusEntryDlg
	    {
	        if (_view == null) {
	            _view = super.document as WorkStatusEntryDlg;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:WorkStatusEntryDlg):void
	    {
	        _view = view;
	    }

	}    
}