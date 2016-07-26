package subApplications.project.logic
{
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.rpc.events.FaultEvent;
	import mx.utils.ObjectUtil;
	
	import subApplications.project.dto.ProjectMemberDto;
	
	import utils.CommonIcon;

	/**
	 * プロジェクト共通クラスです.
	 */
	public class ProjectLogic
	{

//--------------------------------------
//  Constructor
//--------------------------------------
//		/**
//		 * コンストラクタ.
//		 */
//		public function ProjectLogic()
//		{
//			;
//		}

//--------------------------------------
//  Function
//--------------------------------------
//		/**
//		 * 日付フォーマット処理.
//		 *
//		 * @param data DataGridの選択されたデータ項目.
//		 * @param column DataGridの列オブジェクト.
//		 * @return フォーマット済みのデータ項目.
//		 */
//		public function dateLabel(data:Object, column:DataGridColumn):String
//		{
//			var date:Date = data[column.dataField] as Date;							// データ取得.
//			if (!date)	return "";													// データ = null.
//
//			var retStr:String = _dateFormatter.format(date);						// フォーマット変換.
//			if (retStr == "") retStr = _dateFormatter.error + "(" + date + ")";		// フォーマット変換エラー.
//	        return retStr;
//		}
//
//		/**
//		 * 日付フォーマット処理.
//		 *
//		 * @param data DateFieldの選択されたデータ項目.
//		 * @return フォーマット済みのデータ項目.
//		 */
//		public function dateFieldLabel(current:Date):String
//		{
//			if (!current)	return "";												// データ = null.
//
//			var retStr:String = _dateFormatter.format(current);						// フォーマット変換.
//			if (retStr == "") retStr = _dateFormatter.error + "(" + current + ")";	// フォーマット変換エラー.
//	        return retStr;
//		}

//		/**
//		 * DateField 入力日付フォーマットチェック.
//		 *
//		 * @param target チェックするDateFieldデータ.
//		 * @return チェック結果.
//		 */
//		public function checkDateField_text(target:DateField):Boolean
//		{
//			if (!target)		return true;
//
//			// フォーマット変換できるかチェックする.
//			var date:Date = DateField.stringToDate(target.text, _dateFormatter.formatString);
//			if (!date)			return false;
//			else				return true;
//		}
//
//		/**
//		 * 日付フォーマット取得.
//		 *
//		 * @return フォーマット形式.
//		 */
//		 public function get dateFormatString():String
//		 {
//		 	return _dateFormatter.formatString;
//		 }

//		/**
//		 * 日付解析処理.
//		 *
//		 * @param valueString 入力データ.
//		 * @param inputFormat フォーマット形式.
//		 * @return 日付.
//		 */
//		public function dateFieldParse(valueString:String, inputFormat:String):Date
//		{
//			var date:Date = DateField.stringToDate(valueString, inputFormat);
//	        return date;
//		}

		/**
		 * プロジェクトマネージャ表示処理.
		 *
		 * @param data DataGridの選択されたデータ項目.
		 * @param column DataGridの列オブジェクト.
		 * @return フォーマット済みのデータ項目.
		 */
		public static function projectManagerLabel(data:Object, column:DataGridColumn):String
		{
			var member:ProjectMemberDto = data[column.dataField] as ProjectMemberDto;
			if (!member)	return "";
			return member.staffName;
		}

		/**
		 * 開始予定日ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 * @return 結果.
		 */
		public static function planedStartDateSort(obj1:Object, obj2:Object):int
		{
			return dateSort(obj1, obj2, "planedStartDate")
		}

		/**
		 * 終了予定日ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 * @return 結果.
		 */
		public static function planedFinishDateSort(obj1:Object, obj2:Object):int
		{
			return dateSort(obj1, obj2, "planedFinishDate")
		}

		/**
		 * 開始実績日ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 * @return 結果.
		 */
		public static function actualStartDateSort(obj1:Object, obj2:Object):int
		{
			return dateSort(obj1, obj2, "actualStartDate")
		}

		/**
		 * 終了実績日ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 * @return 結果.
		 */
		public static function actualFinishDateSort(obj1:Object, obj2:Object):int
		{
			return dateSort(obj1, obj2, "actualFinishDate")
		}

		/**
		 * 報告日ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 * @return 結果.
		 */
		public static function reportingDateSort(obj1:Object, obj2:Object):int
		{
			return dateSort(obj1, obj2, "reportingDate")
		}

		/**
		 * 日付ソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 * @return 結果.
		 */
		public static function dateSort(obj1:Object, obj2:Object, dataField:String):int
		{
			var date1:Date = obj1[dataField] as Date;
			var date2:Date = obj2[dataField] as Date;
			return ObjectUtil.compare(date1, date2);
		}

		/**
		 * プロジェクトマネージャソート処理.
		 *
		 * @param obj1 比較するデータエレメント.
		 * @param obj2 obj1の比較対象となるデータエレメント.
		 * @return 結果.
		 */
		public static function projectManagerSort(obj1:Object, obj2:Object):int
		{
			var member1:ProjectMemberDto = obj1["projectManager"];
			var member2:ProjectMemberDto = obj2["projectManager"];

			var pm1:String = member1 ? member1.staffName : null;
			var pm2:String = member2 ? member2.staffName : null;
			return ObjectUtil.compare(pm1, pm2);
		}


	//--------------------------------------
	//  警告メッセージ.
	//--------------------------------------
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


		//--------------------------------------
		//  プロジェクト一覧.
		//--------------------------------------
		/**
		 * 警告メッセージの表示.
		 * →プロジェクト取得失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_projectSearch(e:FaultEvent):Boolean
		{
			var message:String = "プロジェクト取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 警告メッセージの表示.
		 * →プロジェクト削除失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_deleteProject(e:FaultEvent):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				message = "データが更新されています。\n再度実行してください。";
				conflict = true;
			}
			else if (isDeleteFault(e)) {
				var d_message:String = getExceptionDetailMessage(e.fault.faultString, EXCEPTION_DELETE_DETAIL, "(", ")");
				message  = "プロジェクト削除に失敗しました。";
				message += "\n";
				message += "交通費が登録されています。: " + d_message;
			}
			else {
				message = "プロジェクト削除に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}

		/**
		 * 警告メッセージの表示.
		 * →プロジェクトマネージャ取得失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getProjectPositionPMList(e:FaultEvent):Boolean
		{
			var message:String = "プロジェクトマネージャ取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}


		//--------------------------------------
		//  プロジェクト登録.
		//--------------------------------------
		/**
		 * 警告メッセージの表示.
		 * →プロジェクト登録失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_createProject(e:FaultEvent):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				message = "データが更新されています。\n画面を表示しなおしたあと、再度実行してください。";
				conflict = true;
			}
			else if (isDeleteFault(e)) {
				var d_message:String = getExceptionDetailMessage(e.fault.faultString, EXCEPTION_DELETE_DETAIL, "(", ")");
				message  = "プロジェクトメンバ削除に失敗しました。";
				message += "\n";
				message += "交通費が登録されています。: " + d_message;
			}
			else {
				message = "プロジェクト登録に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}

		/**
		 * 警告メッセージの表示.
		 * →取引先取得失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getCustomerList(e:FaultEvent):Boolean
		{
			var message:String = "取引先取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 警告メッセージの表示.
		 * →社員取得失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getProjectStaffList(e:FaultEvent):Boolean
		{
			var message:String = "社員取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 警告メッセージの表示.
		 * →役職取得失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getProjectPositionList(e:FaultEvent):Boolean
		{
			var message:String = "役職取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}

		/**
		 * 警告メッセージの表示.
		 * →振込先銀行口座取得失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_getBankList(e:FaultEvent):Boolean
		{
			var message:String = "振込先銀行口座取得に失敗しました。";
			alert_xxxxx(message);
			return false;
		}


		//--------------------------------------
		//  プロジェクト状況登録.
		//--------------------------------------
		/**
		 * 警告メッセージの表示.
		 * →プロジェクト状況登録失敗.
		 *
		 * @param e FaultEvent
		 * @return 排他.
		 */
		public static function alert_createProjectSituation(e:FaultEvent):Boolean
		{
			var message:String = "";
			var conflict:Boolean = false;
			if (isConflictFault(e)) {
				message = "データが更新されています。\n画面を表示しなおしたあと、再度実行してください。";
				conflict = true;
			}
			else {
				message = "プロジェクト状況登録に失敗しました。";
			}
			alert_xxxxx(message);
			return conflict;
		}

//		/**
//		 * 警告メッセージの表示.
//		 *
//		 * @param action 操作.
//		 */
//		public static function alert_xxxx(action:String):void
//		{
//			Alert.show(action + "に失敗しました。");
//		}
//
//		/**
//		 * getXxxxxリモート呼び出しの失敗.
//		 *
//		 * @param e      FaultEvent
//		 * @param action 実行操作.
//		 * @param msg    メッセージ表示.
//		 */
//		public static function onFault_getXxxxx(e:FaultEvent, action:String, msg:Boolean = false):void
//		{
//			trace(e);
//			if (msg) {
//				Alert.show(action + "取得に失敗しました。");
//			}
//			return;
//		}
//
//		/**
//		 * updateXxxxxリモート呼び出しの失敗.
//		 *
//		 * @param e      FaultEvent
//		 * @param action 実行操作.
//		 * @param msg    メッセージ表示.
//		 * @return conflict有無.
//		 */
//		public static function onFault_updateXxxxx(e:FaultEvent, action:String, msg:Boolean = false):Boolean
//		{
//			trace(e);
//			var faultText:String = e.fault.faultString;
//			// 排他エラー.
//			if (faultText.indexOf(FAULT_EXCEPTION_CONFLICT) >= 0) {
//				if (msg) Alert.show(FAULT_MESSAGE_CONFLICT);
//				return true;
//			}
//			// 削除エラー.
//			else if (faultText.indexOf(FAULT_EXCEPTION_DELETE) >= 0) {
//				if (msg) {
//					var error:String  = action + "に失敗しました。";
//					var detail:String = getFaultMessage(faultText, FAULT_EXCEPTION_DELETE_DETAIL, "(", ")");
//					if (detail)	{
//						error +=  "\n" + "交通費が登録されています。: " + detail;
//					}
//					Alert.show(error);
//				}
//				return false;
//			}
//			else {
//				if (msg) Alert.show(action + "に失敗しました。");
//				return false;
//			}
//		}
//
//		/**
//		 * 削除に失敗したかどうかを確認する.
//		 *
//		 * @param  e      FaultEvent
//		 * @return 削除有無.
//		 */
//		public static function isDeleteFault(e:FaultEvent):Boolean
//		{
//			var faultText:String = e.fault.faultString;
//			if (faultText.indexOf(FAULT_EXCEPTION_DELETE) >= 0) 	return true;
//			else 													return false;
//		}
//


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
	}
}