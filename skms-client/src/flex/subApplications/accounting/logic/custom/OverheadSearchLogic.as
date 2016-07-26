package subApplications.accounting.logic.custom
{

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.OverheadSearchDto;
	import subApplications.accounting.logic.AccountingLogic;
	import subApplications.accounting.web.custom.OverheadSearch;


	/**
	 * 諸経費申請検索のLogicクラスです.
	 */
	public class OverheadSearchLogic extends Logic
	{
		/** データリスト */
		private var _transportationList:ArrayCollection;

		/** 状態リスト */
		private var _statusList:ArrayCollection;

		/** プロジェクトリスト */
		private var _projectList:ArrayCollection;

		/** 業務リスト */
		private var _businessList:ArrayCollection;

		/** Viewモード */
		private var _actionViewItem:Object;
		private const ACTION_VIEW_ITEMS:Array = new Array({mode   :AccountingLogic.ACTION_VIEW_APPROVAL,
														   project:"getApprovalProjectList",
														   status :"getApprovalTransportationStatusList",
														   rpc    :"getApprovalTransportations"},
														  {mode   :AccountingLogic.ACTION_VIEW_APPROVAL_AF,
														   project:"getApprovalProjectList_AF",
														   status :"getApprovalTransportationStatusList_AF",
														   rpc    :"getApprovalTransportations_AF"},
														  {mode   :AccountingLogic.ACTION_VIEW_REQUEST,
														   project:"getRequestProjectList",
														   status :"getRequestTransportationStatusList",
														   rpc    :"getRequestTransportations"}
														 );

		/** 検索要求フラグ */
		private var _bSearchRequest:Boolean;

		/** 諸経費取得タイマー */
		private var _requestTimer:Timer;


//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function OverheadSearchLogic()
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
	    	// 諸経費取得要求タイマーを設定する.
			_requestTimer = new Timer(1000, 10);
			_requestTimer.addEventListener(TimerEvent.TIMER, onTimer_requestOverheads);
			_requestTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete_requestOverheads);
	    }
//			/**
//			 * creationComplete処理.
//			 */
//			private function onCreationComplete(event:Event):void
//			{
//				// 検索表示ボタンを初期設定する.
//				changeSwSearch();
//
//				// 検索ボタンを初期設定する.
//				this.btnSearch.enabled = false;
//		 		this.searchOpt.enabled = false;
//			}


//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 検索ボタン押下.
		 */
		public function onButtonClick_btnSearch(e:MouseEvent):void
		{
			// 諸経費を取得する.
			requestOverheads();
		}


		/**
		 * 検索条件表示ボタンの押下.
		 *
		 * @param e MouseEvent.
		 */
		public  function onButtonClick_swSearch(e:MouseEvent):void
		{
			if (view.swSearch.selected) {
				view.searchOpt.setStyle("backgroundColor", 0xECE3EE);
				view.swSearch.label = "検索条件を隠す";
				view.searchGrid.percentWidth = 100;
				view.searchGrid.percentHeight= 100;
			}
			else {
				view.searchOpt.setStyle("backgroundColor", 0xF8F4F9);
				view.swSearch.label = "検索条件を開く";
				view.searchGrid.width = 0;
				view.searchGrid.height= 0;
			}
		}


		/**
		 * 諸経費取得タイマーイベント.
		 *
		 * @param e TimerEvent
		 */
		private function onTimer_requestOverheads(e:TimerEvent):void
		{
			// 諸経費を取得する.
			var request:Boolean = requestOverheads();
			if (request) 	_requestTimer.reset();
		}

		/**
		 * 諸経費取得タイマー完了イベント.
		 *
		 * @param e TimerEvent
		 */
		private function onTimerComplete_requestOverheads(e:TimerEvent):void
		{
			// 諸経費を取得する.
			var request:Boolean = requestOverheads();
			if (!request)	onFault(new FaultEvent("onTimerComplete_requestOverheads"));
		}


		/**
		 * 業務プロジェクトCheckBox選択.
		 *
		 * @param e Event.
		 */
		public function onClick_chkProject(e:MouseEvent):void
		{
			if (view.chkProject.selected) {
				view.cmbProject.enabled = true;
			}
			else {
				view.cmbProject.enabled = false;
			}
		}

		/**
		 * 全社業務CheckBox選択.
		 *
		 * @param e Event.
		 */
		public function onClick_chkAllBusiness(e:MouseEvent):void
		{
			if (view.chkAllBusiness.selected) {
				view.cmbAllBusiness.enabled = true;
			}
			else {
				view.cmbAllBusiness.enabled = false;
			}
		}

