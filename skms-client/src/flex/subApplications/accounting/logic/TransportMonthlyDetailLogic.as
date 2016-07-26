package subApplications.accounting.logic
{
	import logic.Logic;

	import mx.controls.CheckBox;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationMonthlySearchDto;
	import subApplications.accounting.web.TransportMonthly;
	import subApplications.accounting.web.TransportMonthlyDetail;

	import utils.LabelUtil;

	/**
	 * TransportMonthlyDetailのLogicクラスです.
	 */
	public class TransportMonthlyDetailLogic extends Logic
	{

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function TransportMonthlyDetailLogic()
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
			// タイトルを設定する.
			view.title = getMonthlyTitle();

			// 表示条件を設定する.
//			view.monthlyTarget.text = getMonthlyTarget();
//			view.monthlyTerm.text   = getMonthlyTerm();
//			view.monthlyStatus.text = getMonthlyStatus();
//			view.monthlyBase.text   = getMonthlyBase();

	    	// 表示データを設定する.
			var parent:TransportMonthly = view.parentDocument.body.child as TransportMonthly;
	    	view.rdMonthlyGrp.selectedValue = parent.rdMonthlyGrp.selectedValue;
			view.dgMonthly.startDate   = getRequestOpt_startDate();
			view.dgMonthly.finishDate  = getRequestOpt_finishDate();
			view.dgMonthly.projectMonthly = !view.data.search.isProjectMonthly;
			view.dgMonthly.monthlyData = view.data.monthlyData;
			view.dgMonthly.visible     = true;
			view.boxDg.visible         = true;
	    }


//--------------------------------------
//  UI Event Handler
//--------------------------------------

//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 集計表の集計対象取得.
		 *
		 * @return String 集計対象.
		 */
		private function getMonthlyTitle():String
		{
			var search:TransportationMonthlySearchDto = view.data.search as TransportationMonthlySearchDto;
	    	if (search.isProjectMonthly)
				return "プロジェクト別集計 " + " 【" + search.objectCode + "　" + search.objectName + "】";
			else
	    		return "個人別集計" + " 【" + search.objectName + "】";
		}

		/**
		 * 集計表の集計対象取得.
		 *
		 * @return String 集計対象.
		 */
		private function getMonthlyTarget():String
		{
			var search:TransportationMonthlySearchDto = view.data.search as TransportationMonthlySearchDto;
	    	if (search.isProjectMonthly)
				return search.objectCode + "　" + search.objectName;
			else
	    		return search.objectName;
		}

		/**
		 * 集計表の集計期間取得.
		 *
		 * @return String 集計期間.
		 */
		private function getMonthlyTerm():String
		{
			var target:TransportMonthly = view.parentDocument.body.child as TransportMonthly;
			if (ObjectUtil.compare(target.rdRangeGrp.selectedValue, TransportMonthlyLogic.RANGE_MONTH) == 0) {
				return  LabelUtil.date(target.startDate.selectedDate) + " ～ " + LabelUtil.date(target.finishDate.selectedDate);
			}
			else {
				return target.term.text + "期";
			}
		}

		/**
		 * 集計表の申請状態取得.
		 *
		 * @return String 集計状態.
		 */
		private function getMonthlyStatus():String
		{
			var target:TransportMonthly = view.parentDocument.body.child as TransportMonthly;
			var status:String = "";
			for each (var item:CheckBox in target.chkStatus as Array) {
				if (item.selected) {
					if (status.length > 0)	status += "・";
					status += item.label;
				}
			}
			return status;
		}

		/**
		 * 集計表の集計基準取得.
		 *
		 * @return String 集計基準.
		 */
		private function getMonthlyBase():String
		{
			var target:TransportMonthly = view.parentDocument.body.child as TransportMonthly;
			return target.rdBaseDateGrp.selection.label;
		}

		/**
		 * 集計表の集計開始日付取得.
		 *
		 * @return date 開始日付.
		 */
		private function getRequestOpt_startDate():Date
		{
			var search:TransportationMonthlySearchDto = view.data.search as TransportationMonthlySearchDto;
			var date:Date  = search.startDate;
			var dateD:Date = search.objectStartDate;
			if (dateD)				return dateD;
			else					return date;
		}

		/**
		 * 集計表の集計終了日付取得.
		 *
		 * @return date 終了日付.
		 */
		private function getRequestOpt_finishDate():Date
		{
			var search:TransportationMonthlySearchDto = view.data.search as TransportationMonthlySearchDto;
			var date:Date  = search.finishDate;
			var dateD:Date = search.objectFinishDate;
			if (dateD)				return dateD;
			else					return date;
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:TransportMonthlyDetail;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():TransportMonthlyDetail
	    {
	        if (_view == null) {
	            _view = super.document as TransportMonthlyDetail;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:TransportMonthlyDetail):void
	    {
	        _view = view;
	    }
	}
}