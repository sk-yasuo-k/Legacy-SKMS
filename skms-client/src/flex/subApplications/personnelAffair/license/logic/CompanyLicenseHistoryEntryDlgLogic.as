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
    import mx.events.*;
    import mx.managers.*;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.states.*;
    
    import subApplications.personnelAffair.license.dto.MPayLicenceHistoryDto;
    import subApplications.personnelAffair.license.dto.MPayLicenceHistoryListDto;
    import subApplications.personnelAffair.license.web.CompanyLicenseHistoryEntryDlg;
    
	/**
	 * CompanyLicenseHistoryEntryDlgのLogicクラスです。
	 */
	public class CompanyLicenseHistoryEntryDlgLogic extends Logic
	{		
		/** 個人資格手当取得履歴リスト(初期状態) */
		public var  copyMPayLicenceHistoryList:ArrayCollection;
		
		/** 個人資格手当取得履歴リスト */
		[Bindable]
		public var  _mPayLicenceHistoryList:ArrayCollection;
		
		/** 期コンボボックス */
		[Bindable]
		public var  _mPayLicenceComboBox:ArrayCollection;
		
		/**
		 * 検索期の値
		 */						
		public var nowPeriod:int = 0;
		
		/** ログイン者ID */
		public var inStaffId:int = Application.application.indexLogic.loginStaff.staffId;
			
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CompanyLicenseHistoryEntryDlgLogic()
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
	    	// 社員名を設定する
   			view.historyName.text = view.data.staffName;   			
   			
	    	/** DBデータの取得 */
	    	// 資格手当取得履歴の取得
	    	view.companyLicenseService.getOperation("getPrivateMPayLicenceList").send(view.data.staffId);
	    	
	    	/** 必要な変数をバインド */
	    	// 「現在のメンバー」にバインドする
	    	BindingUtils.bindProperty(view.licencePayHistory, "dataProvider", this, "_mPayLicenceHistoryList");
	    	// 
	    	BindingUtils.bindProperty(view.searchComboBox, "dataProvider", this, "_mPayLicenceComboBox");
	    }																		

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 任意の期を表示(検索).
		 *
		 * @param e Clickイベント.
		 */
		public function onClick_searchComboBox(e:Event):void
		{	
			var array:Array = new Array();
			
			// コンボボックスに該当する期の履歴を格納する
			for each(var copyMPayLicenceHistory:MPayLicenceHistoryDto in copyMPayLicenceHistoryList)
			{
				if(view.searchComboBox.selectedItem.data == 999)
				{array.push(copyMPayLicenceHistory);}
				else
				{
					if(copyMPayLicenceHistory.periodName + "期" == view.searchComboBox.text)
					{array.push(copyMPayLicenceHistory);}
				}
			}
			_mPayLicenceHistoryList = new ArrayCollection(array);
		}
		
		/**
		 * 閉じるボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onClick_btnClose(e:Event):void
		{
		 	// PopUpのCloseイベントを作成する.
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
			view.dispatchEvent(ce);
		}
		
		/**
		 * Closeイベント生成.
		 *
		 * @param e Closeイベント.
		 */
		public function onClose_companyLicenseHistoryEntryDlg(e:CloseEvent):void
		{
			// PopUpをCloseする.
			PopUpManager.removePopUp(view);
		}

//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * 期コンボボックスの作成
		 * 
		 * */
		public function creationComboBox():void
		{	
			var array:Array = new Array();
			var initialPeriodFlag:Boolean = false;
			var tmpArrqy:LabelDto = new LabelDto();
				
			tmpArrqy.label = "全期";	
			tmpArrqy.data = 999;
			array.push(tmpArrqy);
					
			for each(var creationComboBox:Object in view.data.mPeriodList)
			{
				var tmp:LabelDto = new LabelDto();
				
				tmp.label = creationComboBox.periodName + "期";	
				tmp.data = creationComboBox.periodId;
				array.push(tmp);		
			}		
			_mPayLicenceComboBox = new ArrayCollection(array);
		}

		/**
		 * 資格手当取得履歴取得成功
		 * 
		 * */
		public function onResult_showPrivateMPayLicenceList(e: ResultEvent):void
		{
			trace("onResult_showVCurrentPayLicenceHistoryList...");
			var mPayLicenceHistoryListDto:MPayLicenceHistoryListDto = new MPayLicenceHistoryListDto(e.result,null,null,null,null,null,null,null);
			copyMPayLicenceHistoryList = mPayLicenceHistoryListDto.MPayLicenceHistoryList;
			
			var array:Array = new Array();
			for each(var copyMPayLicenceHistory:MPayLicenceHistoryDto in copyMPayLicenceHistoryList)
			{
				array.push(copyMPayLicenceHistory);
			}
			_mPayLicenceHistoryList = new ArrayCollection(array);
			
			creationComboBox();
		}
		
		 /**
		 * DB接続エラー・不正なパラメータなどで発生(個人資格手当取得履歴DB接続)
		 * */
		 public function onFault_remotePrivateMPayLicenceList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("個人資格手当取得履歴失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CompanyLicenseHistoryEntryDlg;

	    /**
	     * 画面を取得します

	     */
	    public function get view():CompanyLicenseHistoryEntryDlg
	    {
	        if (_view == null) {
	            _view = super.document as CompanyLicenseHistoryEntryDlg;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CompanyLicenseHistoryEntryDlg):void
	    {
	        _view = view;
	    }

	}    
}