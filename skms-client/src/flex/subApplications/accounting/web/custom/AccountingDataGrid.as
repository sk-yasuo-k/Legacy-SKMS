package subApplications.accounting.web.custom
{
	import com.googlecode.kanaxs.Kana;

	import components.CheckBoxItemEditor;
	import components.EditComboBox;

	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	import mx.events.DataGridEventReason;
	import mx.events.DragEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	import subApplications.accounting.logic.AccountingLogic;

	import utils.LabelUtil;


	/**
	 * AccountingのDataGridクラスです.
	 */
	public class AccountingDataGrid extends DataGrid
	{
		/** drag Index */
		protected var _dragIndices:Array;
		/** drop Index */
		protected var _dropIndices:Array;


//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function AccountingDataGrid()
		{
			super();

			// セルに入りきらないときは折り返す.
			wordWrap = true;
			variableRowHeight = true;
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
		protected function onCreateComplete():void
		{
		}

		/**
		 * データ編集終了.
		 *
		 * @param e DataGridEvent
		 */
		protected function onItemEditEnd_checkData(e:DataGridEvent):void
		{
			// 編集しなかったとき.
			if (ObjectUtil.compare(e.reason, DataGridEventReason.CANCELLED) == 0) {
				return;
			}

			// 入力チェックを行なう.
			var isError:Boolean = checkData(e);
			if (isError) {
				e.preventDefault();
				return;
			}
		}

		/**
		 * データフォーカス ComboBox.
		 *
		 * @param e DataGridEvent
		 */
		protected function onItemFocosIn_comboBox(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
			var cell:Object = dg.selectedItem.hasOwnProperty(col.dataField) ? dg.selectedItem[col.dataField] : "";
			if (dg.itemEditorInstance && dg.itemEditorInstance is EditComboBox) {
				var editor:EditComboBox = dg.itemEditorInstance as EditComboBox;

				switch (col.dataField) {
					// 交通機関
					case "facilityName":
						editor.dataProvider = _columnFacilityNameList;
						editor.maxChars     = 16;
						if (cell) {
							for (var index:int = 0; index < _columnFacilityNameList.length; index++) {
								if (ObjectUtil.compare(_columnFacilityNameList.getItemAt(index).label, cell.toString()) == 0) {
									editor.selectedIndex = index;
									break;
								}
							}
						}
						// dataGrid の背景色が使用されるのを防ぐため、comboBox の背景色を設定する.
						editor.setStyle("alternatingItemColors", new Array(0xffffff,0xffffff));
						editor.open();
						break;
				}
			}
		}

		/**
		 * データフォーカス DateField.
		 *
		 * @param e DataGridEvent
		 */
		protected function onItemFocosIn_dateField(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			if (dg.itemEditorInstance && dg.itemEditorInstance is DateField) {
				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
				var editor:DateField = dg.itemEditorInstance as DateField;

				switch (col.dataField) {
					// 日付.
					case "transportationDate":
						editor.editable     = true;
						var cell:Date = dg.selectedItem.hasOwnProperty(col.dataField) ? dg.selectedItem[col.dataField] as Date: null;
						if(cell){
							editor.selectedDate = cell;
						}
						break;
				}
			}
		}

		/**
		 * データフォーカス TextInput.
		 *
		 * @param e DataGridEvent
		 */
		protected function onItemFocosIn_textInput(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			if (dg.itemEditorInstance && dg.itemEditorInstance is TextInput) {
				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
				var editor:TextInput = dg.itemEditorInstance as TextInput;

				switch (col.dataField) {
					// 業務.
					case "task":
						editor.maxChars = 128;
						break;

					// 目的地.
					case "destination":
						editor.maxChars = 64;
						break;

					// 出発地＆到着地＆経由.
					case "departure":
					case "arrival":
					case "via":
						editor.maxChars = 32;
						break;

					// 備考.
					case "note":
						editor.maxChars = 128;
						break;

					// 領収書No.
					case "receiptNo":
						// 2009.07.02 delete 全角→半角変換を行なうため制約を解除する.
						//editor.restrict = "0-9";
						editor.errorString = "数字を入力してください";
						editor.setStyle("errorColor", editor.getStyle("themeColor"));
						break;

					// 片道金額.
					case "oneWayExpense":
						// 2009.07.02 delete 全角→半角変換を行なうため制約を解除する.
						////editor.restrict = "0-9\\-\u002c\u00a5";
						//editor.restrict = "0-9\\-";
						if (editor.text.length > 0) {
							editor.text = LabelUtil.expenseFormatOff(editor.text);
						}
						editor.errorString = "0以外の数値を入力してください";
						editor.setStyle("errorColor", editor.getStyle("themeColor"));
						break;
				}
			}
		}

		/**
		 * データフォーカス.
		 *
		 * @param e DataGridEvent
		 */
		protected function onItemFocosOut(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];

			// 編集データを取得する.
			if (dg.itemEditorInstance && dg.itemEditorInstance is TextInput) {
				// fieldを取得する.
				var editor:TextInput = dg.itemEditorInstance as TextInput;
				var newData:String = Kana.toHankakuCase(editor.text);

				switch (col.dataField) {
					// 片道金額.
					case "oneWayExpense":
						var expense:Number = Number(newData);
						// 編集行データを取得する.
						var editobj:Object = dg.dataProvider.getItemAt(e.rowIndex);
						if (isNaN(expense) || expense == 0 || int(expense) != expense) {
							editobj.expense = null;
						}
						else {
							// 往復CheckBoxに応じた 金額を計算する.
							var oneway:Number = Number(editor.text);
							if (editobj.roundTrip){
								editobj.expense = oneway * 2;
							}
							else {
								editobj.expense = oneway;
							}
						}
						// 編集行を変更しないと、他のカラムのデータが更新されないため.
						// ここでデータを更新させる.
						this.updateList();
						break;
				}
			}
			else if (dg.itemEditorInstance && dg.itemEditorInstance is EditComboBox) {
				// コンボリストに存在しないときは リストに追加する.
				var edCombo:EditComboBox = dg.itemEditorInstance as EditComboBox;
				for (var index:int = 0; index < _columnFacilityNameList.length; index++) {
					if (ObjectUtil.compare(_columnFacilityNameList.getItemAt(index).label, edCombo.text) == 0) {
						break;
					}
				}
				if (index == _columnFacilityNameList.length) {
					_columnFacilityNameList.addItem({label:edCombo.text});
				}
			}
		}

// 2009.04.02 start Drag&Dropはイベント処理で行なう.
//		/**
//		 * ドラッグエリアEnter.
//		 *
//		 * @param event     DragEvent
//		 * @param dataClass Class
//		 */
//		protected function dragEnterHandler_accounting(event:DragEvent, dataClass:Class):void
//		{
//			// ドラッグデータが有効のときに dragEnterHandler() を呼び出す.
//			var items:Array = event.dragSource.dataForFormat("items") as Array;
//			if (items && items.length > 0) {
//				if (items[0] as dataClass) {
//					// drag＆dropデータを取得する.
//					_dragCtrlKey = event.ctrlKey;
//					_dragIndices = null;
//					_dropIndices = null;
//					_dropCompleteCount = 0;
//
//					// dragEnter イベントを呼び出す.
//					super.dragEnterHandler(event);
//				}
//			}
//		}
//
//		/**
//		 * ドラッグエリアOver.
//		 *
//		 * @param event DragEvent
//		 */
//		protected function dragOverHandler_accounting(event:DragEvent):void
//		{
//			// drag＆dropデータを設定する.
//			event.ctrlKey = _dragCtrlKey;
//			super.dragOverHandler(event);
//		}
//
//		/**
//		 * ドラッグ＆ドロップ.
//		 *
//		 * @param event DragEvent
//		 */
//		protected function dragDropHandler_accounting(event:DragEvent):void
//		{
//			// drag＆dropデータを取得する.
//			// drag Index を取得する.
//			var indices:Array = super.copySelectedItems(false);
//			_dragIndices = indices.sort(Array.NUMERIC);
//			// drop先Index を取得する.
//			var dropIndex:int = super.calculateDropIndex(event);
//			// drag とdrop先Indexの差を計算する.
//			var diff:int = 0;
//			for each (var dragIndex:int in _dragIndices) {
//				if (dropIndex > dragIndex && !_dragCtrlKey)	diff++;
//			}
//			// drop Indexを設定する.
//			_dropIndices = new Array();
//			for (var index:int = 0; index < _dragIndices.length; index++) {
//				// drop行を選択行にするためdrop行を計算する.
//				var calIndex:int = 0;
//				if (dropIndex > _dragIndices[index]) {		// 下に移動.
//					if (_dragCtrlKey)	calIndex = dropIndex + index;
//					else				calIndex = dropIndex - diff + index;
//				}
//				else {										// 上に移動.
//					calIndex = dropIndex - diff + index;
//				}
//				_dropIndices.push(calIndex);
//			}
//			super.dragDropHandler(event);
//		}
// 2009.04.02 end   Drag&Dropはイベント処理で行なう.

		/**
		 * Drop Indexの設定.
		 *
		 * @param event DragEvent
		 */
		protected function setDropIndex(event:DragEvent):void
		{
			// drag＆dropデータを取得する.
			// drag Index を取得する.
			var indices:Array = super.copySelectedItems(false);
			_dragIndices = indices.sort(Array.NUMERIC);
			// drop先Index を取得する.
			var dropIndex:int = super.calculateDropIndex(event);
			// drag とdrop先Indexの差を計算する.
			var diff:int = 0;
			for each (var dragIndex:int in _dragIndices) {
				if (dropIndex > dragIndex && !event.ctrlKey)	diff++;
			}
			// drop Indexを設定する.
			_dropIndices = new Array();
			for (var index:int = 0; index < _dragIndices.length; index++) {
				// drop行を選択行にするためdrop行を計算する.
				var calIndex:int = 0;
				if (dropIndex > _dragIndices[index]) {		// 下に移動.
					if (event.ctrlKey)	calIndex = dropIndex + index;
					else				calIndex = dropIndex - diff + index;
				}
				else {										// 上に移動.
					calIndex = dropIndex - diff + index;
				}
				_dropIndices.push(calIndex);
			}
		}

		/**
		 * Drag データ取得.
		 *
		 * @param evnet     DragEvent
		 * @param dataClass Class
		 * @return ドラッグデータ.
		 */
		protected function getDragData(evnet:DragEvent, dataClass:Class):Array
		{
			var indices:Array = super.copySelectedItems(false);
			indices.sort(Array.NUMERIC);

			// Index順となるようにデータを追加する.
			var items:Array = new Array();
			for (var i:int = indices.length - 1; i >= 0; i--) {
				var index:int = indices[i];
		 		var target:Object = this.dataProvider.getItemAt(index) as dataClass;
		 		var item:Object;
		 		if (evnet.ctrlKey) 	item = target.copy();		// コピー.
		 		else				item = target;				// 移動.
				items.push(item);
		 	}
			return items;
		}

		/**
		 * Drag & Drop の実行確認.
		 *
		 * @return 実行結果.
		 */
		protected function checkDragDrop():Boolean
		{
			// drag＆dropしていない.
			if (!(_dragIndices && _dropIndices)) {
				return false;
			}
			return true;
		}

		/**
		 * Drag & Drop の実行完了処理.
		 *
		 */
		protected function completeDragDrop():void
		{
			// drop行を選択行とする.
			selectedIndices = _dropIndices;
			editedItemPosition = null;
			_dragIndices = null;
			_dropIndices = null;
		}


		/**
		 * ItemEditor 更新イベント.
		 *
		 * @param event Event
		 */
		protected function onItemEditUpdate(event:Event):void
		{
			var datagrid:DataGrid = event.currentTarget as DataGrid;
			var list:ArrayCollection = event.currentTarget.dataProvider as ArrayCollection;

			if (event.target is CheckBoxItemEditor) {
				// 往復CheckBoxに応じた 金額を計算する.
				var checkbox:CheckBoxItemEditor = event.target as CheckBoxItemEditor;

				// checkbox で保持している rowIndex 表示上の行数のため 表を下にスクロールしたとき.
				// rowIndex と 実Index は異なる。そのため、selectedIndex で 実Index を取得する.
				var listobj:Object = list.getItemAt(datagrid.selectedIndex);
				if (listobj.oneWayExpense == null || StringUtil.trim(listobj.oneWayExpense).length == 0) {
					listobj.expense = null;
				}
				else {
					if (checkbox.selected){
						listobj.expense = Number(listobj.oneWayExpense) * 2;
					}
					else {
						listobj.expense = Number(listobj.oneWayExpense);
					}
				}

				//// refresh() すると強制スクロールされるため、check したところ行と異なる行にも.
				//// check されるので、強制スクロールしないよう refresh() する前に position を保持する.
				//var position:Number = datagrid.verticalScrollPosition;
				//
				//// 編集行が変えないで、XXXXX → CheckBox → Checkbox → ･････ とすると.
				//// ビューの更新が行なわれないため 上記で設定した金額が画面に反映されない.
				//// そのため ここでビューを更新する.
				//list.refresh();
				//
				//// refresh() 前の位置にスクロールを設定する.
				//datagrid.verticalScrollPosition = position;
			}

			// ビューを更新する.
			this.updateList();
		}


		/**
		 * DataGrid 往復フォーマット処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		private static function roundTripEditLabel(data:Object, column:DataGridColumn):String
		{
			// 編集行に入力値が設定されていたら 往復ラベルを設定する.
			if (!data.checkEntry())		return "";
			return LabelUtil.roundTripLabel(data, column);
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * カラム作成 目的地.
		 *
		 * @return カラム.
		 */
		protected function makeColumnDestination():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "目的地";
			column.dataField  = "destination";
			column.width      = 100;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

		/**
		 * カラム作成 交通機関.
		 *
		 * @return カラム.
		 */
		protected function makeColumnFacilityName():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column = new DataGridColumn();
			column.headerText = "交通機関";
			column.dataField  = "facilityName";
			column.width      = 80;
			// 編集可能な ComboBox のため 編集データも選択表示させるためコメントアウト.
			//column.editorDataField  = "selectedLabel";
			column.itemEditor       = new ClassFactory(EditComboBox);
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

		/**
		 * カラム作成 出発地.
		 *
		 * @return カラム.
		 */
		protected function makeColumnDeparture():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "出発地";
			column.dataField       = "departure";
			column.width           = 100;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

		/**
		 * カラム作成 到着地.
		 *
		 * @return カラム.
		 */
		protected function makeColumnArrival():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "到着地";
			column.dataField       = "arrival";
			column.width           = 100;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

		/**
		 * カラム作成 経由.
		 *
		 * @return カラム.
		 */
		protected function makeColumnVia():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "経由";
			column.dataField       = "via";
			column.width           = 80;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

		/**
		 * カラム作成 往復.
		 *
		 * @return カラム.
		 */
		protected function makeColumnRoundTrip():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "往復";
			column.dataField       = "roundTrip";
			column.width           = 65;
			column.labelFunction   = LabelUtil.roundTripLabel;
			column.editable        = false;
			// 一覧でしか使用しないため、TransportApplyItemRenderer は設定しない.
			return column;
		}

		/**
		 * カラム作成 往復チェック.
		 *
		 * @return カラム.
		 */
		protected function makeColumnRoundTripEdit():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "往復";
			column.dataField       = "roundTrip";
			column.width           = 50;
			column.labelFunction   = roundTripEditLabel;
			column.editorDataField = "selected";
			column.itemEditor      = new ClassFactory(CheckBoxItemEditor);
			// データ型が boolean のため、TransportApplyItemRenderer は設定しない.
			return column;
		}

		/**
		 * カラム作成 片道金額.
		 *
		 * @return カラム.
		 */
		protected function makeColumnOneWayExpense():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "片道金額";
			column.dataField       = "oneWayExpense";
			column.width           = 80;
			column.labelFunction   = LabelUtil.expenseLabel;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}

		/**
		 * カラム作成 金額.
		 *
		 * @return カラム.
		 */
		protected function makeColumnExpense():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "金額";
			column.dataField       = "expense";
			column.width           = 80;
			column.labelFunction   = LabelUtil.expenseLabel;
			// 片道金額＆往復 から計算するように変更したため、TransportApplyItemRenderer は設定しない.
			column.editable        = false;
			//if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
			//	column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			//}
			return column;
		}

		/**
		 * カラム作成 備考.
		 *
		 * @return カラム.
		 */
		protected function makeColumnNote():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "備考";
			column.dataField       = "note";
			column.width           = 150;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_APPLY) == 0) {
				column.itemRenderer = new ClassFactory(TransportApplyItemRenderer);
			}
			return column;
		}


		/**
		 * データ編集チェック.
		 * チェックＮＧのときは、ＮＧデータは反映しない＆エラーメッセージを表示する.
		 *  ・金額   ：通貨型フォーマット.
		 *  ・領収No.：数値フォーマット.
		 *
		 * @param  e DataGridEvent.
		 * @return エラー有無.
		 */
		private function checkData(e:DataGridEvent):Boolean
		{
			var dataGrid:DataGrid = e.currentTarget as DataGrid;
			var dataField:String  = e.dataField as String;

			// 編集データを取得する.
			if (dataGrid.itemEditorInstance && dataGrid.itemEditorInstance is TextInput) {
				// fieldを取得する.
				var newEditor:TextInput = dataGrid.itemEditorInstance as TextInput;
				var newData:String = Kana.toHankakuCase(newEditor.text);
				if (newData == "") 	return false;

				switch (dataField) {
					// 片道金額.
					case "oneWayExpense":
						var expense:Number = Number(newData);
//						if (isNaN(expense) || expense == 0 || int(expense) != expense) {
//							TextInput(dataGrid.itemEditorInstance).errorString = "0以外の数値を入力してください";
//							return true;
//						}
//						// 変換した値を設定する.
//						newEditor.text = newData;
						if (isNaN(expense) || expense == 0 || int(expense) != expense) 	newEditor.text = null;
						else 															newEditor.text = newData;
						break;

					// 領収書No.
					case "receiptNo":
						var receipt:Number = Number(newData);
//						if (isNaN(receipt)) {
//							TextInput(dataGrid.itemEditorInstance).errorString = "番号を入力してください";
//							return true;
//						}
//						// スペース入力のとき、他のカラムと同様にエラーメッセージは表示しない.
//						// →スペースは number に変換すると 0 に変換される.
//
//						// 変換した値を設定する.
//						newEditor.text = newData;
						if (isNaN(receipt)) 	newEditor.text = null;
						else					newEditor.text = newData;
						break;
				}
			}

			// エラーなし.
			return false;
		}


//--------------------------------------
//  DataGrid Binding
//--------------------------------------
		/** 動作モード */
		protected var _actionMode:String;

		public function set actionMode(mode:String):void
		{
			if (_actionMode != mode) {
				_actionMode = mode;
				// 初期化処理を呼び出す.
				onCreateComplete();
			}
		}
		public function get actionMode():String
		{
			return _actionMode;
		}

		/** 交通機関リスト */
		protected var _columnFacilityNameList:ArrayCollection = null;
		public function set facilities(list:ArrayCollection):void
		{
			_columnFacilityNameList = ObjectUtil.copy(list) as ArrayCollection;
			_columnFacilityNameList.addItemAt({data:-1, label:""}, 0);
		}
	}
}