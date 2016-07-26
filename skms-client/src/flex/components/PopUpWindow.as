package components
{
	import flash.display.DisplayObject;

	import mx.containers.TitleWindow;
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class PopUpWindow extends TitleWindow
	{
		public function PopUpWindow()
		{
			super();

			addEventListener(CloseEvent.CLOSE, onClose);
		}

		/**
		 * close event.
		 * ※×ボタン押下 ･･･ CloseEvent.detail = -1.
		 *   上記以外     ･･･ CloseEvent.detail = 100 ～ 103.
		 *
		 * @param e CloseEvent.
		 */
		protected function onClose(e:CloseEvent):void
		{
			PopUpManager.removePopUp(this);
		}

		/**
		 * popup close.
		 *
		 * @param detail close detail.
		 */
		public function closeWindow(detail:int = CLOSE):void
		{
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, detail);
			super.dispatchEvent(ce);
		}

		/** window close */
		public static const DEFAULT:int = -1;
		public static const CLOSE:int   = 100;
		public static const ENTRY:int   = 101;
		public static const NEXT:int    = 102;
		public static const STOP:int    = 103;
		public static const RELOAD:int  = 104;



		/**
		 * popup open (center).
		 *
		 * @param popClass  popup class.
		 * @param popParent popup parent.
		 * @param data      scceeded data.
		 * @param modal     modal.
		 * @param childList childlist.
		 */
		public static function openWindow(popClass:Class, popParent:DisplayObject, data:Object = null, modal:Boolean = true, childList:String = null):IFlexDisplayObject
		{
			var pop:IFlexDisplayObject = openWindow2(popClass, popParent, data, modal, childList);

			PopUpManager.centerPopUp(pop);

			return pop;
		}

		private static function openWindow2(popClass:Class, popParent:DisplayObject, data:Object = null, modal:Boolean = true, childList:String = null):IFlexDisplayObject
		{
			var pop:IFlexDisplayObject = new popClass();
			PopUpManager.addPopUp(pop, popParent, modal, childList);

			if (data)
				IDataRenderer(pop).data = data;

			return pop;
		}

		/**
		 * popup display (center).
		 *
		 * @param pop       popup instance.
		 * @param popParent popup parent.
		 * @param data      scceeded data.
		 * @param modal     modal.
		 * @param childList childlist.
		 */
		public static function displayWindow(pop:IFlexDisplayObject, popParent:DisplayObject, data:Object = null, modal:Boolean = true, childList:String = null):void
		{
			displayWindow2(pop, popParent, data, modal, childList);

			PopUpManager.centerPopUp(pop);
		}

		public static function displayWindow2(pop:IFlexDisplayObject, popParent:DisplayObject, data:Object = null, modal:Boolean = true, childList:String = null):void
		{
			PopUpManager.addPopUp(pop, popParent, modal, childList);

			if (data)
				IDataRenderer(pop).data = data;
		}

	}
}