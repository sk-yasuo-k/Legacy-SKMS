package subApplications.lunch.logic
{
	import enum.LunchOrderViewId;
	
	import flash.events.*;
	import flash.net.*;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.events.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.web.*;	
	
	public class LunchLogic extends Logic
	{
		[Bindable]
		public var viewIndex:int;
			
		public function LunchLogic()
		{
			super();
			
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onClick_viewStack);
		}
		
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(view.viewStack, "selectedIndex", this, "viewIndex");
			BindingUtils.bindProperty(this, "viewIndex", view.viewStack, "selectedIndex");
		}

		public function onClick_viewStack(e:PropertyChangeEvent):void
		{
			if(viewIndex == LunchOrderViewId.LunchHistory){
				view.lunchHistory.refreshList();
			}else if(viewIndex == LunchOrderViewId.LunchAggregate){
				view.lunchAggregate.refreshList();
			}
		}
		
	
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