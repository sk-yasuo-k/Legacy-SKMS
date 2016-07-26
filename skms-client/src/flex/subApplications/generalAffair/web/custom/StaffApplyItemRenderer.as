package subApplications.generalAffair.web.custom
{
   import flash.display.Graphics;

   import mx.collections.ArrayCollection;
   import mx.controls.DataGrid;
   import mx.controls.Label;
   import mx.controls.dataGridClasses.*;

	public class StaffApplyItemRenderer extends Label
	{
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var grid:DataGrid = DataGrid(DataGridListData(listData).owner);
			var	gridData:DataGridListData = listData as DataGridListData;
			var g:Graphics = graphics;
			g.clear();

			switch (gridData.dataField) {
				// 日付
				case "AcademicBackgroundDate":
					if (!data.checkApply_StaffDate()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;
				// 備考
				case "AcademicBackgroundDatenote":
					if (!data.checkApply_note()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;
				
			}
		}

		private function setColorPattern(g:Graphics, unscaledWidth:Number, unscaledHeight:Number):void
		{
			g.beginFill(0xFF9696);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
		}
	}
}