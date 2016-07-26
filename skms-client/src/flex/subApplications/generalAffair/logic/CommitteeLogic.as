package subApplications.generalAffair.logic
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
    
    import subApplications.generalAffair.dto.CommitteeDto;
    import subApplications.generalAffair.dto.CommitteeListDto;
    import subApplications.generalAffair.dto.CommitteeListLogDto;
    import subApplications.generalAffair.dto.CommitteeNoteDto;
    import subApplications.generalAffair.dto.MCommitteeDto;
    import subApplications.generalAffair.dto.PositionListDto;
    import subApplications.generalAffair.web.Committee;
    import subApplications.generalAffair.web.CommitteeMemberChangeDlg;

    
	/**
	 * CommitteeのLogicクラスです。
	 */
	public class CommitteeLogic extends Logic
	{
		
	//委員会概要変数
	
		/** 経営役職結果*/
		public var positionResult:String;
		
		/** 経営役職リスト*/
		public var _positionList:ArrayCollection;
		
	    /** 委員会概要*/
		[Bindable]
		public var _committeeNoteText:String;
		
		/** 委員会概要(登録用)*/
		public var committeeNoteList:ArrayCollection;
		
		/** 役員権限*/
		public var officerAuthority:Boolean = Application.application.indexLogic.loginStaff.isAuthorisationProfile();
		
	//現在のメンバー変数(表示)
		
		/** サブメニューで選択された委員会ID */
		public var sleetCommiteeId:int;
		
		/** 社員ID */
		public var staffId:int;
		
		/** 委員会ID */
		public var _commiteeId:int;
			
	    /** 社員委員会所属リスト*/
		[Bindable]
		public var _committeeList:ArrayCollection;
		
	//現在のメンバー変数(登録)			
		
		/** 社員ID(登録用) */
		public var _staffId:int;
		
		/** 社員名(登録用) */
		public var _staffName:String;
		
		/** 委員会役職ID(登録用) */
		public var _committeePositionId:String;
		
		/** 委員長フラグ */
		public var committeePosition:String;
		
		/** 副委員長フラグ */
		public var committeeSubPosition:String;
		
		/** ログイン者ID */
		public var inStaffId:int = Application.application.indexLogic.loginStaff.staffId;
		
	//履歴のメンバー変数
		
		/** 社員委員会所属履歴リスト*/
		[Bindable]
		public var _committeeListLog:ArrayCollection;
	
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function CommitteeLogic()
		{
			super();		
		}
//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * 画面が呼び出されたとき最初に実行される
	     *
	     */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
	    {
// 2010.06.01 メニューはDBから取得　change start 
//	    	var item:Object = Application.application.indexLogic.view.treeMenu.selectedItem;
//	    	_commiteeId = item.@id;
//	    	
//	    	// 委員会画面トップのラベル取得
//	    	if (item.@label == "環境美化")
//	    	{
//	    	sleetCommiteeId = 1
//	    	}
//	    	else if (item.@label == "研修")
//	    	{
//	    	sleetCommiteeId = 2	
//	    	}
//	    	else if (item.@label == "広報")
//	    	{
//	    	sleetCommiteeId = 3
//	    	}
//	    	else if (item.@label == "設備")
//	    	{
//	    	sleetCommiteeId = 4
//	    	}
//	    	else if (item.@label == "福利厚生")
//	    	{
//	    	sleetCommiteeId = 5
//	    	}
//	    	
//	    	view.lblCommitteeName.text = item.@label + "委員会";

	    	var item:Object = Application.application.indexLogic.view.selectedMenu;
	    	_commiteeId = item.id;
	    	
	    	// 委員会画面トップのラベル取得
	    	if (item.label == "環境美化")
	    	{
	    	sleetCommiteeId = 1
	    	}
	    	else if (item.label == "研修")
	    	{
	    	sleetCommiteeId = 2	
	    	}
	    	else if (item.label == "広報")
	    	{
	    	sleetCommiteeId = 3
	    	}
	    	else if (item.label == "設備")
	    	{
	    	sleetCommiteeId = 4
	    	}
	    	else if (item.label == "福利厚生")
	    	{
	    	sleetCommiteeId = 5
	    	}
	    	
	    	view.lblCommitteeName.text = item.label + "委員会";
// 2010.06.01 メニューはDBから取得　change end 
	    	
	    	// 社員一覧(経営役職)の取得
	    	view.committeeService.getOperation("getMPositionList").send(inStaffId);
	    	// 委員会概要の取得
	    	view.committeeService.getOperation("getMCommitteeList").send(sleetCommiteeId);
	    	// 社員委員会所属の取得	    	
	    	view.committeeService.getOperation("getCommitteeList").send(sleetCommiteeId);
	    	// 社員委員会所属履歴の取得
	    	view.committeeService.getOperation("getCommitteeListLog").send(sleetCommiteeId);

			
	    	/** 必要な変数をバインド */ 
	    	// 「現在のメンバー」にバインドする
	    	BindingUtils.bindProperty(view.committeeList, "dataProvider", this, "_positionList");
	    	// 「委員会概要」にバインドする
	    	BindingUtils.bindProperty(view.mCommitteeList, "text", this, "_committeeNoteText");
	    	// 「現在のメンバー」にバインドする
	    	BindingUtils.bindProperty(view.committeeList, "dataProvider", this, "_committeeList"); 
	    	
	    }    
	   /**
		* メンバーの履歴タブが生成された時
		*/
	    /** 必要な変数をバインド */ 
	   public function onCreationComplete(e:FlexEvent):void
	   {
	   		// 「メンバーの履歴」画面にバインドする
	    	BindingUtils.bindProperty(view.committeeListLog, "dataProvider", this, "_committeeListLog");
	   }

//--------------------------------------
//  UI Event Handler
//--------------------------------------
		
		/**
		 * 	メンバー変更リンクボタンクリックイベント処理(入会).
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_admission(e:MouseEvent):void
	    {
    		// 画面を作成する.
			var pop:CommitteeMemberChangeDlg = new CommitteeMemberChangeDlg();
			PopUpManager.addPopUp(pop, view, true);
			
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// リンクボタンのidをセット
			obj.id = e.target.id;
			// リンクボタンのラベルをセット
			obj.label = e.target.label;
			// 委員会IDをセットする
			obj.committeeid = sleetCommiteeId;
	
			// 次の画面に、objを渡す
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_committeeMemberChangeDlg);
	
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);
	    }
		/**
		 * 	メンバー変更リンクボタンクリックイベント処理(退会).
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_former(e:MouseEvent):void
	    {								
			// 画面を作成する.
			var pop:CommitteeMemberChangeDlg = new CommitteeMemberChangeDlg();
			PopUpManager.addPopUp(pop, view, true);
			
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// リンクボタンのidをセット
			obj.id = e.target.id;
			// リンクボタンのラベルをセット
			obj.label = e.target.label;
			// 委員会IDをセットする
			obj.committeeid = sleetCommiteeId;
		
			// 委員名をセット
			obj.memberName = _staffName; // TODO:データグリッドで選択された名前
			// 委員名のIDをセット
			obj.selectId = _staffId; // TODO:データグリッドで選択された名前
	
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_committeeMemberChangeDlg);
	
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);		
	    }
	    /**
		 * 	メンバー変更リンクボタンクリックイベント処理(委員長に任命).
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_chairAppoint(e:MouseEvent):void
	    {				    	
			// 画面を作成する.
			var pop:CommitteeMemberChangeDlg = new CommitteeMemberChangeDlg();
			PopUpManager.addPopUp(pop, view, true);
			
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// リンクボタンのidをセット
			obj.id = e.target.id;
			// ラベルに「任命」セット
			obj.label = "任命";
			// 委員会IDをセットする
			obj.committeeid = sleetCommiteeId;
		
			// 委員名をセット
			obj.memberName = _staffName; // TODO:データグリッドで選択された名前
			// 委員名のIDをセット
			obj.selectId = _staffId; // TODO:データグリッドで選択された名前
	
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_committeeMemberChangeDlg);
	
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);			
	    }
	    /**
		 * 	メンバー変更リンクボタンクリックイベント処理(委員長を退任).
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_chairFormer(e:MouseEvent):void
	    {							
			// 画面を作成する.
			var pop:CommitteeMemberChangeDlg = new CommitteeMemberChangeDlg();
			PopUpManager.addPopUp(pop, view, true);
			
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// リンクボタンのidをセット
			obj.id = e.target.id;
			// ラベルに「退任」セット
			obj.label = "退任";
			// 委員会IDをセットする
			obj.committeeid = sleetCommiteeId;
		
			// 委員名をセット
			obj.memberName = _staffName; // TODO:データグリッドで選択された名前
			// 委員名のIDをセット
			obj.selectId = _staffId; // TODO:データグリッドで選択された名前
	
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_committeeMemberChangeDlg);
	
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);		
	    }
	     /**
		 * 	メンバー変更リンクボタンクリックイベント処理(副委員長に任命).
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_subChairAppoint(e:MouseEvent):void
	    {				    	
			// 画面を作成する.
			var pop:CommitteeMemberChangeDlg = new CommitteeMemberChangeDlg();
			PopUpManager.addPopUp(pop, view, true);
			
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// リンクボタンのidをセット
			obj.id = e.target.id;
			// ラベルに「任命」セット
			obj.label = "任命";
			// 委員会IDをセットする
			obj.committeeid = sleetCommiteeId;
		
			// 委員名をセット
			obj.memberName = _staffName; // TODO:データグリッドで選択された名前
			// 委員名のIDをセット
			obj.selectId = _staffId; // TODO:データグリッドで選択された名前
	
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_committeeMemberChangeDlg);
	
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);				
	    }
	     /**
		 * 	メンバー変更リンクボタンクリックイベント処理(副委員長を退任).
		 *
		 * @param e MouseEvent.
		 */
	    public function onClick_subChairFormer(e:MouseEvent):void
	    {				    						
			// 画面を作成する.
			var pop:CommitteeMemberChangeDlg = new CommitteeMemberChangeDlg();
			PopUpManager.addPopUp(pop, view, true);
			
			// 引き継ぐデータを設定する.
			var obj:Object = new Object();
			// リンクボタンのidをセット
			obj.id = e.target.id;
			// ラベルに「退任」セット
			obj.label = "退任";
			// 委員会IDをセットする
			obj.committeeid = sleetCommiteeId;
		
			// 委員名をセット
			obj.memberName = _staffName; // TODO:データグリッドで選択された名前
			// 委員名のIDをセット
			obj.selectId = _staffId; // TODO:データグリッドで選択された名前
	
			IDataRenderer(pop).data = obj;

			// 	closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onClose_committeeMemberChangeDlg);
	
			// P.U画面を表示する.
			PopUpManager.centerPopUp(pop);		
	    }
		/**
		 * CommitteeMemberChangeDlg(各ボタン)のクローズ.
		 *
		 * @param event Closeイベント.
		 */
		private function onClose_committeeMemberChangeDlg(e:CloseEvent):void
		{
			// 「OK」ボタンで終了した場合.
			if(e.detail == Alert.OK)
			{
				// ボタン押下不可
		    	view.noteSave.enabled = false
		    	view.linkJoin.enabled = false;
		    	view.linkRetire.enabled = false;
				view.linkJoinHead.enabled = false;
				view.linkRetireHead.enabled = false;
				view.linkJoinSubHead.enabled = false;
				view.linkRetireSubHead.enabled = false;
				
				// 社員委員会所属の取得	    	
	    		view.committeeService.getOperation("getCommitteeList").send(sleetCommiteeId);
				// 履歴情報を再読み込み
				view.committeeService.getOperation("getCommitteeListLog").send(sleetCommiteeId);
			}
		}
		
		/**
		 * 概要保存ボタン押下処理
		 */
		public function onClick_noteSave(e:Event):void
	    {
	    	// 確認ダイアログ表示
			Alert.show("保存してもよろしいですか？", "",
						Alert.OK | Alert.CANCEL, null,
						onClick_noteSave_updateResult,null, Alert.CANCEL);
	    }
	    /**
		 * 概要保存ボタン押下処理(本処理)
		 */
		public function onClick_noteSave_updateResult(e:CloseEvent):void
		{
			// 確認ダイアログでOKボタンを押下したとき.
			if ( e.detail == Alert.OK )
			{
				//var item:Object = Application.application.indexLogic.view.treeMenu.selectedItem;
				var item:Object = Application.application.indexLogic.view.selectedMenu;
							
				// Dtoに変換
				var mCommitteeDto:MCommitteeDto = new MCommitteeDto();
				mCommitteeDto.committeeId = sleetCommiteeId;
				//mCommitteeDto.committeeName = item.@label;
				mCommitteeDto.committeeName = item.label;
				mCommitteeDto.note = view.mCommitteeList.text;
				
				// 入力文字数判定
				if(view.mCommitteeList.length > 160)
				{	
					// 入力数文字数エラー処理呼び出し
					marginLetter();
					
					return;
				}
				
				// 更新の実行
				view.committeeService.getOperation("insertMCommitteeList").send(mCommitteeDto);	
			}	
		}
				
//--------------------------------------
//  Function
//--------------------------------------

		/**
		 * 社員リストを選択すると実行
		 */
		public function onClick_staffList(e:ListEvent):void
		{
			// 社員IDを取得する.
			_staffId = e.itemRenderer.data.staffId;
			// 社員名を取得する.
			_staffName = e.itemRenderer.data.fullName;
			// 委員会役員IDを取得する.
			_committeePositionId = e.itemRenderer.data.committeePositionId;
			
			// 委員長を選択の場合
			if(_committeePositionId == "1")
			{				
				view.linkRetire.enabled = false;
				view.linkJoinHead.enabled = false;
				view.linkRetireHead.enabled = true;
				view.linkJoinSubHead.enabled = false;
				view.linkRetireSubHead.enabled = false;
			}
			// 副委員長を選択の場合
			else if(_committeePositionId == "2")
			{	
				view.linkRetire.enabled = false;
				view.linkJoinHead.enabled = false;
				view.linkRetireHead.enabled = false;
				view.linkJoinSubHead.enabled = false;
				view.linkRetireSubHead.enabled = true;
			}
			// 社員を選択の場合
			else
			{
				view.linkRetire.enabled = true;
				view.linkJoinHead.enabled = true;
				view.linkRetireHead.enabled = false;
				view.linkJoinSubHead.enabled = true;
				view.linkRetireSubHead.enabled = false;
			}
			
			// 委員長入力済みの場合
			if(committeePosition == "true")
			{
				view.linkJoinHead.enabled = false;
			}
			// 副委員長入力済みの場合
			if(committeeSubPosition == "true")
			{
				view.linkJoinSubHead.enabled = false;
			}
		}
		/**
		 * 経営役職マスタをDBから取得成功
		 * */
		public function onResult_showMPossition(e: ResultEvent):void
		{
			trace("onResult_showPossitionList...");
		
			var positionListDto:PositionListDto = new PositionListDto(e.result);
			_positionList = positionListDto.PositionList;					
		}
		/**
		 * 委員会概要をDBから取得成功
		 * 委員会概要を表示
		 * */
		public function onResult_showMCommittee(e: ResultEvent):void
		{
			trace("onResult_showMCommitteeList...");
		
			var committeeNoteDto:CommitteeNoteDto = new CommitteeNoteDto(e.result);
			_committeeNoteText = committeeNoteDto.MCommitteeNote.note;	
					
		}
		/**
		 * 社員委員会所属一覧をDBから取得成功
		 * 社員委員会所属一覧を表示
		 * */
		public function onResult_showCommitteeList(e: ResultEvent):void
		{
			trace("onResult_showCommitteeList...");
		
			var committeeListDto:CommitteeListDto = new CommitteeListDto(e.result);
			_committeeList = committeeListDto.CommitteeList;
			
			// 「概要」「入会」の押下可能
			view.noteSave.enabled = true
			view.linkJoin.enabled = true;
			
			// 委員会に所属していない場合
			view.mCommitteeList.editable = false;
			view.noteSave.visible = false;
			
			// 委員会概要制御処理
			for each(var committeeList:Object in _committeeList)
			{	
				// 委員会に所属しているまたは、役員権限を持っている場合
				if((inStaffId == committeeList.staffId)||(officerAuthority == true))
				{
					// 委員会に所属している場合
					view.mCommitteeList.editable = true;
					view.noteSave.visible = true;
				}
			}
			
			// 取得した社員委員会所属一覧に役職が存在する場合
			committeePosition = "false";
			committeeSubPosition = "false";
			
			for each(var tmp:CommitteeDto in committeeListDto.CommitteeList)
			{
				// 委員長が存在する場合
				if(tmp.committeePositionId == 1)
				{
					committeePosition = "true";
				}
				// 副委員長が存在する場合
				if(tmp.committeePositionId == 2)
				{
					committeeSubPosition = "true";
				}
			}	
		}
		
		/**
		 * 社員委員会所属履歴をDBから取得成功
		 * 社員委員会所属履歴を表示
		 * */
		public function onResult_showCommitteeListLog(e: ResultEvent):void
		{
			trace("onResult_showCommitteeListLog...");
		
			var committeeListLogDto:CommitteeListLogDto = new CommitteeListLogDto(e.result);
			_committeeListLog = committeeListLogDto.CommitteeListLog;		
		}
		
		/**
		 * 委員会概要更新成功
		 * */
		public function onResult_noteSave_updateResult(e: ResultEvent):void
		{
			trace("委員会概要成功");

	    	// 委員会概要の取得
	    	view.committeeService.getOperation("getMCommitteeList").send(sleetCommiteeId);
			
			// 確認ダイヤルログ表示
			Alert.show("保存に成功しました。", "",
					Alert.OK, null, null, null, Alert.OK);				
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
		 * 不正なパラメータなどで発生(入力文字限界数)
		 * */
		 public function marginLetter():void
		 {
		 	Alert.show("入力文字限界数(160字)を超えています。","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }
//--------------------------------------
//  View-Logic Binding
//--------------------------------------

	    /** 画面 */
	    public var _view:Committee;

	    /**
	     * 画面を取得します

	     */
	    public function get view():Committee
	    {
	        if (_view == null) 
	        {
	            _view = super.document as Committee;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:Committee):void
	    {
	        _view = view;
	    }

	}    
}