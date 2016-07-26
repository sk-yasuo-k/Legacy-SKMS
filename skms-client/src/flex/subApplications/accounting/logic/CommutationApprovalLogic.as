package subApplications.accounting.logic
{

	import com.googlecode.kanaxs.Kana;
	
	import components.PopUpWindow;
	
	import dto.StaffDto;
	
	import enum.CommutationActionId;
	import enum.CommutationStatusId;
	import enum.ProjectPositionId;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.TabBar;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.formatters.CurrencyFormatter;
	import mx.formatters.DateFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import subApplications.accounting.dto.CommutationDetailDto;
	import subApplications.accounting.dto.CommutationDto;
	import subApplications.accounting.dto.CommutationHistoryDto;
	import subApplications.accounting.dto.CommutationSummaryDto;
	import subApplications.accounting.web.CommutationApproval;
	import subApplications.accounting.web.CommutationEntryWithdraw;
	import subApplications.accounting.web.custom.CommutationForm;
	
	import utils.CommonIcon;
	import utils.LabelUtil;
	

	
	

	/**
	 * 通勤費承認のLogicクラスです.
	 */	
	public class CommutationApprovalLogic extends Logic
	{
		/** 通勤期間最大登録数 */
		private const MAX_ENTRY_NUM:int = 3;
		
		/** 通勤費承認  リンクボタンリスト */
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
			]);
		
		

		/** 選択されたリンクバー */
		private var _selectedLinkObject:Object;
		
		/** 選択した社員 */
		private var _selectedCommutationSummaryDto:CommutationSummaryDto;
		
		/** 通勤費詳細情報 */
		private var _commutation:CommutationDto;
		
		/** 社員ID */
		private var _staffId:int;

		/** 勤務月コード */
		private var _commutationMonthCode:String;
		
		/** 住所リスト */
		private var _addressList:ArrayCollection;
		
		/** 交通機関マスタリスト */
		private var _facilityNameList:ArrayCollection;

		/** 取り消し理由 */
		private var _cancelReason:String;
		
		/** カラーパターン */
		private var _defaultColors:Array = null;

		/** 表示中の年 */
		private var _commutationYear:int;

		/** 表示中の月 */
		private var _commutationMonth:int;

		/** ログインユーザのプロジェクト役職 */
		private var _projectPositionId:int;

		/** リンクボタンアイコン */
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
		 * コンストラクタ.
		 */
		public function CommutationApprovalLogic()
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

			// 通勤費手続き状況リストの取得
			view.srv.getOperation("getCommutationStatusList").send();
			
			setInputCtrStatus();

	    }		
		
		
