package subApplications.personnelAffair.logic
{
    import flash.events.*;
    import flash.net.*;
    
    import logic.Logic;
    
    import mx.binding.utils.BindingUtils;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.core.Application;
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.states.*;
    import mx.validators.Validator;
    
    import subApplications.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
    import subApplications.personnelAffair.web.AuthorizedLicenceEntryDlg;
    
	/**
	 * AuthorizedLicenceEntryDlgのLogicクラスです。

	 */
	public class AuthorizedLicenceEntryDlgLogic extends Logic
	{
	    /** カテゴリ名コンボボックス */
		[Bindable]
		public var _licenseLabel:ArrayCollection;
		
		/** 資格名コンボボックス */
		[Bindable]
		public var _mainlicenseLabel:ArrayCollection;
		
		/** カテゴリID */
		public var _categoryId:int;
		
		/** ログイン者ID */
		public var inStaffId:int = Application.application.indexLogic.loginStaff.staffId;
			
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function AuthorizedLicenceEntryDlgLogic()
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
	    	_licenseLabel = view.data.category;	
	    	_mainlicenseLabel = view.data.license;
	    	
	    	/** 必要な変数をバインド */
	    	// 「認定資格情報一覧(カテゴリ名)」にバインドする
	   		BindingUtils.bindProperty(view.cmbCategory, "dataProvider", this, "_licenseLabel");

	    	// 「認定資格情報一覧(資格名)」にバインドする
	   		BindingUtils.bindProperty(view.cmbLicence, "dataProvider", this, "_mainlicenseLabel");
	   		
	    	// titleに任意のtitleNameを設定
	    	this.view.title = view.data.titleName;
	    	
	    	// 社員名を設定
   			view.lblStaffName.text = view.data.staffName;
   			
   			searchLicenceListFilter();
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
			
			var staffAuthorizedLicenceDto:StaffAuthorizedLicenceDto = new StaffAuthorizedLicenceDto();
			
			staffAuthorizedLicenceDto.staffId = view.data.staffId;
			staffAuthorizedLicenceDto.acquisitionDate = view.dtfWorkStatusDate.selectedDate;
			staffAuthorizedLicenceDto.categoryId = view.cmbCategory.selectedItem.categoryId;
			staffAuthorizedLicenceDto.licenceId = view.cmbLicence.selectedItem.licenceId;
			staffAuthorizedLicenceDto.registrantId = inStaffId;
						
			// 追加(登録)
			if(view.data.titleName == "認定資格登録")
			{	
				// 認定資格重複チェック
				for each(var addAuthorizedData:StaffAuthorizedLicenceDto in view.data.authorizedLicenceHistory)
				{						
					// 対象社員IDと等しい場合
					if(addAuthorizedData.licenceId == staffAuthorizedLicenceDto.licenceId)
					{
						// エラーダイアログ表示
						Alert.show( addAuthorizedData.licenceName + "は入力済みです。", "Error",
									Alert.OK, null, null, null, Alert.OK);
						return;
					}
				}
				
				// 追加(登録)の実行
				view.authorizedLicenceService.getOperation("insertAuthorizedLicence").send(staffAuthorizedLicenceDto);
		
			}
			// 変更(更新)
			else if(view.data.titleName == "認定資格変更")
			{		
				// 認定資格重複チェック
				for each(var changeAuthorizedData:StaffAuthorizedLicenceDto in view.data.authorizedLicenceHistory)
				{						
					// 対象社員IDと等しい場合
					if(changeAuthorizedData.licenceId == staffAuthorizedLicenceDto.licenceId)
					{
						// エラーダイアログ表示
						Alert.show( changeAuthorizedData.licenceName + "は入力済みです。", "Error",
									Alert.OK, null, null, null, Alert.OK);
						return;
					}
				}
				
				staffAuthorizedLicenceDto.sequenceNo = view.data.updateData.sequenceNo;
				
				// 変更(更新)の実行
				view.authorizedLicenceService.getOperation("updateAuthorizedLicence").send(staffAuthorizedLicenceDto);
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
		public function onClose_authorizedLicenceEntryDlg(e:CloseEvent):void
		{
			// PopUpをCloseする.
			PopUpManager.removePopUp(view);
		}
		
		/**
		 * カテゴリコンボボックスの変更.
		 *
		 * @param e FlexEventイベント.
		 */
		public function onChange_licenseLabel(e:ListEvent):void
		{	
			_mainlicenseLabel.refresh();
		}

		/**
	     * 保存ボタン制御
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
		
//--------------------------------------
//  Function
//--------------------------------------

		public function searchLicenceListFilter():void
		{
	    	_mainlicenseLabel.filterFunction = authorizedLicenceFilter;
	    	_mainlicenseLabel.refresh();
	    	
	    	if(view.data.titleFlag == false){
	   			view.cmbCategory.selectedData = view.data.updateData.categoryId.toString();
	   			_mainlicenseLabel.refresh();
	   			view.cmbLicence.selectedData = view.data.updateData.licenceId.toString();
	   			view.dtfWorkStatusDate.selectedDate = view.data.updateData.acquisitionDate;
	   		}	
		}

		/**
		 * 認定資格フィルタ処理
		 * 認定資格カテゴリに該当する認定資格を返す
		 * */
		public function authorizedLicenceFilter(obj:Object):Boolean
		{
			if(view.cmbCategory.selectedItem.categoryId == obj.categoryId){
				return true;
			}else{
				return false;
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
		 * DB接続エラー・不正なパラメータなどで発生
		 * */
		 public function onFault_remoteObject(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("DB接続失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		 /**
		 * 保存エラー発生
		 * */
		 public function onFault_failureSave(e: FaultEvent):void
		{
		 	trace("更新失敗");
		 	Alert.show("保存に失敗しました。","",
		 			Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:AuthorizedLicenceEntryDlg;

	    /**
	     * 画面を取得します

	     */
	    public function get view():AuthorizedLicenceEntryDlg
	    {
	        if (_view == null) {
	            _view = super.document as AuthorizedLicenceEntryDlg;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:AuthorizedLicenceEntryDlg):void
	    {
	        _view = view;
	    }

	}    
}