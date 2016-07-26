package subApplications.accounting.web.custom
{
	import dto.StaffDto;

	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	import subApplications.accounting.dto.ProjectDto;
	import subApplications.accounting.dto.TransportationDto;
	import subApplications.accounting.logic.AccountingLogic;

	import utils.LabelUtil;

	/**
	 * TransportationのDataGridクラスです.
	 */
	public class TransportationDataGrid extends AccountingDataGrid
	{
		/** Dto */
		private var dto:TransportationDto = new TransportationDto();

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

		/** ソート位置 */
		protected var _sortColumnIndex:int = -1;

//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ
		 */
		public function TransportationDataGrid()
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

		/**
		 * ソート位置取得.
		 *
		 * @param e DataGridEvent
		 */
		protected function onHeaderRelease(e:DataGridEvent):void
		{
			_sortColumnIndex = e.columnIndex;
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
		 * プロジェクトコードソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 */
		private function projectCodeSort(obj1:Object, obj2:Object):int
		{
			var prj1:ProjectDto = obj1.project as ProjectDto;
			var prj2:ProjectDto = obj2.project as ProjectDto;
			return ObjectUtil.compare(prj1.projectCode, prj2.projectCode);
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

		/**
		 * プロジェクト名ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 */
		private function projectNameSort(obj1:Object, obj2:Object):int
		{
			var prj1:ProjectDto = obj1.project as ProjectDto;
			var prj2:ProjectDto = obj2.project as ProjectDto;
			return ObjectUtil.compare(prj1.projectName, prj2.projectName);
		}

		/**
		 * プロジェクト名（役職付き）取得処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		private function projectNamePositionLabel(data:Object, column:DataGridColumn):String
		{
			// プロジェクト名を取得する.
			var projectName:String = projectNameLabel(data, column);

			// データを取得する.
			var project:ProjectDto = data[column.dataField] as ProjectDto;
			if (!project)		return projectName;
			if (!(project.projectPositionAlias && StringUtil.trim(project.projectPositionAlias).length > 0)) 	return projectName;

			return projectName + " (" + project.projectPositionAlias + ")";;
		}

		/**
		 * 申請者 氏名取得処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		private function staffNameLabel(data:Object, column:DataGridColumn):String
		{
			// データを取得する.
			var staff:StaffDto = data[column.dataField] as StaffDto;
			if (!staff)		return "";
			if (!staff.staffName) 	return "";

			return getStaffName(staff);
		}

		/**
		 * 申請者 氏名ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 */
		private function staffNameSort(obj1:Object, obj2:Object):int
		{
			var name1:String = getStaffName(obj1.staff as StaffDto);
			var name2:String = getStaffName(obj2.staff as StaffDto);
			return ObjectUtil.compare(name1, name2);
		}

		/**
		 * 申請者 氏名取得.
		 *
		 * @param  staff 申請者情報.
		 * @return 申請者氏名.
		 */
		private function getStaffName(staff:StaffDto):String
		{
			if (!staff)		return "";

			// 最新データでフォーマット変換する.
			if (staff.staffName) {
				return staff.staffName.fullName;
			}
			else {
				return "";
			}
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