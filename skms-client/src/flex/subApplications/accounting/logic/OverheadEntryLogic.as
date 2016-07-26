package subApplications.accounting.logic
{

	import components.PopUpWindow;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.OverheadDetailDto;
	import subApplications.accounting.dto.OverheadDto;
	import subApplications.accounting.web.OverheadDetailEntry;
	import subApplications.accounting.web.OverheadEntry;
	import subApplications.project.web.ProjectSelect;

	import utils.LabelUtil;


	/**
	 * 諸経費申請登録のLogicクラスです.
	 */
	public class OverheadEntryLogic extends Logic
	{
		/** リンクボタンリスト */
		[Bindable]
		private var _rp_linkList_entry:ArrayCollection
						= new ArrayCollection([	{label:"新規", func:"onClick_linkList_new",    enabled:true},
												{label:"変更", func:"onClick_linkList_update", enabled:false, enabledCheck:true},
												{label:"削除", func:"onClick_linkList_delete", enabled:false, enabledCheck:true}
												]);
		[Bindable]
		private var _rp_linkList_confirm:ArrayCollection
						= new ArrayCollection([	{label:"変更", func:"onClick_linkList_update", enabled:false, enabledCheck:true}
												]);

		/** 選択されたリンクバー */
		protected var _selectedLinkObject:Object;

		/** 選択されたプロジェクト */
		protected var _selectedProject:Object;

		/** 更新対象の諸経費 */
		protected var _overhead:Object;

		/** 選択された一覧データ */
		protected var _selectedOverhead:OverheadDetailDto;

		/** 一覧再表示 */
		protected var _reload:Boolean;


		/** 諸経費区分リスト */
		protected var _overheadType:ArrayCollection;
		/** 設備種別リスト */
		protected var _equipmentKind:ArrayCollection;
		/** 支払リスト */
		protected var _paymentType:ArrayCollection;
		/** 勘定科目リスト */
		protected var _accountItem:ArrayCollection;
		/** PC種別リスト */
		protected var _pcKind:ArrayCollection;
		/** 社員リスト */
		protected var _staff:ArrayCollection;
		/** 設置場所リスト */
		protected var _installationLocation:ArrayCollection;
		/** クレジットカードリスト */
		protected var _creditCard:ArrayCollection;
		/** ジャンルリスト */
		protected var _janre:ArrayCollection;


		/** 画面表示タイマー */
		private var _displayTimer:Timer;

		/** 検証結果 */
		private var _validateResults:Array;


//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function OverheadEntryLogic()
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
	    	// 明細表示タイマーを設定する.
	    	//view.visible = false;
			_displayTimer = new Timer(1000, 10);
			_displayTimer.addEventListener(TimerEvent.TIMER, onTimer_displayData);
			_displayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete_displayData);

	    	// 諸経費区分を取得する.
	    	requestGetOverheadType();
	    	// 設備区分を取得する.
	    	requestGetEquipmentKind();
	    	// 支払種別を取得する.
	    	requestGetPayment();
	    	// 勘定科目を取得する.
	    	requestGetAccountItem();
			// PC種別を取得する.
			requestGetPcKind();
			// 社員を取得する.
			requestGetStaff();
			// 設置場所を取得する.
			requestGetInstallationLocation();
			// クレジットカードを取得する.
			requestCreditCard();
			// ジャンルを取得する.
			requestJanre();


	    	// リンクボタンを設定する.
	    	if (view.entry || view.copy)	{
	    		view.rpLinkList.dataProvider = _rp_linkList_entry;

	    	}
	    	else {
	    		view.rpLinkList.dataProvider = _rp_linkList_confirm;
	    	}
	    }



