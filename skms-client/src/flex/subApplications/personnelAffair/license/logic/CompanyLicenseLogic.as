package subApplications.personnelAffair.license.logic
{
    import dto.LabelDto;
    
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
    
    import subApplications.personnelAffair.license.dto.MBasicClassLabelDto;
    import subApplications.personnelAffair.license.dto.MBasicRankLabelDto;
    import subApplications.personnelAffair.license.dto.MBasicRankListDto;
    import subApplications.personnelAffair.license.dto.MCompetentAllowanceDto;
    import subApplications.personnelAffair.license.dto.MCompetentAllowanceLabelDto;
    import subApplications.personnelAffair.license.dto.MCompetentAllowanceListDto;
    import subApplications.personnelAffair.license.dto.MHousingAllowanceDto;
    import subApplications.personnelAffair.license.dto.MHousingAllowanceLabelDto;
    import subApplications.personnelAffair.license.dto.MHousingAllowanceListDto;
    import subApplications.personnelAffair.license.dto.MInformationAllowanceLabelDto;
    import subApplications.personnelAffair.license.dto.MInformationAllowanceListDto;
    import subApplications.personnelAffair.license.dto.MManagerialAllowanceDto;
    import subApplications.personnelAffair.license.dto.MManagerialAllowanceLabelDto;
    import subApplications.personnelAffair.license.dto.MManagerialAllowanceListDto;
    import subApplications.personnelAffair.license.dto.MPayLicenceHistoryDto;
    import subApplications.personnelAffair.license.dto.MPayLicenceHistoryListDto;
    import subApplications.personnelAffair.license.dto.MPeriodListDto;
    import subApplications.personnelAffair.license.dto.MTechnicalSkillAllowanceDto;
    import subApplications.personnelAffair.license.dto.MTechnicalSkillAllowanceLabelDto;
    import subApplications.personnelAffair.license.dto.MTechnicalSkillAllowanceListDto;
    import subApplications.personnelAffair.license.web.CompanyLicense;
    import subApplications.personnelAffair.license.web.CompanyLicenseHistoryEntryDlg;
    
	/**
	 * CompanyLicenseLogicのLogicクラスです。
	 */
	public class CompanyLicenseLogic extends Logic
	{		
		/** 資格手当取得履歴リスト */
		[Bindable]
		public var mPayLicenceHistoryList:ArrayCollection;
		
		/** 資格手当取得履歴リスト(初期状態) */	
		[Bindable]	
		public var saveMPayLicenceHistoryList:ArrayCollection;
		
		/** 資格手当取得履歴リスト(前期確認) */	
		[Bindable]	
		public var copyMPayLicenceHistoryList:ArrayCollection;
		
		/** 社内資格手当履歴未格納フラグ */
		public var  resultRecordCountFlag:Boolean = false;
		
		/**
		 * 等級コンボボックスの値
		 */		
		[Bindable] 
		public var basicClassList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 号コンボボックスの値(すべて)
		 */				
		[Bindable] 
		public var allBasicRankList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 号コンボボックスの値
		 */				
		[Bindable] 
		public var basicRankList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 期マスタラベルリスト
		 */		
		public var mPeriodList:ArrayCollection = new ArrayCollection();

		/**
		 * 基本給マスタラベルリスト
		 */		
		public var mBasicRankList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 職務手当ラベルリスト
		 */				
		public var _mManagerialAllowanceLabel:ArrayCollection = new ArrayCollection();
		
		/**
		 * 職務手当リスト
		 */				
		public var _mManagerialAllowanceList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 主務手当ラベルリスト
		 */				
		public var _mCompetentAllowanceLabel:ArrayCollection = new ArrayCollection();
		
		/**
		 * 主務手当リスト
		 */				
		public var _mCompetentAllowanceList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 技能手当ラベルリスト
		 */				
		public var _mTechnicalSkillAllowanceLabel:ArrayCollection = new ArrayCollection();
		
		/**
		 * 技能手当リスト
		 */				
		public var _mTechnicalSkillAllowanceList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 認定資格手当ラベルリスト
		 */				
		public var _mInformationAllowanceLabel:ArrayCollection = new ArrayCollection();
		
		/**
		 * 認定資格手当リスト
		 */				
		public var _mInformationAllowanceList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 住宅手当ラベルリスト
		 */				
		public var _mHousingAllowanceLabel:ArrayCollection = new ArrayCollection();
		
		/**
		 * 住宅手当リスト
		 */				
		public var _mHousingAllowanceList:ArrayCollection = new ArrayCollection();
		
		/** 
		 * 社員名(更新履歴)
		 */
		public var _staffName:String;
		
		/** 
		 * 社員ID(更新履歴) 
		 * */
		public var _staffId:int;
		
		/** 
		 * 基本給_等級(更新履歴) 
		 * */
		public var _basicClassNo:int;

		/**
		 * 検索年の値(開始)
		 */						
		public var dateStartYear:int = 0;
		
		/**
		 * 検索年の値(終了)
		 */						
		public var dateEndYear:int = 0;
		
		/**
		 * 検索年の値
		 */						
		public var dateYear:int = (new Date).fullYear;
		
		/**
		 * 検索月の値
		 */						
		public var dateMonth:int = ((new Date).month + 1);
		
		/**
		 * 期の加算完了フラグ(true = 加算)(false = 減算)
		 */						
		public var periodFlag:Boolean = true;

		/**
		 * 検索期の値
		 */						
		public var searchPeriod:int = 0;
		
		/**
		 * 創業年の値
		 */						
		public var companyYear:int = 1984;
		
		/**
		 * 今期の値
		 */						
		public var nowPeriod:int = 0;
		
		/**
		 * 複製処理使用判定フラグの値
		 */						
		public var copyListFlag:Boolean = false;
		
		/**
		 * コンボボックスOpenフラグの値
		 */						
		public var closeColumnIndex:Boolean = true;
		
		/** ログイン者ID */
		public var inStaffId:int = Application.application.indexLogic.loginStaff.staffId;
			
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CompanyLicenseLogic()
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
	    	// 検索日時算出処理 	
	    	initializeTime();
	    	
	    	// 基本給【等級】を初期化
	    	_basicClassNo = 0;
	    	
	    	/** DBデータの取得 */
	    	// 期マスタの取得
	    	view.companyLicenseService.getOperation("getPeriodList").send();
			// 等級マスタの取得
	    	view.companyLicenseService.getOperation("getBasicClassPayList").send();

	    	/** 必要な変数をバインド */
	    	// 「社内資格」にバインドする
	    	BindingUtils.bindProperty(view.licencePayList, "dataProvider", this, "mPayLicenceHistoryList");
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
	    
	    /**
		 * 任意で選択した社員情報を取得
		 */
		public function onClick_staffSelect(e:ListEvent):void
		{
			// コンボボックスのopenフラグを初期化
			closeColumnIndex = true;
						
			// 社員IDを取得する.
			_staffId = e.itemRenderer.data.staffId;
			
			// 社員名を取得する.
			_staffName = e.itemRenderer.data.fullName;
			
			// 氏名の項目を押下した場合
			if(e.columnIndex == 0)
			{
				// 対象の社員の給与更新履歴画面を作成する.
				openCompanyLicenseHistoryEntryDlg(null);
			}
			
			// 等級リストから現在表示されている「等級No」を検索する
			for each(var basicClassNo:Object in basicClassList)
			{
				if(e.itemRenderer.data.basicPayClassNoName == basicClassNo.label)
				{
					_basicClassNo = basicClassNo.data3;
				}
			}
			
			var array:Array = new Array();
			
			// 「等級No」から格納する号リストを検索する
			for each(var basicRank:Object in allBasicRankList)
			{
				var tmp:LabelDto = new LabelDto();
				
				if(_basicClassNo == basicRank.data)
				{
					tmp.label = basicRank.label;	
					tmp.data = basicRank.data;
					tmp.data3 = basicRank.data3;	
					array.push(tmp);		
				}
			}
			
			// 号リストを更新する
			// ※等級に該当する号リストに差し替える
			basicRankList = new ArrayCollection(array);
		}

		/**
		 * 前年度資格手当検索ボタン
		 */
		public function onClick_linkPreviousMonth(e:Event):void
		{				
			// 期「-1」計算したものを格納する
			searchPeriod = searchPeriod - 1;
			dateStartYear = dateStartYear - 1;
			dateEndYear = dateEndYear -1;
			
			// コンボボックス&ボタン押下制御
			controlItem();
			
			// 期の加算完了フラグにfalseを格納する
			// ※減算(false)
			periodFlag = false

			// 資格手当取得処理			
			manSearchPayLicenceList();
		}
		
		/**
		 * 翌年度資格手当検索ボタン
		 */
		public function onClick_linkNextMonth(e:Event):void
		{
			//「+1」計算したものを格納する
			searchPeriod = searchPeriod + 1;
			dateStartYear = dateStartYear + 1;
			dateEndYear = dateEndYear + 1;

			// コンボボックス&ボタン押下制御
			controlItem();
						
			// 期の加算完了フラグにtrueを格納する
			// ※加算(true)
			periodFlag = true

			// 資格手当取得処理			
			manSearchPayLicenceList();
		}
		
		/**
		 * 社内資格取得履歴更新ボタン
		 */
		public function onClick_updateMPayLicenceHistory(e:Event):void
		{
	    	// 確認ダイアログ表示
			Alert.show("更新してもよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						mainUpdateMPayLicenceHistory,null, Alert.CANCEL);	 
		}	
		
		/**
		 * 前期の社内資格一覧を複製ボタン
		 */
		public function onClick_copyList(e:Event):void
		{	
			// 複製処理使用判定フラグにtrueを格納する
			copyListFlag = true;
			
	    	// 確認ダイアログ表示
			Alert.show("前期の社内資格一覧を複製してもよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						mainCopyList,null, Alert.CANCEL);	 
		}	
//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * 資格手当取得処理
		 */
		public function manSearchPayLicenceList():void
		{  
			// 検索日時算出処理
			searchTime();

	    	// 社内資格手当取得の取得
	    	view.companyLicenseService.getOperation("getMPayLicenceList").send(searchPeriod);
	    	
	    	// 社内資格手当取得(初期状態)の取得
	    	view.companyLicenseService.getOperation("getSeveMPayLicenceList").send(searchPeriod);
		}
		
		/**
		 * 検索日時表示処理
		 */
		public function searchTime():void
		{	
	    	view.linkPeriod.text = searchPeriod + "期";
	    		
	    	view.lblWorkingMonth.text = dateStartYear + "年10月～" + dateEndYear + "年09月"
		}
		
		/**
		 * 検索日時算出処理(初期表示)
		 */
		public function initializeTime():void
		{	
	    	// 初期表示の期間、期を設定する
	    	if(dateMonth <= 10)
	    	{	
	    		// 検索期の格納
	    		searchPeriod = ((dateYear - companyYear) -1);
	    		
	    		// 現在期を格納
	    		nowPeriod = ((dateYear - companyYear) -1);
	    		
	    		view.linkPeriod.text = searchPeriod + "期";
	    		
	    		view.lblWorkingMonth.text = (dateStartYear = (dateYear - 1)) + "年10月～" + (dateEndYear = dateYear) + "年09月"
	    	}
	    	else
	    	{
	    		// 検索期の格納 		    		
	    		searchPeriod = (dateYear - companyYear);

	    		// 現在の期を格納
	    		nowPeriod = (dateYear - companyYear);
	    		
	    		view.linkPeriod.text = searchPeriod + "期";
	    		
	    		view.lblWorkingMonth.text = (dateStartYear = dateYear) + "年10月～" + (dateEndYear = (dateYear + 1)) + "年09月"
	    	}
		}
		
		/**
		 * コンボボックス&ボタン押下制御
		 */
		public function controlItem():void
		{
			// 現在期が検索期より大きい場合
			if(nowPeriod > searchPeriod)
			{
				view.columnBasicClassNo.editable = false;
				view.columnBasicRankNo.editable = false;
				view.columnManagerialClassNo.editable = false;
				view.columnCompetentClassNo.editable = false;
				view.columnTechnicalSkillClassNo.editable = false;
				view.columnInformationPayName.editable = false;
				view.columnHousingName.editable  = false;
				view.btnUpdate.enabled = false;
				view.copyList.enabled = false;
			}
			// 現在期が検索期と等しい場合、また小さい場合
			else if(nowPeriod <= searchPeriod)
			{
				view.columnBasicClassNo.editable = true;
				view.columnBasicRankNo.editable = true;
				view.columnManagerialClassNo.editable = true;
				view.columnCompetentClassNo.editable = true;
				view.columnTechnicalSkillClassNo.editable = true;
				view.columnInformationPayName.editable = true;
				view.columnHousingName.editable  = true;
				view.btnUpdate.enabled = false;
				view.copyList.enabled = false;
				
				// 前期格納確認処理
				corroborationHistory();
			}
			
			// 検索期の値が1の場合
			if(searchPeriod == 1)
			{view.linkPreviousMonth.enabled = false;}
			else
			{view.linkPreviousMonth.enabled = true;}
		}
		
		/**
		 * 前期格納確認処理
		 */
		public function corroborationHistory():void
		{	
			// 資格手当取得の取得(前期格納確認)
	    	view.companyLicenseService.getOperation("getCopyMPayLicenceList").send((searchPeriod - 1));
		}				
		
		/**
		 * 前期社内資格一覧複製処理(本処理)
		 */
		public function mainCopyList(e:CloseEvent):void
		{	
			// 「OK」ならば.
			if (e.detail == 4) 
			{
				// 資格手当取得の取得
	    		view.companyLicenseService.getOperation("getMPayLicenceList").send((searchPeriod - 1));
	    		
	    		// 更新ボタンを押下可能
				view.btnUpdate.enabled = true;
			}
		}				

		/**
		 * 社内資格取得履歴更新処理(本処理)
		 *
		 * 引数：社員資格マスタ
		 */
		 public function mainUpdateMPayLicenceHistory(e:CloseEvent):void
		{
			var updataStaffList:ArrayCollection = new ArrayCollection();
			var tmpArray:Array = new Array();
			var mStaffQualificationFalg:Boolean = false;
			
			// キャンセルの場合
			if(e.detail == 8){return}
				
			// 社員資格マスタ格納判定処理
			for each(var saveHistoryList:MPayLicenceHistoryDto in this.saveMPayLicenceHistoryList)
			{	
				for each(var mainMPayLicenceHistoryDto:MPayLicenceHistoryDto in this.mPayLicenceHistoryList)
				{	
					if(saveHistoryList.staffId == mainMPayLicenceHistoryDto.staffId)
					{
						if((saveHistoryList.basicPayClassNoName == mainMPayLicenceHistoryDto.basicPayClassNoName)&&
						(saveHistoryList.basicPayRankNo == mainMPayLicenceHistoryDto.basicPayRankNo)&&
						(saveHistoryList.technicalSkillClassNo == mainMPayLicenceHistoryDto.technicalSkillClassNo)&&
						(saveHistoryList.competentClassNo == mainMPayLicenceHistoryDto.competentClassNo)&&
						(saveHistoryList.managerialClassNo == mainMPayLicenceHistoryDto.managerialClassNo)&&
						(saveHistoryList.informationPayName == mainMPayLicenceHistoryDto.informationPayName)&&
						(saveHistoryList.housingName == mainMPayLicenceHistoryDto.housingName))
						{}
						else
						{			
							// 社内資格手当取得履歴を格納する
							tmpArray.push(mainMPayLicenceHistoryDto);
							mStaffQualificationFalg = true;
						}
					}
				}
			}
			
			// 社内資格取得履歴リストが「null」または複製処理使用判定フラグが「true」の場合
			// ※複製処理使用判定フラグが「true」の場合は、保存対象期にて複製処理を使用
			if((saveHistoryList == null)||(copyListFlag == true))
			{	
				tmpArray = new Array();
				
				for each(var copyMPayLicenceHistoryDto:MPayLicenceHistoryDto in this.mPayLicenceHistoryList)
				{	
					// 社員資格手当取得履歴を格納する
					tmpArray.push(copyMPayLicenceHistoryDto);
					mStaffQualificationFalg = true;
				}
				
				// 複製処理使用判定フラグを初期化		
				copyListFlag = false
			}	
				
			// DTOの型に変換したものを、リストに追加する
			updataStaffList = new ArrayCollection(tmpArray);
			
			// 更新するデータが存在しない場合
			if(mStaffQualificationFalg == false)
			{updateDataError();
			return;	}

			tmpArray = new Array();
			
			for each(var object:Object in updataStaffList)
			{	
				var tmp:MPayLicenceHistoryDto = new MPayLicenceHistoryDto();
				var mStaffQualificationDto:ArrayCollection = new ArrayCollection();
				var basicPayFlag:Boolean = false;

				// 社員IDを格納
				tmp.staffId = object.staffId;
				// 社員名を格納
				tmp.fullName = object.fullName;
				// 検索期を格納
				tmp.periodId = searchPeriod;
				
				// 基本給【等級】算出
				for each(var mBasicClass:Object in this.basicClassList)
				{
					if(object.basicPayClassNoName == mBasicClass.label)
					{
						tmp.basicPayClassNo = mBasicClass.data3;
						tmp.basicPayClassNoName = mBasicClass.label;
					}
				}

				// 基本給【号】算出
				for each(var mBasicRank:Object in this.allBasicRankList)
				{
					if((object.basicPayRankNo == mBasicRank.label)&&(tmp.basicPayClassNo == mBasicRank.data))
					{
						tmp.basicPayId = mBasicRank.data2;
						tmp.basicPayRankNo = mBasicRank.label;
						tmp.basicPayMonthlySum = mBasicRank.data3;
						
						// 基本給格納完了フラグに「true」を格納する。
						basicPayFlag = true;
					}
				}
				
				// 基本給が格納されていない場合				
				if(basicPayFlag == false)
				{	
					// 更新エラー発生【更新データなし】
					updatePayError();
					return;
				}
				
				// 技能手当算出
				for each(var mTechnicalSkillAllowance:MTechnicalSkillAllowanceDto in this._mTechnicalSkillAllowanceList)
				{
					if(object.technicalSkillClassNo == mTechnicalSkillAllowance.classNo)
					{
						tmp.technicalSkillId = mTechnicalSkillAllowance.technicalSkillId;
						tmp.technicalSkillClassNo = mTechnicalSkillAllowance.classNo;
						tmp.technicalSkillMonthlySum = mTechnicalSkillAllowance.monthlySum;
					}
				}
				
				// 主務手当算出
				for each(var mCompetentAllowance:MCompetentAllowanceDto in this._mCompetentAllowanceList)
				{
					if(object.competentClassNo == mCompetentAllowance.classNo)
					{
						tmp.competentId = mCompetentAllowance.competentId;
						tmp.competentClassNo = mCompetentAllowance.classNo;
						tmp.competentMonthlySum = mCompetentAllowance.monthlySum;
					}
				}
		
				// 職務手当算出
				for each(var mManagerialAllowance:MManagerialAllowanceDto in this._mManagerialAllowanceList)
				{
					if(object.managerialClassNo == mManagerialAllowance.classNo)
					{
						tmp.managerialId = mManagerialAllowance.managerialId;
						tmp.managerialClassNo = mManagerialAllowance.classNo;
						tmp.managerialMonthlySum = mManagerialAllowance.monthlySum;
					}
				}
				
				// 認定資格手当算出
				for each(var mInformationAllowance:Object in this._mInformationAllowanceList)
				{
					if(object.informationPayName == mInformationAllowance.informationPayName)
					{
						tmp.informationPayId = mInformationAllowance.informationPayId;
						tmp.informationPayName = mInformationAllowance.informationPayName;
						tmp.informationPayMonthlySum = mInformationAllowance.monthlySum;
					}
				}
				
				// 住宅手当算出
				for each(var mHousingAllowance:MHousingAllowanceDto in this._mHousingAllowanceList)
				{
					if(object.housingName == mHousingAllowance.housingName)
					{
						tmp.housingId = mHousingAllowance.housingId;
						tmp.housingName = mHousingAllowance.housingName;
						tmp.housingPayMonthlySum = mHousingAllowance.monthlySum;
					}
				}

				// 社内資格手当取得履歴を格納する
				tmpArray.push(tmp);
			}	
			// DTOの型に変換したものを、リストに追加する
			mStaffQualificationDto = new ArrayCollection(tmpArray);

			// 追加の実行
			view.companyLicenseService.getOperation("insertMPayLicenceList").send(inStaffId,searchPeriod,mStaffQualificationDto);
		}


		/**
		 * CompanyLicenseHistoryEntryDlg(個人社内資格更新履歴)のオープン.
		 *
		 * @param companyLicenseHistory 個人社内資格更新履歴.
		 */
		private function openCompanyLicenseHistoryEntryDlg(companyLicenseHistory:Object):void
		{		
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			
			// 個人社内資格更新履歴画面を作成する.			
			var pop:CompanyLicenseHistoryEntryDlg = new CompanyLicenseHistoryEntryDlg();
			PopUpManager.addPopUp(pop, view, true);
			
			// 期マスタをセット
			obj.mPeriodList = mPeriodList;

			// 社員IDをセット
			obj.staffId = _staffId;
			
			// 社員名をセット
			obj.staffName = _staffName;
			
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_companyLicenseHistoryEntryDlg);
			
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);
		}
		
		/**
		 * CompanyLicenseHistoryEntryDlg(個人社内資格更新履歴)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onClose_companyLicenseHistoryEntryDlg(e:CloseEvent):void
		{
			// コンボボックスOpenフラグをfalseに設定
			closeColumnIndex = false;
		}
		
		/**
		 * 社内資格手当取得リスト取得成功
		 * 
		 * */
		public function onResult_showMPayLicenceList(e: ResultEvent):void
		{
			trace("onResult_showMPayLicenceList...");
			
			var mPayLicenceHistoryListDto:MPayLicenceHistoryListDto = new MPayLicenceHistoryListDto(e.result,basicClassList,allBasicRankList,_mManagerialAllowanceLabel,_mCompetentAllowanceLabel,_mTechnicalSkillAllowanceLabel,_mInformationAllowanceLabel,_mHousingAllowanceLabel);
			
			// 社内資格手当履歴未格納フラグ
			// ※社内資格手当履歴未格納フラグ(trueは格納数「0」である)
			resultRecordCountFlag = mPayLicenceHistoryListDto.ResultRecordCountFlag;
			
			// 社内資格手当履歴未格納フラグがtrueで、現在期が検索期より大きい場合
			if((resultRecordCountFlag == true)&&(nowPeriod > searchPeriod))
			{				
				// エラー表示
				Alert.show(searchPeriod + "期のデータが存在しません。","",Alert.OK,null,null,null);
				
				// エラーにより、値を検索前に戻す
				if(periodFlag != true)
				{
					searchPeriod = searchPeriod + 1
					dateStartYear = dateStartYear + 1;
					dateEndYear = dateEndYear + 1;
				}
				
				view.linkPeriod.text = searchPeriod + "期";
				view.lblWorkingMonth.text = dateStartYear + "年10月～" + dateEndYear + "年09月"
				
				// コンボボックス&ボタン押下制御
				controlItem();
				
				return;
			}
			
			mPayLicenceHistoryList = mPayLicenceHistoryListDto.MPayLicenceHistoryList;
		}
		
		/**
		 * 資格手当取得リスト取得成功(初期状態)
		 * 
		 * */
		public function onResult_showSeveMPayLicenceList(e: ResultEvent):void
		{
			trace("onResult_showSeveMPayLicenceList...");

			var mPayLicenceHistoryListDto:MPayLicenceHistoryListDto = new MPayLicenceHistoryListDto(e.result,basicClassList,allBasicRankList,_mManagerialAllowanceLabel,_mCompetentAllowanceLabel,_mTechnicalSkillAllowanceLabel,_mInformationAllowanceLabel,_mHousingAllowanceLabel);
			saveMPayLicenceHistoryList = mPayLicenceHistoryListDto.MPayLicenceHistoryList;
			
			// 「更新」ボタン押下制御
			if(((saveMPayLicenceHistoryList == null)||(saveMPayLicenceHistoryList.length == 0))&&(nowPeriod <= searchPeriod))
		    {view.btnUpdate.enabled = false;}
		    else
		    {view.btnUpdate.enabled = true;}
		}
		
		/**
		 * 資格手当取得リスト取得成功(前期格納確認)
		 * 
		 * */
		public function onResult_showCopyMPayLicenceList(e: ResultEvent):void
		{
			trace("onResult_showCopyMPayLicenceList...");

			var mPayLicenceHistoryListDto:MPayLicenceHistoryListDto = new MPayLicenceHistoryListDto(e.result,basicClassList,allBasicRankList,_mManagerialAllowanceLabel,_mCompetentAllowanceLabel,_mTechnicalSkillAllowanceLabel,_mInformationAllowanceLabel,_mHousingAllowanceLabel);
			copyMPayLicenceHistoryList = mPayLicenceHistoryListDto.MPayLicenceHistoryList;
			
			// 「前期の社内資格一覧を複製」ボタン押下判定
			if((copyMPayLicenceHistoryList == null)||(copyMPayLicenceHistoryList.length == 0))
		    {view.copyList.enabled = false;}
		    else
		    {view.copyList.enabled = true;}
		}
		
		/**
		 * 期マスタ取得成功
		 * 
		 * */
		public function onResult_showPeriodList(e: ResultEvent):void
		{
			trace("onResult_showPeriodList...");
			
			//期マスタ
			var mPeriodListDto:MPeriodListDto = new MPeriodListDto(e.result);
			mPeriodList = mPeriodListDto.MPeriodList;
		}
		
		/**
		 * 等級マスタ取得成功
		 * 
		 * */
		public function onResult_showBasicClassPayList(e: ResultEvent):void
		{
			trace("onResult_showBasicPayClassList...");
			
			var mBasicClassLabelDto:MBasicClassLabelDto = new MBasicClassLabelDto(e.result);
			basicClassList = mBasicClassLabelDto.MBasicPayClassLabel;
	    	
	    	// 基本給【号】マスタの取得
	    	view.companyLicenseService.getOperation("getBasicPayList").send();
		}
		
		/**
		 * 基本給(号)マスタ取得成功
		 * 
		 * */
		public function onResult_showBasicRankPayList(e: ResultEvent):void
		{
			trace("onResult_showBasicPayList...");
			
			//基本給【号】(すべての配列を格納)
			var mBasicRankLabelDto:MBasicRankLabelDto = new MBasicRankLabelDto(e.result);
			allBasicRankList = mBasicRankLabelDto.MBasicPayRankLabel;
			
			//基本給【号】(コンボボックス用)
			var mBasicRankListDto:MBasicRankListDto = new MBasicRankListDto(e.result);
			basicRankList = mBasicRankListDto.MBasicRankList;
			
			// 職務手当マスタの取得
	    	view.companyLicenseService.getOperation("getManagerialAllowanceList").send();
		}
		
		/**
		 * 職務手当マスタ取得成功
		 * 
		 * */
		public function onResult_showManagerialAllowanceList(e: ResultEvent):void
		{
			trace("onResult_showManagerialAllowanceList...");
			var mManagerialAllowanceLabelDto:MManagerialAllowanceLabelDto = new MManagerialAllowanceLabelDto(e.result);
			var mManagerialAllowanceListDto:MManagerialAllowanceListDto = new MManagerialAllowanceListDto(e.result);
			_mManagerialAllowanceLabel = mManagerialAllowanceLabelDto.MManagerialAllowanceLabel;
			_mManagerialAllowanceList = mManagerialAllowanceListDto.MManagerialAllowanceList;	
			
			// 主務手当マスタの取得
	    	view.companyLicenseService.getOperation("getCompetentAllowanceList").send();
		}
			
		/**
		 * 主務手当マスタ取得成功
		 * 
		 * */
		public function onResult_showCompetentAllowanceList(e: ResultEvent):void
		{
			trace("onResult_showCompetentAllowanceList...");
			var mCompetentAllowanceLabelDto:MCompetentAllowanceLabelDto = new MCompetentAllowanceLabelDto(e.result);
			var mCompetentAllowanceListDto:MCompetentAllowanceListDto = new MCompetentAllowanceListDto(e.result);			
			_mCompetentAllowanceLabel = mCompetentAllowanceLabelDto.MCompetentAllowanceLabel;
			_mCompetentAllowanceList = mCompetentAllowanceListDto.MCompetentAllowanceList;
			
			// 技能手当マスタの取得
	    	view.companyLicenseService.getOperation("getMTechnicalSkillAllowanceList").send();
		}
		
		/**
		 * 技能手当マスタ取得成功
		 * 
		 * */
		public function onResult_showMTechnicalSkillAllowanceList(e: ResultEvent):void
		{
			trace("onResult_showMTechnicalSkillAllowanceList...");
			var mTechnicalSkillAllowanceLabelDto:MTechnicalSkillAllowanceLabelDto = new MTechnicalSkillAllowanceLabelDto(e.result);
			var mTechnicalSkillAllowanceListDto:MTechnicalSkillAllowanceListDto = new MTechnicalSkillAllowanceListDto(e.result);			
			_mTechnicalSkillAllowanceLabel = mTechnicalSkillAllowanceLabelDto.MTechnicalSkillAllowanceLabel;
			_mTechnicalSkillAllowanceList = mTechnicalSkillAllowanceListDto.MTechnicalSkillAllowanceList;
	    	
	    	// 認定資格手当マスタの取得
	  		view.companyLicenseService.getOperation("getMInformationAllowanceList").send();
		}
		
		/**
		 * 認定資格手当マスタ取得成功
		 * 
		 * */
		public function onResult_showMInformationAllowanceList(e: ResultEvent):void
		{
			trace("onResult_showMAuthorizedLicenceAllowanceList...");
			var mInformationAllowanceLabelDto:MInformationAllowanceLabelDto = new MInformationAllowanceLabelDto(e.result);
			var mInformationAllowanceListDto:MInformationAllowanceListDto = new MInformationAllowanceListDto(e.result);
			_mInformationAllowanceLabel = mInformationAllowanceLabelDto.MInformationAllowanceLabel;
			_mInformationAllowanceList = mInformationAllowanceListDto.MInformationAllowanceList;
			
			// 住宅手当マスタの取得
	    	view.companyLicenseService.getOperation("getMHousingAllowanceList").send();
		}
		
		/**
		 * 住宅手当マスタ取得成功
		 * 
		 * */
		public function onResult_showMHousingAllowanceList(e: ResultEvent):void
		{
			trace("onResult_showMHousingAllowanceList...");
			var mHousingAllowanceLabelDto:MHousingAllowanceLabelDto = new MHousingAllowanceLabelDto(e.result);
			var mHousingAllowanceListDto:MHousingAllowanceListDto = new MHousingAllowanceListDto(e.result);
			_mHousingAllowanceLabel = mHousingAllowanceLabelDto.MHousingAllowanceLabel;
			_mHousingAllowanceList = mHousingAllowanceListDto.MHousingAllowanceList;

			// 社内資格手当取得処理			
			manSearchPayLicenceList();
		}
		
		/**
		 * DB接続エラー・不正なパラメータなどで発生(期マスタ接続)
		 * 
		 * */
		 public function onFault_remotePeriodList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("期マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }	
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(等級マスタ接続)
		 * 
		 * */
		 public function onFault_remoteBasicClassPayList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("等級マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }	
	
		/**
		 * DB接続エラー・不正なパラメータなどで発生(基本給【号】マスタ接続)
		 * 
		 * */
		 public function onFault_remoteBasicRankPayList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("基本給マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(職務手当マスタDB接続)
		 * 
		 * */
		 public function onFault_remoteManagerialAllowanceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("職務手当マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(主務手当マスタDB接続)
		 * 
		 * */
		 public function onFault_remoteCompetentAllowanceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("主務手当マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(技能手当マスタDB接続)
		 * 
		 * */
		 public function onFault_remoteMTechnicalSkillAllowanceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("技能手当マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(認定資格手当マスタDB接続)
		 * 
		 * */
		 public function onFault_remoteMInformationAllowanceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("認定資格手当マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(住宅手当マスタDB接続)
		 * 
		 * */
		 public function onFault_remoteMHousingAllowanceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("住宅手当マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(社内資格手当取得履歴DB接続)
		 * 
		 * */
		 public function onFault_remoteMPayLicenceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("社内資格手当履歴取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(社内資格手当取得履歴【初期状態】DB接続)
		 * 
		 * */
		 public function onFault_remoteSaveMPayLicenceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("社内資格手当取得履歴【初期状態】取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * DB接続エラー・不正なパラメータなどで発生(社内資格手当取得履歴【前期確認】DB接続)
		 * 
		 * */
		 public function onFault_remoteCopyMPayLicenceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("社内資格手当取得履歴【前期確認】取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
		 
		/**
		 * 更新エラー発生(基本給【号】未入力)
		 * 
		 */
		public function updatePayError():void
		{
			// エラー表示
			trace("更新失敗");	
			// 確認ダイヤルログ表示
			Alert.show("基本給【号】が入力されていません。", "",
			Alert.OK, null, null, null, Alert.OK);					
		}
		
		/**
		 * 更新エラー発生(更新データなし)
		 * 
		 */
		public function updateDataError():void
		{
			// エラー表示
			trace("更新失敗");	
			// 確認ダイヤルログ表示
			Alert.show("更新するデータがありません。", "",
			Alert.OK, null, null, null, Alert.OK);
		}
		
		/**
		 * 更新エラー発生
		 * 
		 * */
		 public function onFault_failureSave(e: FaultEvent):void
		{
		 	trace("更新失敗");
			// 確認ダイヤルログ表示
		 	Alert.show("更新に失敗しました。","",
		 			Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		}
		 
	    /**
		 * 更新成功
		 * 
		 */
		public function onResult_insertMPayLicenceList(e: ResultEvent):void
		{
			trace("更新成功");	
			// 確認ダイヤルログ表示
			Alert.show("保存に成功しました。", "",
					Alert.OK, null, null, null, Alert.OK);
					
			// 社内資格手当取得(初期状態)の取得
	    	view.companyLicenseService.getOperation("getSeveMPayLicenceList").send(searchPeriod);
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CompanyLicense;

	    /**
	     * 画面を取得します
	     */
	    public function get view():CompanyLicense
	    {
	        if (_view == null) 
	        {
	            _view = super.document as CompanyLicense;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CompanyLicense):void
	    {
	        _view = view;
	    }
	}
}    
