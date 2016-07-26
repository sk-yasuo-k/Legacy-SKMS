package subApplications.project.logic
{
	import components.PopUpWindow;

	import flash.events.Event;

	import logic.Logic;

	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import subApplications.project.web.ProjectSituationEntry;

	/**
	 * ProjectSituationEntryのLogicクラスです.
	 */
	public class ProjectSituationEntryLogic extends Logic
	{
		/** 親画面再表示 */
		private var _reload:Boolean = false;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectSituationEntryLogic()
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
			// 中央に表示する.
			PopUpManager.centerPopUp(view);

			// validate を行なう.
			view.validate();
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 「登録」ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:Event):void
		{
			Alert.show("登録してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)
				onButtonClick_entry(e);
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// プロジェクト状況を登録する.
			view.srv.getOperation("createProjectSituation").send(Application.application.indexLogic.loginStaff, view.entrySituation);
		}

//		/**
//		 * ヘルプボタンのクリックイベント//		 *
//		 * @param event MouseEvent
//		 */
//		public function onButtonClick_help(e:MouseEvent):void
//		{
//			// ヘルプ画面を表示する.
//			if (view.tabnavi.selectedChild is ProjectBillForm) {
//				opneHelpWindow("ProjectBillEntry");
//			}
//			else {
//				opneHelpWindow("ProjectBaseEntry");
//			}
//		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_close(e:Event):void
		{
			// window を close する.
			if (_reload)		view.closeWindow(PopUpWindow.ENTRY);
			else				view.closeWindow();
		}

		/**
		 * createProjectSituation処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_createProjectSituation(e:ResultEvent):void
		{
			// window を close する.
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * createProjectSituationの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_createProjectSituation(e:FaultEvent):void
		{
			var conflict:Boolean = ProjectLogic.alert_createProjectSituation(e);
			if (conflict)
				_reload = true;
		}


//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectSituationEntry;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():ProjectSituationEntry
	    {
	        if (_view == null) {
	            _view = super.document as ProjectSituationEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:ProjectSituationEntry):void
	    {
	        _view = view;
	    }
	}
}