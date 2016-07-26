package subApplications.accounting.web.custom
{
	import flash.events.Event;

	import mx.events.DataGridEvent;
	import mx.events.DragEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.RouteDetailDto;
	import subApplications.accounting.logic.AccountingLogic;


	/**
	 * RouteDetailのDataGridクラスです.
	 */
	[Event(name="setDropIndex",       type="flash.events.Event")]
	public class RouteDetailDataGrid extends AccountingDataGrid
	{
		/** Dto */
		private var dto:RouteDetailDto = new RouteDetailDto();

//		/** カラム：目的地 */
//		protected var _colDestination       :DataGridColumn;
//		/** カラム：交通機関 */
//		protected var _colFacilityName      :DataGridColumn;
//		/** カラム：出発地 */
//		protected var _colDeparture         :DataGridColumn;
//		/** カラム：到着地 */
//		protected var _colArrival           :DataGridColumn;
//		/** カラム：経由 */
//		protected var _colVia               :DataGridColumn;
//		/** カラム：往復 */
//		protected var _colRoundTrip         :DataGridColumn;
//		/** カラム：金額 */
//		protected var _colExpense           :DataGridColumn;
//		/** カラム：備考 */
//		protected var _colNote              :DataGridColumn;


//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function RouteDetailDataGrid()
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
			// イベント登録：データ編集.
			addEventListener(DataGridEvent.ITEM_EDIT_END, onItemEditEnd);
			// イベント登録：データフォーカス.
			addEventListener(DataGridEvent.ITEM_FOCUS_IN, onItemFocosIn);
			addEventListener(DataGridEvent.ITEM_FOCUS_OUT,onItemFocosOut);
			// イベント登録：Drag Enter.
			addEventListener(DragEvent.DRAG_ENTER,onDragEnter);
			// イベント登録：Drag & Drop.
			addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			// イベント登録：Drag Complete.
			addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
			// イベント登録：アイテム更新.
			addEventListener("itemEditUpdate", onItemEditUpdate, true);



			var columnItems:Array = new Array();
			// 目的地.
			columnItems.push(makeColumnDestination());
			// 交通機関.
			columnItems.push(makeColumnFacilityName());
			// 出発地.
			columnItems.push(makeColumnDeparture());
			// 到着地.
			columnItems.push(makeColumnArrival());
			// 経由.
			columnItems.push(makeColumnVia());
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_ROUTE_ENTRY) == 0) {
				// 片道金額.
				columnItems.push(makeColumnOneWayExpense());
				// 往復.
				columnItems.push(makeColumnRoundTripEdit());
			}
			else {
				// 往復.
				columnItems.push(makeColumnRoundTrip());
			}
			// 金額.
			columnItems.push(makeColumnExpense());
			// 備考.
			columnItems.push(makeColumnNote());

			// カラムを定義する.
			this.columns = columnItems;
		}

		/**
		 * データ編集終了.
		 *
		 * @param e DataGridEvent
		 */
		protected function onItemEditEnd(e:DataGridEvent):void
		{
			super.onItemEditEnd_checkData(e);
		}

		/**
		 * データフォーカス IN.
		 *
		 * @param e DataGridEvent
		 */
		protected function onItemFocosIn(e:DataGridEvent):void
		{
			super.onItemFocosIn_comboBox(e);
			super.onItemFocosIn_textInput(e);
		}

		/**
		 * データフォーカス OUT.
		 *
		 * @param e DataGridEvent
		 */
		override protected function onItemFocosOut(e:DataGridEvent):void
		{
			super.onItemFocosOut(e);
		}

//		/**
//		 * データ変更通知.
//		 *
//		 * @param event CollectionEvents
//		 */
//		override protected function collectionChangeHandler(event:Event):void
//		{
//			if (super.collectionChangeHandler_accounting(event)) {
//				dispatchEvent(new Event("setDropIndex"));		// selectedIndex変更.
//			}
//		}

// 2009.04.02 start Drag&Dropはイベント処理で行なう.
//		/**
//		 * ドラッグエリアEnter.
//		 *
//		 * @param event DragEvent
//		 */
//		override protected function dragEnterHandler(event:DragEvent):void
//		{
//			super.dragEnterHandler_accounting(event, RouteDetailDto);
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
//			// →データコピーされるが routeId＆routeSeq が引き継がれる＆選択逆順に
//			//   表示されるためドラッグデータを独自に作成する.
//			ds.addHandler(copySelectedItems_sorted, "items");
//		}
//
//		/**
//		 * ドラッグデータ取得.
//		 *
//		 */
//		protected function copySelectedItems_sorted():Array
//		{
//			return super.copySelectedItems_accounting(RouteDetailDto);
//		}
// 2009.04.02 end   Drag&Dropはイベント処理で行なう.

		/**
		 * Drag Enter イベント.
		 *
		 * @param event DragEvent
		 */
		private function onDragEnter(event:DragEvent):void
		{
			if (!(event.dragInitiator is RouteDetailDataGrid)) {
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
			return super.getDragData(event, RouteDetailDto);
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


		/**
		 * ItemEditor 更新イベント.
		 *
		 * @param event Event
		 */
		override protected function onItemEditUpdate(e:Event):void
		{
			super.onItemEditUpdate(e);
		}


//--------------------------------------
//  Function
//--------------------------------------
//		/**
//		 * カラム作成 目的地.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnDestination():DataGridColumn
//		{
//			_colDestination = super.makeColumnDestination();
//			return _colDestination;
//		}
//
//		/**
//		 * カラム作成 交通機関.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnFacilityName():DataGridColumn
//		{
//			_colFacilityName = super.makeColumnFacilityName();
//			return _colFacilityName;
//		}
//
//		/**
//		 * カラム作成 出発地.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnDeparture():DataGridColumn
//		{
//			_colDeparture = super.makeColumnDeparture();
//			return _colDeparture;
//		}
//
//		/**
//		 * カラム作成 到着地.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnArrival():DataGridColumn
//		{
//			_colArrival = super.makeColumnArrival();
//			return _colArrival;
//		}
//
//		/**
//		 * カラム作成 経由.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnVia():DataGridColumn
//		{
//			_colVia = super.makeColumnVia();
//			return _colVia;
//		}
//
//		/**
//		 * カラム作成 往復.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnRoundTrip():DataGridColumn
//		{
//			_colRoundTrip = super.makeColumnRoundTrip();
//			return _colRoundTrip;
//		}
//
//		/**
//		 * カラム作成 金額.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnExpense():DataGridColumn
//		{
//			_colExpense = super.makeColumnExpense();
//			return _colExpense;
//		}
//
//		/**
//		 * カラム作成 備考.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnNote():DataGridColumn
//		{
//			_colNote = super.makeColumnNote();
//			return _colNote;
//		}


//--------------------------------------
//  DataGrid Binding
//--------------------------------------
	}
}