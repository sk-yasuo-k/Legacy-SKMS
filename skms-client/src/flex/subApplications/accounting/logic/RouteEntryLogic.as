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
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.RouteDetailDto;
	import subApplications.accounting.dto.RouteDto;
	import subApplications.accounting.web.RouteEntry;

	/**
	 * RouteEntryのLogicクラスです.
	 */
	public class RouteEntryLogic extends AccountingLogic
	{
		/** 引き継いだ経路情報 */
		private var _entryItems:Array;

		/** 取得した経路情報リスト */
		private var _routeList:ArrayCollection;

		/** 経路Index */
		protected var _previousRouteIndex:int = INDEX_INVALID;

		/** 削除予定の経路リスト */
		private var _deleteRouteList:ArrayCollection = new ArrayCollection();

		/** 削除予定の経路詳細リスト */
		private var _deleteRouteDetailList:ArrayCollection = new ArrayCollection();

		/** 経路一覧 リンクボタンリスト */
		private const RP_LINKROUTE:ArrayCollection
			= new ArrayCollection([
//				{label:"経路追加",	toolTip:"空行を追加する",		func:"onClick_linkList_add",		enabled:true,	enabledCheck:false},
				{label:"経路削除",	toolTip:"選択行を削除する",	func:"onClick_linkList_delete2",	enabled:false,	enabledCheck:true}
			]);

		/** 経路詳細一覧 リンクボタンリスト */
		private const RP_LINKROUTE_DETAIL:ArrayCollection
			= new ArrayCollection([
//				{id:"add",		label:"経路詳細追加",	toolTip:"空行を追加する",					func:"onClick_linkList2_add",		enabled:false,	enabledCheck:true},
				{id:"delete",	label:"経路詳細削除",	toolTip:"選択行を削除する",				func:"onClick_linkList2_delete2",	enabled:false,	enabledCheck:true},
				{id:"guide",	label:"乗り換え案内を開く",	toolTip:"Infoseek乗換案内を表示する",	func:"onClick_linkList2_guide",		enabled:true,	enabledCheck:false}
			]);

		/** コンテキストメニュー：経路削除 */
		private const CMENU_ROUTE_DELETE:String         = "経路削除";
		/** コンテキストメニュー：経路詳細削除 */
		private const CMENU_ROUTE_DETAIL_DELETE:String  = "経路詳細削除";


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function RouteEntryLogic()
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

			// 登録ボタンを押下不可にする.
			view.btnEntry.enabled = false;
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
			_entryItems = view.data.entryItems;
	    	_actionMode = AccountingLogic.ACTION_ROUTE_ENTRY;
	    	_facilityNameList = view.data.facilities;
		}

	    /**
	     * 表示データの設定.
	     *
	     */
	    override protected function onCreationCompleteHandler_setDisplayData():void
	    {
			// 経路一覧の初期データを設定する.
			view.route.actionMode = _actionMode;

	    	// 詳細一覧の初期データを設定する.
	    	view.routeDetail.actionMode = _actionMode;
			view.routeDetail.facilities = _facilityNameList;

			// 経路リストを取得する.
			view.srv.getOperation("getRoutes").send(Application.application.indexLogic.loginStaff);
	    }

		/**
		 * コンテキストメニューの作成.
		 *
		 */
		override protected function onCreationCompleteHandler_setContextMenu():void
		{
			// 経路一覧のコンテキストメニューを作成する.
			view.route.contextMenu = createContextMenu_route();
			setContextMenu_route();

			// 経路詳細一覧のコンテキストメニューを作成する.
			view.routeDetail.contextMenu = createContextMenu_routeDetail();
			setContextMenu_routeDetail();
		}


