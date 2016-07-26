package subApplications.accounting.web.custom
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.dataGridClasses.DataGridLockedRowContentHolder;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.FlexSprite;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.styles.StyleManager;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationMonthlyDto;

	import utils.LabelUtil;
	import utils.TermDateUtil;

	/**
	 * TransportationMonthlyのDataGridクラスです.
	 */
	[Event(name="detailShow", type="flash.events.Event")]
	[Event(name="changeCell", type="flash.events.Event")]
	public class TransportationMonthlyDataGrid extends DataGrid
	{
		/** デフォルト行の背景色リスト */
		private var _defaultColors:Array;

		/** 集計タイプ定義 */
		[Bindable]
		public static var TYPE_MONTHLY:int      = 1;					// 月別.
		[Bindable]
		public static var TYPE_TERM:int         = 2;					// 期別.
		[Bindable]
		public static var TYPE_TERM_6MONTHS:int = 3;					// 上期下期.


//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function TransportationMonthlyDataGrid()
		{
			super();

			// 折り返し表示を可能にする.
			this.wordWrap = true;
			this.variableRowHeight = true;

			//// ソート表示を不可能にする.
			//this.sortableColumns = false;

			// 列の順序を入替不可能にする.
			this.draggableColumns = false;

			// 行を固定する.
			this.lockedRowCount    = 1;										// 合計固定.

			// 列ソートイベントを登録する.
			addEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
			// 表示完了イベントを登録する.
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreateComplete);
		}

