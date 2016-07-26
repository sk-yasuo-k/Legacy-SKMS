package subApplications.generalAffair.logic
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.dto.LunchOrderMonthDto;
	import subApplications.generalAffair.web.Lunch;
	import subApplications.generalAffair.web.MenuThumb;
	import subApplications.generalAffair.web.OrderThumb;
	
	/**
	 * LunchのLogicクラスです。
	 */
	public class LunchLogic extends Logic
	{
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function LunchLogic()
		{
			super();
		}

		public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;
		public var currentDate:Date;
		public var dispDate:Date;
		
//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * onCreationCompleteHandler
	     */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
	    {
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		public function onCreateComplete_viewStack1(e:FlexEvent):void
		{
			view.lbLunchSelect.selectedIndex = 0;
			view.srv.getOperation("getLunchShop").send();
		}
		
		public function onItemClick_lbRunchSelect(e:ItemClickEvent):void
		{
			switch(view.lbLunchSelect.selectedIndex) {
				case 0:
					view.srv.getOperation("getLunchShop").send();
					break;
				case 1:
					break;
				case 2:
			    	currentDate = new Date();
			    	dispDate = new Date();
			    	dispDate.setTime(currentDate.getTime());
					view.srv.getOperation("getMonthlyOrder").send(dispDate);
					break;
			}
		}
		
		public function onClick_btnToTray(e:MouseEvent):void
		{
			var orderThumb:OrderThumb = new OrderThumb();
			view.tlOrderList.addChild(orderThumb);
		}
		
        public function onCreationComplete_tlMenuList(e:FlexEvent):void
        {
            e.currentTarget.addEventListener("addOrder", onAddOrder_tlMenuList);
        }

        public function onCreationComplete_tlOrderList(e:FlexEvent):void
        {
            e.currentTarget.addEventListener("cancelOrder", onCancelOrder_tlOrderList);
        }

        private function onAddOrder_tlMenuList(e:Event):void
        {
			var menu:MenuThumb = e.target as MenuThumb;
            var targetIndex:int = e.currentTarget.itemRendererToIndex(menu);
            var dp:ArrayCollection = e.currentTarget.dataProvider as ArrayCollection;

			if(!view.tlOrderList.dataProvider){
			    view.tlOrderList.dataProvider = new ArrayCollection();
			}
			var ac:ArrayCollection = view.tlOrderList.dataProvider as ArrayCollection;
			ac.addItem(dp.getItemAt(targetIndex));
        }

        private function onCancelOrder_tlOrderList(e:Event):void
        {
			var order:OrderThumb = e.target as OrderThumb;
            var targetIndex:int = e.currentTarget.itemRendererToIndex(order);
            var dp:ArrayCollection = e.currentTarget.dataProvider as ArrayCollection;
			dp.removeItemAt(targetIndex);
        }
        
		public function onCreationComplete_monthlyLunch(e:FlexEvent):void
		{
		}
		
		public function onClick_prevMonth(e:MouseEvent):void
		{
			// 前月の日付を計算
			dispDate = new Date(dispDate.getFullYear(), dispDate.getMonth() - 1, 1);
			view.srv.getOperation("getMonthlyOrder").send(dispDate);
		}
		
		public function onClick_nextMonth(e:MouseEvent):void
		{
			// 翌月の日付を計算
			dispDate = new Date(dispDate.getFullYear(), dispDate.getMonth() + 1, 1);
			view.srv.getOperation("getMonthlyOrder").send(dispDate);
		}
		
	    /**
	     * getList処理の結果イベント
	     * 
	     * @param e ResultEvent
	     */
        public function onGetMonthlyOrderResult(e:ResultEvent):void
        {
        	var lunchOrderMonth:LunchOrderMonthDto = e.result as LunchOrderMonthDto;
        	
	        view.rpMonth.dataProvider = lunchOrderMonth.lunchOrderWeeks;
       }

	    /**
	     * getList処理の結果イベント
	     * 
	     * @param e ResultEvent
	     */
        public function onGetLunchShopResult(e:ResultEvent):void
        {
//        	var lunchOrderMonth:LunchOrderMonthDto = e.result as LunchOrderMonthDto;
        	
	        view.rpShop.dataProvider = e.result;
       }

	    /**
	     * リモート呼び出しの失敗イベント（共通）
	     * 
	     * @param e FaultEvent
	     */
	    public function onFault(e:FaultEvent):void
	    {
	        trace(e);
	    }

//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:Lunch;
	    
	    /**
	     * 画面を取得します
	     */     
	    public function get view():Lunch
	    {
	        if (_view == null) {
	            _view = super.document as Lunch;
	        }
	        return _view;
	    }
	    
	    /**
	     * 画面をセットします。
	     * 
	     * @param view セットする画面
	     */
	    public function set view(view:Lunch):void
	    {
	        _view = view;
	    }
	}
}