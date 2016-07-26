package subApplications.customer.logic
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.utils.StringUtil;

	/**
	 * 顧客共通クラスです.
	 */
	public class CustomerLogic
	{
		/** エラーメッセージ：排他 */
		public static const FAULT_EXCEPTION_CONFLICT:String = "OptimisticLockException";

		/** エラーメッセージ：削除 */
		private static const FAULT_EXCEPTION_DELETE:String = "CostomerDeleteException";
		private static const FAULT_EXCEPTION_DELETE_DETAIL:String = "The project application exists.";

		/** エラーメッセージ：重複 */
		private static const FAULT_EXCEPTION_EXIST:String = "ExistDataException";
		private static const FAULT_EXCEPTION_EXIST_DETAIL:String = "The specified CustomerCode exists.";

//--------------------------------------
//  Constructor
//--------------------------------------


//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 排他エラーかどうかを確認する.
		 *
		 * @param  e      FaultEvent
		 * @return 削除有無.
		 */
		public static function isConflictFault(e:FaultEvent):Boolean
		{
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(FAULT_EXCEPTION_CONFLICT) >= 0) 	return true;
			else 													return false;
		}


		/**
		 * 削除に失敗したかどうかを確認する.
		 *
		 * @param  e      FaultEvent
		 * @return 削除有無.
		 */
		public static function isDeleteFault(e:FaultEvent):Boolean
		{
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(FAULT_EXCEPTION_DELETE) >= 0) 	return true;
			else 													return false;
		}

		/**
		 * 重複エラーかどうかを確認する.
		 *
		 * @param  e      FaultEvent
		 * @return 削除有無.
		 */
		public static function isExistFault(e:FaultEvent):Boolean
		{
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(FAULT_EXCEPTION_EXIST) >= 0) 		return true;
			else 													return false;
		}


		/**
		 * プロジェクトを取得する.
		 *
		 * @param  e      FaultEvent
		 * @return プロジェクト.
		 */
		public static function getDeleteFault_project(e:FaultEvent):String
		{
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(FAULT_EXCEPTION_DELETE) >= 0) {
				var detail:String = getFaultMessage(faultText, FAULT_EXCEPTION_DELETE_DETAIL, "(", ")");
				return detail;
			}
			else {
				return null;
			}
		}
		/**
		 * 新顧客コードを取得する.
		 *
		 * @param  e      FaultEvent
		 * @return 顧客コード.
		 */
		public static function getExistFault_customerCode(e:FaultEvent):String
		{
			var faultText:String = e.fault.faultString;
			if (faultText.indexOf(FAULT_EXCEPTION_EXIST) >= 0) {
				var detail:String = getFaultMessage(faultText, FAULT_EXCEPTION_EXIST_DETAIL, "(", ")");
				return detail;
			}
			else {
				return null;
			}
		}


		/**
		 * 警告メッセージの表示.
		 *
		 * @param action 操作.
		 */
		public static function alert_xxxx(action:String):void
		{
			Alert.show(action + "に失敗しました。");
		}

		/**
		 * 排他エラーによる警告メッセージの表示.
		 *
		 */
		public static function alert_conflictCustomer():void
		{
			var msg:String = "データが更新されています。";
			msg += "\n" + "画面を表示しなおしたあと、再度実行してください。";
			Alert.show(msg);
		}

		/**
		 * プロジェクト登録済みによる警告メッセージの表示.
		 *
		 * @param projects 登録済みのプロジェクト.
		 */
		public static function alert_delteProject(projects:String):void
		{
			var msg:String = "プロジェクト[" + projects + "]が登録済みのため、";
			msg += "削除はできません。";
			Alert.show(msg);
		}

		/**
		 * 顧客コード重複による警告メッセージの表示.
		 *
		 * @param oldCode 重複した顧客コード.
		 * @param newCode 新顧客コード.
		 */
		public static function alert_existCustomerCode(oldCode:String, newCode:String):void
		{
			var msg:String = "顧客コード[" + oldCode + "]が登録済みのため";
			msg += "\n" + "新しい顧客コード[" + newCode + "]に変更しました。";
			msg += "\n" + "上記値で問題ないならば、再度登録してください。";
			Alert.show(msg);
		}

		/**
		 * 取引先ファイルの読取エラーによる警告メッセージの表示.
		 *
		 */
		public static function alert_readCustomerFile():void
		{
			var msg:String = "取引先情報の読み込みに失敗しました。";
			Alert.show(msg);
		}

		/**
		 * 取引先ファイルの読取終了メッセージの表示.
		 *
		 */
		public static function info_readCustomerFile():void
		{
			var msg:String = "取引先情報の読み込みが終了しました。";
			Alert.show(msg);
		}

		/**
		 * 取引先ファイルの読取終了メッセージの表示.
		 *
		 */
		public static function info_readCustomerFile_nothing():void
		{
			var msg:String = "登録可能な取引先情報がありません。";
			Alert.show(msg);
		}


		/**
		 * 取引先ファイルの読取エラーによる警告メッセージの表示.
		 *
		 */
		public static function alert_outputCustomerFile():void
		{
			var msg:String = "取引先情報の出力に失敗しました。";
			Alert.show(msg);
		}

		/**
		 * 取引先ファイルの書込終了メッセージの表示.
		 *
		 */
		public static function info_outputCustomerFile():void
		{
			var msg:String = "取引先情報の出力が終了しました。";
			Alert.show(msg);
		}


		/**
		 * 取引先templateファイルの読取エラーによる警告メッセージの表示.
		 *
		 */
		public static function alert_templateCustomerFile():void
		{
			var msg:String = "取引先情報テンプレートの取得に失敗しました。";
			Alert.show(msg);
		}

		/**
		 * 取引先templateファイルの書込終了メッセージの表示.
		 *
		 */
		public static function info_templateCustomerFile():void
		{
			var msg:String = "取引先情報テンプレートの取得が終了しました。";
			Alert.show(msg);
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
		private static function getFaultMessage(fault:String, error:String, start:String, last:String):String
		{
			var index:int = fault.indexOf(error);
			var sindex:int = fault.indexOf(start, index);
			var lindex:int = fault.indexOf(last, index);
			return fault.substring(sindex + 1, lindex);
		}


		/**
		 * 顧客Webページを表示する.
		 *
		 * @param url 顧客WebページのURL.
		 */
		public static function openCustomerWindow(url:String):void
		{
			if (!(url && StringUtil.trim(url).length > 0))	return;

			var winName:String = "";							// ウィンドウ名.
			var w:int  = 500;
			var h:int  = 400;
			var toolbar:int = 0;								// ツールバーの表示.
			var location:int = 1;								// 場所ツールバーの表示.
			var directories:int = 0;							// ユーザ設定のツールバーの表示.
			var status:int = 0;									// ステータスバーの表示.
			var menubar:int = 0;								// メニューバーの表示.
			var scrollbars:int = 1;								// スクロールバーの表示.
			var resizable:int = 1;								// リサイズ設定.
			var fullURL:String = "javascript:var myWin;" + "if(!myWin || myWin.closed)" + "{myWin = window.open('" + url + "','" + winName + "','" + "width=" + w + ",height=" + h  + ",toolbar=" + toolbar + ",location=" + location + ",directories=" + directories + ",status=" + status + ",menubar=" + menubar + ",scrollbars=" + scrollbars + ",resizable=" + resizable + ",top='+((screen.height/2)-(" + h/2 + "))+'" + ",left='+((screen.width/2)-(" + w/2 + "))+'" + "')}"
														 + "else{myWin.location.href='" + url + "';" + "myWin.focus();};void(0);";
			var u:URLRequest = new URLRequest(fullURL);
			navigateToURL(u,"_self");
		}

	}
}