package subApplications.lunch.logic
{
	import logic.Logic;
	
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.web.*;
	
	public class RegisterLunchAdminLogic extends Logic
	{
		public function RegisterLunchAdminLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			view.lunchService.getOperation("getMLunchAdminList").send();
		}
		
		/**
		 * オプション一覧取得成功
		 * */
		public function onResult_getMLunchAdminList(e:ResultEvent):void
		{
			trace("onResult_getMLunchAdminList...");
			
			
		}
		
		/**
		 * オプション一覧取得失敗
		 * */
		public function onFault_getMLunchAdminList(e:FaultEvent):void
		{
			trace("onFault_getMLunchAdminList...");
			trace(e.message);
		}
		
		/** 画面 */
	    public var _view:RegisterLunchAdmin;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterLunchAdmin
	    {
	        if (_view == null) {
	            _view = super.document as RegisterLunchAdmin;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterLunchAdmin):void
	    {
	        _view = view;
	    }

	}
}