//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 登録ボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_entry_confirm(e:Event):void
		{
			Alert.show("登録してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);				// 登録.
		}
		protected function onButtonClick_entry(e:Event):void
		{
// 2009.04.03 start 詳細一覧のデータ表示方法の変更.
//			// 編集中の経路詳細を取得する.
//			updateRoute_setRouteDetails();
//
//			// 登録データを作成する.
//			var routeList:ArrayCollection = view.route.dataProvider as ArrayCollection;
//			var entryList:ArrayCollection = new ArrayCollection();
//			for (var i:int = 0; i < routeList.length; i++) {
//				var route:RouteDto = routeList.getItemAt(i) as RouteDto;
//				var entryDto:RouteDto = route.entryRoute();
//				if (entryDto) {
//					entryList.addItem(entryDto);
//				}
//			}
// 2009.04.03 end   詳細一覧のデータ表示方法の変更.

			// 登録データを作成する.
			var routeList:ArrayCollection = view.route.dataProvider as ArrayCollection;
			var routDList:ArrayCollection = ObjectUtil.copy(view.routeDetail.dataProvider) as ArrayCollection;
			var entryList:ArrayCollection = new ArrayCollection();
			for (var i:int = 0; i < routeList.length; i++) {
				var route:RouteDto = routeList.getItemAt(i) as RouteDto;
				var entryDto:RouteDto = route.entryRoute(routDList);
				if (entryDto) {
					entryList.addItem(entryDto);
				}
			}


			// 削除データを追加する.
			for (var k:int = 0; k < _deleteRouteList.length; k++) {
				// 削除経路を追加する.
				entryList.addItem(_deleteRouteList.getItemAt(k));
			}
			for (var n:int = 0; n < _deleteRouteDetailList.length; n++) {
				var child:RouteDetailDto = _deleteRouteDetailList.getItemAt(n) as RouteDetailDto;
				for (var j:int = 0; j < entryList.length; j++) {
					// 削除詳細経路を追加する.
					var parent:RouteDto = entryList.getItemAt(j) as RouteDto;
					if (parent.isChild(child)) {
						parent.routeDetails.addItem(child);
					}
				}
			}

			if (entryList.length > 0) {
				// 経路を登録する.
				view.srv.getOperation("createRoutes").send(Application.application.indexLogic.loginStaff, entryList);
			}
			else {
				view.closeWindow(PopUpWindow.ENTRY);
			}
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e Closeイベント.
		 */
		public function onButtonClick_close_confirm(e:Event):void
		{
			Alert.show("編集中のデータは破棄されますがよろしいですか？", "", 3, view, onButtonClick_close_confirmResult);
		}
		protected function onButtonClick_close_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_close(e);				// クローズ.
		}
		public function onButtonClick_close(e:Event):void
		{
			view.closeWindow();
		}

//		/**
//		 * Closeボタンの押下.
//		 *
//		 * @param e Closeイベント.
//		 */
//		public function onCloseButtonClick(e:CloseEvent):void
//		{
//			super.popupRemove(view);
//		}

// 2009.04.03 start 詳細一覧のデータ表示方法の変更.
//		/**
//		 * ドラッグ開始.
//		 *
//		 * @param e DragEvent
//		 */
//		public function onDragStart_route(e:Event):void
//		{
//			// trace ("start " + "select:" + view.route.selectedIndex + " " + "pre:" + getPreviousRouteIndex());
//			// 編集データを保持する.
//			updateRoute_setRouteDetails(getPreviousRouteIndex());
//			setPreviousRouteIndex(INDEX_INVALID);
//		}
// 2009.04.03 end   詳細一覧のデータ表示方法の変更.

		/**
		 * 経路一覧 ドロップIndexの設定.
		 *
		 * @param e Event
		 */
		public function onSetDropIndex_route(e:Event):void
		{
			// 経路一覧を選択した状態と同じにする.
			onChange_route(e);
		}

		/**
		 * 経路詳細一覧 ドロップIndexの設定.
		 *
		 * @param e Event
		 */
		public function onSetDropIndex_routeDetail(e:Event):void
		{
			// 有効なリンクボタンを設定する.
			setRpLinkList_routeDetail();
		}


		/**
		 * 経路一覧 ドラッグデータ通知.
		 *
		 * @param e DragEvent
		 */
		public function onDragSource_route(e:DragEvent):void
		{
			// ドラッグデータの取得.
			var items:Array = e.dragSource.dataForFormat("items") as Array;
			if (!items)			return;

			// コピーした経路の経路詳細に追加する.
			// →移動した経路の経路詳細は 詳細一覧に設定済みのため追加の必要はない.
			if (!e.ctrlKey)		return;
			var routeDList:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
			for (var i:int = 0; i < items.length; i++) {
				var route:RouteDto = items[i] as RouteDto;
				if (route && route.routeDetails) {
					// 経路詳細を追加する.
					for (var k:int = 0; k < route.routeDetails.length; k++) {
						routeDList.addItem(route.routeDetails.getItemAt(k));
					}
					// 空データを追加する.
					for (var n:int = 0; n < (ROW_COUNT_EDIT - route.routeDetails.length); n++) {
						routeDList.addItem(RouteDetailDto.newRouteDetail(route.routeId));
					}
				}
			}
		}

//		/**
//		 * キー押下 経路一覧行の選択.
//		 *
//		 * @param e KeyboardEvent
//		 */
//		public function onKeyDown_route(e:KeyboardEvent):void
//		{
//			if (e.target is DataGrid) {
//				switch (e.keyCode) {
//					case Keyboard.UP:
//					case Keyboard.DOWN:
//						onChange_route(e);
//						break;
//				}
//			}
//		}
//
//		/**
//		 * フォーカスイン 経路一覧.
//		 *
//		 * @param e FocusEvent
//		 */
//		public function onFocusIn_route(e:FocusEvent):void
//		{
//			// trace ("onFocusIn_route " + e.toString());
//			if (e.target is DataGrid) {
//				// DataGrid以外からフォーカスインしたとき すぐに選択行が取得できないため.
//				// 少し遅らせて選択行を取得する.
//				var args:Array = new Array();
//				args.push(e);
//				view.route.callLater(onChange_route, args);
//			}
//			else if (e.target is TextInput){
//				onChange_route(e);
//			}
//		}
//

// 2009.04.03 start 詳細一覧のデータ表示方法の変更.
//		/**
//		 * 経路一覧の選択変更.
//		 * Multi選択はOFFのため、1行しか選択されない.
//		 * →Multi選択をONにすると、明細追加時にどのデータに追加してよいか判断できない.
//		 *
//		 * @param e ListEvent or Event.
//		 */
//		public function onChange_route(e:Event):void
//		{
//			// trace ("click " + "select:" + view.route.selectedIndex + " " + "pre:" + getPreviousRouteIndex());
//			// trace ("onItemClick_route " + e.toString());
//			// 編集データを保持する.
//			updateRoute_setRouteDetails(getPreviousRouteIndex());
//			setPreviousRouteIndex();
//
//			// 経路一覧を設定する.
//			setRpLinkList_route();
//			setContextMenu_route();
//
//			// 経路詳細一覧を設定する.
//			var item:RouteDto = view.route.selectedItem as RouteDto;
//			view.routeDetail.dataProvider = makeTable_routeDetail(item.routeDetails);
//			setRpLinkList_routeDetail();
//			setContextMenu_routeDetail();
//
//			// TAB or Enter で選択行を移動すると画面が更新されないため再描画する.
//			view.route.validateNow();
//			view.routeDetail.validateNow();
//		}
// 2009.04.03 end   詳細一覧のデータ表示方法の変更.

		/**
		 * 経路一覧の選択変更.
		 * Multi選択はOFFのため、1行しか選択されない.
		 * →Multi選択をONにすると、明細追加時にどのデータに追加してよいか判断できない.
		 *
		 * @param e ListEvent or Event.
		 */
		public function onChange_route(e:Event):void
		{
			// 経路一覧を設定する.
			setRpLinkList_route();
			setContextMenu_route();

			// 経路詳細一覧を設定する.
			var routeDList:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
			routeDList.filterFunction = filter_routeDetail;
			routeDList.refresh();
			setRpLinkList_routeDetail();
			setContextMenu_routeDetail();

			// TAB or Enter で選択行を移動すると画面が更新されないため再描画する.
			view.route.validateNow();
			view.routeDetail.validateNow();
		}

		/**
		 * 経路一覧の選択終了.
		 *
		 * @param e DataGridEvent
		 */
		public function onItemFocusOut_route(e:DataGridEvent):void
		{
			// 経路を追加する.
			var ac:ArrayCollection = view.route.dataProvider as ArrayCollection;
			if (ac.length == view.route.selectedIndex+1) {
				var route:RouteDto =
				view.route.dataProvider.getItemAt(view.route.selectedIndex) as RouteDto;
				if (route.checkEntry()) {
					ac.addItem(new RouteDto());
				}
			}
        }

		/**
		 * 経路一覧 リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		override public function onClick_linkList(e:MouseEvent):void
		{
//			super.onClick_linkList(e);
//			_selectedLinkObject = RP_LINKROUTE.getItemAt(e.target.instanceIndex);
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
	     * 経路一覧 リンクボタン選択 確認結果.<br>
	     *
	     * @param e ItemClickEvent
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
		 * 経路一覧 リンクボタン選択 経路追加.
		 *
		 * @param e ItemClickEvent
		 */
		protected function onClick_linkList_add():void
		{
			// 経路を追加する.
			var ac:ArrayCollection = view.route.dataProvider as ArrayCollection;
			ac.addItem(new RouteDto());
		}

// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * 経路一覧 リンクボタン選択 経路削除.
//		 *
//		 * @param e Event
//		 */
//		protected function onItemClick_linkList_delete_confirm(e:Event):void
//		{
//			Alert.show("削除するとデータは元に戻りませんが\n削除してもよろしいですか？", "", 3, view, onItemClick_linkList_confirmResult);
//		}
//		public function onItemClick_linkList_delete():void
//		{
//			// 経路を削除する.
//			var item:RouteDto = view.route.selectedItem as RouteDto;
//			view.srv.getOperation("deleteRoute").send(Application.application.indexLogic.loginStaff, item);
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.
		/**
		 * 経路一覧 リンクボタン選択 経路削除.
		 *
		 */
		public function onClick_linkList_delete2():void
		{
			var indices:Array = view.route.selectedIndices;
			indices.sort(Array.NUMERIC | Array.DESCENDING);

			// 選択last行から削除リストに追加する.
			var list:ArrayCollection = view.route.dataProvider as ArrayCollection;
			for (var i:int = 0; i < indices.length; i++) {
				var index:int = indices[i];
				var item:RouteDto = list.getItemAt(index) as RouteDto;
				item.setDelete();
				_deleteRouteList.addItem(item);
				list.removeItemAt(index);
			}

// 2009.04.03 start 詳細一覧のデータ表示方法の変更.
//			// 経路一覧を設定する.
//			view.route.dataProvider = makeTable_route(list);
//			setRpLinkList_route();
//			setContextMenu_route();
//
//			// 経路詳細一覧を設定する.
//			view.routeDetail.dataProvider = new ArrayCollection();
//			setRpLinkList_routeDetail();
//			setContextMenu_routeDetail();
//
//			// 選択Indexを初期化する.
//			setPreviousRouteIndex();
// 2009.04.03 end   詳細一覧のデータ表示方法の変更.

			// 経路一覧を設定する.
			view.route.dataProvider = makeTable_route2(list);
			setRpLinkList_route();
			setContextMenu_route();

			// 経路詳細一覧を設定する.
			var routeDList:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
			routeDList.filterFunction = filter_routeDetail;
			routeDList.refresh();
			setRpLinkList_routeDetail();
			setContextMenu_routeDetail();

		}

//		/**
//		 * フォーカスイン 経路詳細一覧.
//		 *
//		 * @param e FocusEvent
//		 */
//		public function onFocusIn_routeDetail(e:FocusEvent):void
//		{
//			if ( e.target is DataGrid) {
//				// DataGrid以外からフォーカスインしたとき すぐに選択行が取得できないため.
//				// 少し遅らせて選択行を取得する.
//				var args:Array = new Array();
//				args.push(e);
//				view.routeDetail.callLater(onItemClick_routeDetail, args);
//			}
//			else if (e.target is TextInput || e.target is ComboBox){
//				onItemClick_routeDetail(e);
//			}
//		}
//
		/**
		 * 経路詳細一覧の選択変更.
		 * Multi選択はONのため、複数行選択される.
		 *
		 * @param e ListEvent or FocusEvent.
		 */
		public function onChange_routeDetail(e:Event):void
		{
			// 経路詳細一覧を設定する.
			setRpLinkList_routeDetail();
			setContextMenu_routeDetail();
		}

		/**
		 * 経路詳細一覧の選択終了.
		 *
		 * @param e DataGridEvent
		 */
		public function onItemFocusOut_routeDetail(e:DataGridEvent):void
		{
//			// 経路詳細を追加する.
//			var ac:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
//			if (ac.length == view.routeDetail.selectedIndex+1) {
//				var routeDetail:RouteDetailDto =
//				view.routeDetail.dataProvider.getItemAt(view.routeDetail.selectedIndex) as RouteDetailDto;
//				if (routeDetail.checkEntry()) {
//					ac.addItem(new RouteDetailDto());
//				}
//			}

			// 経路詳細を追加する.
			var ac:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
			if (ac.length == view.routeDetail.selectedIndex+1) {
				var routeDetail:RouteDetailDto =
				view.routeDetail.dataProvider.getItemAt(view.routeDetail.selectedIndex) as RouteDetailDto;
				if (routeDetail.checkEntry()) {
					ac.addItem(RouteDetailDto.newRouteDetail(view.route.selectedItem.routeId));
				}
			}
        }

		/**
		 * 経路詳細一覧 リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList2(e:MouseEvent):void
		{
//			super.onClick_linkList(e);
//			_selectedLinkObject = RP_LINKROUTE_DETAIL.getItemAt(e.target.instanceIndex);
			_selectedLinkObject = view.rpLinkList2.dataProvider.getItemAt(e.target.instanceIndex);
			// 選択したリンクボタンの処理を呼び出す.
			if (_selectedLinkObject.hasOwnProperty("prepare")) {
				this[_selectedLinkObject.prepare](e);
			}
			else {
				this[_selectedLinkObject.func]();
			}
		}

	    /**
	     * 経路詳細一覧 リンクボタン選択 確認結果.<br>
	     *
	     * @param e ItemClickEvent
	     */
		protected function onClick_linkList2_confirmResult(e:CloseEvent):void
		{
			onClick_linkList_confirmResult(e);
		}

	    /**
	     * 経路詳細一覧 リンクボタン選択 経路詳細追加.
	     *
	     */
		protected function onClick_linkList2_add():void
		{
			// 経路詳細を追加する.
			var ac:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
			ac.addItem(new RouteDetailDto());
		}

// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * 経路詳細一覧 リンクボタン選択 経路詳細削除.
//		 *
//	     * @param e ItemClickEvent.
//		 */
//		protected function onItemClick_linkList2_delete_confirm(e:Event):void
//		{
//			Alert.show("削除するとデータは元に戻りませんが\n削除してもよろしいですか？", "", 3, view, onItemClick_linkList_confirmResult);
//		}
//		protected function onItemClick_linkList2_delete():void
//		{
//			// 選択行を取得する.
//			var items:Array = ObjectUtil.copy(view.routeDetail.selectedItems) as Array;
//
//			// 削除リストを作成する.
//			var deleteItems:Array = new Array();
//			for each (var item:RouteDetailDto in items) {
//				item.setDelete();
//				deleteItems.push(item);
//			}
//			view.srv.getOperation("deleteRouteDetails").send(Application.application.indexLogic.loginStaff, deleteItems);
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.
		/**
		 * 経路詳細一覧 リンクボタン選択 経路詳細削除.
		 *
		 */
		protected function onClick_linkList2_delete2():void
		{
			var indices:Array = view.routeDetail.selectedIndices;
			indices.sort(Array.NUMERIC | Array.DESCENDING);

			// 選択last行から削除リストに追加する.
			var list:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
			for (var i:int = 0; i < indices.length; i++) {
				var index:int = indices[i];
				var item:RouteDetailDto = list.getItemAt(index) as RouteDetailDto;
				item.setDelete();
				_deleteRouteDetailList.addItem(item);
				list.removeItemAt(index);
				list.addItem(RouteDetailDto.newRouteDetail(item.routeId));
			}

// 2009.04.03 start 詳細一覧のデータ表示方法の変更.
//			// 経路詳細一覧を設定する.
//			view.routeDetail.dataProvider = makeTable_routeDetail(list);
//			setRpLinkList_routeDetail();
//			setContextMenu_routeDetail();
// 2009.04.03 end   詳細一覧のデータ表示方法の変更.

			// 経路詳細一覧を設定する.
			list.filterFunction = filter_routeDetail;
			list.refresh();
			setRpLinkList_routeDetail();
			setContextMenu_routeDetail();
		}

		/**
		 * 経路詳細一覧 リンクボタン選択 乗り換え案内.
		 *
		 */
		protected function onClick_linkList2_guide():void
		{
			// InfoSeekの乗り換え案内ページを表示する.
			openWindow_InfoSeek();
		}

// 2009.04.03 start 詳細一覧のデータ表示方法の変更.
//		/**
//		 * getRoutes(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_getRoutes(e:ResultEvent):void
//		{
//			// データベースの問い合わせ結果を取得する.
//			_routeList = e.result as ArrayCollection;
//
//			// TransportEntryLogicの引き継ぎデータを取得し、一覧表を作成する.
//			var ac:ArrayCollection = new ArrayCollection();
//			if (_entryItems) {
//				var entryRoute:RouteDto = RouteDto.createRoute(_entryItems);
//				ac.addItem(entryRoute);
//			}
//
//			// 一覧にデータベース経路を追加する.
//			for each (var route:RouteDto in _routeList) {
//				ac.addItem(route);
//			}
//			view.route.dataProvider = makeTable_route(ac);
//			setRpLinkList_route();
//
//
//			// 登録データを選択状態にする.
//			if (_entryItems) {
//				view.route.selectedIndex = 0;
//				onChange_route(new Event("onResult_getRoutes"));
//			}
//
//			// 登録ボタンを押下可能にする.
//			view.btnEntry.enabled = true;
//		}
// 2009.04.03 end   詳細一覧のデータ表示方法の変更.

		/**
		 * getRoutes(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_getRoutes(e:ResultEvent):void
		{
			// データベースの問い合わせ結果を取得する.
			_routeList = e.result as ArrayCollection;

			var ac:ArrayCollection = new ArrayCollection();
			// 交通費登録画面からの指定経路を追加する.
			if (_entryItems) {
				var entryRoute:RouteDto = RouteDto.newRoute(_entryItems);
				ac.addItem(entryRoute);
			}
			// データベース経路を追加する.
			for each (var route:RouteDto in _routeList) {
				ac.addItem(route);
			}
			// 経路一覧・詳細一覧を作成する.
			var routeList:ArrayCollection = makeTable_route2(ac);
			var routDList:ArrayCollection = makeTable_routeDetail2(routeList);


			// 経路一覧を設定する.
			view.route.dataProvider = routeList;
			setRpLinkList_route();

			// 経路詳細一覧を設定する.
			view.routeDetail.dataProvider = routDList;
			routDList.filterFunction = filter_routeDetail;
			routDList.refresh();


			// 指定経路を選択状態にする.
			if (_entryItems) {
				view.route.selectedIndex = 0;
				onChange_route(new Event("onResult_getRoutes"));
			}

			// 登録ボタンを押下不可にする.
			view.btnEntry.enabled = true;
		}

		/**
		 * createRoutes(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_createRoutes(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * deleteRoute(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_deleteRoute(e:ResultEvent):void
//		{
//			// 選択行を取得する.
//			var target:RouteDto = view.route.selectedItem as RouteDto;
//
//			// 一覧から選択行と一致するデータを取得し削除する.
//			var ac:ArrayCollection = ObjectUtil.copy(view.route.dataProvider) as ArrayCollection;
//			var index:int = INDEX_INVALID;
//			for each (var data:RouteDto in ac) {
//				index++;
//				if (ObjectUtil.compare(target, data) == 0) {
//					ac.removeItemAt(index);
//					break;
//				}
//			}
//
//			// 経路一覧を設定する.
//			view.route.dataProvider = makeTable_route(ac);
//			setRpLinkList_route();
//			setContextMenu_route();
//
//			// 経路詳細一覧を設定する.
//			view.routeDetail.dataProvider = new ArrayCollection();
//			setRpLinkList_routeDetail();
//			setContextMenu_routeDetail();
//
//			// 選択Indexを初期化する.
//			setPreviousRouteIndex();
//		}
//
//		/**
//		 * deleteRouteDetails(RemoteObject)の結果受信.
//		 *
//		 * @param e RPCの結果イベント.
//		 */
//		public function onResult_deleteRouteDetails(e:ResultEvent):void
//		{
//			// 選択行を取得する.
//			var targetItems:Array = view.routeDetail.selectedItems;
//
//			// 詳細一覧から選択行と一致するデータを取得し削除する.
//			var ac:ArrayCollection = ObjectUtil.copy(view.routeDetail.dataProvider) as ArrayCollection;
//			for each (var target:RouteDetailDto in targetItems) {
//				var index:int = INDEX_INVALID;
//				for each (var data:RouteDetailDto in ac) {
//					index++;
//					if (ObjectUtil.compare(target, data) == 0) {
//						ac.removeItemAt(index);
//						break;
//					}
//				}
//			}
//
//			// 経路詳細一覧を設定する.
//			view.routeDetail.dataProvider = makeTable_routeDetail(ac);
//			setRpLinkList_routeDetail();
//			setContextMenu_routeDetail();
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.


// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * 経路一覧 ContextMenu「経路削除」の選択確認.
//		 *
//	     * @param e ContextMenuのイベント.
//		 */
//		public function onMenuSelect_routeDelete_confirm(e:ContextMenuEvent):void
//		{
//			Alert.show("削除するとデータは元に戻りませんが\n削除してもよろしいですか？", "", 3, view, onMenuSelect_routeDelete_confirmResult);
//		}
//		protected function onMenuSelect_routeDelete_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES) onMenuSelect_routeDelete(e);
//		}
//		protected function onMenuSelect_routeDelete(e:Event):void
//		{
//			onItemClick_linkList_delete();
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.
		/**
		 * 経路一覧 ContextMenu「経路削除」の選択確認.
		 *
	     * @param e ContextMenuのイベント.
		 */
		public function onMenuSelect_routeDelete2(e:ContextMenuEvent):void
		{
			_selectedLinkObject = RP_LINKROUTE.getItemAt(1);
			onClick_linkList_delete2();
		}


// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * 経路一覧 ContextMenu「経路削除」の選択確認.
//		 *
//	     * @param e ContextMenuのイベント.
//		 */
//		protected function onMenuSelect_routeDetailsDelete_confirm(e:ContextMenuEvent):void
//		{
//			Alert.show("削除するとデータは元に戻りませんが\n削除してもよろしいですか？", "", 3, view, onMenuSelect_routeDetailsDelete_confirmResult);
//		}
//		protected function onMenuSelect_routeDetailsDelete_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES) onMenuSelect_routeDetailsDelete(e);
//		}
//		protected function onMenuSelect_routeDetailsDelete(e:Event):void
//		{
//			onItemClick_linkList2_delete();
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.
		/**
		 * 経路一覧 ContextMenu「経路削除」の選択確認.
		 *
	     * @param e ContextMenuのイベント.
		 */
		public function onMenuSelect_routeDetailsDelete2(e:ContextMenuEvent):void
		{
			_selectedLinkObject = RP_LINKROUTE_DETAIL.getItemAt(1);
			onClick_linkList2_delete2();
		}

		/**
		 * ヘルプメニュー選択.
		 *
		 * @param e ContextMenuEvent.
		 */
		 override protected function onMenuSelect_help(e:ContextMenuEvent):void
		 {
			// ヘルプ画面を表示する.
		 	opneHelpWindow("RouteEntry");
		 }

		/**
		 * ヘルプボタンのクリックイベント
		 *
		 * @param event MouseEvent
		 */
		public function onClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			opneHelpWindow("RouteEntry");
		}

		/**
		 * getRoutesの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getRoutes(e:FaultEvent):void
		{
			super.onFault_getXxxxx(e, true, "経路情報");
			view.closeWindow();
		}

		/**
		 * createRoutesの呼び出し失敗.
		 *
		 * @param e ResultEvent
		 */
		public function onFault_createRoutes(e:FaultEvent):void
		{
			super.onFault_updateXxxxx(e, true, "登録");
		}

