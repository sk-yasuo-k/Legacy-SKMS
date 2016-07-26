package subApplications.personnelAffair.skill.logic
{
	import components.PopUpWindow;
	
	import flash.events.*;
	import flash.net.*;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.*;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.*;
	import mx.managers.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.states.*;
	import mx.utils.ObjectUtil;
	
	import subApplications.personnelAffair.skill.dto.ExperienceYearsDto;
	import subApplications.personnelAffair.skill.dto.SkillStaffDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillListDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillSheetDto;
	import subApplications.personnelAffair.skill.web.*;
	
	
	/**
	 * 業務履歴ロジッククラス
	 * 
	 * @author yoshinori-t
	 */
	public class SkillSheetLogic extends Logic
	{
		/**
		 * インポート時のURL
		 */
	    private const importURL:String = "/skms-server/skillSheetFileImport";
	    
		/**
		 * EXCEL出力時のURL
		 */
	    private const exportURL:String = "/skms-server/skillSheetFileExport";
	    
		/**
		 * 社員ID
		 */
		[Bindable]
		public var _staffId:int;
		
		/**
		 * 社員詳細
		 */
		[Bindable]
		public var _staffDetail:SkillStaffDto;
		
		/**
		 * 取得資格
		 */
		[Bindable]
		public var _authorizedLicence:String;
		
		/**
		 * 取得免許
		 */
		[Bindable]
		public var _otherLocence:String;
		
		/**
		 * スキルシートリストDto
		 */
		private var _staffSkillListDto:StaffSkillListDto;
		
		/**
		 * スキルシートリスト
		 */
		[Bindable]
		public var _staffSkillList:ArrayCollection;
		
		/**
		 * 経験年数(制御系)
		 */
		[Bindable]
		public var _control:Number = 0.0;
		
		/**
		 * 経験年数(業務系)
		 */
		[Bindable]
		public var _open:Number = 0.0;
		
		/**
		 * 経験年数(保守)
		 */
		[Bindable]
		public var _maintenance:Number = 0.0;
		
		/**
		 * 登録画面用作成・変更用データ(選択されたスキルシート)
		 */
		public var createSkillSheetData:StaffSkillSheetDto = new StaffSkillSheetDto();;
		
		/**
		 * ファイル参照オブジェクト
		 */
	    private var refAddFiles:FileReferenceList;
		
		/**
		 * ファイルアップロードオブジェクト
		 */
	    private var refUploadFile:FileReference;
		
	    
		/**
		 * コンストラクタ
		 */
		public function SkillSheetLogic()
		{
			super();
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
		}
		
		/**
		 * 画面が呼び出されたとき最初に実行される
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// 必要な変数をバインド
			BindingUtils.bindProperty(view.skillSheetHeader.staffDetail, "dataProvider", this, "_staffDetail");
			BindingUtils.bindProperty(view.skillSheetHeader.authorizedLicence, "text", this, "_authorizedLicence");
			BindingUtils.bindProperty(view.skillSheetHeader.otherLocence, "text", this, "_otherLocence");
			BindingUtils.bindProperty(view.skillSheetFooter.history, "dataProvider", this, "_staffSkillList");
			BindingUtils.bindProperty(view.skillSheetFooter.control, "text", this, "_control");
			BindingUtils.bindProperty(view.skillSheetFooter.open, "text", this, "_open");
			BindingUtils.bindProperty(view.skillSheetFooter.maintenance, "text", this, "_maintenance");
			
			// ログイン者の社員IDを設定する.
			_staffId = Application.application.indexLogic.loginStaff.staffId;
			
			// ボタン有効/無効制御実施
			enableButton();
			
			// スキルシートリストのドラッグ＆ドロップを有効にする
			view.skillSheetFooter.setEnableDragDrop(true);
		}
		
		/**
		 * スキルシートリスト選択イベント処理
		 */
		public function onItemClickHistoryList(e:ListEvent):void
		{
			// ボタン有効/無効制御実施
			enableButton();
		}
		
		/**
		 * スキルシートリストドラッグ＆ドロップ完了イベント処理
		 */
		public function onDragCompleteHistoryList(e:DragEvent):void
		{
			// データ変更状態に更新
			setModifiedStatus(true);
			
			// ボタン有効/無効制御実施
			enableButton();
		}
		
		/**
		 * 新規作成ボタン押下処理
		 */
		public function onClick_linkList_new(e:MouseEvent):void
		{
			// データ準備
			var obj:Object = new Object();
			createSkillSheetData = new StaffSkillSheetDto();
			createSkillSheetData.staffId = _staffId;	// 社員IDを設定しておく
			obj.createSkillSheetData = createSkillSheetData;
			
			// 登録画面の表示
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(SkillSheetEntry, view, obj);
			
			// 登録画面クローズ時イベントの登録
			pop.addEventListener(CloseEvent.CLOSE, onClose_entry);
		}
		
		/**
		 * 変更ボタン押下処理
		 */
		public function onClick_linkList_modify(e:MouseEvent):void
		{
			// データ準備
			var obj:Object = new Object();
			var dto:StaffSkillSheetDto = view.skillSheetFooter.history.selectedItem as StaffSkillSheetDto;
			createSkillSheetData = ObjectUtil.copy(dto) as StaffSkillSheetDto;
			obj.createSkillSheetData = createSkillSheetData;
			
			// 登録画面の表示
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(SkillSheetEntry, view, obj);
			
			// 登録画面クローズ時イベントの登録
			pop.addEventListener(CloseEvent.CLOSE, onClose_entry);
		}
		
		/**
		 * 登録画面クローズ時イベント
		 *
		 * @param e Closeイベント.
		 */
		protected function onClose_entry(e:CloseEvent):void
		{
			trace("onClose_entry...");
			
			// プロジェクト選択画面でOKボタンを押下したとき.
			if (e.detail == Alert.OK) {
				// 一覧の更新を行う
				_staffSkillList = _staffSkillListDto.updateStaffSkillRecord(_staffId, createSkillSheetData);
				
				// データ変更状態に更新
				setModifiedStatus(true);
				
				// ボタン有効/無効制御実施
				enableButton();
			}
		}
		
		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_linkList_delete(e:MouseEvent):void
		{
			// 確認ダイアログ表示
			Alert.show("削除してもよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						onClick_linkList_deleteResult, null, Alert.CANCEL);
		}
		
		/**
		 * 削除ボタン押下処理(本処理)
		 */
		public function onClick_linkList_deleteResult(e:CloseEvent):void
		{
			// 確認ダイアログでOKボタンを押下したとき.
			if ( e.detail == Alert.OK )
			{
				// 選択行のデータを取得
				var dto:StaffSkillSheetDto = view.skillSheetFooter.history.selectedItem as StaffSkillSheetDto;
				
				// 一覧の更新を行う
				_staffSkillList = _staffSkillListDto.deleteStaffSkillRecord(dto);
				
				// データ変更状態に更新
				setModifiedStatus(true);
				
				// ボタン有効/無効制御実施
				enableButton();
			}
		}
		
		/**
		 * 保存ボタン押下処理
		 */
		public function onClick_linkList_update(e:MouseEvent):void
		{
			// 確認ダイアログ表示
			Alert.show("保存してもよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						onClick_linkList_updateResult,null, Alert.CANCEL);
		}
		
		/**
		 * 保存ボタン押下処理(本処理)
		 */
		public function onClick_linkList_updateResult(e:CloseEvent):void
		{
			// 確認ダイアログでOKボタンを押下したとき.
			if ( e.detail == Alert.OK )
			{
				// 更新の実行
				view.skillSheetService.getOperation("updateSkillSheetList").send(
									Application.application.indexLogic.loginStaff.staffId,
									_staffSkillList);
			}
		}
		
		/**
		 * スキルシート更新成功イベント
		 */
		public function onResult_updateSkillSheetList(e:ResultEvent):void
		{
			trace("onResult_updateSkillSheet...");
			
			// 確認ダイアログ表示
			Alert.show("保存に成功しました。", "",
						Alert.OK, null,
						null, null, Alert.OK);
			
			// スキルシートリストの再取得を行う
			view.skillSheetService.getOperation("getStaffSkillList").send(_staffId);
		}
		
		/**
		 * スキルシート更新失敗イベント
		 */
		public function onFault_updateSkillSheetList(e:FaultEvent):void
		{
			trace("onFault_updateSkillSheetList...");
			
			// エラーダイアログ表示
			Alert.show("保存に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}
		
		/**
		 * 取消ボタン押下処理
		 */
		public function onClick_linkList_cancel(e:MouseEvent):void
		{
			// 確認ダイアログ表示
			Alert.show("入力されたデータを破棄します。\nよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						onClick_linkList_cancelResult, null, Alert.CANCEL);
		}
		
		/**
		 * 取消ボタン押下処理(本処理)
		 */
		public function onClick_linkList_cancelResult(e:CloseEvent):void
		{
			// 確認ダイアログでOKボタンを押下したとき.
			if ( e.detail == Alert.OK )
			{
				// スキルシートリストの再取得を行う
				view.skillSheetService.getOperation("getStaffSkillList").send(_staffId);
			}
		}
		
		/**
		 * インポートボタン押下処理
		 */
		public function onClick_linkList_import(e:MouseEvent):void
		{
			// ファイル選択ダイアログの表示
	        refAddFiles = new FileReferenceList();
	        refAddFiles.addEventListener(Event.SELECT, onSelectFile);
	        refAddFiles.browse();
		}
		
		/**
		 * インポートボタン押下処理(ファイル選択後)
		 */
		public function onSelectFile(event:Event):void
		{
			trace("onSelectFile...");
			
			if ( refAddFiles.fileList.length == 0 )
			{
				// エラーダイアログ表示
				Alert.show("ファイルを選択してください。", "Error",
							Alert.OK, null,
							null, null, Alert.OK);
				return;
			}
			else if ( refAddFiles.fileList.length > 1 )
			{
				// エラーダイアログ表示
				Alert.show("ファイルは1件のみ選択してください。", "Error",
							Alert.OK, null,
							null, null, Alert.OK);
				return;
			}
			
			// HTTPリクエストの準備
			var request:URLRequest = new URLRequest(importURL);
			request.method = URLRequestMethod.GET;
			// パラメータを用意
			var variables:URLVariables = new URLVariables();
			variables.staffId = Application.application.indexLogic.loginStaff.staffId;		// 登録社員者ID
			variables.isManagementMode = false;												// 管理者モード
			request.data = variables;
			refUploadFile = refAddFiles.fileList[0];	// 選択したファイルの情報
			// リスナーの登録
			refUploadFile.addEventListener(Event.COMPLETE, onUploadComplete);							// アップロード完了イベントのリスナー登録
			refUploadFile.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteData);		// サーバー応答イベントのリスナー登録
			refUploadFile.addEventListener(ProgressEvent.PROGRESS, onUploadProgress);					// アップロード中PROGRESSイベントのリスナー登録
			refUploadFile.addEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);						// アップロード中I/Oエラー発生イベントのリスナー登録
			refUploadFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);	// アップロード中セキュリティエラー発生イベントのリスナー登録
			// HTTPリクエストの送信
			refUploadFile.upload(request, "file", false);
		}
		
		/**
		 * アップロード完了イベント
		 */
		private function onUploadComplete(event:Event):void
		{
			trace("onUploadComplete...");
		}
		
		/**
		 * サーバー応答イベント
		 */
	    private function onUploadCompleteData(event:DataEvent):void
	    {
			trace("onUploadCompleteData...");
			
			var xml:XML = new XML(event.data);
			var result:Number = parseInt(xml.result);
			var message:String = xml.message;
			
			// インポート成功
			if ( result == 0 )
			{
				// 完了ダイアログ表示
				Alert.show("インポートが完了しました。", "",
							Alert.OK, null,
							null, null, Alert.OK);
				
				// スキルシートリストの再取得を行う
				view.skillSheetService.getOperation("getStaffSkillList").send(_staffId);
			}
			// インポート失敗
			else
			{
				// エラーダイアログ表示
				Alert.show(message, "",
							Alert.OK, null,
							null, null, Alert.OK);
			}
	    }
	    
		/**
		 * アップロード中PROGRESSイベント
		 */
		private function onUploadProgress(event:ProgressEvent):void
		{
			trace("onUploadProgress...");
			trace("loaded#" + event.bytesLoaded + " bytes");
			trace("total #" + event.bytesTotal + " bytes");
		}
	    
	    /**
	     * アップロードキャンセルイベント
	     */
		private function onUploadCanceled(event:Event):void
		{
			trace("onUploadCanceled...");
			
			// アップロード状態解除処理
			clearUpload();
		}
	    
		/**
		 * アップロード中I/Oエラー発生イベント
		 */
		private function onUploadIoError(event:IOErrorEvent):void
		{
			trace("onUploadIoError...");
			
			// エラーダイアログ表示
			Alert.show("ファイルのアップロードに失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
			
			// アップロード状態解除処理
			clearUpload();
		}
		
		/**
		 * アップロード中セキュリティエラー発生イベント
		 */
		private function onUploadSecurityError(event:SecurityErrorEvent):void
		{
			trace("onUploadSecurityError...");
			
			// エラーダイアログ表示
			Alert.show("ファイルのアップロードに失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
			
			// アップロード状態解除処理
			clearUpload();
		}
		
		/**
		 * アップロード状態解除処理
		 */
	    private function clearUpload():void
	    {
	    	// リスナー登録の解除
	        refUploadFile.removeEventListener(Event.COMPLETE, onUploadComplete);
			refUploadFile.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteData);
	        refUploadFile.removeEventListener(ProgressEvent.PROGRESS, onUploadProgress);
	        refUploadFile.removeEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
	        refUploadFile.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
	        
	    	// キャンセルの実行
	        refUploadFile.cancel();
	    }
	    
		/**
		 * Excel形式出力ボタン押下処理
		 */
		public function onClick_linkList_export(e:MouseEvent):void
		{
			// HTTPリクエストの準備
			var request:URLRequest = new URLRequest(exportURL);
			request.method = URLRequestMethod.POST;
			// パラメータを用意
			var variables:URLVariables = new URLVariables();
			variables.staffId = _staffId;
			request.data = variables;
			// HTTPリクエストの送信
			navigateToURL(request, "_blank");
		}
		
		/**
		 * データ変更状態設定.
		 */
		private function setModifiedStatus(modified:Boolean):void
		{
			// データ変更有無のセット
			Application.application.indexLogic.modified = modified;
		}
		
		/**
		 * ボタン有効/無効制御処理
		 */
		public function enableButton():void
		{
			// 選択している一覧情報を取得する
			var obj:Object = view.skillSheetFooter.history.selectedItem;
			
			// 一覧の選択状態を判定する
			var enabledSelect:Boolean = ( obj != null );
			
			// 変更有無を判定する
			var enabledModify:Boolean = Application.application.indexLogic.modified;
			
			// ボタン制御実行
			view.modifyB.enabled = enabledSelect;			// 変更ボタン
			view.deleteB.enabled = enabledSelect;			// 削除ボタン
			view.updateB.enabled = enabledModify;			// 保存ボタン
			view.cancelB.enabled = enabledModify;			// 取消ボタン
		}
		
		/**
		* 社員詳細取得成功イベント
		*/
		public function onResult_getStaffDetail(e:ResultEvent):void
		{
			trace("onResult_getStaffDetail...");
			
			// フィールドの社員詳細を更新
			var result:ArrayCollection = e.result as ArrayCollection;
			if ( result.length > 0 ) _staffDetail = result[0];
		}
		
		/**
		 * スキルシートリスト取得成功イベント
		 */
		public function onResult_getStaffSkillList(e:ResultEvent):void
		{
			trace("onResult_getStaffSkillList...");
			
			// スキルシートリストを更新する
			_staffSkillListDto = new StaffSkillListDto(e.result);
			_staffSkillList = _staffSkillListDto.StaffSkillList;
			
			// データ未変更状態に更新
			setModifiedStatus(false);
			
			// ボタン有効/無効制御実施
			enableButton();
		}
		
		/**
		 * 業務履歴データ取得失敗イベント
		 */
		public function onFault_getInformation(e:FaultEvent):void
		{
			trace("onFault_getInformation...");
			
			// エラーダイアログ表示
			Alert.show("業務履歴データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}
		
		/**
		 * プロパティ変更時イベント
		 */
		private function propertyChangeHandler(e:PropertyChangeEvent):void
		{
			// 社員IDが変更されたかどうかを判定する.
			if (e.property == "_staffId")
			{
				view.skillSheetService.getOperation("getStaffDetail").send(_staffId);
				view.skillSheetService.getOperation("getStaffSkillList").send(_staffId);
			}
			// 社員詳細が変更されたかどうかを判定する.
			else if ( e.property == "_staffDetail" )
			{
				// 取得資格
				_authorizedLicence = _staffDetail.staffAuthorizedLicenceName;
				// 取得免許
				_otherLocence = _staffDetail.staffOtherLocenceName;
			}
			// スキルシートリストが変更されたかどうかを判定する
			else if ( e.property == "_staffSkillList" )
			{
				// 経験年数(制御系/業務系/保守)
				var experienceYearsDto:ExperienceYearsDto = _staffSkillListDto.experienceYearsDto;
				_control = experienceYearsDto.control;
				_open = experienceYearsDto.open;
				_maintenance = experienceYearsDto.maintenance;
			}
		}
		
		
		/** 画面 */
		public var _view:SkillSheet;

		/**
		 * 画面を取得します.
		 */
		public function get view():SkillSheet
		{
			if (_view == null)
			{
				_view = super.document as SkillSheet;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします.
		 *
		 * @param view セットする画面
		 */
		public function set view(view:SkillSheet):void
		{
			_view = view;
		}
	}
}