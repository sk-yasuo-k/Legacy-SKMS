package subApplications.accounting.logic
{
	import components.PopUpWindow;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.RouteDetailDto;
	import subApplications.accounting.dto.TransportationDetailDto;
	import subApplications.accounting.dto.TransportationDto;
	import subApplications.accounting.web.RouteEntry;
	import subApplications.accounting.web.RouteSearch;
	import subApplications.accounting.web.TransportEntry;
	import subApplications.accounting.web.TransportEntryBatch;
	import subApplications.project.web.ProjectSelect;

	import utils.LabelUtil;


	/**
	 * TransportEntryのLogicクラスです.
	 */
	public class TransportEntryLogic extends AccountingLogic
	{
		/** 所属プロジェクトリスト */
		private var _projectList:ArrayCollection;

		/** 削除予定の交通費申請明細リスト */
		private var _deleteTransDetailList:ArrayCollection = new ArrayCollection();

		/** 再表示 */
		private var _reload:Boolean = false;

		/** 交通費明細一覧 リンクボタンアイテム */
		private const RP_LINKLIST:ArrayCollection
			= new ArrayCollection([
//				{id:"add",		label:"追加",				func:"onClick_linkList_add",															enabled:true,	enabledCheck:false},
				{id:"delete",	label:"削除",				func:"onClick_linkList_delete2",														enabled:false,	enabledCheck:true},
				{id:"copy",		label:"複製",				func:"onClick_linkList_copy",															enabled:false,	enabledCheck:true},
				{id:"search",	label:"よく使う経路から選ぶ",	func:"onClick_linkList_routeSearch",	prepare:"onClick_linkList_routeSearch_prepare",	enabled:true,	enabledCheck:false},
				{id:"entry",	label:"よく使う経路として登録",	func:"onClick_linkList_routeEntry",		prepare:"onClick_linkList_routeEntry_prepare",	enabled:false,	enabledCheck:true},
				{id:"edit",		label:"よく使う経路の編集",		func:"onClick_linkList_routeEntry",		prepare:"onClick_linkList_routeEdit_prepare",	enabled:true,	enabledCheck:false},
				{id:"guide",	label:"乗り換え案内を開く",		func:"onClick_linkList_routeGuide",														enabled:true,	enabledCheck:false}
			]);


		/** コンテキストメニュー：明細行一括追加 */
		private const CMENU_TRANSPORT_COPY:String   = "複製";
		/** コンテキストメニュー：明細行削除 */
		private const CMENU_TRANSPORT_DELETE:String = "削除";
		/** コンテキストメニュー：ルート検索 */
		private const CMENU_ROUTE_SEARCH:String     = "よく使う経路から選ぶ";
		/** コンテキストメニュー：ルート登録 */
		private const CMENU_ROUTE_ENTRY:String      = "よく使う経路として登録";


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function TransportEntryLogic()
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
			// 引き継ぎデータを取得する.
			onCreationCompleteHandler_setSuceedData();

			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();

			// コンテキストメニューを設定する.
			onCreationCompleteHandler_setContextMenu();

			// 画面を表示する.
			view.visible = true;
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
	    	_actionMode = view.data.actionMode;
	    	if (ObjectUtil.compare(_actionMode, ACTION_UPDATE) == 0) {
	    		_selectedTransportDto = view.data.transportDto;
	    	}
	    	else {
	    		// 新規のときは 空データを設定する.
	    		_selectedTransportDto = new TransportationDto();
	    	}
	    	_facilityNameList = view.data.facilities;
		}

	    /**
	     * 表示データの設定.
	     *
	     */
	    override protected function onCreationCompleteHandler_setDisplayData():void
	    {
			// 一覧の初期データを設定する.
			view.transportationDetail.rowCount     = ROW_COUNT_EDIT;
			view.transportationDetail.actionMode   = _actionMode;
			view.transportationDetail.facilities   = _facilityNameList;

			// 一覧を作成する.
			view.transportationDetail.dataProvider = makeTable_transportationDetail(_selectedTransportDto.transportationDetails);
			setRpLinkList_transportationDetail();

			// 所属プロジェクトリストを取得する.
//			view.srv.getOperation("getBelongProjectList").send(Application.application.indexLogic.loginStaff);

			// 交通費申請情報で指定されたプロジェクトを選択状態にする.
			if (ObjectUtil.compare(_actionMode, ACTION_UPDATE) == 0) {
				view.linkProject.label = _selectedTransportDto.project.projectCode
									+ "　" + _selectedTransportDto.project.projectName;
			} else {
				view.linkProject.label = "ここをクリックしてプロジェクトを選択してください...";
			}

	    }

		/**
		 * コンテキストメニューの作成.
		 *
		 */
		override protected function onCreationCompleteHandler_setContextMenu():void
		{
			// コンテキストメニューを設定する.
			view.transportationDetail.contextMenu = createContextMenu_transportDetail();
			setContextMenu_transportationDetail();
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------
	    /**
	     * プロジェクト選択.
	     *
		 * @param e MouseEvent
	     */
		public function onClick_linkProject(e:MouseEvent):void
		{
//			// ProjectSelect（プロジェクト選択）を作成する.
//			var pop:ProjectSelect = new ProjectSelect();
//			PopUpManager.addPopUp(pop, view, true);
//
//			// 引き継ぎデータを設定する.
//			var obj:Object = new Object();
//			obj.transportDto = _selectedTransportDto;
//			IDataRenderer(pop).data = obj;
//
//			// クローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_projectSelect);
//
//			// TransportEntryを表示する.
//			PopUpManager.centerPopUp(pop);
			// 引き継ぎデータを設定する.
			var obj:Object = new Object();
			obj.transportDto = _selectedTransportDto;
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(ProjectSelect, view, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_projectSelect);
		}

//		/**
//		 * フォーカスイン 交通費申請明細一覧.
//		 *
//		 * @param e FocusEvent
//		 */
//		public function onFocusIn_transportationDetail(e:FocusEvent):void
//		{
//			// trace (e.target + " " + e.toString());
//			if (e.target is DataGrid) {
//				// DataGrid以外からフォーカスインしたとき すぐに選択行が取得できないため.
//				// 少し遅らせて選択行を取得する.
//				var args:Array = new Array();
//				args.push(e);
//				view.transportationDetail.callLater(onItemClick_transportationDetail, args);
//			}
//			else if (e.target is UITextField || e.target is ComboBox || e.target is DateField) {
//				onItemClick_transportationDetail(e);
//			}
//		}
//
		/**
		 * 交通費申請明細一覧の選択変更.
		 *
		 * @param e ListEvent or KeyboardEvent
		 */
		public function onChange_transportationDetail(e:Event):void
		{
			// 交通費明細一覧を設定する.
			setContextMenu_transportationDetail();
			setRpLinkList_transportationDetail();
        }

		/**
		 * 交通費申請明細一覧の編集終了.
		 *
		 * @param e ListEvent or KeyboardEvent
		 */
		public function onItemFocusOut_transportationDetail(e:Event):void
		{
			// 交通費明細一覧を設定する.
			var ac:ArrayCollection = view.transportationDetail.dataProvider as ArrayCollection;
			if (ac.length == view.transportationDetail.selectedIndex+1) {
				var transport:TransportationDetailDto =
				view.transportationDetail.dataProvider.getItemAt(view.transportationDetail.selectedIndex) as TransportationDetailDto;
				if (transport.checkEntry()) {
					onClick_linkList_add();
				}
			}
        }

		/**
		 * リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		override public function onClick_linkList(e:MouseEvent):void
		{
//			super.onClick_linkList(e);
//			_selectedLinkObject = RP_LINKLIST.getItemAt(e.target.instanceIndex);
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
		override protected function onClick_linkList_confirmResult(e:CloseEvent):void
		{
			super.onClick_linkList_confirmResult(e);

			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.YES) {
				this[_selectedLinkObject.func]();
			}
		}

	    /**
	     * リンクボタン選択 明細行追加.
	     *
	     */
		protected function onClick_linkList_add():void
		{
			// 交通費明細一覧を設定する.
			var ac:ArrayCollection = view.transportationDetail.dataProvider as ArrayCollection;
			ac.addItem(new TransportationDetailDto());
			view.transportationDetail.validateNow();
			view.transportationDetail.dataProvider.refresh();
			view.transportationDetail.scrollToIndex(ac.length-1);
			setContextMenu_transportationDetail();
			setRpLinkList_transportationDetail();
		}

// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * リンクボタン選択 明細行削除 確認.
//		 *
//		 * @param e Event
//		 */
//		protected function onItemClick_linkList_delete_confirm(e:Event):void
//		{
//			Alert.show("削除するとデータは元に戻りませんが\n削除してもよろしいですか？", "", 3, view, onItemClick_linkList_confirmResult);
//		}
//		/**
//		 * リンクボタン選択 明細行削除.
//		 *
//		 */
//		protected function onItemClick_linkList_delete():void
//		{
//			// 選択行を取得する.
//			var items:Array = ObjectUtil.copy(view.transportationDetail.selectedItems) as Array;
//
//			// 削除リストを作成する.
//			var deleteItems:Array = new Array();
//			for each (var item:TransportationDetailDto in items) {
//				item.setDelete();
//				deleteItems.push(item);
//			}
//			// 選択した明細を削除する.
//			view.srv.getOperation("deleteTransportationDetails").send(Application.application.indexLogic.loginStaff, deleteItems);
//			isLatestDataDisplay = true;
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.
		/**
		 * リンクボタン選択 明細行削除.
		 *
		 */
		protected function onClick_linkList_delete2():void
		{
			// 選択行を取得する.
			var indices:Array = view.transportationDetail.selectedIndices;
			indices.sort(Array.NUMERIC | Array.DESCENDING);

			// 選択last行から削除リストに追加する.
			var list:ArrayCollection = view.transportationDetail.dataProvider as ArrayCollection;
			for (var i:int = 0; i < indices.length; i++) {
				var index:int = indices[i];
				var item:TransportationDetailDto = list.getItemAt(index) as TransportationDetailDto;
				item.setDelete();
				_deleteTransDetailList.addItem(item);
				list.removeItemAt(index);
			}

			// 交通費明細一覧を設定する.
			view.transportationDetail.dataProvider = makeTable_transportationDetail(list);
			setContextMenu_transportationDetail();						// コンテキストメニュー設定.
			setRpLinkList_transportationDetail();						// リンクボタン設定.
		}

		/**
		 * リンクボタン選択 明細行コピー.
		 *
		 */
		protected function onClick_linkList_copy():void
		{
//			// TransportEntryBatch（日付設定）を作成する.
//			var pop:TransportEntryBatch = new TransportEntryBatch();
//			PopUpManager.addPopUp(pop, view, true);
//
//			// TransportEntryBatchのクローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_batchEntry);
//
//			// TransportEntryBatch（日付設定）を表示する.
//			PopUpManager.centerPopUp(pop);
			// TransportEntryBatch（日付設定）を表示する.
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportEntryBatch, view);
			pop.addEventListener(CloseEvent.CLOSE, onClose_batchEntry);
		}

		/**
		 * リンクボタン選択 乗り換え案内.
		 *
		 */
		protected function onClick_linkList_routeGuide():void
		{
			// InfoSeekの乗り換え案内ページを表示する.
			openWindow_InfoSeek();
		}

		/**
		 * リンクボタン選択 経路検索 準備.
		 *
		 * @param e ItemClickEvent
		 */
		protected function onClick_linkList_routeSearch_prepare(e:Event):void
		{
			// 選択Indexを取得する.
			var indices:Array = view.transportationDetail.selectedIndices.sort(Array.NUMERIC);

			if (indices.length == 0) {
				// データ最終Indexを取得する.
				var lastIndex:int = 0;
				var list:ArrayCollection = view.transportationDetail.dataProvider as ArrayCollection;
				if (list) {
					for (var i:int = list.length - 1; i >= 0; i--) {
						var transport:TransportationDetailDto = list.getItemAt(i) as TransportationDetailDto;
						if (transport.checkEntry()) {
							lastIndex = i + 1;
							break;
						}
					}
				}
				indices.push(lastIndex);
			}

			this[_selectedLinkObject.func](indices);
		}
		/**
		 * リンクボタン選択 経路検索.
		 *
		 * @param indices 選択Index
		 */
		protected function onClick_linkList_routeSearch(indices:Array):void
		{
//			// RouteSearch（ルート検索）を作成する.
//			var pop:RouteSearch = new RouteSearch();
//			PopUpManager.addPopUp(pop, view, true);
//
//			// 引き継ぎデータを設定する.
//			var obj:Object = makeSucceedData_routeSearch(indices);
//			IDataRenderer(pop).data = obj;
//
//			// RouteSearchのクローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_routeSearch);
//
//			// RouteSearchを表示する.
//			PopUpManager.centerPopUp(pop);
			// RouteSearch（ルート検索）を表示する.
			var obj:Object = makeSucceedData_routeSearch(indices);
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(RouteSearch, view, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_routeSearch);

			// 本画面を非表示にする.
			view.visible = false;
		}

		/**
		 * リンクボタン選択 経路登録 確認.
		 *
		 * @param e ItemClickEvent
		 */
		protected function onClick_linkList_routeEntry_prepare(e:Event):void
		{
			// 選択データを取得する.
			var indices:Array = view.transportationDetail.selectedIndices.sort(Array.NUMERIC);
			var items:Array = new Array();
			for each (var index:int in indices) {
				items.push(view.transportationDetail.dataProvider.getItemAt(index));
			}
			onClick_linkList_routeEntry(items);
		}

		/**
		 * リンクボタン選択 経路編集 確認.
		 *
		 * @param e ItemClickEvent
		 */
		protected function onClick_linkList_routeEdit_prepare(e:Event):void
		{
			this[_selectedLinkObject.func](null);
		}
		/**
		 * リンクボタン選択 経路登録.
		 *
		 * @param items 経路リスト.
		 */
		protected function onClick_linkList_routeEntry(items:Array):void
		{
//			// RouteEntry（ルート登録）を作成する.
//			var pop:RouteEntry = new RouteEntry();
//			PopUpManager.addPopUp(pop, view, true);
//
//			// 引き継ぎデータを設定する.
//			var obj:Object = makeSucceedData_routeEntry(items);
//			IDataRenderer(pop).data = obj;
//
//			// RouteEntryのクローズイベントを登録する.
//			pop.addEventListener(CloseEvent.CLOSE, onClose_routeEntry);
//
//			// RouteEntryを表示する.
//			PopUpManager.centerPopUp(pop);

			// RouteEntry（ルート登録）を表示する.
			var obj:Object = makeSucceedData_routeEntry(items);
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(RouteEntry, view, obj);
			pop.addEventListener(CloseEvent.CLOSE, onClose_routeEntry);

			// 本画面を非表示にする.
			view.visible = false;
		}

		/**
		 * ドロップIndexの設定.
		 *
		 * @param e Event
		 */
		public function onSetDropIndex_transportationDetail(e:Event):void
		{
			setRpLinkList_transportationDetail();
		}

		/**
		 * 合計金額計算.
		 *
		 * @param e Event.
		 */
		public function onCalculatedExpense_transportationDetail(e:Event):void
		{
			view.transportationExpense.text = LabelUtil.expense(e.currentTarget.transportationExpense.toString());
		}

		/**
		 * ContextMenu「ルート登録」の選択.
		 *
	     * @param e ContextMenuのイベント.
		 */
		protected function onMenuSelect_routeEntry(e:Event):void
		{
			// 選択データを取得する.
			var indices:Array = view.transportationDetail.selectedIndices.sort(Array.NUMERIC);
			var items:Array = new Array();
			for each (var index:int in indices) {
				items.push(view.transportationDetail.dataProvider.getItemAt(index));
			}
			onClick_linkList_routeEntry(items);
		}

		/**
		 * ContextMenu「ルート検索」の選択.
		 *
	     * @param e ContextMenuのイベント.
		 */
		protected function onMenuSelect_routeSearch(e:Event):void
		{
			// 選択Indexを取得する.
			var indices:Array = view.transportationDetail.selectedIndices.sort(Array.NUMERIC);
			onClick_linkList_routeSearch(indices);
		}


// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * ContextMenu「明細削除」の選択確認.
//		 *
//	     * @param e ContextMenuのイベント.
//		 */
//		protected function onMenuSelect_transportDelete(e:Event):void
//		{
//			Alert.show("削除するとデータは元に戻りませんが\n削除してもよろしいですか？", "", 3, view, onMenuSelect_transportDelete_confirmResult);
//		}
//		/**
//		 * ContextMenu「明細削除」.
//		 *
//		 * @param e Closeイベント.
//		 */
//		protected function onMenuSelect_transportDelete_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES) {
//				onItemClick_linkList_delete();
//			}
//		}
//// 2009/03/26 end   登録のタイミングで削除するようにする.
		/**
		 * ContextMenu「明細削除」の選択確認.
		 *
	     * @param e ContextMenuのイベント.
		 */
		protected function onMenuSelect_transportDelete2(e:Event):void
		{
			onClick_linkList_delete2();
		}

		/**
		 * ContextMenu「明細コピー」の選択確認.
		 *
	     * @param e ContextMenuのイベント.
		 */
		protected function onMenuSelect_transportCopy(e:Event):void
		{
			onClick_linkList_copy();
		}

		/**
		 * ヘルプメニュー選択.
		 *
		 * @param e ContextMenuEvent.
		 */
		 override protected function onMenuSelect_help(e:ContextMenuEvent):void
		 {
			// ヘルプ画面を表示する.
		 	opneHelpWindow("TransportEntry");
		 }

		/**
		 * ヘルプボタンのクリックイベント.
		 *
		 * @param event MouseEvent
		 */
		public function onClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			opneHelpWindow("TransportEntry");
		}

		/**
		 * ProjectSelect（プロジェクト選択）のクローズ.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_projectSelect(e:CloseEvent):void
		{
			// TransportEntryBatchのOKボタンを押下したとき.
			if (e.detail == PopUpWindow.ENTRY) {
				view.linkProject.label = _selectedTransportDto.project.projectCode
										+ "　" + _selectedTransportDto.project.projectName;
			}
//			super.onClose_popupEntry(e);
		}

		/**
		 * TransportEntryBatchのClose処理.
		 *
	     * @param e PopupManagerのCloseイベント.
		 */
		protected function onClose_batchEntry(e:CloseEvent):void
		{
			// TransportEntryBatchのOKボタンを押下したとき.
			if (e.detail == PopUpWindow.ENTRY) {
				var pop:TransportEntryBatch = e.currentTarget as TransportEntryBatch;

				// 選択日付のリストを作成する.
				var dateList:ArrayCollection = new ArrayCollection();
				var popItems:Array = pop.dateChooser.selectedRanges as Array;

				// 選択した日付を取得する.
				for each (var popItem:Object in popItems) {
					var end  :Date = popItem.rangeEnd;
					var start:Date = popItem.rangeStart;

					// 基準日付を取得する.
					var sYear :Number = start.getFullYear();
					var sMonth:Number = start.getMonth();
					var sDate :Number = start.getDate();

					// 選択期間（日）を計算する.
					var msecond:Number = end.time - start.time;
					var itemRange:int  = msecond / (24*60*60*1000);

					// 選択日付をリストに追加する.
					for (var range:int = 0; range <= itemRange; range++) {
						var date:Date = new Date(sYear, sMonth, sDate + range);
						dateList.addItem(date);
					}
				}


				// 明細一覧データを取得する.
				var list:ArrayCollection = ObjectUtil.copy(view.transportationDetail.dataProvider) as ArrayCollection;
				var indices:Array = view.transportationDetail.selectedIndices;

				// 一覧表を作成する.
				var ac:ArrayCollection = new ArrayCollection();
				var listIndex:int = INDEX_INVALID;
				var insertIndices:Array = new Array();						// 追加したIndexリスト.

				var insertIndex:int = INDEX_INVALID;
				for each (var transDetail:TransportationDetailDto in list) {
					listIndex++;

					// 選択行かどうかを確認する.
					var isSelected:Boolean = false;
					for each (var index:int in indices) {
						if (listIndex == index) {
							// 選択行を追加する.
							ac.addItem(transDetail);

							// 選択行をコピーし、明細行を追加する.
							for each (var date2:Date in dateList) {
								var cpTransDetail:TransportationDetailDto = transDetail.copyTransportationDetail(date2);
								ac.addItem(cpTransDetail);
								insertIndex = listIndex + insertIndices.length + 1;
								insertIndices.push(insertIndex);
							}
							isSelected = true;
							break;
						}
					}

					// 選択行でないとき、空行も追加する.
					if (!isSelected) {
						if (transDetail) {
							ac.addItem(transDetail);
						}
					}
				}

				// 交通費明細一覧を設定する.
				view.transportationDetail.dataProvider = makeTable_transportationDetail(ac);
				view.transportationDetail.validateNow();
				view.transportationDetail.selectedIndices = insertIndices;	// 追加したIndexを選択表示.
				view.transportationDetail.scrollToIndex(insertIndex);
				setContextMenu_transportationDetail();						// コンテキストメニュー設定.
				setRpLinkList_transportationDetail();						// リンクボタン設定.
			}
		}

		/**
		 * ルート登録のClose.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_routeEntry(e:CloseEvent):void
		{
			// 登録前の画面をそのまま表示するため 後処理は何もしない.

			// 本画面を表示する.
			view.visible = true;
		}

		/**
		 * ルート検索のClose.
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_routeSearch(e:CloseEvent):void
		{
			// RouteSearchの設定ボタンを押下したとき.
			if (e.detail == PopUpWindow.ENTRY) {
				var pop:RouteSearch = e.currentTarget as RouteSearch;

				// RouteSearch で 選択したデータを取得する.
				var popRouteList:ArrayCollection = pop.routeDetail.dataProvider as ArrayCollection;
				var popIndices:Array = pop.data.insertIndices;

				// 明細一覧データを取得する.
				var list:ArrayCollection = ObjectUtil.copy(view.transportationDetail.dataProvider) as ArrayCollection;

				// 一覧表を作成する.
				var ac:ArrayCollection = new ArrayCollection();
				var listIndex:int = INDEX_INVALID;							// ListIndex.
				var insertIndices:Array = new Array();						// 追加したIndexリスト.

				var insertIndex:int = INDEX_INVALID;
				for each (var transDetail:TransportationDetailDto in list) {
					listIndex++;

					// 選択行かどうかを確認する.
					var isSelected:Boolean = false;
					for each (var popIndex:int in popIndices) {
						if (listIndex == popIndex) {
							// 選択行を削除リストに追加する.
							_deleteTransDetailList.addItem(transDetail);

							// 選択行をコピーし、明細行を追加する.
							for each (var route:RouteDetailDto in popRouteList) {
								var cpTransDetail:TransportationDetailDto = transDetail.copyRouteDetail(route);
								ac.addItem(cpTransDetail);
								insertIndex = listIndex + insertIndices.length - (int)(insertIndices.length / popRouteList.length);
								insertIndices.push(insertIndex);
							}
							isSelected = true;
							break;
						}
					}

					// 選択行でないとき、空行も追加する.
					if (!isSelected) {
						if (transDetail) {
							ac.addItem(transDetail);
						}
					}
				}

				// リンクボタンから「経路検索」を行なうと 選択Index が listIndex を over することがある.
				// overしてるときは 検索データを追加する.
				for each (var overIndex:int in popIndices) {
					if (overIndex > listIndex) {
						for each (var overRoute:RouteDetailDto in popRouteList) {
							var overTransDetail:TransportationDetailDto = new TransportationDetailDto();
							ac.addItem(overTransDetail.copyRouteDetail(overRoute));
							insertIndex = listIndex + insertIndices.length + 1;
							insertIndices.push(insertIndex);
						}
					}
				}


				// 交通費明細一覧を設定する.
				view.transportationDetail.dataProvider = makeTable_transportationDetail(ac);
				view.transportationDetail.validateNow();
				view.transportationDetail.selectedIndices = insertIndices;	// 追加したIndexを選択表示.

				// 最終行への追加ならば行を追加する.
				var transport:TransportationDetailDto =
					view.transportationDetail.dataProvider.getItemAt(view.transportationDetail.dataProvider.length-1) as TransportationDetailDto;
				if (transport.checkEntry()) {
					onClick_linkList_add();
				} else {
					view.transportationDetail.scrollToIndex(insertIndex);
					setContextMenu_transportationDetail();						// コンテキストメニュー設定.
					setRpLinkList_transportationDetail();						// リンクボタン設定.
				}
			}

			// 本画面を表示する.
			view.visible = true;
		}

		/**
		 * 「登録」ボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_entry_confirm(e:Event):void
		{
			if (_selectedTransportDto.project != null) {
				Alert.show("登録してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
			} else {
				Alert.show("プロジェクトを選択してください。");
			}
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);				// 登録.
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// 登録データを作成する.
			var entryList:ArrayCollection = view.transportationDetail.dataProvider as ArrayCollection;
			var project:Object = new Object();
			project.data = _selectedTransportDto.projectId;
			var entryDto:TransportationDto = _selectedTransportDto.entryTransportation(entryList, project);

			// 削除データを追加する.（経路検索で選択した行のデータ）.
			entryDto.addDeleteTransportationDetail(_deleteTransDetailList);

			// 交通費申請を登録する.
			view.srv.getOperation("createTransportation").send(Application.application.indexLogic.loginStaff, entryDto);
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e イベント.
		 */