//--------------------------------------
//  Initialization
//--------------------------------------

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 表示完了.
		 *
		 * @param e FlexEvent.
		 */
		private function onCreateComplete(e:FlexEvent):void
		{
			// セル選択イベントを登録する.
			if (_detailShowEnabled) {
				addEventListener(MouseEvent.CLICK, onClick);
				addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			}
		}

		/**
		 * 列ソート.
		 * ※ユーザが列のコンテンツに基づいてソートするよう列ヘッダをクリックしたときに送出される.
		 *
		 * @param e DataGridEvent.
		 */
		private function onHeaderRelease(e:DataGridEvent):void
		{
			//trace ("onHeaderRelease");
			// DataGridColumn の dataField or sortCompareFunction によるソートは.
			// lockedRow も含めてソートされてしまうため SDKソートは行なわない.
			e.preventDefault();

			// 一覧リストを取得する.
			var list:ArrayCollection = this.dataProvider as ArrayCollection;

			// column を取得する.
			var c:DataGridColumn = this.columns[e.columnIndex];
			var desc:Boolean = c.sortDescending;

			// 現在のソート状態を確認する.
			var s:Sort = list.sort;
			if (s && s.fields[0].name == e.dataField)	{
				desc = !desc;
			}

			// ソート状態を設定する.
			c.sortDescending = desc;

			// ソートを実行する.
			var sort:Sort = new Sort();
			var sfield:SortField = new SortField(e.dataField);
			sfield.descending = desc;
			sort.fields = [sfield];
			if (desc)	sort.compareFunction = sortCompareDesc;
			else		sort.compareFunction = sortCompareAsc;
			list.sort   = sort;
			list.refresh();

			// 画面表示中にメニューリストを行き来すると、style = null のためエラーになるため.
			// 解決策が見つかるまで、コメントアウトする.
			// →WorkinghoursMonthlyDataGrid を参考にすう.社員単位表示のときのみ.
			// setColorPattern();
		}

		/**
		 * 勤務時間ソートDESC処理.
		 *
		 * @param a_comp 比較データ.
		 * @param b_comp 比較データ.
		 * @param fields ソートカラム名.
		 * @return ソート結果.
		 */
		private function sortCompareDesc(a_comp:Object, b_comp:Object, fields:Array = null):int
		{
			// DESCソート処理を行なう.
			return sortCompare(a_comp, b_comp, fields, true);
		}

		/**
		 * 勤務時間ソートASC処理.
		 *
		 * @param a_comp 比較データ.
		 * @param b_comp 比較データ.
		 * @param fields ソートカラム名.
		 * @return ソート結果.
		 */
		private function sortCompareAsc(a_comp:Object, b_comp:Object, fields:Array = null):int
		{
			// ASCソート処理を行なう.
			return sortCompare(a_comp, b_comp, fields, false);
		}

		/**
		 * 勤務時間ソート処理.
		 *
		 * @param a_comp 比較データ.
		 * @param b_comp 比較データ.
		 * @param fields ソートカラム名.
		 * @param desc   降順ソート.
		 * @return ソート結果.
		 */
		private function sortCompare(a_comp:Object, b_comp:Object, fields:Array, desc:Boolean):int
		{
			/*
				a が b の前に現れるソート順の場合は -1
				a = b の場合は 0.
				a が b の後に表示されるソート順の場合は 1 です.
			*/

			// ソート項目未設定のときは ソートしない.
			if (!fields)							return 0;
			if (!fields[0].hasOwnProperty("name"))	return 0;

			// 合計/ 平均時間のときは 前に 表示する.
			if (a_comp.lockedRow && b_comp.lockedRow) {
				if (a_comp.lockedRow > b_comp.lockedRow)	return  1;
				else										return -1;
			}
			else if (a_comp.lockedRow) 						return -1;
			else if (b_comp.lockedRow) 						return  1;

			// 勤務時間を比較する.
			var a:Object = a_comp[fields[0].name];
			var b:Object = b_comp[fields[0].name];
			if (a == b) {
				var field:String = "objectId";
				if (a_comp[field] > b_comp[field])		return  1;
				else									return -1;
			}
			// 降順ソートのとき.
			if (desc) {
				if (a > b)								return -1;
				else									return  1;
			}
			// 昇順ソートのとき.
			else {
				if (a > b)								return  1;
				else									return -1;
			}
		}

		/**
		 * DataGridのクリック.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick(e:MouseEvent):void
		{
			var renderer:DataGridItemRenderer = e.target as DataGridItemRenderer;
			if (renderer) {
				var startColIndex:int = this.lockedColumnCount;
				if (renderer.text.length > 0 && renderer.data.hasOwnProperty("objectId")) {
					_changeCell = true;
					_selectedCell = new Object();
					_selectedCell.columnIndex = renderer.listData.columnIndex;
					_selectedCell.rowIndex    = renderer.listData.rowIndex;
					_selectedCell.objectId    = renderer.data.objectId;
					_selectedCell.objectType  = renderer.data.objectType;
					_selectedCell.objectCode  = renderer.data.objectCode;
					_selectedCell.objectName  = renderer.data.objectName;
					_selectedCell.columnName  = DataGridColumn(this.columns[renderer.listData.columnIndex]).headerText;
					_selectedCell.objectStartDate  = getObjectStartDate(renderer);
					_selectedCell.objectFinishDate = getObjectFinishDate(renderer);
					_selectedCell.dateDetail  = getDateDetail(renderer);
				}
				else {
					if (_selectedCell)	_changeCell = true;
					_selectedCell = null;
				}

				this.changeCell = _changeCell;
			}

//			var renderer:TransportationMonthlyItemRenderer;
//			if (e.target is UITextField && e.target.owner is TransportationMonthlyItemRenderer) {
//
//				// 集計セルを選択解除する.
////				for (var i:int = 0; i < this.dataProvider.length; i++) {
////					renderer = this.indexToItemRenderer(i) as TransportationMonthlyItemRenderer;
////					if (renderer)
////						renderer.selected = false;
////				}
////				if (_selectedCell) {
////				trace ("select off" + _selectedCell.index);
////					renderer = this.indexToItemRenderer(_selectedCell.index) as TransportationMonthlyItemRenderer;
////					renderer.selected = false;
////					this.updateRendererDisplayList(renderer);
////				}
////
////				// 集計セルを選択設定する.
////				var point:Point = this.itemRendererToIndices(e.target.owner);
////				var index:int   = this.itemRendererToIndex(e.target.owner);
////				var colIndex:int = point.x;
////				var rowIndex:int = point.y;
////
////				_selectedCell = new Object();
////				_selectedCell.columnIndex  = colIndex;
////				_selectedCell.rowIndex     = rowIndex;
////				_selectedCell.index        = index;
////
//
////				if (_selectedCell) {
////					var map:Object = this.columnMap;
////					renderer = map[_selectedCell.uid];
////					renderer.selected = false;
////					this.updateRendererDisplayList(renderer);
////					_selectedCell = null;
////					trace ("select off");
////					trace (renderer.uid);
////				}
//
//				renderer = e.target.owner as TransportationMonthlyItemRenderer;
//				if (renderer.text.length > 0) {
//					renderer.selected = true;
//
//					var colIndex:int = renderer.listData.columnIndex;
//					var rowIndex:int = renderer.listData.rowIndex;
//					var aryUid:Array = renderer.uid.split(".");
//
//					_selectedCell = new Object();
//					_selectedCell.columnIndex = colIndex;
//					_selectedCell.rowIndex    = rowIndex;
//					_selectedCell.data        = renderer.data;
//					_selectedCell.uid         = aryUid[aryUid.length - 1];
//					_selectedCell.objectId    = renderer.data.objectId;
//					_selectedCell.objectType  = renderer.data.objectType;
//					_selectedCell.objectCode  = renderer.data.objectCode;
//					_selectedCell.objectName  = renderer.data.objectName;
//					var listData:DataGridListData = renderer.listData as DataGridListData;
////					_selectedCell.yyyymm      = renderer.data[DataGridListData(renderer.listData).dataField];
//					_selectedCell.objectStartDate  = getObjectStartDate(renderer);
//					_selectedCell.objectFinishDate = getObjectFinishDate(renderer);
////					_selectedCell.uid         = renderer.uid;
//
//					trace ("select on " + "row " + rowIndex + " " + "col " + colIndex);
//					trace (_selectedCell.uid);
//				}
//			}
		}

		/**
		 * DataGridのダブルクリック.
		 *
		 * @param e MouseEvent.
		 */
		public function onDoubleClick(e:MouseEvent):void
		{
			if (_selectedCell) {
				// 詳細データを取得する.
				dispatchEvent(new Event("detailShow"));
			}
		}

		/**
		 * 集計セル 開始日付の取得.
		 *
		 * @param renderer ItemRenderer.
		 * @return Date.
		 */
		private function getObjectStartDate(renderer:DataGridItemRenderer):Date
		{
			// dataField を取得する.
			var dateField:String = DataGridListData(renderer.listData).dataField;
			var date:Date = null;
			if (ObjectUtil.compare(dateField, "total") == 0 ||
				ObjectUtil.compare(dateField, "objectCode") == 0 ||
				ObjectUtil.compare(dateField, "objectName") == 0) {
				date = _startDate;
			}
			else {
				switch (_type) {
					case TYPE_TERM:
						var term:String = dateField.replace("期", "");
						date = TermDateUtil.convertStartDate(term);
						break;

					case TYPE_TERM_6MONTHS:
						var termhalf:String = dateField.replace("期", "");
						date = TermDateUtil.convertStartDate2(termhalf);
						break;

					case TYPE_MONTHLY:
					default:
						date = DateField.stringToDate(dateField + "01", "YYYYMMDD");
						break;
				}
			}
			return date;
		}

		/**
		 * 集計セル 終了日付の取得.
		 *
		 * @param renderer ItemRenderer.
		 * @return Date.
		 */
		private function getObjectFinishDate(renderer:DataGridItemRenderer):Date
		{
			// dataField を取得する.
			var dateField:String = DataGridListData(renderer.listData).dataField;

			var date:Date = null;
			if (ObjectUtil.compare(dateField, "total") == 0 ||
				ObjectUtil.compare(dateField, "objectCode") == 0 ||
				ObjectUtil.compare(dateField, "objectName") == 0) {
				date = _finishDate;;
			}
			else {
				switch (_type) {
					case TYPE_TERM:
						var term:String = dateField.replace("期", "");
						date = TermDateUtil.convertFinishDate(term);
						break;

					case TYPE_TERM_6MONTHS:
						var termhalf:String = dateField.replace("期", "");
						date = TermDateUtil.convertFinishDate2(termhalf);
						break;

					case TYPE_MONTHLY:
					default:
						date = DateField.stringToDate(dateField + "01", "YYYYMMDD");
						date.setMonth(date.getMonth() + 1, date.getDate());
						date.setMonth(date.getMonth(), date.getDate() - 1);
						break;
				}
			}
			return date;
		}


		/**
		 * 集計セル 詳細日付の有無.
		 *
		 * @param renderer ItemRenderer.
		 * @return 詳細日付.
		 */
		private function getDateDetail(renderer:DataGridItemRenderer):String
		{
			var dateField:String = DataGridListData(renderer.listData).dataField;
			if (ObjectUtil.compare(dateField, "total") == 0 ||
				ObjectUtil.compare(dateField, "objectCode") == 0 ||
				ObjectUtil.compare(dateField, "objectName") == 0) {
				return "";
			}
			else {
				return DataGridColumn(this.columns[renderer.listData.columnIndex]).headerText;
			}
		}