//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList(e:MouseEvent):void
		{
			// 選択したリンクボタンの処理を呼び出す.
			_selectedLinkObject = view.rpLinkList.dataProvider.getItemAt(e.target.instanceIndex);
			if (_selectedLinkObject.hasOwnProperty("prepare")) {
				this[_selectedLinkObject.prepare](e);
			}
			else {
				this[_selectedLinkObject.func]();
			}
		}

	    /**
	     * リンクボタン選択 新規.<br>
	     *
	     */
		protected function onClick_linkList_new():void
		{
			// 画面表示データ.
			var pop:OverheadDetailEntry = new OverheadDetailEntry();
			pop.actionMode = view.actionMode;
			pop.authorizeApproval = view.authorizeApproval;
			// 引き継ぎデータ.
			var object:Object = requiredData_OverheadDetail();
			// 表示.
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, object);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadDetailEntryNew);
			pop.addEventListener("entryNew", onEntryNew_overheadDetailEntry);
		}

	    /**
	     * リンクボタン選択 変更.<br>
	     *
	     */
		protected function onClick_linkList_update():void
		{
			// 画面表示データ.
			var pop:OverheadDetailEntry = new OverheadDetailEntry();
			pop.actionMode = view.actionMode;
			pop.authorizeApproval = view.authorizeApproval;
			// 画面データ.
			var object:Object = requiredData_OverheadDetail();
			object.overhead = _selectedOverhead;
			// 表示.
			PopUpWindow.displayWindow(pop, view.parentApplication as DisplayObject, object);
			pop.addEventListener(CloseEvent.CLOSE, onClose_overheadDetailEntryUpdate);
		}

	    /**
	     * リンクボタン選択 削除.<br>
	     *
	     */
		protected function onClick_linkList_delete():void
		{
			// 削除フラグを ON に設定し、表示しないようにする.
			var list:ArrayCollection = view.overheadList.dataProvider as ArrayCollection;
			var object:Object = list.getItemAt(view.overheadList.selectedIndex);
			object.isDelete = true;
			list.filterFunction = filterOverheadList;
			list.refresh();

			// 選択行をクリアにする.
			view.overheadList.selectedIndex = -1;
			view.overheadList.selectedItem  = null;
			_selectedOverhead = view.overheadList.selectedItem as OverheadDetailDto;

			// リンクボタンを設定する.
			setRpLinkList_overheadList();

			// 合計金額を再計算する.
			view.totalExpense.text = LabelUtil.totalExpense(view.overheadList.dataProvider as ArrayCollection);

			// validate する.
			validateOverheadList();
		}


		/**
		 * 諸経費明細一覧リストの選択.
		 *
		 * @param e ListEvent.
		 */
		public function onChangeDataGrid_overheadList(e:ListEvent):void
		{
			// 一覧リストを設定する.
			_selectedOverhead = view.overheadList.selectedItem as OverheadDetailDto;

			// リンクボタンを設定する.
			setRpLinkList_overheadList();
		}


		/**
		 * 諸経費明細 DragEnter.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_overheadList(e:DragEvent):void
		{
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}

		/**
		 * 諸経費明細 DragOver.
		 *
		 * @param e DragEvent
		 */
		public function onDragOver_overheadList(e:DragEvent):void
		{
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}


		/**
		 * データ表示タイマーイベント.
		 *
		 * @param e TimerEvent
		 */
		private function onTimer_displayData(e:TimerEvent):void
		{
			// 諸経費を取得する.
			var request:Boolean = setOverheadInfo();
//			if (request) 	_displayTimer.reset();
		}

		/**
		 * 諸経費取得タイマー完了イベント.
		 *
		 * @param e TimerEvent
		 */
		private function onTimerComplete_displayData(e:TimerEvent):void
		{
			// 諸経費を取得する.
			var request:Boolean = setOverheadInfo();
			if (!request)	onTimerOut_displayData(new Event("onTimerComplete_displayData"));
		}


	    /**
	     * プロジェクト選択.
	     *
		 * @param e MouseEvent
	     */
		public function onClick_linkProject(e:MouseEvent):void
		{
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(ProjectSelect, view);
			pop.addEventListener(CloseEvent.CLOSE, onClose_projectSelect);
		}


		/**
		 * （新規）諸経費登録P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent.
		 */
		private function onClose_overheadDetailEntryNew(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY) {
				;
			}
		}

		/**
		 * （変更）諸経費登録P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent.
		 */
		private function onClose_overheadDetailEntryUpdate(e:CloseEvent):void
		{
			if (e.detail ==  PopUpWindow.ENTRY) {
				var pop:OverheadDetailEntry = e.target as OverheadDetailEntry;
				var entry:Object = pop.entryOverhead;
				_selectedOverhead.update(entry);
				view.totalExpense.text = LabelUtil.totalExpense(view.overheadList.dataProvider as ArrayCollection);
				if (!view.entry) {
					validateOverheadList();
				}
			}
		}

		/**
		 * プロジェクト選択P.U.クローズイベント処理.
		 *
		 * @param e CloseEvent.
		 */
		private function onClose_projectSelect(e:CloseEvent):void
		{
			if (e.detail == PopUpWindow.ENTRY) {
				var pop:ProjectSelect = e.target as ProjectSelect;
				_selectedProject = pop.entryProject;
				view.linkProject.label = _selectedProject.projectCode + "　" + _selectedProject.projectName;
			}
		}


		/**
		 * 諸経費 新規登録イベント処理.
		 *
		 * @param e Event.
		 */
		private function onEntryNew_overheadDetailEntry(e:Event):void
		{
			var pop:OverheadDetailEntry = e.target as OverheadDetailEntry;
			var entry:Object = pop.entryOverhead;
			if (!view.overheadList.dataProvider)
				view.overheadList.dataProvider = new ArrayCollection();
			view.overheadList.dataProvider.addItem(entry);
			view.totalExpense.text = LabelUtil.totalExpense(view.overheadList.dataProvider as ArrayCollection);
		}

		/**
		 * 登録ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:MouseEvent):void
		{
			// 諸経費明細入力チェックを行なう.
			if (ObjectUtil.compare(e.type, "onCreationCompleteHandler") != 0) {
				var result:Boolean = validateOverheadList();
				if (!result) {
					Alert.show("未入力の項目があります。\n入力してください。");
					return;
				}
			}

			// プロジェクト入力チェックを行なう.
			if (_selectedProject == null) {
				Alert.show("プロジェクトを選択してください。");
				return;
			}

			Alert.show("登録してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) {
				// 申請情報を設定する.
				var overhead:OverheadDto = OverheadDto.create(_overhead as OverheadDto, _selectedProject);
				// 申請明細情報を設定する.
				var list:ArrayCollection = ObjectUtil.copy(view.overheadList.dataProvider) as ArrayCollection;
				if (list) {
					list.filterFunction = filterOverheadEntryList;
					list.refresh();
					for each (var object:Object in list) {
						overhead.overheadDetails.addItem(object);
					}
				}
				view.srv.getOperation("createOverhead").send(Application.application.indexLogic.loginStaff, overhead);
			}
		}

		/**
		 * 申請ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_apply_confirm(e:MouseEvent):void
		{
			if (ObjectUtil.compare(e.type, "onCreationCompleteHandler") != 0) {
				var result:Boolean = validateOverheadList();
				if (!result) {
					Alert.show("未入力の項目があります。\n入力してください。");
					return;
				}
			}

			Alert.show("申請してもよろしいですか？", "", 3, view, onButtonClick_apply_confirmResult);
		}
		protected function onButtonClick_apply_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) {
				// 申請情報を設定する.
				var overhead:OverheadDto = OverheadDto.create(_overhead as OverheadDto, _selectedProject);
				// 申請明細情報を設定する.
				var list:ArrayCollection = ObjectUtil.copy(view.overheadList.dataProvider) as ArrayCollection;
				list.filterFunction = filterOverheadEntryList;
				list.refresh();
				for each (var object:Object in list) {
					overhead.overheadDetails.addItem(object);
				}
				view.srv.getOperation("applyOverhead").send(Application.application.indexLogic.loginStaff, overhead);
			}
			else if (e.detail == Alert.NO && !view.visible) {
				view.closeWindow();
			}
		}

		/**
		 * 承認ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_approval_confirm(e:MouseEvent):void
		{
			if (ObjectUtil.compare(e.type, "onCreationCompleteHandler") != 0) {
				var result:Boolean = validateOverheadList();
				if (!result) {
					Alert.show("未入力の項目があります。\n入力してください。");
					return;
				}
			}

			Alert.show("承認してもよろしいですか？", "", 3, view, onButtonClick_approval_confirmResult);
		}
		protected function onButtonClick_approval_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES) {
				// 申請情報を設定する.
				var overhead:OverheadDto = OverheadDto.create(_overhead as OverheadDto, _selectedProject);
				// 申請明細情報を設定する.
				var list:ArrayCollection = ObjectUtil.copy(view.overheadList.dataProvider) as ArrayCollection;
				for each (var object:Object in list) {
					overhead.overheadDetails.addItem(object);
				}
				if (view.approvalAf)
					view.srv.getOperation("approvalAfOverhead").send(Application.application.indexLogic.loginStaff, overhead);
				else
					view.srv.getOperation("approvalOverhead").send(Application.application.indexLogic.loginStaff, overhead);
			}
			else if (e.detail == Alert.NO && !view.visible) {
				view.closeWindow();
			}
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_close(e:MouseEvent):void
		{
			if (_reload)	view.closeWindow(PopUpWindow.RELOAD);
			else			view.closeWindow();
		}


		/**
		 * createOverhead(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_createOverhead(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * applyOverhead(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_applyOverhead(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * approvalOverhead(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_approvalOverhead(e:ResultEvent):void
		{
			trace (e.toString());
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * approvalAfOverhead(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_approvalAfOverhead(e:ResultEvent):void
		{
			trace (e.toString());
			view.closeWindow(PopUpWindow.ENTRY);
		}


		/**
		 * createOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_createOverhead(e:FaultEvent):void
		{
			Alert.show(e.toString());
		}

		/**
		 * applyOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_applyOverhead(e:FaultEvent):void
		{
			var conflict:Boolean = AccountingLogic.alert_applyOverhead(e, view.visible);
			if (conflict)	_reload = true;

			// 画面が表示されていないときは、強制的に画面を閉じる.
			if (!view.visible) {
				if (_reload)	view.closeWindow(PopUpWindow.RELOAD);
				else			view.closeWindow();
			}
		}

		/**
		 * approvalOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_approvalOverhead(e:FaultEvent):void
		{
			var conflict:Boolean = AccountingLogic.alert_approvalOverhead(e, view.visible);
			if (conflict)	_reload = true;

			// 画面が表示されていないときは、強制的に画面を閉じる.
			if (!view.visible) {
				if (_reload)	view.closeWindow(PopUpWindow.RELOAD);
				else			view.closeWindow();
			}
		}

		/**
		 * approvalAfOverheadの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_approvalAfOverhead(e:FaultEvent):void
		{
			var conflict:Boolean = AccountingLogic.alert_approvalAfOverhead(e, view.visible);
			if (conflict)	_reload = true;

			// 画面が表示されていないときは、強制的に画面を閉じる.
			if (!view.visible) {
				if (_reload)	view.closeWindow(PopUpWindow.RELOAD);
				else			view.closeWindow();
			}
		}

		/**
		 * getOverheadType(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getOverheadType(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_overheadType = list;

			setOverheadInfo();
		}

		/**
		 * getEquipmentKind(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getEquipmentKind(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_equipmentKind = list;

			setOverheadInfo();
		}

		/**
		 * getPayment(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getPayment(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_paymentType = list;

			setOverheadInfo();
		}

		/**
		 * getAccountItem(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getAccountItem(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_accountItem = list;

			setOverheadInfo();
		}

		/**
		 * getPcKind(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getPcKind(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_pcKind = list;

			setOverheadInfo();
		}

		/**
		 * getStaff(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getStaff(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_staff = list;

			setOverheadInfo();
		}

		/**
		 * getInstallationLocation(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getInstallationLocation(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_installationLocation = list;

			setOverheadInfo();
		}

		/**
		 * getCreditCard(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getCreditCard(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_creditCard = list;

			setOverheadInfo();
		}

		/**
		 * getJanre(RemoteObject)の呼び出し成功.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getJanre(e:ResultEvent):void
		{
			var list:ArrayCollection = e.result as ArrayCollection;
			_janre = list;

			setOverheadInfo();
		}


		/**
		 * getOverheadTypeの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getOverheadType(e:FaultEvent):void
		{
			AccountingLogic.alert_getOverheadType(e);
			view.closeWindow();
		}

		/**
		 * getEquipmentKindの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getEquipmentKind(e:FaultEvent):void
		{
			AccountingLogic.alert_getEquipmentKind(e);
			view.closeWindow();
		}

		/**
		 * getPaymentの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getPayment(e:FaultEvent):void
		{
			AccountingLogic.alert_getPayment(e);
			view.closeWindow();
		}

		/**
		 * getAccountItemの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getAccountItem(e:FaultEvent):void
		{
			AccountingLogic.alert_getAccountItem(e);
			view.closeWindow();
		}

		/**
		 * getPcKindの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getPcKind(e:FaultEvent):void
		{
			AccountingLogic.alert_getPcKind(e);
			view.closeWindow();
		}

		/**
		 * getStaffの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getStaff(e:FaultEvent):void
		{
			AccountingLogic.alert_getStaff(e);
			view.closeWindow();
		}

		/**
		 * getInstallationLocationの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getInstallationLocation(e:FaultEvent):void
		{
			AccountingLogic.alert_getInstallationLocation(e);
			view.closeWindow();
		}

		/**
		 * getCreditCardの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getCreditCard(e:FaultEvent):void
		{
			AccountingLogic.alert_getCreditCard(e);
			view.closeWindow();
		}

		/**
		 * getJanreの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getJanre(e:FaultEvent):void
		{
			AccountingLogic.alert_getJanre(e);
			view.closeWindow();
		}


		/**
		 * データ表示タイムアウト.
		 *
		 * @param e FaultEvent.
		 */
		public function onTimerOut_displayData(e:Event):void
		{
			AccountingLogic.alert_timerOutDisplayData(e);
			view.closeWindow();
		}