// 2009/03/26 start 登録のタイミングで削除するようにする.
//		/**
//		 * deleteRouteの呼び出し失敗.
//		 *
//		 * @param e ResultEvent
//		 */
//		public function onFault_deleteRoute(e:FaultEvent):void
//		{
//			super.onFault_updateXxxxx(e, true, "経路削除");
//		}
//
//		/**
//		 * deleteRouteDetailsの呼び出し失敗.
//		 *
//		 * @param e ResultEvent
//		 */
//		public function onFault_deleteRouteDetails(e:FaultEvent):void
//		{
//			super.onFault_updateXxxxx(e, true, "経路詳細削除");
//		}
// 2009/03/26 end   登録のタイミングで削除するようにする.

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * ルート一覧の調整.
		 *
		 * @param  ac ルートリスト.
		 * @return 調整済みのルートリスト.
		 */
		private function makeTable_route2(ac:ArrayCollection):ArrayCollection
		{
			// 一覧表示行分のデータを作成する.
			var acLength:int = 0;
			if (ac) 	acLength = ac.length;
			else		ac = new ArrayCollection();
			// 表示行数に満たないときは 空行を追加する.
			for (var i:int = 0; i < (ROW_COUNT_EDIT - acLength) ; i++) {
				var dto:RouteDto = RouteDto.newRoute();
				ac.addItem(dto);
			}
			return ac;
		}

		/**
		 * ルート詳細一覧の調整.
		 *
		 * @param  ac ルートリスト.
		 * @return 調整済みのルート詳細リスト.
		 */
		private function makeTable_routeDetail2(routeAc:ArrayCollection):ArrayCollection
		{
			// 一覧表示行分のデータを作成する.
			var ac:ArrayCollection = new ArrayCollection();
			for (var k:int = 0; k < routeAc.length; k++) {
				var route:RouteDto = routeAc.getItemAt(k) as RouteDto;
				var list:ArrayCollection = route.routeDetails ? route.routeDetails : new ArrayCollection();
				var listLength:int = list.length;

				// 経路詳細を追加する.
				for (var i:int = 0; i < listLength; i++) {
					ac.addItem(route.routeDetails.getItemAt(i));
				}
				// 経路.経路ID = 空行.経路ID となる経路詳細を追加する.
				for (var n:int = 0; n < (ROW_COUNT_EDIT - listLength); n++) {
					var dto:RouteDetailDto = RouteDetailDto.newRouteDetail(route.routeId);
					ac.addItem(dto);
				}
			}
			return ac;
		}

		/**
		 * 経路詳細一覧のフィルタリング.
		 *
		 * @param item 経路詳細.
		 * @return フィルタリング結果.
		 */
		private function filter_routeDetail(item:Object):Boolean
		{
			// 選択経路の詳細経路を取得する.
			var route:RouteDto = view.route.selectedItem as RouteDto;
			var routeId:Number = route ? route.routeId : INDEX_INVALID;
			return item.routeId == routeId;
		}