//--------------------------------------
//  Override
//--------------------------------------
	    /**
	     * (override)背景色の変更.
	     * ※SDKの処理では 固定行の背景色設定にも alternatingItemColors が使用されており setColorPattern() で
	     *   設定した背景色になってしまうので、固定行には デフォルトの背景色を設定する.
	     */
	    override protected function drawRowGraphics(contentHolder:ListBaseContentHolder):void
	    {
	    	// 固定行でないとき 背景色を変更するため、通常処理を呼び出す.
	    	if (!(contentHolder is DataGridLockedRowContentHolder)) {
	    		super.drawRowGraphics(contentHolder);
	    	}
			// 固定行のとき 背景色は変更する必要がないため、初期値を使用する.
	    	else {
		        var rowBGs:Sprite = Sprite(contentHolder.getChildByName("rowBGs"));
		        if (!rowBGs)
		        {
		            rowBGs = new FlexSprite();
		            rowBGs.mouseEnabled = false;
		            rowBGs.name = "rowBGs";
		            contentHolder.addChildAt(rowBGs, 0);
		        }

		// SDK change start
		//	    var colors:Array;
		//
		//	    colors = getStyle("alternatingItemColors");
			if (!_defaultColors) 	_defaultColors = this.getStyle("alternatingItemColors");
		        var colors:Array = _lockedColors ? _lockedColors : _defaultColors;
		// SDK change end

		        if (!colors || colors.length == 0)
		        {
		            while (rowBGs.numChildren > n)
		            {
		                rowBGs.removeChildAt(rowBGs.numChildren - 1);
		            }
		            return;
		        }

		        StyleManager.getColorNames(colors);

		        var curRow:int = 0;

		        var i:int = 0;
		        var actualRow:int = verticalScrollPosition;
		        var n:int = contentHolder.listItems.length;

		        while (curRow < n)
		        {
		            drawRowBackground(rowBGs, i++, contentHolder.rowInfo[curRow].y, contentHolder.rowInfo[curRow].height,
		                colors[actualRow % colors.length], actualRow);
		            curRow++;
		            actualRow++;
		        }

		        while (rowBGs.numChildren > i)
		        {
		            rowBGs.removeChildAt(rowBGs.numChildren - 1);
		        }
		    }
		 }


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * DataGrid 構築.
		 */
		private function createDataGrid():void
		{
			// カラムを作成する.
			var colitems:Array = new Array();
			// 共通カラムを設定する.
			if (_isProjectMonthly) {
				// プロジェクトコード、プロジェクト名.
				colitems.push(makeColumnProjectCode());
				colitems.push(makeColumnProjectName());
				this.lockedColumnCount = 2;
			}
			else {
				// 氏名.
				colitems.push(makeColumnStaffName());
				this.lockedColumnCount = 1;
			}
			// 集計別カラムを設定する.
			var coltypes:Array = makeColumnXxxxx();
			for (var i:int = 0; i < coltypes.length; i++) {
				colitems.push(coltypes[i]);
			}
			// 共通カラム：合計金額を設定する.
			colitems.push(makeColumnTotalExpense());						// 合計金額.
			// カラムを設定する.
			this.columns = colitems;


			// データを設定する.
			this.dataProvider = convertMonthlyList();

		}

