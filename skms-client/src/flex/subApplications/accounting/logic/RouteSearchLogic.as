package subApplications.accounting.logic
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import subApplications.accounting.dto.RouteDetailDto;
	import subApplications.accounting.dto.RouteDto;
	import subApplications.accounting.web.RouteSearch;

	/**
	 * RouteSearchのLogicクラスです.
	 */
	public class RouteSearchLogic extends AccountingLogic
	{
		/** 経路情報 */
		private var _routeList:ArrayCollection;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function RouteSearchLogic()
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

	    	// 設定ボタンを押下不可にする.
	    	view.btnEntry.enabled = false;
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
	    	_actionMode     = AccountingLogic.ACTION_ROUTE_SEARCH;
	    	view.insertIndices = view.data.insertIndices;
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

			// 経路リストを取得する.
			view.srv.getOperation("getRoutes").send(Application.application.indexLogic.loginStaff);
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * get(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_getRoutes(e:ResultEvent):void
		{
			// データベースの問い合わせ結果を取得する.
			_routeList = e.result as ArrayCollection;
			view.route.dataProvider = _routeList;
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
		 * 経路一覧の選択.
		 * ※Multi選択はONのため、複数行選択される.
		 * ※selectedIndex または selectedItem が変更されたときに送出される.
		 *
		 * @param e リストコントロールのイベント.
		 */
		public function onChange_route(e:ListEvent):void
		{
			var i:int;
			var index:int;
			var item:RouteDto;

			// データを取得する.
			var items:Array = view.route.selectedItems as Array;

			// 経路詳細一覧を取得する.
			if (!view.routeDetail.dataProvider)
				view.routeDetail.dataProvider = new ArrayCollection();
			var details:ArrayCollection = view.routeDetail.dataProvider as ArrayCollection;

			// 経路選択順に応じて経路詳細一覧を作成する.
			// 選択経路以外の経路を削除する.
			for (index = details.length - 1; index >= 0; index--) {
				var rmDetail:RouteDetailDto = details.getItemAt(index) as RouteDetailDto;
				var remove:Boolean = true;
				for (i = 0; i < items.length; i++) {
					item = items[i] as RouteDto;
					if (item.isChild(rmDetail)) {
						remove = false;
						break;
					}
				}
				if (remove) {
					details.removeItemAt(index);
				}
			}
			// 一覧追加済以外の経路を追加する.
			for (i = 0; i < items.length; i++) {
				item = items[i] as RouteDto;
				if (!item.routeDetails) 	continue;
				for (index = 0; index < item.routeDetails.length; index++) {
					var adDetail:RouteDetailDto = item.routeDetails.getItemAt(index) as RouteDetailDto;
					var add:Boolean = true;
					for (var k:int = 0; k < details.length; k++) {
						var detail:RouteDetailDto = details.getItemAt(k) as RouteDetailDto;
						if (RouteDetailDto.compare(adDetail, detail)) {
							add = false;
							break;
						}
					}
					if (add) {
						details.addItem(adDetail);
					}
				}
			}
			// 設定ボタンを押下可能にする.
			if (details.length > 0)		view.btnEntry.enabled = true;
			else						view.btnEntry.enabled = false;
		}

		/**
		 * ヘルプメニュー選択.
		 *
		 * @param e ContextMenuEvent.
		 */
		 override protected function onMenuSelect_help(e:ContextMenuEvent):void
		 {
			// ヘルプ画面を表示する.
		 	opneHelpWindow("RouteSearch");
		 }

		/**
		 * ヘルプボタンのクリックイベント
		 *
		 * @param event MouseEvent
		 */
		public function onClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			opneHelpWindow("RouteSearch");
		}

//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:RouteSearch;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():RouteSearch
	    {
	        if (_view == null) {
	            _view = super.document as RouteSearch;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RouteSearch):void
	    {
	        _view = view;
	    }
	}
}