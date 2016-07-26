package subApplications.accounting.web.custom
{
	import components.EditDateField;

	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	import mx.events.DragEvent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationDetailDto;
	import subApplications.accounting.logic.AccountingLogic;

	import utils.LabelUtil;

	/**
	 * TransportationDetailのDataGridクラスです.
	 */
	[Event(name="calculatedExpense",  type="flash.events.Event")]
	[Event(name="setBackgroundColor", type="flash.events.Event")]
	[Event(name="setDropIndex",       type="flash.events.Event")]
	public class TransportationDetailDataGrid extends AccountingDataGrid
	{
		/** Dto */
		private var dto:TransportationDetailDto = new TransportationDetailDto();

		/** 交通費 合計金額 */
		[Bindable]
		public var transportationExpense:int = -1;
//
//		/** カラム：日付 */
//		protected var _colTransportationDate:DataGridColumn;
//		/** カラム：業務 */
//		protected var _colTask              :DataGridColumn;
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
//		/** カラム：領収書No */
//		protected var _colReceiptNo         :DataGridColumn;
//		/** カラム：備考 */
//		protected var _colNote              :DataGridColumn;
//

		/** デフォルト行の背景色リスト */
		private var _defaultColors:Array;

		/** 入力エラー行の背景色 */
		private const _TRANS_DETAIL_ERROR:Number = 0xffe6e6;

//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function TransportationDetailDataGrid()
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
			addEventListener(DataGridEvent.ITEM_EDIT_END, onItemEditEnd, false);
			// イベント登録：データフォーカス.
			addEventListener(DataGridEvent.ITEM_FOCUS_IN, onItemFocosIn);
			addEventListener(DataGridEvent.ITEM_FOCUS_OUT,onItemFocosOut);
			// イベント登録：合計金額変更
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
			// イベント登録：Drag Enter.
			addEventListener(DragEvent.DRAG_ENTER,onDragEnter);
			// イベント登録：Drag & Drop.
			addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			// イベント登録：Drag Complete.
			addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
			// イベント登録：アイテム更新.
			addEventListener("itemEditUpdate", onItemEditUpdate, true);


			var columnItems:Array = new Array();
			// 日付.
			columnItems.push(makeColumnTransportationDate());
			// 業務.
			columnItems.push(makeColumnTask());
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
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_NEW) == 0
				|| ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_UPDATE) == 0
				|| ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
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
			// 領収書No.
			columnItems.push(makeColumnReceiptNo());
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
			// 日付を EditDateField に変更したため、不要なのでコメントアウト.
			//super.onItemFocosIn_dateField(e);
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

		/**
		 * データ変更通知.
		 *
		 * @param event CollectionEvents
		 */
		override protected function collectionChangeHandler(event:Event):void
		{
			// trace ("collection change -> " + e);
			super.collectionChangeHandler(event);
			onCalculatedExpense(event);							// 合計金額計算.
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				onSetBackgroundColor(event);					// 背景色設定.
			}
		}

		/**
		 * 合計金額計算.
		 *
		 * @param e Event
		 */
		private function onCalculatedExpense(e:Event):void
		{
			// trace("calc  -> " + e.toString());
			// 合計金額を計算する.
			var expense:int = 0;
			for each (var trans:TransportationDetailDto in dataProvider) {
// 2009.06.26 change 編集するときに 数値しか扱えないようにしたため変換の必要なし.
//				var tmp:String = expenseSymbolOff(trans.expense);
//				expense += Number(tmp);
				expense += Number(trans.expense);
// 2009.06.26 change end.
			}
			transportationExpense = expense;
		}

		/**
		 * 合計金額変更.
		 *
		 * @param e Event
		 */
		private function onPropertyChange(e:Event):void
		{
			dispatchEvent(new Event("calculatedExpense"));
		}

		/**
		 * 背景色設定.
		 *
		 * @param e Event
		 */
		private function onSetBackgroundColor(e:Event):void
		{
			// trace("color -> " + e.toString());
			var list:ArrayCollection = this.dataProvider as ArrayCollection;

			// 表の行数を取得する.
			var rowNum:int = (list.length > this.rowCount) ? list.length : this.rowCount;

			// 背景色リストを取得する.
			if (!_defaultColors) {
				_defaultColors = getStyle("alternatingItemColors");
			}


			// 入力エラー行は 背景色を変更する.
			_errorCount = 0;
			var colors:Array = new Array();
			for (var i:int = 0; i < rowNum; i++) {
				// 明細データ ＜ 表示行数 のとき.
				if (i < list.length) {
					// 明細を1件取得する.
					var trans:TransportationDetailDto = list.getItemAt(i) as TransportationDetailDto;

					// 申請できるかどうか確認する.
					if (trans.checkApply()) {
						colors.push(_defaultColors[i % 2]);
					}
					else {
						colors.push(_TRANS_DETAIL_ERROR);
						_errorCount++;
					}
				}
				// 明細データ ＞ 表示行数 のとき.
				else {
					colors.push(_defaultColors[i % 2]);
				}
			}
			setStyle("alternatingItemColors", colors);

			// イベントを通知する.
			dispatchEvent(new Event("setBackgroundColor"));
		}

