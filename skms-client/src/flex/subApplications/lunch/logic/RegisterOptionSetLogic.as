package subApplications.lunch.logic
{
	import logic.Logic;
	
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.web.*;
	
	public class RegisterOptionSetLogic extends Logic
	{
		public function RegisterOptionSetLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			view.lunchService.getOperation("getMOptionSetList").send();
		}
		
		/**
		 * オプション一覧取得成功
		 * */
		public function onResult_getMOptionSetList(e:ResultEvent):void
		{
			trace("onResult_getMOptionSetList...");
			
			
		}
		
		/**
		 * オプション一覧取得失敗
		 * */
		public function onFault_getMOptionSetList(e:FaultEvent):void
		{
			trace("onFault_getMOptionSetList...");
			trace(e.message);
		}
		
		/** 画面 */
	    public var _view:RegisterOptionSet;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterOptionSet
	    {
	        if (_view == null) {
	            _view = super.document as RegisterOptionSet;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterOptionSet):void
	    {
	        _view = view;
	    }

	}
}