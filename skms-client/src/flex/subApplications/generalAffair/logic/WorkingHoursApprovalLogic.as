package subApplications.generalAffair.logic
{
	import components.PopUpWindow;
	
	import dto.StaffDto;
	
	import enum.WorkingHoursStatusId;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.dto.WorkingHoursDailyDto;
	import subApplications.generalAffair.dto.WorkingHoursHistoryDto;
	import subApplications.generalAffair.web.WorkingHoursApproval;
	import subApplications.generalAffair.web.WorkingHoursEntryWithdraw;


	/**
	 * WorkingHoursAnalizeのLogicクラスです。


	 */
	public class WorkingHoursApprovalLogic extends Logic
	{


		/** 勤務時間承認  リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
			= new ArrayCollection([
				{label:"承認"
					,	func:"onClick_linkList_approval"
					,	prepare:"onClick_linkList_approval_confirm"
					,	enabled:false
					,	enabledCheck:"enabledApproval"},
				{label:"承認前に戻す"
					,	func:"onClick_linkList_approvalCancel"
					,	enabled:false
					,	enabledCheck:"enabledApprovalCancel"},
				{label:"提出者に差し戻す"
					,	func:"onClick_linkList_approvalReject"
					,	enabled:false
					,	enabledCheck:"enabledApprovalReject"},
				{label:"Excel形式で出力"
					,	func:"onClick_linkExport"
					,	enabled:false
					,	enabledCheck2:"enabledExport"},
				{label:"Excel形式で出力(全員分)"
					,	func:"onClick_linkExportAll"
					,	enabled:false
					,	enabledCheck2:"enabledExportAll"},
			]);


		/** 勤怠リスト */
		private var _attendanceList:ArrayCollection;

		/** 選択した勤務日 */
		private var _selectedWorkTimeDate:WorkingHoursDailyDto;

		/** 選択した社員 */
		private var _selectedWorkingHoursHistoryDto:WorkingHoursHistoryDto;

		/** 時刻(時)リスト */
		private var _timeHList:ArrayCollection;

		/** 時刻(文)リスト */
		private var _timeMList:ArrayCollection;

		/** 選択されたリンクバー */
		private var _selectedLinkObject:Object;

		/** 取り消し理由 */
		private var _cancelReason:String;

		/** カラーパターン */
		private var _defaultColors:Array = null;

		/** 表示中の年 */
		private var _workingYear:int;

		/** 表示中の月 */
		private var _workingMonth:int;

		/** ログインユーザのプロジェクト役職 */
		private var _projectPositionId:int;
		
		// リンクボタンアイコン
        [Embed(source="images/arrow_previous.gif")]
        private var _icon_previous:Class;

        [Embed(source="images/arrow_previous_d.gif")]
        private var _icon_previous_d:Class;

        [Embed(source="images/arrow_next.gif")]
        private var _icon_next:Class;

        [Embed(source="images/arrow_next_d.gif")]
        private var _icon_next_d:Class;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function WorkingHoursApprovalLogic()
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
	    	view.rpLinkList.dataProvider = RP_LINKLIST;
	    	view.stpYear.value = now.getFullYear();
	    	view.stpMonth.value = now.getMonth() + 1;
	    	onClick_linkHideDateSetting(null);

			var loginStaff:StaffDto = Application.application.indexLogic.loginStaff;
			// PMでないならば
			if (!loginStaff.isProjectPositionPM()) {
				view.chkSubordinateOnly.visible = false;
			}

			// 総務部長ならば
			if (loginStaff.isDepartmentHeadGA()) {
				view.chkSubordinateOnly.selected = false;
			}

			// 勤務管理表手続き状況リストの取得
			view.srv.getOperation("getWorkingHoursStatusList").send();

	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 	表示ボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_btnRefresh(e:MouseEvent):void
		{
			// 勤務時間詳細データのクリア
			view.tblWorkingHours.clear();
			view.lblStaffName.text = "";

			_workingYear = view.stpYear.value;
			_workingMonth = view.stpMonth.value;

			setlinkMonthEnabled();

			// 勤務月コード
        	var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			var workingMonthCode:String = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
			df.formatString = "YYYY年MM月";
        	view.lblWorkingMonth.text = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
	    	// 勤務管理表手続き状況の取得
	    	var isSubordinateOnly:Boolean = view.chkSubordinateOnly.selected;

			// 検索条件 状態 を取得する.
			var chkStatusItems:Array = view.chkStatus as Array;
			var statusItems:Array = new Array();
			var index:int = 0;
			for each (var chkStatusItem:CheckBox in chkStatusItems) {
				if (chkStatusItem.selected) {
					statusItems.push(parseInt(chkStatusItem.selectedField));
				}
				index++;
			}
			// allCheckOFFにすると全検索されてしまうためダミー値を設定する.
			statusItems.push(-99);

	    	view.srv.getOperation("getSubordinateCurrentWorkingHoursStatus")
	    		.send(Application.application.indexLogic.loginStaff, workingMonthCode,
	    			isSubordinateOnly, statusItems);
		}

		/**
		 * リンクボタン選択.
		 *
		 * @param e ItemClickEvent.
		 */
		public function onClick_linkList(e:MouseEvent):void
		{
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
		 * リンクボタン選択 承認確認.
		 *
		 * @param e Event
		 */
		public function onClick_linkList_approval_confirm(e:Event):void
		{
			Alert.show("承認してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}

		/**
		 * リンクボタン選択 承認.
		 *
		 */
		public function onClick_linkList_approval():void
		{
			// 承認する.
			view.tblWorkingHours.approval(Application.application.indexLogic.loginStaff, _projectPositionId, "");
		}

		/**
		 * リンクボタン選択 承認取り消し.
		 * @param initReason	理由初期化.
		 *
		 */
		public function onClick_linkList_approvalCancel(initReason:Boolean = true):void
		{

			// 理由を初期化する.
			if (initReason) _cancelReason = null;

//			// WorkingHoursEntryWithdraw（承認取り消し）を作成する.
//			var pop:WorkingHoursEntryWithdraw = new WorkingHoursEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = new Object();
//			obj.entry		= "";
//			obj.withdraw	= "承認前に戻す";
//			obj.reason		= _cancelReason;
//			IDataRenderer(pop).data = obj;
//
//			// 	closeイベントを監視する.
//			pop.addEventListener(CloseEvent.CLOSE, onApprovalCancelPopUpClose);
//
//			// P.U画面を表示する.
//			PopUpManager.centerPopUp(pop);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			obj.entry		= "";
			obj.withdraw	= "承認前に戻す";
			obj.reason		= _cancelReason;

			// P.U画面を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(WorkingHoursEntryWithdraw, view.parentApplication as DisplayObject, obj);

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onApprovalCancelPopUpClose);
		}


		/**
		 * リンクボタン選択 差し戻し.
		 *
		 */
		public function onClick_linkList_approvalReject(initReason:Boolean = true):void
		{
			// 理由を初期化する.
			if (initReason) _cancelReason = null;

//			// WorkingHoursEntryWithdraw（承認取り下げ）を作成する.
//			var pop:WorkingHoursEntryWithdraw = new WorkingHoursEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = new Object();
//			obj.entry		= "";
//			obj.withdraw	= "提出者に差し戻す";
//			obj.reason		= _cancelReason;
//			IDataRenderer(pop).data = obj;
//
//			// 	closeイベントを監視する.
//			pop.addEventListener(CloseEvent.CLOSE, onApprovalRejectPopUpClose);
//
//			// P.U画面を表示する.
//			PopUpManager.centerPopUp(pop);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			obj.entry		= "";
			obj.withdraw	= "提出者に差し戻す";
			obj.reason		= _cancelReason;

			// P.U画面を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(WorkingHoursEntryWithdraw, view.parentApplication as DisplayObject, obj);

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onApprovalRejectPopUpClose);
		}

		/**
		 * リンクボタン選択 前月.
		 *
		 */
		public function onClick_linkPreviousMonth(e:MouseEvent):void
		{
			view.stpYear.value = _workingYear;
			view.stpMonth.value = _workingMonth;

			if (view.stpMonth.value == 1) {
				view.stpYear.value--;
				view.stpMonth.value = 12;
			} else {
				view.stpMonth.value--;
			}

			setlinkMonthEnabled();

			_workingYear = view.stpYear.value;
			_workingMonth = view.stpMonth.value;

			onClick_btnRefresh(null);
		}

		/**
		 * リンクボタン選択 翌月.
		 *
		 */
		public function onClick_linkNextMonth(e:MouseEvent):void
		{
			view.stpYear.value = _workingYear;
			view.stpMonth.value = _workingMonth;

			if (view.stpMonth.value == 12) {
				view.stpYear.value++;
				view.stpMonth.value = 1;
			} else {
				view.stpMonth.value++;
			}

			setlinkMonthEnabled();

			_workingYear = view.stpYear.value;
			_workingMonth = view.stpMonth.value;

			onClick_btnRefresh(null);
		}

		/**
		 * リンクボタン選択 年月指定.
		 *
		 */
		public function onClick_linkShowDateSetting(e:MouseEvent):void
		{
			view.vbxShowDateSetting.width = 0;
			view.vbxShowDateSetting.height = 0;
			view.vbxHideDateSetting.percentWidth = 100;
			view.vbxHideDateSetting.percentHeight = 100;
		}

		/**
		 * リンクボタン選択 閉じる.
		 *
		 */
		public function onClick_linkHideDateSetting(e:MouseEvent):void
		{
			view.vbxShowDateSetting.percentWidth = 100;
			view.vbxShowDateSetting.percentHeight = 100;
			view.vbxHideDateSetting.width = 0;
			view.vbxHideDateSetting.height = 0;
		}

		/**
		 * リンクボタン選択 エクスポート.
		 *
		 */
		public function onClick_linkExport():void
		{
      		var req:URLRequest = new URLRequest("/skms-server/workingHoursFileExport_xlsx");
            req.method = URLRequestMethod.POST;

            var uv:URLVariables = new URLVariables();

            var workingHoursStatusList:ArrayCollection = view.grdWorkingHoursStatus.dataProvider as ArrayCollection;
            var staffIds:String = _selectedWorkingHoursHistoryDto.staffId.toString();
           	uv.staffId = staffIds;
			var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			uv.workingMonthCode = df.format(new Date(_workingYear, _workingMonth - 1, 1));

            req.data = uv;
 			navigateToURL(req, "_blank");
		}

		/**
		 * リンクボタン選択 エクスポート(全員分).
		 *
		 */
		public function onClick_linkExportAll():void
		{
      		var req:URLRequest = new URLRequest("/skms-server/workingHoursFileExport_xlsx");
            req.method = URLRequestMethod.POST;

            var uv:URLVariables = new URLVariables();

            var workingHoursStatusList:ArrayCollection = view.grdWorkingHoursStatus.dataProvider as ArrayCollection;
            var staffIds:String = "";
            for each(var whh:WorkingHoursHistoryDto in workingHoursStatusList) {
            	if (staffIds != "") staffIds += ",";
            	staffIds += whh.staffId.toString();
            }
           	uv.staffId = staffIds;
			var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			uv.workingMonthCode = df.format(new Date(_workingYear, _workingMonth - 1, 1));

            req.data = uv;
 			navigateToURL(req, "_blank");
		}

		/**
		 * エクスポートリンクボタンの有効無効判定.
		 *
		 * @return enabled 有効/無効.
		 */
		private function enabledExport():Boolean
		{
			if (view.grdWorkingHoursStatus.selectedIndex >= 0) return true;
			return false;
		}

		/**
		 * エクスポート(全員分)リンクボタンの有効無効判定.
		 *
		 * @return enabled 有効/無効.
		 */
		private function enabledExportAll():Boolean
		{
			if (view.grdWorkingHoursStatus.dataProvider.length > 0) return true;
			return false;
		}

		/**
		 * WorkingHoursEntryWithdraw(承認前に戻す)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onApprovalCancelPopUpClose(e:CloseEvent):void
		{
			// p.u画面登録で終了した場合.
			if(e.detail == PopUpWindow.ENTRY){
				var pop:WorkingHoursEntryWithdraw = e.currentTarget as WorkingHoursEntryWithdraw;
				_cancelReason = pop.reason.text;
				// 承認を取り消す.
				view.tblWorkingHours.approvalCancel(Application.application.indexLogic.loginStaff, _projectPositionId, _cancelReason);
			}
		}

		/**
		 * WorkingHoursEntryWithdraw(申請者に差し戻す)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onApprovalRejectPopUpClose(e:CloseEvent):void
		{
			// p.u画面登録で終了した場合.
			if(e.detail == PopUpWindow.ENTRY){
				var pop:WorkingHoursEntryWithdraw = e.currentTarget as WorkingHoursEntryWithdraw;
				_cancelReason = pop.reason.text;
				// 承認を取り下げる.
				view.tblWorkingHours.approvalReject(Application.application.indexLogic.loginStaff, _projectPositionId, _cancelReason);
			}
		}

		/**
		 * RemoteObject（承認）の呼び出し成功イベントハンドラ.
		 *
		 */
		public function onCompleteApproval_tblWorkingHours(e:Event):void
		{
			// 勤務管理表手続き状況の取得
			view.srv.getOperation("getCurrentWorkingHoursStatus")
				.send(_selectedWorkingHoursHistoryDto.staffId, _selectedWorkingHoursHistoryDto.workingMonthCode);
		}

		/**
		 * RemoteObject（承認）の排他エラーイベントハンドラ.
		 *
		 */
		public function onOptimisticLockApproval_tblWorkingHours(e:Event):void
		{
			Alert.show("他のユーザにより既にデータが更新されています。\n承認ができません。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（承認）の呼び出し失敗イベントハンドラ.
		 *
		 */
		public function onFaultApproval_tblWorkingHours(e:Event):void
		{
			Alert.show("承認に失敗しました。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（承認取り消し）の排他エラーイベントハンドラ.
		 *
		 */
		public function onOptimisticLockApprovalCancel_tblWorkingHours(e:Event):void
		{
			Alert.show("他のユーザにより既にデータが更新されています。\n承認取り消しができません。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（承認取り消し）の呼び出し失敗イベントハンドラ.
		 *
		 */
		public function onFaultApprovalCancel_tblWorkingHours(e:Event):void
		{
			Alert.show("承認取り消しに失敗しました。","",Alert.OK,null,faulApprovalCancelCloseHandler);
		}

		/**
		 * RemoteObject（承認取り下げ）の排他エラーイベントハンドラ.
		 *
		 */
		public function onOptimisticLockApprovalReject_tblWorkingHours(e:Event):void
		{
			Alert.show("他のユーザにより既にデータが更新されています。\n承認差し戻しができません。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（承認取り下げ）の呼び出し失敗イベントハンドラ.
		 *
		 */
		public function onFaultApprovalReject_tblWorkingHours(e:Event):void
		{
			Alert.show("承認差し戻しに失敗しました。","",Alert.OK,null,faulApprovalRejectCloseHandler);
		}

		/**
		 * アラート（承認取り消し）クローズに関連付けされたイベントハンドラ.
		 *
		 * @param event Closeイベント.
		 */
		private function faulApprovalCancelCloseHandler(event:CloseEvent):void
		{
			// P.U再表示する.
			onClick_linkList_approvalCancel(false);
		}

		/**
		 * アラート（承認取り下げ）クローズに関連付けされたイベントハンドラ.
		 *
		 * @param event Closeイベント.
		 */
		private function faulApprovalRejectCloseHandler(event:CloseEvent):void
		{
			// P.U再表示する.
			onClick_linkList_approvalReject(false);
		}

		/**
		 * 	勤務時間概要データグリッドクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
		public function onChange_grdWorkingHoursStatus(e:ListEvent):void
		{
	 		// 勤務表のクリア
	 		view.tblWorkingHours.clear();

			// 選択した社員情報を取得する.
			_selectedWorkingHoursHistoryDto = view.grdWorkingHoursStatus.selectedItem as WorkingHoursHistoryDto;

			// 氏名の表示
			view.lblStaffName.text = _selectedWorkingHoursHistoryDto.staffName.fullName + "さん";
			// 年月の表示
			var year:String = _selectedWorkingHoursHistoryDto.workingMonthCode.substr(0, 4);
			var month:String = _selectedWorkingHoursHistoryDto.workingMonthCode.substr(4, 2);
//        	view.lblWorkingMonth2.text = year + "年" + month + "月";

			// 勤務表手続き履歴
			var workingStatusId:int = _selectedWorkingHoursHistoryDto.workingHoursStatusId;
			// 勤務表を作成済みならば
			if (workingStatusId != WorkingHoursStatusId.NONE) {
				// 社員ID
				var staffId:int = _selectedWorkingHoursHistoryDto.staffId;
				// 勤務月コード
				var workingMonthCode:String = _selectedWorkingHoursHistoryDto.workingMonthCode;
				// ログインユーザのプロジェクト役職の取得
			    view.srv.getOperation("getStaffProjectPositionId")
	    			.send(Application.application.indexLogic.loginStaff.staffId, staffId, workingMonthCode);
		 	}
		}

	    /**
	     * getWorkingHoursStatusList処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getWorkingHoursStatusList(e:ResultEvent):void
        {
        	view.rpStatusList.dataProvider = e.result as ArrayCollection;
			// 初期表示データを取得する.
	    	onClick_btnRefresh(null);
		}

	    /**
	     * getStaffProjectPositionId処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getStaffProjectPositionId(e:ResultEvent):void
        {
        	// プロジェクト役職
        	_projectPositionId = e.result as int;
			// 社員ID
			var staffId:int = _selectedWorkingHoursHistoryDto.staffId;
			// 勤務月コード
			var workingMonthCode:String = _selectedWorkingHoursHistoryDto.workingMonthCode;
			// 勤務時間(月別)の取得
	    	view.tblWorkingHours.load(staffId, workingMonthCode);
		}

	    /**
	     * getStaffWorkingHoursTotalList処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getSubordinateCurrentWorkingHoursStatus(e:ResultEvent):void
        {
        	view.grdWorkingHoursStatus.dataProvider = e.result as ArrayCollection;

			// データソート時のイベント登録
			view.grdWorkingHoursStatus.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChanged_grdWorkingHoursStatus);

			setColorPattern(view.grdWorkingHoursStatus, view.grdWorkingHoursStatus.dataProvider as ArrayCollection);

        	var list:ArrayCollection = e.result as ArrayCollection;
        	var i:int = 0;
        	view.grdWorkingHoursStatus.selectedIndex = -1;
        	for each(var whh:WorkingHoursHistoryDto in list) {
        		if (_selectedWorkingHoursHistoryDto != null
        			&& whh.staffId == _selectedWorkingHoursHistoryDto.staffId) {
        				view.grdWorkingHoursStatus.selectedIndex = i;
        				view.grdWorkingHoursStatus.scrollToIndex(i);
        				onChange_grdWorkingHoursStatus(null);
        				return;
        		}
        		i++;
        	}
			view.lblStaffName.text = "左で選択された社員の勤務管理表を表示します。";
			// リンクボタンの状態制御
			setRpLinkListStatus();
		}

	    /**
	     * getStaffWorkingHoursStatus処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getCurrentWorkingHoursStatus(e:ResultEvent):void
        {
        	// 選択中の社員の勤務管理表手続き状態を更新する。
        	var list:ArrayCollection = view.grdWorkingHoursStatus.dataProvider as ArrayCollection;
        	var i:int = 0;

        	for each(var whh:WorkingHoursHistoryDto in list) {
        		if (whh.staffId == _selectedWorkingHoursHistoryDto.staffId) {
		        	list.setItemAt(e.result as WorkingHoursHistoryDto, i);
		        	break;
		        }
		        i++;
        	}
			setColorPattern(view.grdWorkingHoursStatus, list);
		}

		/**
		 * 勤務管理表読込完了イベントハンドラ.
		 *
		 */
		public function onLoadComplete_tblWorkingHours(e:Event):void
		{
			// リンクボタンの状態設定
			setRpLinkListStatus();
		}

	    /**
	     * リモートオブジェクト実行の失敗イベント
	     *
	     * @param e FaultEvent
	     */
        public function onFault_remoteObject(e:FaultEvent):void
        {
			Alert.show("勤務管理表データの取得に失敗しました。","",Alert.OK,null,null);
		}

		// データグリッドでソートが実行された時のイベント
		private function onCollectionChanged_grdWorkingHoursStatus(e:CollectionEvent):void
		{
			setColorPattern(view.grdWorkingHoursStatus, e.currentTarget as ArrayCollection);
		}

//--------------------------------------
//  Function
//--------------------------------------

		/**
	     * 行の背景色用カラーパターンを生成.
	     *
	     * @param dg	データグリッド.
	     * @param data	データプロバイダ.
	     */
		private function setColorPattern(dg:DataGrid, data:ArrayCollection):void
		{
//			if(!_defaultColors){
//				// 初期値のカラーパターンを記憶
//				_defaultColors = dg.getStyle("alternatingItemColors");
//			}
//
//			if (!data) return;
//
//			var colors:Array = new Array();
//			var rowMax:uint = (data.length > 100) ? data.length : 100;
//
//			for(var i:int = 0;i < rowMax; i++){
//				// データによって色を変更する
//				if(i < data.length){
//					var whh:WorkingHoursHistoryDto = data[i];
//					if (whh.workingHoursStatus.workingHoursStatusColor) {
//						colors.push(whh.workingHoursStatus.workingHoursStatusColor);
//					} else {
//						colors.push(_defaultColors[i % 2]);
//					}
//				}else{
//					colors.push(_defaultColors[i % 2]);
//				}
//			}
//			dg.setStyle("alternatingItemColors", colors);
		}


		/**
	     * 勤務管理表作成  リンクボタン状態設定.
	     *
	     * @return リンクボタンリスト.
	     */
		private function setRpLinkListStatus():void
		{
			// リンクボタンの数分繰り返し.
			for(var i:int = 0; i < view.rpLinkList.dataProvider.length; i++) {
				// リンクボタンオブジェクトの取得
				var linkObject:Object = view.rpLinkList.dataProvider.getItemAt(i);
				// 可否チェック用プロパティが定義されていたら
				if (linkObject.hasOwnProperty("enabledCheck")) {
					// 勤務管理テーブルの可否チェック
					if (view.tblWorkingHours) {
						linkObject.enabled
							= view.tblWorkingHours[linkObject.enabledCheck](Application.application.indexLogic.loginStaff, _projectPositionId);
						// リンクボタンの表示にも反映させる.
						view.linkList[i].enabled = linkObject.enabled;
					}
				} else if (linkObject.hasOwnProperty("enabledCheck2")) {
					// 勤務管理テーブルの可否チェック
					linkObject.enabled
						= this[linkObject.enabledCheck2]();
					// リンクボタンの表示にも反映させる.
					view.linkList[i].enabled = linkObject.enabled;
				}
			}
		}

		/**
		 * 時間フォーマット処理.
		 *
		 * @param hours 時間データ.
		 * @return フォーマット済みのデータ項目.
		 */
		public function hoursLabel(data:Object, column:DataGridColumn):String
		{
			var nf:NumberFormatter = new NumberFormatter();
			nf.precision = 2;
			// データを取得する.
			var hours:Number = data[column.dataField] as Number;
			if (isNaN(hours) || hours == 0) return "";

	        return nf.format(hours);
	    }

		/**
		 * 回数フォーマット処理.
		 *
		 * @param hours 回数データ.
		 * @return フォーマット済みのデータ項目.
		 */
		public function countLabel(data:Object, column:DataGridColumn):String
		{
			// データを取得する.
			var count:int = data[column.dataField] as int;
			if (isNaN(count) || count == 0) return "";

	        return count.toString();
	    }

		/**
		 * 前月／翌月リンクボタン有効無効判定処理.
		 *
		 */
		private function setlinkMonthEnabled():void
		{
			if (view.stpYear.value == view.stpYear.minimum
				&& view.stpMonth.value == view.stpMonth.minimum) {
				view.linkPreviousMonth.enabled = false;
				view.linkPreviousMonth.setStyle("icon", _icon_previous_d);
			}
			if (view.stpYear.value == view.stpYear.maximum
				&& view.stpMonth.value == view.stpMonth.maximum) {
				view.linkNextMonth.enabled = false;
				view.linkNextMonth.setStyle("icon", _icon_next_d);
			}
			if (view.stpYear.value > view.stpYear.minimum
				|| view.stpMonth.value > view.stpMonth.minimum) {
				view.linkPreviousMonth.enabled = true;
				view.linkPreviousMonth.setStyle("icon", _icon_previous);
			}
			if (view.stpYear.value < view.stpYear.maximum
				|| view.stpMonth.value < view.stpMonth.maximum) {
				view.linkNextMonth.enabled = true;
				view.linkNextMonth.setStyle("icon", _icon_next);
			}

	    }

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:WorkingHoursApproval;

	    /**
	     * 画面を取得します
	     */
	    public function get view():WorkingHoursApproval
	    {
	        if (_view == null) {
	            _view = super.document as WorkingHoursApproval;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:WorkingHoursApproval):void
	    {
	        _view = view;
	    }

	}
}