package subApplications.project.logic
{
	import components.PopUpWindow;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.DragEvent;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import mx.validators.Validator;
	
	import subApplications.project.dto.MCustomerDto;
	import subApplications.project.dto.ProjectBillDto;
	import subApplications.project.dto.ProjectDto;
	import subApplications.project.dto.ProjectMemberDto;
	import subApplications.project.web.ProjectEntry;
	import subApplications.project.web.custom.ProjectBillForm;

	/**
	 * ProjectEntryのLogicクラスです.
	 */
	public class ProjectEntryLogic extends Logic
	{
		/** 変更対象のプロジェクト */
		private var _project:ProjectDto;

		/** 社員マスタリスト */
		private var _staffList:ArrayCollection;

		/** 役職マスタリスト */
		private var _positionList:ArrayCollection;

		/** 顧客マスタリスト */
		private var _customerList:ArrayCollection;

		/** 銀行口座マスタリスト */
		private var _bankList:ArrayCollection;

		/** 削除予定の請求書リスト */
		private var _deleteBillList:ArrayCollection;

		/** プロジェクトreloadフラグ */
		private var _projectReload:Boolean = false;

		/** 会社設立年 */
		private const COMPANY_ESTABLISH_DATE:Date = new Date(1984, 10-1);


// 2009.03.24 start 日付範囲のチェック方法変更によりコメントアウト.
//		/** 関連データ定義 */
//		private static const RELATED_DATEFIELD_ITEMS:Array
//								= new Array({target:"planedStartDate",  relate:"planedFinishDate", rangeEnd:true},
//											{target:"planedFinishDate", relate:"planedStartDate",  rangeStart:true},
//											{target:"actualStartDate",  relate:"actualFinishDate", rangeEnd:true},
//											{target:"actualFinishDate", relate:"actualStartDate",  rangeStart:true}
//											);
// 2009.03.24 end   日付範囲のチェック方法変更によりコメントアウト.

		/** 関連データ定義 */
		private static const RELATED_DATEFIELD_ITEMS2:Array
								= new Array({control:"projectEntry", target:"planedStartDate",
											 relateItems:new Array ({control:"projectMemberList", target:"planedStartDate",  rangeEnd:true},
															 		{control:"projectMemberList", target:"planedFinishDate", rangeEnd:true},
															 		{control:"projectEntry",      target:"planedFinishDate", rangeEnd:true}	)
											 },
											{control:"projectEntry", target:"planedFinishDate",
											 relateItems:new Array ({control:"projectEntry",      target:"planedStartDate",  rangeStart:true},
											 						{control:"projectMemberList", target:"planedStartDate",  rangeStart:true},
															 		{control:"projectMemberList", target:"planedFinishDate", rangeStart:true})
											 },
											{control:"projectEntry", target:"actualStartDate",
											 relateItems:new Array ({control:"projectMemberList", target:"actualStartDate",  rangeEnd:true},
															 		{control:"projectMemberList", target:"actualFinishDate", rangeEnd:true},
															 		{control:"projectEntry",      target:"actualFinishDate", rangeEnd:true}	)
											 },
											{control:"projectEntry", target:"actualFinishDate",
											 relateItems:new Array ({control:"projectEntry",      target:"actualStartDate",  rangeStart:true},
											 						{control:"projectMemberList", target:"actualStartDate",  rangeStart:true},
															 		{control:"projectMemberList", target:"actualFinishDate", rangeStart:true})
											 },
											{control:"projectMemberList", target:"planedStartDate",
											 relateItems:new Array ({control:"projectEntry",      target:"planedStartDate",  rangeStart:true},
											 						{control:"projectMemberList", target:"planedFinishDate", rangeEnd:true},
															 		{control:"projectEntry",      target:"planedFinishDate", rangeEnd:true}	)
											 },
											{control:"projectMemberList", target:"planedFinishDate",
											 relateItems:new Array ({control:"projectEntry",      target:"planedStartDate",  rangeStart:true},
											 						{control:"projectMemberList", target:"planedStartDate",  rangeStart:true},
															 		{control:"projectEntry",      target:"planedFinishDate", rangeEnd:true}	)
											 },
											{control:"projectMemberList", target:"actualStartDate",
											 relateItems:new Array ({control:"projectEntry",      target:"actualStartDate",  rangeStart:true},
											 						{control:"projectMemberList", target:"actualFinishDate", rangeEnd:true},
															 		{control:"projectEntry",      target:"actualFinishDate", rangeEnd:true}	)
											 },
											{control:"projectMemberList", target:"actualFinishDate",
											 relateItems:new Array ({control:"projectEntry",      target:"actualStartDate",  rangeStart:true},
											 						{control:"projectMemberList", target:"actualStartDate",  rangeStart:true},
															 		{control:"projectEntry",      target:"actualFinishDate", rangeEnd:true}	)
											 }
											);

		/** プロジェクトメンバ 必須データ定義 */
		private static const MEMBER_REQUIRED_ITEMS:Array
								= new Array({target:"planedStartDate",  name:"開始予定日", error:false},
											{target:"planedFinishDate", name:"完了予定日", error:false}
											);


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectEntryLogic()
		{
			super();
		}

//--------------------------------------
//  Initialization
//--------------------------------------
		/**
		 * onCreationCompleteHandler
		 */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// 初期設定をする.
			view.enabled = false;
			_deleteBillList = new ArrayCollection();

			// 引き継ぎデータを取得する.
			onCreationCompleteHandler_setSuceedData();

			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		protected function onCreationCompleteHandler_setSuceedData():void
		{
			_project = view.data.project;								// プロジェクト.
			if (!_project) _project = new ProjectDto();
		}

		/**
		 * 表示データの設定.
		 *
		 */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
			// マスタを取得する.
			requestData_customerList();								// 顧客リスト取得.
			requestCata_staffList();								// 社員リスト取得.
			requestData_positionList();								// 役職リスト取得.
			requestData_bankList();									// 銀行口座リスト取得.

			// プロジェクト情報はマスタ取得後に設定する.
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * プロジェクトメンバ DragEnter.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_projectMemberList(e:DragEvent):void
		{
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}

		/**
		 * プロジェクトメンバ DragOver.
		 *
		 * @param e DragEvent
		 */
		public function onDragOver_projectMemberList(e:DragEvent):void
		{
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}

		/**
		 * プロジェクトメンバ Drag＆Drop.
		 *
		 * @param e DragEvent
		 */
		public function onDragDrop_projectMemberList(e:DragEvent):void
		{
			// イベントをキャンセルすると、マウスにあわせてリストが.
			// スクロールされるためドラッグデータをクリアする.
			e.dragSource = new DragSource();

			// drop先を取得する.
			var index:int = view.projectMemberList.calculateDropIndex(e);

			var control:DataGrid = e.dragInitiator as DataGrid;
			if (ObjectUtil.compare(control.id, "projectStaffList") == 0) {
				// プロジェクトスタッフをプロジェクトメンバに移動する.
				moveProjectStaff_toProjectMember(index);
			}
			else if (ObjectUtil.compare(control.id, "projectMemberList") == 0) {
				// プロジェクトメンバ内で移動する.
				moveProjectMember_toProjectMember(index);
			}
		}

		/**
		 * プロジェクトメンバ Drag＆Drop終了.
		 *
		 * @param e DragEvent
		 */
		public function onDragComplete_projectMemberList(e:DragEvent):void
		{
			// validateチェックをする.
			validateProjectMemberListt();
		}


		/**
		 * スタッフメンバ DragEnter.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_projectStaffList(e:DragEvent):void
		{
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}

		/**
		 * スタッフメンバ DragOver.
		 *
		 * @param e DragEvent
		 */
		public function onDragOver_projectStaffList(e:DragEvent):void
		{
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}

		/**
		 * スタッフメンバ Drag＆Drop.
		 *
		 * @param e DragEvent
		 */
		public function onDragDrop_projectStaffList(e:DragEvent):void
		{
			// イベントをキャンセルすると、マウスにあわせてリストが.
			// スクロールされるためドラッグデータをクリアする.
			e.dragSource = new DragSource();

			// drop先を取得する.
			var index:int = view.projectStaffList.calculateDropIndex(e);

			var control:DataGrid = e.dragInitiator as DataGrid;
			if (ObjectUtil.compare(control.id, "projectStaffList") == 0) {
				// プロジェクトスタッフ内で移動する.
				moveProjectStaff_toProjectStaff(index);
			}
			else if (ObjectUtil.compare(control.id, "projectMemberList") == 0) {
				// プロジェクトメンバをプロジェクトスタッフに移動する.
				moveProjectMember_toProjectStaff(index);
			}
		}

		/**
		 * スタッフメンバ Drag＆Drop終了.
		 *
		 * @param e DragEvent
		 */
		public function onDragComplete_projectStaffList(e:DragEvent):void
		{
			// validateチェックをする.
			validateProjectMemberListt();
		}


		/**
		 * プロジェクトメンバ データ編集開始.
		 *
		 * @param e DataGridEvent
		 */
		public function onItemFocusIn_projectMemberList(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			if (dg.itemEditorInstance && dg.itemEditorInstance is ComboBox) {
				// 編集項目を取得する.
				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
				var editor:ComboBox = dg.itemEditorInstance as ComboBox;
				var cell:Object = dg.selectedItem.hasOwnProperty(col.dataField) ? dg.selectedItem[col.dataField] : "";

				switch (col.dataField) {
					// 役職
					case "projectPositionAlias":
						editor.dataProvider = _positionList;
						if(cell){
							editor.selectedItem = cell.toString();
						}
						editor.open();
						break;
				}
			}
		}

// 2009.03.24 start 日付範囲のチェック方法変更によりコメントアウト.
//		/**
//		 * プロジェクトメンバ データ編集終了.
//		 *
//		 * @param e DataGridEvent
//		 */
//		public function onItemFocusOut_projectMemberList(e:DataGridEvent):void
//		{
//			// datefieldが有効データかどうかチェックする.
//			var dg:DataGrid = e.currentTarget as DataGrid;
//			if (dg.itemEditorInstance && dg.itemEditorInstance is DateField) {
//				// 編集項目を取得する.
//				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
//				var editor:DateField = dg.itemEditorInstance as DateField;
//
//				switch (col.dataField) {
//					// 予定日、実績日.
//					case "planedStartDate":
//					case "planedFinishDate":
//					case "actualStartDate":
//					case "actualFinishDate":
//						// 編集行を取得する.
//						var rowIndex:int = e.rowIndex;
//						var rowList:ArrayCollection = e.currentTarget.dataProvider as ArrayCollection;
//						if (rowList && rowList.length > 0) {
//							// editor は Component なので id が存在しないため DateField を作成する.
//							var target:DateField = new DateField();
//							target.id = col.dataField;
//							target.selectedDate = editor.selectedDate;
//							// 編集行を取得する.
//							var rowData:Object = rowList.getItemAt(rowIndex);
//							// 有効データかどうか確認する.
//							var ret:Boolean = checkDateField_selectableRange(target, rowData);
//							if (!ret) {
//								rowData[col.dataField] = null;
//							}
//						}
//						break;
//				}
//				// dateField で設定すると valueCommit が呼ばれないためここで呼ぶ.
//				onValidateCheck(e as Event);
//			}
//		}
// 2009.03.24 end   日付範囲のチェック方法変更によりコメントアウト.

		/**
		 * プロジェクトメンバ データ編集終了.
		 *
		 * @param e DataGridEvent
		 */
		public function onItemFocusOut_projectMemberList2(e:DataGridEvent):void
		{
			// datefieldが有効データかどうかチェックする.
			var dg:DataGrid = e.currentTarget as DataGrid;
			if (dg.itemEditorInstance && dg.itemEditorInstance is DateField) {
				// 編集項目を取得する.
				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
				var editor:DateField = dg.itemEditorInstance as DateField;

				switch (col.dataField) {
					// 予定日、実績日.
					case "planedStartDate":
					case "planedFinishDate":
					case "actualStartDate":
					case "actualFinishDate":
						// 編集行を取得する.
						var rowIndex:int = e.rowIndex;
						var rowList:ArrayCollection = e.currentTarget.dataProvider as ArrayCollection;
						if (rowList && rowList.length > 0) {
							// editor は Component なので id が存在しないため DateField を作成する.
							var target:DateField = new DateField();
							target.id = col.dataField;
							target.selectedDate = editor.selectedDate;
							// 編集行を取得する.
							var rowData:Object = rowList.getItemAt(rowIndex);
							// 有効データかどうか確認する.
							var ret:Boolean = checkDateField_selectableRange2("projectMemberList", target, rowData);
							if (!ret) {
								rowData[col.dataField] = null;
							}
						}
						break;
				}
			}
			// validateチェックをする.
			validateProjectMemberListt();
		}


// 2009.03.24 start 日付範囲のチェック方法変更によりコメントアウト.
//		/**
//		 * DateFieldフォーカスアウト.
//		 *
//		 * @param e FocusEvent
//		 */
//		public function onFocusOut_dateField(e:FocusEvent):void
//		{
//			// 入力データのチェックを行なう.
//			// →parseFunction はキー入力毎に呼ばれるため focusOut したときに入力チェックする.
//			var target:DateField = e.currentTarget as DateField;
//			var ret:Boolean = view.projectLogic.checkDateField_text(target);
//			if (!ret) {
//				target.text = "";
//				return;
//			}
//
//			// 有効データかどうかチェックする.
//			var ret2:Boolean = checkDateField_selectableRange(target, view, "selectedDate");
//			if (!ret2) {
//				target.text = "";
//				return;
//			}
//		}
// 2009.03.24 end   日付範囲のチェック方法変更によりコメントアウト.

		/**
		 * DateFieldフォーカスアウト.
		 *
		 * @param e FocusEvent
		 */
		public function onFocusOut_dateField2(e:FocusEvent):void
		{
//			// 入力データのチェックを行なう.
//			// →parseFunction はキー入力毎に呼ばれるため focusOut したときに入力チェックする.
			var target:DateField = e.currentTarget as DateField;
//			var ret:Boolean = view.projectLogic.checkDateField_text(target);
//			if (!ret) {
//				target.text = "";
//				return;
//			}

			// 有効データかどうかチェックする.
			var ret2:Boolean = checkDateField_selectableRange2("projectEntry", target);
			if (!ret2) {
				target.text = "";
				return;
			}
		}

// 2009.03.24 start 日付範囲のチェック方法変更によりコメントアウト.
//		/**
//		 * DateFieldコントロールOpen.
//		 *
//		 * @param e DropdownEvent
//		 */
//		public function onOpen_dateField(e:DropdownEvent):void
//		{
//			var target:DateField = e.currentTarget as DateField;
//			if (!target)		return;
//
//			// 有効範囲を設定する.
//			var range:Object = getDateField_selectableRange(target.id, view, "selectedDate");
//			target.selectableRange = range;
//		}
// 2009.03.24 end   日付範囲のチェック方法変更によりコメントアウト.

		/**
		 * DateFieldコントロールOpen.
		 *
		 * @param e DropdownEvent
		 */
		public function onOpen_dateField2(e:DropdownEvent):void
		{
			var target:DateField = e.currentTarget as DateField;
			if (!target)		return;

			// 有効範囲を設定する.
			var range:Object = getDateField_selectableRange2("projectEntry", target.id);
			target.selectableRange = range;
		}

		/**
		 * 客先名選択.
		 *
		 * @param e ListEvent
		 */
		public function onChange_projectCustomerName(e:ListEvent):void
		{
			// 選択客先名からプロジェクトコード（YY$XX-99#）を作成する.
			if (e.target.selectedItem.customerId > 0 && view.projectCode.length <= 3) {
				var custom:Object = e.target.selectedItem;
				if (custom) {
					// 現在のYY期を計算する.
					var now:Date = new Date();
					var term:int = now.getFullYear() - COMPANY_ESTABLISH_DATE.getFullYear();
					if (now.getMonth() >= COMPANY_ESTABLISH_DATE.getMonth()) {
						term = term + 1;
					}

					// プロジェクトコードの設定状態を確認する.
					var flg:Boolean = false;
					if (view.projectCode.length == 3) {				// YY$が一致しているかどうか確認する.
						var tmp3:String = term.toString() + custom.customerType;
						if (ObjectUtil.compare(view.projectCode.text, tmp3) == 0) {
							flg = true;
						}
					}
					else if (view.projectCode.length == 2) {		// YYが一致しているかどうか確認する.
						if (ObjectUtil.compare(view.projectCode.text, term.toString()) == 0) {
							flg = true;
						}
					}
					else if (view.projectCode.length == 0) {		// 未設定かどうか確認する.
						flg = true;
					}
					if (flg)
						view.projectCode.text = term.toString() + custom.customerType + custom.customerNo + "-";
				}
			}
		}

		/**
		 * プロジェクトコード入力終了.
		 *
		 * @param e FocusEvent
		 */
		public function onFocusOut_projectCode(e:FocusEvent):void
		{
			// 入力プロジェクトコード（YY$XX-99#）から客先名を選択する.
			if (view.projectCode.length >= 5 && !(view.projectCustomerName.selectedItem.customerId > 0)) {
				var cCode:String = view.projectCode.text.substr(2, 3);
				// 客先コードと一致するかどうか確認する.
				var cList:ArrayCollection = view.projectCustomerName.dataProvider as ArrayCollection;
				for (var i:int = 0; i < cList.length; i++) {
					var customCode:String = cList.getItemAt(i).customerType + cList.getItemAt(i).customerNo;
					if (ObjectUtil.compare(cCode, customCode) == 0) {
						view.projectCustomerName.selectedIndex = i;
						break;
					}
				}
			}
		}


		/**
		 * validateチェック.
		 *
		 * @return チェック結果.
		 */
		public function validateBaseInfo():Boolean
		{
			if (!view.authorize)	return true;

			var ret:Boolean = validateValidateItems();
			if (!ret)	return false;

			ret = validateProjectMemberListt();
			if (!ret)	return false;

			return true;
		}

		/**
		 * validateチェック（validateItems）.
		 *
		 * @return チェック結果.
		 */
		public function validateValidateItems():Boolean
		{
			if (!view.authorize)	return true;

			// テキストフィールドのvalidateチェックを行なう.
			var results:Array = Validator.validateAll(view.validateItems);

			// validate 結果を設定する.
			if (!(results && results.length > 0)) 		return true;
			else 									 	return false;
		}

		/**
		 * validatorチェック（DataGrid プロジェクトメンバ）.
		 *
		 * @return チェック結果.
		 */
		public function validateProjectMemberListt():Boolean
		{
			if (!view.authorize)	return true;

			// チェックNGのエラーメッセージを作成する.
			var msg:String = "";

			// DataGridのvalidateチェックを行なう.
			var requireItems:Array = ObjectUtil.copy(MEMBER_REQUIRED_ITEMS) as Array;
			var list:ArrayCollection = view.projectMemberList.dataProvider as ArrayCollection;
			if (list) {
				// validateチェックをする.
				for (var i:int = 0; i < list.length; i++) {
					var member:ProjectMemberDto = list.getItemAt(i) as ProjectMemberDto;
					// 必須チェックを行なう.
					for (var j:int = 0; j < requireItems.length; j++) {
						if (!member[requireItems[j].target])
							requireItems[j].error = true;
					}
				}
				// errorメッセージを作成する.
				for (var k:int = 0; k < requireItems.length; k++) {
					if (!requireItems[k].error)	continue;
					if (msg.length > 0)	msg += "・";
					msg += requireItems[k].name;
				}
				if (msg.length > 0) msg += "は必須です。";
			}

			// 関連データチェックを行なう.
			// プロジェクト開始実績日なしのとき メンバ開始実績日ありは NG とする.
			if (!view.actualStartDate.selectedDate && list) {
				for (var n:int = 0; n < list.length; n++) {
					if (list.getItemAt(n).actualStartDate) {
						if (msg.length > 0)	msg += "\n";
						msg += "プロジェクト開始実績日が設定されていません。";
						break;
					}
				}
			}
			view.projectMemberList.errorString = msg;

			if (msg && msg.length > 0)			return false;
			else 								return true;
		}


		/**
		 * 基本情報or請求書情報タブクリック.
		 *
		 * @param event IndexChangedEvent
		 */
		public function onTabChange_tabnavi(e:IndexChangedEvent):void
		{
			// 請求書ボタンの有効/無効を設定する.
			setBillButton_enabled();
		}


		/**
		 * 請求書作成ボタン押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_linkNew(e:MouseEvent):void
		{
			// 現在のタブ数を取得する.
			var tabnum:int = view.tabnavi.numChildren;

			// 請求書タブを作成する.
			var billform:ProjectBillForm = new ProjectBillForm();
			billform.displayBill(tabnum, null, ObjectUtil.copy(_bankList) as ArrayCollection);

			// タブを追加する.
			view.tabnavi.addChild(billform);

			// 追加したタブを選択する.
			view.tabnavi.selectedChild = billform;
		}

		/**
		 * 請求書複製ボタン押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_linkCopy(e:MouseEvent):void
		{
			// 複製する請求書を取得する.
			var billform:ProjectBillForm = view.tabnavi.selectedChild as ProjectBillForm;
			var bill:ProjectBillDto = billform.createBillCopy();

			// 請求書タブを作成する.
			var tabnum:int = view.tabnavi.numChildren;
			var newtab:ProjectBillForm = new ProjectBillForm();
			newtab.displayBill(tabnum, bill, ObjectUtil.copy(_bankList) as ArrayCollection);

			// タブを追加する.
			view.tabnavi.addChild(newtab);

			// 追加したタブを選択する.
			view.tabnavi.selectedChild = newtab;
		}

		/**
		 * 請求書削除ボタン押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_linkDelete_confirm(e:MouseEvent):void
		{
			Alert.show("削除してもよろしいですか？", "", 3, view, onButtonClick_linkDelete_confirmResult);
		}
		protected function onButtonClick_linkDelete_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_linkDelete(e);				// 請求書削除.
		}
		protected function onButtonClick_linkDelete(e:Event):void
		{
			var item:Container = view.tabnavi.selectedChild;
			if (item is ProjectBillForm) {
				// 請求書情報を取得し、削除リストに追加する.
				var billtab:ProjectBillForm = item as ProjectBillForm;
				var bill:Object = billtab.createBillDelete();
				_deleteBillList.addItem(bill);

				// 請求書タブを削除し、基本情報タブを選択する.
				view.tabnavi.removeChild(billtab);
				view.tabnavi.selectedIndex = 0;
			}
		}

		/**
		 * プロジェクトメンバ→スタッフ移動ボタン押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_fromProjectMemberToProjectStaff(e:MouseEvent):void
		{
			// プロジェクトメンバをプロジェクトスタッフに移動する.
			moveProjectMember_toProjectStaff();
			// validateチェックをする.
			validateProjectMemberListt();
		}

		/**
		 * プロジェクトスタッフ→メンバ移動ボタン押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_fromProjectStaffToProjectMember(e:MouseEvent):void
		{
			// プロジェクトスタッフをプロジェクトメンバに移動する.
			moveProjectStaff_toProjectMember();
			// validateチェックをする.
			validateProjectMemberListt();
		}


		/**
		 * プロジェクト予定日反映ボタンのクリックイベント
		 *
		 * @param event MouseEvent
		 */
		public function onButtonClick_planedDateEntry(e:MouseEvent):void
		{
			// プロジェクト予定日を取得する.
			var startDate:Date  = view.planedStartDate.selectedDate;
			var finishDate:Date = view.planedFinishDate.selectedDate;

			// プロジェクトメンバを取得する.
			var members:ArrayCollection = view.projectMemberList.dataProvider as ArrayCollection;
			for (var i:int = 0; i < members.length; i++) {
				var member:ProjectMemberDto = members.getItemAt(i) as ProjectMemberDto;
				if (!member)	continue;
				// 開始日が未設定のとき.
				if (startDate && !member.planedStartDate) {
					member.planedStartDate = startDate;
				}
				// 完了日が未設定のとき.
				if (finishDate && !member.planedFinishDate) {
					member.planedFinishDate = finishDate;
				}
			}
			// validateチェックをする.
			validateProjectMemberListt();
		}

		/**
		 * プロジェクト実績日反映ボタンのクリックイベント
		 *
		 * @param event MouseEvent
		 */
		public function onButtonClick_actualDateEntry(e:MouseEvent):void
		{
			// プロジェクト実績日を取得する.
			var startDate:Date  = view.actualStartDate.selectedDate;
			var finishDate:Date = view.actualFinishDate.selectedDate;

			// プロジェクトメンバを取得する.
			var members:ArrayCollection = view.projectMemberList.dataProvider as ArrayCollection;
			for (var i:int = 0; i < members.length; i++) {
				var member:ProjectMemberDto = members.getItemAt(i) as ProjectMemberDto;
				if (!member)	continue;
				// 開始日が未設定のとき.
				if (startDate && !member.actualStartDate) {
					member.actualStartDate = startDate;
				}
				// 完了日が未設定のとき.
				if (finishDate && !member.actualFinishDate) {
					member.actualFinishDate = finishDate;
				}
			}
			// validateチェックをする.
			validateProjectMemberListt();
		}

		/**
		 * 「登録」ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:Event):void
		{
			// 各タブのvalidateチェックをする.
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				var ret:Boolean = false;
				var item:Object = view.tabnavi.getChildAt(index);
				if (item is ProjectBillForm) {
					ret = item.validateAll();
				}
				else {
					ret = validateBaseInfo();
				}
				if (!ret) {
					view.tabnavi.selectedIndex = index;
					Alert.show("入力項目に不備があるため登録できません。\n修正してください。");
					return;
				}
			}

			Alert.show("登録してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);				// 登録.
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// 登録データを作成する.
			var project:ProjectDto   = _project;
			project.projectCode      = view.projectCode.text.length > 0 ? view.projectCode.text : null;
			project.projectName      = view.projectName.text.length > 0 ? view.projectName.text : null;
			project.customerId       = view.projectCustomerName.selectedItem.customerId > 0 ? view.projectCustomerName.selectedItem.customerId : null;
			project.orderNo          = view.projectOrderNo.text.length > 0 ? view.projectOrderNo.text : null;
			project.orderName        = view.projectOrderName.text.length > 0 ? view.projectOrderName.text : null;
			project.planedStartDate  = view.planedStartDate.selectedDate;
			project.planedFinishDate = view.planedFinishDate.selectedDate;
			project.actualStartDate  = view.actualStartDate.selectedDate;
			project.actualFinishDate = view.actualFinishDate.selectedDate;
			project.note             = view.note.text.length > 0 ? view.note.text : null;
			// プロジェクト メンバ情報を設定する.
			project.projectMembers   =
				ProjectMemberDto.createMembers(view.projectMemberList.dataProvider as ArrayCollection,
											   _positionList,
											   view.projectStaffList.dataProvider as ArrayCollection);

			// プロジェクト完了実績日が設定されているならば
			if (project.actualFinishDate) {
				for each(var pm:ProjectMemberDto in project.projectMembers) {
					// メンバの完了実績日が未設定ならばプロジェクトの完了実績日を設定する.
					if (!pm.actualFinishDate) pm.actualFinishDate = new Date(project.actualFinishDate);
				}
			}
			// プロジェクト 請求書情報を設定する.
			project.projectBills     = new ArrayCollection();
			for (var index:int = 0; index < view.tabnavi.numChildren; index++) {
				// タブを取得する.
				var billtab:ProjectBillForm = view.tabnavi.getChildAt(index) as ProjectBillForm;
				if (!billtab) 		continue;

				// 請求書情報を取得する.
				var bill:Object = billtab.createBill();
				project.projectBills.addItem(bill);
			}
			for (var k:int = 0; k < _deleteBillList.length; k++) {
				// 削除する請求書情報を追加する.
				project.projectBills.addItem(_deleteBillList.getItemAt(k));
			}

			// プロジェクトを登録する.
			view.srv.getOperation("createProject").send(Application.application.indexLogic.loginStaff, project);
		}

		/**
		 * ヘルプボタンのクリックイベント
		 *
		 * @param event MouseEvent
		 */
		public function onButtonClick_help(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			if (view.tabnavi.selectedChild is ProjectBillForm) {
				opneHelpWindow("ProjectBillEntry");
			}
			else {
				opneHelpWindow("ProjectBaseEntry");
			}
		}
		public function onButtonClick_help2(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			opneHelpWindow("ProjectRef");
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_close(e:Event):void
		{
			if (_projectReload)		view.closeWindow(PopUpWindow.ENTRY);
			else					view.closeWindow();
		}


		/**
		 * createProject処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_createProject(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * getCustomerList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getCustomerList(e:ResultEvent):void
		{
			// 結果を取得する.
			_customerList = e.result as ArrayCollection;
			if (!_customerList)		_customerList = new ArrayCollection();

			// プロジェクト情報を設定する.
			setProjectInfo();
		}

		/**
		 * getProjectStaffList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getProjectStaffList(e:ResultEvent):void
		{
			// 結果を取得する.
			_staffList = e.result as ArrayCollection;
			if (!_staffList)		_staffList = new ArrayCollection();

			// プロジェクト情報を設定する.
			setProjectInfo();
		}

		/**
		 * getProjectPositionList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getProjectPositionList(e:ResultEvent):void
		{
			// 結果を取得する.
			_positionList = e.result as ArrayCollection;
			if (!_positionList)		_positionList = new ArrayCollection();
			_positionList.addItemAt({label:"", data:-99}, 0);

			// プロジェクト情報を設定する.
			setProjectInfo();
		}

		/**
		 * getBankList処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_getBankList(e:ResultEvent):void
		{
			// 結果を取得する.
			_bankList = e.result as ArrayCollection;
			if (!_bankList)			_bankList = new ArrayCollection();

			// プロジェクト情報を設定する.
			setProjectInfo();
		}


		/**
		 * createProjectの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_createProject(e:FaultEvent):void
		{
			var conflict:Boolean = ProjectLogic.alert_createProject(e);
			if (conflict)
				_projectReload = true;
		}

		/**
		 * getCustomerListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getCustomerList(e:FaultEvent):void
		{
			ProjectLogic.alert_getCustomerList(e);
			view.closeWindow();
		}

		/**
		 * getProjectStaffListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getProjectStaffList(e:FaultEvent):void
		{
			ProjectLogic.alert_getProjectStaffList(e);
			view.closeWindow();
		}

		/**
		 * getProjectPositionListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getProjectPositionList(e:FaultEvent):void
		{
			ProjectLogic.alert_getProjectPositionList(e);
			view.closeWindow();
		}

		/**
		 * getBankListの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_getBankList(e:FaultEvent):void
		{
			ProjectLogic.alert_getBankList(e);
			view.closeWindow();
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 顧客リストの取得.
		 *
		 */
		private function requestData_customerList():void
		{
			view.srv.getOperation("getCustomerList").send();
		}

		/**
		 * 社員リストの取得.
		 *
		 */
		private function requestCata_staffList():void
		{
			// 登録権限があるときだけ 社員リストを取得する.
			if (view.authorize)	{
				view.srv.getOperation("getProjectStaffList").send();
			}
		}

		/**
		 * 役職リストの取得.
		 *
		 */
		private function requestData_positionList():void
		{
			view.srv.getOperation("getProjectPositionList").send();
		}

		/**
		 * 銀行口座リストの取得.
		 *
		 */
		private function requestData_bankList():void
		{
			view.srv.getOperation("getBankList").send();
		}


		/**
		 * プロジェクト情報設定.
		 *
		 */
		private function setProjectInfo():void
		{
			// データ取得中かどうか確認する.
			var cursorID:int = CursorManager.getInstance().currentCursorID;
			if (ObjectUtil.compare(cursorID, CursorManager.NO_CURSOR) != 0) {
				return;
			}

			// プロジェクト情報を設定する.
			view.projectCode.text      = _project.projectCode;
			view.projectName.text      = _project.projectName;
			view.projectOrderNo.text   = _project.orderNo;
			view.projectOrderName.text = _project.orderName;
			view.planedStartDate.selectedDate  = _project.planedStartDate;
			view.planedFinishDate.selectedDate = _project.planedFinishDate;
			view.actualStartDate.selectedDate  = _project.actualStartDate;
			view.actualFinishDate.selectedDate = _project.actualFinishDate;
			view.note.text                     = _project.note;
			// プロジェクト メンバ情報を設定する.
			view.projectMemberList.dataProvider = _project.projectMembers;

			// プロジェクト スタッフリストを作成する.
			if (view.authorize) {
				if (_project.projectMembers) {
					var prjStfList:ArrayCollection = new ArrayCollection();
					// 社員 = プロジェクトメンバ + プロジェクトスタッフ.
					for each (var staff:ProjectMemberDto in _staffList) {
						var flg:Boolean = true;
						for (var k:int = 0; k < _project.projectMembers.length; k++) {
							var member:ProjectMemberDto = _project.projectMembers.getItemAt(k) as ProjectMemberDto;
							if (ObjectUtil.compare(staff.staffId, member.staffId) == 0) {
								flg = false;
								break;
							}
						}
						// プロジェクトメンバでない社員を追加する.
						if (flg) prjStfList.addItem(staff);
					}
					view.projectStaffList.dataProvider = prjStfList;
				}
				else {
					view.projectStaffList.dataProvider = _staffList;
				}
			}

			// 請求書情報を設定する.
			if (view.authorize) {
				if (_project.projectBills) {
					for (var bi:int = 0; bi < _project.projectBills.length; bi++) {
						// 請求書情報を取得する.
						var bill:ProjectBillDto = _project.projectBills.getItemAt(bi) as ProjectBillDto;

						// 請求書タブを設定する.
						var newtab:ProjectBillForm = new ProjectBillForm();
						newtab.displayBill(bi, bill, ObjectUtil.copy(_bankList) as ArrayCollection);
						view.tabnavi.addChild(newtab);
					}
				}
			}


			// 客先名を設定する.
			if (_customerList) {
				_customerList.addItemAt(MCustomerDto.createDummy(), 0);
				view.projectCustomerName.dataProvider = _customerList;
				for (var ci:int = 0; ci < _customerList.length; ci++) {
					if (_customerList.getItemAt(ci).customerId == _project.customerId) {
						view.projectCustomerName.selectedIndex = ci;
						break;
					}
				}
			}

			// (SDK-15301）Tabが 1つのとき、Tab名が省略表示されるため正式表示されるようにMouseEventを通知する.
			if (view.tabnavi.numChildren == 1)
				view.tabnavi.getTabAt(0).dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));

			// validateチェックをする.
			validateValidateItems();
			validateProjectMemberListt();

			// 請求書リンクボタンの有効/無効を設定する.
			setBillButton_enabled();

			// プロジェクト情報編集可能にする.
			view.enabled = true;
		}

		/**
		 * 請求書リンクボタンの有効/無効設定.
		 *
		 */
		private function setBillButton_enabled():void
		{
			// 作成は常に選択可能にする.
			view.linkNew.enabled = true;

			// 複製・削除は請求書が選択ていたら選択可能にする.
			var item:Container = view.tabnavi.selectedChild;
			if (item is ProjectBillForm) {
				view.linkCopy.enabled   = true;
				view.linkDelete.enabled = true;
			}
			else {
				view.linkCopy.enabled   = false;
				view.linkDelete.enabled = false;
			}
		}


		/**
		 * プロジェクトメンバ→スタッフ移動.
		 *
		 */
		private function moveProjectMember_toProjectStaff(insertIndex:int = -99):void
		{
			var indices:Array = view.projectMemberList.selectedIndices;
			if (!(indices && indices.length > 0))	return;
			indices.sort(Array.NUMERIC);
			var moveItems:Array = new Array();

			// index順にデータを処理する.
			var members:ArrayCollection   = ObjectUtil.copy(view.projectMemberList.dataProvider) as ArrayCollection;
			for (var i:int = 0; i < indices.length; i++) {
				// プロジェクトメンバからデータを取得する.
				var member:ProjectMemberDto = members.getItemAt(indices[i]) as ProjectMemberDto;
				// プロジェクトスタッフを追加する.
				addProjectStaff(member, insertIndex + i);
				moveItems.push(member);
				// プロジェクトメンバを削除する.
				removeProjectMember(member);
			}

			// スタッフID順に並び替える.
			sortProjectStaffList();

			// 移動データを選択状態にする.
			view.projectStaffList.editedItemPosition = null;
			var moveIndices:Array = calculateMoveIndex(moveItems, view.projectStaffList.dataProvider as ArrayCollection);
			view.projectStaffList.selectedIndices = moveIndices;
		}

		/**
		 * プロジェクトメンバ内移動.
		 *
		 * @param insertIndex 移動先Index.
		 */
		private function moveProjectMember_toProjectMember(insertIndex:int = -99):void
		{
			var indices:Array = view.projectMemberList.selectedIndices;
			if (!(indices && indices.length > 0))	return;
			indices.sort(Array.NUMERIC);
			var moveItems:Array = new Array();

			// index順にデータを処理する.
			var upCnt:int = 0;
			var dnCnt:int = 0;
			var members:ArrayCollection   = ObjectUtil.copy(view.projectMemberList.dataProvider) as ArrayCollection;
			for (var i:int = 0; i < indices.length; i++) {
				// プロジェクトメンバからデータを取得する.
				var member:ProjectMemberDto = members.getItemAt(indices[i]) as ProjectMemberDto;
				// 追加先を計算する.
				var index:int = insertIndex;
				if (insertIndex >= 0) {
					if (insertIndex > indices[i]) {							// 下に移動.
						index = insertIndex + i - dnCnt -1;
						dnCnt++;
					}
					else {													// 上に移動.
						index = insertIndex + i - dnCnt;
						upCnt++;
					}
				}
				// プロジェクトメンバを削除する.
				removeProjectMember(member);
				// プロジェクトメンバを追加する.
				addProjectMember(member, index);
				moveItems.push(member);
			}

			// 移動データを選択状態にする.
			view.projectMemberList.editedItemPosition = null;
			var moveIndices:Array = calculateMoveIndex(moveItems, view.projectMemberList.dataProvider as ArrayCollection);
			view.projectMemberList.selectedIndices = moveIndices;
		}

		/**
		 * プロジェクトスタッフ→メンバ移動.
		 *
		 * @param insertIndex 移動先Index.
		 */
		private function moveProjectStaff_toProjectMember(insertIndex:int = -99):void
		{
			var indices:Array = view.projectStaffList.selectedIndices;
			if (!(indices && indices.length > 0))	return;
			indices.sort(Array.NUMERIC);
			var moveItems:Array = new Array();

			// index順にデータを処理する.
			var staffs:ArrayCollection   = ObjectUtil.copy(view.projectStaffList.dataProvider) as ArrayCollection;
			for (var i:int = 0; i < indices.length; i++) {
				// スタッフリストからデータを取得する.
				var staff:ProjectMemberDto = staffs.getItemAt(indices[i]) as ProjectMemberDto;
				// プロジェクト情報を引き継ぐ.
				suceedProject_toProjectMember(staff);
				// プロジェクトメンバを追加する.
				addProjectMember(staff, insertIndex + i);
				moveItems.push(staff);
				// プロジェクトスタッフを削除する.
				removeProjectStaff(staff);
			}

			// 移動データを選択状態にする.
			view.projectMemberList.editedItemPosition = null;
			var moveIndices:Array = calculateMoveIndex(moveItems, view.projectMemberList.dataProvider as ArrayCollection);
			view.projectMemberList.selectedIndices = moveIndices;
		}

		/**
		 * プロジェクトスタッフ内移動.
		 *
		 * @param insertIndex 移動先Index.
		 */
		private function moveProjectStaff_toProjectStaff(insertIndex:int = -99):void
		{
			var indices:Array = view.projectStaffList.selectedIndices;
			if (!(indices && indices.length > 0))	return;
			indices.sort(Array.NUMERIC);
			var moveItems:Array = new Array();

			// index順にデータを処理する.
			var upCnt:int = 0;
			var dnCnt:int = 0;
			var staffs:ArrayCollection   = ObjectUtil.copy(view.projectStaffList.dataProvider) as ArrayCollection;
			for (var i:int = 0; i < indices.length; i++) {
				// スタッフリストからデータを取得する.
				var staff:ProjectMemberDto = staffs.getItemAt(indices[i]) as ProjectMemberDto;
				// 追加先を計算する.
				var index:int = insertIndex;
				if (insertIndex >= 0) {
					if (insertIndex > indices[i]) {							// 下に移動.
						index = insertIndex + i - dnCnt -1;
						dnCnt++;
					}
					else {													// 上に移動.
						index = insertIndex + i - dnCnt;
						upCnt++;
					}
				}
				// プロジェクトスタッフを削除する.
				removeProjectStaff(staff);
				// プロジェクトスタッフを追加する.
				addProjectStaff(staff, index);
				moveItems.push(staff);
			}

			// スタッフID順に並び替える.
			sortProjectStaffList();

			// 移動データを選択状態にする.
			view.projectStaffList.editedItemPosition = null;
			var moveIndices:Array = calculateMoveIndex(moveItems, view.projectStaffList.dataProvider as ArrayCollection);
			view.projectStaffList.selectedIndices = moveIndices;
		}


		/**
		 * プロジェクトメンバ追加.
		 *
		 * @param member      プロジェクトメンバ.
		 * @param insertIndex 追加先Index.
		 */
		private function addProjectMember(member:ProjectMemberDto, insertIndex:int):void
		{
			var list:ArrayCollection = view.projectMemberList.dataProvider as ArrayCollection;
			if (!list)	view.projectMemberList.dataProvider = new ArrayCollection();

			// 追加データの開始・終了日付が有効範囲かどうか確認する.
			// 有効範囲でないときは 日付をクリアする.
			var ret:Boolean = false;
			var target:DateField = new DateField;
			// 開始予定日.
			target.id           = "planedStartDate";
			target.selectedDate = member[target.id];
			if (target.selectedDate) {
				ret = checkDateField_selectableRange2("projectMemberList", target, member);
				if (!ret) {
					member[target.id] = null;
				}
			}
			// 終了予定日.
			target.id           = "planedFinishDate";
			target.selectedDate = member[target.id];
			if (target.selectedDate) {
				ret = checkDateField_selectableRange2("projectMemberList", target, member);
				if (!ret) {
					member[target.id] = null;
				}
			}

			// 開始実績日.
			target.id           = "actualStartDate";
			target.selectedDate = member[target.id];
			if (target.selectedDate) {
				ret = checkDateField_selectableRange2("projectMemberList", target, member);
				if (!ret) {
					member[target.id] = null;
				}
			}
			// 終了実績日.
			target.id           = "actualFinishDate";
			target.selectedDate = member[target.id];
			if (target.selectedDate) {
				ret = checkDateField_selectableRange2("projectMemberList", target, member);
				if (!ret) {
					member[target.id] = null;
				}
			}

			// 指定のIndexにデータを追加する.
			if (insertIndex >= 0)	list.addItemAt(member, insertIndex);
			else					list.addItem(member);
		}

		/**
		 * プロジェクトメンバ削除.
		 *
		 * @param member プロジェクトメンバ.
		 */
		private function removeProjectMember(member:ProjectMemberDto):void
		{
			// 指定されたデータを削除する.
			var list:ArrayCollection = view.projectMemberList.dataProvider as ArrayCollection;
			if (!list)	return;
			for (var i:int = 0; i < list.length; i++) {
				var rmMember:ProjectMemberDto = list.getItemAt(i) as ProjectMemberDto;
				if (ProjectMemberDto.compare(member, rmMember)) {
					list.removeItemAt(i);
					break;
				}
			}
		}


		/**
		 * プロジェクトスタッフの追加.
		 *
		 * @param member プロジェクトメンバ.
		 * @param insertIndex 追加先Index.
		 */
		private function addProjectStaff(member:ProjectMemberDto, insertIndex:int):void
		{
			var list:ArrayCollection = view.projectStaffList.dataProvider as ArrayCollection;
			if (!list)	view.projectStaffList.dataProvider = new ArrayCollection();
			// 指定のIndexにデータを追加する.
			if (insertIndex >= 0)	list.addItemAt(member, insertIndex);
			else					list.addItem(member);
		}

		/**
		 * プロジェクトスタッフの削除.
		 *
		 * @param staff プロジェクトスタッフ.
		 */
		private function removeProjectStaff(staff:ProjectMemberDto):void
		{
			// 指定されたデータを削除する.
			var list:ArrayCollection = view.projectStaffList.dataProvider as ArrayCollection;
			if (!list)	return;
			for (var i:int = 0; i < list.length; i++) {
				var rmStaff:ProjectMemberDto = list.getItemAt(i) as ProjectMemberDto;
				if (ProjectMemberDto.compare(staff, rmStaff)) {
					list.removeItemAt(i);
					break;
				}
			}
		}


		/**
		 * プロジェクトメンバ＆スタッフの移動先Indexの計算.
		 *
		 * @param moveItems 移動データ.
		 * @param targets   移動先データ.
		 * @return 移動先Index.
		 */
		 private function calculateMoveIndex(moveItems:Array, targets:ArrayCollection):Array
		 {
		 	var indices:Array = new Array();
		 	for (var i:int = 0; i < moveItems.length; i++) {
		 		var member:ProjectMemberDto = moveItems[i] as ProjectMemberDto;
		 		for (var k:int = 0; k < targets.length; k++) {
		 			var target:ProjectMemberDto = targets.getItemAt(k) as ProjectMemberDto;
		 			if (ProjectMemberDto.compare(member, target)) {
		 				indices.push(k);
		 				break;
		 			}
		 		}
		 	}
		 	return indices;
		 }


		/**
		 * プロジェクト情報からプロジェクトメンバへのデータ引き継ぎ.
		 *
		 * @param staff プロジェクトスタッフ.
		 */
		 private function suceedProject_toProjectMember(staff:ProjectMemberDto):void
		 {
		 	// 開始予定日が未設定のとき.
		 	if (view.planedStartDate.selectedDate && !staff.planedStartDate) {
		 		staff.planedStartDate = view.planedStartDate.selectedDate;
		 	}

		 	// 終了予定日が未設定のとき.
		 	if (view.planedFinishDate.selectedDate && !staff.planedFinishDate) {
		 		staff.planedFinishDate = view.planedFinishDate.selectedDate;
		 	}

		 	// 開始実績日が未設定のとき.
		 	if (view.actualStartDate.selectedDate && !staff.actualStartDate) {
		 		staff.actualStartDate = view.actualStartDate.selectedDate;
		 	}

		 	// 終了実績日が未設定のとき.
		 	if (view.actualFinishDate.selectedDate && !staff.actualFinishDate) {
		 		staff.actualFinishDate = view.actualFinishDate.selectedDate;
		 	}
		 }


		/**
		 * DateField(ItemEditor) 選択可能な日付の範囲取得.
		 *
		 * @param target 設定するDateField.
		 * @param member プロジェクトメンバ.
		 * @return 有効範囲.
		 */
		public function getItemEditor_selectableRange2(target:String, member:Object):Object
		{
			if (!(target && member))		return null;

			// 有効範囲を取得する.
			var range:Object = getDateField_selectableRange2("projectMemberList", target, member);
			return range;
		}

		/**
		 * 顧客リストコンボボックス表示名の作成.
		 *
		 */
		 public function setCustomerLabel(item:Object):String
		 {
			return item.customerType + item.customerNo + " " + item.customerName;
		 }

		/**
		 * DateField 選択可能な日付の範囲取得.
		 *
		 * @param control 対象オブジェクトの親ID.
		 * @param target  対象オブジェクトのID.
		 * @param ctlData 対象データ.
		 * @return 有効範囲.
		 */
		private function getDateField_selectableRange2(control:String, target:String, ctlData:Object = null):Object
		{
			if (!(control && target))	return null;

			// プロジェクトメンバを取得する.
			var members:ArrayCollection = view.projectMemberList.dataProvider as ArrayCollection;
			for (var i:int = 0; i < RELATED_DATEFIELD_ITEMS2.length; i++) {
				// 関連データ定義を取得する.
				var item:Object = RELATED_DATEFIELD_ITEMS2[i];
				if (ObjectUtil.compare(target,  item.target)  == 0 &&
					ObjectUtil.compare(control, item.control) == 0 ) {
					// 有効範囲を作成する.
					var range:Object = null;

					// 設定する日付を取得する.
					var startDate:Date;
					var endDate:Date;

					// 関連データを取得する.
					for (var k:int = 0; k < item.relateItems.length; k++) {
						// 関連データを1レコード取得する.
						var relItem:Object = item.relateItems[k];

						// プロジェクトメンバ.
						if (ObjectUtil.compare(relItem.control, "projectMemberList") == 0) {
							if (!members) 	continue;

							// プロジェクトメンバを取得する.
							for (var n:int = 0; n < members.length; n++) {
								// メンバを1レコード取得する.
								var member:Object = members.getItemAt(n);
								var tmpDate:Date  = member[relItem.target];

								// 対象データが設定されているときはそのデータで有効な範囲を取得する.
								if (ctlData) {
									if (!ProjectMemberDto.compare(member as ProjectMemberDto, ctlData as ProjectMemberDto))
										continue;
								}

								// 終了範囲.
								if (relItem.rangeEnd) {
									var ret1:Boolean = checkSelectableRange_rangeEnd(endDate, tmpDate);
									if (ret1) {
										endDate = tmpDate
									}
								}

								// 開始範囲.
								if (relItem.rangeStart) {
									var ret2:Boolean = checkSelectableRange_rangeStart(startDate, tmpDate);
									if (ret2) {
										startDate = tmpDate
									}
								}
							}
						}
						// プロジェクト情報.
						else if (ObjectUtil.compare(relItem.control, "projectEntry") == 0) {
							var tmpDateField:DateField = view[relItem.target];
							// 終了範囲.
							if (relItem.rangeEnd) {
								var ret3:Boolean = checkSelectableRange_rangeEnd(endDate, tmpDateField.selectedDate);
								if (ret3) {
									endDate = tmpDateField.selectedDate;
								}
							}

							// 開始範囲.
							if (relItem.rangeStart) {
								var ret4:Boolean = checkSelectableRange_rangeStart(startDate, tmpDateField.selectedDate);
								if (ret4) {
									startDate = tmpDateField.selectedDate;
								}
							}
						}
					}

					// 有効範囲を設定する.
					if (startDate || endDate) {
						range = new Object();
						if (startDate)	range.rangeStart = startDate;
						if (endDate)	range.rangeEnd   = endDate;
					}

					// 有効範囲を返す.
					return range;
				}
			}
			return null;
		}

		/**
		 * 選択開始日時の更新チェック.
		 *
		 * @param date 現在の選択開始日時.
		 * @param tmp  比較する日時.
		 * @return チェック結果.
		 */
		private function checkSelectableRange_rangeStart(date:Date, tmp:Date):Boolean
		{
			if (!date && !tmp)		return false;
			if (date  && !tmp)		return false;
			if (!date  && tmp)		return true;

			// last日付を取得する.
			if (ObjectUtil.dateCompare(tmp, date) > 0) {
				return true;
			}
			return false;
		}

		/**
		 * 選択終了日時の更新チェック.
		 *
		 * @param date 現在の選択終了日時.
		 * @param tmp  比較する日時.
		 * @return チェック結果.
		 */
		private function checkSelectableRange_rangeEnd(date:Date, tmp:Date):Boolean
		{
			if (!date && !tmp)		return false;
			if (date  && !tmp)		return false;
			if (!date  && tmp)		return true;

			// past日付を取得する.
			if (ObjectUtil.dateCompare(date, tmp) > 0) {
				return true;
			}
			return false;
		}

		/**
		 * DateField 有効範囲チェック.
		 *
		 * @param control 対象オブジェクトの親ID.
		 * @param target  対象オブジェクトのDateField.
		 * @param ctlData 対象データ.
		 * @return チェック結果.
		 */
		private function checkDateField_selectableRange2(control:String, target:DateField, ctlData:Object = null):Boolean
		{
			if (!(target && control))		return true;

			// 有効範囲を取得する.
			var range:Object = getDateField_selectableRange2(control, target.id, ctlData);
			if (!range)			return true;

			// 有効データかどうか確認する.
			var targetDate:Date = target.selectedDate;
			// 開始＆終了範囲.
			if (range.rangeStart && range.rangeEnd) {
				if (ObjectUtil.compare(targetDate, range.rangeStart) >= 0 &&
					ObjectUtil.compare(range.rangeEnd, targetDate)   >= 0 )
					return true;
			}
			// 開始範囲.
			else if (range.rangeStart) {
				if (ObjectUtil.compare(targetDate, range.rangeStart) >= 0)
					return true;
			}
			// 終了範囲.
			else if (range.rangeEnd) {
				if (ObjectUtil.compare(range.rangeEnd, targetDate) >= 0)
					return true;
			}
			return false;
		}

		/**
		 * プロジェクトスタッフリストのソート.
		 *
		 */
		 private function sortProjectStaffList():void
		 {
			var ac:ArrayCollection = view.projectStaffList.dataProvider as ArrayCollection;
			var array:Array = ac.toArray();
			array.sortOn("staffId", Array.NUMERIC);

			var list:ArrayCollection = new ArrayCollection();
			for (var i:int =0; i < array.length; i++) {
				var item:Object = array[i];
				list.addItem(item);
			}
			view.projectStaffList.dataProvider = list;
		 }


// 2009.03.24 start 日付範囲のチェック方法変更によりコメントアウト.
//		/**
//		 * DateField(ItemEditor) 選択可能な日付の範囲取得.
//		 *
//		 * @param target 設定するDateField.
//		 * @param member プロジェクトメンバ.
//		 * @return 有効範囲.
//		 */
//		public function getItemEditor_selectableRange(target:String, member:Object):Object
//		{
//			if (!(target && member))		return null;
//
//			// 有効範囲を取得する.
//			var range:Object = getDateField_selectableRange(target, member);
//			return range;
//		}
//
//		/**
//		 * DateField 選択可能な日付の範囲取得.
//		 * ※dataとpropの設定値.
//		 *   data:ProjectEntry      prop:selectedDate
//		 *   data:ProjectMemberDto  prop:---
//		 *
//		 * @param target 取得するデータのフィールド名.
//		 * @param data   Object.
//		 * @param prop   ObjectからDateを取得するためのプロパティ.
//		 * @return 有効範囲.
//		 */
//		private function getDateField_selectableRange(target:String, data:Object, prop:String = null):Object
//		{
//			if (!(target && data))
//				return null;
//
//			// 関連データを取得し、範囲設定する.
//			for (var i:int = 0; i < RELATED_DATEFIELD_ITEMS.length; i++) {
//				var checkItem:Object = RELATED_DATEFIELD_ITEMS[i];
//				if (ObjectUtil.compare(target, checkItem.target) == 0) {
//					// 比較対象のデータを取得する.
//					var relateDate:Date;
//					if (prop) {
//						relateDate = data[checkItem.relate][prop];
//					}
//					else {
//						relateDate = data[checkItem.relate];
//					}
//
//					// 有効範囲を計算する.
//					var range:Object = null;
//					if (relateDate) {
//						if (checkItem.rangeStart) {
//							var start:Date = new Date();
//							start.setTime(relateDate.getTime());
//							range  = {rangeStart:start};
//						}
//						else if (checkItem.rangeEnd) {
//							var end:Date   = new Date();
//							end.setTime(relateDate.getTime());
//							range  = {rangeEnd:end};
//						}
//					}
//					// 有効範囲を返す.
//					return range;
//				}
//			}
//			return null;
//		}
//
//		/**
//		 * DateField 有効範囲チェック.
//		 * ※dataとpropの設定値.
//		 *   data:ProjectEntry      prop:selectedDate
//		 *   data:ProjectMemberDto  prop:---
//		 *
//		 * @param target チェックするDateField.
//		 * @param data   Object.
//		 * @param prop   ObjectからDateを取得するためのプロパティ.
//		 * @return チェック結果.
//		 */
//		private function checkDateField_selectableRange(target:DateField, data:Object, prop:String = null):Boolean
//		{
//			if (!(target && data))		return true;
//
//			// 有効範囲を取得する.
//			var range:Object = getDateField_selectableRange(target.id, data, prop);
//			if (!range)			return true;
//
//			// 有効データかどうか確認する.
//			var targetDate:Date = target.selectedDate;
//			if (range.rangeStart) {
//				if (ObjectUtil.compare(targetDate, range.rangeStart) >= 0)
//					return true;
//			}
//			else if (range.rangeEnd) {
//				if (ObjectUtil.compare(range.rangeEnd, targetDate) >= 0)
//					return true;
//			}
//			return false;
//		}
// 2009.03.24 end   日付範囲のチェック方法変更によりコメントアウト.



//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectEntry;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():ProjectEntry
	    {
	        if (_view == null) {
	            _view = super.document as ProjectEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:ProjectEntry):void
	    {
	        _view = view;
	    }
	}
}