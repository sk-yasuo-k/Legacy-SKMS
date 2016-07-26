package subApplications.project.logic
{
	import components.PopUpWindow;

	import dto.StaffDto;

	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.core.Application;
	import mx.core.IDataRenderer;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.project.dto.ProjectDto;
	import subApplications.project.dto.ProjectMemberDto;
	import subApplications.project.web.ProjectEntry;
	import subApplications.project.web.ProjectList;
	import subApplications.project.web.ProjectSituationEntry;

	/**
	 * ProjectListのLogicクラスです.
	 */
	public class ProjectListLogic extends Logic
	{
		/** プロジェクトリスト */
		private var _projectList:ArrayCollection;

		/** 選択したプロジェクト */
		private var _selectedProject:ProjectDto;

		/** 選択したリンクボタン */
		protected var _selectedLinkObject:Object;

		/** プロジェクト登録権限 */
		private var _projectEntryAuthorisation:Boolean = false;

		/** PM社員マスタリスト */
		private var _pmStaffList:ArrayCollection;

		/** 所属プロジェクトリスト */
		private var _belongProjectList:ArrayCollection;

		/** マスタデータ取得失敗 */
		private var _masterError:Boolean = false;


		/** プロジェクト一覧 リンクボタンアイテム（プロジェクト登録権限あり） */
		private var _rpLinkListAuthrisation:ArrayCollection
			= new ArrayCollection([
				{label:"新規",	func:"onClick_linkList_project_new",														enabled:true,	enabledCheck:false  },
				{label:"変更",	func:"onClick_linkList_project_update",														enabled:false,	enabledCheck:true,	reqSelect:true},
				{label:"複製",	func:"onClick_linkList_project_copy",														enabled:false,	enabledCheck:true,	reqSelect:true},
				{label:"削除",	func:"onClick_linkList_project_delete",	prepare:"onClick_linkList_project_delete_confirm",	enabled:false,	enabledCheck:true,	reqSelect:true}
			]);
		/** プロジェクト一覧 リンクボタンアイテム（プロジェクト登録権限なし） */
		private var _rpLinkList:ArrayCollection
			= new ArrayCollection([
				{label:"参照", func:"onClick_linkList_project_ref",	enabled:false,	enabledCheck:true,	reqSelect:true}
			]);

		/** プロジェクト状況 リンクボタンアイテム（プロジェクト状況登録権限あり） */
		private var LINK_PROJECT_SITUATION:Object = {label:"状況報告", func:"onClick_linkList_project_situation", enabled:false, enabledCheck:true, reqSelect:true, situationCheck:true};


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectListLogic()
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
			// 初期設定をする.
			authorizeProjectEditor();							// プロジェクト編集権限確認.
			requestPMStaffListt();								// PM社員リスト取得.

			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();

			// コンテキストメニューを設定する.
			onCreationCompleteHandler_setContextMenu();
	    }

		/**
		 * 表示データの設定.
		 *
		 */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
			// プロジェクトを取得する.
			view.projectSearch.getProjectList();
		}

		/**
		 * コンテキストメニューの設定.
		 *
		 */
		protected function onCreationCompleteHandler_setContextMenu():void
		{
			// プロジェクト一覧 コンテキストメニューを作成する.
			view.projectList.contextMenu = createContextMenu_projectList();
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * プロジェクト一覧選択（クリック）.
		 *
		 * @param e ListEvent or Event or KeyboardEvent
		 */
		public function onChange_projectList(e:Event):void
		{
			// 選択したプロジェクトのメンバ＆有効リンクを表示する.
			_selectedProject = view.projectList.selectedItem as ProjectDto;
			if (_selectedProject) {
				setProjectMemberList(_selectedProject.projectMembers);
				setProjectSituationList(_selectedProject.projectSituations);
			}
			else {
				setProjectMemberList(new ArrayCollection());
				setProjectSituationList(null);
			}
			setRpLinkList_projectList();
			setContextMenu_projectList();
		}

		/**
		 * プロジェクト一覧選択（ダブルクリック）.
		 *
		 * @param e MouseEvent
		 */
		public function onDoubleClick_projectList(e:MouseEvent):void
		{
			// 選択行でダブルクリックしたとき.
			if (e.target is DataGridItemRenderer) {
				// プロジェクト情報編集を表示する.
				open_projectEntry(_selectedProject);
			}
		}


		/**
		 * リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList(e:MouseEvent):void
		{
//			if (_projectEntryAuthorisation) {
//				_selectedLinkObject = _rpLinkListAuthrisation.getItemAt(e.target.instanceIndex);
//			}
//			else {
//				_selectedLinkObject = _rpLinkList.getItemAt(e.target.instanceIndex);
//			}
			_selectedLinkObject = view.rpLinkList.dataProvider.getItemAt(e.target.instanceIndex);
			// 選択したリンクボタンの処理を呼び出す.
			if (_selectedLinkObject.hasOwnProperty("prepare")) {
				this[_selectedLinkObject.prepare](e);
			}
			else {
				this[_selectedLinkObject.func]();
			}
		}

	    /**
	     * リンクボタン選択 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		public function onClick_linkList_confirmResult(e:CloseEvent):void
		{
			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.YES) {
				this[_selectedLinkObject.func]();
			}
		}

		/**
		 * リンクボタン選択 新規作成.
		 *
		 */
		public function onClick_linkList_project_new():void
		{
			// プロジェクト登録P.U.を表示する.
			open_projectEntry();
		}

		/**
		 * リンクボタン選択 変更.
		 *
		 */
		public function onClick_linkList_project_update():void
		{
			// プロジェクト登録P.U.を表示する.
			open_projectEntry(_selectedProject);
		}

		/**
		 * リンクボタン選択 複製.
		 *
		 */
		public function onClick_linkList_project_copy():void
		{
			// プロジェクト登録P.U.を表示する.
			var project:ProjectDto = ProjectDto.copy(_selectedProject);
			open_projectEntry(project);
		}


		/**
		 * リンクボタン選択 削除.
		 *
		 * @param e Event
		 */
		public function onClick_linkList_project_delete_confirm(e:Event):void
		{
			Alert.show("削除してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		/**
		 * リンクボタン選択 削除.
		 *
		 */
		protected function onClick_linkList_project_delete():void
		{
			// 削除.
			view.srv.getOperation("deleteProject").send(Application.application.indexLogic.loginStaff, _selectedProject);
		}

		/**
		 * リンクボタン選択 参照.
		 *
		 */
		public function onClick_linkList_project_ref():void
		{
			// プロジェクト参照P.U.を表示する.
			open_projectEntry(_selectedProject);
		}

		/**
		 * リンクボタン選択 状況報告.
		 *
		 */
		public function onClick_linkList_project_situation():void
		{
			// プロジェクト状況P.U.を表示する.
			open_projectSituationEntry(_selectedProject);
		}


		/**
		 * ContextMenu「変更」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_update(e:ContextMenuEvent):void
		{
			// プロジェクト情報編集を表示する.
			_selectedLinkObject = _rpLinkListAuthrisation.getItemAt(1);
			this[_selectedLinkObject.func]();
		}

		/**
		 * ContextMenu「複製」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_copy(e:ContextMenuEvent):void
		{
			// プロジェクト情報編集を表示する.
			_selectedLinkObject = _rpLinkListAuthrisation.getItemAt(2);
			this[_selectedLinkObject.func]();
		}

		/**
		 * ContextMenu「削除」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_delete(e:ContextMenuEvent):void
		{
			// 削除する.
			_selectedLinkObject = _rpLinkListAuthrisation.getItemAt(3);
			this[_selectedLinkObject.prepare](new ItemClickEvent(e.type));
		}

		/**
		 * ContextMenu「参照」の選択.
		 *
	     * @param e ContextMenuEvent.
		 */
		private function onMenuSelect_ref(e:ContextMenuEvent):void
		{
			// プロジェクト情報編集を表示する.
			_selectedLinkObject = _rpLinkList.getItemAt(0);
			this[_selectedLinkObject.func]();
		}

		/**
		 * プロジェクト登録P.U.クローズイベント処理.
		 *
		 * @param project 登録するプロジェクト.
		 */
		private function open_projectEntry(project:ProjectDto = null):void
		{
			// window を作成する.
			var pop:ProjectEntry = new ProjectEntry();
			pop.authorize = _projectEntryAuthorisation;

			// 引き継ぐデータを作成する.
			var obj:Object   = new Object();
			obj.project      = ObjectUtil.copy(project);

			// window を表示する.
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, obj);

			// window close イベントを登録する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_projectEntry);
		}

		/**
		 * プロジェクト状況P.U.クローズイベント処理.
		 *
		 * @param project 登録するプロジェクト.
		 */
		private function open_projectSituationEntry(project:ProjectDto):void
		{
			// window を作成する.
			var pop:ProjectSituationEntry = new ProjectSituationEntry();
			pop.project = project;

			// window を表示する.
			PopUpWindow.displayWindow2(pop, view.parentApplication as DisplayObject);

			// window close イベントを登録する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_projectSituationEntry);
		}


		/**
		 * プロジェクト登録P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_projectEntry(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY) {
				// 登録したら、最新データを取得する.
				setProjectMemberList(new ArrayCollection());
				setProjectSituationList(null);
				view.projectSearch.getProjectList();
			}
		}

		/**
		 * プロジェクト状況P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent
		 */
		private function onClose_projectSituationEntry(e:CloseEvent):void
		{
			if (e.detail == PopUpWindow.ENTRY) {
				// 登録したら、最新データを取得する.
				setProjectMemberList(new ArrayCollection());
				setProjectSituationList(null);
				view.projectSearch.getProjectList();
			}
		}


		/**
		 * getProjectList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_projectSearch(e:ResultEvent):void
		{
			// エラーがあるときは、終了する.
			if (_masterError) {
				clearDisplayData();
				return;
			}

			// 結果を取得する.
			_projectList = e.result as ArrayCollection;

			// プロジェクト一覧を設定する.
			setProjectList(_projectList);

			// プロジェクトメンバ一覧を設定する.
			setProjectMemberList(new ArrayCollection());

			// プロジェクト状況を設定する
			setProjectSituationList(null);

			// 選択行を表示する.
	        if (_selectedProject && _projectList) {
				for (var index:int = 0; index < _projectList.length; index++) {
				var project:ProjectDto = _projectList.getItemAt(index) as ProjectDto;
					if (ProjectDto.compare(_selectedProject, project)) {
						view.projectList.selectedIndex = index;
						onChange_projectList(new Event("onResult_projectSearch"));
						view.projectList.scrollToIndex(index);
						break;
					}
				}
			}
			_selectedProject = view.projectList.selectedItem as ProjectDto;
		}

		/**
		 * getProjectPositionPMList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getProjectPositionPMList(e:ResultEvent):void
		{
			// 結果を取得する.
			_pmStaffList = e.result as ArrayCollection;

			// 検索条件を設定する.
			setProjectSearch_projectManager(_pmStaffList);
		}


		/**
		 * deleteProject処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_deleteProject(e:ResultEvent):void
		{
			// 最新データを取得する.
			view.projectSearch.getProjectList();
		}

		/**
		 * getProjectListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_projectSearch(e:FaultEvent):void
		{
			clearDisplayData();									// 表示データクリア.
			ProjectLogic.alert_projectSearch(e);
		}

		/**
		 * deleteProjectの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_deleteProject(e:FaultEvent):void
		{
			var conflict:Boolean = ProjectLogic.alert_deleteProject(e);
			if (conflict)
				view.projectSearch.getProjectList();
		}

		/**
		 * getProjectPositionPMListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getProjectPositionPMList(e:FaultEvent):void
		{
			_masterError = true;
			clearDisplayData();									// 表示データクリア.
			ProjectLogic.alert_getProjectPositionPMList(e);
		}

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * プロジェクト一覧 リンクボタン設定.
		 *
		 * @param enable リンクボタン有効.
		 */
		private function setRpLinkList_projectList(enable:Boolean = true):void
		{
			view.rpLinkList.dataProvider = getRpLinkList_projectList(enable);
		}

		/**
		 * プロジェクト一覧 リンクボタン取得.
		 *
		 * @param enable リンクボタン有効.
		 * @return リンクボタンリスト.
		 */
		private function getRpLinkList_projectList(enable:Boolean):ArrayCollection
		{
			// リンクボタンが未設定の時は 定義を設定する.
			var rplist:ArrayCollection = view.rpLinkList.dataProvider as ArrayCollection;
			if (!(rplist && rplist[0] as Object)) {
				// プロジェクト登録リンクを設定する.
				if (_projectEntryAuthorisation)
					rplist = _rpLinkListAuthrisation;
				else
					rplist = _rpLinkList;

				// プロジェクト状況登録リンクを設定する.
				if (Application.application.indexLogic.loginStaff.isAuthorisationProjectSituationEntry()) {
					rplist.addItem(LINK_PROJECT_SITUATION);
				}
			}

			// リンクボタンの有効/無効を設定する.
			var project:Object = view.projectList.selectedItem;
			for (var index:int = 0; index < rplist.length; index++) {
				var linkObject:Object = rplist.getItemAt(index);
				// 有効無効設定のとき.
				if (enable) {
					if (linkObject.enabledCheck) {
						if (project)
							if (linkObject.situationCheck) {
								// プロジェクトメンバ＆状況登録権限があるかどうか確認する.
								linkObject.enabled = false;
								for each (var member:ProjectMemberDto in project.projectMembers) {
									var staff:Object = Application.application.indexLogic.loginStaff;
									if (!ProjectMemberDto.compare(member, staff))	continue;
									if (member.isAuthorisationProjectSituationEntry()) {
										linkObject.enabled = true;
										break;
									}
								}
							}
							else {
								linkObject.enabled = true;
							}
						else
							linkObject.enabled = false;
					}
					else {
						linkObject.enabled = true;
					}
				}
				// 無効設定のとき.
				else {
					linkObject.enabled = false;
				}
				rplist.setItemAt(linkObject, index);
			}
			return rplist;
		}

		/**
		 * プロジェクト一覧設定.
		 *
		 * @param list プロジェクトリスト.
		 */
		private function setProjectList(list:ArrayCollection):void
		{
			view.projectList.dataProvider = list;
			setRpLinkList_projectList();
			setContextMenu_projectList();
		}

		/**
		 * プロジェクトメンバ一覧設定.
		 *
		 * @param list プロジェクトメンバリスト.
		 */
		private function setProjectMemberList(list:ArrayCollection):void
		{
			view.projectMemberList.dataProvider = list;
		}

		/**
		 * プロジェクト状況リスト設定.
		 *
		 * @param list  プロジェクト状況リスト.
		 */
		private function setProjectSituationList(list:ArrayCollection):void
		{
			view.projectSituationList.referenceSituations = list;
		}

		/**
		 * プロジェクト情報検索 PMリスト.
		 *
		 * @param list 社員情報リスト.
		 */
		private function setProjectSearch_projectManager(list:ArrayCollection):void
		{
			view.projectSearch.entryProjectManagerList = ObjectUtil.copy(list) as ArrayCollection;
		}

		/**
		 * プロジェクト編集権限設定.
		 *
		 */
		private function authorizeProjectEditor():void
		{
			// プロジェクト権限を取得・設定する.
			var staff:StaffDto = Application.application.indexLogic.loginStaff;
			_projectEntryAuthorisation = staff.isAuthorisationProjectEntry();
		}


		/**
		 * 社員プロジェクト役職PMリストの取得.
		 *
		 */
		private function requestPMStaffListt():void
		{
			view.srv.getOperation("getProjectPositionPMList").send();
		}


		/**
		 * プロジェクト一覧表示のクリア.
		 *
		 */
		 private function clearDisplayData():void
		 {
			// プロジェクト一覧をクリアする.
			view.projectList.dataProvider = null;
			setRpLinkList_projectList(false);
			setContextMenu_projectList();

			// プロジェクトメンバ一覧をクリアする.
	        view.projectMemberList.dataProvider = null;

	        // プロジェクト検索不可とする.
			view.projectSearch.swSearch.enabled  = false;
			view.projectSearch.searchOpt.enabled = false;
		 }


		/**
		 * プロジェクト一覧 コンテキストメニューの作成.
		 *
		 */
		private function createContextMenu_projectList():ContextMenu
		{
			// コンテキストメニューを作成する.
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			if (_projectEntryAuthorisation) {
				// コンテキストメニュー：変更
				var cmItem_update:ContextMenuItem = new ContextMenuItem(_rpLinkListAuthrisation.getItemAt(1).label);
				cmItem_update.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_update);
				contextMenu.customItems.push(cmItem_update);

				// コンテキストメニュー：複製
				var cmItem_copy:ContextMenuItem = new ContextMenuItem(_rpLinkListAuthrisation.getItemAt(2).label);
				cmItem_copy.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_copy);
				contextMenu.customItems.push(cmItem_copy);

				// コンテキストメニュー：削除
				var cmItem_delete:ContextMenuItem = new ContextMenuItem(_rpLinkListAuthrisation.getItemAt(3).label);
				cmItem_delete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_delete);
				contextMenu.customItems.push(cmItem_delete);
			}
			else {
				// コンテキストメニュー：参照
				var cmItem_ref:ContextMenuItem = new ContextMenuItem(_rpLinkList.getItemAt(0).label);
				cmItem_ref.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_ref);
				contextMenu.customItems.push(cmItem_ref);
			}
			// コンテキストメニューを返す.
			return contextMenu;
		}


		/**
		 * 交通費一覧 コンテキストメニューの有効／無効設定.
		 *
		 */
		private function setContextMenu_projectList():void
		{
			// 有効メニューを作成する.
			var enabledItems:Array = new Array();
			// 選択された交通費情報に応じて有効/無効を設定する.
			var project:Object = view.projectList.selectedItem;
			var menu:ContextMenu = view.projectList.contextMenu as ContextMenu;
			if (menu && menu.customItems) {
				for (var i:int = 0; i < menu.customItems.length; i++) {
					if (project)
						menu.customItems[i].enabled = true;
					else
						menu.customItems[i].enabled = false;
				}
			}
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectList;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():ProjectList
	    {
	        if (_view == null) {
	            _view = super.document as ProjectList;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:ProjectList):void
	    {
	        _view = view;
	    }
	}
}