//		public function onButtonClick_close_confirm(e:Event):void
//		{
//			Alert.show("編集中のデータは破棄されますがよろしいですか？", "", 3, view, onButtonClick_close_confirmResult);
//		}
//		protected function onButtonClick_close_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES)	onButtonClick_close(e);				// クローズ.
//		}
		public function onButtonClick_close(e:Event):void
		{
			if (_reload)			view.closeWindow(PopUpWindow.ENTRY);
			else					view.closeWindow();
		}


		/**
		 * createTransportation(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_createTransportation(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * deleteTransportationDetails(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_deleteTransportationDetails(e:ResultEvent):void
//		{
//			// 選択行を取得する.
//			var targetItems:Array = view.transportationDetail.selectedItems;
//
//			// 明細一覧から選択行と一致するデータを取得し削除する.
//			var ac:ArrayCollection = ObjectUtil.copy(view.transportationDetail.dataProvider) as ArrayCollection;
//			for each (var target:TransportationDetailDto in targetItems) {
//				var index:int = 0;
//				for each (var data:TransportationDetailDto in ac) {
//					if (ObjectUtil.compare(target, data) == 0) {
//						ac.removeItemAt(index);
//						break;
//					}
//					index++;
//				}
//			}
//
//			// 交通費明細一覧を設定する.
//			view.transportationDetail.dataProvider = makeTable_transportationDetail(ac);
//			setContextMenu_transportationDetail();
//			setRpLinkList_transportationDetail();
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.

// 2009.03.13 プロジェクト選択画面作成に伴い廃止
//		/**
//		 * getBelongProjectList(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_getBelongProjectList(e:ResultEvent):void
//		{
//			// プロジェクトリストを取得する.
//			_projectList = e.result as ArrayCollection;
//			if (!(_projectList && _projectList.length > 0)) {
//				Alert.show("所属プロジェクトがありません。\n所属プロジェクトを登録してください。");
//				popupClose(view);
//				return;
//			}
//			view.project.dataProvider = _projectList;
//
//
//			// 交通費申請情報で指定されたプロジェクトを選択状態にする.
//			if (ObjectUtil.compare(_actionMode, ACTION_UPDATE) == 0) {
//				view.linkProject.label = _selectedTransportDto.project.projectCode
//									+ "　" + _selectedTransportDto.project.projectName;
//			} else {
//				view.linkProject.label = "ここをクリックしてプロジェクトを選択してください...";
//			}
//		}

		/**
		 * createTransportationの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_createTransportation(e:FaultEvent):void
		{
			var conflict:Boolean = super.onFault_updateXxxxx(e, true, "登録");
			if (conflict)		_reload = true;
		}

// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * deleteTransportationDetailsの呼び出し失敗.
//		 *
//		 * @param e FaultEvent
//		 */
//		public function onFault_deleteTransportationDetails(e:FaultEvent):void
//		{
//			super.onFault_updateXxxxx(e, true, "明細削除");
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.

