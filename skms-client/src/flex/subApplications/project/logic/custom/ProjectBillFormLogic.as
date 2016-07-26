package subApplications.project.logic.custom
{
	import com.googlecode.kanaxs.Kana;

	import flash.events.Event;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.Validator;

	import subApplications.project.dto.ProjectBillDto;
	import subApplications.project.dto.ProjectBillItemDto;
	import subApplications.project.web.custom.ProjectBillForm;

	import utils.LabelUtil;


	/**
	 * ProjectBillFprmのLogicクラスです.
	 */
	public class ProjectBillFormLogic extends Logic
	{
		/** 変更対象の請求書情報 */
		private var _bill:ProjectBillDto;

		/** 請求書Index */
		private var _billIndex:int;

		/** 銀行口座リスト */
		private var _bankList:ArrayCollection;

//		/** 数値フォーマット */
//		private var _numberFormatter:NumberFormatter;
//
		/** 消費税 5％*/
		private var TAX_CONSUMPTION:Number = 5;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function ProjectBillFormLogic()
		{
			super();

//			_numberFormatter=new NumberFormatter();
//			_numberFormatter.useThousandsSeparator = false;
//			_numberFormatter.useNegativeSign       = true;
		}

//--------------------------------------
//  Initialization
//--------------------------------------
		/**
		 * onCreationCompleteHandler
		 */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();

	    }

		/**
		 * 表示データの設定.
		 *
		 */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
			// 新規のとき.
			if (!_bill) _bill = new ProjectBillDto();

			// 表示データを設定する.
			view.billDate.selectedDate       = _bill.billDate;
			view.dgBillItemList.dataProvider = createBillItemList(_bill.projectBillItems);
			view.dgBillOtherList.dataProvider= createBillOtherList(_bill.projectBillOthers);
			view.billItems.text              = calculateBillItems();
			view.billItemsTax.text           = calculateBillItemsTax();
			view.billItemsTotal.text         = calculateBillItemsTotal();
			view.billOthersTotal.text        = calculateBillOthersTotal();
			view.billTotal.text              = calculateBillTotal();
			view.cmbBankAccount.dataProvider = _bankList;
			for (var index:int = 0; index < _bankList.length; index++) {
				if (ObjectUtil.compare(_bill.accountId, _bankList.getItemAt(index).accountId) == 0) {
					view.cmbBankAccount.selectedIndex = index;
					onCmbChange_bankAccount(new Event("creationComplete"));
					break;
				}
			}

			// validateチェックをする.
			validateValidateItems();
			validateBillItemList();

			// ラベルを設定する.
			setLabel();
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------
//		/**
//		 * DateFieldフォーカスアウト.
//		 *
//		 * @param e FocusEvent
//		 */
//		public function onFocusOut_dateField2(e:FocusEvent):void
//		{
//			// 入力データのチェックを行なう.
//			// →parseFunction はキー入力毎に呼ばれるため focusOut したときに入力チェックする.
//			var target:DateField = e.currentTarget as DateField;
//			var ret:Boolean = view.projectLogic.checkDateField_text(target);
//			if (!ret) {
//				target.text = "";
//			}
//
//			// ラベルを設定する.
//			setLabel();
//		}
		/**
		 * 請求日変更.
		 *
		 * @param e CalendarLayoutChangeEvent.
		 */
		public function onChange_billDate(e:CalendarLayoutChangeEvent):void
		{
			// ラベルを設定する.
			setLabel();
		}



		/**
		 * 請求項目リストのフォーカスイン.
		 *
		 * @param e DataGridEvent.
		 */
		public function onItemFocusIn_billItemList(e:DataGridEvent):void
		{
			// 入力条件を設定する.
			itemFocusIn_billList(e);
		}

		/**
		 * その他請求項目リストのフォーカスイン.
		 *
		 * @param e DataGridEvent.
		 */
		public function onItemFocusIn_billOtherList(e:DataGridEvent):void
		{
			// 入力条件を設定する.
			itemFocusIn_billList(e);
		}

		/**
		 * 請求/その他項目リストのフォーカスイン.
		 *
		 * @param e DataGridEvent.
		 */
		private function itemFocusIn_billList(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			if (dg.itemEditorInstance && dg.itemEditorInstance is TextInput) {
				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
				var editor:TextInput = dg.itemEditorInstance as TextInput;

				switch (col.dataField) {
					// 発注No.
					case "orderNo":
						editor.maxChars = 64;
						break;

					// 件名.
					case "title":
						editor.maxChars = 256;
						break;

					// 請求額.
					case "billAmount":
						//editor.restrict = "0-9\\-\u002c";
						if (editor.text.length > 0) {
							editor.text = LabelUtil.currencyFormatOff(editor.text);
						}
						editor.errorString = "数値を入力してください";
						editor.setStyle("errorColor", editor.getStyle("themeColor"));
						break;
				}
			}
		}

		/**
		 * 請求項目リストのフォーカスアウト.
		 *
		 * @param e DataGridEvent.
		 */
		public function onItemFocusOut_billItemList(e:DataGridEvent):void
		{
			// 最終行を編集したとき..
			var list:ArrayCollection = view.dgBillItemList.dataProvider as ArrayCollection;
			if (list.length == view.dgBillItemList.selectedIndex+1) {
				var billitem:ProjectBillItemDto = list.getItemAt(view.dgBillItemList.selectedIndex) as ProjectBillItemDto;
				if (billitem.checkEntry()) {
					// 新規データを追加する.
					list.addItem(new ProjectBillItemDto());
				}
			}
			// 請求金額を再計算する.
			calculateBillTotal2();

			// validateチェックをする.
			validateBillItemList();
		}

		/**
		 * その他請求項目リストのフォーカスアウト.
		 *
		 * @param e DataGridEvent.
		 */
		public function onItemFocusOut_billOtherList(e:DataGridEvent):void
		{
			// 最終行を編集したとき..
			var list:ArrayCollection = view.dgBillOtherList.dataProvider as ArrayCollection;
			if (list.length == view.dgBillItemList.selectedIndex+1) {
				var billitem:ProjectBillItemDto = list.getItemAt(view.dgBillItemList.selectedIndex) as ProjectBillItemDto;
				if (billitem.checkEntry()) {
					// 新規データを追加する.
					list.addItem(new ProjectBillItemDto());
				}
			}
			// 請求金額を再計算する.
			calculateBillTotal2();
		}


		/**
		 * 請求項目リストの編集終了.
		 *
		 * @param e DataGridEvent.
		 */
		public function onItemEditEnd_billItemList(e:DataGridEvent):void
		{
			// 編集データのチェックを行なう.
			var ret:Boolean = itemEditEnd_billList(e);
			if (!ret)	e.preventDefault();
		}

		/**
		 * その他請求項目リストの編集終了.
		 *
		 * @param e DataGridEvent.
		 */
		public function onItemEditEnd_billOtherList(e:DataGridEvent):void
		{
			// 編集データのチェックを行なう.
			var ret:Boolean = itemEditEnd_billList(e);
			if (!ret)	e.preventDefault();
		}

		/**
		 * 請求/その他項目リストの編集終了.
		 *
		 * @param e DataGridEvent.
		 */
		private function itemEditEnd_billList(e:DataGridEvent):Boolean
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			if (dg.itemEditorInstance && dg.itemEditorInstance is TextInput) {
				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
				var editor:TextInput = dg.itemEditorInstance as TextInput;
				var newData:String = editor.text;
				if (newData == "") 	return true;

				switch (col.dataField) {
					// 請求額.
					case "billAmount":
						// 半角に変換する
						newData = Kana.toHankakuCase(newData);
						var expense:Number = Number(newData);
//						if (isNaN(expense) || int(expense) != expense || StringUtil.trim(newData).length == 0) {
//							TextInput(dg.itemEditorInstance).errorString = "数値を入力してください";
//							return false;
//						}
//						// 変換した値を設定する.
//						editor.text = String(expense);
						if (isNaN(expense) || int(expense) != expense || StringUtil.trim(newData).length == 0)
							editor.text = null;
						else
							editor.text = String(expense);
						break;
				}
			}
			return true;
		}


		/**
		 * 振込口座の選択.
		 *
		 * @param e Event.
		 */
		public function onCmbChange_bankAccount(e:Event):void
		{
		 	if (view.cmbBankAccount.selectedIndex > 0) {
		 		var item:Object = view.cmbBankAccount.selectedItem;
				view.bankName.text   = item.bankName + ":" + item.bankCode;
				view.branchName.text = item.branchName + ":" + item.branchCode;
				view.accountNo.text  = item.accountType + ":" + item.accountNo;
				view.accountName.text= item.accountName;
		 	}
		 	else {
				view.bankName.text   = "―――";
				view.branchName.text = "";
				view.accountNo.text  = "";
				view.accountName.text= "―――";
		 	}
		}


		/**
		 * 振込口座の表示.
		 *
		 * @param item comboBoxのitem.
		 * @return フォーマット済みのデータ項目.
		 */
		public function bankAccountLabel(item:Object):String
		{
			if (item.dummy)		return "";
			//else 				return item.bankName + " " + item.branchName + " " + "(口座番号:" + item.accountNo +")";
			else 				return item.bankName + " " + item.branchName;
		}


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 登録する請求書情報の作成.
		 *
		 * @return 請求書情報.
		 */
		public function createBill():ProjectBillDto
		{
			var bill:ProjectBillDto = _bill;
			bill.billDate = view.billDate.selectedDate;
			bill.projectBillItems = ProjectBillItemDto.entry(view.dgBillItemList.dataProvider  as ArrayCollection);
			bill.projectBillOthers= ProjectBillItemDto.entry(view.dgBillOtherList.dataProvider as ArrayCollection);
			bill.accountId = view.cmbBankAccount.selectedItem.accountId;
			return bill;
		}

		/**
		 * 複製する請求書情報の作成.
		 *
		 * @return 請求書情報.
		 */
		public function createBillCopy():ProjectBillDto
		{
			var bill:ProjectBillDto = new ProjectBillDto();
			bill.billDate = null;
			bill.projectBillItems = ProjectBillItemDto.copy(view.dgBillItemList.dataProvider  as ArrayCollection);
			bill.projectBillOthers= ProjectBillItemDto.copy(view.dgBillOtherList.dataProvider as ArrayCollection);
			bill.accountId = view.cmbBankAccount.selectedItem.accountId;
			return bill;
		}

		/**
		 * 削除する請求書情報の作成.
		 *
		 * @return 請求書情報.
		 */
		public function createBillDelete():ProjectBillDto
		{
			var bill:ProjectBillDto = createBill();
			bill.setDelete();
			return bill;
		}

		/**
		 * 請求書情報の表示.
		 * ※表示前のため、view へアクセスしても component が 作成されていない.
		 *
		 * @param index 請求Index.
		 * @param bill 請求情報.
		 * @param banklist 銀行口座リスト.
		 */
		public function displayBill(index:int, bill:ProjectBillDto, banklist:ArrayCollection):void
		{
			_billIndex = index;
			_bill      = bill;
			_bankList  = createBankAccountList(banklist);
		}


		/**
		 * ラベルの設定.
		 */
		private function setLabel():void
		{
			var label:String = "";
			var date:Date    = view.billDate.selectedDate;
			if (date) {
				label += String(date.getFullYear())  + "年";
				label += String(date.getMonth() + 1) + "月";
			}
			label += "請求書";

			view.label = label;
		}

		/**
		 * 請求項目リストの作成.
		 *
		 * @param list 請求項目リスト.
		 * @return リスト.
		 */
		private function createBillItemList(list:ArrayCollection):ArrayCollection
		{
			if (!list)	list = new ArrayCollection();
//			var initno:int = list.length;
//			for (var itemno:int = initno; itemno < view.dgBillItemList.rowCount-1; itemno++) {
//				var item:ProjectBillItemDto = ProjectBillItemDto.createBillItem(itemno + 1);
//				list.addItem(item);
//			}
			var listnum:int = list.length;
			for (var i:int = 0; (i + listnum) < view.dgBillItemList.rowCount-1; i++) {
				var item:ProjectBillItemDto = new ProjectBillItemDto();
				list.addItem(item);
			}
			return list;
		}

		/**
		 * その他請求項目リストの作成.
		 *
		 * @param list その他請求項目リスト.
		 * @return リスト.
		 */
		private function createBillOtherList(list:ArrayCollection):ArrayCollection
		{
			if (!list)	list = new ArrayCollection();
			var listnum:int = list.length;
			// dgBillOtherList が非表示のときは rowCount = -1 のため dgBillItemList から取得する.
			var rowCount:int = view.dgBillOtherList.rowCount > 0 ? view.dgBillOtherList.rowCount : view.dgBillItemList.rowCount;
			for (var i:int = 0; (i + listnum) < rowCount - 1; i++) {
				var item:ProjectBillItemDto = new ProjectBillItemDto();
				list.addItem(item);
			}
			return list;
		}

		/**
		 * 振込口座リストの作成.
		 *
		 * @param list 振込口座リスト.
		 * @return リスト.
		 */
		private function createBankAccountList(list:ArrayCollection):ArrayCollection
		{
			if (!list)	list = new ArrayCollection();
			var dummy:Object = {dummy:true};
			list.addItemAt(dummy, 0);
			return list;
		}


		/**
		 * 請負分小計の計算.
		 *
		 * @return 小計金額.
		 */
		private function calculateBillItems():String
		{
			var list:ArrayCollection = view.dgBillItemList.dataProvider as ArrayCollection;
			if (!list)		return "0";

			// 請求項目を取得する.
			var amount:Number = 0;
			for (var i:int = 0; i < list.length; i++) {
				var bill:String = list.getItemAt(i).billAmount;
				amount += Number(bill);
			}
			return LabelUtil.currency(amount.toString());
		}

		/**
		 * 請負分消費税の計算.
		 *
		 * @return 消費税金額.
		 */
		 private function calculateBillItemsTax():String
		 {
		 	// 請負分小計を取得する.
		 	var amount:String = view.billItems.text;
		 	if (!amount)	return "0";
		 	var tax:Number = Number(LabelUtil.currencyFormatOff(amount)) * TAX_CONSUMPTION / 100;
		 	var abs:Number = tax >= 0 ? Math.floor(Math.abs(tax)) : 0 - Math.floor(Math.abs(tax));
		 	return LabelUtil.currency(abs.toString());
		 }

		/**
		 * 請負分合計の計算.
		 *
		 * @return 合計金額.
		 */
		 private function calculateBillItemsTotal():String
		 {
		 	// 請負分小計を取得する.
		 	var amount:String = view.billItems.text;
		 	if (!amount)	return "0";

		 	// 請負分消費税を取得する.
		 	var tax:String = view.billItemsTax.text;
		 	if (!tax)		return "0";

			// 請負分合計をを計算する.
		 	var total:Number = Number(LabelUtil.currencyFormatOff(amount)) + Number(LabelUtil.currencyFormatOff(tax));
		 	return LabelUtil.currency(total.toString());
		 }

		/**
		 * 請負分その他の計算.
		 *
		 * @return その他費用.
		 */
		 private function calculateBillOthersTotal():String
		 {
			var list:ArrayCollection = view.dgBillOtherList.dataProvider as ArrayCollection;
			if (!list)		return "0";

			// 請求項目を取得する.
			var amount:Number = 0;
			for (var i:int = 0; i < list.length; i++) {
				var bill:String = list.getItemAt(i).billAmount;
				amount += Number(LabelUtil.currencyFormatOff(bill));
			}
			return LabelUtil.currency(amount.toString());
		 }

		/**
		 * 請求金額合計の計算.
		 *
		 * @return 合計金額.
		 */
		 private function calculateBillTotal():String
		 {
		 	// 請負分合計金額を取得する.
		 	var billitem:String  = view.billItemsTotal.text;
		 	if (!billitem)		return "0";

		 	// その他請求金額を取得する.
		 	var billother:String = view.billOthersTotal.text;
		 	if (!billother)		return "0";

			// 合計金額を計算する.
		 	var total:Number = Number(LabelUtil.currencyFormatOff(billitem)) + Number(LabelUtil.currencyFormatOff(billother));
		 	return LabelUtil.currency(total.toString());
		 }


		/**
		 * 請負分合計の再計算.
		 *
		 */
		 private function calculateBillTotal2():void
		 {
			view.billItems.text              = calculateBillItems();
			view.billItemsTax.text           = calculateBillItemsTax();
			view.billItemsTotal.text         = calculateBillItemsTotal();
			view.billOthersTotal.text        = calculateBillOthersTotal();
			view.billTotal.text              = calculateBillTotal();
		 }


		/**
		 * validate チェック.
		 *
		 * @return チェック結果.
		 */
		public function validateAll():Boolean
		{
			var ret:Boolean = validateValidateItems();
			if (!ret)	return false;

			ret = validateBillItemList();
			if (!ret)	return false;

			return true;
		}

		/**
		 * validatorチェック（validateItems）.
		 *
		 * @return チェック結果.
		 */
		public function validateValidateItems():Boolean
		{
			// DataField、ComboBox の validate チェックをする.
			var results:Array = Validator.validateAll(view.validateItems);

			// validate 結果を設定する.
			if (results && results.length > 0) 		return false;
			else 									return true;
		}

		/**
		 * validatorチェック（DataGrid 請求項目）.
		 *
		 * @return チェック結果.
		 */
		public function validateBillItemList():Boolean
		{
			// DataGridの validate チェックをする.
			var msg:String = "請求項目は必須です。";
			var list:ArrayCollection = view.dgBillItemList.dataProvider as ArrayCollection;
			for each (var billitem:ProjectBillItemDto in list) {
				if (billitem.checkEntry()) {
					msg = "";
					break;
				}
			}
			view.dgBillItemList.errorString = msg;

			// validate 結果を設定する.
			if (msg && msg.length > 0)			return false;
			else 								return true;
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ProjectBillForm;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():ProjectBillForm
	    {
	        if (_view == null) {
	            _view = super.document as ProjectBillForm;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:ProjectBillForm):void
	    {
	        _view = view;
	    }
	}
}