package subApplications.customer.logic.custom
{
	import flash.events.Event;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import subApplications.customer.dto.CustomerSearchDto;
	import subApplications.customer.web.custom.CustomerSearch;

	/**
	 * CustomerSearchのLogicクラスです.
	 */
	public class CustomerSearchLogic extends Logic
	{
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
	    public function CustomerSearchLogic()
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
			// 顧客リストを取得する.
			getCustomerList();
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

		/**
		 * getCustomerListの結果取得.
		 *
		 * @param event ResultEvent
		 */
		public function onResult_getCustomerList(event:ResultEvent):void
		{
			// ResultEventを通知する.
			setRequestCustomerList(true);
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
		 * 顧客リストの取得.
		 */
		public function getCustomerList():void
		{
			// 顧客リスト取得不可状態にする.
			setRequestCustomerList(false);

			// 検索条件を作成する.
			var search:CustomerSearchDto = new CustomerSearchDto();
			// 顧客区分を設定する.
			search.customerTypeList = new ArrayCollection();
			search.customerTypeList.addItem("dummy");
			if (view.chkUser.selected)  search.customerTypeList.addItem(view.chkUser.selectedField);
			if (view.chkMaker.selected) search.customerTypeList.addItem(view.chkMaker.selectedField);
			// 顧客コードを設定する.
			search.customerCode = view.customerCode.text.length > 0 ? view.customerCode.text : null;
			if (search.customerCode) {
				var cCode:String = search.customerCode;
				search.customerType = cCode.substr(0, 1);
				search.customerNo   = cCode.length > 1 ? cCode.substring(1, cCode.length) : null;
			}
			// 顧客名称を設定する.
			search.customerName = view.fullName.text.length > 0 ? view.fullName.text : null;
			// 顧客略称を設定する.
			search.customerAlias= view.aliasName.text.length > 0 ? view.aliasName.text : null;


			// 顧客リストを取得する.
			view.srv.getOperation("getCustomerList").send(search);
		}

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
		 * 検索ボタン有効設定.
		 *
		 * @param enable 有効／無効.
		 */
		 private function setRequestCustomerList(enable:Boolean):void
		 {
		 	view.btnSearch.enabled = enable;
		 	view.searchOpt.enabled = enable;
		 	view.swSearch.enabled  = enable;
		 }

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CustomerSearch;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CustomerSearch
	    {
	        if (_view == null) {
	            _view = super.document as CustomerSearch;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CustomerSearch):void
	    {
	        _view = view;
	    }
	}
}