// 2009.04.02 start Drag&Dropはイベント処理で行なう.
//		/**
//		 * ドラッグエリアEnter.
//		 *
//		 * @param event DragEvent
//		 */
//		override protected function dragEnterHandler(event:DragEvent):void
//		{
//			// trace ("dragEnterHandler : " + event);
//			super.dragEnterHandler_accounting(event, TransportationDetailDto);
//		}
//
//		/**
//		 * ドラッグエリアOver.
//		 *
//		 * @param event DragEvent
//		 */
//		override protected function dragOverHandler(event:DragEvent):void
//		{
//			// trace ("dragOverHandler : " + event);
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
//			// trace ("dragDropHandler : " + event);
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
//			// trace ("addDragData : " + ds);
//			// ドラッグデータを作成する.
//			// →データコピーされるが Id / seq が引き継がれる＆選択逆順になるため.
//			//   ドラッグデータのcopy＆選択順序変更を行なう.
//			ds.addHandler(copySelectedItems_sorted, "items");
//		}
//
//		/**
//		 * ドラッグデータ取得.
//		 *
//		 * @return ドラッグデータ.
//		 */
//		protected function copySelectedItems_sorted():Array
//		{
//			// trace ("copySortedSelectedItems : ");
//			return super.copySelectedItems_accounting(TransportationDetailDto);
//		}
// 2009.04.02 end   Drag&Dropはイベント処理で行なう.

		/**
		 * Drag Enter イベント.
		 *
		 * @param event DragEvent
		 */
		private function onDragEnter(event:DragEvent):void
		{
			if (!(event.dragInitiator is TransportationDetailDataGrid)) {
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
			return super.getDragData(event, TransportationDetailDto);
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
		/**
		 * カラム作成 日付.
		 *
		 * @return カラム
		 */
		protected function makeColumnTransportationDate():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "日付";
			column.dataField  = "transportationDate";
			column.width      = 100;
			column.itemEditor      = new ClassFactory(EditDateField);
			column.editorDataField = "editedDate"
			column.labelFunction   = LabelUtil.dateLabel;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

		/**
		 * カラム作成 業務.
		 *
		 * @return カラム
		 */
		protected function makeColumnTask():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "業務";
			column.dataField  = "task";
			column.width      = 120;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

//		/**
//		 * カラム作成 目的地.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnDestination():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnDestination();
//			return column;
//		}
//
//		/**
//		 * カラム作成 交通機関.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnFacilityName():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnFacilityName();
//			return column;
//		}
//
//		/**
//		 * カラム作成 出発地.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnDeparture():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnDeparture();
//			return column;
//		}
//
//		/**
//		 * カラム作成 到着地.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnArrival():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnArrival();
//			return column;
//		}
//
//		/**
//		 * カラム作成 経由.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnVia():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnVia();
//			return column;
//		}
//
//		/**
//		 * カラム作成 往復.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnRoundTrip():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnRoundTrip();
//			return column;
//		}
//
//		/**
//		 * カラム作成 金額.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnExpense():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnExpense();
//			return column;
//		}
//
		/**
		 * カラム作成 領収書No.
		 *
		 * @return カラム
		 */
		protected function makeColumnReceiptNo():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "領収書No";
			column.dataField       = "receiptNo";
			column.width           = 80;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

//		/**
//		 * カラム作成 備考.
//		 *
//		 * @return カラム
//		 */
//		override protected function makeColumnNote():DataGridColumn
//		{
//			var column:DataGridColumn = super.makeColumnNote();
//			return column;
//		}

//--------------------------------------
//  DataGrid Binding
//--------------------------------------
		/** エラー件数 */
		private var _errorCount:int = 0;

		public function get errorCount():int
		{
			return _errorCount;
		}
	}
}