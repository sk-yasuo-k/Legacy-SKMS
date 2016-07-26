package subApplications.accounting.web.custom
{
	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DragEvent;

	import subApplications.accounting.dto.RouteDetailDto;
	import subApplications.accounting.dto.RouteDto;

	/**
	 * RouteのDataGridクラスです.
	 */
	[Event(name="setDropIndex",       type="flash.events.Event")]
	[Event(name="dragSource",         type="mx.events.DragEvent")]
	public class RouteDataGrid extends AccountingDataGrid
	{
		/** Dto */
		private var dto:RouteDto = new RouteDto();

		/** カラム：経路名 */
		protected var _colRouteName  :DataGridColumn;
		/** カラム：発～着 */
		protected var _colRouteOption:DataGridColumn;

//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function RouteDataGrid()
		{
			super();
		}

//--------------------------------------
//  Initialization
//--------------------------------------

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 一覧の初期化.
		 *
		 */
		override protected function onCreateComplete():void
		{
			// イベント登録：Drag Enter.
			addEventListener(DragEvent.DRAG_ENTER,onDragEnter);
			// イベント登録：Drag & Drop.
			addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			// イベント登録：Drag Complete.
			addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);


			var columnItems:Array = new Array();
			// 経路名.
			columnItems.push(makeColumnRouteName());
			// 発～着.
			columnItems.push(makeColumnRouteOption());

			// カラムを定義する.
			this.columns = columnItems;
		}

// 2009.04.02 start Drag&Dropはイベント処理で行なう.
//		/**
//		 * ドラッグエリアEnter.
//		 *
//		 * @param event DragEvent
//		 */
//		override protected function dragEnterHandler(event:DragEvent):void
//		{
//			super.dragEnterHandler_accounting(event, RouteDto);
//		}
//
//		/**
//		 * ドラッグエリアOver.
//		 *
//		 * @param event DragEvent
//		 */
//		override protected function dragOverHandler(event:DragEvent):void
//		{
//			super.dragOverHandler_accounting(event);
//		}
//
//		/**
//		 * ドラッグ＆ドロップ.
//		 *
//		 * @param event DragEvent
//		 */
//		override protected function dragDropHandler(event:DragEvent):void
//		{
//			super.dragDropHandler_accounting(event);
//		}
//
//		/**
//		 * ドラッグデータ追加.
//		 *
//		 * @param ds DragSource
//		 */
//		override protected function addDragData(ds:Object):void // actually a DragSource
//		{
//			// ドラッグデータを作成する.
//			// →データコピーされるが Id / seq が引き継がれる＆選択逆順になるため.
//			//   ドラッグデータのcopy＆選択順序変更を行なう.
//			ds.addHandler(copySelectedItems_sorted, "items");
//		}
//
//		/**
//		 * ドラッグデータ取得.
//		 *
//		 */
//		protected function copySelectedItems_sorted():Array
//		{
//			return super.copySelectedItems_accounting(RouteDto);
//		}
// 2009.04.02 end   Drag&Dropはイベント処理で行なう.

		/**
		 * Drag Enter イベント.
		 *
		 * @param event DragEvent
		 */
		private function onDragEnter(event:DragEvent):void
		{
			if (!(event.dragInitiator is RouteDataGrid)) {
				event.preventDefault();
			}
		}

		/**
		 * Drag & Drop イベント.
		 *
		 * @param event DragEvent
		 */
		private function onDragDrop(event:DragEvent):void
		{
			event.dragSource.addData(onDragDrop_getDragData(event), "items");
			super.setDropIndex(event);
			if (dragSourceNotify) {
				var e:DragEvent = new DragEvent("dragSource");
				e.dragSource = event.dragSource;
				e.ctrlKey    = event.ctrlKey;
				dispatchEvent(e);
			}
		}

		/**
		 * Drag データ取得.
		 *
		 * @param event DragEvent
		 * @return ドラッグデータ.
		 */
		private function onDragDrop_getDragData(event:DragEvent):Array
		{
			// trace ("copySortedSelectedItems : ");
			return super.getDragData(event, RouteDto);
		}

		/**
		 * Drag Complete イベント.
		 *
		 * @param event DragEvent
		 */
		private function onDragComplete(event:DragEvent):void
		{
			//trace ("onDragComplete");
			if (super.checkDragDrop()) {
				super.completeDragDrop();
				dispatchEvent(new Event("setDropIndex"));		// selectedIndex変更.
			}
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * カラム作成 経路名.
		 *
		 * @return カラム.
		 */
		protected function makeColumnRouteName():DataGridColumn
		{
			_colRouteName = new DataGridColumn();
			_colRouteName.headerText = "経路名";
			_colRouteName.dataField  = "routeName";
			_colRouteName.width      = 120;
			return _colRouteName;
		}

		/**
		 * カラム作成 出発～到着.
		 *
		 * @return カラム.
		 */
		protected function makeColumnRouteOption():DataGridColumn
		{
			_colRouteOption = new DataGridColumn();
			_colRouteOption.headerText = "出発～到着";
			_colRouteOption.dataField  = "routeDetails";
			_colRouteOption.width      = 120;
			_colRouteOption.labelFunction = routeOptionLabel;
			_colRouteOption.editable      = false;
			return _colRouteOption
		}

		/**
		 * 経路・出発～到着の作成.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		protected function routeOptionLabel(data:Object, column:DataGridColumn):String
		{
			var list:ArrayCollection = data[column.dataField] as ArrayCollection;
			if (!(list && list.length > 0)) 	return "";

			var retString:String = "";
			var isValue:Boolean = false;

			// 入力値が存在する最初の行の「出発」を取得する.
			var departure:String = null;
			for each (var depDto:RouteDetailDto in list) {
				if (depDto.checkEntry()) {
					departure = depDto.departure;
					isValue = true;
					break;
				}
			}

			// 入力値が存在する最後の行の「到着」を取得する.
			var arrival:String   = null;
			for (var lastIndex:int = list.length - 1; lastIndex >= 0; lastIndex--) {
				var arrDto:RouteDetailDto = list.getItemAt(lastIndex) as RouteDetailDto;
				if (arrDto.checkEntry()) {
					arrival = arrDto.arrival;
					isValue = true;
					break;
				}
			}

			// 入力値が存在するときのみ「出発～到着」を作成する.
			if (isValue) {
				retString  = departure == null ? "" : departure;
				retString += " ～ ";
				retString += arrival == null ? "" : arrival;
			}
	        return retString;
		}

//--------------------------------------
//  DataGrid Binding
//--------------------------------------
		/** DragSource 通知 */
		private var _dragSourceNotifyy:Boolean = false;
		public function set dragSourceNotify(value:Boolean):void
		{
			_dragSourceNotifyy = value;
		}
		public function get dragSourceNotify():Boolean
		{
			return _dragSourceNotifyy;
		}
	}
}