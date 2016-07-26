package subApplications.personnelAffair.logic
{
    import flash.events.*;
    import flash.net.*;
    
    import logic.Logic;
    
    import mx.controls.*;
    import mx.core.IDataRenderer;
    import mx.events.*;
    import mx.managers.*;
    import mx.states.*;
    
    import subApplications.personnelAffair.web.WorkStatus;
    import subApplications.personnelAffair.web.WorkStatusEntryDlg;
    
    import utils.CommonIcon;
    
	/**
	 * WorkStatusのLogicクラスです。

	 */
	public class WorkStatusLogic extends Logic
	{
	    
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function WorkStatusLogic()
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
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 	「検索」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_btnSearch(e:MouseEvent):void
	    {
	    }
	    
		/**
		 * 	就労履歴「追加」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkAddWorkStatus(e:MouseEvent):void
	    {
			// 就労状況登録画面を作成する.
			openWorkStatusEntryDlg(null);
	    }
	    
		/**
		 * 	就労履歴「変更」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkUpdateWorkStatus(e:MouseEvent):void
	    {
			// 就労状況登録画面を作成する.
			// TODO:選ばれた行の就労状況を引数にセット
			openWorkStatusEntryDlg(null);
	    }
	    
		/**
		 * 	就労履歴「削除」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkDeleteWorkStatus(e:MouseEvent):void
	    {
			Alert.show("削除してもよろしいですか？",
			 "",
			  Alert.YES | Alert.NO,
			   view,
			    onClose_deleteWorkStatusAlert,
			    CommonIcon.questionIcon);
	    }
	    
	    
		/**
		 * リンクボタン選択 検索条件の表示.
		 *
		 */
		public function onClick_linkShowSearchCondition(e:MouseEvent):void
		{
			view.vbxShowSearchCondition.width = 0;
			view.vbxShowSearchCondition.height = 0;
			view.vbxHideSearchCondition.percentWidth = 100;
			view.vbxHideSearchCondition.percentHeight = 100;
		}

		/**
		 * リンクボタン選択 閉じる.
		 *
		 */
		public function onClick_linkHideSearchCondition(e:MouseEvent):void
		{
			view.vbxShowSearchCondition.percentWidth = 100;
			view.vbxShowSearchCondition.percentHeight = 100;
			view.vbxHideSearchCondition.width = 0;
			view.vbxHideSearchCondition.height = 0;
		}

		/**
		 * WorkStatusEntry(就労状況登録)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onClose_workStatusEntryDlg(e:CloseEvent):void
		{
			// 「OK」ボタンで終了した場合.
			if(e.detail == Alert.OK){
				// TODO:ここに就労状況登録処理を記述
				Alert.show("OK");
			}
		}

	    /**
	     * 就労履歴削除 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		private function onClose_deleteWorkStatusAlert(e:CloseEvent):void
		{
			// 「OK」ならば.
			if (e.detail == Alert.YES) {
				// TODO:資格削除処理
			}
		}

	    
//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * WorkStatusEntry(就労状況登録)のオープン.
		 *
		 * @param workStatusId 就労状況.
		 */
		private function openWorkStatusEntryDlg(workStatus:Object):void
		{
			// 就労状況登録画面を作成する.
			var pop:WorkStatusEntryDlg = new WorkStatusEntryDlg();
			PopUpManager.addPopUp(pop, view, true);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// 就労状況をセット
			obj.workStatus = workStatus;
			// 社員名をセット
			obj.staffName = "大野 純一";
			
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_workStatusEntryDlg);
			
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);
		}
		

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:WorkStatus;

	    /**
	     * 画面を取得します

	     */
	    public function get view():WorkStatus
	    {
	        if (_view == null) {
	            _view = super.document as WorkStatus;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:WorkStatus):void
	    {
	        _view = view;
	    }

	}    
}