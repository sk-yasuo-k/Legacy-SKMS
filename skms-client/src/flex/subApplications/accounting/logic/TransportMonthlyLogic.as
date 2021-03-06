package subApplications.accounting.logic
{
	import components.PopUpWindow;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationMonthlySearchDto;
	import subApplications.accounting.web.TransportMonthly;
	import subApplications.accounting.web.TransportMonthlyDetail;

	import utils.TermDateUtil;

	/**
	 * TransportTotalのLogicクラスです.
	 */
	public class TransportMonthlyLogic extends AccountingLogic
	{
		/** 集計期間の定義 */
		[Bindable]
		public static var RANGE_MONTH:int = 1;							// 集計期間日付
		[Bindable]
		public static var RANGE_TERM:int  = 2;							// 集計期間xx期.

		/** 集計基準定義 */
		[Bindable]
		public static var BASE_OCCUR_DATE:int   = 1;					// 発生日で集計.
		[Bindable]
		public static var BASE_PAY_DATE:int     = 2;					// 支払日で集計.


		/** 状態リスト */
		private var _statusList:ArrayCollection;

		/** 検索条件 */
		private var _search:TransportationMonthlySearchDto;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function TransportMonthlyLogic()
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
			// 初期値を設定する.
			view.btnSearch.enabled    = false;
			view.searchOpt.enabled    = false;
			view.dgMonthly.visible    = false;
			view.boxDg.visible        = false;
			view.lbMonthlyGrp.enabled = false;
			view.rdMonthlyGrp.enabled = false;

			// 集計期間を設定する.
			view.startDate.selectedDate  = TermDateUtil.getStartDateCurrent();
			view.finishDate.selectedDate = new Date();
			view.term.text = TermDateUtil.convertTerm(new Date());

			// 状態を取得する.
			requestStatusList();

			// 集計リストは状態取得後に取得する.
	    }


//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 集計期間選択.
		 *
		 * @param e Event.
		 */
		 public function onChange_rdRangeGrp(e:Event):void
		 {
		 	// 集計実行チェックを行なう.
		 	var ret:Boolean = checkReauestOpt();
		 	view.btnSearch.enabled = ret;
		 }


		/**
		 * 集計期間 DateFieldフォーカスアウト.
		 *
		 * @param e CalendarLayoutChangeEvent.
		 */
		public function onChange_dateField(e:CalendarLayoutChangeEvent):void
		{
		 	// 集計実行チェックを行なう.
		 	var ret:Boolean = checkReauestOpt();
		 	view.btnSearch.enabled = ret;
		}


//		/**
//		 * 集計期間 DateFieldフォーカスアウト.
//		 *
//		 * @param e FocusEvent.
//		 */
//		public function onFocusOut_dateField(e:FocusEvent):void
//		{
//			// 入力データのチェックを行なう.
//			// →parseFunction はキー入力毎に呼ばれるため focusOut したときに入力チェックする.
//			// →change は selectedDate が変化したタイミングで呼ばれるため null → 2009/13/01 は呼ばれない.
//			var target:DateField = e.currentTarget as DateField;
//			// フォーマット変換できるかチェックする.
//			var date:Date = DateField.stringToDate(target.text, target.formatString);
//			if (!date)			target.text = "";
//
//		 	// 集計実行チェックを行なう.
//		 	var ret:Boolean = checkReauestOpt();
//		 	view.btnSearch.enabled = ret;
//		}

		/**
		 * 集計期間 xx期フォーカスアウト.
		 *
		 * @param e FocusEvent.
		 */
		public function onFocusOut_term(e:FocusEvent):void
		{
		 	// 集計実行チェックを行なう.
		 	var ret:Boolean = checkReauestOpt();
		 	view.btnSearch.enabled = ret;
		}


		/**
		 * 集計ボタン押下.
		 *
		 * @param e MouseEvent.
		 */
		public function onButtonClick_btnSearch(e:MouseEvent):void
		{
			// 集計リストを問い合わせる.
			requestMonthlyList();
		}

		/**
		 * 詳細ボタン押下.
		 *
		 * @param e MouseEvent.
		 */
		public function onButtonClick_btnDetail(e:MouseEvent):void
		{
			// 集計リストを問い合わせる.
			requestMonthlyDetailList();
		}

		/**
		 * 選択セルの詳細集計データの表示.
		 *
		 * @param e Event.
		 */
		public function onDetailShow_dgMonthly(e:Event):void
		{
			// 集計リストを問い合わせる.
			requestMonthlyDetailList();
		}


		/**
		 * 選択セルの変更.
		 *
		 * @param e Event.
		 */
		public function onChangeCell_dgMonthly(e:Event):void
		{
			// 選択セルを取得する.
			var object:Object = view.dgMonthly.selectedCell;
			if (object) {
				view.cnvDetail.visible = true;
				view.detailTarget.text = object.objectName + "　"+ object.dateDetail;
			}
			else {
				view.cnvDetail.visible = false;
			}
		}


		/**
		 * 集計詳細表示P.U.クローズ.
		 *
		 * @param e CloseEvent
		 */
		public function onClose_transportMonthlyDetail(e:CloseEvent):void
		{
			;
		}

		/**
		 * getTransportationMonthlyListの呼び出し結果.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getTransportationMonthlyList(e:ResultEvent):void
		{
			// 結果を設定する.
			view.dgMonthly.startDate   = getRequestOpt_startDate();
			view.dgMonthly.finishDate  = getRequestOpt_finishDate();
			view.dgMonthly.projectMonthly = view.chkProjectMonthly.selected;
			view.dgMonthly.monthlyData = e.result as ArrayCollection;

			// 集計を可能にする.
			view.btnSearch.enabled    = true;
			view.searchOpt.enabled    = true;
			view.dgMonthly.visible    = true;
			view.boxDg.visible        = true;
			view.lbMonthlyGrp.enabled = true;
			view.rdMonthlyGrp.enabled = true;
			view.btnDetail.enabled    = true;
			view.detailTarget.enabled = true;
		}

		/**
		 * getTransportationMonthlyDetailListの呼び出し結果.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getTransportationMonthlyDetailList(e:ResultEvent):void
		{
			// 集計を可能にする.
			view.btnSearch.enabled    = true;
			view.searchOpt.enabled    = true;
			view.lbMonthlyGrp.enabled = true;
			view.rdMonthlyGrp.enabled = true;
			view.boxDg.enabled        = true;
			view.btnDetail.enabled    = true;
			view.detailTarget.enabled = true;

			// 詳細集計画面を表示する.
			var data:Object = new Object();
			data.monthlyData = e.result as ArrayCollection;
			data.search      = _search;
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(TransportMonthlyDetail, view.parentApplication as DisplayObject, data);
			pop.addEventListener(CloseEvent.CLOSE, onClose_transportMonthlyDetail);
		}

		/**
		 * getTransportationMonthlyStatusListの呼び出し結果.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getTransportationMonthlyStatusList(e:ResultEvent):void
		{
			// 状態を設定する.
			_statusList = e.result as ArrayCollection;
			view.rpStatusList.dataProvider = _statusList;

			// 集計リストを問い合わせる.
			// (検索条件は初期として設定済みのため、入力チェックはしない).
			requestMonthlyList();
		}


		/**
		 * getTransportationMonthlyListの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getTransportationMonthlyList(e:FaultEvent):void
		{
			super.onFault_getXxxxx(e, true, "交通費集計データ");
		}

		/**
		 * getTransportationMonthlyDetailListの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getTransportationMonthlyDetailList(e:FaultEvent):void
		{
			super.onFault_getXxxxx(e, true, "交通費集計詳細データ");
		}

		/**
		 * getTransportationMonthlyStatusListの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getTransportationMonthlyStatusList(e:FaultEvent):void
		{
			super.onFault_getXxxxx(e, true, "交通費状態");
		}

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 集計表の集計開始日付取得.
		 *
		 * @return date 開始日付.
		 */
		private function getRequestOpt_startDate():Date
		{
			if (ObjectUtil.compare(view.rdRangeGrp.selectedValue, RANGE_MONTH) == 0) {
				// 未設定の時は 1期 の日時を設定する.
				var date:Date = view.startDate.selectedDate;
				if (date)		return date;
				return TermDateUtil.convertStartDate("1");
			}
			else {
				return TermDateUtil.convertStartDate(view.term.text);
			}
		}

		/**
		 * 集計表の集計終了日付取得.
		 *
		 * @return date 終了日付.
		 */
		private function getRequestOpt_finishDate():Date
		{
			if (ObjectUtil.compare(view.rdRangeGrp.selectedValue, RANGE_MONTH) == 0) {
				// 未設定の時は 現在日時を設定する.
				var date:Date = view.finishDate.selectedDate;
				if (date)		return date;
				return new Date();
			}
			else {
				return TermDateUtil.convertFinishDate(view.term.text);
			}
		}


		/**
		 * 集計条件入力チェック.
		 *
		 * @return チェック結果.
		 */
		private function checkReauestOpt():Boolean
		{
		 	var ret:Boolean = false;
		 	// 集計期間指定のとき.
		 	if (ObjectUtil.compare(view.rdRangeGrp.selectedValue, RANGE_MONTH) == 0) {
		 		ret = checkReauestOpt_dateField(true);
		 		checkReauestOpt_term(false);
		 	}
		 	// xx期指定のとき.
		 	else {
		 		checkReauestOpt_dateField(false);
		 		ret = checkReauestOpt_term(true);
		 	}
		 	return ret;
		}

		/**
		 * 集計条件入力チェック 集計期間DateField.
		 *
		 * @param error エラーチェック.
		 */
		private function checkReauestOpt_dateField(error:Boolean = true):Boolean
		{
			view.startDate.errorString = "";
			view.finishDate.errorString = "";

			if (error) {
				if (!view.startDate.selectedDate && !view.finishDate.selectedDate) {
					view.startDate.errorString  = "開始あるいは終了日時を入力してください。";
					view.finishDate.errorString = "開始あるいは終了日時を入力してください。";
					return false;
				}
			}
			return true;
		}

		/**
		 * 集計条件入力チェック 集計期間xx期.
		 *
		 * @param error エラーチェック.
		 */
		private function checkReauestOpt_term(error:Boolean = true):Boolean
		{
			view.term.errorString = "";

			if (error) {
				if (!view.term.text) {
					view.term.errorString = "期を入力してください。";
					return false;
				}
				if (int(view.term.text) == 0) {
					view.term.errorString = "1期以降の期を入力してください。";
					return false;
				}
			}
			return true;
		}


		/**
		 * 集計リストの問い合わせ.
		 *
		 */
		private function requestMonthlyList():void
		{
			// データ取得中かどうか確認する.
			var cursorID:int = CursorManager.getInstance().currentCursorID;
			if (ObjectUtil.compare(cursorID, CursorManager.NO_CURSOR) != 0) {
				return;
			}

			// 集計を無効にする.
			view.btnSearch.enabled    = false;
			view.searchOpt.enabled    = false;
			view.dgMonthly.visible    = false;
			view.boxDg.visible        = false;
			view.lbMonthlyGrp.enabled = false;
			view.rdMonthlyGrp.enabled = false;
			view.btnDetail.enabled    = false;
			view.detailTarget.enabled = false;

			// 検索条件を取得する.
			_search = new TransportationMonthlySearchDto();
			// 集計期間.
			_search.startDate  = getRequestOpt_startDate();
			_search.finishDate = getRequestOpt_finishDate();
			// 状態.
			_search.statusList = new ArrayCollection();
			_search.statusList.addItem(-99);
			for each (var chkStsItem:CheckBox in view.chkStatus as Array) {
				if (chkStsItem.selected)	_search.statusList.addItem(int(chkStsItem.selectedField));
			}
			// 集計基準
			_search.baseDateType = view.rdBaseDateGrp.selectedValue as int;
			_search.isProjectMonthly = view.chkProjectMonthly.selected;

			// データを取得する.
			 view.srv.getOperation("getTransportationMonthlyList").send(Application.application.indexLogic.loginStaff, _search);
		}

		/**
		 * 詳細集計リストの問い合わせ.
		 *
		 */
		private function requestMonthlyDetailList():void
		{
			// データ取得中かどうか確認する.
			var cursorID:int = CursorManager.getInstance().currentCursorID;
			if (ObjectUtil.compare(cursorID, CursorManager.NO_CURSOR) != 0) {
				return;
			}

			// 集計を無効にする.
			view.btnSearch.enabled    = false;
			view.searchOpt.enabled    = false;
			view.lbMonthlyGrp.enabled = false;
			view.rdMonthlyGrp.enabled = false;
			view.boxDg.enabled        = false;
			view.btnDetail.enabled    = false;
			view.detailTarget.enabled = false;

			// 検索条件を追加する.
			var object:Object = view.dgMonthly.selectedCell;
			_search.objectId   = object.objectId;
			_search.objectType = object.objectType;
			_search.objectCode = object.objectCode;
			_search.objectName = object.objectName;
			_search.objectStartDate  = object.objectStartDate;
			_search.objectFinishDate = object.objectFinishDate;

			// データを取得する.
			 view.srv.getOperation("getTransportationMonthlyDetailList").send(Application.application.indexLogic.loginStaff, _search);
		}

		/**
		 * 申請状態の問い合わせ.
		 *
		 */
		private function requestStatusList():void
		{
			view.srv.getOperation("getTransportationMonthlyStatusList").send();
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:TransportMonthly;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():TransportMonthly
	    {
	        if (_view == null) {
	            _view = super.document as TransportMonthly;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:TransportMonthly):void
	    {
	        _view = view;
	    }
	}
}