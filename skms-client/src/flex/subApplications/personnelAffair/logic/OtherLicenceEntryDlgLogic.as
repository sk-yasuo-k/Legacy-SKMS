package subApplications.personnelAffair.logic
{
    import flash.events.*;
    import flash.net.*;
    
    import logic.Logic;
    
    import mx.controls.*;
    import mx.core.Application;
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.states.*;
    import mx.validators.Validator;
    
    import subApplications.personnelAffair.skill.dto.StaffOtherLocenceDto;
    import subApplications.personnelAffair.web.OtherLicenceEntryDlg;
    
	/**
	 * OtherLicenceEntryDlgのLogicクラスです。

	 */
	public class OtherLicenceEntryDlgLogic extends Logic
	{	
		/** 社員ID(社員情報選択時) */
		public var _staffId:int;
		
		/** 社員名(社員情報選択時) */
		public var _staffName:String;

		/** ログイン者ID */
		public var inStaffId:int = Application.application.indexLogic.loginStaff.staffId;
	    
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function OtherLicenceEntryDlgLogic()
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
	    	// titleに任意のtitleNameを設定
	    	this.view.title = view.data.titleName;
	    	
   			view.lblStaffName.text = view.data.staffName;
   			
   			onValidateCheck(null);
   			
   			// 変更の場合
			if(view.data.titleName == "その他資格変更")
			{	
				view.dtfWorkStatusDate.selectedDate = view.data.updateAcquisitionDate;
				view.LicenceNote.text = view.data.updateLicenceName;
			}
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * OKボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onClick_btnOk(e:Event):void
		{
			// PopUpのCloseイベントを作成する.
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);
			
			var staffOtherLocenceDto:StaffOtherLocenceDto = new StaffOtherLocenceDto();
			
			staffOtherLocenceDto.staffId = view.data.staffId;
			staffOtherLocenceDto.acquisitionDate = view.dtfWorkStatusDate.selectedDate;
			staffOtherLocenceDto.licenceName = view.LicenceNote.text;
			staffOtherLocenceDto.registrantId = inStaffId;
			
			// その他資格重複チェック(完全一致のみ)
			for each(var addOtherData:StaffOtherLocenceDto in view.data.otherLicenceList)
			{						
				// 対象社員IDと等しい場合
				if(addOtherData.licenceName == staffOtherLocenceDto.licenceName)
				{
					// エラーダイアログ表示
					Alert.show( addOtherData.licenceName + "は入力済みです。", "Error",
								Alert.OK, null, null, null, Alert.OK);
					return;
				}
			}
			
			// 追加(登録)
			if(view.data.titleName == "その他資格登録")
			{		
				// 追加(登録)の実行
				view.authorizedLicenceService.getOperation("insertOtherLicence").send(staffOtherLocenceDto);
		
			}
			// 変更(更新)
			else if(view.data.titleName == "その他資格変更")
			{	
				staffOtherLocenceDto.sequenceNo = view.data.updateSequenceNo;

				// 変更(更新)の実行
				view.authorizedLicenceService.getOperation("updateOtherLicence").send(staffOtherLocenceDto);
			}
		}

		/**
		 * キャンセルボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onClick_btnCancel(e:Event):void
		{
		 	// PopUpのCloseイベントを作成する.
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
			view.dispatchEvent(ce);
		}


		/**
		 * Closeボタンの押下.
		 *
		 * @param e Closeイベント.
		 */
		public function onClose_otherLicenceEntryDlg(e:CloseEvent):void
		{
			// PopUpをCloseする.
			PopUpManager.removePopUp(view);
		}
	    
//--------------------------------------
//  Function
//--------------------------------------
		/**
	     * 保存ボタン押下制御
	     *
	     */
		public function onValidateCheck(e:Event):void
		{
			// mxml定義のvalidateチェックを行なう.
			var results:Array = Validator.validateAll(view.validateItems);
			if (results.length != 0)
			{
				view.btnOk.enabled = false;
			}
			else
			{
				view.btnOk.enabled = true;
			}
		}

		/**
		 * 更新成功
		 */
		public function onResult_JoinLicense(e: ResultEvent):void
		{
			trace("更新成功");	
			
			// 確認ダイヤルログ表示
			Alert.show("更新に成功しました。", "",
					Alert.OK, null, null, null, Alert.OK);	
			
			// PopUpのCloseイベントを作成する.
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);
		}
		 
		/**
		 * 更新失敗
		 * */
		 public function onFault_failureSave(e: FaultEvent):void
		{
		 	trace("更新失敗");
		 	Alert.show("更新に失敗しました。","",
		 			Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		}
		
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:OtherLicenceEntryDlg;

	    /**
	     * 画面を取得します

	     */
	    public function get view():OtherLicenceEntryDlg
	    {
	        if (_view == null) {
	            _view = super.document as OtherLicenceEntryDlg;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:OtherLicenceEntryDlg):void
	    {
	        _view = view;
	    }

	}    
}