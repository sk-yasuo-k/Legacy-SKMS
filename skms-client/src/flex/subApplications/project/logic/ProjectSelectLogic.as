package subApplications.project.logic
{
	import components.PopUpWindow;

	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import subApplications.accounting.dto.ProjectDto;
	import subApplications.accounting.dto.TransportationDto;
	import subApplications.project.web.ProjectSelect;

	/**
	 * ProjectSelectのLogicクラスです。
	 */
	public class ProjectSelectLogic extends Logic
	{
		private var _entryProject:Object;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectSelectLogic()
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
			// 所属プロジェクトリストを取得する.
			view.srv2.getOperation("getBelongProjectList").send(Application.application.indexLogic.loginStaff);
			// 全社的業務リストを取得する.
			view.srv.getOperation("getWholeBusinessList").send();
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * プロジェクトリストの項目選択.
		 *
		 * @param e イベント.
		 */
		public function onItemClick_belongProjectList(e:ListEvent):void
		{
			view.wholeBusinessList.selectedIndex = -1;
			view.btnOk.enabled = true;
		}

		/**
		 * 全社的業務リストの項目選択.
		 *
		 * @param e イベント.
		 */
		public function onItemClick_wholeBusinessList(e:ListEvent):void
		{
			view.belongProjectList.selectedIndex = -1;
			view.btnOk.enabled = true;
		}

		/**
		 * ヘルプメニュー選択.
		 *
		 * @param e ContextMenuEvent.
		 */
		 override protected function onMenuSelect_help(e:ContextMenuEvent):void
		 {
			// ヘルプ画面を表示する.
		 	opneHelpWindow("ProjectSelect");
		 }

		/**
		 * ヘルプボタンのクリックイベント
		 *
		 * @param event MouseEvent
		 */
		public function onClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			opneHelpWindow("ProjectSelect");
		}

		/**
		 * OKボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_ok(e:MouseEvent):void
		{
//			if (view.data && view.data.transportDto) {
//				var trans:TransportationDto = view.data.transportDto;
//				if (trans.project == null) trans.project = new ProjectDto();
//				if (view.wholeBusinessList.selectedIndex >= 0) {
//					trans.projectId = view.wholeBusinessList.selectedItem.projectId;
//					trans.project.projectCode = view.wholeBusinessList.selectedItem.projectCode;
//					trans.project.projectName = view.wholeBusinessList.selectedItem.projectName;
//				} else if (view.belongProjectList.selectedIndex >= 0) {
//					trans.projectId = view.belongProjectList.selectedItem.projectId;
//					trans.project.projectCode = view.belongProjectList.selectedItem.projectCode;
//					trans.project.projectName = view.belongProjectList.selectedItem.projectName;
//				}
//			}
			if (view.wholeBusinessList.selectedIndex >= 0) {
				_entryProject = new Object();
				_entryProject.projectId   = view.wholeBusinessList.selectedItem.projectId;
				_entryProject.projectCode = view.wholeBusinessList.selectedItem.projectCode;
				_entryProject.projectName = view.wholeBusinessList.selectedItem.projectName;
				//追加 @auther watanuki
				_entryProject.actualStartDate = view.wholeBusinessList.selectedItem.actualStartDate;
				_entryProject.actualFinishDate = view.wholeBusinessList.selectedItem.actualFinishDate;
				
			} else if (view.belongProjectList.selectedIndex >= 0) {
				_entryProject = new Object();
				_entryProject.projectId   = view.belongProjectList.selectedItem.projectId;
				_entryProject.projectCode = view.belongProjectList.selectedItem.projectCode;
				_entryProject.projectName = view.belongProjectList.selectedItem.projectName;
				//追加 @auther watanuki
				_entryProject.actualStartDate = view.belongProjectList.selectedItem.actualStartDate;
				_entryProject.actualFinishDate = view.belongProjectList.selectedItem.actualFinishDate;
				
			}
			if (view.data && view.data.transportDto) {
				var trans:TransportationDto = view.data.transportDto;
				if (trans.project == null) trans.project = new ProjectDto();
				
				/*
				 * var 
				 */
				trans.projectId           = _entryProject.projectId;
				trans.project.projectCode = _entryProject.projectCode;
				trans.project.projectName = _entryProject.projectName;
				//追加 @auther watanuki
				trans.project.actualStartDate = _entryProject.actualStartDate;
				trans.project.actualFinishDate = _entryProject.actualFinishDate;
			}
//			onCloseButtonClick(null);				// クローズ.
//		 	// PopUpのCloseイベントを作成する.
//			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, 1);
//			view.dispatchEvent(ce);
			// PopUpをCloseする.
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * キャンセルボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_cancel(e:MouseEvent):void
		{
//			onCloseButtonClick(null);				// クローズ.
//		 	var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
//		 	view.dispatchEvent(ce);
			view.closeWindow();
		}

//		/**
//		 * Closeボタンの押下.
//		 *
//		 * @param e Closeイベント.
//		 */
//		public function onCloseButtonClick(e:CloseEvent):void
//		{
//			// PopUpをCloseする.
//			PopUpManager.removePopUp(view);
//		}

		/**
		 * 選択プロジェクトの取得.
		 *
		 * @return プロジェクト情報.
		 */
		public function get entryProject():Object
		{
			return _entryProject;
		}

	    /**
	     * リモート呼び出しの失敗イベント（共通）
	     *
	     * @param e FaultEvent
	     */
	    public function onFault(e:FaultEvent):void
	    {
	        trace(e);
	    }

		/**
		 * getWholeBusinessList(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント
		 */
		public function onResult_getWholeBusinessList(e:ResultEvent):void
		{
			// 全社的業務リストを取得する.
	    	view.wholeBusinessList.dataProvider = e.result;
		}

		/**
	     * getWholeBusinessList(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_getWholeBusinessList(e:FaultEvent):void
		{
		}

		/**
		 * getBelongProjectList(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント
		 */
		public function onResult_getBelongProjectList(e:ResultEvent):void
		{
			// 所属プロジェクトリストを取得する.
	    	view.belongProjectList.dataProvider = e.result;
		}

		/**
	     * getBelongProjectList(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_getBelongProjectList(e:FaultEvent):void
		{
		}

//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectSelect;

	    /**
	     * 画面を取得します
	     */
	    public function get view():ProjectSelect
	    {
	        if (_view == null) {
	            _view = super.document as ProjectSelect;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:ProjectSelect):void
	    {
	        _view = view;
	    }
	}
}