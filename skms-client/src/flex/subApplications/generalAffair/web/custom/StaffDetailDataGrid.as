package subApplications.generalAffair.web.custom
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

	import utils.LabelUtil;
	import subApplications.generalAffair.dto.StaffDetailDto;
	import subApplications.generalAffair.logic.AccountingLogic;

	/**
	 * StaffDetailのDataGridクラスです.
	 */
	public class StaffDetailDataGrid extends AccountingDataGrid
	{
		/** Dto */
		private var dto:StaffDetailDto = new StaffDetailDto();

		/** デフォルト行の背景色リスト */
		private var _defaultColors:Array;

//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function StaffDetailDataGrid()
		{
			super();
		}

//--------------------------------------
//  Initialization
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
//			addEventListener(DataGridEvent.ITEM_FOCUS_OUT,onItemFocosOut);

			var columnItems:Array = new Array();
			// 日付.
			columnItems.push(makeColumnStaffDate());
//			// 備考.
//			columnItems.push(makeColumnNote());		
			// 経歴.
			columnItems.push(makeColumnHistory());

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
//--------------------------------------
//  UI Event Handler
//--------------------------------------


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * カラム作成 日付.
		 *
		 * @return カラム
		 */
		protected function makeColumnStaffDate():DataGridColumn
		{
			var column:DataGridColumn = new DataGridColumn();
			column.headerText = "日付";
			column.dataField  = "AcademicBackgroundDate";
			column.width      = 100;
			column.itemEditor      = new ClassFactory(EditDateField);
			column.editorDataField = "editedDate"
			column.labelFunction   = LabelUtil.dateLabel;
			if (ObjectUtil.compare(_actionMode, AccountingLogic.ACTION_UPDATE) == 0) {
				column.itemRenderer = new ClassFactory(StaffApplyItemRenderer);
			}
			return column;
		}
	}
}