//			/**
//			 * 検索実行の確認.
//			 */
//			private function onClick_btnSearch_check(event:Event):Boolean
//			{
//				// trace (event.toString());
//				if (!setSearchOption(event)) {
//					// 初期データ表示のとき 検索要求フラグONとする.
//					if (ObjectUtil.compare(event.type, "initTransportations") == 0) {
//						_bSearchRequest = true;
//					}
//					return false;
//				}
//
//				// 検索要求フラグONなら 検索を実行する.
//				if (_bSearchRequest) {
//					_bSearchRequest = false;
//					return true;
//				}
//
//				// 検索要求を受けたとき 検索を実行する.
//				if (ObjectUtil.compare(event.type, "initTransportations") == 0 ||
//					ObjectUtil.compare(event.type, MouseEvent.CLICK) == 0	   ){
//					return true;
//				}
//				return false;
//			}
//			/**
//			 * 検索条件の設定完了.
//			 */
//			private function setSearchOption(event:Event):Boolean
//			{
//				// 検索条件が設定されているかどうか確認する.
//				if (_projectList && _statusList && _businessList) {
//					var cmbProjectItem:Object = this.cmbProject.selectedItem;
//					var chkStatusItems:Array = this.chkStatus as Array;
//					var cmbBusinessItem:Object = this.cmbAllBusiness.selectedItem;
//					if (cmbProjectItem && ObjectUtil.compare(chkStatusItems.length, _statusList.length) == 0 && cmbBusinessItem) {
//						return true;
//					}
//				}
//				return false;
//			}
//
//
//			/**
//			 * getStatusListの結果取得.
//			 * 状態チェックボックスの設定.
//			 */
//			private function onResult_getRequestTransportationStatusList(event:ResultEvent):void
//			{
//				setStatusList(event);
//			}
//			private function onResult_getApprovalTransportationStatusList(event:ResultEvent):void
//			{
//				setStatusList(event);
//			}
//			private function onResult_getApprovalTransportationStatusList_AF(event:ResultEvent):void
//			{
//				setStatusList(event);
//			}
//			private function setStatusList(event:ResultEvent):void
//			{
//				_statusList = event.result as ArrayCollection;
//				var list:ArrayCollection = new ArrayCollection();
//				for each (var status:Object in _statusList) {
//					list.addItem(status);
//				}
//				this.rpStatusList.dataProvider = list;
//			}
//			/**
//			 * 状態チェックボックス設定終了.
//			 */
//			private function onRepeatEnd_rpStatusList(event:Event):void
//			{
//				// 初期表示データを取得する.
//				onClick_btnSearch(event);
//			}
//
//
//			/**
//			 * getProjectListの結果取得.
//			 * プロジェクトコンボボックスの設定.
//			 */
//			private function onResult_getRequestProjectList(event:ResultEvent):void
//			{
//				setProjectList(event);
//			}
//			private function onResult_getApprovalProjectList(event:ResultEvent):void
//			{
//				setProjectList(event);
//			}
//			private function onResult_getApprovalProjectList_AF(event:ResultEvent):void
//			{
//				setProjectList(event);
//			}
//			private function setProjectList(event:ResultEvent):void
//			{
//				_projectList = event.result as ArrayCollection;
//				var list:ArrayCollection = new ArrayCollection();
//				list.addItem({label:"全てのプロジェクト", data:-1, selected:true});
//				for each (var project:Object in _projectList) {
//					list.addItem(project);
//				}
//				this.cmbProject.dataProvider = list;
//
//				// 初期表示データを取得する.
//				onClick_btnSearch(event);
//			}
//
//			/**
//			 * getWholeBusinessListの結果取得.
//			 * 全社業務コンボボックスの設定.
//			 */
//			private function onResult_getWholeBusinessList(event:ResultEvent):void
//			{
//				setWholeBusinessList(event);
//			}
//			private function setWholeBusinessList(event:ResultEvent):void
//			{
//				_businessList = event.result as ArrayCollection;
//				var list:ArrayCollection = new ArrayCollection();
//				list.addItem({label:"全ての全社業務", data:-1, selected:true});
//				for each (var business:Object in _businessList) {
//					list.addItem({label:business.projectCode + " " + business.projectName, data:business.projectId});
//				}
//				this.cmbAllBusiness.dataProvider = list;
//
//				// 初期表示データを取得する.
//				onClick_btnSearch(event);
//			}
//
//
//			/**
//			 * getTransportationsの結果取得.
//			 * データ取得通知.
//			 */
//			private function onResult_getRequestTransportations(event:ResultEvent):void
//			{
//				getTransportations(event);
//			}
//			private function onResult_getApprovalTransportations(event:ResultEvent):void
//			{
//				getTransportations(event);
//			}
//			private function onResult_getApprovalTransportations_AF(event:ResultEvent):void
//			{
//				getTransportations(event);
//			}
//			private function getTransportations(event:ResultEvent):void
//			{
//				if (!this.btnSearch.enabled)	{
//					this.btnSearch.enabled = true;
//					this.searchOpt.enabled = true;
//				}
//				_transportationList = event.result as ArrayCollection;
//				// ResultEventを通知する.
//				var resultEvent:ResultEvent = event.clone() as ResultEvent;
//				dispatchEvent(resultEvent);
//			}
//
//
//			/**
//			 * RemoteObjectの呼び出し失敗.
//			 */
//			private function onFault(event:FaultEvent):void
//			{
//				// FaultEventを通知する.
//				var faultEvent:FaultEvent = event.clone() as FaultEvent;
//				dispatchEvent(faultEvent);
//			}
//
//

