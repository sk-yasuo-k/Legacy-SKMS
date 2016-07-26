package subApplications.accounting.logic.custom
{

	import com.googlecode.kanaxs.Kana;
	
	import components.EditComboBox;
	
	import flash.events.Event;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.DateField;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.Validator;
	
	import subApplications.accounting.dto.CommutationDetailDto;
	import subApplications.accounting.dto.CommutationItemDto;
	import subApplications.accounting.web.custom.CommutationForm;
	import subApplications.generalAffair.dto.StaffAddressMoveDateDto;
	
	import utils.LabelUtil;
	


	/**
	 * CommutationFormのLogicクラスです.
	 */
	public class CommutationFormLogic extends Logic
	{

		/** 通勤費詳細情報 */
		private var _commuDetail:CommutationDetailDto;
		
		/** 通勤費項目情報 */
		private var _commuItem:CommutationItemDto;

		/** 一覧表の表示行数 */
		private static const ROW_COUNT_EDIT:int = 10;

		/** 交通機関マスタリスト */
		private var _facilityNameList:ArrayCollection;
		
		/** 住所リスト */
		private var _staffAddressList:ArrayCollection;

		/** 数値フォーマット */
		private var _numberFormatter:NumberFormatter;
		
		/** デフォルト行の背景色リスト */
		private var _defaultColors:Array;
		
		/** 入力エラー行の背景色 */
		private const _COMMUTATION_ERROR:Number = 0xffe6e6;
		
		/** エラー件数 */
		private var _errorCount:Array = new Array(10);

		/** 編集前値 */
		private var _oldValue:String;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CommutationFormLogic()
		{
			super();

			_numberFormatter=new NumberFormatter();
			_numberFormatter.useThousandsSeparator = false;
			_numberFormatter.useNegativeSign       = true;
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
	     * 引き継ぎデータの取得.
	     *
	     */
		protected function onCreationCompleteHandler_setSuceedData():void
		{
			// 新規のとき.
			if (!_commuDetail) {
				_commuDetail = new CommutationDetailDto();
			}
		}


		/**
		 * 表示データの設定.
		 *
		 */
		protected function onCreationCompleteHandler_setDisplayData():void
		{
 			// 一覧の初期データを設定する.
			view.grdCommutationItem.rowCount = ROW_COUNT_EDIT;

			// 勤務開始日を設定する.
			view.commuStartDate.selectedDate = _commuDetail.commutationStartDate;

			// 表示データを設定する.
			var itemExTotal:int = 0;
			if (_commuDetail.commutationItems) {
				for (var i:int = 0; i < _commuDetail.commutationItems.length; i++) {
					var ci:CommutationItemDto = _commuDetail.commutationItems.getItemAt(i) as CommutationItemDto;
					itemExTotal += parseInt(ci.expense);
				}
			}
			view.commuItemsTotal.text = LabelUtil.currency(itemExTotal.toString());

			// 一覧を作成する.
			view.grdCommutationItem.dataProvider = makeTable_commutationItem(_commuDetail.commutationItems);
			// 背景色の設定	        	
			setColorPattern( view.grdCommutationItem.dataProvider as ArrayCollection);

			// ラベルを設定する.
			setLabel();
			
			// 住所を設定する.
			setAddress();

			// イベントを通知する.
			view.dispatchEvent(new Event("loadComplete"));
	}


//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 通勤費詳細情報の表示.
		 * ※表示前のため、view へアクセスしても component が 作成されていない.
		 *
		 * @param commu  通勤費詳細情報.
		 */
		public function displayCommuDetail(cd:CommutationDetailDto,
											 al:ArrayCollection,
											 fl:ArrayCollection):void
		{
			_commuDetail = cd;
			_staffAddressList = al;
			_facilityNameList = fl;
		}
		
		/**
		 * 入力コントロール状態設定.
		 * @param commu  通勤費詳細情報.
		 */
		public function setInputCtrStatus(isEdit:Boolean):void
		{
			// コントロールの編集状態を設定する.
			view.grdCommutationItem.editable = isEdit;
			view.grdCommutationItem.dragEnabled = isEdit;
			view.grdCommutationItem.dropEnabled = isEdit;
			view.commuStartDate.editable = isEdit;
			if(!isEdit){
				// 通勤開始日付有効範囲を作成する.
				var startDate:Date = view.commuStartDate.selectedDate;
				view.commuStartDate.selectableRange = getDateField_selectableRange(startDate,isEdit);
			}
		}
		
		/**
		 * DateField 選択可能な日付の範囲取得.
		 *
		 * @param startDate 開始日.
		 * @param isEdit    編集可能であるか.
		 * @return 有効範囲.
		 */
		public function getDateField_selectableRange(startDate:Date,isEdit:Boolean):Object
		{
			// 有効範囲を作成する.
			var range:Object = null;
			// 開始日
			var staetStr:String;
			var year:Number;
			var month:Number;
			var day:Number;
			var dateFormatter:DateFormatter;
			
			// nullの場合は勤務月の最初の日付.
			if(!startDate){
				startDate = view.commuStartDate.selectedDate;
			}
			else{
				//日付をYYMMDD形式に
				dateFormatter = new DateFormatter();
				dateFormatter.formatString = "YYYYMMDD";
				staetStr = dateFormatter.format(startDate);
				
				//日付を年、月、日に分解 
				year = Number(staetStr.substr(0,4)); 
				month = Number(staetStr.substr(4,2)); 
				day = Number(staetStr.substr(6,2));
			}
			if (isEdit){
				//範囲の設定
				range = new Object();
				range.rangeStart = new Date(year, month-1, 1);
				range.rangeEnd   = new Date(year, month, 0);
			}
			else{
				//範囲の設定
				range = new Object();
				range.rangeStart = new Date(year, month-1, day);
				range.rangeEnd   = new Date(year, month-1, day);
			}
			return range;
		}

		/**
		 * 通勤開始日変更.
		 *
		 * @param e CalendarLayoutChangeEvent.
		 */
		public function onChange_startDate(e:CalendarLayoutChangeEvent):void
		{
			var target:DateField = e.currentTarget as DateField;
			
			if(!target.editable)return;
			
			// ラベルを設定する.
			setLabel();
			
			// 住所を設定する.
			setAddress();
			
			// データ変更あり.
			setModifiedStatus(true);
			
			// イベントを通知する.
			view.dispatchEvent(new Event("changeInputData"));
		}
		
		/**
		 * ラベルの設定.
		 */
		private function setLabel():void
		{
			var label:String = "通勤期間 ";
			var date:Date    = view.commuStartDate.selectedDate;

			if (date) {
				label += String(date.getMonth() + 1)  + "月";
				label += String(date.getDate()) + "日";
			}
			view.label = label;
		}
		
		/**
		 * 住所の設定.
		 */
		private function setAddress():void
		{
			var label:String = "";
			var startDate:Date;
			startDate = view.commuStartDate.selectedDate;
			
			// 勤務開始日より該当する住所を取得します.
			for each (var items:StaffAddressMoveDateDto in _staffAddressList) 
			{
				if (!items.houseNumber) items.houseNumber = "";
				var address:String = items.prefectureName + items.ward+ items.houseNumber;
				if (label == "") label = address;
				if(items.moveDate <= startDate) label = address;
			}
			view.address.text = label;
		}

		/**
		 * 交通機関リストの作成.
		 *
		 * @param list 交通機関リスト.
		 * @return リスト.
		 */
		private function createTransportList(list:ArrayCollection):ArrayCollection
		{
			if (!list)	list = new ArrayCollection();
			var dummy:Object = {dummy:true};
			list.addItemAt(dummy, 0);
			return list;
		}

		
//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * 登録する通勤費詳細情報の作成.
		 *
		 * @return 通勤費詳細情報.
		 */
		public function createCommuDetail():CommutationDetailDto
		{
			var commuDetail:CommutationDetailDto = _commuDetail;
			commuDetail.commutationStartDate = view.commuStartDate.selectedDate;
			commuDetail.commutationItems = CommutationItemDto.entry(view.grdCommutationItem.dataProvider as ArrayCollection);
			return commuDetail;
		}



		/**
		 * 通勤費項目一覧行数の調整.
		 *
		 * @param  ac 通勤費項目リスト.
		 * @return 調整済みの通勤費項目リスト.
		 */
		private function makeTable_commutationItem(ac:ArrayCollection):ArrayCollection
		{
			// 一覧表示行分のデータを作成する.
			var copy:ArrayCollection = ac ? ObjectUtil.copy(ac) as ArrayCollection : new ArrayCollection();
			var acLength:int         = ac ? ac.length : 0;
			
			for (var i:int = 0; i < (ROW_COUNT_EDIT - acLength) ; i++) {
				var dto:CommutationItemDto = new CommutationItemDto();
				copy.addItem(dto);
			}

			// index >= ROW_COUNT_EDIT の空データを削除する.
			var cpLength:int = copy.length;
			for (var lastIndex:int = cpLength - 1; lastIndex >= ROW_COUNT_EDIT; lastIndex--) {
				var commu:CommutationItemDto = copy.getItemAt(lastIndex) as CommutationItemDto;
				if (commu && commu.checkEntry()) 		break;
				copy.removeItemAt(lastIndex);
			}
			return copy;
		}


		/**
		 * データフォーカス IN.
		 *
		 * @param e DataGridEvent
		 */
		public function onItemFocosIn(e:DataGridEvent):void
		{
			
			var dg:DataGrid = e.currentTarget as DataGrid;
			var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
			var cell:Object = dg.selectedItem.hasOwnProperty(col.dataField) ? dg.selectedItem[col.dataField] : "";
			
			// コンボボックスの場合
			if (dg.itemEditorInstance && dg.itemEditorInstance is EditComboBox) {
				var editor:EditComboBox = dg.itemEditorInstance as EditComboBox;

				switch (col.dataField) {
					// 交通機関
					case "facilityName":
						editor.dataProvider = _facilityNameList;
						editor.maxChars     = 16;
						if (cell) {
							for (var index:int = 0; index < _facilityNameList.length; index++) {
								if (ObjectUtil.compare(_facilityNameList.getItemAt(index).label, cell.toString()) == 0) {
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
				// 変更前の値を記憶します
				 _oldValue = StringUtil.trim(editor.text);
			}
			else if (dg.itemEditorInstance && dg.itemEditorInstance is TextInput) {
				var editorTx:TextInput = dg.itemEditorInstance as TextInput;
				switch (col.dataField) {
					// 金額.
					case "expense":
						if (editorTx.text.length > 0) {
							editorTx.text = LabelUtil.expenseFormatOff(editorTx.text);
						}
						break;
					// 通勤先等.
					case "destination":
						editorTx.maxChars = 64;
						break;
					// 交通機関名.
					case "facilityCmpName":
						editorTx.maxChars = 64;
						break;
					// 出発地.
					case "departure":
						editorTx.maxChars = 32;
						break;
					// 到着地.
					case "arrival":
						editorTx.maxChars = 32;
						break;
					// 経由.
					case "via":
						editorTx.maxChars = 32;
						break;
				}
				// 変更前の値を記憶します
				_oldValue = "";
				if (cell != null) _oldValue = StringUtil.trim(editorTx.text);
			}
		}


		/**
		 * データ編集終了.
		 *
		 * @param e DataGridEvent
		 */
		public function onItemEditEnd(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			var ciDto:CommutationItemDto = dg.selectedItem as CommutationItemDto;

			// テキストインプットならば
			if(dg.itemEditorInstance && dg.itemEditorInstance is TextInput) {
				// 編集中カラムの取得
				var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
				// 金額ならば数値以外は受け付けない..
				if (e.dataField == "expense"){
					// 編集中アイテムエディタの取得
					var editor:TextInput = dg.itemEditorInstance as TextInput;
					var newData:String = editor.text;
					if (newData == "") 	return;
					
					// 半角に変換する
					newData = Kana.toHankakuCase(newData);
					var expense:Number = Number(newData);
					if (isNaN(expense) || int(expense) != expense || StringUtil.trim(newData).length == 0) {
						TextInput(dg.itemEditorInstance).errorString = "数値を入力してください";
						editor.text = "";
						return;
					}
					// 変換した値を設定する.
					editor.text = String(expense);

				}
			}
		}

		/**
		 * データフォーカス Out.
		 *
		 * @param e DataGridEvent
		 */
		public function onItemFocosOut(e:DataGridEvent):void
		{
			var dg:DataGrid = e.currentTarget as DataGrid;
			var col:DataGridColumn = e.currentTarget.columns[e.columnIndex];
			var ciDto:CommutationItemDto = dg.selectedItem as CommutationItemDto;
			var newValue:String;

			// 編集データを取得する.
			if (dg.itemEditorInstance && dg.itemEditorInstance is TextInput) {
				// fieldを取得する.
				var editor:TextInput = dg.itemEditorInstance as TextInput;
				// データ変更なしならばこのまま抜ける
				newValue = StringUtil.trim(editor.text);
				if(newValue ==_oldValue) return;

				// 金額が入力された場合.
				if (col.dataField == "expense"){
					var totalVal:int = 0;
					var data:ArrayCollection = dg.dataProvider as ArrayCollection;
					for (var i:int = 0; i < data.length; i++) {
						// データを取得する.
						var items:CommutationItemDto = data.getItemAt(i) as CommutationItemDto;
						totalVal += items.expense != null && items.expense != ""  ? parseInt(items.expense) : 0;
					}
					// 合計の表示更新.
					this.view.commuItemsTotal.text = LabelUtil.currency(totalVal.toString());
					// イベントを通知する.
					view.dispatchEvent(new Event("changeExpense"));
					
				}

				// 申請できるかどうか確認する.
				if (ciDto.checkApply()) {
					_errorCount[e.rowIndex] = 0;
				}
				else {
					_errorCount[e.rowIndex] = 1;
				}
			}
			else if (dg.itemEditorInstance && dg.itemEditorInstance is EditComboBox) {
				var edCombo:EditComboBox = dg.itemEditorInstance as EditComboBox;
				// データ変更なしならばこのまま抜ける
				newValue = StringUtil.trim(edCombo.text);
				if(newValue ==_oldValue) return;
				
				// コンボリストに存在しないときは リストに追加する.
				for (var index:int = 0; index < _facilityNameList.length; index++) {
					if (ObjectUtil.compare(_facilityNameList.getItemAt(index).label, edCombo.text) == 0) {
						break;
					}
				}
				if (index == _facilityNameList.length) {
					_facilityNameList.addItem({label:edCombo.text});
				}
			}
			
			// 背景色設定
			setColorPattern(dg.dataProvider as ArrayCollection);

			// validateチェックをする.
			validateCommutationItemList();
			
			// イベントを通知する.
			view.dispatchEvent(new Event("changeInputData"));
		}
		
		/**
	     * 行の背景色用カラーパターンを生成.
	     *
	     * @param data	データプロバイダ.
	     */
		private function setColorPattern(data:ArrayCollection):void
		{
			var list:ArrayCollection = view.grdCommutationItem.dataProvider as ArrayCollection;
			// 表の行数を取得する.
			var rowNum:int = (list.length > view.grdCommutationItem.rowCount) ? list.length : view.grdCommutationItem.rowCount;
			
			if (!data) return;
			if(!_defaultColors){
				// 初期値のカラーパターンを記憶
				_defaultColors = view.grdCommutationItem.getStyle("alternatingItemColors");
			}
			
			// 入力エラー行は 背景色を変更する.
			_errorCount = new Array(rowNum);
			var colors:Array = new Array();
			for (var i:int = 0; i < rowNum; i++) {
				// 明細データ ＜ 表示行数 のとき.
				if (i < list.length) {
					// 明細を1件取得する.
					var ciDto:CommutationItemDto = data.getItemAt(i) as CommutationItemDto;
					// データ入力行であるか確認する.
					if(ciDto.checkEntry()){
						// 申請できるかどうか確認する.
						if (ciDto.checkApply()) {
							colors.push(_defaultColors[i % 2]);
							_errorCount[i] = 0;
						}
						else {
							colors.push(_COMMUTATION_ERROR);
							_errorCount[i] = 1;
						}
					}
					else
					{
						colors.push(_defaultColors[i % 2]);
						_errorCount[i] = 0;
					}
				}
				// 明細データ ＞ 表示行数 のとき.
				else {
					colors.push(_defaultColors[i % 2]);
				}
			}
			view.grdCommutationItem.setStyle("alternatingItemColors", colors);
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

			ret = validateCommutationItemList();
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
		 * validatorチェック（通勤費詳細）.
		 *
		 * @return チェック結果.
		 */
		public function validateCommutationDetail():Boolean
		{
			var isErr:Boolean=false;
			var msg:String = "通勤開始日は必須です。";
			if(!view){
				if(!_commuDetail.commutationStartDate) isErr = true;
			}
			else{
				// 未入力
				if(!view.commuStartDate.selectedDate) isErr = true;
				// 範囲
				var target:Date  = view.commuStartDate.selectedDate;
				var range:Object = view.commuStartDate.selectableRange;
				if (ObjectUtil.compare(target, range.rangeStart) < 0 ||
					ObjectUtil.compare(range.rangeEnd, target)   < 0 )
					isErr = true;
			}
			if(!isErr){
				msg = "";
			}
			view.commuStartDate.errorString = msg;
			// validate 結果を設定する.
			if (msg && msg.length > 0)			return false;
			else 								return true;
		}

		/**
		 * validatorチェック（DataGrid 通勤項目）.
		 *
		 * @return チェック結果.
		 */
		public function validateCommutationItemList():Boolean
		{
			// DataGridの validate チェックをする.
			var msg:String = "通勤項目は必須です。";
			var list:ArrayCollection = view.grdCommutationItem.dataProvider as ArrayCollection;
			for each (var commitem:CommutationItemDto in list) {
				if (commitem.checkEntry()) {
					msg = "";
					break;
				}
			}
			view.grdCommutationItem.errorString = msg;

			// validate 結果を設定する.
			if (msg && msg.length > 0)			return false;
			else 								return true;
		}
		
		/**
		 * データ変更状態設定.
		 *
		 */
		private function setModifiedStatus(modified:Boolean):void
		{
			// データ変更有無のセット
			Application.application.indexLogic.modified = modified;
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CommutationForm;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():CommutationForm
	    {
	        if (_view == null) {
	            _view = super.document as CommutationForm;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:CommutationForm):void
	    {
	        _view = view;
	    }
	    
	    /**
	    * 保存可能であるかを判定します.
	    * 
	    */
	    public function get isEntry():Boolean
	    {
	    	// 通勤日
	    	if (!validateCommutationDetail())return false;
	    	return true;
	    }
	    
	    /**
	    * 申請可能であるかを判定します.
	    * 
	    */
	    public function get isApply():Boolean
	    {
	    	// 通勤日
	    	if (!validateCommutationDetail())return false;
	    	
	    	// DataGridにエラーがあるかを調べる.
	    	for each (var err:int in _errorCount){
	    		if (err != 0) return false;
	    	}

			// DataGrid未入力の場合はエラーとする.
			if (!validateCommutationItemList())return false;

	    	return true;
	    }
	}
}