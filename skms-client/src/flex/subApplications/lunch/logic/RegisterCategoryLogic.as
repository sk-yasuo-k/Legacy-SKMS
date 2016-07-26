package subApplications.lunch.logic
{
	import logic.Logic;
	
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.web.*;
	
	public class RegisterCategoryLogic extends Logic
	{
		public function RegisterCategoryLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			view.lunchService.getOperation("getMenuCategoryList").send();
		}
		
		/**
		 * オプション一覧取得成功
		 * */
		public function onResult_getMenuCategoryList(e:ResultEvent):void
		{
			trace("onResult_getMenuCategoryList...");
			
			
		}
		
		/**
		 * オプション一覧取得失敗
		 * */
		public function onFault_getMenuCategoryList(e:FaultEvent):void
		{
			trace("onFault_getMenuCategoryList...");
			trace(e.message);
		}
		
		/** 画面 */
	    public var _view:RegisterCategory;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterCategory
	    {
	        if (_view == null) {
	            _view = super.document as RegisterCategory;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterCategory):void
	    {
	        _view = view;
	    }

	}
}