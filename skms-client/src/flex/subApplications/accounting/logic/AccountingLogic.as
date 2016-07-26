package subApplications.accounting.logic
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import logic.Logic;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;

	import subApplications.accounting.dto.TransportationDto;

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

		/** 選択された交通費申請情報 */
		protected var _selectedTransportDto:TransportationDto;
		/** 選択されたリンクバー */
		protected var _selectedLinkObject:Object;

		/** 交通機関マスタリスト */
		protected var _facilityNameList:ArrayCollection;


		/** 一覧表の表示行数 */
		public static const ROW_COUNT_EDIT:int = 15;

		/** 一覧選択行のデフォルト値 */
		public static const INDEX_INVALID:int = -1;

		/** 処理動作 申請一覧 */
		public static const ACTION_VIEW_REQUEST:String 		= "view request";
		/** 処理動作 承認一覧 通常*/
		public static const ACTION_VIEW_APPROVAL:String 	= "view approval";
		/** 処理動作 承認一覧 総務*/
		public static const ACTION_VIEW_APPROVAL_AF:String 	= "view approval af";

		/** 処理動作 新規作成 */
		public static const ACTION_NEW:String 				= "new";
		/** 処理動作 変更 */
		public static const ACTION_UPDATE:String 			= "update";
		/** 処理動作 複製 */
		public static const ACTION_COPY:String 				= "copy";
		/** 処理動作 申請 */
		public static const ACTION_APPLY:String 			= "apply";
		/** 処理動作 申請取り下げ */
		public static const ACTION_APPLY_WITHDRAW:String 	= "applyWithdraw";
		/** 処理動作 受領 */
		public static const ACTION_ACCEPT:String 			= "accept";
		/** 処理動作 受領取り消し */
		public static const ACTION_ACCEPT_CANCEL:String 	= "acceptCancel";
		/** 処理動作 承認 */
		public static const ACTION_APPROVAL:String 			= "approval";
		/** 処理動作 承認 総務 */
		public static const ACTION_APPROVAL_AF:String 		= "approval af";
		/** 処理動作 承認取り消し */
		public static const ACTION_APPROVAL_CANCEL:String	= "approvalCancel";
		/** 処理動作 承認取り下げ */
		public static const ACTION_APPROVAL_WITHDRAW:String	= "approvalWithdraw";
		/** 処理動作 支払 */
		public static const ACTION_PAYMENT:String 			= "payment";
		/** 処理動作 支払取り消し */
		public static const ACTION_PAYMENT_CANCEL:String 	= "paymentCancel";
		/** 処理動作 経路検索 */
		public static const ACTION_ROUTE_SEARCH:String 		= "routeSearch";
		/** 処理動作 経路登録 */
		public static const ACTION_ROUTE_ENTRY:String 		= "routeEntry";


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
		 * リンクボタン選択.
		 *
		 * @param e MouseEvent
		 */
		public function onClick_linkList(e:MouseEvent):void
		{
			// 選択したデータを取得する.
			_selectedLinkObject = e.target;
		}

		/**
		 * リンクボタン選択 確認結果.
		 *
		 * @param e CloseEvent
		 */
		protected function onClick_linkList_confirmResult(e:CloseEvent):void
		{
		}

