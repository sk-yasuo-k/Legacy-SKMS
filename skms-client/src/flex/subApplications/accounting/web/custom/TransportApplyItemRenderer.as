package subApplications.accounting.web.custom
{
   import flash.display.Graphics;

   import mx.collections.ArrayCollection;
   import mx.controls.DataGrid;
   import mx.controls.Label;
   import mx.controls.dataGridClasses.*;

	public class TransportApplyItemRenderer extends Label
	{
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var grid:DataGrid = DataGrid(DataGridListData(listData).owner);
			var	gridData:DataGridListData = listData as DataGridListData;
			var g:Graphics = graphics;
			g.clear();

			switch (gridData.dataField) {
				// 交通費発生日
				case "transportationDate":
					if (!data.checkApply_transDate()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				// 業務
				case "task":
					if (!data.checkApply_task()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				// 目的地
				case "destination":
					if (!data.checkApply_destination()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				// 交通機関
				case "facilityName":
					if (!data.checkApply_facilityName()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				// 発
				case "departure":
					if (!data.checkApply_departure()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				// 経由
				case "via":
					if (!data.checkApply_via()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				// 着
				case "arrival":
					if (!data.checkApply_arrival()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				//// 往復
				//case "roundTrip":
				//	if (!data.checkApply_roundTrip()) {
				//		setColorPattern(g, unscaledWidth, unscaledHeight);
				//	}
				//	break;

				// 片道金額
				case "oneWayExpense":
					if (!data.checkApply_oneWayExpense()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				//// 金額
				//case "expense":
				//	if (!data.checkApply_expense()) {
				//		setColorPattern(g, unscaledWidth, unscaledHeight);
				//	}
				//	break;

				// 領収No.
				case "receiptNo":
					if (!data.checkApply_receiptNo()) {
						setColorPattern(g, unscaledWidth, unscaledHeight);
					}
					break;

				// 備考
				case "note":
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