//
//			/**
//			 * 検索条件の初期設定.
//			 */
//			private function onCreateComplete():void
//			{
//				// trace (" onCreateComplete");
//				for each (var actionItem:Object in ACTION_VIEW_ITEMS) {
//					if (ObjectUtil.compare(_actionMode, actionItem.mode) == 0) {
//						_actionViewItem = actionItem;
//					}
//				}
//
//				if (_actionViewItem) {
//					// PM承認時は「部下のみ」チェックボックスを表示して選択状態とする
//					if (_actionViewItem.mode == AccountingLogic.ACTION_VIEW_APPROVAL) {
//						chkSubordinateOnly.visible = true;
//						chkSubordinateOnly.enabled = true;
//						chkSubordinateOnly.selected = true;
//					}
//					// 検索条件を取得する.
//					this.srv.getOperation(_actionViewItem.project).send(Application.application.indexLogic.loginStaff);
//					this.srv.getOperation(_actionViewItem.status).send();
//					this.srv2.getOperation("getWholeBusinessList").send();
//				}
//				else {
//					var faultEvent:FaultEvent = FaultEvent.createEvent(new Fault("", "動作モードの設定が不正です。"));
//					dispatchEvent(faultEvent);
//				}
//			}
//

		/**
		 * getXxxxxOverheadsの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getXxxxxOverheads(e:ResultEvent):void
		{
			view.btnSearch.enabled = true;
			view.searchOpt.enabled = true;
			view.dispatchEvent(e);
		}

		/**
		 * getXxxxxStatusの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getXxxxxStatus(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			view.rpStatusList.dataProvider = list;
		}

		/**
		 * getXxxxxProjectの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getXxxxxProject(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			list.addItemAt({data:-99, label:"全てのプロジェクト"}, 0);
			view.cmbProject.dataProvider = list;
		}

		/**
		 * getAllBusinessの呼び出し成功.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getAllBusiness(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			list.addItemAt({data:-99, label:"全ての全社業務"}, 0);
			view.cmbAllBusiness.dataProvider = list;
		}

		/**
		 * getXxxxxの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault(e:FaultEvent):void
		{
			view.dispatchEvent(e);
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 検索表示ボタンの表示設定.
		 */
		private function changeSwSearch():void
		{
			if (view.swSearch.selected) {
				view.searchOpt.setStyle("backgroundColor", 0xECE3EE);
				view.swSearch.label = "検索条件を隠す";
				view.searchGrid.percentWidth = 100;
				view.searchGrid.percentHeight= 100;
			}
			else {
				view.searchOpt.setStyle("backgroundColor", 0xF8F4F9);
				view.swSearch.label = "検索条件を開く";
				view.searchGrid.width = 0;
				view.searchGrid.height= 0;
			}
		}


		/**
		 * 諸経費の問合せ.
		 *
		 */
		public function requestOverheads():Boolean
		{
			if (!_requestTimer.running) {
				view.btnSearch.enabled = false;
				view.searchOpt.enabled = false;
				view.dispatchEvent(new Event("requesting"));
			}

			// データ取得中かどうか確認する.
			var cursorID:int = CursorManager.getInstance().currentCursorID;
			if (ObjectUtil.compare(cursorID, CursorManager.NO_CURSOR) != 0) {
				// 先発優先でデータを取得する.
				if (_requestTimer.running) 		return false;
				// タイマーを開始する.
				_requestTimer.start();
				return false;
			}

			// 検索条件を作成する.
			var search:OverheadSearchDto = new OverheadSearchDto();
			// プロジェクトリスト.
			search.projectList = new ArrayCollection();
			search.projectList.addItem(-99);
			if (view.chkProject.selected) {
				if (view.cmbProject.selectedIndex > 0) {
					search.projectList.addItem(view.cmbProject.selectedItem.data);
				}
				else {
					for each (var pro:Object in view.cmbProject.dataProvider) {
						search.projectList.addItem(pro.data);
					}
				}
			}
			if (view.chkAllBusiness.selected) {
				if (view.cmbAllBusiness.selectedIndex > 0) {
					search.projectList.addItem(view.cmbAllBusiness.selectedItem.data);
				}
				else {
					for each (var biz:Object in view.cmbAllBusiness.dataProvider) {
						search.projectList.addItem(biz.data);
					}
				}
			}
			search.subordinateOnly = view.chkSubordinateOnly.selected;
			// 状態リスト.
			search.statusList = new ArrayCollection();
			search.statusList.addItem(-99);
			for each (var check:CheckBox in view.chkStatus) {
				if (check.selected) {
					search.statusList.addItem(check.selectedField);
				}
			}

			if (view.request) {
			   	view.srv.getOperation("getRequestOverheads").send(Application.application.indexLogic.loginStaff, search);
			}
			else if (view.approval) {
			   	view.srv.getOperation("getApprovalOverheads").send(Application.application.indexLogic.loginStaff, search);
			}
			else if (view.approvalAf) {
			   	view.srv.getOperation("getApprovalAfOverheads").send(Application.application.indexLogic.loginStaff, search);
			}
			return true;
		}

		/**
		 * 諸経費申請状態の問合せ.
		 *
		 */
		public function requestStatus():void
		{
			if (view.request) {
			   	view.srv.getOperation("getRequestStatus").send();
			}
			else if (view.approval) {
			   	view.srv.getOperation("getApprovalStatus").send();
			}
			else if (view.approvalAf) {
				view.srv.getOperation("getApprovalAfStatus").send();
			}
		}

		/**
		 * 業務プロジェクトの問合せ.
		 *
		 */
		public function requestProject():void
		{
			if (view.request) {
			   	view.srv.getOperation("getRequestProject").send(Application.application.indexLogic.loginStaff);
			}
			else if (view.approval) {
			   	view.srv.getOperation("getApprovalProject").send(Application.application.indexLogic.loginStaff);
			}
			else if (view.approvalAf) {
			   	view.srv.getOperation("getApprovalAfProject").send(Application.application.indexLogic.loginStaff);
			}
		}
		/**
		 * 全社プロジェクトの問合せ.
		 *
		 */
		public function requestAllBusiness():void
		{
		   	view.srv.getOperation("getAllBusiness").send();
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:OverheadSearch;

	    /**
	     * 画面を取得します
	     */
	    public function get view():OverheadSearch
	    {
	        if (_view == null) {
	            _view = super.document as OverheadSearch;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:OverheadSearch):void
	    {
	        _view = view;
	    }

	}
}