//		/**
//		 * PopUp画面の登録後処理（PopUp画面に最新データを設定する）.
//		 * ※登録ボタンを押下したときに呼ぶ.
//		 *
//		 * @param e CloseEvent
//		 */
//		protected function onClose_popupEntry(e:CloseEvent):void
//		{
//			// 登録ボタンを押下したとき.
//			if (e.detail == 1) {
//				// 最新データを取得する.
//		    	onCreationCompleteHandler_setDisplayData();
//			}
//		}
//
//		/**
//		 * PopUp画面の登録後処理（PopUp画面を閉じる）.
//		 * ※登録ボタンを押下したときに呼ぶ.
//		 *
//		 * @param view IFlexDisplayObject
//		 */
//		protected function popupEntryAfter(view:IFlexDisplayObject):void
//		{
//		 	// PopUpのCloseイベントを作成する.
//			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, 1);
//			view.dispatchEvent(ce);
//		}
//
//		/**
//		 * PopUp画面の閉じる処理.
//		 * ※閉じるボタンを押下したときに呼ぶ.
//		 *
//		 * @param view IFlexDisplayObject
//		 */
//		protected function popupClose(view:IFlexDisplayObject):void
//		{
//		 	// PopUpのCloseイベントを作成する.
//		 	if (isLatestDataDisplay && ObjectUtil.compare(_actionMode, ACTION_NEW) != 0) {
//				popupEntryAfter(view);
//		 	}
//		 	else {
//			 	var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
//			 	view.dispatchEvent(ce);
//		 	}
//		}
//
//		/**
//		 * PopUp画面のClose処理.
//		 * ※Closeボタンを押下したときに呼ぶ.
//		 *
//		 * @param view IFlexDisplayObject
//		 */
//		protected function popupRemove(view:IFlexDisplayObject):void
//		{
//			// PopUpをCloseする.
//			PopUpManager.removePopUp(view);
//		}

		/**
		 * コンテキストメニュー有効／無効の設定.
		 *
		 * @param contextMenu  コンテキストメニュー.
		 * @param enabledItems 有効メニューリスト.
		 */
		protected function setEnabledContextMenu(contextMenu:ContextMenu, enabledItems:Array):void
		{
			// ContextMenuの有効／無効を設定する.
			for each (var customItem:ContextMenuItem in contextMenu.customItems) {
				// 無効で初期化する.
				customItem.enabled = false;
				// 有効メニューを検索する.
				for each (var enabledItem:String in enabledItems) {
					if (ObjectUtil.compare(customItem.caption, enabledItem) == 0) {
						customItem.enabled = true;
						break;
					}
				}
			}
		}

		/**
		 * 引き継ぎデータの作成（申請・承認）.
		 *
		 */
		protected function makeSucceedData(transport:TransportationDto = null, actionMode:String = null):Object
		{
			var obj:Object   = new Object();
			if (transport)	obj.transportDto = ObjectUtil.copy(transport);
			else			obj.transportDto = ObjectUtil.copy(_selectedTransportDto);
			if (actionMode)					obj.actionMode = ObjectUtil.copy(actionMode);
			else if (_selectedLinkObject)	obj.actionMode = ObjectUtil.copy(_selectedLinkObject.action);
			else							obj.actionMode = null;
			obj.actionView = ObjectUtil.copy(_actionView);
			obj.facilities = _facilityNameList;
			return obj;
		}

		/**
		 * 引き継ぎデータの作成（取り下げ）.
		 *
		 */
		protected function makeSucceedData_withdraw(entry:String, withdraw:String, transport:TransportationDto = null, actionMode:String = null):Object
		{
			var obj:Object = makeSucceedData(transport, actionMode);
			obj.entry      = entry;
			obj.withdraw   = withdraw;
			return obj;
		}

		/**
		 * 引き継ぎデータの作成（経路登録）.
		 *
		 */
		protected function makeSucceedData_routeEntry(routeItems:Array, transport:TransportationDto = null, actionMode:String = null):Object
		{
			var obj:Object = makeSucceedData(transport, actionMode);
			obj.entryItems = routeItems;
			obj.facilities = _facilityNameList;
			return obj;
		}

		/**
		 * 引き継ぎデータの作成（経路検索）.
		 *
		 */
		protected function makeSucceedData_routeSearch(insertIndices:Array, transport:TransportationDto = null, actionMode:String = null):Object
		{
			var obj:Object = makeSucceedData(transport, actionMode);
			obj.insertIndices = insertIndices;
			return obj;
		}

		/**
		 * InfoSeekウィンドウ表示.
		 */
		protected function openWindow_InfoSeek():void
		{
			// 2009.05.18 start 表示方法の変更.
			//var w_height:int= Application.application.height * 0.8;
			//var w_width:int = Application.application.width  * 0.8;
			//var window_infoseek:HtmlWindow = new HtmlWindow();
			//window_infoseek.openNewWindow("http://transfer.infoseek.co.jp/", "window_infoseek", w_width, w_height);
			//var u:URLRequest = new URLRequest("http://transit.loco.yahoo.co.jp/");
			var u:URLRequest = new URLRequest("https://transit.ekitan.com/?search_type=pass");
       		navigateToURL(u,"_blank");
			// 2009.05.18 end   表示方法の変更.
		}


		/** エラーメッセージ：排他 */
		private static const EXCEPTION_CONFLICT:String = "OptimisticLockException";

		/** エラーメッセージ：削除 */
		private static const EXCEPTION_DELETE:String = "ProjectDeleteException";
		private static const EXCEPTION_DELETE_DETAIL:String = "The transportation application exists.";

		/**
		 * 警告メッセージの表示.
		 *
		 */
		private static function alert_xxxxx(message:String):void
		{
			Alert.show(message, "", 4, null, null, CommonIcon.exclamationIcon);
		}

		/**
		 * 情報メッセージの表示.
		 *
		 */
		private static function info_xxxxx(message:String):void
		{
			Alert.show(message, "", 4, null, null, CommonIcon.exclamationIcon);
		}

		/**
		 * 排他エラーかどうかを確認する.
		 *
		 * @param  e      FaultEvent
		 * @return 削除有無.
		 */
		private static function isConflictFault(e:FaultEvent):Boolean
		{
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(EXCEPTION_CONFLICT) >= 0) 	return true;
			else 												return false;
		}


		/**
		 * 削除に失敗したかどうかを確認する.
		 *
		 * @param  e      FaultEvent
		 * @return 削除有無.
		 */
		private static function isDeleteFault(e:FaultEvent):Boolean
		{
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(EXCEPTION_DELETE) >= 0) 	return true;
			else 											return false;
		}

		/**
		 * faultメッセージの取得.
		 *
		 * @param fault faultメッセージ.
		 * @param error errorメッセージ.
		 * @param start errorメッセージの区切り文字.
		 * @param last  errorメッセージの区切り文字.
		 * @return errorメッセージ抜粋.
		 */
		private static function getExceptionDetailMessage(fault:String, error:String, start:String, last:String):String
		{
			var index:int = fault.indexOf(error);
			var sindex:int = fault.indexOf(start, index);
			var lindex:int = fault.indexOf(last, index);
			return fault.substring(sindex + 1, lindex);
		}


	//----------------------------------------------------------------------------
	//  諸経費 ： 共通.
	//----------------------------------------------------------------------------
		/**
		 * 諸経費区分取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getOverheadType(e:FaultEvent):Boolean
		{
			var message:String = "諸経費区分取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 設備種別取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getEquipmentKind(e:FaultEvent):Boolean
		{
			var message:String = "設備種別取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 支払種別取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getPayment(e:FaultEvent):Boolean
		{
			var message:String = "支払種別取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 勘定科目取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getAccountItem(e:FaultEvent):Boolean
		{
			var message:String = "勘定科目取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * PC種別得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getPcKind(e:FaultEvent):Boolean
		{
			var message:String = "PC種別取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 社員取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getStaff(e:FaultEvent):Boolean
		{
			var message:String = "社員取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 設置場所取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getInstallationLocation(e:FaultEvent):Boolean
		{
			var message:String = "設置場所取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * カード取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getCreditCard(e:FaultEvent):Boolean
		{
			var message:String = "クレジットカード情報取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * ジャンル取得失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getJanre(e:FaultEvent):Boolean
		{
			var message:String = "ジャンル取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 表示タイむアウトのメッセージ表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_timerOutDisplayData(e:Event):Boolean
		{
			var message:String = "諸経費明細表示に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 諸経費取り消し／取り下げ失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_withdrawOverhead(e:FaultEvent, withdraw:String):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				message = "データが更新されています。\n画面を表示しなおしたあと、再度実行してください。";
				conflict = true;
			}
			else {
				message = "諸経費" + withdraw + "に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}



	//----------------------------------------------------------------------------
	//  諸経費 ： 申請操作.
	//----------------------------------------------------------------------------
		/**
		 * 申請諸経費取得メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getRequestOverheads(e:FaultEvent):Boolean
		{
			var message:String = "諸経費取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 諸経費削除失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_deleteOverhead(e:FaultEvent):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				message = "データが更新されています。\n再度実行してください。";
				conflict = true;
			}
			else if (isDeleteFault(e)) {
//				var d_message:String = getExceptionDetailMessage(e.fault.faultString, EXCEPTION_DELETE_DETAIL, "(", ")");
				message  = "諸経費削除に失敗しました。";
//				message += "\n";
//				message += "交通費が登録されています。: " + d_message;
			}
			else {
				message = "諸経費削除に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}

		/**
		 * 諸経費複製失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_copyOverhead(e:FaultEvent):Boolean
		{
			var message:String = "諸経費複製に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 申請メッセージの表示.
		 *
		 */
		public static function info_applyOverhead():void
		{
			var message:String = "領収書Noを発行しました。\n" + "領収書に発行された領収書Noをメモしてください。";
			info_xxxxx(message);
		}

		/**
		 * 申請取り下げメッセージの表示.
		 *
		 */
		public static function info_applyWithdrawOverhead():void
		{
			var message:String = "領収書Noを破棄しました。\n" + "領収書にメモした領収書Noを消してください。";
			info_xxxxx(message);
		}

		/**
		 * 諸経費申請失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_applyOverhead(e:FaultEvent, popwin:Boolean):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				if (popwin) {
					message = "データが更新されています。\n画面を表示しなおしたあと、再度実行してください。";
				}
				else {
					message = "データが更新されています。\n再度実行してください。";
				}
				conflict = true;
			}
			else {
				message = "諸経費申請に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}

		/**
		 * 諸経費受領失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_acceptOverhead(e:FaultEvent):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				message = "データが更新されています。\n再度実行してください。";
				conflict = true;
			}
			else {
				message = "諸経費受領処理に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}


	//----------------------------------------------------------------------------
	//  諸経費 ： 承認操作.
	//----------------------------------------------------------------------------
		/**
		 * 承認諸経費取得メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getApprovalOverheads(e:FaultEvent):Boolean
		{
			var message:String = "諸経費取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 諸経費支払メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_paymentOverhead(e:FaultEvent):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				message = "データが更新されています。\n再度実行してください。";
				conflict = true;
			}
			else {
				message = "諸経費支払処理に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}

		/**
		 * PM承認失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_approvalOverhead(e:FaultEvent, popwin:Boolean):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				if (popwin) {
					message = "データが更新されています。\n画面を表示しなおしたあと、再度実行してください。";
				}
				else {
					message = "データが更新されています。\n再度実行してください。";
				}
				conflict = true;
			}
			else {
				message = "諸経費承認に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}

		/**
		 * 総務承認失敗メッセージの表示.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_approvalAfOverhead(e:FaultEvent, popwin:Boolean):Boolean
		{
			return alert_approvalOverhead(e, popwin);
		}


//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	}
}