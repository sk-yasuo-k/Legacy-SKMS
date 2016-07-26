package subApplications.lunch.logic
{
	import logic.Logic;
	
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.web.*;
	
	public class RegisterShopMenuLogic extends Logic
	{
		public function RegisterShopMenuLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			view.lunchService.getOperation("getMMenuList").send();
		}
		
		/**
		 * オプション一覧取得成功
		 * */
		public function onResult_getMMenuList(e:ResultEvent):void
		{
			trace("onResult_getMMenuList...");
			
			
		}
		
		/**
		 * オプション一覧取得失敗
		 * */
		public function onFault_getMMenuList(e:FaultEvent):void
		{
			trace("onFault_getMMenuList...");
			trace(e.message);
		}
		
		/** 画面 */
	    public var _view:RegisterShopMenu;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterShopMenu
	    {
	        if (_view == null) {
	            _view = super.document as RegisterShopMenu;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterShopMenu):void
	    {
	        _view = view;
	    }

	}
}