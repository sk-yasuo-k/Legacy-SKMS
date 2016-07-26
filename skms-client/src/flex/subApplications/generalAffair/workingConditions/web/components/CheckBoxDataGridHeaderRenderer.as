package subApplications.generalAffair.workingConditions.web.components
{
	import flash.events.MouseEvent;
	
	import mx.controls.CheckBox;
	
	public class CheckBoxDataGridHeaderRenderer extends CheckBox
	{	
		
		public var state:String;
		public var parentObject:Object;		
		
		public function CheckBoxDataGridHeaderRenderer()
		{
			super();
			selected = true;
		}
		
        /**
        * data set
        **/
        override public function set data(value:Object):void {
        	selected = parentObject[state];
        }
        
        /**
         * クリック イベント
        **/
        override protected function clickHandler(event:MouseEvent):void {
			super.clickHandler(event);
			parentObject[state] = selected;
        }                
		
	}
}