//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 諸経費区分の問い合わせ.
		 *
		 */
		private function requestGetOverheadType():void
		{
			view.srv.getOperation("getOverheadType").send();
		}

		/**
		 * 設備種別の問い合わせ.
		 *
		 */
		private function requestGetEquipmentKind():void
		{
			view.srv.getOperation("getEquipmentKind").send();
		}

		/**
		 * 支払種別の問い合わせ.
		 *
		 */
		private function requestGetPayment():void
		{
			view.srv.getOperation("getPayment").send();
		}

		/**
		 * 勘定科目の問い合わせ.
		 *
		 */
		private function requestGetAccountItem():void
		{
			if (view.authorizeApproval)
				view.srv.getOperation("getAccountItem").send();
		}

		/**
		 * PC種別の問い合わせ.
		 *
		 */
		private function requestGetPcKind():void
		{
			view.srv.getOperation("getPcKind").send();
		}

		/**
		 * 社員の問い合わせ.
		 *
		 */
		private function requestGetStaff():void
		{
			view.srv.getOperation("getStaff").send();
		}

		/**
		 * 設置場所の問い合わせ.
		 *
		 */
		private function requestGetInstallationLocation():void
		{
			view.srv.getOperation("getInstallationLocation").send();
		}

		/**
		 * クレジットカードの問い合わせ.
		 *
		 */
		private function requestCreditCard():void
		{
			view.srv.getOperation("getCreditCard").send();
		}

		/**
		 * ジャンルの問い合わせ.
		 *
		 */
		private function requestJanre():void
		{
			view.srv.getOperation("getJanre").send();
		}


		/**
		 * 諸経費情報の設定.
		 *
		 */
		private function setOverheadInfo():Boolean
		{
			// データ取得中かどうか確認する.
			var cursorID:int = CursorManager.getInstance().currentCursorID;
			if (ObjectUtil.compare(cursorID, CursorManager.NO_CURSOR) != 0) {
				// 先発優先でデータを取得する.
				if (!_displayTimer.running) 		_displayTimer.start();
				return false;
			}

			// タイマをクリアする.
			_displayTimer.reset();


			// 諸経費データを設定する.
			if (view.data && view.data.overhead) {
				if (view.copy)		_overhead = OverheadDto.copy(view.data.overhead);
				else				_overhead = ObjectUtil.copy(view.data.overhead);
				_selectedProject = {projectId:_overhead.projectId, projectCode:_overhead.projectCode, projectName:_overhead.projectName};
				view.linkProject.label = view.linkProject.label = _selectedProject.projectCode + "　" + _selectedProject.projectName;
				view.overheadList.dataProvider = _overhead.overheadDetails;
				view.totalExpense.text = LabelUtil.totalExpense(view.overheadList.dataProvider as ArrayCollection);
			}


			// 登録       → validateチェックせずそのまま表示する.（validateチェックしなくてもよいのだが、一応する）
			// 複製       → validateチェックしてそのまま表示する.
			// 申請・承認 → validateチェックしＯＫならば 操作確認メッセージ、ＮＧならそのまま表示する.
			var result:Boolean = validateOverheadList();
			if (result) {
				if (view.apply) {
					onButtonClick_apply_confirm(new MouseEvent("onCreationCompleteHandler"));
					return true;
				}
				else if (view.approval || view.approvalAf) {
					onButtonClick_approval_confirm(new MouseEvent("onCreationCompleteHandler"));
					return true;
				}
			}
			else {
				Alert.show("未入力の項目があります。\n入力してください。");
			}

			view.visible = true;
			return true;
		}


		/**
	     * リンクボタン設定.
	     *
	     * @param enable リンクボタン有効.
	     * @return リンクボタンリスト.
	     */
	     private function setRpLinkList_overheadList(enable:Boolean = true):void
	     {
			// リンクボタンの数分繰り返し.
			for(var i:int = 0; i < view.rpLinkList.dataProvider.length; i++) {
				// リンクボタンオブジェクトの取得.
				var linkObject:Object = view.rpLinkList.dataProvider.getItemAt(i);
				// 可否チェック用プロパティが定義されていたら.
				if (linkObject.hasOwnProperty("enabledCheck")) {
					// 可否チェック.
					linkObject.enabled = false;
					var overhead:Object = view.overheadList.selectedItem;
					if (overhead) {
						linkObject.enabled = true;
					}
				}
			}
			// リンクボタンリストを更新する.
			view.rpLinkList.dataProvider.refresh();
	     }


		/**
		 * 諸経費明細一覧のフィルタリング.
		 *
		 * @param item 諸経費明細データ.
		 * @return 結果.
		 */
		private function filterOverheadList(item:Object):Boolean
		{
			// 削除予定のデータは表示しない.
			return !item.isDelete;
		}

		/**
		 * 諸経費明細一覧のフィルタリング.
		 *
		 * @param item 諸経費明細データ.
		 * @return 結果.
		 */
		private function filterOverheadEntryList(item:Object):Boolean
		{
			// 全データを表示する.
			return true;
		}


		/**
		 * 諸経費詳細 必須データ取得.
		 *
		 */
		private function requiredData_OverheadDetail():Object
		{
			var object:Object = new Object();
			object.overheadType  = _overheadType;
			object.equipmentKind = _equipmentKind;
			object.paymentType   = _paymentType;
			object.accountItem   = _accountItem;
			object.pcKind        = _pcKind;
			object.staff         = _staff;
			object.installationLocation = _installationLocation;
			object.creditCard    = _creditCard;
			object.janre         = _janre;
			return object;
		}


		/**
		 * 諸経費詳細 validate.
		 *
		 * @return 結果.
		 */
		private function validateOverheadList(colorFlg:Boolean = true):Boolean
		{
			var result:Boolean = true;

			// validate を行なう.
			var items:Array = new Array();
			var list:ArrayCollection = view.overheadList.dataProvider as ArrayCollection;
			for each (var overhead:Object in list) {
				var pop:OverheadDetailEntry = new OverheadDetailEntry();
				pop.actionMode = view.actionMode;
				pop.authorizeApproval = view.authorizeApproval;
				var object:Object = requiredData_OverheadDetail();
				object.overhead = overhead;
				PopUpWindow.displayWindow(pop, view, object);
				var validate:Boolean = pop.validate();
				pop.closeWindow();
				if (validate)	items.push(true);
				else			items.push(false);
			}
			// error 有無を確認する.
			for each (var item:Object in items) {
				if (item != true) {
					result = false;
					break;
				}
			}
			_validateResults = items;


			// 背景色を設定する.
			if (colorFlg && view.overheadList.dataProvider) {
				view.overheadList.validateIndices = _validateResults;
			}
			return result;
		}
//
//		/**
//		 * 諸経費詳細 validate結果.
//		 *
//		 * @return 結果.
//		 */
//		private function validateOverheadDetailResult():Boolean
//		{
//			for each (var item:Object in _validateResults) {
//				if (item != true)		return false;
//			}
//			return true;
//		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:OverheadEntry;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():OverheadEntry
	    {
	        if (_view == null) {
	            _view = super.document as OverheadEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:OverheadEntry):void
	    {
	        _view = view;
	    }

	}
}