//		/**
//		 * 一覧データリストへの変換.
//		 *
//		 * @param list 一覧データリスト.
//		 * @return 一覧データリスト.
//		 */
//		private function getDataProvider(list:ArrayCollection):ArrayCollection
//		{
//			// 1行目 に 各列の合計値を表示するため 合計値行を追加する.
//			var obj:Object = new Object();
//			obj.projectCode = "集計別合計金額";
//
//			var cp:ArrayCollection = ObjectUtil.copy(list) as ArrayCollection;
//			cp.addItemAt(obj, 0);
//			return cp;
//		}

		/**
		 * 月別 一覧データリストの作成.
		 *
		 * @return データリスト.
		 */
		protected function convertMonthlyList():ArrayCollection
		{
			var list:ArrayCollection = new ArrayCollection();
			if (!_monthlyList)		return list;

			var object:Object;
			var expsense:Number;

			// 月別リストを作成する.
			for each (var transmonthly:TransportationMonthlyDto in _monthlyList) {

				// 行データを作成する.
				object = new Object();
				object.objectId   = transmonthly.objectId;
				object.objectName = transmonthly.objectName;
				object.objectCode = transmonthly.objectCode;
				object.objectType = transmonthly.objectType;

				// DataGridColumn.dataField を定義する.
				var nowField:String = "";
				var preField:String = "";

				for (var date:Date = ObjectUtil.copy(_startDate) as Date;
					 date.getTime() <= _finishDate.getTime();
					 date.setMonth(date.getMonth() + 1, 1)) {

					// DataGridColumn.dataField を設定する.
					nowField = makeDataFieldXxxx(date);

					// dataFieldが変わったかどうか確認する.
					if (ObjectUtil.compare(preField, nowField) != 0) {
						object[nowField] = 0;
						preField = String(nowField);
					}

					// 月別交通費を取得する.
					var transMonth:String = DateField.dateToString(date, "YYYYMM");
					if (transmonthly.monthyList) {

						// 交通費リストをソートする.
						var monthlyList:ArrayCollection = transmonthly.monthyList;
						var sort:Sort = new Sort();
						sort.fields = [new SortField("yyyymm")];
						monthlyList.sort = sort;
						monthlyList.refresh();

						// dataField と一致する月別勤務時間を取得する.
						var cursor:IViewCursor = monthlyList.createCursor();
						var find:Boolean = cursor.findFirst({yyyymm:transMonth});
						if (find) {
							expsense = cursor.current.expense;
							object[nowField] += expsense;
						}
					}
				}
				// データを追加する.
				list.addItem(object);
			}


			var total:Number;
			var count:int;
			var col:DataGridColumn;
			var field:String;

			// 集計行データを作成する.
			var object_total:Object = {objectName:"", objectCode:"集計別 合計金額", lockedRow:1};
			for each (col in this.columns) {

				// 月別カラムかどうか確認する.
				field = col.dataField as String;
				if (ObjectUtil.compare(field, "objectCode")  == 0
					|| ObjectUtil.compare(field, "objectName")  == 0
					|| ObjectUtil.compare(field, "total")   == 0)
					continue;

				total = 0;;
				count = 0;
				for each (object in list) {
					expsense = Number(object[field]);
					if (expsense > 0) {
						total += expsense;
						count++;
					}
				}
				// 金額を設定する.
				object_total[field]   = total;
			}
			list.addItemAt(object_total, 0);



			// 合計＆平均時間を計算する.
			for (var index:int = 0; index < list.length; index++) {

				total = 0;
				count = 0;
				object = list.getItemAt(index);
				for each (col in this.columns) {
					// 月別カラムかどうか確認する.
					field = col.dataField as String;
					if (ObjectUtil.compare(field, "objectCode")  == 0
						|| ObjectUtil.compare(field, "objectName")  == 0
						|| ObjectUtil.compare(field, "total")   == 0)
						continue;

					expsense = Number(object[field]);
					if (expsense > 0) {
						total += expsense;
						count++;
					}
				}

				object.total   = total;
				if (object.lockedRow)
					object.average = 0;
				else
					object.average = (total && count) ? total/count : 0;
				list.setItemAt(object, index);
			}

			return list;
		}

		/**
		 * カラム作成 氏名.
		 *
		 * @return カラム.
		 */
		protected function makeColumnStaffName():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "氏名";
			column.dataField  = "objectCode";
			column.width      = 100;
			column.sortable   = false;
			return column;
		}

		/**
		 * カラム作成 プロジェクトコード.
		 *
		 * @return カラム.
		 */
		protected function makeColumnProjectCode():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "プロジェクトコード";
			column.dataField  = "objectCode";
			column.width      = 100;
			column.sortable   = false;
			return column;
		}

		/**
		 * カラム作成 プロジェクト名.
		 *
		 * @return カラム.
		 */
		protected function makeColumnProjectName():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "プロジェクト名";
			column.dataField  = "objectName";
			column.width      = 150;
			column.sortable   = false;
			return column;
		}

