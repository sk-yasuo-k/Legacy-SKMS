package subApplications.generalAffair.paidVacationMaintenance.logic
{
	import dto.StaffDto;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.dto.WorkingHoursMonthlyDto;
	import subApplications.generalAffair.paidVacationMaintenance.dto.WorkingHoursMonthlyDtoList;
	import subApplications.generalAffair.paidVacationMaintenance.web.PaidVacationMaintenance;

	/**
	 * 有給・代休メンテナンスロジッククラス
	 * 
	 * @author t-ito
	 */			
	public class PaidVacationMaintenanceLogic extends Logic
	{	
		
		/** 表示中の年 */
		private var _workingYear:int;

		/** 表示中の月 */
		private var _workingMonth:int;

		/** 表示中の年月 */		
		private var workingMonthCode:String;
		
		/** ログインスタッフ */
		private var loginStaff:StaffDto = Application.application.indexLogic.loginStaff;		
		
		/** 勤務管理一覧 */
		[Bindable]
		public var _list:ArrayCollection;	

		// リンクボタンアイコン
        [Embed(source="images/arrow_previous.gif")]
        private var _icon_previous:Class;

        [Embed(source="images/arrow_previous_d.gif")]
        private var _icon_previous_d:Class;

        [Embed(source="images/arrow_next.gif")]
        private var _icon_next:Class;

        [Embed(source="images/arrow_next_d.gif")]
        private var _icon_next_d:Class;

		public function PaidVacationMaintenanceLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
	    	var now:Date = new Date();
	    	view.stpYear.value = now.getFullYear();
	    	view.stpMonth.value = now.getMonth() + 1;
	    	onClick_btnRefresh(null);
	    	onClick_linkHideDateSetting(null);
			
			// PMでないならば
			if (!loginStaff.isProjectPositionPM()) {
				view.chkSubordinateOnly.visible = false;
			}

			// 総務部長ならば
			if (loginStaff.isDepartmentHeadGA()) {
				view.chkSubordinateOnly.selected = false;
			}
			
			BindingUtils.bindProperty(this.view.list, "dataProvider", this, "_list");
		}

		/**
		 * 	表示ボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_btnRefresh(e:MouseEvent):void
		{
			_workingYear = view.stpYear.value;
			_workingMonth = view.stpMonth.value;
			
			setlinkMonthEnabled();			

			// 勤務月コード
        	var df:DateFormatter = new DateFormatter();
        	df.formatString = "YYYYMM";
			workingMonthCode = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
			df.formatString = "YYYY年MM月";
        	view.lblWorkingMonth.text = df.format(new Date(view.stpYear.value, view.stpMonth.value - 1, 1));
        	
        	// データを取得する.
			view.paidVacationMaintenanceService.getOperation("getWorkingStaffNameList").send(loginStaff, workingMonthCode, view.chkSubordinateOnly.selected);
		}

		/**
		 * リンクボタン選択 前月.
		 *
		 */
		public function onClick_linkPreviousMonth(e:MouseEvent):void
		{
			view.stpYear.value = _workingYear;
			view.stpMonth.value = _workingMonth;

			if (view.stpMonth.value == 1) {
				view.stpYear.value--;
				view.stpMonth.value = 12;
			} else {
				view.stpMonth.value--;
			}

			setlinkMonthEnabled();

			_workingYear = view.stpYear.value;
			_workingMonth = view.stpMonth.value;

			onClick_btnRefresh(null);
		}

		/**
		 * リンクボタン選択 翌月.
		 *
		 */
		public function onClick_linkNextMonth(e:MouseEvent):void
		{
			view.stpYear.value = _workingYear;
			view.stpMonth.value = _workingMonth;

			if (view.stpMonth.value == 12) {
				view.stpYear.value++;
				view.stpMonth.value = 1;
			} else {
				view.stpMonth.value++;
			}

			setlinkMonthEnabled();

			_workingYear = view.stpYear.value;
			_workingMonth = view.stpMonth.value;

			onClick_btnRefresh(null);
		}

		/**
		 * リンクボタン選択 年月指定.
		 *
		 */
		public function onClick_linkShowDateSetting(e:MouseEvent):void
		{
			view.vbxShowDateSetting.width = 0;
			view.vbxShowDateSetting.height = 0;
			view.vbxHideDateSetting.percentWidth = 100;
			view.vbxHideDateSetting.percentHeight = 100;
		}

		/**
		 * リンクボタン選択 閉じる.
		 *
		 */
		public function onClick_linkHideDateSetting(e:MouseEvent):void
		{
			view.vbxShowDateSetting.percentWidth = 100;
			view.vbxShowDateSetting.percentHeight = 100;
			view.vbxHideDateSetting.width = 0;
			view.vbxHideDateSetting.height = 0;
		}

		/**
		 * 前月／翌月リンクボタン有効無効判定処理.
		 *
		 */
		private function setlinkMonthEnabled():void
		{
			if (view.stpYear.value == view.stpYear.minimum
				&& view.stpMonth.value == view.stpMonth.minimum) {
				view.linkPreviousMonth.enabled = false;
				view.linkPreviousMonth.setStyle("icon", _icon_previous_d);
			}
			if (view.stpYear.value == view.stpYear.maximum
				&& view.stpMonth.value == view.stpMonth.maximum) {
				view.linkNextMonth.enabled = false;
				view.linkNextMonth.setStyle("icon", _icon_next_d);
			}
			if (view.stpYear.value > view.stpYear.minimum
				|| view.stpMonth.value > view.stpMonth.minimum) {
				view.linkPreviousMonth.enabled = true;
				view.linkPreviousMonth.setStyle("icon", _icon_previous);
			}
			if (view.stpYear.value < view.stpYear.maximum
				|| view.stpMonth.value < view.stpMonth.maximum) {
				view.linkNextMonth.enabled = true;
				view.linkNextMonth.setStyle("icon", _icon_next);
			}
	    }

		/**
		 * 保存ボタン押下処理.
		 *
		 * @param e MouseEvent.
		 */
		public function onClick_storageWorkingHoursMonthly(e:MouseEvent):void
		{
			Alert.show("保存してもよろしいですか？", "", 3, view, storageWorkingHoursMonthly);			
		}

		/**
		 * 保存処理.
		 *
		 * @param e CloseEvent.
		 */
		public function storageWorkingHoursMonthly(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				view.paidVacationMaintenanceService.getOperation("storageWorkingHoursMonthly").send(this._list);
			}			
		}
		
		/**
		 * フォーカスアウト処理.
		 *
		 * @param e Event.
		 */
		public function onFocusOut(e:Event):void
		{
			var changeData:WorkingHoursMonthlyDto = view.list.selectedItem as WorkingHoursMonthlyDto;
			
			changeData.currentPaidVacationCount
				= changeData.lastPaidVacationCount - changeData.lostPaidVacationCount + changeData.givenPaidVacationCount - changeData.takenPaidVacationCount;
			changeData.currentCompensatoryDayOffCount
				= changeData.lastCompensatoryDayOffCount - changeData.lostCompensatoryDayOffCount + changeData.givenCompensatoryDayOffCount - changeData.takenCompensatoryDayOffCount;
			
			view.list.selectedItem = changeData;
		}

		/**
		 * onResult_getWorkingStaffNameListの呼び出し結果.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getWorkingStaffNameList(e:ResultEvent):void
		{
			// 結果を設定する.
			trace("onResult_getWorkingStaffNameList...");
			var workingHoursMonthlyDtoList:WorkingHoursMonthlyDtoList = new WorkingHoursMonthlyDtoList(e.result);
			this._list = workingHoursMonthlyDtoList.workingHoursMonthlyList;
			this._list.refresh();
		}

		/**
		 * getWorkingHoursMonthlyListの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getWorkingStaffNameList(e:FaultEvent):void
		{
			trace("onFault_getWorkingStaffNameList...");
			trace(e.message);			
			Alert.show("勤務管理集計データ取得に失敗しました。","",Alert.OK,null);
		}

		/**
		 * onResult_storageWorkingHoursMonthlyの呼び出し結果.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_storageWorkingHoursMonthly(e:ResultEvent):void
		{
			// 結果を設定する.
			trace("onResult_storageWorkingHoursMonthly...");
			
        	// データを取得する.
			view.paidVacationMaintenanceService.getOperation("getWorkingStaffNameList").send(loginStaff, workingMonthCode, view.chkSubordinateOnly.selected);
		}

		/**
		 * storageWorkingHoursMonthlyの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_storageWorkingHoursMonthly(e:FaultEvent):void
		{
			trace("onFault_storageWorkingHoursMonthly...");
			trace(e.message);			
			Alert.show("勤務管理集計データ取得に失敗しました。","",Alert.OK,null);
		}
		
		/** 画面 */
	    public var _view:PaidVacationMaintenance;

	    /**
	     * 画面を取得します
	     */
	    public function get view():PaidVacationMaintenance
	    {
	        if (_view == null) {
	            _view = super.document as PaidVacationMaintenance;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:PaidVacationMaintenance):void
	    {
	        _view = view;
	    }

	}
}