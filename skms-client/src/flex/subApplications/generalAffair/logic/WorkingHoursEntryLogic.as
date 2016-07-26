package subApplications.generalAffair.logic
{
	import components.PopUpWindow;

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
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;

	import subApplications.generalAffair.dto.WorkingHoursDailyDto;
	import subApplications.generalAffair.web.WorkingHoursEntry;
	import subApplications.generalAffair.web.WorkingHoursEntryWithdraw;

	import utils.CommonIcon;


	/**
	 * WorkingHoursのLogicクラスです。
	 */
	public class WorkingHoursEntryLogic extends Logic
	{




		/** 勤務時間承認  リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
			= new ArrayCollection([
				{label:"保存",
						func:"onClick_linkList_entry",
						prepare:"onClick_linkList_entry_confirm",
						enabled:false,
						enabledCheck:"enabledEntry"},
				{label:"提出",
						func:"onClick_linkList_submit",
						prepare:"onClick_linkList_submit_confirm",
						enabled:false,
						enabledCheck:"enabledSubmit"},
				{label:"提出取り消し",
						func:"onClick_linkList_submitCancel",
						enabled:false,
						enabledCheck:"enabledSubmitCancel"},
/*
				{label:"Excel形式で出力(.xls)",
						func:"onClick_linkExport",
						enabled:true
						},
*/						
				//追加 @auther watanuki		
				{label:"Excel形式で出力",
						func:"onClick_linkExport_xlsx",
						enabled:true
						},
			]);



		/** 勤怠リスト */
		private var _attendanceList:ArrayCollection;

		/** 選択した勤務日 */
		private var _selectedWorkTimeDate:WorkingHoursDailyDto;


		/** 時刻(時)リスト */
		private var _timeHList:ArrayCollection;

		/** 時刻(文)リスト */
		private var _timeMList:ArrayCollection;

		/** 選択されたリンクバー */
		protected var _selectedLinkObject:Object;

		/** 取り消し理由 */
		protected var _cancelReason:String;

		/** 表示中の年 */
		private var _workingYear:int;

		/** 表示中の月 */
		private var _workingMonth:int;

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
		public function WorkingHoursEntryLogic()
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
	    	onClick_btnRefresh(null);
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 勤務管理表読込完了イベントハンドラ.
		 *
		 */
		public function onLoadComplete_tblWorkingHours(e:Event):void
		{
			// リンクボタンの状態設定.
			setRpLinkListStatus();
			// コントロールの更新状態設定.
			setUpdateStatus();
			// データ変更状態設定
			setModifiedStatus(false);

			// 年月の表示
			var year:String = view.stpYear.value.toString();
			var month:String = view.stpMonth.value.toString();

		}


		/**
		 * 勤務管理表入力値変更イベントハンドラ.
		 *
		 */
		public function onChangeInputData_tblWorkingHours(e:Event):void
		{
			// リンクボタンの状態設定.
			setRpLinkListStatus();

			// データ変更状態設定
			setModifiedStatus(true);
		}





		/**
		 * 	表示ボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_btnRefresh(e:MouseEvent):void
		{
			// データ変更ありならば
			if (Application.application.indexLogic.modified) {
					Alert.show("当月のデータが変更されましたが保存されていません。\nデータを破棄して表示月を変更してもよろしいですか？",
					 "",
					  Alert.YES | Alert.NO,
					   view,
					    onClose_CancelAlert,
					    CommonIcon.questionIcon);
			} else {
				// 勤務管理表表示更新
				refreshWorkingHours();
			}
		}

		/**
		 * 	リンクボタン選択 保存確認.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_linkList_entry_confirm(e:Event):void
		{
			Alert.show("保存してもよろしいですか？", "" , 3 , view, onClick_linkList_confirmResult);
		}

	    /**
	     * リンクボタン選択 保存.
	     *
	     * @param e CloseEvent
	     */
		public function onClick_linkList_entry():void
		{
			// 勤務管理表データの更新
	    	view.tblWorkingHours.save(Application.application.indexLogic.loginStaff);
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
		 * リンクボタン選択 提出確認.
		 *
		 * @param e Event
		 */
		public function onClick_linkList_submit_confirm(e:Event):void
		{
			Alert.show("提出してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}

		/**
		 * リンクボタン選択 提出.
		 *
		 */
		public function onClick_linkList_submit():void
		{
			// 提出する.
			view.tblWorkingHours.submit(Application.application.indexLogic.loginStaff, "");
		}

		/**
		 * リンクボタン選択 提出取り消し.
		 * @param initReason	理由初期化.
		 *
		 */
		public function onClick_linkList_submitCancel(initReason:Boolean = true):void
		{
			// 理由を初期化する.
			if (initReason) _cancelReason = null;

//			// WorkingHoursEntryWithdraw（取り消し）を作成する.
//			var pop:WorkingHoursEntryWithdraw = new WorkingHoursEntryWithdraw();
//			PopUpManager.addPopUp(pop, view.parentApplication as DisplayObject, true);
//
//			// 引き継ぐデータを設定する.
//			var obj:Object = new Object();
//			obj.entry		= "提出";
//			obj.withdraw	= "取り消し";
//			obj.reason		= _cancelReason;
//			IDataRenderer(pop).data = obj;
//
//			// 	closeイベントを監視する.
//			pop.addEventListener(CloseEvent.CLOSE, onSubmitCancelPopUpClose);
//
//			// P.U画面を表示する.
//			PopUpManager.centerPopUp(pop);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			obj.entry		= "提出";
			obj.withdraw	= "取り消し";
			obj.reason		= _cancelReason;

			// P.U画面を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(WorkingHoursEntryWithdraw, view.parentApplication as DisplayObject, obj);

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onSubmitCancelPopUpClose);
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
      		var req:URLRequest = new URLRequest("/skms-server/workingHoursFileExport");
            req.method = URLRequestMethod.POST;

            var uv:URLVariables = new URLVariables();
            uv.staffId = Application.application.indexLogic.loginStaff.staffId;
			var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			uv.workingMonthCode = df.format(new Date(_workingYear, _workingMonth - 1, 1));

            req.data = uv;
 			navigateToURL(req, "_blank");
		}
		
		//追加 @auther watanuki
		public function onClick_linkExport_xlsx():void
		{
      		var req:URLRequest = new URLRequest("/skms-server/workingHoursFileExport_xlsx");
            req.method = URLRequestMethod.POST;

            var uv:URLVariables = new URLVariables();
            uv.staffId = Application.application.indexLogic.loginStaff.staffId;
			var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			uv.workingMonthCode = df.format(new Date(_workingYear, _workingMonth - 1, 1));

            req.data = uv;
 			navigateToURL(req, "_blank");
		}
		
		/**
		 * WorkingHoursEntryWithdraw(提出取り消し)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onSubmitCancelPopUpClose(e:CloseEvent):void
		{
			// p.u画面登録で終了した場合.
			if(e.detail == PopUpWindow.ENTRY){
				var pop:WorkingHoursEntryWithdraw = e.currentTarget as WorkingHoursEntryWithdraw;
				_cancelReason = pop.reason.text;
				// 提出取り下げを行なう.
				view.tblWorkingHours.submitCancel(Application.application.indexLogic.loginStaff, _cancelReason);
			}
		}

		/**
		 * RemoteObject（更新）の呼び出し失敗イベントハンドラ.
		 *
		 */
		public function onFaultUpdate_tblWorkingHours(e:Event):void
		{
			Alert.show("更新に失敗しました。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（提出）の排他エラーイベントハンドラ.
		 *
		 */
		public function onOptimisticLockSubmit_tblWorkingHours(e:Event):void
		{
			Alert.show("他のユーザにより既にデータが更新されています。\n提出ができません。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（提出）の呼び出し失敗イベントハンドラ.
		 *
		 */
		public function onFaultSubmit_tblWorkingHours(e:Event):void
		{
			Alert.show("提出に失敗しました。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（提出取り消し）の排他エラーイベントハンドラ.
		 *
		 */
		public function onOptimisticLockSubmitCancel_tblWorkingHours(e:Event):void
		{
			Alert.show("他のユーザにより既にデータが更新されています。\n提出取り消しができません。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（提出取り消し）の呼び出し失敗イベントハンドラ.
		 *
		 */
		public function onFaultSubmitCancel_tblWorkingHours(e:Event):void
		{
			Alert.show("提出取り消しに失敗しました。","",Alert.OK,null,faulSubmitCancelCloseHandler);
		}

		/**
		 * アラート（提出取り消し）クローズに関連付けされたイベントハンドラ.
		 *
		 * @param event Closeイベント.
		 */
		private function faulSubmitCancelCloseHandler(event:CloseEvent):void
		{
			// P.U再表示する.
			onClick_linkList_submitCancel(false);
		}


//--------------------------------------
//  Function
//--------------------------------------

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
					linkObject.enabled
						= view.tblWorkingHours[linkObject.enabledCheck](Application.application.indexLogic.loginStaff);
					// リンクボタンの表示にも反映させる.
					view.linkList[i].enabled = linkObject.enabled;
				}
			}
		}


		/**
	     * 勤務管理表作成  コントロールの更新状態設定.
	     *
	     */
		private function setUpdateStatus():void
		{
			// 勤務管理テーブルの可否チェック
			var isEdit:Boolean;
			isEdit = view.tblWorkingHours.enabledEntry(Application.application.indexLogic.loginStaff);
			// 更新ボタンの状態設定.
//			view.btnUpdate.enabled = isEdit
			// Gridテーブルの状態設定.
			view.tblWorkingHours.editable = isEdit
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

		/**
		 * データ変更状態設定.
		 *
		 */
		private function setModifiedStatus(modified:Boolean):void
		{
			// データ変更有無のセット
			Application.application.indexLogic.modified = modified;
		}

		/**
	     * 勤務管理表表示更新.
	     *
	     */
		private function refreshWorkingHours():void
		{
			// 勤務時間詳細データのクリア
			view.tblWorkingHours.clear();

			_workingYear = view.stpYear.value;
			_workingMonth = view.stpMonth.value;

			setlinkMonthEnabled();

			// 社員ID
			var staffId:int = Application.application.indexLogic.loginStaff.staffId;
			// 勤務月コード
        	var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			var workingMonthCode:String = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
			df.formatString = "YYYY年MM月";
        	view.lblWorkingMonth.text = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
			// 勤務時間(月別)の取得
	    	view.tblWorkingHours.load(staffId, workingMonthCode);
		}

	    /**
	     * データ破棄 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		private function onClose_CancelAlert(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) {
				// 勤務管理表表示更新
				refreshWorkingHours();
			} else {
				view.stpYear.value = _workingYear;
				view.stpMonth.value = _workingMonth;
			}
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:WorkingHoursEntry;

	    /**
	     * 画面を取得します
	     */
	    public function get view():WorkingHoursEntry
	    {
	        if (_view == null) {
	            _view = super.document as WorkingHoursEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:WorkingHoursEntry):void
	    {
	        _view = view;
	    }







	}
}