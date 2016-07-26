package subApplications.generalAffair.logic
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
    
    import subApplications.generalAffair.dto.CommitteeDto;
    import subApplications.generalAffair.dto.CommitteeListLabelDto;
    import subApplications.generalAffair.web.CommitteeMemberChangeDlg;
    
	/**
	 * CommitteeMemberChangeDlgのLogicクラスです。
	 */
	public class CommitteeMemberChangeDlgLogic extends Logic
	{    	
		// 登録画面			
		/** 委員会ID */
		[Bindable]
		public var _commiteeId:int;
		
		/** サブメニューで選択された委員会ID */
		[Bindable]
		public var sleetCommiteeId:int;
		
		/** コンボボックス用 */
		[Bindable]
		public var _committeeLabel:ArrayCollection;
		
		/** ログイン者ID */
		public var inStaffId:int = Application.application.indexLogic.loginStaff.staffId;
		
		//追加 @auther okamoto-y
		/** 日にち比較用変数 */
		public var cmp:int;
		/** 更新用フラグ */
		public var flg:Boolean;
	    
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CommitteeMemberChangeDlgLogic()
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
	    	// 画面タイトルを設定
	    	view.title = view.data.label;
//  			view.fitmApplyDate.label = view.title + "日";
	    	
	    	/*
	    	// 入会ならば
	    	if (view.data.id == "linkJoin") {
	    		view.fitmMemberName.height = 0;
	    		view.fitmMemberName.visible = false;
	    		view.fitmStaffName.percentHeight = 100;
	    		view.fitmStaffName.visible = true;
	    	} else {
	    		view.fitmStaffName.height = 0;
	    		view.fitmStaffName.visible = false;
	    		view.fitmMemberName.percentHeight = 100;
	    		view.fitmMemberName.visible = true;
	   			view.lblStaffName.text = view.data.memberName;
	    	}
	    	*/
	    	
	    	//追加 @auther maruta
	    	if(view.data.id == "linkJoin")
	    	{
	    		view.fitmMemberName.height = 0;
	    		view.fitmMemberName.visible = false;
	    		view.fitmStaffName.percentHeight = 100;
	    		view.fitmStaffName.visible = true;
	    		//追加 @auther okamoto-y
	    		view.committeeDate.percentHeight = 100;
	    		view.committeeDate.visible = true;
	    		view.edfcommitteeDate.percentHeight = 100;
	    		view.edfcommitteeDate.visible = true;
//	    		view.enrollmentDate.percentHeight = 100;
//	    		view.enrollmentDate.visible = true;
//	    		view.edfenrollmentDate.percentHeight = 100;
//	    		view.edfenrollmentDate.visible = true;
	    	}
	    	//退会ならば「委員名」と「退会日」を表示
	    	else if(view.data.id == "linkRetire")
	    	{
	    		view.fitmStaffName.height = 0;
	    		view.fitmStaffName.visible = false;
	    		view.fitmMemberName.percentHeight = 100;
	    		view.fitmMemberName.visible = true;
	    		view.lblStaffName.text = view.data.memberName;
	    		//追加 @auther okamoto-y
	    		view.committeeDate.percentHeight = 100;
	    		view.committeeDate.visible = true;
	    		view.edfcommitteeDate.percentHeight = 100;
	    		view.edfcommitteeDate.visible = true;
//	    		view.withdrawalDate.percentHeight = 100;
//	    		view.withdrawalDate.visible = true;
//	    		view.edfwithdrawalDate.percentHeight = 100;
//	    		view.edfwithdrawalDate.visible = true;
	    	}
	    	//委員長に任命ならば「委員名」と「任命日」を表示
	    	else if(view.data.id == "linkJoinHead")
	    	{
	    		view.fitmStaffName.height = 0;
	    		view.fitmStaffName.visible = false;
	    		view.fitmMemberName.percentHeight = 100;
	    		view.fitmMemberName.visible = true;
	    		view.lblStaffName.text = view.data.memberName;
	    		//追加 @auther okamoto-y
	    		view.committeeDate.percentHeight = 100;
	    		view.committeeDate.visible = true;
	    		view.edfcommitteeDate.percentHeight = 100;
	    		view.edfcommitteeDate.visible = true;
//	    		view.joinheadDate.percentHeight = 100;
//	    		view.joinheadDate.visible = true;
//	    		view.edfjoinheadDate.percentHeight = 100;
//	    		view.edfjoinheadDate.visible = true;
	    	}
	    	//委員長を解任ならば「委員名」と「解任日」を表示
	    	else if(view.data.id == "linkRetireHead")
	    	{
	    		view.fitmStaffName.height = 0;
	    		view.fitmStaffName.visible = false;
	    		view.fitmMemberName.percentHeight = 100;
	    		view.fitmMemberName.visible = true;
	    		view.lblStaffName.text = view.data.memberName;
	    		//追加 @auther okamoto-y
	    		view.committeeDate.percentHeight = 100;
	    		view.committeeDate.visible = true;
	    		view.edfcommitteeDate.percentHeight = 100;
	    		view.edfcommitteeDate.visible = true;
//	    		view.retireheadDate.percentHeight = 100;
//	    		view.retireheadDate.visible = true;
//	    		view.edfretireheadDate.percentHeight = 100;
//	    		view.edfretireheadDate.visible = true;
	    	}
	    	//副委員長に任命ならば「委員名」と「任命日」を表示
	    	else if(view.data.id == "linkJoinSubHead")
	    	{
	    		view.fitmStaffName.height = 0;
	    		view.fitmStaffName.visible = false;
	    		view.fitmMemberName.percentHeight = 100;
	    		view.fitmMemberName.visible = true;
	    		view.lblStaffName.text = view.data.memberName;
	    		//追加 @auther okamoto-y
	    		view.committeeDate.percentHeight = 100;
	    		view.committeeDate.visible = true;
	    		view.edfcommitteeDate.percentHeight = 100;
	    		view.edfcommitteeDate.visible = true;
//	    		view.joinsubheadDate.percentHeight = 100;
//	    		view.joinsubheadDate.visible = true;
//	    		view.edfjoinsubheadDate.percentHeight = 100;
//	    		view.edfjoinsubheadDate.visible = true;
	    	}
	    	//副委員長を解任ならば「委員名」と「解任日」を表示
	    	else
	    	{
	    		view.fitmStaffName.height = 0;
	    		view.fitmStaffName.visible = false;
	    		view.fitmMemberName.percentHeight = 100;
	    		view.fitmMemberName.visible = true;
	    		view.lblStaffName.text = view.data.memberName;
	    		//追加 @auther okamoto-y
	    		view.committeeDate.percentHeight = 100;
	    		view.committeeDate.visible = true;
	    		view.edfcommitteeDate.percentHeight = 100;
	    		view.edfcommitteeDate.visible = true;
//	    		view.retiresubheadDate.percentHeight = 100;
//	    		view.retiresubheadDate.visible = true;
//	    		view.edfretiresubheadDate.percentHeight = 100;
//	    		view.edfretiresubheadDate.visible = true;
	    	}
	    	//
	    	
// 2010.06.01 メニューはDBから取得　change start 
//	    	var item:Object = Application.application.indexLogic.view.treeMenu.selectedItem;
//	    	_commiteeId = item.@id;
//	    	
//	    	if (item.@label == "環境美化"){
//	    		sleetCommiteeId = 1
//	    	}
//	    	else if (item.@label == "研修"){
//	    		sleetCommiteeId = 2	
//	    	}
//	    	else if (item.@label == "広報"){
//	    		sleetCommiteeId = 3
//	    	}
//	    	else if (item.@label == "設備"){
//	    		sleetCommiteeId = 4
//	    	}
//	    	else if (item.@label == "福利厚生"){
//	    		sleetCommiteeId = 5
//	    	}
	    	var item:Object = Application.application.indexLogic.view.selectedMenu;
	    	_commiteeId = item.id;
	    	
	    	if (item.label == "環境美化"){
	    		sleetCommiteeId = 1
	    	}
	    	else if (item.label == "研修"){
	    		sleetCommiteeId = 2	
	    	}
	    	else if (item.label == "広報"){
	    		sleetCommiteeId = 3
	    	}
	    	else if (item.label == "設備"){
	    		sleetCommiteeId = 4
	    	}
	    	else if (item.label == "福利厚生"){
	    		sleetCommiteeId = 5
	    	}
// 2010.06.01 メニューはDBから取得　change end 
	    		    	
	    	view.committeeService.getOperation("getCommitteeLabel").send();
			
	    	/** 必要な変数をバインド */ 
	   		BindingUtils.bindProperty(view.cmbStaffName, "dataProvider", this, "_committeeLabel");
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
			var obj:Object = new Object();
			var dtoCombo:LabelDto = view.cmbStaffName.selectedItem as LabelDto;
			var committeeDto:CommitteeDto = new CommitteeDto();
	    	// 入会ならば
	    	if (view.data.id == "linkJoin") 
	    	{										
	    		if(dtoCombo != null){
					// Dtoに変換
					committeeDto.staffId = dtoCombo.data;
					committeeDto.committeeId = view.data.committeeid;
				
					//追加 @auther okamoto-y
					committeeDto.applyDate = view.edfcommitteeDate.selectedDate;
				
//					committeeDto.applyDate = DateField.stringToDate(view.dtfApplyDate.text, view.dtfApplyDate.formatString);
					
//					if(committeeDto.applyDate == null)
//					{
//						// エラーダイアログ表示
//						Alert.show(view.fitmApplyDate.label + "を入力していません。", "Error",
//									Alert.OK, null, null, null, Alert.OK);
//						return;
//					}			
					committeeDto.registrantId = inStaffId;			
				
					view.committeeService.getOperation("insertJoinCommittee").send(committeeDto);	
	    		}else{
					Alert.show("入会できる人がいません。", "Error",
							Alert.OK, null,
							null, null, Alert.OK);
	    		}
			}
			else
			{	
				// Dtoに変換
				committeeDto.staffId = view.data.selectId;
				committeeDto.committeeId = view.data.committeeid; 
				
//				var inputDate:Date = DateField.stringToDate(view.dtfApplyDate.text, view.dtfApplyDate.formatString);
				
//				if(inputDate == null)
//				{
//					// エラーダイアログ表示
//					Alert.show(view.fitmApplyDate.label + "を入力していません。", "Error",
//								Alert.OK, null, null, null, Alert.OK);
//					return;
//				}		
				committeeDto.registrantId = inStaffId;
				
				// 退会ならば
				if(view.data.id == "linkRetire")
				{				
//					committeeDto.cancelDate = inputDate;
					
					//追加 @auther okamoto-y
					committeeDto.cancelDate = view.edfcommitteeDate.selectedDate;
					
					view.committeeService.getOperation("compareWithdrawalDate").send(committeeDto);
				
					if(flg)
					{
						// 更新の実行
						view.committeeService.getOperation("updateLinkRetireCommittee").send(committeeDto);
					}	
				}
				// 委員長に任命ならば
				else if(view.data.id == "linkJoinHead")
				{
//					committeeDto.applyDate = inputDate;
					
					//追加 @auther okamoto-y
					committeeDto.applyDate = view.edfcommitteeDate.selectedDate;
					// 更新の実行
					view.committeeService.getOperation("insertLinkJoinHeadCommittee").send(committeeDto);					
				}
				// 委員長を退任ならば
				else if(view.data.id == "linkRetireHead")
				{
//					committeeDto.cancelDate = inputDate;
					
					//追加 @auther okamoto-y
					committeeDto.cancelDate = view.edfcommitteeDate.selectedDate;

					view.committeeService.getOperation("compareRetireDate").send(committeeDto);
					
					if(flg){
						// 更新の実行
						view.committeeService.getOperation("updateLinkRetireHeadCommittee").send(committeeDto);
					}	
				}
				// 副委員長に任命ならば
				else if(view.data.id == "linkJoinSubHead")
				{
//					committeeDto.applyDate = inputDate;
					
					//追加 @auther okamoto-y
					committeeDto.applyDate = view.edfcommitteeDate.selectedDate;
					// 更新の実行
					view.committeeService.getOperation("insertLinkJoinSubHeadCommittee").send(committeeDto);					
				}
				// 副委員長を退任ならば
				else if(view.data.id == "linkRetireSubHead")
				{
//					committeeDto.cancelDate = inputDate;

					//追加 @auther okamoto-y
					committeeDto.cancelDate = view.edfcommitteeDate.selectedDate;
					
					view.committeeService.getOperation("compareRetireDate").send(committeeDto);
					
					if(flg){
						// 更新の実行
						view.committeeService.getOperation("updateLinkRetireSubHeadCommittee").send(committeeDto);	
					}
				}
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
		public function onClose_committeeMemberChangeDlg(e:CloseEvent):void
		{
			// PopUpをCloseする.
			PopUpManager.removePopUp(view);
		}

	    /**
		 * 更新成功
		 */
		public function onResult_JoinCommittee(e: ResultEvent):void
		{
			trace("更新成功");	
			
			// 確認ダイヤルログ表示
			Alert.show("保存に成功しました。" , "",
					Alert.OK, null, null, null, Alert.OK);	
			
			// PopUpのCloseイベントを作成する.
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);	
		}
		
		//追加 @auther okamoto-y
		 /**
		 * 日にち比較成功
		 */
		 public function onResult_CompareDate(e: ResultEvent):void
		 {
		 	cmp = e.result as int;
		 	
		 	if(cmp > 0){
		 		// エラーダイアログ表示
				Alert.show("日付設定が間違っています。", "Error",
							Alert.OK, null,
							null, null, Alert.OK);	
									
				flg = false;					
			}else{
				flg = true;
			}
		 }
//--------------------------------------
//  Function
//--------------------------------------
		/**
		 * 社員委員会所属一覧(コンボボックス)をDBから取得成功
		 * 社員委員会所属一覧(コンボボックス)を表示
		 * */
		public function onResult_showCommitteeLabel(e: ResultEvent):void
		{
			trace("onResult_showCommitteeLabel...");
			
			var committeeListLabelDto:CommitteeListLabelDto = new CommitteeListLabelDto(e.result);
			_committeeLabel = committeeListLabelDto.CommitteeListLabel;
			
			view.btnOk.enabled = true;
			view.btnCancel.enabled = true;
			
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
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:CommitteeMemberChangeDlg;

	    /**
	     * 画面を取得します
	     */
	    public function get view():CommitteeMemberChangeDlg
	    {
	        if (_view == null) 
	        {
	            _view = super.document as CommitteeMemberChangeDlg;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:CommitteeMemberChangeDlg):void
	    {
	        _view = view;
	    }

	}    
}