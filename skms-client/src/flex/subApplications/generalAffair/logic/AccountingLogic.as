package subApplications.generalAffair.logic
{
	import logic.Logic;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	
	import subApplications.generalAffair.dto.StaffEntryDto;
	
	import utils.CommonIcon;


	/**
	 * AccountingのLogicクラスです.
	 */
	public class AccountingLogic extends Logic
	{
		/** Viewモード */
		protected var _actionView:String;
		/** 動作モード */
		protected var _actionMode:String;

		/** 一覧表の表示行数 */
		public static const ROW_COUNT_EDIT:int = 14;

		/** 一覧選択行のデフォルト値 */
		public static const INDEX_INVALID:int = -1;
		/** 選択されたスタッフ情報 */
		protected var _selectedStaffDto:StaffEntryDto;
		/** 処理動作 新規作成 */
		public static const ACTION_NEW:String 				= "new";
		/** 処理動作 変更 */
		public static const ACTION_UPDATE:String 			= "update";

		/** エラーメッセージ：排他 */
		public static const FAULT_EXCEPTION_CONFLICT:String = "OptimisticLockException";
		public static const FAULT_MESSAGE_CONFLICT  :String = ERROR_MESSAGE_CONFLICT + "\n" + ERROR_MESSAGE_RE_ACTION;
		private static const ERROR_MESSAGE_CONFLICT :String = "データが更新されています";
		private static const ERROR_MESSAGE_RE_ACTION:String = "画面を表示しなおしたあと、再度実行してください。";


//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function AccountingLogic()
		{
			super();
		}

//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		protected function onCreationCompleteHandler_setSuceedData():void
		{
		}

	    /**
	     * 表示データの設定.
	     *
	     */
	    protected function onCreationCompleteHandler_setDisplayData():void
	    {
	    }

	    /**
		 * コンテキストメニューの設定.
	     *
	     */
	    protected function onCreationCompleteHandler_setContextMenu():void
	    {
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * getXxxxxリモート呼び出しの失敗.
		 *
		 * @param e      FaultEvent
		 * @param msg    メッセージ表示.
		 * @param action 実行操作.
		 */
		protected function onFault_getXxxxx(e:FaultEvent, msg:Boolean = false, action:String = null):void
		{
			trace(e);
			if (msg) {
				var actionOpe:String = action;
				if (!actionOpe)	actionOpe = "データ";
				Alert.show(actionOpe + "取得に失敗しました。");
			}
			return;
		}

		/**
		 * updateXxxxxリモート呼び出しの失敗.
		 *
		 * @param e      FaultEvent
		 * @param msg    メッセージ表示.
		 * @param action 実行操作.
		 * @return conflict有無.
		 */
		protected function onFault_updateXxxxx(e:FaultEvent, msg:Boolean = false, action:String = null):Boolean
		{
			trace(e);
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(FAULT_EXCEPTION_CONFLICT) >= 0) {
				if (msg) Alert.show(FAULT_MESSAGE_CONFLICT);
				return true;
			}
			else {
				var actionOpe:String = action;
				if (!actionOpe)	actionOpe = "データ更新";
				if (msg) Alert.show(actionOpe + "に失敗しました。");
				return false;
			}
		}

		/**
		 * 警告メッセージの表示.
		 *
		 */
		private static function alert_xxxxx(message:String):void
		{
			Alert.show(message, "", 4, null, null, CommonIcon.exclamationIcon);
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	}
}