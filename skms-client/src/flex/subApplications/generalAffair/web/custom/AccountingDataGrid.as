package subApplications.generalAffair.web.custom
{
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

	import utils.LabelUtil;
	import subApplications.generalAffair.logic.AccountingLogic;


	/**
	 * のDataGridクラスです.
	 */
	public class AccountingDataGrid extends DataGrid
	{
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
		}

//--------------------------------------
//  Function
//--------------------------------------

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
					// 備考.
					case "AcademicBackgroundDatenote":
						editor.maxChars = 128;
						break;
				}
			}
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
			column.dataField       = "AcademicBackgroundDatenote";
			column.width           = 150;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_UPDATE) == 0) {
				column.itemRenderer = new ClassFactory(StaffApplyItemRenderer);
			}
			return column;
		}
		
		/**
		 * カラム作成 経歴.
		 *
		 * @return カラム.
		 */
		protected function makeColumnHistory():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText      = "経歴";
			column.dataField       = "AcademicBackgroundDatenote";
			column.width           = 150;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_UPDATE) == 0) {
				column.itemRenderer = new ClassFactory(StaffApplyItemRenderer);
			}
			return column;
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

	}
}