//--------------------------------------
//  UI Event Handler
//--------------------------------------



		/**
		 * 	通勤費項目読込完了イベントハンドラ.
		 *
		 * @param e Event.
		 */
		public function onLoadComplete_commutationTab(e:Event):void
		{
			// リンクボタンの状態設定.
			setRpLinkListStatus();
			// コントロールの更新状態設定.
			setInputCtrStatus();
			// データ変更状態設定
			setModifiedStatus(false);
		}

		
		
		/**
		 * 	通勤費概要データグリッドクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
		public function onChange_grdCommutationStatus(e:ListEvent):void
		{
			if (Application.application.indexLogic.modified) {
					Alert.show("データが変更されましたが保存されていません。\nデータを破棄して通勤費情報を変更してもよろしいですか？",
					 "",
					  Alert.YES | Alert.NO,
					  view,
					  onClose_confirmResultCommutationStatus,
					  CommonIcon.questionIcon);
			} else {
				// 表示更新
				setCommutationStatusInfo();
			}
		}

		/**
		 * 	通勤費概要データグリッドソートイベント処理.
		 *
		 * @param e CollectionEvent.
		 */
		private function onCollectionChanged_grdCommutationStatus(e:CollectionEvent):void
		{
			// 背景色
			setColorPattern(view.grdCommutationStatus, e.currentTarget as ArrayCollection);
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
					Alert.show("データが変更されましたが保存されていません。\nデータを破棄して表示月を変更してもよろしいですか？",
					 "",
					  Alert.YES | Alert.NO,
					  view,
					  onClose_confirmResultRefresh,
					  CommonIcon.questionIcon);
			} else {
				// 表示更新
				dispCommutationStatus();
			}
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
			if (e.detail == Alert.YES) this[_selectedLinkObject.func]();
		}
		
		/**
		 * 	リンクボタン選択 承認確認.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_linkList_approval_confirm(e:Event):void
		{
			Alert.show("承認してもよろしいですか？", "" , 3 , view, onClick_linkList_confirmResult);
		}
		
	    /**
	     * リンクボタン選択 承認.
	     *
	     * @param e CloseEvent
	     */
		public function onClick_linkList_approval():void
		{

			// 登録データの生成
			var commu:CommutationDto = getCommutationBase();

			// 通勤費申請手続履歴の生成
			var cmhDto:CommutationHistoryDto = getCommutationHistoryBase();
			var registrant:StaffDto = Application.application.indexLogic.loginStaff;
			var projectPositionId:int = _projectPositionId;
			
			// 総務部長ならば
			if (registrant.isDepartmentHeadGA()) {
				// 勤務管理表手続き状態IDに「総務承認」をセット
				cmhDto.commutationStatusId = CommutationStatusId.GA_APPROVED;
				cmhDto.commutationActionId = CommutationActionId.GA_APPROVAL;
			} else {
				if(registrant.isProjectPositionPM()
					 || projectPositionId == ProjectPositionId.PM)
				{
					// 通勤費手続き状態IDに「PM承認」をセット
					cmhDto.commutationStatusId = CommutationStatusId.PM_APPROVED;
					cmhDto.commutationActionId = CommutationActionId.PM_APPROVAL;
				}
			}
			// 承認処理
			view.srv.getOperation("approvalCommutation").send(registrant,commu,cmhDto);
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
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			obj.entry		= "";
			obj.withdraw	= "承認前に戻す";
			obj.reason		= _cancelReason;

			// P.U画面を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(CommutationEntryWithdraw, view.parentApplication as DisplayObject, obj);

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
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			obj.entry		= "";
			obj.withdraw	= "提出者に差し戻す";
			obj.reason		= _cancelReason;
			
			// P.U画面を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(CommutationEntryWithdraw, view.parentApplication as DisplayObject, obj);

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onApprovalRejectPopUpClose);
		}

		/**
		 * リンクボタン選択 前月.
		 *
		 */
		public function onClick_linkPreviousMonth(e:MouseEvent):void
		{
			view.stpYear.value = _commutationYear;
			view.stpMonth.value = _commutationMonth;
					
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
			view.stpYear.value = _commutationYear;
			view.stpMonth.value = _commutationMonth;

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
		 * WorkingHoursEntryWithdraw(承認前に戻す)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onApprovalCancelPopUpClose(e:CloseEvent):void
		{
			// p.u画面登録で終了した場合.
			if(e.detail == PopUpWindow.ENTRY){
				var pop:CommutationEntryWithdraw = e.currentTarget as CommutationEntryWithdraw;
				_cancelReason = pop.reason.text;
				
				// 通勤費申請手続履歴の生成
				var cmhDto:CommutationHistoryDto = getCommutationHistoryBase();
				var registrant:StaffDto = Application.application.indexLogic.loginStaff;
				var projectPositionId:int = _projectPositionId;
				var approvalActionId:int;
				
				// 総務部長ならば
				if (registrant.isDepartmentHeadGA()) {
					// 手続き状態IDに「総務承認取り消し」をセット
					cmhDto.commutationActionId = CommutationActionId.GA_APPROVAL_CANCEL;
					approvalActionId = CommutationActionId.GA_APPROVAL;
				} else {
					// PMならば
					if(registrant.isProjectPositionPM()
						 || projectPositionId == ProjectPositionId.PM)
					{
						cmhDto.commutationActionId = CommutationActionId.PM_APPROVAL_CANCEL;
						approvalActionId = CommutationActionId.PM_APPROVAL;
					}
				}

				var cancel:Boolean = false;
				for each (var commutationHistory:CommutationHistoryDto in _commutation.commutationHistories) {
					if (commutationHistory.commutationStatusId == CommutationStatusId.GA_APPROVED
						|| commutationHistory.commutationStatusId == CommutationStatusId.PM_APPROVED
						|| commutationHistory.commutationStatusId == CommutationStatusId.APPLIED) {
						if (cancel) {
							// 勤務管理表手続き状態IDに直前の状態をセット
							cmhDto.commutationStatusId = commutationHistory.commutationStatusId;
							break;
						} else {
							if (commutationHistory.commutationActionId == approvalActionId) {
								cancel = true;
							}
						}
					}
				}

				// コメントのセット
				cmhDto.comment = _cancelReason;

				// 承認を取り消す.
				view.srv.getOperation("approvalCancelCommutation").send(registrant,_commutation,cmhDto);

			}
		}

		/**
		 * WorkingHoursEntryWithdraw(申請者に差し戻す)確認結果.
		 *
		 * @param event Closeイベント.
		 */
		private function onApprovalRejectPopUpClose(e:CloseEvent):void
		{
			// p.u画面登録で終了した場合.
			if(e.detail == PopUpWindow.ENTRY){
				var pop:CommutationEntryWithdraw = e.currentTarget as CommutationEntryWithdraw;
				_cancelReason = pop.reason.text;
				
				// 通勤費申請手続履歴の生成
				var cmhDto:CommutationHistoryDto = getCommutationHistoryBase();
				var registrant:StaffDto = Application.application.indexLogic.loginStaff;
				var projectPositionId:int = _projectPositionId;
				
				// 手続き状態IDに「差し戻し」をセット
				cmhDto.commutationStatusId = CommutationStatusId.REJECTED;
				
				// 総務部長ならば
				if (registrant.isDepartmentHeadGA()) {
					cmhDto.commutationActionId = CommutationActionId.GA_APPROVAL_REJECT;
				} else {
					// PMならば
					if(registrant.isProjectPositionPM()
						 || projectPositionId == ProjectPositionId.PM)
					{
						cmhDto.commutationActionId = CommutationActionId.PM_APPROVAL_REJECT;
					}
				}
				
				// コメントのセット
				cmhDto.comment = _cancelReason;

				// 承認を取り下げる.
				view.srv.getOperation("approvalRejectCommutation").send(registrant,_commutation,cmhDto);
			}
		}


	    /**
	     * データ破棄確認結果(再表示).
	     *
	     * @param e CloseEvent
	     */
		private function onClose_confirmResultRefresh(e:CloseEvent):void
		{
			if (e.detail == Alert.YES){
				setModifiedStatus(false);
				dispCommutationStatus();
			} else {
				view.stpYear.value = _commutationYear;
				view.stpMonth.value = _commutationMonth;
			}
		}		
		
	    /**
	     * データ破棄確認結果(社員一覧).
	     *
	     * @param e CloseEvent
	     */
		private function onClose_confirmResultCommutationStatus(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) {
				setModifiedStatus(false);
				setCommutationStatusInfo();
			}
		}
		
		/**
		 * 	払戻額フォーカスアウトイベントハンドラ.
		 *
		 * @param e Event.
		 */
		public function focusOut_Repayment(e:Event):void
		{
			// 編集不可の時は何もしない.
			if (!view.repayment.editable) return;
			// データを取得する.
			var newData:String = e.target.text;
			// 半角に変換する
			newData = Kana.toHankakuCase(newData);
			var repay:Number = Number(newData);
			if (isNaN(repay) || int(repay) != repay || StringUtil.trim(newData).length == 0) {
				e.target.text = 0;
				view.payment.text = view.expenseTotal.text;
				return;
			}
			// 変換した値を設定する.
			e.target.text = LabelUtil.currency(repay.toString());
			var total:Number = Number(LabelUtil.currencyFormatOff(view.expenseTotal.text)) - repay;
		 	view.payment.text = LabelUtil.currency(total.toString());
		}
		
		/**
		 * 	払戻額変更イベントハンドラ.
		 *
		 * @param e Event.
		 */
		public function change_Repayment(e:Event):void
		{
			// データ変更状態設定
			setModifiedStatus(true);
		}
		

		/**
		 * 	通勤費担当備考変更イベントハンドラ.
		 *
		 * @param e Event.
		 */
		public function change_NoteCharge(e:Event):void
		{
			// データ変更状態設定
			setModifiedStatus(true);
		}
		
