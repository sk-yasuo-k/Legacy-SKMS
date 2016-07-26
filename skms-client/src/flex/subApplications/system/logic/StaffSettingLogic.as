package subApplications.system.logic
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.system.dto.StaffSettingDto;
	import subApplications.system.web.StaffSetting;
	

	/**
	 * StaffSettingのLogicクラスです.
	 */
	public class StaffSettingLogic extends Logic
	{
		// 環境設定
		private var _staffSetting:StaffSettingDto;

		// 勤務時刻
		private var _staggeredStartTimeList:Array;
		private var _startTimeList:Array;
		private var _quittingTimeList:Array;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function StaffSettingLogic()
		{
			super();
		}

//--------------------------------------
//  Initialization
//--------------------------------------
		/**
		 * onCreationCompleteHandler
		 *
		 * @param e FlexEvent
		 */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
	    }

		/**
		 * onCreationComplete_tabWorkingHours
		 *
		 * @param e FlexEvent
		 */
	    public function onCreationComplete_tabWorkingHours(e:FlexEvent):void
		{
			// 環境設定
			var staffSetting:StaffSettingDto;
		
			_staggeredStartTimeList = new Array();
			_startTimeList = new Array();
			_quittingTimeList = new Array();

			// 環境設定データ取得
			staffSetting = Application.application.indexLogic.loginStaff.staffSetting;

			// 勤務管理表関連イベント発生時にメールで通知するか否か
			view.cbxSendMailWorkingHours.selected
				= staffSetting.sendMailWorkingHours;

			var df:DateFormatter = new DateFormatter();
			df.formatString = "JJ:NN";
			var millisecondsPer15Minute:int = 1000 * 60 * 15;

			// 時刻選択肢の生成
			var time:Date = new Date();
			time.setHours(7,0,0,0);
			var timeChoices:Array = new Array();
			for (var i:int = 0; i < 24 * 4; i++) {
				var timeChoice:Object = new Object();
				timeChoice.label = df.format(time);
				timeChoices.push(timeChoice);
				time.setTime(time.getTime() + millisecondsPer15Minute);
			}
			view.listTimeChoices.dataProvider = timeChoices;

			// 時差勤務開始時刻選択肢
			var defaultIndex:int = -1;
			var idx:int = 0;
			if (staffSetting.staggeredStartTimeChoices != null) {
				for each (var staggeredStartTime:String in staffSetting.staggeredStartTimeChoices.split(",")) {
					var staggeredStartTimeChoice:Object = new Object();
					staggeredStartTimeChoice.label = staggeredStartTime;
					_staggeredStartTimeList.push(staggeredStartTimeChoice);
					if (staffSetting.defaultStaggeredStartTime != null
						&& staffSetting.defaultStaggeredStartTime == staggeredStartTime) {
							defaultIndex = idx;
					}
					idx++;
				}
			}
			view.listStaggeredStartTime.dataProvider = _staggeredStartTimeList;
			view.cmbDefaultStaggeredStartTime.dataProvider = view.listStaggeredStartTime.dataProvider;

			if (defaultIndex >= 0) {
				view.chkDefaultStaggeredStartTime.selected = true;
				view.cmbDefaultStaggeredStartTime.enabled = true;
				view.cmbDefaultStaggeredStartTime.selectedIndex = defaultIndex;
			} else {
				view.chkDefaultStaggeredStartTime.selected = false;
				view.cmbDefaultStaggeredStartTime.enabled = false;
				view.cmbDefaultStaggeredStartTime.selectedIndex = 0;
			}
			
			// 勤務開始時刻選択肢
			defaultIndex = -1;
			idx = 0;
			if (staffSetting.startTimeChoices != null) {
				for each (var startTime:String in staffSetting.startTimeChoices.split(",")) {
					var startTimeChoice:Object = new Object();
					startTimeChoice.label = startTime;
					_startTimeList.push(startTimeChoice);
					if (staffSetting.defaultStartTime != null
						&& staffSetting.defaultStartTime == startTime) {
							defaultIndex = idx;
					}
					idx++;
				}
			}
			view.listStartTime.dataProvider = _startTimeList;
			view.cmbDefaultStartTime.dataProvider = view.listStartTime.dataProvider;
			if (defaultIndex >= 0) {
				view.chkDefaultStartTime.selected = true;
				view.cmbDefaultStartTime.enabled = true;
				view.cmbDefaultStartTime.selectedIndex = defaultIndex;
			} else {
				view.chkDefaultStartTime.selected = false;
				view.cmbDefaultStartTime.enabled = false;
				view.cmbDefaultStartTime.selectedIndex = 0;
			}
			
			// 勤務開始時刻選択肢
			defaultIndex = -1;
			idx = 0;
			if (staffSetting.quittingTimeChoices != null) {
				for each (var quittingTime:String in staffSetting.quittingTimeChoices.split(",")) {
					var quittingTimeChoice:Object = new Object();
					quittingTimeChoice.label = quittingTime;
					_quittingTimeList.push(quittingTimeChoice);
					if (staffSetting.defaultQuittingTime != null
						&& staffSetting.defaultQuittingTime == quittingTime) {
							defaultIndex = idx;
					}
					idx++;
				}
			}
			view.listQuittingTime.dataProvider = _quittingTimeList;
			view.cmbDefaultQuittingTime.dataProvider = view.listQuittingTime.dataProvider;
			if (defaultIndex >= 0) {
				view.chkDefaultQuittingTime.selected = true;
				view.cmbDefaultQuittingTime.enabled = true;
				view.cmbDefaultQuittingTime.selectedIndex = defaultIndex;
			} else {
				view.chkDefaultQuittingTime.selected = false;
				view.cmbDefaultQuittingTime.enabled = false;
				view.cmbDefaultQuittingTime.selectedIndex = 0;
			}
	    }

		/**
		 * onCreationComplete_tabTransportation
		 *
		 * @param e FlexEvent
		 */
	    public function onCreationComplete_tabTransportation(e:FlexEvent):void
		{
			// 交通費関連イベント発生時にメールで通知するか否か
			view.cbxSendMailTransportation.selected
				= Application.application.indexLogic.loginStaff.staffSetting.sendMailTransportation;
	    }

		/**
		 * onCreationComplete_tabMenu
		 *
		 * @param e FlexEvent
		 */
	    public function onCreationComplete_tabMenu(e:FlexEvent):void
		{
			// 環境設定情報を取得する。
			var staffSetting:StaffSettingDto = Application.application.indexLogic.loginStaff.staffSetting;
			view.cbxAllMenu.selected = staffSetting.allMenu;
			view.cbxMyMenu.selected  = staffSetting.myMenu;
			
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 交通費関連メール通知有無洗濯変更時イベント.
		 *
		 * @param e Event
		 */
		public function onChange_cbxSendMailTransportation(e:Event):void
		{
			// データ変更時の処理
			setModifiedStatus(true);
		}

		/**
		 * メニュー関連全メニュー表示変更時イベント.
		 *
		 * @param e Event
		 */
		public function onChange_cbxAllMenu(e:Event):void
		{
			// データ変更時の処理
			setModifiedStatus(true);
		}

		/**
		 * メニュー関連マイメニュー表示変更時イベント.
		 *
		 * @param e Event
		 */
		public function onChange_cbxMyMenu(e:Event):void
		{
			// データ変更時の処理
			setModifiedStatus(true);
		}
		
		/**
		 * 時刻選択肢 DragEnter イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_listTimeChoices(e:DragEvent):void
		{
			// 自分自身からの Drag は無効とする。
			if (e.dragInitiator == view.listTimeChoices) {
				e.preventDefault();
			}
		}

		/**
		 * 時刻選択肢 DragDrop イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragDrop_listTimeChoices(e:DragEvent):void
		{
			// 無効化する。
			e.dragSource = new DragSource();
			// データ変更時の処理
			setModifiedStatus(true);
		}

		/**
		 * 時差勤務開始時刻 DragEnter イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_listStaggeredStartTime(e:DragEvent):void
		{
			// DragEnterイベント発生時の共通処理を呼び出す。
			onDragEnter_listWorkingTime(e, e.dragInitiator, view.listStaggeredStartTime);			
		}

		/**
		 * 勤務開始時刻 DragEnter イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_listStartTime(e:DragEvent):void
		{
			// DragEnterイベント発生時の共通処理を呼び出す。
			onDragEnter_listWorkingTime(e, e.dragInitiator, view.listStartTime);			
		}

		/**
		 * 勤務終了時刻 DragEnter イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_listQuittingTime(e:DragEvent):void
		{
			// DragEnterイベント発生時の共通処理を呼び出す。
			onDragEnter_listWorkingTime(e, e.dragInitiator, view.listQuittingTime);			
		}

		/**
		 * 勤務時刻 DragOver イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragOver_listWorkingTime(e:DragEvent):void
		{
			// コピーのときは イベントをキャンセルする.
			if (e.ctrlKey)
				e.preventDefault();
		}

		/**
		 * 勤務時刻 DragDrop イベント.
		 *
		 * @param e ListEvent
		 */
		public function onDragDrop_listWorkingTime(e:Event):void
		{
			// データ変更時の処理
			setModifiedStatus(true);
		}

		/**
		 * 勤務時刻 Change イベント.
		 *
		 * @param e ListEvent
		 */
		public function onChange_defaultWorkingTime(e:Event):void
		{
			// 勤務時刻の初期値コンボボックスの有効/無効の切り替え
			view.cmbDefaultStaggeredStartTime.enabled = view.chkDefaultStaggeredStartTime.selected;
			view.cmbDefaultStartTime.enabled = view.chkDefaultStartTime.selected;
			view.cmbDefaultQuittingTime.enabled = view.chkDefaultQuittingTime.selected;
			// データ変更時の処理
			setModifiedStatus(true);
		}

		/**
		 * 適用ボタン押下時イベント.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_btnOk(e:MouseEvent):void
		{
			_staffSetting = Application.application.indexLogic.loginStaff.staffSetting;
			
			if (view.cbxSendMailTransportation != null) {
				// 交通費関連メール受け取り
				_staffSetting.sendMailTransportation = view.cbxSendMailTransportation.selected;
			}

			if (view.cbxSendMailWorkingHours != null) {
				// 勤務管理表関連メール受け取り
				_staffSetting.sendMailWorkingHours = view.cbxSendMailWorkingHours.selected;
			}

			// 時差勤務開始時刻既定値
			var obj:Object;
			obj = view.cmbDefaultStaggeredStartTime.selectedItem;
			if (obj != null && view.chkDefaultStaggeredStartTime.selected) {
				_staffSetting.defaultStaggeredStartTime = obj.label;
				
			} else {
				_staffSetting.defaultStaggeredStartTime = null;
			}

			// 勤務開始時刻既定値
			obj = view.cmbDefaultStartTime.selectedItem;
			if (obj != null && view.chkDefaultStartTime.selected) {
				_staffSetting.defaultStartTime = obj.label;
				
			} else {
				_staffSetting.defaultStartTime = null;
			}

			// 勤務終了時刻既定値
			obj = view.cmbDefaultQuittingTime.selectedItem;
			if (obj != null && view.chkDefaultQuittingTime.selected) {
				_staffSetting.defaultQuittingTime = obj.label;
				
			} else {
				_staffSetting.defaultQuittingTime = null;
			}

			if (view.listTimeChoices != null) {
				// 時差勤務開始時刻選択肢
				_staffSetting.staggeredStartTimeChoices = null;
				for each (var staggeredStartTime:Object in view.listStaggeredStartTime.dataProvider) {
					if (_staffSetting.staggeredStartTimeChoices != null) {
						_staffSetting.staggeredStartTimeChoices += ",";
					} else {
						_staffSetting.staggeredStartTimeChoices = "";
					}
					_staffSetting.staggeredStartTimeChoices += staggeredStartTime.label;
				}
				
				// 勤務開始時刻選択肢
				_staffSetting.startTimeChoices = null;
				for each (var startTime:Object in view.listStartTime.dataProvider) {
					if (_staffSetting.startTimeChoices != null) {
						_staffSetting.startTimeChoices += ",";
					} else {
						_staffSetting.startTimeChoices = "";
					}
					_staffSetting.startTimeChoices += startTime.label;
				}
				
				// 勤務終了時刻選択肢
				_staffSetting.quittingTimeChoices = null;
				for each (var quittingTime:Object in view.listQuittingTime.dataProvider) {
					if (_staffSetting.quittingTimeChoices != null) {
						_staffSetting.quittingTimeChoices += ",";
					} else {
						_staffSetting.quittingTimeChoices = "";
					}
					_staffSetting.quittingTimeChoices += quittingTime.label;
				}
			}
			
			// メール表示設定
			if (view.cbxAllMenu != null) {
				_staffSetting.allMenu = view.cbxAllMenu.selected;
			}
			if (view.cbxMyMenu != null) {
				_staffSetting.myMenu = view.cbxMyMenu.selected;;
			}
			
			// 環境設定の更新
			view.srv.getOperation("updateStaffSetting").send(_staffSetting);
		}

		/**
		 * キャンセルボタン押下時イベント.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_btnCancel(e:MouseEvent):void
		{
			// 各設定値の初期化
			this.initializeSetting();
			// データ変更キャンセル時の処理
			setModifiedStatus(false);
		}

		/**
		 * updateStaffSetting処理の結果イベント.
		 *
		 * @param e ResultEvent
		 */
		public function onResult_updateStaffSetting(e:ResultEvent):void
		{
			// ログイン情報の環境設定に反映させる.
			Application.application.indexLogic.loginStaff.staffSetting
			 = _staffSetting;
			// データ変更完了時の処理
			setModifiedStatus(false);
		}

		/**
		 * updateStaffSettingの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_updateStaffSetting(e:FaultEvent):void
		{
       		Alert.show("環境設定の更新に失敗しました。");
		}


//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * 設定値の初期化.
		 *
		 */
		private function initializeSetting():void
		{
			if (view.listTimeChoices != null) {
				onCreationComplete_tabWorkingHours(null);
			}
			if (view.cbxSendMailTransportation != null) {
				onCreationComplete_tabTransportation(null);
			}
			if (view.cbxMyMenu != null && view.cbxAllMenu != null) {
				onCreationComplete_tabMenu(null);
			}
		}
		
		/**
		 * 勤務時刻リストに対する DragEnter イベント発生時の共通処理.
		 *
		 * @param e DragEvent
		 * @param src DragSource
		 * @param dst DropTarget
		 */
		private function onDragEnter_listWorkingTime(e:DragEvent, src:Object, dst:List):void
		{
			if (src == view.listTimeChoices) {
				var dragSource:DragSource = e.dragSource;
				var selectedTimes:Array = dragSource.dataForFormat("items") as Array;
				var timeList:ArrayCollection = dst.dataProvider as ArrayCollection;
				if (timeList != null) {
					for each (var time:Object in selectedTimes) {
						for each (var time2:Object in timeList) {
							if (time2.label == time.label) {
								e.preventDefault();
								return;
							}
						}
					}
				}
			} else if (src != dst) {
				e.preventDefault();
			} else if (e.ctrlKey) {
				e.preventDefault();
			}
		}

		/**
		 * データ変更状態設定.
		 *
		 */
		private function setModifiedStatus(modified:Boolean):void
		{
			// 「変更を適用する」ボタン、「変更を元に戻す」ボタンの有効状態セット
			view.btnOk.enabled = modified;
			view.btnCancel.enabled = modified;
			// データ変更有無のセット
			Application.application.indexLogic.modified = modified;
		}
		
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:StaffSetting;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():StaffSetting
	    {
	        if (_view == null) {
	            _view = super.document as StaffSetting;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:StaffSetting):void
	    {
	        _view = view;
	    }
	}
}