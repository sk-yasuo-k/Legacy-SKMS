package subApplications.generalAffair.workingConditions.logic
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.workingConditions.dto.WorkingAllConditions;
	import subApplications.generalAffair.workingConditions.dto.WorkingHoursMonthlyExtListDto;
	import subApplications.generalAffair.workingConditions.web.WorkingConditions;
	import subApplications.generalAffair.workingConditions.web.components.CheckBoxDataGridHeaderRenderer;
	

	public class WorkingConditionsLogic extends Logic 
	{
		
		//勤務状況
		public var _workingHoursMonthlyExtListDto:WorkingHoursMonthlyExtListDto = new WorkingHoursMonthlyExtListDto(null);
		[Bindable]
		public var _workingHoursMonthlyList:ArrayCollection = new ArrayCollection();
		
		//画面のすべての条件
		public var _screenAllConditions:WorkingAllConditions = new WorkingAllConditions();
		
		//全選択・全選択解除
		public var _allShow:Boolean = true;
		
		//送信した開始日		
		private var _sendStartDate:Date = new Date();
		//送信した終了日
		private var _sendFinishDate:Date = new Date();		
		
		//社員選択のheaderRenderer
		[Bindable]
		public var _headerRenderer:ClassFactory;
		
		//csv出力URL
		private const exportURL:String = "/skms-server/workingConditionsCsvFileExport" 
			
		/**
		 * コンストラクタ
		 * */
		public function WorkingConditionsLogic()
		{
			super();
			//開いたときに先月の1日と最終日にする
			var date:Date = new Date();
			date.month = date.month - 1;
			this.onlyOneMonth(date);
			
			//社員選択フィールド作成
			this.InitHeaderRender();
			//開始日が変更された時のイベント登録
			ChangeWatcher.watch(this._screenAllConditions, "startDate", this.startDateFieldChangeHandler);
		}
		
		/**
		 * 社員選択フィールド作成 
		 * */
		public function InitHeaderRender():void
		{
			this._headerRenderer = new ClassFactory(CheckBoxDataGridHeaderRenderer);
			this._headerRenderer.properties = { parentObject:this, state:"_allShow" };
		}

		
		/**
		 * 開始日が変更されたときに動作
		 * */
		private function startDateFieldChangeHandler(e:Event):void
		{
			if( this._screenAllConditions.isOnlyOneMonth ){
				this.onlyOneMonth(this._screenAllConditions.startDate);
			}
		}
		
		/**
		 * 適当な日を選択すると自動的に開始日をその月の1日、終了日をその月の最終日にする
		 * */
		private function onlyOneMonth(date:Date):void
		{
			if( !isAfterChangeForce() ){
				this._screenAllConditions.startDate.fullYear = date.fullYear;
				this._screenAllConditions.startDate.month = date.month;
				this._screenAllConditions.startDate.date = 1;
				this._screenAllConditions.finishDate = new Date(date.fullYear,date.month,  this.getLastDay(date.fullYear,date.month));
				
			}			
		}
		
		/**
		 * 強制的に1ヶ月指定をした後か判定する
		 *   自身を書き換えた後にも反応してしまうため作成
		 * */
		private function isAfterChangeForce():Boolean{
			
			if( this._screenAllConditions.startDate.fullYear == this._screenAllConditions.finishDate.fullYear
				&& this._screenAllConditions.startDate.month == this._screenAllConditions.finishDate.month
				&& this._screenAllConditions.startDate.date == 1 
				&& this._screenAllConditions.finishDate.date == this.getLastDay( this._screenAllConditions.startDate.fullYear, this._screenAllConditions.startDate.month) ){
				return true;
			}else{
				return false;
			}
		}
		
		/**
		 * 閏年判定
		 * */
		private function isLeapYear( year:Number ):Boolean
		{
			return (0 == (year % 400)) || ((0 != (year % 100)) && (0 == (year % 4)));
		}
		
		/**
		 * 月末作成
		 * */
		 private function getLastDay( year:Number, month:Number ):Number
		 {
		 	//月は-1された値が入る example: 1月→0 10月→9
		 	var result:Number = 31;
		 	switch(month){
		 		case 0:
		 		case 2:
		 		case 4:
		 		case 6:
		 		case 7:
		 		case 9:
		 		case 11:
		 			break; 
		 		case 3:
		 		case 5:
		 		case 8:
		 		case 10:
		 			result = 30;
		 			break;
		 		case 1:
		 			if(isLeapYear(year)){
		 				result = 29;
		 			}else{
		 				result = 28;
		 			}
		 			break;
		 		default:
		 		//ありえない
		 			break;		 			
		 	}
		 	return result;
		 }
		
		/**
		 * 強制的に1日を表示する
		 * */
		public function mydateformatter(date:Date):String
		{
			var df:DateFormatter = new DateFormatter();
			if( this._screenAllConditions.isOnlyOneMonth ){
				df.formatString = "YYYY/MM/01";
			}else{
				df.formatString = "YYYY/MM/DD";
			}
			
			return df.format(date);
		}
		
		/**
		 * 画面が呼び出されたとき最初に実行される
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			//以下バインド
			//状況一覧
			BindingUtils.bindProperty(view.list, "dataProvider", this, "_workingHoursMonthlyList");
//			BindingUtils.bindProperty(view.list, "dataProvider", this._workingHoursMonthlyExtListDto, "WorkingHoursMonthlyExtList"); できない理由がよくわからない…
			//開始日
			this.wayBinding(view.startDateField, "selectedDate", this._screenAllConditions, "startDate");
			//終了日
			this.wayBinding(view.finishDateField, "selectedDate", this._screenAllConditions, "finishDate");
			//表示非表示
			BindingUtils.bindProperty(view.showColumn, "visible", this._screenAllConditions, "show");
			//総勤務時間		
			this.BindingCheckBoxAndDataGridColumn(view.workingHoursCheckBox, "workingHours", view.workingHoursColumn);
			//実勤務時間
			this.BindingCheckBoxAndDataGridColumn(view.realWorkingHoursCheckBox, "realWorkingHours", view.realWorkingHoursColumn);
			//控除
			this.BindingCheckBoxAndDataGridColumn(view.deductionCountCheckBox, "deductionCount", view.deductionCountColumn);
			//深夜勤務
			this.BindingCheckBoxAndDataGridColumn(view.nightWorkCountCheckBox, "nightWorkCount", view.nightWorkCountColumn);
			//休日出勤
			this.BindingCheckBoxAndDataGridColumn(view.holidayWorkCountCheckBox, "holidayWorkCount", view.holidayWorkCountColumn);
			//欠勤
			this.BindingCheckBoxAndDataGridColumn(view.absenceCountCheckBox, "absenceCount", view.absenceCountColumn);
			//無断欠勤
			this.BindingCheckBoxAndDataGridColumn(view.absenceWithoutLeaveCountCheckBox, "absenceWithoutLeaveCount", view.absenceWithoutLeaveCountColumn);
			//使用有給数
			this.BindingCheckBoxAndDataGridColumn(view.takenPaidVacationCountCheckBox, "takenPaidVacationCount", view.takenPaidVacationCountColumn);
			//残有給数 
			this.BindingCheckBoxAndDataGridColumn(view.currentPaidVacationCountCheckBox, "currentPaidVacationCount", view.currentPaidVacationCountColumn);
			//使用代休数
			this.BindingCheckBoxAndDataGridColumn(view.takenCompensatoryDayOffCountCheckBox, "takenCompensatoryDayOffCount", view.takenCompensatoryDayOffCountColumn);
			//残代休数
			this.BindingCheckBoxAndDataGridColumn(view.currentCompensatoryDayOffCountCheckBox, "currentCompensatoryDayOffCount", view.currentCompensatoryDayOffCountColumn);
			//使用特別休暇
			this.BindingCheckBoxAndDataGridColumn(view.takenSpecialVacationCountCheckBox, "takenSpecialVacationCount", view.takenSpecialVacationCountColumn);
			//残特別休暇
			this.BindingCheckBoxAndDataGridColumn(view.currentSpecialVacationCountCheckBox, "currentSpecialVacationCount", view.currentSpecialVacationCountColumn);
			//1ヶ月集計のみ			
			this.wayBinding(view.onlyOneMonthCheckBox, "selected", this._screenAllConditions, "isOnlyOneMonth");
			//社員一覧取得
			this.view.workingConditionsService.getOperation("getStaffNameList").send();
			
			//勤務状況一覧の社員選択CheckBoxの部分
			this.view.showColumn.headerRenderer = this._headerRenderer;
			
		}
		
		/**
		 * CheckBoxとDataGridColumをすべてバインド
		 * (本来分割出来る書き方ではないけど、量が多い…)
		 * */
		private function BindingCheckBoxAndDataGridColumn( checkBox:CheckBox, boolData:String, dataGridColumn:DataGridColumn):void
		{
			this.wayBinding(checkBox, "selected", this._screenAllConditions, boolData);			
			this.wayBinding(dataGridColumn, "visible", this._screenAllConditions, boolData);			
		}
		
		/**
		 * 双方向バインド
		 *   標準では片方向でしかないので作成
		 * */
		private function wayBinding(bindingObject1:Object, bindingProperty1:String, 
										bindingObject2:Object, bindingProperty2:String):void
		{
			BindingUtils.bindProperty(bindingObject1, bindingProperty1, bindingObject2, bindingProperty2);
			BindingUtils.bindProperty(bindingObject2, bindingProperty2, bindingObject1, bindingProperty1);	
		}
		
		/**
		 * 表示社員選択ボタン押下時
		 * */
		public function onClick_selectedEmp(e:MouseEvent):void
		{
			//選択フィールドを表示する
			this._screenAllConditions.show = true;
			//stateを社員選択用に切り替える
			this.view.currentState = "selectEmp";
			this._workingHoursMonthlyList.refresh();
		}
		
		/**
		 * 表示社員決定ボタン押下時
		 * */
		public function onClick_ConfirmedEmp(e:MouseEvent):void
		{
			this._screenAllConditions.show = false;
			this.view.currentState = "basic";
			this._workingHoursMonthlyList.refresh();
		}
		
		
		/**
		 * 表示されている期間と現在表示されている集計データの期間が異なっていないか判定
		 * */
		public function onClick_getCsv(e:MouseEvent):void
		{
			//表示しているデータと集計期間の違いは無いか
			if(	this._sendStartDate.valueOf() == this._screenAllConditions.startDate.valueOf()
					&& this._sendFinishDate.valueOf() == this._screenAllConditions.finishDate.valueOf() ){
				//一致していれば問題なし
				this.createCsvFile();
			}else{
				// 不一致なので確認ダイアログ表示
				Alert.show("一覧表示している期間と\ncsvファイルを作成する期間が\n異なりますがよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						onClick_AnotherPeriod, null, Alert.CANCEL);				
			}
			
		}
		
		/**
		 * 表示されている期間と現在表示されている集計データの期間が異なっていたときに
		 * 表示されるダイアログのクローズ処理
		 * */		
		public function onClick_AnotherPeriod(e:CloseEvent):void
		{
			if(e.detail == Alert.OK ){
				//期間が異なっていても問題無しのとき
				this.createCsvFile();
			}
		}
		
		/**
		 * csvファイルを出力POST送信
		 * */
		public function createCsvFile():void{
			// HTTPリクエストの準備
			var request:URLRequest = new URLRequest(exportURL);
			request.method = URLRequestMethod.POST;

			//送信用パラメータ作成
			request.data = this.setDataURLVariables();
			
			// HTTPリクエストの送信
			navigateToURL(request, "_blank");
		}
		
		/**
		 * 送信用パラメータ作成
		 * */
		private function setDataURLVariables():URLVariables
		{
			// パラメータを用意
			var variables:URLVariables = new URLVariables();
			//TODO:リフレクションを使って書き直しを検討
			
			//社員名
			variables.staffFullName = this._screenAllConditions.staffFullName;
			//差引時間
			variables.balanceHours = this._screenAllConditions.balanceHours;
			//私用時間
			variables.privateHours = this._screenAllConditions.privateHours;
			//勤務時間
			variables.workingHours = this._screenAllConditions.workingHours;
			//休憩時間
			variables.recessHours = this._screenAllConditions.recessHours;
			//実働時間
			variables.realWorkingHours = this._screenAllConditions.realWorkingHours;
			//控除数
			variables.deductionCount = this._screenAllConditions.deductionCount;
			//欠勤日数
			variables.absenceCount = this._screenAllConditions.absenceCount;
			//無断欠勤日数
			variables.absenceWithoutLeaveCount = this._screenAllConditions.absenceWithoutLeaveCount;
			//深夜勤務日数
			variables.nightWorkCount = this._screenAllConditions.nightWorkCount;
			//休日出勤日数
			variables.holidayWorkCount = this._screenAllConditions.holidayWorkCount;
			//有給繰越日数
			variables.lastPaidVacationCount = this._screenAllConditions.lastPaidVacationCount;
			//有給今月発生日数
			variables.givenPaidVacationCount = this._screenAllConditions.givenPaidVacationCount;
			//有給今月消滅日数
			variables.lostPaidVacationCount = this._screenAllConditions.lostPaidVacationCount;
			//有給今月使用日数
			variables.takenPaidVacationCount = this._screenAllConditions.takenPaidVacationCount;
			//有給今月残日数
			variables.currentPaidVacationCount = this._screenAllConditions.currentPaidVacationCount;
			//特別休暇繰越日数
			variables.lastSpecialVacationCount = this._screenAllConditions.lastSpecialVacationCount;
			//特別休暇今月発生日数
			variables.givenSpecialVacationCount = this._screenAllConditions.givenSpecialVacationCount;
			//特別休暇今月消滅日数
			variables.lostSpecialVacationCount = this._screenAllConditions.lostSpecialVacationCount;
			//特別休暇今月使用日数
			variables.takenSpecialVacationCount = this._screenAllConditions.takenSpecialVacationCount;
			//特別休暇今月残日数
			variables.currentSpecialVacationCount = this._screenAllConditions.currentSpecialVacationCount;
			//代休繰越日数
			variables.lastCompensatoryDayOffCount = this._screenAllConditions.lastCompensatoryDayOffCount;
			//代休今月発生日数
			variables.givenCompensatoryDayOffCount = this._screenAllConditions.givenCompensatoryDayOffCount;
			//代休今月消滅日数
			variables.lostCompensatoryDayOffCount = this._screenAllConditions.lostCompensatoryDayOffCount;
			//代休今月使用日数
			variables.takenCompensatoryDayOffCount = this._screenAllConditions.takenCompensatoryDayOffCount;
			//代休今月残日数
			variables.currentCompensatoryDayOffCount = this._screenAllConditions.currentCompensatoryDayOffCount;
			
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYY/MM/DD";
			//集計開始日
			variables.startDate = df.format(this._screenAllConditions.startDate);
			//集計終了日
			variables.finishDate = df.format(this._screenAllConditions.finishDate);
			//1ヶ月のみにするかどうか
			variables.isOnlyOneMonth = this._screenAllConditions.isOnlyOneMonth;
			//表示している社員
			variables.showStaffList = this._workingHoursMonthlyExtListDto.getShowStaffList();
			
			return variables;
		}
		
		/**
		 * 業務状況集計一覧をクリックしたとき
		 *   目的はHeaderのCheckBoxのClick処理
		 * */
		public function onClick_DataGrid(e:Event):void
		{
			//社員表示選択のCheckBoxをClickした時
			if(e.target is CheckBoxDataGridHeaderRenderer){
				_workingHoursMonthlyExtListDto.changeAllShow(_allShow);
				this._workingHoursMonthlyList.refresh();
			}			
		}
		
		/**
		 * 集計ボタン押下時
		 * */
		public function onClick_AggregateButton(e:MouseEvent):void
		{
		 	this.aggregate();
		}
		
		/**
		 * 指定された年月のデータを取得
		 * */
		private function aggregate():void
		{	
			//取得済みのデータと送信する日付が同じかどうか
			if( !(this._screenAllConditions.startDate.valueOf() == this._sendStartDate.valueOf()
					&& this._screenAllConditions.finishDate.valueOf() == this._sendFinishDate.valueOf()) ){
				//送信済み日付の保存
				this._sendStartDate = new Date(this._screenAllConditions.startDate.fullYear, this._screenAllConditions.startDate.month, this._screenAllConditions.startDate.date);
				this._sendFinishDate = new Date(this._screenAllConditions.finishDate.fullYear, this._screenAllConditions.finishDate.month, this._screenAllConditions.finishDate.date);
			 
				this.view.workingConditionsService.getOperation("getStaffWorkingHoursMonthlyList").send(this._screenAllConditions.startDate);
			}
		} 

		/**
		 * 社員名一覧取得成功時
		 * */
		 public function onResult_getStaffNameList(e:ResultEvent):void
		 {
		 	trace("onResult_getStaffNameList...");
		 	_workingHoursMonthlyExtListDto = new WorkingHoursMonthlyExtListDto(e.result);
		 	this.aggregate();
		 }
		 
		 /**
		 * 社員名一覧取得失敗時
		 * */
		 public function onFault_getStaffNameList(e:FaultEvent):void
		 {
		 	Alert.show("社員一覧取得に失敗しました。","error");
		 	trace(e.message);
		 }
		 
		 /**
		 * 社員月別勤務状況取得成功時
		 * */
		 public function onResult_getStaffWorkingHoursMonthlyList(e:ResultEvent):void
		 {
		 	trace("onResult_getStaffWorkingHoursMonthlyList...");
		 	this._workingHoursMonthlyExtListDto.update(e.result);
		 	this._workingHoursMonthlyList = _workingHoursMonthlyExtListDto.WorkingHoursMonthlyExtList;
			if( _workingHoursMonthlyList.filterFunction == null){
				_workingHoursMonthlyList.filterFunction = showFilter;
			}

		 	this._workingHoursMonthlyList.refresh();
		 }
		 
		 /**
		 * 社員月別勤務状況取得失敗時
		 * */
		 public function onFault_getStaffWorkingHoursMonthlyList(e:FaultEvent):void
		 {
		 	Alert.show("指定された期間の社員勤務状況集計データの取得に失敗しました。","error");
		 	trace(e.message);
		 }
		 
		 
		 /**
		 * ArrayCollectionのfilterFunction用関数オブジェクト
		 * 表示非表示切り替え
		 * */
		 public function showFilter(data:Object):Boolean
		 {
		 	//通常画面
		 	if(view.currentState == "basic"){
		 		return data.show;
		 	}else{
		 	//表示者選択画面
		 		return true;
		 	}
		 		
		 }
		 
		 /**
		 * ラベルフォーマッタ
		 *  0以外は小数点2桁まで表示
		 * */
		 public function numberFormat(data:Object, column:DataGridColumn):String {
			var formatter:NumberFormatter = new NumberFormatter();
			if(data[column.dataField] != 0){
				formatter.precision = 2;
			}else{
				formatter.precision = 0;
			}
			formatter.useThousandsSeparator = true;
			return formatter.format(data[column.dataField]);
		}

		 		
		/** 画面 */
	    public var _view:WorkingConditions;

	    /**
	     * 画面を取得します
	     */
	    public function get view():WorkingConditions
	    {
	        if (_view == null) {
	            _view = super.document as WorkingConditions;
	        }
	        return this._view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:WorkingConditions):void
	    {
	        this._view = view;
	    }
	}
}