package subApplications.generalAffair.logic
{
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	import subApplications.generalAffair.dto.StaffWorkingHoursSearchDto;
	import subApplications.generalAffair.web.WorkingHoursMonthly;

	import utils.TermDateUtil;


	/**
	 * WorkingHoursAnalizeのLogicクラスです。
	 */
	public class WorkingHoursMonthlyLogic extends Logic
	{
		/** 集計期間の定義 */
		[Bindable]
		public static var RANGE_MONTH:int = 1;							// 集計期間日付
		[Bindable]
		public static var RANGE_TERM:int  = 2;							// 集計期間xx期.

		/** 集計項目定義 */
		[Bindable]
		public static var CONT_WORK_HOUR:int      = 1;					// 勤務時間.
		[Bindable]
		public static var CONT_REAL_WORK_HOUR:int = 2;					// 実働時間.

		/** 集計タイプ定義 */
		[Bindable]
		public static var TYPE_MONTHLY:int      = 1;					// 月別.
		[Bindable]
		public static var TYPE_TERM:int         = 2;					// 期別.
		[Bindable]
		public static var TYPE_TERM_6MONTHS:int = 3;					// 上期下期.

		/** 集計対象者定義 */
		[Bindable]
		public static var TARGET_NAME:int      = 1;						// 個人.
		[Bindable]
		public static var TARGET_TERM:int      = 2;						// xx期入社.


		/** 社員リスト */
		private var _staffList:ArrayCollection;


//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function WorkingHoursMonthlyLogic()
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
			view.rdContentGrp.enabled = false;
			view.rdMonthlyGrp.enabled = false;

			// 集計期間を設定する.
			view.startDate.selectedDate  = TermDateUtil.getStartDateCurrent();
			view.finishDate.selectedDate = new Date();
			view.term.text = TermDateUtil.convertTerm(new Date());

			// 集計リストを取得する.
			requestMonthlyList();
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
		 * 集計期間選択（DateField）.
		 *
		 * @param e CalendarLayoutChangeEvent.
		 */
		public function onChange_dateField(e:CalendarLayoutChangeEvent):void
		{
		 	// 集計実行チェックを行なう.
		 	var ret:Boolean = checkReauestOpt();
		 	view.btnSearch.enabled = ret;
		}


		/**
		 * 集計期間 DateFieldフォーカスアウト.
		 *
		 * @param e FocusEvent.
		 */
		public function onFocusOut_dateField(e:FocusEvent):void
		{
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
		}

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
			// 集計リストが問い合わせる.
			requestMonthlyList();
		}


		/**
		 * getWorkingHoursMonthlyListの呼び出し結果.
		 *
		 * @param e ResultEvent.
		 */
		public function onResult_getWorkingHoursMonthlyList(e:ResultEvent):void
		{
			// 結果を設定する.
			view.dgMonthly.startDate   = getRequestOpt_startDate();
			view.dgMonthly.finishDate  = getRequestOpt_finishDate();
			view.dgMonthly.monthlyData = e.result as ArrayCollection;

			// 集計を可能にする.
			view.btnSearch.enabled    = true;
			view.searchOpt.enabled    = true;
			view.dgMonthly.visible    = true;
			view.boxDg.visible        = true;
			view.rdContentGrp.enabled = true;
			view.rdMonthlyGrp.enabled = true;
		}


		/**
		 * getWorkingHoursMonthlyListの呼び出し失敗.
		 *
		 * @param e FaultEvent.
		 */
		public function onFault_getWorkingHoursMonthlyList(e:FaultEvent):void
		{
			Alert.show("勤務管理集計データ取得に失敗しました。","",Alert.OK,null);
		}

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 集計リストの問い合わせ.
		 *
		 */
		private function requestMonthlyList():void
		{
			// 集計を無効にする.
			view.btnSearch.enabled    = false;
			view.searchOpt.enabled    = false;
			view.dgMonthly.visible    = false;
			view.boxDg.visible        = false;
			view.rdContentGrp.enabled = false;
			view.rdMonthlyGrp.enabled = false;

			// 検索条件を取得する.
			var search:StaffWorkingHoursSearchDto = new StaffWorkingHoursSearchDto();
			// 集計期間.
			search.startDate   = getRequestOpt_startDate();
			search.finishtDate = getRequestOpt_finishDate();
			// 氏名.
			search.staffName   = getRequestOpt_staffName();
			// プロジェクト.
			search.projectCode = getRequestOpt_projectCode();
			search.projectName = getRequestOpt_projectName();

			// データを取得する.
			 view.srv.getOperation("getWorkingHoursMonthlyList").send(Application.application.indexLogic.loginStaff, search);
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
		 * 集計開始日付取得.
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
		 * 集計終了日付取得.
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
		 * 集計氏名取得.
		 *
		 * @return String 氏名.
		 */
		private function getRequestOpt_staffName():String
		{
			var opt:String = view.staffName.text;
			if (opt && StringUtil.trim(opt).length > 0)		return opt;
			return null;
		}

		/**
		 * 集計プロジェクトコード取得.
		 *
		 * @return String プロジェクトコード.
		 */
		private function getRequestOpt_projectCode():String
		{
			var opt:String = view.projectCode.text;
			if (opt && StringUtil.trim(opt).length > 0)		return opt;
			return null;
		}

		/**
		 * 集計プロジェクト名取得.
		 *
		 * @return String プロジェクト名.
		 */
		private function getRequestOpt_projectName():String
		{
			var opt:String = view.projectName.text;
			if (opt && StringUtil.trim(opt).length > 0)		return opt;
			return null;
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:WorkingHoursMonthly;

	    /**
	     * 画面を取得します
	     */
	    public function get view():WorkingHoursMonthly
	    {
	        if (_view == null) {
	            _view = super.document as WorkingHoursMonthly;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:WorkingHoursMonthly):void
	    {
	        _view = view;
	    }

	}
}