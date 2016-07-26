package subApplications.personnelAffair.logic
{
    import flash.events.*;
    import flash.net.*;
    
    import logic.Logic;
    
    import mx.binding.utils.BindingUtils;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.core.Application;
    import mx.core.IDataRenderer;
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.states.*;
    
    import subApplications.lunch.dto.StaffDtoList;
    import subApplications.personnelAffair.dto.StaffAuthorizedLocenceListDto;
    import subApplications.personnelAffair.dto.StaffOtherLocenceListDto;
    import subApplications.personnelAffair.skill.dto.MAuthorizedLicenceCategoryListDto;
    import subApplications.personnelAffair.skill.dto.MAuthorizedLicenceListDto;
    import subApplications.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
    import subApplications.personnelAffair.skill.dto.StaffOtherLocenceDto;
    import subApplications.personnelAffair.web.AuthorizedLicenceEntryDlg;
    import subApplications.personnelAffair.web.Licence;
    import subApplications.personnelAffair.web.OtherLicenceEntryDlg;
    
    import utils.CommonIcon;
    
	/**
	 * LicenceのLogicクラスです。

	 */
	public class LicenceLogic extends Logic
	{
		/** タイトルフラグ */
		public var titleFlag:Boolean = true;
	    
	    /** 社員情報リスト*/
		[Bindable]
		public var _mStaffSelect:ArrayCollection;
		
		/** 社員認定資格情報リスト*/
		[Bindable]
		public var _authorizedLicenceList:ArrayCollection;
		
		public var _searchLicenceList:ArrayCollection;
		
		/** 社員その他資格情報リスト*/
		[Bindable]
		public var _otherLicenceList:ArrayCollection;

		public var _searchOtherLicenceList:ArrayCollection;
		
		/** カテゴリ名コンボボックス*/
		[Bindable]
		public var _category:ArrayCollection;
		
		/** 資格名コンボボックス */
		[Bindable]
		public var _license:ArrayCollection;
		
		/** 社員ID(社員情報選択時) */
		public var _staffId:int;
		
		/** 社員名(社員情報選択時) */
		public var _staffName:String;
		
		/** 社員ID(資格情報選択時) */
		public var updateStaffId:int;
		
		/** カテゴリID(資格情報選択時) */
		public var updateCategoryId:int;
		
		/** カテゴリ名(資格情報選択時) */
		public var updateCategoryName:String;		
		
		/** 資格ID(資格情報選択時) */
		public var updateLicenceId:int;
		
		/** 資格名(資格情報選択時) */
		public var updateLicenceName:String;
		
		/** 資格連番(資格情報選択時) */
		public var updateSequenceNo:int;
		
		/** 取得日(資格情報選択時) */
		public var updateAcquisitionDate:Date;	

		/** 画面初期化フラグ */		
		public var allFalsehFlag:Boolean = false;
			
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function LicenceLogic()
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
	    	// 社員一覧の取得
	    	view.authorizedLicenceService.getOperation("getMStaffList").send();
	    	// 認定資格カテゴリーマスタの取得
	    	view.authorizedLicenceService.getOperation("getMAuthorizedLicenceCategory").send();	    	
	    	
	    	/** 必要な変数をバインド */ 
	    	// 「社員一覧」にバインドする
	    	BindingUtils.bindProperty(view.mStaffList, "dataProvider", this, "_mStaffSelect");
	    	// 「認定資格一覧」にバインドする
	    	BindingUtils.bindProperty(view.authorizedLicenceList, "dataProvider", this, "_authorizedLicenceList");    	
	    	// 「その他資格一覧」にバインドする
	    	BindingUtils.bindProperty(view.otherLicenceList, "dataProvider", this, "_otherLicenceList");    	
	    	
	    	// 権限判定
	    	var button:Boolean = Application.application.indexLogic.loginStaff.isAuthorisationProfile();
	    	
	    	// 権限を持つ社員の場合
	    	if(button == false)
	    	{
	    		// 各ボタンを非表示に設定する
		    	view.linkAddAuthorizedLicence.visible = false
		    	view.linkUpdateAuthorizedLicence.visible = false
		    	view.linkDeleteAuthorizedLicence.visible = false
		    	view.linkAddOtherLicence.visible = false
		    	view.linkUpdateOtherLicence.visible = false
		    	view.linkDeleteOtherLicence.visible = false
	    	}
	    	
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 	検索該当イベント処理
		 *
		 *
		 */
	    public function onClick_checkBox(e:FlexEvent):void
	    {	
	    	// 社員名チェックボックスがtrueの場合
			if(view.checkStaff.selected == true){view.textSearchStaff.enabled = true}
			else{view.textSearchStaff.enabled = false}

			// 認定資格カテゴリ名チェックボックスがtrueの場合
			if(view.checkCategory.selected == true){view.cmbSearchCategory.enabled = true}
			else{view.cmbSearchCategory.enabled = false}
			
			// 認定資格名チェックボックスがtrueの場合
			if(view.checkLicence.selected == true){view.cmbSearchLicence.enabled = true}
			else{view.cmbSearchLicence.enabled = false}
			
			// その他資格名チェックボックスがtrueの場合
			if(view.checkOther.selected == true){view.textSearchOther.enabled = true}
			else{view.textSearchOther.enabled = false}
			
			_license.refresh();	
	    }
	    
		/**
		 * 	「検索」リンクボタンクリックイベント処理
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_btnSearch(e:MouseEvent):void
	    {
	    	_authorizedLicenceList = new ArrayCollection();
	    	_otherLicenceList = new ArrayCollection();
	    	
	    	if(view.checkStaff.selected == false && view.checkCategory.selected == false
	    			&& view.checkLicence.selected == false && view.checkOther.selected == false){
		    	// 社員一覧の取得
		    	view.authorizedLicenceService.getOperation("getMStaffList").send();	    		
	    	}else{
	    		orderProcessing();
	    	}
	    }
	    
		/**
		 * 	認定資格「追加」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkAddAuthorizedLicence(e:MouseEvent):void
	    {
			// 認定資格登録画面を作成する.
			openAuthorizedLicenceEntryDlg();
	    }
	    
		/**
		 * 	認定資格「変更」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkUpdateAuthorizedLicence(e:MouseEvent):void
	    {	
	    	// タイトルフラグ(変更)
	    	titleFlag = false;
	    	
			// 認定資格登録画面を作成する.
			// TODO:選ばれた行の認定資格情報を引数にセット
			openAuthorizedLicenceEntryDlg();
	    }
	    
		/**
		 * 	認定資格「削除」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkDeleteAuthorizedLicence(e:MouseEvent):void
	    {
			Alert.show("削除してもよろしいですか？", "", Alert.YES | Alert.NO, view, onClose_deleteAuthorizedLicenceAlert, CommonIcon.questionIcon);
	    }
	    
		/**
		 * 	その他資格「追加」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkAddOtherLicence(e:MouseEvent):void
	    {
			// その他資格登録画面を作成する.
			openOtherLicenceEntryDlg(null);
	    }
	    
		/**
		 * 	その他資格「変更」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkUpdateOtherLicence(e:MouseEvent):void
	    {	
	    	// タイトルフラグ(変更)
	    	titleFlag = false;
	    	
			// その他資格登録画面を作成する.
			// TODO:選ばれた行のその他資格情報を引数にセット
			openOtherLicenceEntryDlg(null);
	    }
	    
		/**
		 * 	その他資格「削除」リンクボタンクリックイベント処理.
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_linkDeleteOtherLicence(e:MouseEvent):void
	    {
			Alert.show("削除してもよろしいですか？",
			 "",
			  Alert.YES | Alert.NO,
			   view,
			    onClose_deleteOtherLicenceAlert,
			    CommonIcon.questionIcon);
	    }
	    
		/**
		 * リンクボタン選択 検索条件の表示.
		 *
		 */
		public function onClick_linkShowSearchCondition(e:MouseEvent):void
		{	
			//vbxShowSearchConditionを検索ボックスに切り替える
			this.view.currentState = "search";			
	    	// 「資格カテゴリコンボボックス」にバインドする
	    	BindingUtils.bindProperty(view.cmbSearchCategory, "dataProvider", this, "_category");	
	    	// 「認定資格コンボボックス」にバインドする
	    	BindingUtils.bindProperty(view.cmbSearchLicence, "dataProvider", this, "_license");
		}

		/**
		 * リンクボタン選択 閉じる.
		 *
		 */
		public function onClick_linkHideSearchCondition(e:MouseEvent):void
		{				
			//vbxShowSearchConditionを初期表示に切り替える
			this.view.currentState = "initialize";
		}

		/**
		 * 資格カテゴリコンボボックス変更処理.
		 *
		 */
		public function onChange_category(e:ListEvent):void
		{
			_license.refresh();	
		}

		/**
		 * AuthorizedLicenceEntryDlg(認定資格登録)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onClose_authorizedLicenceEntryDlg(e:CloseEvent):void
		{
			// 「OK」ボタンで終了した場合.
			if(e.detail == Alert.OK)
			{
				// 社員IDを取得する.
				_staffId = view.mStaffList.selectedItem.staffId;
				
		    	// 認定資格一覧の取得
		    	view.authorizedLicenceService.getOperation("getAuthorizedLicenceList").send(_staffId);
			}
		}
	    
		/**
		 * OtherLicenceEntryDlg(その他資格登録)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onClose_otherLicenceEntryDlg(e:CloseEvent):void
		{
			// 「OK」ボタンで終了した場合.
			if(e.detail == Alert.OK)
			{
				// 社員IDを取得する.
				_staffId = view.mStaffList.selectedItem.staffId;
		    	
		    	// その他資格一覧の取得
		    	view.authorizedLicenceService.getOperation("getOtherLicenceList").send(_staffId);
			}
		}

	    /**
	     * 認定資格削除 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		private function onClose_deleteAuthorizedLicenceAlert(e:CloseEvent):void
		{
			// 「OK」ならば.
			if (e.detail == Alert.YES) 
			{
				// TODO:資格削除処理
				var staffAuthorizedLicenceDto:StaffAuthorizedLicenceDto = new StaffAuthorizedLicenceDto();
					
				// 選択中のDataGrid情報を格納する
	    		staffAuthorizedLicenceDto = view.authorizedLicenceList.selectedItem as StaffAuthorizedLicenceDto;
				
				// 削除の実行
				view.authorizedLicenceService.getOperation("deleteAuthorizedLicence").send(staffAuthorizedLicenceDto);
			}
		}

	    /**
	     * その他資格削除 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		private function onClose_deleteOtherLicenceAlert(e:CloseEvent):void
		{
			// 「OK」ならば.
			if (e.detail == Alert.YES) 
			{
				// TODO:資格削除処理
				var staffOtherLocenceDto:StaffOtherLocenceDto = new StaffOtherLocenceDto();
					
				// 選択中のDataGrid情報を格納する
	    		staffOtherLocenceDto.staffId = updateStaffId;
		    	staffOtherLocenceDto.licenceName = updateLicenceName;
		    	staffOtherLocenceDto.acquisitionDate = updateAcquisitionDate;
		    	staffOtherLocenceDto.sequenceNo = updateSequenceNo;
				
				// 削除の実行
				view.authorizedLicenceService.getOperation("deleteOtherLocence").send(staffOtherLocenceDto);
			}
		}
		
		/**
		 * 任意で選択した社員情報を取得
		 */
		public function onClick_staffSelect(e:ListEvent):void
		{	
			// 社員IDを取得する.
			_staffId = view.mStaffList.selectedItem.staffId;
			
	    	// 認定資格一覧の取得
	    	view.authorizedLicenceService.getOperation("getAuthorizedLicenceList").send(_staffId);
	    	
	    	// その他資格一覧の取得
	    	view.authorizedLicenceService.getOperation("getOtherLicenceList").send(_staffId);

	    	// 認定資格登録可能
	    	view.linkAddAuthorizedLicence.enabled = true;
	    	
	    	// その他資格登録可能
	    	view.linkAddOtherLicence.enabled = true;
	    	
	    	// 認定資格変更・削除不可能
    		view.linkUpdateAuthorizedLicence.enabled = false
    		view.linkDeleteAuthorizedLicence.enabled = false
    		
    		// その他資格変更・削除不可能
    		view.linkUpdateOtherLicence.enabled = false
    		view.linkDeleteOtherLicence.enabled = false
		}
		
		/**
		 *認定資格「変更」「削除」押下制御
		 * DataGrid上のデータを取得する
		 */
		public function onClick_authorizedLicenceSelect(e:ListEvent):void
		{
			// 認定資格変更・削除可能
			view.linkUpdateAuthorizedLicence.enabled = true
	    	view.linkDeleteAuthorizedLicence.enabled = true
	    	
    		// 選択中のDataGrid情報を格納する
    		updateStaffId = e.itemRenderer.data.staffId;
 			updateCategoryId = e.itemRenderer.data.categoryId;
 			updateCategoryName = e.itemRenderer.data.categoryName;
	    	updateLicenceId = e.itemRenderer.data.licenceId;
	    	updateLicenceName = e.itemRenderer.data.licenceName;
	    	updateAcquisitionDate = e.itemRenderer.data.acquisitionDate;
	    	updateSequenceNo = e.itemRenderer.data.sequenceNo;
		}
		
		/**
		 *その他資格「変更」「削除」押下制御
		 * DataGrid上のデータを取得する
		 */
		public function onClick_otherLicenceSelect(e:ListEvent):void
		{
			// その他資格変更・削除可能
			view.linkUpdateOtherLicence.enabled = true
	    	view.linkDeleteOtherLicence.enabled = true
	    	
    		// 選択中のDataGrid情報を格納する
    		updateStaffId = e.itemRenderer.data.staffId;
	    	updateLicenceName = e.itemRenderer.data.licenceName;
	    	updateAcquisitionDate = e.itemRenderer.data.acquisitionDate;
	    	updateSequenceNo = e.itemRenderer.data.sequenceNo;
		}

//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * AuthorizedLicenceEntryDlg(認定資格登録)のオープン.
		 *
		 * @param authorizedLicenceHistory 認定資格取得履歴.
		 */
		private function openAuthorizedLicenceEntryDlg():void
		{	
			var array:Array = new Array();
			
			// 認定資格登録画面を作成する.
			var pop:AuthorizedLicenceEntryDlg = new AuthorizedLicenceEntryDlg();
			PopUpManager.addPopUp(pop, view, true);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// 認定資格取得履歴をセット
			obj.authorizedLicenceHistory = _authorizedLicenceList;
			// 社員名をセット
			obj.staffName = view.mStaffList.selectedItem.fullName;
			// 社員IDをセット
			obj.staffId = view.mStaffList.selectedItem.staffId;
			// 認定資格カテゴリをセット
			obj.category = _category;			
			// 認定資格をセット
			obj.license = _license;			
			// 選択中のDataGrid情報を格納する
			obj.updateData = view.authorizedLicenceList.selectedItem as StaffAuthorizedLicenceDto;
			
			obj.titleFlag = titleFlag;
					
			// タイトルフラグがtrue(登録)の場合			
			if(titleFlag == true)
			{
				// タイトルフラグがtrue(登録)の場合
				obj.titleName = "認定資格登録";
			}
			else
			{
				// タイトルフラグがfalse(変更)の場合
				obj.titleName = "認定資格変更";
				
				// タイトルフラグ(登録)
	    		titleFlag = true;		
			}	
			
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_authorizedLicenceEntryDlg);
			
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);
		}
		
		/**
		 * OtherLicenceEntryDlg(その他資格登録)のオープン.
		 *
		 * @param otherLicenceHistory その他資格取得履歴.
		 */
		private function openOtherLicenceEntryDlg(otherLicenceHistory:Object):void
		{	
			var array:Array = new Array();
			
			// その他資格登録画面を作成する.
			var pop:OtherLicenceEntryDlg = new OtherLicenceEntryDlg();
			PopUpManager.addPopUp(pop, view, true);

			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// 認定資格取得履歴をセット
			obj.otherLicenceHistory = otherLicenceHistory;
			// 社員名をセット
			obj.staffName = view.mStaffList.selectedItem.fullName;
			// 社員IDをセット
			obj.staffId = view.mStaffList.selectedItem.staffId;
			
			// 認定資格取得情報をセット
			for each(var otherData:StaffOtherLocenceDto in _otherLicenceList)
			{
				var tmp:StaffOtherLocenceDto = new StaffOtherLocenceDto();
				
				tmp.staffId = otherData.staffId;
				tmp.licenceName = otherData.licenceName;
				
				// 対象社員IDと等しい場合
				if(otherData.staffId == _staffId)
				{
					array.push(tmp);
				}
			}
			
			// DTOの型に変換したものを、objに追加する
			obj.otherLicenceList = new ArrayCollection(array);
			
			// 選択中のDataGrid情報を格納する
    		obj.updateStaffId = updateStaffId;
    		obj.updateLicenceName = updateLicenceName;
    		obj.updateAcquisitionDate = updateAcquisitionDate;	
    		obj.updateSequenceNo = updateSequenceNo;
			
			// タイトルフラグがtrue(登録)の場合
			if(titleFlag == true)
			{
				// タイトルフラグがtrue(登録)
				obj.titleName = "その他資格登録";
			}
			else
			{
				// タイトルフラグがfalse(変更)
				obj.titleName = "その他資格変更";
				
				// タイトルフラグ(登録)
	    		titleFlag = true;   	
			}
			
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_otherLicenceEntryDlg);
			
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);
		}

		/**
		 * 社員一覧をDBから取得成功
		 * 社員一覧を表示
		 * */
		public function onResult_showMStaffList(e: ResultEvent):void
		{
			trace("onResult_showMStaffList...");		
			var staffList:StaffDtoList = new StaffDtoList(e.result);
			_mStaffSelect = staffList.staffList;
		}

		/**
		 * 認定資格マスタをDBから取得成功
		 * 認定資格マスタを表示
		 * */
		public function onResult_showMAuthorizedLicence(e: ResultEvent):void
		{
			trace("onResult_showMAuthorizedLicence...");
			var mAuthorizedLicenceList:MAuthorizedLicenceListDto = new MAuthorizedLicenceListDto(e.result);
			_license = mAuthorizedLicenceList.mAuthorizedLicenceList;
			_license.filterFunction = authorizedLicenceFilter;
		}		

		/**
		 * 認定資格フィルタ処理
		 * 認定資格カテゴリに該当する認定資格を返す
		 * */
		public function authorizedLicenceFilter(obj:Object):Boolean
		{
			if(view.checkCategory.selected == true){
				if(obj != null){
					if(view.cmbSearchCategory.selectedItem.categoryId == obj.categoryId){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return true;
			}
		}	

		/**
		 * 認定資格カテゴリーマスタをDBから取得成功
		 * 認定資格カテゴリーマスタを表示
		 * */
		public function onResult_showMAuthorizedLicenceCategory(e: ResultEvent):void
		{
			trace("onResult_showMAuthorizedLicenceCategory...");		
			var mAuthorizedLicenceCategoryList:MAuthorizedLicenceCategoryListDto = new MAuthorizedLicenceCategoryListDto(e.result);
			_category = mAuthorizedLicenceCategoryList.mAuthorizedLicenceCategoryList;
			
			// 認定資格マスタの取得
	    	view.authorizedLicenceService.getOperation("getMAuthorizedLicence").send();
		}
		
		/**
		 * 社員情報フィルタ処理
		 * StaffIDに該当する社員名を返す
		 * */
		public function mStaffFilter(obj:Object):Boolean
		{	
			var bool:Boolean;
			
			if(!(view.checkLicence.selected == false && view.checkCategory.selected == false)){
				bool = false;
				for each(var tmp:StaffAuthorizedLicenceDto in _searchLicenceList){
					if(obj.staffId == tmp.staffId){
						bool = true;
					}
				}

				if(view.checkOther.selected == true){
					if(bool){
						if(view.textSearchOther.length != 0){
							bool = false;
							for each(var tmp2:StaffOtherLocenceDto in _searchOtherLicenceList){
								if( tmp2.licenceName.indexOf(view.textSearchOther.text) >= 0 ){
									if(obj.staffId == tmp2.staffId){
										bool = true;
									}	
								}								
							}
						}
					}	
				}
				
				if(view.checkStaff.selected == true){
					if(bool){
						if(view.textSearchStaff.length != 0){
							bool = false;
							
							if( obj.fullName.indexOf(view.textSearchStaff.text) >= 0 ){
								bool = true;
							}				
						}
					}			
				}
			}else if(view.checkOther.selected == true){
				if(view.textSearchOther.length != 0){
					bool = false;
					for each(var tmp3:StaffOtherLocenceDto in _searchOtherLicenceList){
						if( tmp3.licenceName.indexOf(view.textSearchOther.text) >= 0 ){
							if(obj.staffId == tmp3.staffId){
								bool = true;
							}	
						}
					}								
				}
				
				if(view.checkStaff.selected == true){
					if(bool){
						if(view.textSearchStaff.length != 0){
							bool = false;
							
							if( obj.fullName.indexOf(view.textSearchStaff.text) >= 0 ){
								bool = true;
							}				
						}
					}			
				}
			}else if(view.checkStaff.selected == true){
				if(view.textSearchStaff.length != 0){
					bool = false;
					
					if( obj.fullName.indexOf(view.textSearchStaff.text) >= 0 ){
						bool = true;
					}				
				}
			}
			
			return bool;
		}

		/**
		 * 社員所持認定資格マスタをDBから取得成功
		 * 社員所持認定資格マスタを表示
		 * */
		public function onResult_showAuthorizedLicenceList(e: ResultEvent):void
		{
			trace("onResult_showAuthorizedLicenceList...");
						
			var staffAuthorizedLicenceListDto:StaffAuthorizedLocenceListDto = new StaffAuthorizedLocenceListDto(e.result);
			_authorizedLicenceList = staffAuthorizedLicenceListDto.StaffAuthorizedLocenceList;
		}

		/**
		 * 社員所持その他資格マスタをDBから取得成功
		 * 社員所持その他資格マスタを表示
		 * */
		public function onResult_showotherLicenceList(e: ResultEvent):void
		{
			trace("onResult_showotherLicenceList...");	
			
			var staffOtherLocenceListDto:StaffOtherLocenceListDto = new StaffOtherLocenceListDto(e.result);
			_otherLicenceList = staffOtherLocenceListDto.StaffOtherLocenceList;	
		}	

		/**
		 * 検索結果一覧をDBから取得成功
		 * 検索結果一覧を表示
		 * */
		public function onResult_showSearchLicenceList(e: ResultEvent):void
		{
			trace("onResult_showSearchLicenceList...");	
			var staffAuthorizedLicenceListDto:StaffAuthorizedLocenceListDto = new StaffAuthorizedLocenceListDto(e.result);
			_searchLicenceList = staffAuthorizedLicenceListDto.StaffAuthorizedLocenceList;
			
			if(view.checkOther.selected == true){
	    		view.authorizedLicenceService.getOperation("getSearchOtherLicenceList").send();
	    	}else{
	    		searchLicenceListFilter();
	    	}
		}

		public function onResult_showSearchOtherLicenceList(e: ResultEvent):void
		{
			trace("onResult_showSearchOtherLicenceList...");	
			var staffOtherLocenceListDto:StaffOtherLocenceListDto = new StaffOtherLocenceListDto(e.result);
			_searchOtherLicenceList = staffOtherLocenceListDto.StaffOtherLocenceList;
			
			searchLicenceListFilter();
		}	


		public function searchLicenceListFilter():void
		{
			_mStaffSelect.filterFunction = mStaffFilter;
			_mStaffSelect.refresh();			
		}

		/**
		 * 検索処理
		 * 検索結果一覧を表示
		 * */
		public function orderProcessing():void
		{
	    	var licenceId:String = "";
	    	var categoryId:String = "";
	    	
	    	if(view.cmbSearchLicence.selectedIndex >= 0){
		    	if(view.checkLicence.selected == true){
		    		licenceId = view.cmbSearchLicence.selectedData;
		    	}else if(view.checkCategory.selected == true){
	    			categoryId = view.cmbSearchCategory.selectedData;
		    	}
		    	
		    	if(!(view.checkLicence.selected == false && view.checkCategory.selected == false)){
					view.authorizedLicenceService.getOperation("getSearchLicenceList").send(licenceId, categoryId);
		    	}else if(view.checkOther.selected == true){
		    		view.authorizedLicenceService.getOperation("getSearchOtherLicenceList").send();
		    	}else if(view.checkStaff.selected == true){
		    		searchLicenceListFilter();
		    	}
		    }	
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
		 * 更新成功
		 */
		public function onResult_JoinLicense(e: ResultEvent):void
		{
			trace("更新成功");	
			
			// 社員IDを取得する.
			_staffId = view.mStaffList.selectedItem.staffId;			
	    	// 認定資格一覧の取得
	    	view.authorizedLicenceService.getOperation("getAuthorizedLicenceList").send(_staffId);
	    	// その他資格一覧の取得
	    	view.authorizedLicenceService.getOperation("getOtherLicenceList").send(_staffId);
			
			// 確認ダイヤルログ表示
			Alert.show("更新に成功しました。", "",
					Alert.OK, null, null, null, Alert.OK);	
		}

		 /**
		 * 保存エラー発生
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
	    public var _view:Licence;

	    /**
	     * 画面を取得します

	     */
	    public function get view():Licence
	    {
	        if (_view == null) {
	            _view = super.document as Licence;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:Licence):void
	    {
	        _view = view;
	    }

	}    
}