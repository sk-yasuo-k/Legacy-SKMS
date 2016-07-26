package subApplications.home.logic
{
	import enum.WorkingHoursStatusId;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ValidationResultEvent;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import subApplications.generalAffair.dto.WorkingHoursDailyDto;
	import subApplications.generalAffair.dto.WorkingHoursHistoryDto;
	import subApplications.generalAffair.dto.WorkingHoursMonthlyDto;
	import subApplications.home.web.HomePage;
	import subApplications.system.dto.StaffSettingDto;
	
	/**
	 * HomePageのLogicクラスです.
	 */
	public class HomePageLogic extends Logic
	{
		private var _oneDayMilliseconds:Number = (24 * 60 * 60 * 1000);
		// 社員ID
		private var _staffId:int;
		// 勤務管理表
		private var _whmDto:WorkingHoursMonthlyDto;
		// 日別勤務時間
		private var _whdDto:WorkingHoursDailyDto;
		private var _todayDate:Date;
		private var _settingDate:Date;

		// 休日出勤タイプ一覧
		private var _holidayWorkTypeList:ArrayCollection;

		// 時刻フォーマッタ
		private var _timeFormatter:DateFormatter;
		// 時間フォーマッタ
		private var _hoursFormatter:NumberFormatter;

		// リンクボタンアイコン
        [Embed(source="images/arrow_previous.gif")]
        private var _icon_previous:Class;
		
        [Embed(source="images/arrow_previous_d.gif")]
        private var _icon_previous_d:Class;

        [Embed(source="images/arrow_next.gif")]
        private var _icon_next:Class;

        [Embed(source="images/arrow_next_d.gif")]
        private var _icon_next_d:Class;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function HomePageLogic()
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
			_todayDate = new Date();
			_settingDate = new Date(_todayDate);
			_staffId = Application.application.indexLogic.loginStaff.staffId;

			_todayDate.setHours(0, 0, 0, 0);
			_settingDate.setHours(0, 0, 0, 0);
			
			// 時刻フォーマッタの生成
			_timeFormatter = new DateFormatter();
			_timeFormatter.formatString = "JJ:NN";

			// 時間フォーマッタの生成
			_hoursFormatter = new NumberFormatter();
			_hoursFormatter.precision = 2;
			_hoursFormatter.thousandsSeparatorTo = "";
			
			// 休日出勤タイプデータの取得
	    	view.srv.getOperation("getHolidayWorkTypeList").send();
			
			// 勤務管理表データの取得
			getWorkingHoursMonthly(_staffId, _settingDate);
			
	    }


//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * お知らせリンクボタン選択イベント.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkAnnounce(e:Event):void
		{
       		var u:URLRequest = new URLRequest("./announce/20090831.html");
       		navigateToURL(u, "_blank");
		}

		/**
		 * リンクボタン選択 前月.
		 *
		 */
		public function onClick_linkPreviousDate(e:MouseEvent):void
		{
			// 月替わりの判定
			if (_settingDate.date == 1) {
				_settingDate.setTime(_settingDate.getTime() - _oneDayMilliseconds);
				_settingDate.setHours(0, 0, 0, 0);
				getWorkingHoursMonthly(_staffId, _settingDate);
				view.linkPreviousDate.enabled = false;
			} else {
				_settingDate.setTime(_settingDate.getTime() - _oneDayMilliseconds);
				_settingDate.setHours(0, 0, 0, 0);
				showWorkingHours(_settingDate);
			}
		}
		
		/**
		 * リンクボタン選択 翌日.
		 *
		 */
		public function onClick_linkNextDate(e:MouseEvent):void
		{
			_settingDate.setTime(_settingDate.getTime() + _oneDayMilliseconds);
//			_settingDate.setHours(0, 0, 0, 0);
			
			// 月替わりの判定
			if (_settingDate.date == 1) {
				getWorkingHoursMonthly(_staffId, _settingDate);
				view.linkPreviousDate.enabled = true;
			} else {
				showWorkingHours(_settingDate);
			}
		}
		
		/**
		 * リンクボタン選択 開始時刻更新.
		 *
		 */
		public function onClick_linkUpdateStartTime(e:MouseEvent):void
		{
			var now:Date = new Date();
   			now.minutes = Math.ceil(now.minutes / 15) * 15;
			view.cmbStartTime.data = _timeFormatter.format(now);
			view.cmbStartTime.text = _timeFormatter.format(now);
			onFocusOut_cmbStartTime(null);
		}
		
		/**
		 * リンクボタン選択 終了時刻更新.
		 *
		 */
		public function onClick_linkUpdateQuittingTime(e:MouseEvent):void
		{
			var now:Date = new Date();
   			now.minutes = Math.floor(now.minutes / 15) * 15;
			view.cmbQuittingTime.data = _timeFormatter.format(now);
			view.cmbQuittingTime.text = _timeFormatter.format(now);
			onFocusOut_cmbQuittingTime(null);
		}
		
		/**
		 * リンクボタン選択 Google Map 検索.
		 *
		 */
		public function onClick_linkGoogleMap(e:MouseEvent):void
		{
//			var req:URLRequest = new URLRequest("http://maps.google.co.jp/maps");
//			req.method = URLRequestMethod.GET;
//			var uv:URLVariables = new URLVariables();
//			uv.f = "d";
//			uv.hl= "ja";
//			uv.q = view.txtAddress.text;
//			uv.z = "18";
//			req.data = uv;
// 			navigateToURL(req, "_blank");
		}
		
		/**
		 * 時差勤務開始時刻変更イベント.
		 *
		 * @param e FocusEvent
		 */
		public function onFocusOut_cmbStaggeredStartTime(e:FocusEvent):void
		{
			_whdDto.staggeredStartTime = convertStringToTime(_whdDto.workingDate, view.cmbStaggeredStartTime.text);
			if (_whdDto.staggeredStartTime) {
				view.cmbStaggeredStartTime.data = _timeFormatter.format(_whdDto.staggeredStartTime);
				view.cmbStaggeredStartTime.text = _timeFormatter.format(_whdDto.staggeredStartTime);
			} else {
				view.cmbStaggeredStartTime.data = "";
				view.cmbStaggeredStartTime.text = "";
			}
		}
		
		/**
		 * 開始時刻変更イベント.
		 *
		 * @param e FocusEvent
		 */
		public function onFocusOut_cmbStartTime(e:FocusEvent):void
		{
			_whdDto.startTime = convertStringToTime(_whdDto.workingDate, view.cmbStartTime.text);
			if (_whdDto.startTime) {
				view.cmbStartTime.data = _timeFormatter.format(_whdDto.startTime);
				view.cmbStartTime.text = _timeFormatter.format(_whdDto.startTime);
			} else {
				view.cmbStartTime.data = "";
				view.cmbStartTime.text = "";
			}
		}
		
		/**
		 * 終了時刻変更イベント.
		 *
		 * @param e ListEvent
		 */
		public function onChange_cmbQuittingTime(e:ListEvent):void
		{
 			_whdDto.quittingTime = convertStringToTime(_whdDto.workingDate, view.cmbQuittingTime.text);
			if (_whdDto.quittingTime) {
				if (_whdDto.quittingTime <= _whdDto.startTime) {
					_whdDto.quittingTime.setTime(_whdDto.quittingTime.getTime() + _oneDayMilliseconds);
				}
				_whdDto.recessHours = 0;
				_whdDto.calculateDailyTotal();
				view.txtRecessHours.text = _hoursFormatter.format(_whdDto.recessHours);
				view.lblRealWorkingHours.text = _hoursFormatter.format(_whdDto.realWorkingHours);
			}

		}
		
		/**
		 * 終了時刻変更イベント.
		 *
		 * @param e FocusEvent
		 */
		public function onFocusOut_cmbQuittingTime(e:FocusEvent):void
		{
 			_whdDto.quittingTime = convertStringToTime(_whdDto.workingDate, view.cmbQuittingTime.text);
			if (_whdDto.quittingTime) {
				view.cmbQuittingTime.data = _timeFormatter.format(_whdDto.quittingTime);
				view.cmbQuittingTime.text = _timeFormatter.format(_whdDto.quittingTime);
				if (_whdDto.quittingTime <= _whdDto.startTime) {
					_whdDto.quittingTime.setTime(_whdDto.quittingTime.getTime() + _oneDayMilliseconds);
				}
				_whdDto.recessHours = 0;
				_whdDto.calculateDailyTotal();
				view.txtRecessHours.text = _hoursFormatter.format(_whdDto.recessHours);
				view.lblRealWorkingHours.text = _hoursFormatter.format(_whdDto.realWorkingHours);
			} else {
				view.cmbQuittingTime.data = "";
				view.cmbQuittingTime.text = "";
			}

		}
		
		/**
		 * 私用時刻変更イベント.
		 *
		 * @param e FocusEvent
		 */
		public function onFocusOut_txtPrivateHours(e:FocusEvent):void
		{
			var privateHours:Number = parseFloat(view.txtPrivateHours.text);
			// 不正な入力ならば
			if (isNaN(privateHours) || privateHours < 0) {
				_whdDto.privateHours = 0;
			} else {
				_whdDto.privateHours = parseFloat(view.txtPrivateHours.text);
			}
//			whdDto.recessHours = 0;
			_whdDto.calculateDailyTotal();
			// 休憩時間が多すぎる場合は再計算
			if (!isNaN(_whdDto.workingHours) && _whdDto.realWorkingHours < 0) {
				_whdDto.privateHours = 0;
				_whdDto.calculateDailyTotal();
			}
			view.txtPrivateHours.text = _hoursFormatter.format(_whdDto.privateHours);
			view.txtRecessHours.text = _hoursFormatter.format(_whdDto.recessHours);
			view.lblRealWorkingHours.text = _hoursFormatter.format(_whdDto.realWorkingHours);

		}
		
		/**
		 * 休憩時刻変更イベント.
		 *
		 * @param e FocusEvent
		 */
		public function onFocusOut_txtRecessHours(e:FocusEvent):void
		{
 			var recessHours:Number = parseFloat(view.txtRecessHours.text);
			// 不正な入力ならば
			if (isNaN(recessHours) || recessHours < 0) {
				_whdDto.recessHours = 0;
			} else {
				_whdDto.recessHours = parseFloat(view.txtRecessHours.text);
			}
			_whdDto.calculateDailyTotal();
			// 休憩時間が多すぎる場合は再計算
			if (!isNaN(_whdDto.realWorkingHours) && _whdDto.realWorkingHours < 0) {
				_whdDto.recessHours = 0;
				_whdDto.calculateDailyTotal();
			}
			view.txtRecessHours.text = _hoursFormatter.format(_whdDto.recessHours);
			view.lblRealWorkingHours.text = _hoursFormatter.format(_whdDto.realWorkingHours);

		}
		
		/**
		 * 出社ボタン押下イベント.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_btnStartTime(e:Event):void
		{
 			// 時差勤務開始時刻取得
			_whdDto.staggeredStartTime = convertStringToTime(_whdDto.workingDate, view.cmbStaggeredStartTime.text);
			// 開始時刻取得
			_whdDto.startTime = convertStringToTime(_whdDto.workingDate, view.cmbStartTime.text);
        	// 日別集計
        	_whdDto.calculateDailyTotal();
        	// 月間集計
        	_whmDto.workingHoursDailies.setItemAt(_whdDto, _settingDate.date-1);
        	_whmDto.calculateMonthlyTotal();
        	// データベースを更新
	    	view.srv.getOperation("updateWorkingHoursMonthly").send(_whmDto);
		}

		/**
		 * 退社ボタン押下イベント.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_btnQuittingTime(e:Event):void
		{
			// 休日出勤
			_whdDto.holidayWorkType = view.cmbHolidayWork.selectedItem.holidayWorkType;
			// 備考
			_whdDto.note = StringUtil.trim(view.txtNote.text);
			
        	// 日別集計
        	_whdDto.calculateDailyTotal();
        	// 月間集計
        	_whmDto.workingHoursDailies.setItemAt(_whdDto, _settingDate.date-1);
        	_whmDto.calculateMonthlyTotal();
        	// データベースを更新
	    	view.srv.getOperation("updateWorkingHoursMonthly").send(_whmDto);
		}

	    /**
	     * getHolidayWorkTypeList処理の結果イベント
	     * 
	     * @param e ResultEvent
	     */
        public function onResult_getHolidayWorkTypeList(e:ResultEvent):void
        {
        	_holidayWorkTypeList = e.result as ArrayCollection;
        	view.cmbHolidayWork.dataProvider = _holidayWorkTypeList;
		}
			
	    /**
	     * getWorkingHoursMonthly処理の結果イベント
	     * 
	     * @param e ResultEvent
	     */
        public function onResult_getWorkingHoursMonthly(e:ResultEvent):void
        {
        	_whmDto = e.result as WorkingHoursMonthlyDto;

			// 選択された日の勤務管理データ表示        	
        	showWorkingHours(_settingDate);
        }

	    /**
	     * updateWorkingHoursMonthly処理の結果イベント
	     * 
	     * @param e ResultEvent
	     */
        public function onResult_updateWorkingHoursMonthly(e:ResultEvent):void
        {
			// 勤務管理表データの取得
			getWorkingHoursMonthly(_staffId, _settingDate);
		}
			
	    /**
	     * リモートオブジェクト実行の失敗イベント
	     * 
	     * @param e FaultEvent
	     */
        public function onFault_remoteObject(e:FaultEvent):void
        {
		}
			
		/**
		 * validator検証 OK.
		 *
		 * @param e ValidationResultEvent
		 */
		public function onValid_validator(e:ValidationResultEvent):void
		{
			view.btnStartTime.enabled = true;
			view.btnQuiitingTime.enabled = true;
		}

		/**
		 * validator検証 NG.
		 *
		 * @param e ValidationResultEvent
		 */
		public function onInvalid_validator(e:ValidationResultEvent):void
		{
			view.btnStartTime.enabled = false;
			view.btnQuiitingTime.enabled = false;
		}


//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * 勤務管理表の取得処理.
		 * @param staffId		社員ID
		 * @param selectedDate	日付
		 *
		 */
		private function getWorkingHoursMonthly(staffId:int, selectedDate:Date):void
		{
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYYMM";
			var workingMonthCode:String = df.format(selectedDate);
			
			// 勤務時間詳細データの取得
	    	view.srv.getOperation("getWorkingHoursMonthly").send(staffId, workingMonthCode);
		}
		
		/**
		 * 指定された日の勤務管理データ表示.
		 * @param selectedDate	日付
		 *
		 */
		private function showWorkingHours(selectedDate:Date):void
		{
			// 日付移動ボタン有効無効制御
			setlinkDateEnabled();
			
        	// 当日の勤務時間データ取得
        	_whdDto = ObjectUtil.copy(_whmDto.workingHoursDailies.getItemAt(_settingDate.date-1)) as WorkingHoursDailyDto; 

			// ログインユーザの環境設定取得
			var staffSetting:StaffSettingDto = Application.application.indexLogic.loginStaff.staffSetting;

			// 日付の表示
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYY年MM月DD日 (EEE)";
			view.lblWorkingDate.text = df.format(selectedDate);

    		if (_whdDto.holidayName != null) {
    			_whdDto.styleName = "DateHoliday";
       			view.itmHolidayWork.percentHeight = 100;
       			view.itmHolidayWork2.percentHeight = 100;
       			view.itmHolidayWork.visible = true;
       			view.itmHolidayWork2.visible = true;
    		} else {
    			switch(_whdDto.workingDate.day) {
    				case 0:
	        			_whdDto.styleName = "DateSunday";
	        			view.itmHolidayWork.percentHeight = 100;
	        			view.itmHolidayWork2.percentHeight = 100;
	        			view.itmHolidayWork.visible = true;
	        			view.itmHolidayWork2.visible = true;
    					break;
    				case 1:
    				case 2:
    				case 3:
    				case 4:
    				case 5:
	        			_whdDto.styleName = "DateWeekday";
	        			view.itmHolidayWork.height = 0;
	        			view.itmHolidayWork2.height = 0;
	        			view.itmHolidayWork.visible = false;
	        			view.itmHolidayWork2.visible = false;
    					break;
    				case 6:
	        			_whdDto.styleName = "DateSaturday";
	        			view.itmHolidayWork.percentHeight = 100;
	        			view.itmHolidayWork2.percentHeight = 100;
	        			view.itmHolidayWork.visible = true;
	        			view.itmHolidayWork2.visible = true;
    					break;
    			}
    		}

			// 昨日以前ならば
			if (_settingDate < _todayDate) {
				view.hbxHeader.height = 0;
				view.hbxFooter.height = 0;
			} else {
				view.hbxHeader.percentHeight = 100;
				view.hbxFooter.percentHeight = 100;
				var birthday:Date = Application.application.indexLogic.loginStaff.birthday;
				if (birthday != null && birthday.getMonth() == _settingDate.getMonth()
					&& birthday.getDate() == _settingDate.getDate()) {
					view.hbxBirthday.percentHeight = 100;
					view.hbxMorning.height = 0;
				} else {
					view.hbxBirthday.height = 0;
					view.hbxMorning.percentHeight = 100;
				}
			}
			
			// 休日の場合の色替え、ツールチップへの設定
			view.lblWorkingDate.styleName = _whdDto.styleName;
			view.lblWorkingDate.toolTip = _whdDto.holidayName;
			
			var submitted:Boolean = false;
			// 手続き履歴が存在するならば
			if (_whmDto.workingHoursHistories != null
				&& _whmDto.workingHoursHistories.length > 0) {
				var whh:WorkingHoursHistoryDto = _whmDto.workingHoursHistories.getItemAt(0) as WorkingHoursHistoryDto;
				if (whh.workingHoursStatusId != WorkingHoursStatusId.NONE
					&& whh.workingHoursStatusId != WorkingHoursStatusId.ENTERED
					&& whh.workingHoursStatusId != WorkingHoursStatusId.REJECTED) {
						submitted = true;
				}
			}
			
			// 開始時間未設定ならば
			if (_whdDto.startTime == null && !submitted) {
				// 開始時刻入力フォーム表示
				showStartTimeEnterForm(staffSetting, selectedDate);
			// 終了時刻未設定ならば
			} else if (_whdDto.quittingTime == null && !submitted) {				
				// 終了時刻入力フォーム表示
				showQuittingTimeEnterForm(staffSetting, selectedDate, _whdDto);
			} else {
				// 入力完了フォーム表示
				showEnteredForm(staffSetting, selectedDate, _whdDto);
			}
			if (!view.pnlWorkingHours.visible) view.pnlWorkingHours.visible = true;
		}

		/**
		 * 開始時刻入力フォームの表示.
		 *
		 * @param staffSetting	環境設定
		 * @param selectedDate	日付
		 */
		private function showStartTimeEnterForm(staffSetting:StaffSettingDto, selectedDate:Date):void
		{
			view.frmStartTime.percentHeight = 100;
			view.frmQuittingTime.height = 0;
			view.frmEnterdHours.height = 0;
			
			var timeArray:Array;
			var timeArrayCollection:ArrayCollection;

			// 時差勤務開始時刻選択肢作成
			if (staffSetting.staggeredStartTimeChoices != null) {
				timeArray = staffSetting.staggeredStartTimeChoices.split(",");
			} else {
				timeArray = new Array();
			}
			timeArrayCollection = new ArrayCollection(timeArray);
			timeArrayCollection.addItemAt("", 0);
			view.cmbStaggeredStartTime.dataProvider = timeArrayCollection;
			
			view.cmbStaggeredStartTime.data = staffSetting.defaultStaggeredStartTime;
			view.cmbStaggeredStartTime.text = staffSetting.defaultStaggeredStartTime;

			// 開始時刻選択肢作成
			if (staffSetting.startTimeChoices != null) {
				timeArray = staffSetting.startTimeChoices.split(",");
			} else {
				timeArray = new Array();
			}
			timeArrayCollection = new ArrayCollection(timeArray);
			timeArrayCollection.addItemAt("", 0);
			view.cmbStartTime.dataProvider = timeArrayCollection;
			
			// 本日の開始時刻ならば現在時刻をセットする。
			if (selectedDate.getTime() == _todayDate.getTime()) {
		    	var now:Date = new Date();
    			now.minutes = Math.ceil(now.minutes / 15) * 15;
    			var defaultStartTime:String = _timeFormatter.format(now);
				view.cmbStartTime.data = defaultStartTime;
				view.cmbStartTime.text = defaultStartTime;
			} else {
				view.cmbStartTime.data = staffSetting.defaultStartTime;
				view.cmbStartTime.text = staffSetting.defaultStartTime;
			}
		}
		
		/**
		 * 終了時刻入力フォームの表示.
		 *
		 * @param staffSetting	環境設定
		 * @param selectedDate	当日日付
		 * @param whdDto		当日勤務時間
		 */
		private function showQuittingTimeEnterForm(staffSetting:StaffSettingDto,
			selectedDate:Date, whdDto:WorkingHoursDailyDto):void
		{
			view.frmStartTime.height = 0;
			view.frmQuittingTime.percentHeight = 100;
			view.frmEnterdHours.height = 0;
			
			// 時差勤務開始時刻の表示
			view.lblStaggeredStartTime.text = _timeFormatter.format(whdDto.staggeredStartTime);
			// 開始時刻の表示
			view.lblStartTime.text = _timeFormatter.format(whdDto.startTime);
			var timeArray:Array;
			var timeArrayCollection:ArrayCollection;

			// 終了時刻選択肢作成
			if (staffSetting.quittingTimeChoices != null) {
				timeArray = staffSetting.quittingTimeChoices.split(",");
			} else {
				timeArray = new Array();
			}
			timeArrayCollection = new ArrayCollection(timeArray);
			timeArrayCollection.addItemAt("", 0);
			view.cmbQuittingTime.dataProvider = timeArrayCollection;
			
			// 本日の終了時刻ならば現在時刻をセットする。
			if (selectedDate.getTime() == _todayDate.getTime()) {
		    	var now:Date = new Date();
    			now.minutes = Math.floor(now.minutes / 15) * 15;
    			var defaultQuittingTime:String = _timeFormatter.format(now);
				view.cmbQuittingTime.data = defaultQuittingTime;
				view.cmbQuittingTime.text = defaultQuittingTime;
			} else {
				view.cmbQuittingTime.data = staffSetting.defaultQuittingTime;
				view.cmbQuittingTime.text = staffSetting.defaultQuittingTime;
			}
			onFocusOut_cmbQuittingTime(null);
			
			// 私用時間
			view.txtPrivateHours.text = _hoursFormatter.format(whdDto.privateHours);
			// 休憩時間
			view.txtRecessHours.text = _hoursFormatter.format(whdDto.recessHours);
			// 実働時間
			view.lblRealWorkingHours.text = _hoursFormatter.format(whdDto.realWorkingHours);
			// 休日出勤
			for each(var hol:Object in _holidayWorkTypeList) {
				if (whdDto.holidayWorkType == hol.holidayWorkType) {
					view.cmbHolidayWork.selectedItem = hol;
					break;
				}
			}
			// 備考
			view.txtNote.text = whdDto.note;
			
		}
		
		/**
		 * 入力完了フォームの表示.
		 *
		 * @param staffSetting	環境設定
		 * @param selectedDate	当日日付
		 * @param whdDto		当日勤務時間
		 */
		private function showEnteredForm(staffSetting:StaffSettingDto,
			selectedDate:Date, whdDto:WorkingHoursDailyDto):void
		{
			view.frmStartTime.height = 0;
			view.frmQuittingTime.height = 0;
			view.frmEnterdHours.percentHeight = 100;
			
			// 時差勤務開始時刻の表示
			view.lblStaggeredStartTime2.text = _timeFormatter.format(whdDto.staggeredStartTime);
			// 開始時刻の表示
			view.lblStartTime2.text = _timeFormatter.format(whdDto.startTime);
			// 終了時刻
			view.lblQuittingTime.text = _timeFormatter.format(whdDto.quittingTime);
			// 私用時刻
			view.lblPrivateHours.text = _hoursFormatter.format(whdDto.privateHours);
			// 休憩時刻
			view.lblRecessHours.text = _hoursFormatter.format(whdDto.recessHours);
			// 実働時間
			view.lblRealWorkingHours2.text = _hoursFormatter.format(whdDto.realWorkingHours);
			// 休日出勤
			for each(var hol:Object in _holidayWorkTypeList) {
				if (whdDto.holidayWorkType == hol.holidayWorkType) {
					view.lblHolidayWork.text = hol.holidayWorkName;
					break;
				}
			}
			// 備考
			view.lblNote.text = whdDto.note;
			
		}

		/**
		 * 文字列から時刻への変換処理.
		 *
		 * @param date	日付
		 * @param sTime 時刻文字列
		 * @return		時刻データ
		 */
		private function convertStringToTime(date:Date, sTime:String):Date
		{
			var timeValue:Date = null;

			if (StringUtil.trim(sTime).length > 0) {
		    	var sTimeArray:Array = sTime.split(":");
		    	if (sTimeArray.length == 1 || sTimeArray.length == 2) {
		    		var hour:Number = parseInt(sTimeArray[0]);
		    		var minute:Number = 0;
		    		if (sTimeArray.length == 2) {
			    		minute = parseInt(sTimeArray[1]);
		    		}
		    		if (!isNaN(hour) && !isNaN(minute) && hour <= 33 && (minute % 15) == 0) {
		    			hour = hour % 24;
			    		timeValue = new Date(date.fullYear, date.month, date.date, hour, minute, 0, 0);
			    	}
			    }
			}
			return timeValue;
		}

		/**
		 * 前日／翌日リンクボタン有効無効判定処理.
		 *
		 */
		private function setlinkDateEnabled():void
		{
			if (_settingDate.getTime() >= _todayDate.getTime()) {
				view.linkPreviousDate.enabled = true;
				view.linkNextDate.enabled = false;
				view.linkNextDate.setStyle("icon", _icon_next_d);
			} else {
				view.linkPreviousDate.enabled = true;
				view.linkNextDate.enabled = true;
				view.linkNextDate.setStyle("icon", _icon_next);
			}
			
	    }

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:HomePage;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():HomePage
	    {
	        if (_view == null) {
	            _view = super.document as HomePage;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:HomePage):void
	    {
	        _view = view;
	    }
	}
}