package subApplications.generalAffair.workingConditions.web.components
{
	import flash.events.Event;
	
	import mx.controls.CheckBox;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.core.mx_internal;
	use namespace mx_internal;


	public class CheckBoxDataGridItemRenderer extends CheckBox
	{
		private var _value:*;
		
		public function CheckBoxDataGridItemRenderer()
		{
			super();
			addEventListener(Event.CHANGE, changeHandler, false, 0, true);
		}
		
		/**
		 * Getter
		 */
		public function get value():Object {
			if (_value == undefined) {
				return _value;
			} else {
				return selected ? true : false;
			}
		}
		
		/**
		 * Setter
		 * 
		 * @param i_value	セット値
		 */
		public function set value(i_value:*):void {
			_value = i_value;
			invalidateProperties();	
		}
		
		/**
		 * @param i_item	itemRenderer 値
		 */
		override public function set data(i_item:Object):void	{
			super.data = i_item;
			if (i_item != null) {
				value = i_item[DataGridListData(listData).dataField];
			}
		}
		
		
		/**
		 * プロパティの更新
		 */
		override protected function commitProperties():void {
			if (_value != undefined) {
				selected = (_value == true);
			}
			super.commitProperties();
		}
		
		/**
		 * 再描画
		 * 
		 * @param unscaledWidth		親コンテナにより決定されるコンポーネントの幅
		 * @param unscaledHeight	親コンテナにより決定されるコンポーネントの高さ
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (currentIcon) {
				var style:String = getStyle("textAlign");
				if ((!label) && (style=="center")) {
					// 中央表示
					currentIcon.x = (unscaledWidth - currentIcon.measuredWidth) / 2;
				}
				currentIcon.visible = (_value != undefined);
			}
		}
		
		
		/**
		 * CheckBox の change イベント
		 * 
		 * @param event	Event
		 */
		private function changeHandler(event:Event):void {
			if (listData) {
				value = selected;
				data[DataGridListData(listData).dataField] = value;
			}
		}		
		
	}
}