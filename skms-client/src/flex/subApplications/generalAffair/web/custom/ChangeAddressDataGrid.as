package subApplications.ChangeAddress.web.custom
{
	import dto.StaffDto;

	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	import subApplications.accounting.dto.ProjectDto;
	import subApplications.accounting.dto.TransportationDto;
	import subApplications.generalAffair.logic.ChangeAddressApplyLogic;
	import subApplications.generalAffair.web.ChangeAddressApply;


	/**
	 * ChangeAddressのDataGridクラスです.
	 */
	public class ChangeAddressDataGrid extends DataGrid
	{
		/** カラム：状態 */
		protected var _colTransportationStatus :DataGridColumn;
		/** カラム：交通費申請ID */
		protected var _colTransportationId     :DataGridColumn;
		/** カラム：氏名 */
		protected var _colStaffName            :DataGridColumn;
		/** カラム：プロジェクトコード */
		protected var _colProjectCode          :DataGridColumn;
		/** カラム：プロジェクト名 */
		protected var _colProjectName          :DataGridColumn;
		/** カラム：金額 */
		protected var _colTransportationExpense:DataGridColumn;

//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function ChangeAddressDataGrid()
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
		 * 一覧のv初期化.
		 *
		 */
//		override protected function onCreateComplete():void
		{
			// イベント登録：ソート位置取得.
			addEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease, false);

			var columnItems:Array = new Array();
			// 状態.
			columnItems.push(makeColumnTransportationStatus());
			// 交通費申請ID.
			columnItems.push(makeColumnTransportationId());
			// 氏名.
			if (ObjectUtil.compare(actionMode, AccountingLogic.ACTION_VIEW_APPROVAL) == 0   ||
				ObjectUtil.compare(actionMode, AccountingLogic.ACTION_VIEW_APPROVAL_AF) == 0) {
				columnItems.push(makeColumnStaffName());
			}
			// プロジェクトコード.
			columnItems.push(makeColumnProjectCode());
			// プロジェクトコード名.
			columnItems.push(makeColumnProjectName());
			// 金額.
			columnItems.push(makeColumnTransportationExpense());

			// カラムを定義する.
			this.columns = columnItems;
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * カラム作成 状態.
		 *
		 * @return カラム
		 */
		protected function makeColumnTransportationStatus():DataGridColumn
		{
			_colTransportationStatus = new DataGridColumn();
			_colTransportationStatus.headerText = "状態";
			_colTransportationStatus.dataField  = "transportationStatusName";
			_colTransportationStatus.width      = 70;
			return _colTransportationStatus;
		}

		/**
		 * カラム作成 交通費申請ID.
		 *
		 * @return カラム
		 */
		protected function makeColumnTransportationId():DataGridColumn
		{
			_colTransportationId = new DataGridColumn();
			_colTransportationId.headerText = "申請ID";
			_colTransportationId.dataField  = "transportationId";
			_colTransportationId.width      = 50;
			return _colTransportationId
		}

		/**
		 * カラム作成 プロジェクトコード.
		 *
		 * @return カラム
		 */
		protected function makeColumnProjectCode():DataGridColumn
		{
			_colProjectCode = new DataGridColumn();
			_colProjectCode.headerText = "プロジェクトコード";
			_colProjectCode.dataField  = "project";
			_colProjectCode.width      = 90;
			_colProjectCode.labelFunction       = projectCodeLabel;
			_colProjectCode.sortCompareFunction = projectCodeSort;
			return _colProjectCode;
		}

		/**
		 * カラム作成 プロジェクト名.
		 *
		 * @return カラム
		 */
		protected function makeColumnProjectName():DataGridColumn
		{
			_colProjectName = new DataGridColumn();
			_colProjectName.headerText = "プロジェクト名";
			_colProjectName.dataField  = "project";
			_colProjectName.width      = 160;
			/*
			if (ObjectUtil.compare(actionMode, AccountingLogic.ACTION_VIEW_APPROVAL) == 0) {
				_colProjectName.labelFunction   = projectNamePositionLabel;
			}
			else {
				_colProjectName.labelFunction       = projectNameLabel;
				_colProjectName.sortCompareFunction = projectNameSort;
			}
			*/
			_colProjectName.labelFunction       = projectNameLabel;
			_colProjectName.sortCompareFunction = projectNameSort;
			return _colProjectName;
		}

		/**
		 * カラム作成 氏名.
		 *
		 * @return カラム
		 */
		protected function makeColumnStaffName():DataGridColumn
		{
			_colStaffName = new DataGridColumn();
			_colStaffName.headerText = "申請者";
			_colStaffName.dataField  = "staff";
			_colStaffName.width      = 70;
			_colStaffName.labelFunction       = staffNameLabel;
			_colStaffName.sortCompareFunction = staffNameSort;
			return _colStaffName;
		}

		/**
		 * カラム作成 金額.
		 *
		 * @return カラム
		 */
		protected function makeColumnTransportationExpense():DataGridColumn
		{
			_colTransportationExpense = new DataGridColumn();
			_colTransportationExpense.headerText      = "金額";
			_colTransportationExpense.dataField       = "transportationTotal";
			_colTransportationExpense.width           = 80;
			_colTransportationExpense.labelFunction    = LabelUtil.expenseLabel;;
			return _colTransportationExpense;
		}

		/**
		 * プロジェクトコード取得処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		private function projectCodeLabel(data:Object, column:DataGridColumn):String
		{
			// データを取得する.
			var project:ProjectDto = data[column.dataField] as ProjectDto;
			if (!project)	return "";

			// フォーマット変換する.
			return project.projectCode;
	    }


		/**
		 * プロジェクト名取得処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		private function projectNameLabel(data:Object, column:DataGridColumn):String
		{
			// データを取得する.
			var project:ProjectDto = data[column.dataField] as ProjectDto;
			if (!project)	return "";

			// フォーマット変換する.
			return project.projectName;
	    }



//--------------------------------------
//  DataGrid Binding
//--------------------------------------
		/**
		 * 一覧データの設定.
		 *
		 * @param value 一覧データ.
		 */
		override public function set dataProvider(value:Object):void
		{
			super.dataProvider = value;
			if (_sortColumnIndex >= 0) {
				// ソートされていたら、指定ソート状態で表示する.
				var event:DataGridEvent = new DataGridEvent(DataGridEvent.HEADER_RELEASE);
				event.columnIndex = _sortColumnIndex;
				dispatchEvent(event);
			}
		}
	}
}