//		/**
//		 * カラム作成 月別集計カラムリスト.
//		 *
//		 * @return カラムリスト.
//		 */
//		protected function makeColumnMonthly():Array
//		{
//			var items:Array = new Array();
//			for (var date:Date = ObjectUtil.copy(_startDate) as Date;
//				 date.getTime() <= _finishDate.getTime();
//				 date.setMonth(date.getMonth() + 1, 1)) {
//				var column:DataGridColumn = new DataGridColumn();
//				column.headerText = DateField.dateToString(date, "YYYY/MM");
//				column.dataField  = DateField.dateToString(date, "YYYYMM");
//				column.width      = 80;
//				column.labelFunction = expenseLabel;
//				column.sortable   = false;
//				column.setStyle("textAlign", "right");
//				items.push(column);
//			}
//			return items;
//		}
//
//		/**
//		 * カラム作成 期別集計カラムリスト.
//		 *
//		 * @return カラムリスト.
//		 */
//		protected function makeColumnTerm():Array
//		{
//			var term:String    = "";
//			var preterm:String = "";
//			var items:Array = new Array();
//			for (var date:Date = ObjectUtil.copy(_startDate) as Date;
//				 date.getTime() <= _finishDate.getTime();
//				 date.setMonth(date.getMonth() + 1, 1)) {
//
//				// term を計算する.
//				term = TermDateUtil.convertTerm(date);
//
//				// term が変わったかどうか確認する.
//				if (ObjectUtil.compare(preterm, term) == 0) 	continue;
//
//				// term を保持する.
//				preterm = String(term);
//
//				var column:DataGridColumn = new DataGridColumn();
//				column.headerText = term + "期";
//				column.dataField  = term;
//				column.width      = 80;
//				column.labelFunction = expenseLabel;
//				column.sortable   = false;
//				column.setStyle("textAlign", "right");
//				items.push(column);
//			}
//			return items;
//		}
//
//		/**
//		 * カラム作成 上期下期別集計カラムリスト.
//		 *
//		 * @return カラムリスト.
//		 */
//		protected function makeColumnTermHalf():Array
//		{
//			var term:String    = "";
//			var preterm:String = "";
//			var items:Array = new Array();
//			for (var date:Date = ObjectUtil.copy(_startDate) as Date;
//				 date.getTime() <= _finishDate.getTime();
//				 date.setMonth(date.getMonth() + 1, 1)) {
//
//				// term を計算する.
//				term = TermDateUtil.convertTermHalf(date);
//
//				// term が変わったかどうか確認する.
//				if (ObjectUtil.compare(preterm, term) == 0) 	continue;
//
//				// term を保持する.
//				preterm = String(term);
//
//				var column:DataGridColumn = new DataGridColumn();
//				column.headerText = term + "期";
//				column.dataField  = term;
//				column.width      = 80;
//				column.labelFunction = expenseLabel;
//				column.sortable   = false;
//				column.setStyle("textAlign", "right");
//				items.push(column);
//			}
//			return items;
//		}

		/**
		 * カラム作成 xx別集計カラムリスト.
		 *
		 * @return カラムリスト.
		 */
		protected function makeColumnXxxxx():Array
		{
			var nowField:String = "";
			var preField:String = "";
			var items:Array = new Array();
			for (var date:Date = ObjectUtil.copy(_startDate) as Date;
				 date.getTime() <= _finishDate.getTime();
				 date.setMonth(date.getMonth() + 1, 1)) {

				// dateField を取得する.
				nowField = makeDataFieldXxxx(date);

				// dateField が変わったかどうか確認する.
				if (ObjectUtil.compare(preField, nowField) == 0) 	continue;

				// dateField を保持する.
				preField = String(nowField);

				var column:DataGridColumn = new DataGridColumn();
				column.headerText = makeHeaderTextXxxx(date);
				column.dataField  = nowField;
				column.width      = 80;
				column.labelFunction = LabelUtil.expenseLabel;
				column.sortable   = true;
				column.setStyle("textAlign", "right");
// クリックされたセルだけ 背景色を変更したかったが、前選択のセル色を元に戻すことが難しい.ため.
// 背景色を変更する処理は保留とする.
//				column.itemRenderer = new ClassFactory(TransportationMonthlyItemRenderer);
				items.push(column);
			}
			return items;
		}

		/**
		 * カラムDataField作成 xx別集計カラム .
		 *
		 * @param date 日時.
		 * @return dataField.
		 */
		private function makeDataFieldXxxx(date:Date):String
		{
			// DataGridColumn.dataField を設定する.
			var field:String = "";
			switch (_type) {
				case TYPE_TERM:
					field = TermDateUtil.convertTerm(date);
					break;

				case TYPE_TERM_6MONTHS:
					field = TermDateUtil.convertTermHalf(date);
					break;

				case TYPE_MONTHLY:
				default:
					field = DateField.dateToString(date, "YYYYMM");
					break;
			}
			return field;
		}

		/**
		 * カラムHeaderText作成 xx別集計カラム .
		 *
		 * @param date 日時.
		 * @return dataField.
		 */
		private function makeHeaderTextXxxx(date:Date):String
		{
			// DataGridColumn.dataField を設定する.
			var field:String = "";
			switch (_type) {
				case TYPE_TERM:
					field = TermDateUtil.convertTerm(date) + "期";
					break;

				case TYPE_TERM_6MONTHS:
					field = TermDateUtil.convertTermHalf(date) + "期";
					break;

				case TYPE_MONTHLY:
				default:
					field = DateField.dateToString(date, "YYYY/MM");
					break;
			}
			return field;
		}

		/**
		 * カラム作成 合計金額カラム.
		 *
		 * @return からむ.
		 */
		protected function makeColumnTotalExpense():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "合計金額";
			column.dataField  = "total";
			column.width      = 80;
			column.labelFunction = LabelUtil.expenseLabel;
			column.sortable   = true;
			column.setStyle("textAlign", "right");
			return column;

		}

		/**
		 * 月別集計データラベル.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return ラベル.
		 */
		protected function expenseLabel(data:Object, column:DataGridColumn):String
		{
			// 集計データを取得する.
			var expense:int = 0;
			var list:ArrayCollection = new ArrayCollection();
			if (data is TransportationMonthlyDto) 		list.addItem(data);
			else 										list = _monthlyList;

			if (list) {
				for (var li:int = 0; li < list.length; li++) {
					var monthlyList:ArrayCollection = list.getItemAt(li).monthyList as ArrayCollection;
					if (!monthlyList)	continue;
					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
						// 集計単位を取得する.
						var target:String;
						switch (_type) {
							case TYPE_TERM:
								target = TermDateUtil.convertTermFromYYYYMM(monthlyList.getItemAt(mi).yyyymm as String);
								break;
							case TYPE_TERM_6MONTHS:
								target = TermDateUtil.convertTermHalfFromYYYYYMM(monthlyList.getItemAt(mi).yyyymm as String);
								break;
							case TYPE_MONTHLY:
							default:
								target = monthlyList.getItemAt(mi).yyyymm as String;
								break;
						}

						// 集計金額を取得する.
						if (ObjectUtil.compare(target, column.dataField) == 0) {
							expense += monthlyList.getItemAt(mi).expense as int;
						}
					}
				}
			}
	        return convertExpenseFormat(expense);
	    }

		/**
		 * 合計金額データラベル.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return ラベル.
		 */
		protected function totalExpenseLabel(data:Object, column:DataGridColumn):String
		{
			// 集計データを取得する.
			var expense:int = 0;
			var list:ArrayCollection = new ArrayCollection();
			if (data is TransportationMonthlyDto) 		list.addItem(data);
			else 										list = _monthlyList;

			if (list) {
				for (var li:int = 0; li < list.length; li++) {
					var monthlyList:ArrayCollection = list.getItemAt(li).monthyList as ArrayCollection;
					if (!monthlyList)	continue;
					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
						// 集計金額を取得する.
						expense += monthlyList.getItemAt(mi).expense as int;
					}
				}
			}
	        return convertExpenseFormat(expense);
	    }

		/**
		 * 通貨フォーマットへの変換.
		 *
		 * @param expense 金額.
		 * @return フォーマット後の金額.
		 */
		 private function convertExpenseFormat(expense:int):String
		 {
		 	if (ObjectUtil.compare(expense, 0) == 0)	return "";
		 	return LabelUtil.expense(expense);
		 }