// 2009.04.03 start 詳細一覧のデータ表示方法の変更.
//		/**
//		 * ルート一覧の調整.
//		 *
//		 * @param  ac ルートリスト.
//		 * @return 調整済みのルートリスト.
//		 */
//		private function makeTable_route(ac:ArrayCollection):ArrayCollection
//		{
//			// 一覧表示行分のデータを作成する.
//			var copy:ArrayCollection = ac ? ObjectUtil.copy(ac) as ArrayCollection : new ArrayCollection();
//			var acLength:int         = ac ? ac.length                              : 0;
//			for (var i:int = 0; i < (ROW_COUNT_EDIT - acLength) ; i++) {
//				var dto:RouteDto = new RouteDto();
//				copy.addItem(dto);
//			}
//			return copy;
//		}
//
//		/**
//		 * ルート詳細一覧の調整.
//		 *
//		 * @param  ac ルート詳細リスト.
//		 * @return 調整済みのルート詳細リスト.
//		 */
//		private function makeTable_routeDetail(ac:ArrayCollection):ArrayCollection
//		{
//			// 一覧表示行分のデータを作成する.
//			var copy:ArrayCollection = ac ? ObjectUtil.copy(ac) as ArrayCollection : new ArrayCollection();
//			var acLength:int         = ac ? ac.length                              : 0;
//			for (var i:int = 0; i < (ROW_COUNT_EDIT - acLength) ; i++) {
//				var dto:RouteDetailDto = new RouteDetailDto();
//				copy.addItem(dto);
//			}
//			return copy;
//		}
//
//		/**
//		 * 経路一覧 前回選択したIndexの設定.
//		 *
//		 * @param index 経路一覧Index
//		 */
//		private function setPreviousRouteIndex(index:int = -99):void
//		{
//			var routeIndex:int = index;
//			if (index == -99)	routeIndex = view.route.selectedIndex;
//			_previousRouteIndex = routeIndex;
//		}
//
//		/**
//		 * 経路一覧 前回選択したIndexの取得.
//		 *
//		 * @param index 経路一覧Index
//		 */
//		private function getPreviousRouteIndex():int
//		{
//			return _previousRouteIndex;
//		}
//
//		/**
//		 * 経路詳細データの設定.
//		 *
//		 * @param index 経路一覧Index
//		 */
//		private function updateRoute_setRouteDetails(index:int = -99):void
//		{
//			var routeIndex:int = index;
//			if (index == -99)	routeIndex = view.route.selectedIndex;
//
//			// 経路に編集中の経路詳細を保持する.
//			if (routeIndex >= 0) {
//				var routeList:ArrayCollection = view.route.dataProvider as ArrayCollection;
//				var routeDetailList:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;
//				routeList.getItemAt(routeIndex).routeDetails = routeDetailList;
//			}
//		}
// 2009.04.03 end   詳細一覧のデータ表示方法の変更.

		/**
		 * 経路一覧 コンテキストメニューの作成.
		 *
		 */
		private function createContextMenu_route():ContextMenu
		{
			// コンテキストメニューを作成する.
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// コンテキストメニュー：経路削除.
			var cmItem_deleteD:ContextMenuItem = new ContextMenuItem(CMENU_ROUTE_DELETE);
			cmItem_deleteD.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_routeDelete2);
			contextMenu.customItems.push(cmItem_deleteD);

			// コンテキストメニューを返す.
			return contextMenu;
		}

		/**
		 * 経路詳細一覧 コンテキストメニューの作成.
		 *
		 */
		private function createContextMenu_routeDetail():ContextMenu
		{
			// コンテキストメニューを作成する.
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// コンテキストメニュー：経路削除.
			var cmItem_deleteD:ContextMenuItem = new ContextMenuItem(CMENU_ROUTE_DETAIL_DELETE);
			cmItem_deleteD.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect_routeDetailsDelete2);
			contextMenu.customItems.push(cmItem_deleteD);

			// コンテキストメニューを返す.
			return contextMenu;
		}

		/**
		 * 経路一覧 コンテキストメニューの有効／無効設定.
		 *
		 */
		private function setContextMenu_route():void
		{
			// 有効メニューを作成する.
			var enabledItems:Array = new Array();

			// 選択された経路情報に応じて有効/無効を設定する.
			var route:Object = view.route.selectedItem;
			if (route) {
				enabledItems.push(CMENU_ROUTE_DELETE);
			}
			setEnabledContextMenu(view.route.contextMenu as ContextMenu, enabledItems);
		}

		/**
		 * 経路詳細一覧 コンテキストメニューの有効／無効設定.
		 *
		 */
		private function setContextMenu_routeDetail():void
		{
			// 有効メニューを作成する.
			var enabledItems:Array = new Array();

			// 選択された経路情報に応じて有効/無効を設定する.
			var routeItems:Array = view.routeDetail.selectedItems;
			if (routeItems && routeItems.length > 0) {
				enabledItems.push(CMENU_ROUTE_DETAIL_DELETE);
			}
			setEnabledContextMenu(view.routeDetail.contextMenu as ContextMenu, enabledItems);
		}

		/**
	     * 経路一覧 リンクボタン設定.
	     *
	     * @return リンクボタンリスト.
	     */
	     private function setRpLinkList_route():void
	     {
			view.rpLinkList.dataProvider = getRpLinkList_route();
	     }

		/**
	     * 経路一覧 リンクボタン取得.
	     *
	     * @return リンクボタンリスト.
	     */
		private function getRpLinkList_route():ArrayCollection
		{
			// 実行可能なリンクボタンを設定する.
			var rplist:ArrayCollection = ObjectUtil.copy(RP_LINKROUTE) as ArrayCollection;
			var route:Object = view.route.selectedItem;
			if (route) {
				for (var index:int = 0; index < rplist.length; index++) {
					// リンクボタンのリストを取得する.
					var linkObject:Object   = rplist.getItemAt(index);
					// 各状態を確認する.
					if (!linkObject.enabledCheck)	continue;
					linkObject.enabled = true;
					// リンクボタンのリストを設定する.
					rplist.setItemAt(linkObject, index);
				}
			}
			return rplist;
		}

		/**
	     * 経路詳細一覧 リンクボタン設定.
	     *
	     * @return リンクボタンリスト.
	     */
	     private function setRpLinkList_routeDetail():void
	     {
			view.rpLinkList2.dataProvider = getRpLinkList_routeDetail();
	     }

	    /**
	     * 経路詳細一覧 リンクボタン取得.
	     *
	     * @return リンクボタンリスト.
	     */
		private function getRpLinkList_routeDetail():ArrayCollection
		{
			// 実行可能なリンクボタンを設定する.
			var rplist:ArrayCollection = ObjectUtil.copy(RP_LINKROUTE_DETAIL) as ArrayCollection;
			var route:Object = view.route.selectedItem;
			var routeItems:Array = view.routeDetail.selectedItems;
			if (route || (routeItems && routeItems.length > 0)) {
				for (var index:int = 0; index < rplist.length; index++) {
					// リンクボタンのリストを取得する.
					var linkObject:Object   = rplist.getItemAt(index);
					// 各状態を確認する.
					if (!linkObject.enabledCheck)	continue;

					// 明細追加のとき 経路が選択されていたら表示する
					if (linkObject.id == "add") {
						if (route) {
							linkObject.enabled = true;
						}
					}
					// 明細削除のとき 明細が選択されていたら表示する.
					else if (linkObject.id == "delete") {
						if (routeItems && routeItems.length > 0) {
							linkObject.enabled = true;
						}
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
	    public var _view:RouteEntry;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():RouteEntry
	    {
	        if (_view == null) {
	            _view = super.document as RouteEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RouteEntry):void
	    {
	        _view = view;
	    }
	}
}