package subApplications.generalAffair.web.custom
{
	import enum.WorkStatusId;

	import flash.display.Sprite;

	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridLockedRowContentHolder;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.FlexSprite;
	import mx.events.DataGridEvent;
	import mx.styles.StyleManager;
	import mx.utils.ObjectUtil;

	import subApplications.generalAffair.dto.StaffWorkingHoursDto;
	import subApplications.generalAffair.logic.WorkingHoursMonthlyLogic;

	import utils.LabelUtil;
	import utils.TermDateUtil;


	/**
	 * WorkingHoursMonthlyのDataGridクラスです.
	 */
	public class WorkingHoursMonthlyDataGrid extends DataGrid
	{
		/** デフォルト行の背景色リスト */
		private var _defaultColors:Array;

//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function WorkingHoursMonthlyDataGrid()
		{
			super();

			// 折り返し表示を可能にする.
			this.wordWrap = true;
			this.variableRowHeight = true;

			//// ソート表示を不可能にする.
			//this.sortableColumns = false;

			// 列の順序を入替不可能にする.
			this.draggableColumns = false;

			// 行・列を固定する.
			this.lockedColumnCount = 1;										// 氏名を固定.
			this.lockedRowCount    = 2;										// 合計、平均を固定.

			// 列ソートイベントを登録する.
			addEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
		}

//--------------------------------------
//  Initialization
//--------------------------------------
		/**
		 * DataGrid 構築.
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

			setColorPattern();
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
				var field:String = "staffId";
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

			// 共通カラム：氏名を設定する.
			colitems.push(makeColumnStaffName());

			// 集計別カラムを設定する.
			var coltypes:Array = makeColumnXxxxx();
			for (var i:int = 0; i < coltypes.length; i++) {
				colitems.push(coltypes[i]);
			}
			// 共通カラム：平均時間を設定する.
			colitems.push(makeColumnAverageHour());
			// 共通カラム：合計時間を設定する.
			colitems.push(makeColumnTotalHour());
			// カラムを設定する.
			this.columns = colitems;

			// データを設定する.
			this.dataProvider = convertMonthlyList();

			// 背景色を設定する.
			setColorPattern();
		}


//		/**
//		 * 一覧データリストへの変換.
//		 *
//		 * @param list 一覧データリスト.
//		 * @return 一覧データリスト.
//		 */
//		private function getDataProvider(list:ArrayCollection):ArrayCollection
//		{
//			// 1～2行目 に 各列の合計値を表示するため 合計値行を追加する.
//			var obj:Object = new Object();
//			obj.staffName = "集計別 合計時間";
//			obj.total     = true;
//
//			var obj2:Object = new Object();
//			obj2.staffName = "集計別 平均時間";
//			obj2.average   = true;
//
//			var cp:ArrayCollection = ObjectUtil.copy(list) as ArrayCollection;
//			cp.addItemAt(obj2, 0);
//			cp.addItemAt(obj,  0);
//			return cp;
//		}
//
//
//		/**
//		 * 月別 一覧データリストの作成.
//		 *
//		 * @return カラム.
//		 */
//		protected function createDataTerm(list:ArrayCollection):ArrayCollection
//		{
//			var list:ArrayCollection = new ArrayCollection();
//			if (!_monthlyList)		return list;
////			for each (StaffWorkingHoursDto staffwork in _monthlyList) {
////				for (var date:Date = ObjectUtil.copy(_startDate) as Date;
////					 date.getTime() <= _finishDate.getTime();
////					 date.setMonth(date.getMonth() + 1, 1)) {
////				}
////			}
//			return list;
//		}
//
//
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
			var hour:Number;

			// 月別リストを作成する.
			for each (var staffwork:StaffWorkingHoursDto in _monthlyList) {

				// 行データを作成する.
				object = new Object();
				object.staffId    = staffwork.staffId;
				object.staffName  = staffwork.staffName;
				object.workStatusId=staffwork.workStatusId;

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

					// 月別勤務時間を取得する.
					var workingMonth:String = DateField.dateToString(date, "YYYYMM");
					if (staffwork.monthlyList) {

						// 勤務時間リストをソートする.
						var monthlyList:ArrayCollection = staffwork.monthlyList;
						var sort:Sort = new Sort();
						sort.fields = [new SortField("yyyymm")];
						monthlyList.sort = sort;
						monthlyList.refresh();

						// dataField と一致する月別勤務時間を取得する.
						var cursor:IViewCursor = monthlyList.createCursor();
						var find:Boolean = cursor.findFirst({yyyymm:workingMonth});
						if (find) {
							hour = getWorkingHour(cursor.current)
							object[nowField] += hour;
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
			var object_total:Object   = {staffName:"集計別 合計時間", lockedRow:1};
			var object_average:Object = {staffName:"集計別 平均時間", lockedRow:2};
			for each (col in this.columns) {

				// 月別カラムかどうか確認する.
				field = col.dataField as String;
				if (ObjectUtil.compare(field, "staffName")  == 0
					|| ObjectUtil.compare(field, "total")   == 0
					|| ObjectUtil.compare(field, "average") == 0)
					continue;

				total = 0;;
				count = 0;
				for each (object in list) {
					hour = Number(object[field]);
					if (hour > 0) {
						total += hour;
						count++;
					}
				}
				// 勤務時間を設定する.
				object_total[field]   = total;
				object_average[field] = (total && count) ? total/count : 0;
			}
			list.addItemAt(object_average, 0);
			list.addItemAt(object_total, 0);



			// 合計＆平均時間を計算する.
			for (var index:int = 0; index < list.length; index++) {

				total = 0;
				count = 0;
				object = list.getItemAt(index);
				for each (col in this.columns) {
					// 月別カラムかどうか確認する.
					field = col.dataField as String;
					if (ObjectUtil.compare(field, "staffName")  == 0
						|| ObjectUtil.compare(field, "total")   == 0
						|| ObjectUtil.compare(field, "average") == 0)
						continue;

					hour = Number(object[field]);
					if (hour > 0) {
						total += hour;
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
			column.dataField  = "staffName";
			column.width      = 120;
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
////				column.labelFunction = workingHourLabel;
//				column.labelFunction = LabelUtil.workingHourLabel;
//				column.sortable   = true;
////				column.sortCompareFunction = workingHourSort;
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
//				column.labelFunction = workingHourLabel;
//				column.sortable   = true;
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
//				column.labelFunction = workingHourLabel;
//				column.sortable   = true;
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
				column.labelFunction = LabelUtil.workingHourLabel;
				column.sortable   = true;
				column.setStyle("textAlign", "right");
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
				case WorkingHoursMonthlyLogic.TYPE_TERM:
					field = TermDateUtil.convertTerm(date);
					break;

				case WorkingHoursMonthlyLogic.TYPE_TERM_6MONTHS:
					field = TermDateUtil.convertTermHalf(date);
					break;

				case WorkingHoursMonthlyLogic.TYPE_MONTHLY:
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
				case WorkingHoursMonthlyLogic.TYPE_TERM:
					field = TermDateUtil.convertTerm(date) + "期";
					break;

				case WorkingHoursMonthlyLogic.TYPE_TERM_6MONTHS:
					field = TermDateUtil.convertTermHalf(date) + "期";
					break;

				case WorkingHoursMonthlyLogic.TYPE_MONTHLY:
				default:
					field = DateField.dateToString(date, "YYYY/MM");
					break;
			}
			return field;
		}

		/**
		 * カラム作成 平均時間カラム.
		 *
		 * @return からむ.
		 */
		protected function makeColumnAverageHour():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "平均時間";
			column.dataField  = "average";
			column.width      = 80;
			column.labelFunction = LabelUtil.workingHourLabel;
			column.sortable   = true;
			column.setStyle("textAlign", "right");
			return column;

		}

		/**
		 * カラム作成 合計時間カラム.
		 *
		 * @return からむ.
		 */
		protected function makeColumnTotalHour():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "合計時間";
			column.dataField  = "total";
			column.width      = 120;
			column.labelFunction = LabelUtil.workingHourLabel;
			column.sortable   = true;
			column.setStyle("textAlign", "right");
			return column;

		}

//		/**
//		 * xxxxx集計データラベル.
//		 *
//		 * @param data DataGridの選択されたデータ項目.
//		 * @param column DataGridの列オブジェクト.
//		 * @return ラベル.
//		 */
//		protected function workingHourLabel(data:Object, column:DataGridColumn):String
//		{
//			// 集計データを取得する.
//			var hour:Number = 0;
//			var list:ArrayCollection = new ArrayCollection();
//			if (data is StaffWorkingHoursDto) 		list.addItem(data);
//			else 									list = _monthlyList;
//
//			if (list) {
//
//				// 勤務人数をカウントする.
//				var cnt:int = 0;
//				for (var li:int = 0; li < list.length; li++) {
//
//					var flg:Boolean = false;
//
//					// 勤務樹幹リストを取得する.
//					var monthlyList:ArrayCollection = list.getItemAt(li).monthlyList as ArrayCollection;
//					if (!monthlyList)	continue;
//
//					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
//						// 集計単位を取得する.
//						var target:String;
//						switch (_type) {
//							case WorkingHoursMonthlyLogic.TYPE_TERM:
//								target = TermDateUtil.convertTermFromYYYYMM(monthlyList.getItemAt(mi).yyyymm as String);
//								break;
//							case WorkingHoursMonthlyLogic.TYPE_TERM_6MONTHS:
//								target = TermDateUtil.convertTermHalfFromYYYYYMM(monthlyList.getItemAt(mi).yyyymm as String);
//								break;
//							case WorkingHoursMonthlyLogic.TYPE_MONTHLY:
//							default:
//								target = monthlyList.getItemAt(mi).yyyymm as String;
//								break;
//						}
//
//						// 集計時間を取得する.
//						if (ObjectUtil.compare(target, column.dataField) == 0) {
//							var workinghour:Number = getWorkingHour(monthlyList.getItemAt(mi));
//							hour += workinghour;
//
//							// 勤務していたら平均値計算のため cnt++ する.
//							if (workinghour != 0)	flg = true;;
//						}
//					}
//
//					if (flg)	cnt++;
//				}
//
//				// 平均値表示のとき.
//				if (data.hasOwnProperty("average") && hour != 0 && cnt != 0) {
//					hour = hour / cnt;
//				}
//			}
//	        return convertHourFormat(hour);
//	    }

//		/**
//		 * 月別集計データラベル.
//		 *
//		 * @param data DataGridの選択されたデータ項目.
//		 * @param column DataGridの列オブジェクト.
//		 * @return ラベル.
//		 */
//		protected function monthlyLabel(data:Object, column:DataGridColumn):String
//		{
//			// 集計データを取得する.
//			var hour:Number = 0;
//			var list:ArrayCollection = new ArrayCollection();
//			if (data is StaffWorkingHoursDto) 		list.addItem(data);
//			else 									list = _monthlyList;
//
//			if (list) {
//
//				// 勤務人数をカウントする.
//				var cnt:int = 0;
//				for (var li:int = 0; li < list.length; li++) {
//
//					var flg:Boolean = false;
//
//					// 勤務樹幹リストを取得する.
//					var monthlyList:ArrayCollection = list.getItemAt(li).monthlyList as ArrayCollection;
//					if (!monthlyList)	continue;
//
//					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
//						// 勤務月を取得する.
//						var monthly:String = monthlyList.getItemAt(mi).yyyymm as String;
//
//						// 集計時間を取得する.
//						if (ObjectUtil.compare(monthly, column.dataField) == 0) {
//							var workinghour:Number = getWorkingHour(monthlyList.getItemAt(mi));
//							hour += workinghour;
//
//							// 勤務していたら平均値計算のため cnt++ する.
//							if (workinghour != 0)	flg = true;;
//						}
//					}
//
//					if (flg)	cnt++;
//				}
//
//				// 平均値表示のとき.
//				if (data.hasOwnProperty("average") && hour != 0 && cnt != 0) {
//					hour = hour / cnt;
//				}
//			}
//	        return convertHourFormat(hour);
//	    }
//
//		/**
//		 * 期別集計データラベル.
//		 *
//		 * @param data DataGridの選択されたデータ項目.
//		 * @param column DataGridの列オブジェクト.
//		 * @return ラベル.
//		 */
//		protected function termLabel(data:Object, column:DataGridColumn):String
//		{
//			// 集計データを取得する.
//			var hour:Number = 0;
//			var list:ArrayCollection = new ArrayCollection();
//			if (data is StaffWorkingHoursDto) 			list.addItem(data);
//			else 										list = _monthlyList;
//
//			if (list) {
//				for (var li:int = 0; li < list.length; li++) {
//					var monthlyList:ArrayCollection = list.getItemAt(li).monthlyList as ArrayCollection;
//					if (!monthlyList)	continue;
//					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
//						// term を計算する.
//						var term:String = TermDateUtil.convertTermFromYYYYMM(monthlyList.getItemAt(mi).yyyymm as String);
//
//						// 集計金額を取得する.
//						if (ObjectUtil.compare(term, column.dataField) == 0) {
//							hour += getWorkingHour(monthlyList.getItemAt(mi));
//						}
//					}
//				}
//
//				// 平均値表示のとき.
//				if (data.hasOwnProperty("average") && hour > 0 && list.length > 0) {
//					hour = hour / list.length;
//				}
//			}
//	        return convertHourFormat(hour);
//	    }
//
//		/**
//		 * 上/下期別集計データラベル.
//		 *
//		 * @param data DataGridの選択されたデータ項目.
//		 * @param column DataGridの列オブジェクト.
//		 * @return ラベル.
//		 */
//		protected function termHalfLabel(data:Object, column:DataGridColumn):String
//		{
//			// 集計データを取得する.
//			var hour:Number = 0;
//			var list:ArrayCollection = new ArrayCollection();
//			if (data is StaffWorkingHoursDto) 			list.addItem(data);
//			else 										list = _monthlyList;
//
//			if (list) {
//				for (var li:int = 0; li < list.length; li++) {
//					var monthlyList:ArrayCollection = list.getItemAt(li).monthlyList as ArrayCollection;
//					if (!monthlyList)	continue;
//					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
//						// term を計算する.
//						var term:String = TermDateUtil.convertTermHalfFromYYYYYMM(monthlyList.getItemAt(mi).yyyymm as String);
//
//						// 集計金額を取得する.
//						if (ObjectUtil.compare(term, column.dataField) == 0) {
//							hour += getWorkingHour(monthlyList.getItemAt(mi));
//						}
//					}
//				}
//
//				// 平均値表示のとき.
//				if (data.hasOwnProperty("average") && hour > 0 && list.length > 0) {
//					hour = hour / list.length;
//				}
//			}
//	        return convertHourFormat(hour);
//	    }
//
//		/**
//		 * 合計時間データラベル.
//		 *
//		 * @param data DataGridの選択されたデータ項目.
//		 * @param column DataGridの列オブジェクト.
//		 * @return ラベル.
//		 */
//		protected function totalHourLabel(data:Object, column:DataGridColumn):String
//		{
//			// 集計データを取得する.
//			var hour:Number = 0;
//			var list:ArrayCollection = new ArrayCollection();
//			if (data is StaffWorkingHoursDto) 			list.addItem(data);
//			else 										list = _monthlyList;
//
//			// 平均値表示の時は 計算しない.
//			if (list && !data.hasOwnProperty("average")) {
//				for (var li:int = 0; li < list.length; li++) {
//					var monthlyList:ArrayCollection = list.getItemAt(li).monthlyList as ArrayCollection;
//					if (!monthlyList)	continue;
//					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
//						// 勤務時間を取得する.
//						hour += getWorkingHour(monthlyList.getItemAt(mi));
//					}
//				}
//			}
//	        return convertHourFormat(hour);
//	    }
//
//		/**
//		 * 合計時間データラベル.
//		 *
//		 * @param data DataGridの選択されたデータ項目.
//		 * @param column DataGridの列オブジェクト.
//		 * @return ラベル.
//		 */
//		protected function averageHourLabel(data:Object, column:DataGridColumn):String
//		{
//			// 集計データを取得する.
//			var hour:Number = 0;
//			var list:ArrayCollection = new ArrayCollection();
//			if (data is StaffWorkingHoursDto) 			list.addItem(data);
//			else 										list = _monthlyList;
//
//			// 平均値表示の時は 計算しない.
//			if (list && !data.hasOwnProperty("average")) {
//				for (var li:int = 0; li < list.length; li++) {
//					var monthlyList:ArrayCollection = list.getItemAt(li).monthlyList as ArrayCollection;
//					if (!monthlyList)	continue;
//					for (var mi:int = 0 ; mi < monthlyList.length; mi++) {
//						// 勤務時間を取得する.
//						hour += getWorkingHour(monthlyList.getItemAt(mi));
//					}
//				}
//			}
//	        return convertHourFormat(hour);
//	    }
//
//
//		/**
//		 * 時間フォーマットの取得.
//		 *
//		 * @param hour 時間.
//		 * @return フォーマット後の時間.
//		 */
//		 private function convertHourFormat(hour:Number):String
//		 {
//			if (isNaN(hour) || hour == 0) return "";
//			return LabelUtil.workingHour(hour);;
//		 }


		/**
		 * 勤務時間の取得.
		 *
		 * @param data データ.
		 * @return 勤務時間.
		 */
		 private function getWorkingHour(data:Object):Number
		 {
		 	if (ObjectUtil.compare(_conttype, WorkingHoursMonthlyLogic.CONT_WORK_HOUR) == 0) {
		 		return data.workingHours;
		 	}
		 	else {
		 		return data.realWorkingHours;
		 	}
		 }


		/**
		 * 背景色の設定.
		 *
		 */
		private function setColorPattern():void
		{
			// 画面表示中にメニューリストを行き来すると、style = null のためエラーになるため.
			// 解決策が見つかるまで、コメントアウトする.
			var flg:Boolean = true;
			if (flg)	return;

			// 背景色が未設定のときは何もしない.
			if (isNaN(_colorInService) && isNaN(_colorLeave) && isNaN(_colorRetire))	return;

			// カラーパターンを保持する.
			if (!_defaultColors) {
				_defaultColors = this.getStyle("alternatingItemColors");
			}

			// 背景色リストを作成する.
			var colors:Array = new Array();
			// 表の行数を取得する.
			var rowNum:int = this.dataProvider.length;
			var rowCnt:int = this.rowCount;
			var rowMax:int = (rowNum > rowCnt) ? rowNum : rowCnt;
			if (rowMax < 50) 	rowMax = 50;
			// 就労状態に応じて背景色を変更する.
			for (var index:int = 0; index < rowMax; index++){
				if (index < rowNum) {
					var data:Object = this.dataProvider.getItemAt(index);
					// 集計行は 背景色設定対象から外す.
					// →lockedRow と lockedRow以外の背景色 は alternatingItemColors を使用して.
					//   それぞれ設定される.
					// →lockedrow は rowCount に含まれていない.
					if (data.hasOwnProperty("lockedRow"))	continue;

					// 就労状態を確認する.
					var statusId:int = data.workStatusId;
					if (statusId == WorkStatusId.WORKING && !isNaN(_colorInService)) {
						colors.push(_colorInService);
					}
					else if (statusId == WorkStatusId.LEAVE && !isNaN(_colorLeave)) {
						colors.push(_colorLeave);
					}
					else if (statusId == WorkStatusId.RETIRED && !isNaN(_colorRetire)) {
						colors.push(_colorRetire);
					}
					else{
						colors.push(_defaultColors[index%2]);
					}
				}
				else {
					colors.push(_defaultColors[index%2]);
				}
			}
			this.setStyle("alternatingItemColors", colors);
		}


//--------------------------------------
//  DataGrid Binding
//--------------------------------------
		/** 集計リスト */
		private var _monthlyList:ArrayCollection;
		public function set monthlyData(list:ArrayCollection):void
		{
			_monthlyList = list;
			createDataGrid();
		}

		/** 集計開始日付 */
		private var _startDate:Date;
		public function set startDate(date:Date):void
		{
			_startDate = date;
		}

		/** 集計終了日付 */
		private var _finishDate:Date;
		public function set finishDate(date:Date):void
		{
			_finishDate = date;
		}

		/** 集計単位 */
		private var _type:int = -1;
		public function set type(type:int):void
		{
			var flg:Boolean = false;
			if (this.visible && _type != type)	flg = true;
			_type = type;
			if (flg)	createDataGrid();
		}

		/** 集計項目 */
		private var _conttype:int = -1;
		public function set content(type:int):void
		{
			var flg:Boolean = false;
			if (this.visible && _conttype != type)	flg = true;
			_conttype = type;
			if (flg)	createDataGrid();
		}

		/** 背景色の定義：在職 */
		private var _colorInService:Number;
		public function set colorInService(color:Number):void
		{
			_colorInService = color;
		}

		/** 背景色の定義：休職 */
		private var _colorLeave:Number;
		public function set colorLeave(color:Number):void
		{
			_colorLeave = color;
		}

		/** 背景色の定義：退職 */
		private var _colorRetire:Number;
		public function set colorRetire(color:Number):void
		{
			_colorRetire = color;
		}

		/** 固定行背景色 */
		private var _lockedColors:Array;
		public function set colorLocked(color:Number):void
		{
			_lockedColors = new Array();
			_lockedColors.push(color);
		}

	}
}