//--------------------------------------
//  RPC Event Handler
//--------------------------------------

		/**
		 * getCommutation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getCommutation(e:ResultEvent):void
		{
			// 結果を取得する.
			_commutation = e.result as CommutationDto;
			view.grdCommutationHistory.dataProvider = _commutation.commutationHistories as ArrayCollection;
			// 通勤情報を設定する.
			setCommutationInfo();
		}

	    /**
	     * getCommutationStatusList処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getCommutationStatusList(e:ResultEvent):void
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
			// 通勤情報の取得.
	    	view.srv.getOperation("getCommutation")
	    		.send(_selectedCommutationSummaryDto.staffId,
	    		 _commutationMonthCode);
        	
        }

	    /**
	     * getSubordinateCurrentCommutationStatus処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getSubordinateCurrentCommutationStatus(e:ResultEvent):void
        {
        	view.grdCommutationStatus.dataProvider = e.result as ArrayCollection;
 			// データソート時のイベント登録
			view.grdCommutationStatus.dataProvider.addEventListener(
				CollectionEvent.COLLECTION_CHANGE, onCollectionChanged_grdCommutationStatus);
				
			setColorPattern(view.grdCommutationStatus, view.grdCommutationStatus.dataProvider as ArrayCollection);	
       	
          	var list:ArrayCollection = e.result as ArrayCollection;
        	var i:int = 0;
        	view.grdCommutationStatus.selectedIndex = -1;
        	for each(var cmh:CommutationSummaryDto in list) {
        		if (_selectedCommutationSummaryDto != null
        			&& cmh.staffId == _selectedCommutationSummaryDto.staffId) {
        				view.grdCommutationStatus.selectedIndex = i;
        				view.grdCommutationStatus.scrollToIndex(i);
        				onChange_grdCommutationStatus(null);
        				return;
        		}
        		i++;
        	}
			view.lblStaffName.text = "左で選択された社員の通勤費を表示します。";
        }
		
		/**
		 * approvalCommutation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_approvalCommutation(e:ResultEvent):void
		{
 			
			// 通勤情報の取得.
	    	view.srv.getOperation("getCommutation")
	    		.send(_selectedCommutationSummaryDto.staffId,
	    		 _commutationMonthCode);

			// 通勤費手続き状況の取得
			view.srv.getOperation("getCurrentCommutationStatus")
				.send(_selectedCommutationSummaryDto.staffId, _selectedCommutationSummaryDto.commutationMonthCode);

			var ret:Boolean = e.result as Boolean;
			if (!ret){
				Alert.show("他のユーザにより既にデータが更新されています。\承認ができません。","",Alert.OK,null);
			}
		}
		
		/**
		 * approvalCancelCommutation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_approvalCancelCommutation(e:ResultEvent):void
		{
 			// 通勤費手続き状況の取得
			view.srv.getOperation("getCurrentCommutationStatus")
				.send(_selectedCommutationSummaryDto.staffId, _selectedCommutationSummaryDto.commutationMonthCode);
			// 通勤情報の取得.
	    	view.srv.getOperation("getCommutation")
	    		.send(_selectedCommutationSummaryDto.staffId,
	    		 _commutationMonthCode);
			var ret:Boolean = e.result as Boolean;
			if (!ret){
				Alert.show("他のユーザにより既にデータが更新されています。\承認取り消しができません。","",Alert.OK,null);
			}
			
		}
		
		/**
		 * approvalRejectCommutation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_approvalRejectCommutation(e:ResultEvent):void
		{
 			// 通勤費手続き状況の取得
			view.srv.getOperation("getCurrentCommutationStatus")
				.send(_selectedCommutationSummaryDto.staffId, _selectedCommutationSummaryDto.commutationMonthCode);
			// 通勤情報の取得.
	    	view.srv.getOperation("getCommutation")
	    		.send(_selectedCommutationSummaryDto.staffId,
	    		 _commutationMonthCode);
			var ret:Boolean = e.result as Boolean;
			if (!ret){
				Alert.show("他のユーザにより既にデータが更新されています。\申請者に差し戻しができません。","",Alert.OK,null);
			}
			
		}
		
	    /**
	     * getCurrentCommutationStatus処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getCurrentCommutationStatus(e:ResultEvent):void
        {
        	// 選択中の社員の勤務管理表手続き状態を更新する。
        	var list:ArrayCollection = view.grdCommutationStatus.dataProvider as ArrayCollection;
        	var i:int = 0;

        	for each(var cmh:CommutationSummaryDto in list) {
        		if (cmh.staffId == _selectedCommutationSummaryDto.staffId) {
		        	list.setItemAt(e.result as CommutationSummaryDto, i);
		        	break;
		        }
		        i++;
        	}
			setColorPattern(view.grdCommutationStatus, list);
		}
		
		/**
		 * getStaffAddressList(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getStaffAddressList(e:ResultEvent):void
		{
			// 結果を取得する.
			_addressList  = e.result as ArrayCollection;

		}

		/**
	     * RemoteObject（通勤費情報取得）の呼び出し失敗イベントハンドラ.
		 *
		 * @param FaultEvent
		 */
		public function onFault_getCommutation(e:FaultEvent):void
		{
			Alert.show("通勤費情報の取得に失敗しました。","",Alert.OK,null);
		}

		/**
	     * RemoteObject（通勤費情報承認）の呼び出し失敗イベントハンドラ.
		 *
		 * @param FaultEvent
		 */
		public function onFault_approvalCommutation(e:FaultEvent):void
		{
			Alert.show("承認に失敗しました。","",Alert.OK,null);
		}
		
		/**
	     * RemoteObject（通勤費情報承認取り消し）の呼び出し失敗イベントハンドラ.
		 *
		 * @param FaultEvent
		 */
		public function onFault_approvalCancelCommutation(e:FaultEvent):void
		{
			Alert.show("承認取り消しに失敗しました。","",Alert.OK,null);
		}
		
		/**
	     * RemoteObject（通勤費情報承認差し戻し）の呼び出し失敗イベントハンドラ.
		 *
		 * @param FaultEvent
		 */
		public function onFault_approvalRejectCommutation(e:FaultEvent):void
		{
			Alert.show("承認差し戻しに失敗しました。","",Alert.OK,null);
		}

	    /**
	     * リモートオブジェクト実行の失敗イベント
	     *
	     * @param e FaultEvent
	     */
        public function onFault_remoteObject(e:FaultEvent):void
        {
			Alert.show("通勤費情報の取得に失敗しました。","",Alert.OK,null,null);
		}
		
		/**
	     * getStaffAddressList(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_getStaffAddressList(e:FaultEvent):void
		{
			Alert.show("社員住所情報の取得に失敗しました。","",Alert.OK,null);
		}	

		/**
	     * 金額のフォーマット.
		 *
		 * @param payment
		 */
		public function paymentLabel(data:Object, column:DataGridColumn):String
		{
			var formatter:CurrencyFormatter = new CurrencyFormatter();
			formatter.useThousandsSeparator = true;
			formatter.useNegativeSign       = true;
			return formatter.format(data[column.dataField]);
		}