//--------------------------------------
//  DataGrid Binding
//--------------------------------------
		/** 集計リスト */
		private var _monthlyList:ArrayCollection;
		public function set monthlyData(list:ArrayCollection):void
		{
			_selectedCell = null;
			_monthlyList = list;
			createDataGrid();
		}

		/** 集計開始月 */
		private var _startDate:Date;
		public function set startDate(date:Date):void
		{
			_startDate = date;
		}

		/** 集計終了月 */
		private var _finishDate:Date;
		public function set finishDate(date:Date):void
		{
			_finishDate = date;
		}

		/** 集計タイプ */
		private var _type:int = TYPE_MONTHLY;
		public function set type(type:int):void
		{
			_type = type;
			_selectedCell = null;
			if (this.visible)
				createDataGrid();
		}

		/** 固定行背景色 */
		private var _lockedColors:Array;
		public function set colorLocked(color:Number):void
		{
			_lockedColors = new Array();
			_lockedColors.push(color);
		}

		/** 集計単位 */
		private var _isProjectMonthly:Boolean = true;
		public function set projectMonthly(value:Boolean):void
		{
			_isProjectMonthly = value;
		}

		/** 選択セル */
		private var _selectedCell:Object;
		public function get selectedCell():Object
		{
			return _selectedCell;
		}

		/** 選択セル変更 */
		private var _changeCell:Boolean = false;
		private function set changeCell(value:Boolean):void
		{
			if (value)
				dispatchEvent(new Event("changeCell"));
			_changeCell = false;
		}

		/** 詳細データ表示 */
		private var _detailShowEnabled:Boolean = doubleClickEnabled;
		public function set detailShowEnabled(value:Boolean):void
		{
			_detailShowEnabled = value;
			this.doubleClickEnabled = _detailShowEnabled;
		}
	}
}