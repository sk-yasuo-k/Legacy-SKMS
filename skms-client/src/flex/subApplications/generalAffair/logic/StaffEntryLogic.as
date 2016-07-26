package subApplications.generalAffair.logic
{
    import dto.LabelDto;
    
    import flash.events.*;
    import flash.net.*;
    
    import mx.binding.utils.BindingUtils;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.core.Application;
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.states.*;
    import mx.utils.ObjectUtil;
    import mx.validators.Validator;
    
    import subApplications.generalAffair.dto.AcademicBackgroundDto;
    import subApplications.generalAffair.dto.AddressApplyDto;
    import subApplications.generalAffair.dto.BusinessCareerDto;
    import subApplications.generalAffair.dto.MPrefectureListDto;
    import subApplications.generalAffair.dto.MStaffNameDto;
    import subApplications.generalAffair.dto.NewMStaffDto;
    import subApplications.generalAffair.dto.StaffDetailDto;
    import subApplications.generalAffair.dto.StaffEntryDto;
    import subApplications.generalAffair.web.StaffEntry;
    import subApplications.personnelAffair.license.dto.MBasicClassListDto;
    import subApplications.personnelAffair.license.dto.MBasicRankDto;
    import subApplications.personnelAffair.license.dto.MBasicRankListDto;
    import subApplications.personnelAffair.license.dto.MPayLicenceHistoryDto;
    
	/**
	 * StaffEntryのLogicクラスです。
	 */
	public class StaffEntryLogic extends AccountingLogic
	{
		/** 都道府県リスト*/
		[Bindable]
		public var _mPrefectureList:ArrayCollection;
		
		/** 血液型コンボボックスリスト */
		private var bloodTypeArray:Array = [
											 {label:"A型"},
											 {label:"B型"},
											 {label:"AB型"},
											 {label:"O型"}
											 ];
		[Bindable]
		public var bloodGroup:ArrayCollection = new ArrayCollection(bloodTypeArray);	
		
		/** 性別コンボボックスリスト */
		private var sexTypeArray:Array = [
										   {label:"男"},
										   {label:"女"}
										   ];									  									  								  
		[Bindable]
		public var sexGroup:ArrayCollection = new ArrayCollection(sexTypeArray);
		
		/** 住所画面作成フラグ*/
		[Bindable]
		public var addressFromFlag:Boolean;

		/** 学歴 */						  
		[Bindable]
		public var staffentryLogicDetailArray:ArrayCollection = new ArrayCollection();
		
		/** 職歴 */	
		[Bindable]
		public var staffentryLogicDetailBusinessCareerArray:ArrayCollection = new ArrayCollection();
		
		/** ログイン者ID */
		public var inStaffId:int = Application.application.indexLogic.loginStaff.staffId;

		/** 表示中の新入社員情報リスト */
		private var _displayStaffList:ArrayCollection = new ArrayCollection();
		
		/** 等級 */	
		[Bindable]
		public var _basicClass:ArrayCollection = new ArrayCollection();	
		
		/** 号 */	
		[Bindable]
		public var _basicRank:ArrayCollection = new ArrayCollection();	
		
		/** 今期 */	
		public var nowPeriod:int = 0;	
		
//--------------------------------------
//  Constructor
//--------------------------------------

	    /**
	     * コンストラクタ
	     */
		public function StaffEntryLogic()
		{
			super();
			
			//　住所作成フラグの初期値を「false」に設定する
			addressFromFlag = false; 
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
			
			/** DBデータの取得 */
			// 都道府県名の取得
	    	view.staffEntryService.getOperation("getContinentList").send();
	    	// 等級マスタの取得
	    	view.staffEntryService.getOperation("getBasicClassPayList").send();
	    	// 基本給マスタの取得
	    	view.staffEntryService.getOperation("getBasicPayList").send();
	    	
	    	/** 必要な変数をバインド */ 
	    	// 「都道府県名」にバインドする
	    	BindingUtils.bindProperty(view.cmbdomicileOriginCode, "dataProvider", this, "_mPrefectureList");
	    	
	    	// 「性別」にバインドする
	    	BindingUtils.bindProperty(view.cmbSex, "dataProvider", this, "sexGroup");
	    	
	    	// 「血液型」にバインドする
	    	BindingUtils.bindProperty(view.cmbBloodGroup, "dataProvider", this, "bloodGroup");
	    	
	    	// 「等級」にバインドする
	    	BindingUtils.bindProperty(view.basicPyaClassNo, "dataProvider", this, "_basicClass");	    	
	    	
	    	// 「号」にバインドする
	    	BindingUtils.bindProperty(view.basicPayRankNo, "dataProvider", this, "_basicRank");
	    }
	    
	    /**
	     * 引き継ぎデータの取得.
	     *
	     */
		override protected function onCreationCompleteHandler_setSuceedData():void
		{
			_actionView = ACTION_NEW;
		}
		
		/**
		 * onCreationCompleteHandler_setDisplayData
		 *
		 * @param e FlexEvent
		 */
	    public function onCreationComplete_tabStaffEntry(e:FlexEvent):void
		{
			// 一覧の初期データを設定する.
			view.staffentryLogicDetail.rowCount     = ROW_COUNT_EDIT;
			view.staffentryLogicDetail.actionMode   = _actionView;
    		// 新規のときは 空データを設定する.
    		_selectedStaffDto = new StaffEntryDto();

			// 一覧を作成する. 
			this.staffentryLogicDetailArray = makeTable_StaffDetail(_selectedStaffDto.StaffDetails);
			BindingUtils.bindProperty(view.staffentryLogicDetail, "dataProvider", this, "staffentryLogicDetailArray");
			
			// 画面を表示する.
			view.visible = true;
		}
		
		/**
		 * onCreationCompleteHandler_setDisplayData
		 *
		 * @param e FlexEvent
		 */
	    public function onCreationComplete_tabStaffEntryBusinessCareer(e:FlexEvent):void
		{
			// 一覧の初期データを設定する.
			view.staffentryLogicDetailBusinessCareer.rowCount     = ROW_COUNT_EDIT;
			view.staffentryLogicDetailBusinessCareer.actionMode   = _actionView;
    		// 新規のときは 空データを設定する.
    		_selectedStaffDto = new StaffEntryDto();

			// 一覧を作成する. 
			this.staffentryLogicDetailBusinessCareerArray = makeTable_StaffDetail(_selectedStaffDto.StaffDetails);
			BindingUtils.bindProperty(view.staffentryLogicDetailBusinessCareer, "dataProvider", this, "staffentryLogicDetailBusinessCareerArray");
			
			// 画面を表示する.
			view.visible = true;
		}
		
		/**
		 *  初期化(確認ダイヤログ)
		 * 
		 */
		public function onClick_confirmFormat(e:Event):void
	    {
	    	// 確認ダイアログ表示
			Alert.show("初期化してもよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						onClick_Format,null, Alert.CANCEL);
	    }
		
		/**
		 * 初期化ボタンの押下.
		 *
		 * @param e MouseEvent
		 */	
		public function onClick_Format(e:CloseEvent):void
		{
			// 確認ダイアログでOKボタンを押下したとき.
			if ( e.detail == Alert.OK )
			{
				onClick_manFormat();
			}	
		}	
		/**
		 *  初期化(メイン処理)
		 * 
		 */	
		public function onClick_manFormat():void
			{			
				
				// ■■■■■■■■■■■■
				// ■　個人情報　　　　　■
				// ■■■■■■■■■■■■
				
				view.LoginName.text = "";
				view.lastName.text = "";
				view.firstName.text = "";
				view.lastNameKana.text = "";
				view.firstNameKana.text = "";
				view.cmbSex.prompt = "選択してください";
				view.cmbBloodGroup.prompt = "選択してください";
				view.txdateField.text = "";
				view.presentAge.text = "";
				view.cmbdomicileOriginCode.text = "選択してください";
				view.emergencyAddress.text = "";
				
				// ■■■■■■■■■■■■
				// ■　　　　住所　　　　■
				// ■■■■■■■■■■■■

				// 住所の画面生成完了の場合
				if(addressFromFlag == true)
				{
					// 住所初期化処理呼び出し
					view.addressForm.onClick_addressFormat()
				}
				
				// ■■■■■■■■■■■■
				// ■　　学歴・学歴　　　■
				// ■■■■■■■■■■■■	
								
				// 学歴・職歴の画面生成完了の場合
		  		if((view.staffentryLogicDetail != null) && (view.staffentryLogicDetailBusinessCareer != null))
		  		{	
		  			// 学歴の初期化
		  			this.staffentryLogicDetailArray = makeTable_StaffDetail(_selectedStaffDto.StaffDetails);
		  			
		  			// 職歴の初期化
		  			this.staffentryLogicDetailBusinessCareerArray = makeTable_StaffDetail(_selectedStaffDto.StaffDetails);
		  		}
		  		
		  		// 経験年数初期化
				if(view.experienceYears != null)
				{
				view.experienceYears.text = "";
				}
				
				// バインドデータ初期化
				onCreationCompleteHandler(null);
			}
			
		/**
		 * 検索日時算出処理
		 */
		public function initializeTime():void
		{	
			var nowTime:Date = new Date;

	    	// 初期表示の期間、期を設定する
	    	if(nowTime.month <= 10)
	    	{
	    		// 現在の期を格納
	    		nowPeriod = ((nowTime.fullYear - 1984) -1);
	    	}
	    	else
	    	{
	    		// 現在の期を格納
	    		nowPeriod = (nowTime.fullYear - 1984);
	    	}
		}
//--------------------------------------
//  UI Event Handler
//--------------------------------------
		/**
		 * 職歴・学歴の編集終了.
		 *
		 * @param e ListEvent or KeyboardEvent
		 */
		public function onItemFocusOut_StaffDetail(e:Event):void
		{
			// 職歴・学歴一覧を設定する.
			var ac:ArrayCollection = view.staffentryLogicDetail.dataProvider as ArrayCollection;
			if (ac.length == view.staffentryLogicDetail.selectedIndex+1) {
				var staff:StaffDetailDto =
				view.staffentryLogicDetail.dataProvider.getItemAt(view.staffentryLogicDetail.selectedIndex) as StaffDetailDto;
				if (staff.checkEntry()) {
					onClick_linkList_add();
				}
			}
        }
	    /**
	     * 学歴。職歴行追加.
	     *
	     */
		protected function onClick_linkList_add():void
		{
			// 交通費明細一覧を設定する.
			var ac:ArrayCollection = view.staffentryLogicDetail.dataProvider as ArrayCollection;
			ac.addItem(new StaffDetailDto());
			view.staffentryLogicDetail.validateNow();
			view.staffentryLogicDetail.dataProvider.refresh();
			view.staffentryLogicDetail.scrollToIndex(ac.length-1);
		}

		/**
		 * 職歴・学歴の編集終了.
		 *
		 * @param e ListEvent or KeyboardEvent
		 */
		public function onItemFocusOut_StaffDetailBusinessCareer(e:Event):void
		{
			// 職歴・学歴一覧を設定する.
			var ac:ArrayCollection = view.staffentryLogicDetailBusinessCareer.dataProvider as ArrayCollection;
			if (ac.length == view.staffentryLogicDetailBusinessCareer.selectedIndex+1) {
				var staff:StaffDetailDto =
				view.staffentryLogicDetailBusinessCareer.dataProvider.getItemAt(view.staffentryLogicDetailBusinessCareer.selectedIndex) as StaffDetailDto;
				if (staff.checkEntry()) {
					onClick_linkList_add_BusinessCareer();
				}
			}
        }
	    /**
	     * 学歴。職歴行追加.
	     *
	     */
		protected function onClick_linkList_add_BusinessCareer():void
		{
			// 交通費明細一覧を設定する.
			var ac:ArrayCollection = view.staffentryLogicDetailBusinessCareer.dataProvider as ArrayCollection;
			ac.addItem(new StaffDetailDto());
			view.staffentryLogicDetailBusinessCareer.validateNow();
			view.staffentryLogicDetailBusinessCareer.dataProvider.refresh();
			view.staffentryLogicDetailBusinessCareer.scrollToIndex(ac.length-1);
		}

		/**
		 * 年齢算出(※生年月日にnull以外が存在)
		 * 年齢を表示
		 * */	
		public function onClick_ageCalculate():void
		{			
			// 生年月日にnull以外が存在
			if(view.txdateField.text != "")
			{
			// 現在日時を取得する		
			var today:Date = new Date();
			
			// 現在日時を設定する
			var y1:int = (today.fullYear);
			var m1:int = ((today.month) + 1);
			var d1:int = today.date;
			
			// 生年月日入力判定
			if(view.txdateField.selectedDate == null)
			{	
				// 強制初期化
				view.txdateField.text = "";
				
				// エラーダイヤルログ表示
				Alert.show("年齢が算出できません。", "",
				Alert.OK, null, null, null, Alert.OK);
				
				return;
			}
			
			// 生年月日を設定する
			var y2:int = (view.txdateField.selectedDate.fullYear);
			var m2:int = ((view.txdateField.selectedDate.month) + 1);
			var d2:int = view.txdateField.selectedDate.date;
			
			// 年齢計算用に編集する
			var y3:int = y1 * 10000;
			var m3:int = m1 * 100;
			var y4:int = y2 * 10000;
			var m4:int = m2 * 100;
			
			// 年齢を算出する
			var age:int = (int(y3 + m3 + d1) - int(y4 + m4 + d2)) / 10000;
			
			// 年齢を画面に表示
			view.presentAge.text = String(age);
			}
			else
			{
			// 初期化
			view.presentAge.text = "";	
			}	
		}
		
		/**
		 * 住所画面作成フラグ
		 * 
		 * */	
		public function onClick_addressFromFlag(e:Event):void
		{
			addressFromFlag = true;
		}

		/**
		 * 等級変更イベント
		 * 
		 * */	
		public function onChange_basicClass(e:Event):void
		{
			_basicRank.refresh();
			view.basicPayRankNo.selectedIndex = 0;
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
					
				// 住所のバインドが完了している場合
				if (addressFromFlag == true)
				{	
					// mxml定義のvalidateチェックを行なう.(住所)	
					if (view.addressForm.btnOkFlag == true)
					{
						view.btnOk.enabled = true;
					}
					else
					{
						view.btnOk.enabled = false;
					}
				}
				else
				{
					view.btnOk.enabled = false;
				}
			}
			// 年齢算出関数呼び出し	
			onClick_ageCalculate();
		}

		/**
		 * 保存ボタンの押下.
		 *
		 * @param e MouseEvent
		 */
		public function onButtonClick_entry_confirm(e:MouseEvent):void
		{
			Alert.show("保存してもよろしいですか？", "", 3, view, onButtonClick_entry_confirmResult);
		}
		

		/**
		 * 保存ボタン押下判定処理.
		 *
		 * @param e CloseEvent
		 */
		protected function onButtonClick_entry_confirmResult(e:CloseEvent):void
		{
			if (e.detail == Alert.YES)	onButtonClick_entry(e);
		}

		/**
		 * 保存ボタン押下処理.
		 *
		 * @param e Event
		 */		
		protected function onButtonClick_entry(e:Event):void
		{
			var newMStaffDto:NewMStaffDto = new NewMStaffDto();
			var dtoCombo:LabelDto = view.cmbdomicileOriginCode.selectedItem as LabelDto;			
			
			// ■■■■■■■■■■■■
			// ■　個人情報　　　　　■
			// ■■■■■■■■■■■■
			
			newMStaffDto.loginName = view.LoginName.text;
			newMStaffDto.email = null;
			newMStaffDto.birthday = view.txdateField.selectedDate;
			newMStaffDto.school = null;
			newMStaffDto.department = null;
			newMStaffDto.course = null;
			newMStaffDto.emergencyAddress = view.emergencyAddress.text;
			newMStaffDto.registrantId = inStaffId;
			newMStaffDto.registrationTime = null;
			
			// 経験年数判定処理
			if(view.experienceYears == null)
			{
				newMStaffDto.experienceYears = "0";
			}
			else
			{
				newMStaffDto.experienceYears = view.experienceYears.text;
			}
			
			// 都道府県判定処理
			if(view.cmbdomicileOriginCode.selectedLabel == "")
			{
				newMStaffDto.legalDomicileCode = null;
			}
			else
			{
				if(dtoCombo.data <= 9)
				{
					newMStaffDto.legalDomicileCode = "0" + dtoCombo.data.toString();
				}
				else
				{
					newMStaffDto.legalDomicileCode = dtoCombo.data.toString();
				}
			}
			
			// 性別判定処理
			if(view.cmbSex.text == "男")
			{
				newMStaffDto.sex = 1;
			}
			else if(view.cmbSex.text == "女")
			{
				newMStaffDto.sex = 2;
			}
			
			// 血液型判定処理
			if(view.cmbBloodGroup.text == "A型")
			{
				newMStaffDto.blood_group = 1;
			}
			else if(view.cmbBloodGroup.text == "B型")
			{
				newMStaffDto.blood_group = 2;
			}
			else if(view.cmbBloodGroup.text == "O型")
			{
				newMStaffDto.blood_group = 3;
			}			
			else if(view.cmbBloodGroup.text == "AB型")
			{
				newMStaffDto.blood_group = 4;
			}

			// ■■■■■■■■■■■■
			// ■　個人情報(名前)　　■
			// ■■■■■■■■■■■■
			
			var staffNameDto:MStaffNameDto = new MStaffNameDto();
			
			staffNameDto.updateCount = 1;
			staffNameDto.lastName = view.lastName.text;
			staffNameDto.lastNameKana = view.lastNameKana.text;
			staffNameDto.firstName = view.firstName.text;
			staffNameDto.firstNameKana = view.firstNameKana.text;
			staffNameDto.registrantId = inStaffId;
			staffNameDto.registrationTime = null;

			// ■■■■■■■■
			// ■　社内資格　■
			// ■■■■■■■■
			
			var mPayLicenceHistoryDto:MPayLicenceHistoryDto = new MPayLicenceHistoryDto();
			
			var nowPeriod:int;
			var dateYear:int = (new Date).fullYear;
			var dateMonth:int = ((new Date).month + 1);
			
			// 検索日時算出処理呼び出し
			initializeTime();
			
			// 初期表示の期間、期を設定する
	    	if(dateMonth <= 10)
	    	{nowPeriod = ((dateYear - 1984) -1);}
	    	else
	    	{nowPeriod = (dateYear - 1984);}

			mPayLicenceHistoryDto.periodId = nowPeriod;
			mPayLicenceHistoryDto.basicPayId = view.basicPayRankNo.selectedItem.basicPayId;
			mPayLicenceHistoryDto.basicPayClassNo = view.basicPyaClassNo.selectedItem.classId;
			mPayLicenceHistoryDto.basicPayClassNoName = view.basicPyaClassNo.selectedItem.className;		
			mPayLicenceHistoryDto.basicPayRankNo = view.basicPayRankNo.selectedItem.rankNo;
			mPayLicenceHistoryDto.basicPayMonthlySum = view.basicPayRankNo.selectedItem.monthlySum;
			
			// ■■■■■■■■■■■■
			// ■　　　　住所　　　　■
			// ■■■■■■■■■■■■
			
			var addressApplyDto:AddressApplyDto = new AddressApplyDto();
			var dtoCombo2:LabelDto = view.addressForm.AdministrativeDivisions.selectedItem as LabelDto;
			
			addressApplyDto.moveDate = view.addressForm.Moveday.selectedDate;
			addressApplyDto.postalCode1 = view.addressForm.newPostalCode1.text;
			addressApplyDto.postalCode2 = view.addressForm.newPostalCode2.text;
			addressApplyDto.prefectureCode = dtoCombo2.data;
			addressApplyDto.updateCount = 1;
			addressApplyDto.ward = view.addressForm.Municipality.text;
			addressApplyDto.wardKana = view.addressForm.MunicipalityKana.text;
			addressApplyDto.houseNumber = view.addressForm.newHouseNumber.text;
			addressApplyDto.houseNumberKana = view.addressForm.newHouseNumberKana.text;
			addressApplyDto.homePhoneNo1 = view.addressForm.CarryContact1.text;
			addressApplyDto.homePhoneNo2 = view.addressForm.CarryContact2.text;
			addressApplyDto.homePhoneNo3 = view.addressForm.CarryContact3.text;
			addressApplyDto.householderFlag = view.addressForm.HouseholdCheck.selected;
			addressApplyDto.nameplate = "";
			addressApplyDto.associateStaff = "";
			addressApplyDto.registrantId = inStaffId;
			addressApplyDto.registrationTime = null;
				
			// ■■■■■■■■■■■■
			// ■　　　　学歴　　　　■
			// ■■■■■■■■■■■■	
			
			// エラー行カウンタ
			var errorCount:int = 1;
			
			var sequenceNo:int = 1;
			var tmpArray:Array = new Array();
			
			for each(var object:StaffDetailDto in this.staffentryLogicDetailArray)
			{	
				var academicBackgroundDto:ArrayCollection;
				var tmp:AcademicBackgroundDto = new AcademicBackgroundDto();
				
				tmp.sequenceNo = sequenceNo;
				tmp.occuredDate = object.AcademicBackgroundDate;
				tmp.content = object.AcademicBackgroundDatenote;
				tmp.registrantId = inStaffId;
				tmp.registrationTime = null;
				
				// 日付・備考がnull以外の場合
				if(!((object.AcademicBackgroundDate == null)&&(isHoge(object.AcademicBackgroundDatenote) == true)))
				{
					// 日付(null)の場合
					if(object.AcademicBackgroundDate == null)
					{	
						// エラーダイヤルログ表示
						Alert.show("学歴" + errorCount + "行目の日付が正しくありません。", "",
						Alert.OK, null, null, null, Alert.OK);
						
						return;
					}
					
					// 内容(true)の場合
					if(isHoge(object.AcademicBackgroundDatenote) == true)
					{
						Alert.show("学歴" + errorCount + "行目の備考が正しくありません。", "",
						Alert.OK, null, null, null, Alert.OK);
						
						return;
					}

					// 学歴を格納する
					tmpArray.push(tmp);
					sequenceNo = sequenceNo + 1
				}
				// エラーカウント(+1)
				errorCount = errorCount + 1			
			}
			
			// DTOの型に変換したものを、リストに追加する
			academicBackgroundDto = new ArrayCollection(tmpArray);
			
			// ■■■■■■■■■■■■
			// ■　　　　職歴　　　　■
			// ■■■■■■■■■■■■	
			
			// エラー行カウンタ(初期化)
			errorCount = 1;
			
			// 行カウンタ(初期化)
			sequenceNo = 1;
			
			var tmpArray2:Array = new Array();
			
			for each(var object2:StaffDetailDto in this.staffentryLogicDetailBusinessCareerArray)
			{	
				var businessCareerDto:ArrayCollection;
				var tmp2:BusinessCareerDto = new BusinessCareerDto();
				
				tmp2.sequenceNo = sequenceNo;
				tmp2.occuredDate = object2.AcademicBackgroundDate;
				tmp2.content = object2.AcademicBackgroundDatenote;
				tmp2.registrantId = inStaffId;
				tmp2.registrationTime = null;
				
				// 日付・備考がnull以外の場合
				if(!((object2.AcademicBackgroundDate == null)&&(isHoge(object2.AcademicBackgroundDatenote) == true)))
				{
					// 日付(null)の場合
					if(object2.AcademicBackgroundDate == null)
					{	
						// エラーダイヤルログ表示
						Alert.show("職歴" + errorCount + "行目の日付が正しくありません。", "",
						Alert.OK, null, null, null, Alert.OK);
						
						return;
					}
						
					// 内容(true)の場合
					if(isHoge(object2.AcademicBackgroundDatenote) == true)
					{	
						// エラーダイヤルログ表示
						Alert.show("職歴" + errorCount + "行目の備考が正しくありません。", "",
						Alert.OK, null, null, null, Alert.OK);
						
						return;
					}
					// 職歴を格納する
					tmpArray2.push(tmp2);
					sequenceNo = sequenceNo + 1	
				}
				
				// エラーカウント(+1)
				errorCount = errorCount + 1	
			}

			// DTOの型に変換したものを、リストに追加する
			businessCareerDto = new ArrayCollection(tmpArray2);

			// 入社日を設定する
			var enterday:Date = new Date(view.postaldateField.text);

			// 追加の実行
			view.staffEntryService.getOperation("insertLinkMStaff").send(newMStaffDto,staffNameDto,addressApplyDto,academicBackgroundDto,businessCareerDto,mPayLicenceHistoryDto,nowPeriod,enterday);
		}
		
		// 項目null判定処理(学歴・職歴)
		private function isHoge(string:String):Boolean
		{
			if( string == null)
			{
				return true;
			}
			if(string == ""  || string == " ")
			{
				return true;
			}
			return false;
		}
		/**
		 * 一覧行数の調整.
		 *
		 * @param  ac 交通費申請明細リスト.
		 * @return 調整済みの交通費申請明細リスト.
		 */
		private function makeTable_StaffDetail(ac:ArrayCollection):ArrayCollection
		{
			// 一覧表示行分のデータを作成する.
			var copy:ArrayCollection = ac ? ObjectUtil.copy(ac) as ArrayCollection : new ArrayCollection();
			var acLength:int         = ac ? ac.length                              : 0;
			for (var i:int = 0; i < (ROW_COUNT_EDIT - acLength) ; i++) {
				var dto:StaffDetailDto = new StaffDetailDto();
				copy.addItem(dto);
			}

			// index >= ROW_COUNT_EDIT の空データを削除する.
			var cpLength:int = copy.length;
			for (var lastIndex:int = cpLength - 1; lastIndex >= ROW_COUNT_EDIT; lastIndex--) {
				var trans:StaffDetailDto = copy.getItemAt(lastIndex) as StaffDetailDto;
				if (trans && trans.checkEntry()) 		break;
				copy.removeItemAt(lastIndex);
			}
			return copy;
		}
		
		/**
		 * 都道府県をDBから取得成功
		 * 都道府県を表示
		 * */
		public function onResult_showContinentList(e: ResultEvent):void
		{
			trace("onResult_showContinentList...");
		
			var mPrefectureListDto:MPrefectureListDto = new MPrefectureListDto(e.result);
			_mPrefectureList = mPrefectureListDto.MPrefectureList;				
		}
		
		/**
		 * 等級マスタ取得成功
		 * 
		 * */
		public function onResult_showBasicClassPayList(e: ResultEvent):void
		{
			trace("onResult_showBasicClassPayList...");
			var basicClassList:MBasicClassListDto = new MBasicClassListDto(e.result);
			_basicClass = basicClassList.MBasicClassList;
		}
		
		/**
		 * 基本給マスタ取得成功
		 * 
		 * */
		public function onResult_showBasicPayList(e: ResultEvent):void
		{
			trace("onResult_showBasicPayList...");
			var mBasicRankListDto:MBasicRankListDto = new MBasicRankListDto(e.result);
			_basicRank = mBasicRankListDto.MBasicRankList;
			_basicRank.filterFunction = rankNoFilter;
			_basicRank.refresh();
		}

		/**
		 * 号リストフィルター処理
		 * 
		 * */
		public function rankNoFilter(basicPay:MBasicRankDto):Boolean
		{	
			if(basicPay.classNo == 9)
			{
				trace("OK");
			}
			return(view.basicPyaClassNo.selectedData == basicPay.classNo.toString());
		}		 
		
		/**
		 * DB接続エラー・不正なパラメータなどで発生(都道府県マスタ接続)
		 * */
		 public function onFault_remoteObject(e: FaultEvent):void
		{
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("都道府県マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		}
		
		/**
		 * DB接続エラー・不正なパラメータなどで発生(等級マスタ接続)
		 * */
		 public function onFault_remoteBasicClassPayList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("等級マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }

		/**
		 * DB接続エラー・不正なパラメータなどで発生(基本給マスタ接続)
		 * */
		 public function onFault_remoteBasicPayList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("基本給マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
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

	    /**
		 * 更新成功
		 */
		public function onResult_SucceedSave(e: ResultEvent):void
		{
			trace("更新成功");	
			// 確認ダイヤルログ表示
			Alert.show("保存に成功しました。", "",
					Alert.OK, null, null, null, Alert.OK);
					
			// 初期化
			onClick_manFormat();
		}
		
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:StaffEntry;

	    /**
	     * 画面を取得します

	     */
	    public function get view():StaffEntry
	    {
	        if (_view == null) {
	            _view = super.document as StaffEntry;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:StaffEntry):void
	    {
	        _view = view;
	    }

	}    
}