//--------------------------------------
//  Function
//--------------------------------------

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
		 * 社員情報表示.
		 *
		 */
		private function dispCommutationStatus():void
		{
			// データのクリア
			_commutation = new CommutationDto();
			view.grdCommutationHistory.dataProvider = null;
			view.lblStaffName.text = "";

			_commutationYear = view.stpYear.value;
			_commutationMonth = view.stpMonth.value;

			//前月／翌月リンクボタン有効無効判定.
			setlinkMonthEnabled();

			// 勤務月コード
        	var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			_commutationMonthCode = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
			df.formatString = "YYYY年MM月";
        	view.lblCommuMonth.text = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
 	    	// 通勤費手続き状況の取得
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

	    	view.srv.getOperation("getSubordinateCurrentCommutationStatus")
	    		.send(Application.application.indexLogic.loginStaff,
	    		  _commutationMonthCode,
	    		  isSubordinateOnly,
	    		  statusItems);
		}

		/**
		 * 通勤情報設定.
		 *
		 */
		private function setCommutationInfo():void
		{
			// 通勤費情報を設定する.
	    	view.note.text 			= _commutation.note;
	    	view.noteCharge.text 	= _commutation.noteCharge;
	    	view.expenseTotal.text 	= LabelUtil.currency(_commutation.expenseTotal);
	    	view.repayment.text		= LabelUtil.currency(_commutation.repayment);
	    	view.payment.text		= LabelUtil.currency(_commutation.payment);
	    	
			// タブを一旦クリアする.
			view.tabnavi.removeAllChildren();

			// 通勤費詳細情報を設定する.
			if (_commutation.commutationDetails) {
				for (var i:int = 0; i < _commutation.commutationDetails.length; i++) {
					// 通勤費詳細情報を取得する.
					var cd:CommutationDetailDto = _commutation.commutationDetails.getItemAt(i) as CommutationDetailDto;

					// 通勤費詳細タブを設定する.
					var newtab:CommutationForm = new CommutationForm();
					newtab.addEventListener("loadComplete", onLoadComplete_commutationTab);
					newtab.displayCommuDetail(cd,_addressList,null);
					view.tabnavi.addChild(newtab);
					newtab.commuStartDate.editable = false;
					newtab.grdCommutationItem.editable = false;
				}
			}
			
			// 1枚目のタブを選択する.
			//view.tabnavi.selectedIndex = 0;
			TabBar(view.tabnavi.rawChildren.getChildByName("tabBar")).selectedIndex = 0;
		}
		
		/**
		 * 社員情報設定.
		 *
		 */
		private function setCommutationStatusInfo():void
		{
	 		// Tabをクリア
	 		view.tabnavi.removeAllChildren();
	 		// 履歴をクリア
	 		view.grdCommutationHistory.dataProvider = null;
	 		view.expenseTotal.text = ""
	 		view.repayment.text = ""
	 		view.payment.text = ""
	 		view.note.text = ""
	 		view.noteCharge.text = ""

			// 選択した社員情報を取得する.
			_selectedCommutationSummaryDto = ObjectUtil.copy(view.grdCommutationStatus.selectedItem) as CommutationSummaryDto;
			
			// 氏名の表示.
			view.lblStaffName.text = _selectedCommutationSummaryDto.fullName + "さん";
			// 年月の表示.
			var year:String = _selectedCommutationSummaryDto.commutationMonthCode.substr(0, 4);
			var month:String = _selectedCommutationSummaryDto.commutationMonthCode.substr(4, 2);
			
			// 手続き履歴の取得.
			var commutationStatusId:int = _selectedCommutationSummaryDto.commutationStatusId;
			// 通勤費を作成済みならば
			if (commutationStatusId != CommutationStatusId.NONE) {
				// 社員ID
				var staffId:int = _selectedCommutationSummaryDto.staffId;
				// 社員住所を取得する.
				view.srv.getOperation("getStaffAddressList").send(staffId);
				// ログインユーザのプロジェクト役職の取得
			    view.srv.getOperation("getStaffProjectPositionId")
	    			.send(Application.application.indexLogic.loginStaff.staffId, staffId, _commutationMonthCode);
		 	}else{
				// 通勤情報の取得.
		    	view.srv.getOperation("getCommutation").send(staffId, _commutationMonthCode);
		 	}
		
		}
		
		/**
		 * 通勤費手続き履歴の基本データ作成.
		 *
		 */
		private function getCommutationBase():CommutationDto
		{
			// 登録データを作成する.
			var commu:CommutationDto = _commutation;
			commu.repayment = view.repayment.text.length > 0 ? LabelUtil.currencyFormatOff(view.repayment.text) : "0";
			commu.payment = view.payment.text.length > 0 ? LabelUtil.currencyFormatOff(view.payment.text) : "0";
			commu.noteCharge = view.noteCharge.text.length > 0 ? view.noteCharge.text : null;
			return commu;
		}	
		
		/**
		 * 通勤費手続き履歴の基本データ作成.
		 * 
		 */
		private function getCommutationHistoryBase():CommutationHistoryDto
		{
			// 通勤費申請手続履歴の生成
			var cmhDto:CommutationHistoryDto = new CommutationHistoryDto();
			var registrant:StaffDto = Application.application.indexLogic.loginStaff;
			
			// 社員IDのセット
			cmhDto.staffId = _commutation.staffId;
			// 勤務月のセット
			cmhDto.commutationMonthCode = _commutation.commutationMonthCode;
			//cmhDto登録者IDのセット
			cmhDto.registrantId = registrant.staffId;
			// 登録者氏名のセット
			cmhDto.registrantName = registrant.staffName.fullName;
			// 更新回数のセット
			cmhDto.updateCount =
				_commutation.commutationHistories != null
					&& _commutation.commutationHistories.length > 0 ?
						_commutation.commutationHistories.getItemAt(0).updateCount + 1 : 1;
			
			
			return cmhDto;
		}

		/**
	     * 行の背景色用カラーパターンを生成.
	     *
	     * @param dg	データグリッド.
	     * @param data	データプロバイダ.
	     */
		private function setColorPattern(dg:DataGrid, data:ArrayCollection):void
		{
			
		}

		/**
	     * 入力コントロール状態設定.
	     *
	     */
		private function setInputCtrStatus():void
		{
			var registrant:StaffDto = Application.application.indexLogic.loginStaff;
			var isEdit:Boolean = false;
			
			// 総務部長ならば
			if (registrant.isDepartmentHeadGA()) {
				if(_selectedCommutationSummaryDto){
					var commutationStatusId:int = _selectedCommutationSummaryDto.commutationStatusId;
					// 未作成または総務承認済みならば編集不可
					if (commutationStatusId == CommutationStatusId.NONE ||
						 commutationStatusId == CommutationStatusId.GA_APPROVED	) {
							isEdit = false;
					}
					else{
						isEdit = true;
					}				
				}
			}
			// 総務備考欄
			view.noteCharge.editable = isEdit;
			
			// 以下のコントロールはいつも編集不可にする.
			// 払い戻し額
			view.repayment.editable = false;
			// 備考欄
			view.note.editable = false;
			// タブ.
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				var commutab:CommutationForm = view.tabnavi.getChildAt(index) as CommutationForm;
				if (!commutab) continue;
				// タブ内のコントロールの操作制御を行う.
				commutab.commutationFormLogic.setInputCtrStatus(false);
			}
		}

		/**
	     * 通勤費  リンクボタン状態設定.
	     *
	     * @return リンクボタンリスト.
	     */
		private function setRpLinkListStatus():void
		{
			// リンクボタンの数分繰り返し.
			for(var i:int = 0; i < view.rpLinkList.dataProvider.length; i++) {
				// リンクボタンオブジェクトの取得.
				var linkObject:Object = view.rpLinkList.dataProvider.getItemAt(i);
				// 可否チェック用プロパティが定義されていたら
				if (linkObject.hasOwnProperty("enabledCheck")) {
					// 可否チェック
					linkObject.enabled = this[linkObject.enabledCheck]();
					// リンクボタンの表示にも反映させる.
					view.linkList[i].enabled = linkObject.enabled;
				}
			}
		}

		/**
		 * 承認可否判定.
		 *
		 * @return value Boolean	承認可否
		 */
		public function enabledApproval():Boolean
		{
			// 通勤費情報、手続き履歴が存在しないならば申請取り下げ不可能.
			if (!_commutation || !_commutation.commutationHistories) return false;
			var commutationStatusId:int
				= _commutation.commutationHistories.getItemAt(0).commutationStatusId;
			var registrant:StaffDto = Application.application.indexLogic.loginStaff;
			var projectPositionId:int = _projectPositionId;
			

			// 総務部長ならば
			if (registrant.isDepartmentHeadGA()) {
				// 申請済みまたはTN/SL/PL/PM承認済みならば承認可能
				if (commutationStatusId == CommutationStatusId.APPLIED
					|| commutationStatusId == CommutationStatusId.PM_APPROVED) {
					return true;
				}
			} else {
				if (!projectPositionId) {
					// PMならば
					if (registrant.isProjectPositionPM()) {
						projectPositionId = ProjectPositionId.PM;
					}
				}
				
				switch (projectPositionId) {
					case ProjectPositionId.PM:	// PM
						// 申請済みならば承認可能
						if (commutationStatusId == CommutationStatusId.APPLIED) {
							return true;
						}
						break;
				}
			}
			return false;

		}

		/**
		 * 承認取り消し可否判定.
		 * 
		 * @return value Boolean	承認取り消し可否
		 */
		public function enabledApprovalCancel():Boolean
		{
			// 通勤費情報、手続き履歴が存在しないならば申請取り下げ不可能.
			if (!_commutation || !_commutation.commutationHistories) return false;
			var commutationStatusId:int
				= _commutation.commutationHistories.getItemAt(0).commutationStatusId;
			var registrant:StaffDto = Application.application.indexLogic.loginStaff;
			var projectPositionId:int = _projectPositionId;

			// 総務部長ならば
			if (registrant.isDepartmentHeadGA()) {
				// 総務承認済みならば承認取り消し可能
				if (commutationStatusId == CommutationStatusId.GA_APPROVED) {
					return true;
				}
			} else {
			
				if (!_projectPositionId) {
					// PMならば
					if (registrant.isProjectPositionPM()) {
						projectPositionId = ProjectPositionId.PM;
					}
				}
				
				switch (projectPositionId) {
					case ProjectPositionId.PM:	// PM
						// PM承認済みならば承認取り消し可能
						if (commutationStatusId == CommutationStatusId.PM_APPROVED) {
							return true;
						}
						break;
				}
			}
			return false;			
		}

		/**
		 * 却下(差し戻し)可否判定.
		 *
		 * @return value Boolean	却下(差し戻し)可否
		 */
		public function enabledApprovalReject():Boolean
		{
			// 承認可否判定と同じ
			return enabledApproval();
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
		 * 日時フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public function dateTimeLabel(data:Object, column:DataGridColumn):String
		{
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYY/MM/DD JJ:NN";
			// データを取得する.
			var date:Date = data[column.dataField] as Date;
			if (!date)	return "";

			// フォーマット変換する.
			var retStr:String = df.format(date);
			if (retStr == "")  {
				// エラーのときエラー内容を返す.
				retStr = df.error + "(" + date + ")";
			}
	        return retStr;
	    }

		/**
		 * コメントフォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public function commentLabel(data:Object, column:DataGridColumn):String
		{
			// データを取得する.
			var cmh:CommutationHistoryDto = data as CommutationHistoryDto;
			var comment:String = cmh.commutationAction != null ? 
				cmh.commutationAction.commutationActionName : "";
				
			switch (cmh.commutationActionId) {
				case CommutationActionId.APPLY_CANCEL:			// 申請取り消し
					comment += ":" + cmh.comment;
					break;
				case CommutationActionId.PM_APPROVAL:			// PM承認
				case CommutationActionId.GA_APPROVAL:			// 総務承認
					comment += "(" + cmh.registrantName + ")";
					break
				case CommutationActionId.PM_APPROVAL_CANCEL:	// PM承認取り消し
				case CommutationActionId.PM_APPROVAL_REJECT:	// PM差し戻し
				case CommutationActionId.GA_APPROVAL_CANCEL:	// 総務承認取り消し
				case CommutationActionId.GA_APPROVAL_REJECT:	// 総務差し戻し
					comment += "(" + cmh.registrantName + "):" + cmh.comment;
					break;
			}
			return comment;
		}		
		
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CommutationApproval;
	    
	    /**
	     * 画面を取得します
	     */     
	    public function get view():CommutationApproval
	    {
	        if (_view == null) {
	            _view = super.document as CommutationApproval;
	        }
	        return _view;
	    }
	    
	    /**
	     * 画面をセットします。
	     * 
	     * @param view セットする画面
	     */
	    public function set view(view:CommutationApproval):void
	    {
	        _view = view;
	    }

		
		
		
		
		
		
		
		

	}
}