// 2009.03.13 プロジェクト選択画面作成に伴い廃止
//		/**
//		 * getBelongProjectListの呼び出し失敗.
//		 *
//		 * @param e FaultEvent
//		 */
//		public function onFault_getBelongProjectList(e:FaultEvent):void
//		{
//			super.onFault_getXxxxx(e, true, "所属プロジェクト");
//			super.popupClose(view);
//		}

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 交通費申請明細一覧行数の調整.
		 *
		 * @param  ac 交通費申請明細リスト.
		 * @return 調整済みの交通費申請明細リスト.
		 */
		private function makeTable_transportationDetail(ac:ArrayCollection):ArrayCollection
		{
			// 一覧表示行分のデータを作成する.
			var copy:ArrayCollection = ac ? ObjectUtil.copy(ac) as ArrayCollection : new ArrayCollection();
			var acLength:int         = ac ? ac.length                              : 0;
			for (var i:int = 0; i < (ROW_COUNT_EDIT - acLength) ; i++) {
				var dto:TransportationDetailDto = new TransportationDetailDto();
				copy.addItem(dto);
			}

			// index >= ROW_COUNT_EDIT の空データを削除する.
			var cpLength:int = copy.length;
			for (var lastIndex:int = cpLength - 1; lastIndex >= ROW_COUNT_EDIT; lastIndex--) {
				var trans:TransportationDetailDto = copy.getItemAt(lastIndex) as TransportationDetailDto;
				if (trans && trans.checkEntry()) 		break;
				copy.removeItemAt(lastIndex);
			}
			return copy;
		}

		/**
		 * 交通費明細一覧 コンテキストメニューの作成.
		 *
		 */
		private function createContextMenu_transportDetail():ContextMenu
		{
			// コンテキストメニューを作成する.
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// コンテキストメニュー：明細削除.
			var cmItem_delete:ContextMenuItem = new ContextMenuItem(CMENU_TRANSPORT_DELETE);
			cmItem_delete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_transportDelete2);
			contextMenu.customItems.push(cmItem_delete);

			// コンテキストメニュー：明細一括入力.
			var cmItem_entry:ContextMenuItem = new ContextMenuItem(CMENU_TRANSPORT_COPY);
			cmItem_entry.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_transportCopy);
			contextMenu.customItems.push(cmItem_entry);

			// メニューを区切る.

			// コンテキストメニュー：ルート検索.
			var cmItem_rsearch:ContextMenuItem = new ContextMenuItem(CMENU_ROUTE_SEARCH);
			cmItem_rsearch.separatorBefore = true;
			cmItem_rsearch.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_routeSearch);
			contextMenu.customItems.push(cmItem_rsearch);

			// コンテキストメニュー：ルート登録.
			var cmItem_rentry:ContextMenuItem = new ContextMenuItem(CMENU_ROUTE_ENTRY);
			cmItem_rentry.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_routeEntry);
			contextMenu.customItems.push(cmItem_rentry);

			// コンテキストメニューを返す.
			return contextMenu;
		}

		/**
		 * 交通費明細一覧 コンテキストメニューの有効／無効設定.
		 *
		 */
		private function setContextMenu_transportationDetail():void
		{
			// 有効メニューを作成する.
			var enabledItems:Array = new Array();

			// 選択された交通費情報に応じて有効/無効を設定する.
			var transportItems:Array = view.transportationDetail.selectedItems;
			if (transportItems && transportItems.length > 0) {
				enabledItems.push(CMENU_TRANSPORT_DELETE);
				enabledItems.push(CMENU_ROUTE_ENTRY);
				enabledItems.push(CMENU_ROUTE_SEARCH)

				// 明細行コピーは選択行がチェックOKのとき 有効にする.
				var enabled:Boolean = true;
				for each (var transport:TransportationDetailDto in transportItems) {
					// 選択行全てチェックOKのとき 有効にする.
					if (!transport.checkEntryBatch()) {
						enabled = false;
						break;
					}
				}
				if (enabled) {
					enabledItems.push(CMENU_TRANSPORT_COPY);
				}
			}
			setEnabledContextMenu(view.transportationDetail.contextMenu as ContextMenu, enabledItems);
		}

		/**
	     * 交通費明細一覧 リンクボタン設定.
	     *
	     */
	     private function setRpLinkList_transportationDetail():void
	     {
			view.rpLinkList.dataProvider = getRpLinkList_transportationDetail();
	     }

		/**
		 * 交通費明細一覧 リンクボタン取得.
		 *
		 * @return リンクボタンリスト.
		 */
		private function getRpLinkList_transportationDetail():ArrayCollection
		{
			// 実行可能なリンクボタンを設定する.
			var rplist:ArrayCollection = ObjectUtil.copy(RP_LINKLIST) as ArrayCollection;
			var transportItems:Array = view.transportationDetail.selectedItems;
			if (transportItems && transportItems.length > 0) {
				for (var index:int = 0; index < rplist.length; index++) {
					// リンクボタンのリストを取得する.
					var linkObject:Object   = rplist.getItemAt(index);
					// 各状態を確認する.
					if (!linkObject.enabledCheck)	continue;

					// 明細行コピーは選択行がチェックOKのとき 有効にする.
					if (linkObject.id == "copy") {
						linkObject.enabled = true;
						for each (var transport:TransportationDetailDto in transportItems) {
							// NGがあるときは 無効にする.
							if (!transport.checkEntryBatch()) {
								linkObject.enabled = false;
								break;
							}
						}
					}
					// 明細行削除は選択されたら 有効にする.
					else if (linkObject.id == "delete") {
						linkObject.enabled = true;
					}
					// 経路登録は選択されたら 有効にする.
					else if (linkObject.id == "entry") {
						linkObject.enabled = true;
					}
					// リンクボタンのリストを設定する.
					rplist.setItemAt(linkObject, index);
				}
			}
			return rplist;
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:TransportEntry;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():TransportEntry
	    {
	        if (_view == null) {
	            _view = super.document as TransportEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:TransportEntry):void
	    {
	        _view = view;
	    }
	}
}