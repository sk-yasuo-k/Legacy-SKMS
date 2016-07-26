package subApplications.accounting.logic
{
	import components.PopUpWindow;

	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationDto;
	import subApplications.accounting.web.TransportApply;

	import utils.LabelUtil;

	/**
	 * TransportApplyのLogicクラスです.
	 */
	public class TransportApplyLogic extends AccountingLogic
	{
		/** 再表示 */
		private var _reload:Boolean = false;

//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ.
	     */
		public function TransportApplyLogic()
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
			// 引き継ぎデータを取得する.
			onCreationCompleteHandler_setSuceedData();

			// 表示データを設定する.
			onCreationCompleteHandler_setDisplayData();

			// CreationComplete
			onSetBackgroundColor_transportationDetail(new Event("onCreationCompleteHandler"));
	    }

	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
	    	_selectedTransportDto = view.data.transportDto;
	    	_actionMode = view.data.actionMode;
	    	_facilityNameList = view.data.facilities;
		}

	    /**
	     * 表示データの設定.
	     *
	     */
	    override protected function onCreationCompleteHandler_setDisplayData():void
	    {
	    	// 一覧表を作成する.
			view.transportationDetail.rowCount     = ROW_COUNT_EDIT;
			view.transportationDetail.actionMode   = _actionMode;
	    	view.transportationDetail.dataProvider = _selectedTransportDto.transportationDetails;
			view.transportationDetail.facilities   = _facilityNameList;

			// ヘッダ情報を設定する.
			view.project.text      = _selectedTransportDto.project.projectCode
									+ "　" + _selectedTransportDto.project.projectName;
			view.transportationExpense.text = LabelUtil.expense(view.transportationDetail.transportationExpense.toString());
	    }


//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 申請ボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onButtonClick_entry_confirm(e:Event):void
		{
			Alert.show("申請してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);				// 申請.
			else {
				if (view.visible)		;									// エラー修正あり、何もしない.
				else 					onButtonClick_close(e);				// エラー修正なし、クローズ.
			}
		}
		protected function onButtonClick_entry(e:Event):void
		{
			// エラー修正あり.
			if (view.visible) {
				var entryList:ArrayCollection = view.transportationDetail.dataProvider as ArrayCollection;
				var entryDto:TransportationDto = _selectedTransportDto.entryTransportation(entryList);
				view.srv.getOperation("updateApplyTransportation").send(Application.application.indexLogic.loginStaff, entryDto);
			}
			// エラー修正なし.
			else {
				view.srv.getOperation("applyTransportation").send(Application.application.indexLogic.loginStaff, _selectedTransportDto);
			}
		}

		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e イベント.
		 */
//		public function onButtonClick_close_confirm(e:Event):void
//		{
//			Alert.show("編集中のデータは破棄されますがよろしいですか？", "", 3, view, onButtonClick_close_confirmResult);
//		}
//		protected function onButtonClick_close_confirmResult(e:CloseEvent):void
//		{
//			if (e.detail == Alert.YES)	onButtonClick_close(e);				// クローズ.
//		}
		public function onButtonClick_close(e:Event):void
		{
			if (_reload)			view.closeWindow(PopUpWindow.ENTRY);
			else					view.closeWindow();
		}


	    /**
	     * 合計金額計算.
	     *
	     * @param e Event
	     */
		public function onCalculatedExpense_transportationDetail(e:Event):void
		{
			view.transportationExpense.text = LabelUtil.expense(e.currentTarget.transportationExpense.toString());
		}

		/**
		 * applyTransportation(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_applyTransportation(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * updateApplyTransportation(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_updateApplyTransportation(e:ResultEvent):void
		{
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * 一覧の背景色設定.
		 *
		 * @param e Event.
		 */
		public function onSetBackgroundColor_transportationDetail(e:Event):void
		{
			// エラーを確認する.
			var error:Boolean = view.transportationDetail.errorCount > 0 ? true : false;
			if (error) 		view.btnEntry.enabled = false;
			else			view.btnEntry.enabled = true;

 			// CreationComplete
			if (ObjectUtil.compare(e.type, "onCreationCompleteHandler") == 0) {
				if (error) {
					view.visible = true;
					Alert.show("入力項目に不備があるため申請できません。\n修正してください。");
				}
				else {
					onButtonClick_entry_confirm(e);
				}
			}
		}

		/**
		 * applyTransportationの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_applyTransportation(e:FaultEvent):void
		{
			var conflict:Boolean = super.onFault_updateXxxxx(e, true, "申請");
			if (conflict)		view.closeWindow(PopUpWindow.ENTRY);
			else				view.closeWindow();
		}

		/**
		 * updateApplyTransportationの呼び出し失敗.
		 *
		 * @param e FaultEvent
		 */
		public function onFault_updateApplyTransportation(e:FaultEvent):void
		{
			var conflict:Boolean = super.onFault_updateXxxxx(e, true, "申請");
			if (conflict)		_reload = true;
		}

//--------------------------------------
//  Function
//--------------------------------------

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:TransportApply;

	    /**
	     * 画面を取得します.
	     */
	    public function get view():TransportApply
	    {
	        if (_view == null) {
	            _view = super.document as TransportApply;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします.
	     *
	     * @param view セットする画面.
	     */
	    public function set view(view:TransportApply):void
	    {
	        _view = view;
	    }
	}
}