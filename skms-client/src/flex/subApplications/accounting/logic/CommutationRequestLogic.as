package subApplications.accounting.logic
{
	import com.googlecode.kanaxs.Kana;
	
	import components.PopUpWindow;
	
	import dto.StaffDto;
	
	import enum.CommutationActionId;
	import enum.CommutationStatusId;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	//追加 @auther watanuki
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.TabBar;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import subApplications.accounting.dto.CommutationDetailDto;
	import subApplications.accounting.dto.CommutationDto;
	import subApplications.accounting.dto.CommutationHistoryDto;
	import subApplications.accounting.web.CommutationCopySelectedMonth;
	import subApplications.accounting.web.CommutationEntryWithdraw;
	import subApplications.accounting.web.CommutationRequest;
	import subApplications.accounting.web.custom.CommutationForm;
	
	import utils.CommonIcon;
	import utils.LabelUtil;

	

	/**
	 * 通勤費申請のLogicクラスです.
	 */
	public class CommutationRequestLogic extends Logic
	{
		/** 通勤期間最大登録数 */
		private const MAX_ENTRY_NUM:int = 3;
		/**  最大タブ数 */
		private const MAX_TAB_NUM:int   = 3;

		
		/** 通勤費申請  リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
			= new ArrayCollection([
				{label:"通勤期間の追加",
						func:"onClick_linkList_add",
						enabled:false,
						enabledCheck:"enabledAdd"},
				{label:"通勤期間の削除",
						func:"onClick_linkList_delete",
						prepare:"onClick_linkList_delete_confirm",
						enabled:false,
						enabledCheck:"enabledDelete"},				
				{label:"保存",
						func:"onClick_linkList_entry",
						prepare:"onClick_linkList_entry_confirm",
						enabled:false,
						enabledCheck:"enabledEntry"},				
				{label:"申請",
						func:"onClick_linkList_apply",
						prepare:"onClick_linkList_apply_confirm",
						enabled:false,
						enabledCheck:"enabledApply"},				
				{label:"申請取り消し",
						func:"onClick_linkList_applyCancel",
						enabled:false,
						enabledCheck:"enabledApplyCancel"},				
				{label:"前月の通勤費を複製",
						func:"onClick_linkList_copy",
						prepare:"onClick_linkList_copy_confirm",
						enabled:false,
						enabledCheck:"enabledCopy"},				
				{label:"指定月の通勤費を複製",
						func:"onClick_linkList_copy_selMonth",
						enabled:false,
						enabledCheck:"enabledCopy"},
				//追加 @auther watanuki
				{label:"乗り換え案内",
						func:"onClick_linkList_transfer",
						enabled:true,
						enabledCheack:false}				
			]);
			

		
		/** 表示中の年 */
		private var _commutationYear:int;

		/** 表示中の月 */
		private var _commutationMonth:int;

		/** 選択されたリンクバー */
		private var _selectedLinkObject:Object;

		/** リンクボタンアイコン */
        [Embed(source="images/arrow_previous.gif")]
        private var _icon_previous:Class;
		
        [Embed(source="images/arrow_previous_d.gif")]
        private var _icon_previous_d:Class;

        [Embed(source="images/arrow_next.gif")]
        private var _icon_next:Class;

        [Embed(source="images/arrow_next_d.gif")]
        private var _icon_next_d:Class;
		
		/** 社員ID */
		private var _staffId:int;

		/** 勤務月コード */
		private var _commutationMonthCode:String;

		/** 通勤費詳細情報 */
		private var _commutation:CommutationDto;
		
		/** 住所リスト */
		private var _addressList:ArrayCollection;
		
		/** 交通機関マスタリスト */
		private var _facilityNameList:ArrayCollection;

		/** 取り消し理由 */
		private var _cancelReason:String;


//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function CommutationRequestLogic()
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
	    	view.stpMonth.value = now.getMonth() + 2;
	    	onClick_linkHideDateSetting(null);

 	    	// 社員ID.
			_staffId = Application.application.indexLogic.loginStaff.staffId;
			// 交通機関リストを取得する.
			view.srv2.getOperation("getFacilityNameList").send(Application.application.indexLogic.loginStaff);
			// 社員住所を取得する.
			view.srv.getOperation("getStaffAddressList").send(_staffId);
			// 表示処理
	    	onClick_btnRefresh(null);
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
			// データ変更ありならば
			if (Application.application.indexLogic.modified) {
					Alert.show("当月のデータが変更されましたが保存されていません。\nデータを破棄して表示月を変更してもよろしいですか？",
					 "",
					  Alert.YES | Alert.NO,
					   view,
					    onClose_confirmResultRefresh,
					    CommonIcon.questionIcon);
			} else {
				// 通勤費表表示更新
				refreshCommutation();
			}
		}

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
	     * リンクボタン選択 確認結果.
	     *
	     * @param e CloseEvent
	     */
		public function onClick_linkList_confirmResult(e:CloseEvent):void
		{
			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.YES) this[_selectedLinkObject.func]();
		}

		/**
		 * リンクボタン選択 通勤期間追加.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList_add():void
		{
			// 現在のタブ数を取得する.
			var tabnum:int = view.tabnavi.numChildren;
			// 通勤費タブを作成する.
			var commuForm:CommutationForm = new CommutationForm();
			var cd:CommutationDetailDto = new CommutationDetailDto();
			// 通勤費詳細情報をセットする.
			cd.staffId = _staffId;
			cd.commutationMonthCode = _commutationMonthCode;
			cd.detailNo = tabnum;
			cd.commutationStartDate = new Date(view.stpYear.value, view.stpMonth.value-1, 1);
			commuForm.displayCommuDetail(cd,_addressList,_facilityNameList);
			// イベント作成.
			commuForm.addEventListener("loadComplete", onLoadComplete_commutationTab);
			commuForm.addEventListener("changeExpense", onChangeExpense_commutationTab);
			commuForm.addEventListener("changeInputData", onChangeInputData_commutationTab);

			// タブを追加する.
			view.tabnavi.addChild(commuForm);
			// 追加したタブを選択する.
			view.tabnavi.selectedChild = commuForm;
			// リンクボタンの状態設定.
			setRpLinkListStatus();
			// データ変更状態設定
			setModifiedStatus(true);
		}

		/**
		 * リンクボタン選択 通勤期間削除確認.
		 *
		 * @param e Event
		 */
		public function onClick_linkList_delete_confirm(e:Event):void
		{
			Alert.show("選択された通勤情報を削除してもよろしいですか？", "", 3, view, onClick_linkList_confirmResult);
		}
		
		/**
		 * リンクボタン選択 通勤期間削除.
		 *
		 */
		public function onClick_linkList_delete():void
		{
			var item:Container = view.tabnavi.selectedChild;
			if (item is CommutationForm) {
				// 通勤費タブを削除し、1枚目のタブを選択する.
				var commutab:CommutationForm = item as CommutationForm;
				view.tabnavi.removeChild(commutab);
			}
			onChangeExpense_commutationTab(null);
			view.tabnavi.selectedIndex = 0;
			// リンクボタンの状態設定.
			setRpLinkListStatus();
			// データ変更状態設定
			setModifiedStatus(true);
		}
		
		/**
		 * 	リンクボタン選択 保存確認.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_linkList_entry_confirm(e:Event):void
		{
			var ret:String = checkEntryApplyVal(CommutationActionId.ENTER);
			if(ret!=null){
				Alert.show(ret);
			}
			else{
				Alert.show("保存してもよろしいですか？", "" , 3 , view, onClick_linkList_confirmResult);
			}
		}
				
		/**
		 * 	リンクボタン選択 申請確認.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_linkList_apply_confirm(e:Event):void
		{
			var ret:String = checkEntryApplyVal(CommutationActionId.APPLY);
			if(ret!=null){
				Alert.show(ret);
			}
			else{
				Alert.show("申請してもよろしいですか？", "" , 3 , view, onClick_linkList_confirmResult);
			}
		}
		
		/**
		 * 	リンクボタン選択 複製確認.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_linkList_copy_confirm(e:Event):void
		{
			Alert.show("当月のデータを破棄して前月の通勤費を複製してもよろしいですか？", "" , 3 , view, onClick_linkList_confirmResult);
		}
		
		/**
		 * リンクボタン選択 申請取り消し.
		 * @param initReason	理由初期化.
		 *
		 */
		public function onClick_linkList_applyCancel(initReason:Boolean = true):void
		{
			// 理由を初期化する.
			if (initReason) _cancelReason = null;

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			obj.entry		= "申請";
			obj.withdraw	= "取り消し";
			obj.reason		= _cancelReason;

			// P.U画面を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(CommutationEntryWithdraw, view.parentApplication as DisplayObject, obj);

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onApplyCancelPopUpClose);
			
		}
		
	    /**
	     * リンクボタン選択 保存.
	     *
	     * @param e CloseEvent
	     */
		public function onClick_linkList_entry():void
		{
			// 登録データの生成
			var commu:CommutationDto = getCommutationBase();
			// 保存処理
			view.srv.getOperation("updateCommutation").send(commu);
		}
		
	    /**
	     * リンクボタン選択 申請.
	     *
	     * @param e CloseEvent
	     */
		public function onClick_linkList_apply():void
		{
			// 登録データの生成
			var commu:CommutationDto = getCommutationBase();
			// 通勤費手続履歴の生成
			var cmhDto:CommutationHistoryDto = getCommutationHistoryBase();
			// 通勤費手続き状態IDに「申請」をセット
			cmhDto.commutationStatusId = CommutationStatusId.APPLIED;
			cmhDto.commutationActionId = CommutationActionId.APPLY;
			// 通勤費データの更新
	    	view.srv.getOperation("applyCommutation").send(commu,cmhDto);
		}
		
		/**
		 * リンクボタン選択 複製.
		 * @param e CloseEvent
		 *
		 */
		public function onClick_linkList_copy():void
		{
			// データのクリア.
			_commutation = new CommutationDto();
			view.grdCommutationHistory.dataProvider = null;
			
			var lastCommutationMonthCode:String;
			var lastCommutationYear:int;
			var lastCommutationMonth:int;
			lastCommutationYear = _commutationYear;
			lastCommutationMonth = _commutationMonth;
			if (lastCommutationMonth == 1) {
				lastCommutationYear--;
				lastCommutationMonth = 12;
			} else {
				lastCommutationMonth--;
			}
			// 前月の勤務月の作成.
     		var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			lastCommutationMonthCode = df.format(new Date(lastCommutationYear, lastCommutationMonth - 1, 1));
			// 複製通勤情報の取得.
	    	view.srv.getOperation("getCommutationCopy").send(_staffId, _commutationMonthCode,lastCommutationMonthCode);
		}

		/**
		 * リンクボタン選択 指定月の複製.
		 * @param e CloseEvent
		 *
		 */
		public function onClick_linkList_copy_selMonth():void
		{
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(CommutationCopySelectedMonth, view);
			pop.addEventListener(CloseEvent.CLOSE, onClose_selectMonth);
		}
		
		/**
		 * CommutationCopySelectedMonthのClose処理.
		 *
	     * @param e PopupManagerのCloseイベント.
		 */
		protected function onClose_selectMonth(e:CloseEvent):void
		{
			// CommutationCopySelectedMonthの複製ボタンを押下したとき.
			if (e.detail == PopUpWindow.ENTRY) {
				var pop:CommutationCopySelectedMonth = e.currentTarget as CommutationCopySelectedMonth;

				// データのクリア.
				_commutation = new CommutationDto();
				view.grdCommutationHistory.dataProvider = null;
			
				var selectedYear:int = pop.stpYear.value;
				var selectedMonth:int = pop.stpMonth.value;
				
				// 指定月の勤務月の作成.
    	 		var df:DateFormatter = new DateFormatter();
        		df.formatString = "YYYYMM";
				var selectedYearMonth:String = df.format(new Date(selectedYear, selectedMonth - 1, 1));
				
				// 複製通勤情報の取得.
	    		view.srv.getOperation("getCommutationCopy").send(_staffId, _commutationMonthCode, selectedYearMonth);

			}
		}
		
		//追加 @auther watanuki
		/**
		 * リンクボタン選択 乗り換え案内
		 * 
		 * */
		public function onClick_linkList_transfer():void
		{
			//乗り換え案内ページのリンクを開く
			//var u:URLRequest = new URLRequest("http://transit.loco.yahoo.co.jp/");
			var u:URLRequest = new URLRequest("https://transit.ekitan.com/?search_type=pass");
			navigateToURL(u,"_blank");
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
			// データ変更状態設定.
			setModifiedStatus(true);
		}

		/**
		 * 	備考変更イベントハンドラ.
		 *
		 * @param e Event.
		 */
		public function change_Note(e:Event):void
		{
			// データ変更状態設定.
			setModifiedStatus(true);
		}

		/**
		 * 	通勤費詳細入力データ変更処理.
		 *
		 * @param e Event.
		 */
		public function onChangeInputData_commutationTab(e:Event):void
		{
			// リンクボタンの状態設定.
			setRpLinkListStatus();
			// データ変更状態設定.
			setModifiedStatus(true);
		}

		/**
		 * 	通勤費項目金額データ変更処理.
		 *
		 * @param e Event.
		 */
		public function onChangeExpense_commutationTab(e:Event):void
		{
			var exTotal:int = 0;
			for each (var obj:Object in view.tabnavi.getChildren()) {
				var grdTotal:Number = Number(LabelUtil.currencyFormatOff(obj.commuItemsTotal.text));
				if (isNaN(grdTotal) == false
						&& int(grdTotal) == grdTotal){
					exTotal += parseInt(grdTotal.toString());
				} 
			}
			// 合計金額の表示.
			view.expenseTotal.text = LabelUtil.currency(exTotal.toString());
			
			// 差引支給額の表示.
			var repayCrrOff:String = LabelUtil.currencyFormatOff(view.repayment.text);
			var repay:Number = Number(repayCrrOff);
			if (isNaN(repay) || int(repay) != repay || StringUtil.trim(repayCrrOff).length == 0) repay = 0;
			view.payment.text = LabelUtil.currency((exTotal - repay).toString());
		}

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
			
			// データ変更状態設定
			setModifiedStatus(false);
			
		}
		
		/**
		 * getCommutationCopy(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getCommutationCopy(e:ResultEvent):void
		{
			// 結果を取得する.
			_commutation = e.result as CommutationDto;
			view.grdCommutationHistory.dataProvider = _commutation.commutationHistories as ArrayCollection;

			// 通勤情報を設定する.
			setCommutationInfo();

			// データ変更状態設定
			setModifiedStatus(true);
		}

	    /**
	     * insertCommutation(RemoteObject)の結果受信.
	     * 
	     * @param e ResultEvent
	     */
        public function onResult_insertCommutation(e:ResultEvent):void
        {
			// 登録データの生成
			var commu:CommutationDto = getCommutationBase();
			// 通勤費履歴データの挿入
			view.srv.getOperation("insertCommutationHistory").send(commu,null);
		}

		/**
		 * updateCommutation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_updateCommutation(e:ResultEvent):void
		{
			// 最新通勤費データの取得
			view.srv.getOperation("getCommutation").send(_staffId, _commutationMonthCode);
		}

		/**
		 * applyCommutation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_applyCommutation(e:ResultEvent):void
		{
			// 最新通勤費データの取得
			view.srv.getOperation("getCommutation").send(_staffId, _commutationMonthCode);
			var ret:Boolean = e.result as Boolean;
			if (!ret){
				Alert.show("他のユーザにより既にデータが更新されています。\n申請ができません。","",Alert.OK,null);
			}
		}
		
		/**
		 * applyCancelCommutation(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_applyCancelCommutation(e:ResultEvent):void
		{
			// 最新通勤費データの取得
			view.srv.getOperation("getCommutation").send(_staffId, _commutationMonthCode);
			var ret:Boolean = e.result as Boolean;
			if (!ret){
				Alert.show("他のユーザにより既にデータが更新されています。\n申請取り消しができません。","",Alert.OK,null);
			}
		}

		/**
		 * getFacilityNameList(RemoteObject)の結果受信.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getFacilityNameList(e:ResultEvent):void
		{
			// 結果を取得する.
			_facilityNameList  = ObjectUtil.copy(e.result as ArrayCollection) as ArrayCollection;
			_facilityNameList .addItemAt({data:-1, label:""}, 0);
			_facilityNameList .addItem({data:-1, label:"自転車"});
			_facilityNameList .addItem({data:-1, label:"徒歩"});
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
			//RPC失敗
			Alert.show("通勤費情報の取得に失敗しました。","",Alert.OK,null);
		}

		/**
	     * RemoteObject（複製通勤費情報取得）の呼び出し失敗イベントハンドラ.
		 *
		 * @param FaultEvent
		 */
		public function onFault_getCommutationCopy(e:FaultEvent):void
		{
			//RPC失敗
			Alert.show("通勤費情報の複製に失敗しました。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（通勤費情報挿入）の呼び出し失敗イベントハンドラ.
		 *
		 * @param e ResultEvent
		 */
		public function onFault_insertCommutation(e:FaultEvent):void
		{
			Alert.show("更新に失敗しました。","",Alert.OK,null);
		}		

		/**
		 * RemoteObject（通勤費情報更新）の呼び出し失敗イベントハンドラ.
		 *
		 * @param e ResultEvent
		 */
		public function onFault_updateCommutation(e:FaultEvent):void
		{
			// TODO:tomcat起動後最初の1回目に何故かエラーとなるのでとりあえずリカバリ処理
			var commu:CommutationDto = getCommutationBase();
			view.srv.getOperation("insertCommutation").send(commu);
		}

		/**
		 * RemoteObject（通勤費情報申請）の呼び出し失敗イベントハンドラ.
		 *
		 * @param e ResultEvent
		 */
		public function onFault_applyCommutation(e:FaultEvent):void
		{
			Alert.show("申請に失敗しました。","",Alert.OK,null);
		}

		/**
		 * RemoteObject（申請取り消し）の呼び出し失敗イベントハンドラ.
		 *
		 */
		public function onFault_applyCancelCommutation(e:Event):void
		{
			Alert.show("申請取り消しに失敗しました。","",Alert.OK,null,faulApplyCancelCloseHandler);
		}

		/**
	     * getFacilityNameList(RemoteObject)の呼び出し失敗.
		 *
		 * @param FaultEvent
		 */
		public function onFault_getFacilityNameList(e:FaultEvent):void
		{
			Alert.show("交通費マスタの取得に失敗しました。","",Alert.OK,null);
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
		 * CommutationEntryWithdraw(申請取り消し)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onApplyCancelPopUpClose(e:CloseEvent):void
		{			
			// p.u画面登録で終了した場合.
			if(e.detail == PopUpWindow.ENTRY){
				var pop:CommutationEntryWithdraw = e.currentTarget as CommutationEntryWithdraw;
				_cancelReason = pop.reason.text;
				
				// 申請取り下げを行なう.
				// 登録データの生成
				var commu:CommutationDto = getCommutationBase();
				// 通勤費手続履歴の生成
				var cmhDto:CommutationHistoryDto = getCommutationHistoryBase();
				// 通勤費手続き状態IDに「作成」をセット
				cmhDto.commutationStatusId = CommutationStatusId.ENTERED;
				// 通勤費手続き動作IDに「申請取り消し」をセット
				cmhDto.commutationActionId = CommutationActionId.APPLY_CANCEL;
				// コメントのセット
				cmhDto.comment = _cancelReason;
				// 通勤費データの更新
				view.srv.getOperation("applyCancelCommutation").send(_commutation,cmhDto);
			}
		}

		/**
		 * アラート（申請取り消し）クローズに関連付けされたイベントハンドラ.
		 *
		 * @param event Closeイベント.
		 */
		private function faulApplyCancelCloseHandler(e:CloseEvent):void
		{
			// P.U再表示する.
			onClick_linkList_applyCancel(false);
		}

	    /**
	     * データ破棄確認結果(再表示).
	     *
	     * @param e CloseEvent
	     */
		private function onClose_confirmResultRefresh(e:CloseEvent):void
		{
			if (e.detail == Alert.YES){
				// 通勤費表示更新.
				refreshCommutation();
			} else {
				view.stpYear.value = _commutationYear;
				view.stpMonth.value = _commutationMonth;
			}
		}		

//--------------------------------------
//  Function
//--------------------------------------

		/**
	     * 通勤費表示更新.
	     *
	     */
		private function refreshCommutation():void
		{
			// データのクリア.
			_commutation = new CommutationDto();
			view.grdCommutationHistory.dataProvider = null;

			//前月／翌月リンクボタン有効無効判定.
			setlinkMonthEnabled();

			// パラメータ勤務月の作成.
     		var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			_commutationMonthCode = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
			df.formatString = "YYYY年MM月";
        	view.lblCommuMonth.text = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
			_commutationYear = view.stpYear.value;
			_commutationMonth = view.stpMonth.value;
			
			// 通勤情報の取得.
	    	view.srv.getOperation("getCommutation").send(_staffId, _commutationMonthCode);
		}

		/**
		 * 通勤情報設定.
		 *
		 */
		private function setCommutationInfo():void
		{
			// データ取得中かどうか確認する.
			var cursorID:int = CursorManager.getInstance().currentCursorID;
			if (ObjectUtil.compare(cursorID, CursorManager.NO_CURSOR) != 0) {
				return;
			}

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
					newtab.addEventListener("changeExpense", onChangeExpense_commutationTab);
					newtab.addEventListener("changeInputData", onChangeInputData_commutationTab);
					newtab.displayCommuDetail(cd,_addressList,_facilityNameList);
					view.tabnavi.addChild(newtab);
				}
			}
			
			// 1枚目のタブを選択する.
			//view.tabnavi.selectedIndex = 0;
			TabBar(view.tabnavi.rawChildren.getChildByName("tabBar")).selectedIndex = 0;
		}


		/**
		 * 通勤費手続き履歴の基本データ作成.
		 *
		 */
		private function getCommutationBase():CommutationDto
		{
			// 登録データを作成する.
			var commu:CommutationDto = _commutation;
			commu.expenseTotal = view.expenseTotal.text.length > 0 ? LabelUtil.currencyFormatOff(view.expenseTotal.text) : "0";
			commu.repayment = view.repayment.text.length > 0 ? LabelUtil.currencyFormatOff(view.repayment.text) : "0";
			commu.payment = view.payment.text.length > 0 ? LabelUtil.currencyFormatOff(view.payment.text) : "0";
			commu.note = view.note.text.length > 0 ? view.note.text : null;
			commu.noteCharge = view.noteCharge.text.length > 0 ? view.noteCharge.text : null;
			// 通勤費詳細情報を設定する.
			commu.commutationDetails = new ArrayCollection();
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				// タブを取得する.
				var commutab:CommutationForm = view.tabnavi.getChildAt(index) as CommutationForm;
				if (!commutab) continue;
				
				// 通勤費詳細情報を取得する.
				var cd:Object = commutab.createCommuDetail();
				commu.commutationDetails.addItem(cd);
			}
			
			// 登録者のセット
			_commutation.registrantId = _staffId;
			return commu;				
		}		

		/**
		 * 通勤費手続き履歴の基本データ作成.
		 *
		 */
		private function getCommutationHistoryBase():CommutationHistoryDto
		{
			// 通勤費手続履歴の生成
			var cmhDto:CommutationHistoryDto = new CommutationHistoryDto();
			var registrant:StaffDto = Application.application.indexLogic.loginStaff;
			
			// 社員IDのセット
			cmhDto.staffId = _commutation.staffId;
			// 勤務月のセット
			cmhDto.commutationMonthCode = _commutation.commutationMonthCode;
			// 登録者IDのセット
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
		 * データ変更状態設定.
		 *
		 */
		private function setModifiedStatus(modified:Boolean):void
		{
			// データ変更有無のセット
			Application.application.indexLogic.modified = modified;
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
	     * 入力コントロール状態設定.
	     *
	     */
		private function setInputCtrStatus():void
		{
			// 登録可否チェックを行う.
			var isEdit:Boolean;
			isEdit = this.enabledEntry();
			// 入力コントロールの操作制御を行う.
			view.repayment.editable = isEdit;
			view.note.editable = isEdit;
			// 通勤費担当の備考はいつも操作不可.
			view.noteCharge.editable = false;
			
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				// タブを取得する.
				var commutab:CommutationForm = view.tabnavi.getChildAt(index) as CommutationForm;
				if (!commutab) continue;
				// タブ内のコントロールの操作制御を行う.
				commutab.commutationFormLogic.setInputCtrStatus(isEdit);
			}
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
		 * 追加可否判定.
		 *
		 * @return value Boolean	登録可否
		 */
		private function enabledAdd():Boolean
		{
			// 現在のタブ数を取得する.
			var tabnum:int = view.tabnavi.numChildren;
			// 最大登録タブ数を超える場合は追加不可.
			if (tabnum >= MAX_TAB_NUM) return false;
			// 登録可否のステータス判定と同じ.
			return enabledEntryStatus();
		}

		/**
		 * 削除可否判定.
		 *
		 * @return value Boolean	削除可否
		 */
		private function enabledDelete():Boolean
		{
			// 現在のタブ数を取得する.
			var tabnum:int = view.tabnavi.numChildren;
			// タブ数が1枚の場合は削除不可.
			if (tabnum == 1) return false;
			// 登録可否のステータス判定と同じ.
			return enabledEntryStatus();
		}
    
		/**
		 * 登録可否判定.
		 *
		 * @return value Boolean	登録可否
		 */
		private function enabledEntry():Boolean
		{
			// 通勤開始日が空白の場合は保存不可能.
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				// タブを取得する.
				var commutab:CommutationForm = view.tabnavi.getChildAt(index) as CommutationForm;
				if (!commutab) continue;
				if (!commutab.commutationFormLogic.isEntry) return false;
			}
			
			// ステータスをチェックする.
			if(enabledEntryStatus()) return true;

			return false;
		}
		
		/**
		 * 登録可否判定(ステータス).
		 *
		 * @return value Boolean	登録可否
		 */
		private function enabledEntryStatus():Boolean{
			
			// 手続き履歴が存在しない場合.
			if (_commutation.commutationHistories == null
				|| _commutation.commutationHistories.length == 0) {
					
				// 当月より２カ月先ならば登録不可.
				var baseDate:Date = new Date();
				baseDate.dateUTC = 1;
				baseDate.monthUTC = baseDate.monthUTC + 2;
				var targetDate:Date = new Date(_commutationYear,_commutationMonth,1,0,0,0,0);
				if(targetDate > baseDate) return false;
				return true;
			}
			
			// 作成.差し戻し状態ならば登録可能.
			var statusId:int = _commutation.commutationHistories.getItemAt(0).commutationStatusId;
			if (statusId == CommutationStatusId.ENTERED ||
				statusId == CommutationStatusId.REJECTED) {
				return true;
			}
			return false;
		}
		
	    
		/**
		 * 申請可否判定.
		 *
		 * @return value Boolean	申請可否
		 */
		private function enabledApply():Boolean
		{
			if (!_commutation) return false;

			// 手続き履歴が存在しないならば申請不可能(入力エラーの先にする).
			if (_commutation.commutationHistories == null
				|| _commutation.commutationHistories.length == 0) {
				return false;
			}
			
			// 入力エラーがある場合は申請不可能.
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				// タブを取得する.
				var commutab:CommutationForm = view.tabnavi.getChildAt(index) as CommutationForm;
				if (!commutab) continue;
				
				if (!commutab.commutationFormLogic.isApply) return false;
			}

			// 作成.差し戻し状態ならば申請可能.
			var statusId:int = _commutation.commutationHistories.getItemAt(0).commutationStatusId;
			if (statusId == CommutationStatusId.ENTERED ||
				statusId == CommutationStatusId.REJECTED) {
				return true;
			}

			return false;
		}
	    
		/**
		 * 申請取り消し可否判定.
		 *
		 * @return value Boolean	申請取り消し可否
		 */
		private function enabledApplyCancel():Boolean
		{
			if (!_commutation) return false;
			// 手続き履歴が存在しないならば申請取り下げ不可能.
			if (_commutation.commutationHistories == null
				|| _commutation.commutationHistories.length == 0) {
				return false;
			}

			// 申請済状態ならば申請取り下げ可能.
			if (_commutation.commutationHistories.getItemAt(0).commutationStatusId
				== CommutationStatusId.APPLIED) {
				return true;
			}

			return false;
		}
		
		/**
		 * 複製可否判定.
		 *
		 * @return value Boolean	複製可否
		 */
		private function enabledCopy():Boolean
		{
			// 登録可否のステータス判定と同じ.
			return enabledEntryStatus();
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
			var comment:String = cmh.commutationAction != null ? cmh.commutationAction.commutationActionName : "";
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
		
		
		/**
		 * 保存申請入力値処理.
		 *
		 * @param actionType 動作ID.
		 * @return エラーメッセージ.
		 */
		private function checkEntryApplyVal(actionType:int):String
		{
			var typeMsg:String;
			var errMsg:String;
			var dateArray:Array = new Array();
			typeMsg = actionType == CommutationActionId.APPLY ? "申請":"保存";
			// 各タブのvalidateチェックをする.
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				var ret:Boolean = false;
				var isValid:Boolean = false;
				var isExist:Boolean = false;
				var item:Object = view.tabnavi.getChildAt(index);
				var baseDate:Date = item.commuStartDate.selectedDate;
				if(!baseDate){
					view.tabnavi.selectedIndex = index;
					item.commuStartDate.errorString = "通勤開始日が未入力です。";
					errMsg = "通勤開始日が未入力のため" + typeMsg + "できません。\n修正してください。";
					return errMsg;
				}
				
				// 申請の場合
				if(actionType == CommutationActionId.APPLY){
					for (var i:int = 0; i < dateArray.length; i++) {
		                baseDate.hours = 0;
		                baseDate.minutes = 0;
		                baseDate.seconds = 0;
		
		                var targetDate:Date = dateArray[i];
		                targetDate.hours = 0;
		                targetDate.minutes = 0;
		                targetDate.seconds = 0;
	
						if (baseDate.time == targetDate.time) {
							isExist = true;
							break;
						}
					}
					if (isExist) {
						view.tabnavi.selectedIndex = index;
						item.commuStartDate.errorString = "通勤開始日が重複しています。";
						errMsg = "通勤開始日が重複しているため" + typeMsg + "できません。\n修正してください。";
						return errMsg;
					} else {
						dateArray.push(item.commuStartDate.selectedDate);
					}

					if (item is CommutationForm) {
						ret = item.validateAll();
					}
					if (!ret) {
						view.tabnavi.selectedIndex = index;
						errMsg = "入力項目に不備があるため申請できません。\n修正してください。";
						return errMsg;
					}
				}
			}
			return errMsg;
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CommutationRequest;
	    
	    /**
	     * 画面を取得します
	     */     
	    public function get view():CommutationRequest
	    {
	        if (_view == null) {
	            _view = super.document as CommutationRequest;
	        }
	        return _view;
	    }
	    
	    /**
	     * 画面をセットします。
	     * 
	     * @param view セットする画面
	     */
	    public function set view(view:CommutationRequest):void
	    {
	        _view = view;
	    }




		
	}
}

