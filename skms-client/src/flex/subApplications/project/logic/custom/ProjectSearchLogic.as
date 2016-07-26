package subApplications.project.logic.custom
{
	import flash.events.Event;
	import flash.events.FocusEvent;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.project.dto.ProjectMemberDto;
	import subApplications.project.dto.ProjectSearchDto;
	import subApplications.project.web.custom.ProjectSearch;

	/**
	 * ProjectSearchのLogicクラスです.
	 */
	public class ProjectSearchLogic extends Logic
	{
		/** プロジェクトリスト */
		private var _projectList:ArrayCollection;

		/** プロジェクトマネージャリスト */
		private var _projectPMList:ArrayCollection;

		/** 検索要求フラグ */
		private var _bSearchRequest:Boolean;

		/** XX期開始日（10月1日）*/
		private static const TERM_BEGINNING_MONTH:int = 10;
		private static const TERM_BEGINNING_DATE:int  = 1;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectSearchLogic()
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
			changeSwSearch();									// 検索表示ボタン.

			var now:Date = new Date();
			view.actualStartDateTo.selectedDate  = now;			// 実績開始日.
			view.actualFinishDateTo.selectedDate = now;			// 実績終了日.
			if (now.getMonth() + 1 > TERM_BEGINNING_MONTH) {
				view.actualFinishDateFrom.selectedDate = new Date(now.fullYear,     TERM_BEGINNING_MONTH - 1, TERM_BEGINNING_DATE);
			}
			else {
				view.actualFinishDateFrom.selectedDate = new Date(now.fullYear - 1, TERM_BEGINNING_MONTH - 1, TERM_BEGINNING_DATE);
			}
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 検索ボタン押下.
		 *
		 * @param event MouseEvent or Event
		 */
		public function onClick_btnSearch(event:Event):void
		{
			// 検索ボタンを無効にする.
			setRequestProjectList(false);

			// 検索実行の可否を確認する.
			if (!onClick_btnSearch_check(event))	return;

			// 検索条件を作成する.
			var search:ProjectSearchDto = new ProjectSearchDto();
			search.projectCode          = view.projectCode.text.length > 0 ? view.projectCode.text : null;
			search.projectName          = view.projectName.text.length > 0 ? view.projectName.text : null;
			search.pmStaffId            = view.cmbProjectManager.selectedItem.data;		// PM.
			search.projectMemberName	= view.txtProjectMemberName.text.length > 0 ? view.txtProjectMemberName.text : null;
			search.actualStartDateNone  = view.actualStartDateNone.selected;			// 開始実績日.
			search.actualStartDateFrom  = view.actualStartDateFrom.selectedDate;
			search.actualStartDateTo    = view.actualStartDateTo.selectedDate;
			search.actualFinishDateNone = view.actualFinishDateNone.selected;			// 終了実績日.
			search.actualFinishDateFrom = view.actualFinishDateFrom.selectedDate;
			search.actualFinishDateTo   = view.actualFinishDateTo.selectedDate;
			if (view.chkBelongProject.selected)
				search.staffId = Application.application.indexLogic.loginStaff.staffId;

			// プロジェクトリストを取得する.
			view.srv.getOperation("getProjectList").send(search);
		}

		/**
		 * 検索表示ボタンの押下.
		 *
		 * @param event Event
		 */
		public function onChange_swSearch(event:Event):void
		{
			changeSwSearch();
		}

//		/**
//		 * DateFieldフォーカスアウト.
//		 *
//		 * @param e FocusEvent
//		 */
//		public function onFocusOut_dateField(e:FocusEvent):void
//		{
//			// 入力データのチェックを行なう.
//			// →parseFunction はキー入力毎に呼ばれるため focusOut したときに入力チェックする.
//			var target:DateField = e.currentTarget as DateField;
//			var ret:Boolean = view.projectLogic.checkDateField_text(target);
//			if (!ret) {
//				target.text = "";
//				return;
//			}
//		}

		/**
		 * getProjectListの結果取得.
		 *
		 * @param event ResultEvent
		 */
		public function onResult_getProjectList(event:ResultEvent):void
		{
			// 結果を取得する.
			_projectList = event.result as ArrayCollection;
			setRequestProjectList(true);

			// ResultEventを通知する.
			var resultEvent:ResultEvent = event.clone() as ResultEvent;
			view.dispatchEvent(resultEvent);
		}

		/**
		 * RemoteObjectの呼び出し失敗.
		 *
		 * @param event FaultEvent
		 */
		public function onFault(event:FaultEvent):void
		{
			// FaultEventを通知する.
			var faultEvent:FaultEvent = event.clone() as FaultEvent;
			view.dispatchEvent(faultEvent);
		}

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * プロジェクトマネージャーリストの設定.
		 *
		 * @param pml プロジェクトマネージャリスト.
		 */
		public function displayProjectManager(pml:ArrayCollection):void
		{
			// リストをComboBoxデータに変換する.
			_projectPMList = pml;
			var cmlist:ArrayCollection = new ArrayCollection();
			cmlist.addItem({data:-99,label:"指定なし"});
			if (_projectPMList) {
				for (var i:int = 0; i < _projectPMList.length; i++) {
					cmlist.addItem(_projectPMList.getItemAt(i));
				}
			}
			// PMリストを設定する.
			view.cmbProjectManager.dataProvider = cmlist;

			// 未処理の検索要求を処理する.
			onClick_btnSearch(new Event("displayProjectManager"));
		}

		/**
		 * プロジェクトリストの取得.
		 *
		 */
		public function getProjectList():void
		{
			requestProjectList();
		}

		/**
		 * プロジェクトリストの取得.
		 */
		private function requestProjectList():void
		{
			onClick_btnSearch(new Event("requestProjectList"));
		}

		/**
		 * 検索表示ボタンの表示設定.
		 */
		private function changeSwSearch():void
		{
			if (view.swSearch.selected) {
//				view.searchOpt.setStyle("borderStyle",     "outset");
				view.searchOpt.setStyle("backgroundColor", 0xECE3EE);
				view.swSearch.setStyle("icon", view.iconMinus);
				view.swSearch.label = "検索条件を隠す";
				view.searchGrid.percentWidth = 100;
				view.searchGrid.percentHeight= 100;
			}
			else {
//				view.searchOpt.setStyle("borderStyle",     "none");
				view.searchOpt.setStyle("backgroundColor", 0xF8F4F9);
				view.swSearch.setStyle("icon", view.iconPlus);
				view.swSearch.label = "検索条件を開く";
				view.searchGrid.width = 0;
				view.searchGrid.height= 0;
			}
		}

		/**
		 * 検索実行の確認.
		 *
		 * @param event MouseEvent or Event
		 */
		private function onClick_btnSearch_check(event:Event):Boolean
		{
			// trace (event.toString());
			if (!setSearchOption()) {
				// 初期データ表示のとき 検索要求フラグONとする.
				if (ObjectUtil.compare(event.type, "requestProjectList") == 0) {
					_bSearchRequest = true;
				}
				return false;
			}

			// 検索要求フラグONなら OFFにする.
			if (_bSearchRequest)	_bSearchRequest = false;
			return true;
		}

		/**
		 * 検索条件の設定完了.
		 *
		 * @return true/false
		 */
		private function setSearchOption():Boolean
		{
			// 検索条件が設定されているかどうか確認する.
			var cmbProjectManagerItem:Object = view.cmbProjectManager.selectedItem;
			if (cmbProjectManagerItem) {
				return true;
			}
			return false;
		}

		/**
		 * 検索ボタン有効設定.
		 *
		 * @param enable 有効／無効.
		 */
		 private function setRequestProjectList(enable:Boolean):void
		 {
		 	view.btnSearch.enabled = enable;
		 	view.searchOpt.enabled = enable;
		 }

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectSearch;

	    /**
	     * 画面を取得します
	     */
	    public function get view():ProjectSearch
	    {
	        if (_view == null) {
	            _view = super.document as ProjectSearch;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:ProjectSearch):void
	    {
	        _view = view;
	    }
	}
}