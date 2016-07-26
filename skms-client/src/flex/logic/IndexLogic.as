package logic
{
	import components.TreeDescriptor;
	
	import dto.LabelDto;
	import dto.StaffDepartmentHeadDto;
	import dto.StaffDto;
	import dto.StaffNameDto;
	import dto.TreeDto;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.registerClassAlias;
	import flash.ui.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.TreeEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.DragManager;
	import mx.managers.HistoryManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import subApplications.accounting.dto.CommutationDetailDto;
	import subApplications.accounting.dto.CommutationDto;
	import subApplications.accounting.dto.CommutationHistoryDto;
	import subApplications.accounting.dto.CommutationItemDto;
	import subApplications.accounting.dto.CommutationSummaryDto;
	import subApplications.accounting.dto.EquipmentDto;
	import subApplications.accounting.dto.HistoryDto;
	import subApplications.accounting.dto.OverheadDetailDto;
	import subApplications.accounting.dto.OverheadDto;
	import subApplications.accounting.dto.OverheadHistoryDto;
	import subApplications.accounting.dto.OverheadSearchDto;
	import subApplications.accounting.dto.TransportationDetailDto;
	import subApplications.accounting.dto.TransportationDto;
	import subApplications.accounting.dto.TransportationMonthlyDto;
	import subApplications.accounting.dto.TransportationMonthlySearchDto;
	import subApplications.customer.dto.CustomerDto;
	import subApplications.customer.dto.CustomerMemberDto;
	import subApplications.customer.dto.CustomerSearchDto;
	import subApplications.generalAffair.dto.AcademicBackgroundDto;
	import subApplications.generalAffair.dto.AddressApplyDto;
	import subApplications.generalAffair.dto.BusinessCareerDto;
	import subApplications.generalAffair.dto.ChangeAddressApplyDto;
	import subApplications.generalAffair.dto.CommitteeDto;
	import subApplications.generalAffair.dto.CommitteeListDto;
	import subApplications.generalAffair.dto.CommitteeListLabelDto;
	import subApplications.generalAffair.dto.CommitteeListLogDto;
	import subApplications.generalAffair.dto.CommitteeNoteDto;
	import subApplications.generalAffair.dto.MCommitteeDto;
	import subApplications.generalAffair.dto.MPrefectureDto;
	import subApplications.generalAffair.dto.MPrefectureListDto;
	import subApplications.generalAffair.dto.MStaffNameDto;
	import subApplications.generalAffair.dto.MWorkingHoursActionDto;
	import subApplications.generalAffair.dto.MWorkingHoursStatusDto;
	import subApplications.generalAffair.dto.NewMStaffDto;
	import subApplications.generalAffair.dto.PositionListDto;
	import subApplications.generalAffair.dto.StaffAddressDto;
	import subApplications.generalAffair.dto.StaffAddressMoveDateDto;
	import subApplications.generalAffair.dto.StaffDetailDto;
	import subApplications.generalAffair.dto.StaffEntryDto;
	import subApplications.generalAffair.dto.StaffWorkingHoursDto;
	import subApplications.generalAffair.dto.StaffWorkingHoursSearchDto;
	import subApplications.generalAffair.dto.WorkingHoursDailyDto;
	import subApplications.generalAffair.dto.WorkingHoursHistoryDto;
	import subApplications.generalAffair.dto.WorkingHoursMonthlyDto;
	import subApplications.generalAffair.workingConditions.dto.WorkingHoursMonthlyExtDto;
	import subApplications.generalAffair.workingConditions.dto.WorkingHoursMonthlyExtListDto;
	import subApplications.generalAffair.workingConditions.dto.WorkingStaffDto;
	import subApplications.lunch.dto.*;
	import subApplications.personnelAffair.dto.MStaffDto;
	import subApplications.personnelAffair.dto.MStaffSelectDto;
	import subApplications.personnelAffair.license.dto.MAuthorizedLicenceAllowanceLabelListDto;
	import subApplications.personnelAffair.license.dto.MBasicClassDto;
	import subApplications.personnelAffair.license.dto.MBasicClassLabelDto;
	import subApplications.personnelAffair.license.dto.MBasicClassListDto;
	import subApplications.personnelAffair.license.dto.MBasicRankDto;
	import subApplications.personnelAffair.license.dto.MBasicRankLabelDto;
	import subApplications.personnelAffair.license.dto.MBasicRankListDto;
	import subApplications.personnelAffair.license.dto.MCompetentAllowanceDto;
	import subApplications.personnelAffair.license.dto.MCompetentAllowanceLabelDto;
	import subApplications.personnelAffair.license.dto.MCompetentAllowanceListDto;
	import subApplications.personnelAffair.license.dto.MHousingAllowanceDto;
	import subApplications.personnelAffair.license.dto.MHousingAllowanceLabelDto;
	import subApplications.personnelAffair.license.dto.MHousingAllowanceListDto;
	import subApplications.personnelAffair.license.dto.MInformationAllowanceDto;
	import subApplications.personnelAffair.license.dto.MInformationAllowanceLabelDto;
	import subApplications.personnelAffair.license.dto.MInformationAllowanceListDto;
	import subApplications.personnelAffair.license.dto.MManagerialAllowanceDto;
	import subApplications.personnelAffair.license.dto.MManagerialAllowanceLabelDto;
	import subApplications.personnelAffair.license.dto.MManagerialAllowanceListDto;
	import subApplications.personnelAffair.license.dto.MPayLicenceHistoryDto;
	import subApplications.personnelAffair.license.dto.MPayLicenceHistoryListDto;
	import subApplications.personnelAffair.license.dto.MPeriodDto;
	import subApplications.personnelAffair.license.dto.MPeriodListDto;
	import subApplications.personnelAffair.license.dto.MTechnicalSkillAllowanceDto;
	import subApplications.personnelAffair.license.dto.MTechnicalSkillAllowanceLabelDto;
	import subApplications.personnelAffair.license.dto.MTechnicalSkillAllowanceListDto;
	import subApplications.personnelAffair.profile.dto.DisplayItemsShowDto;
	import subApplications.personnelAffair.profile.dto.ProfileDetailDto;
	import subApplications.personnelAffair.profile.dto.ProfileDto;
	import subApplications.personnelAffair.skill.dto.MAuthorizedLicenceCategoryDto;
	import subApplications.personnelAffair.skill.dto.MAuthorizedLicenceDto;
	import subApplications.personnelAffair.skill.dto.SkillLabelDto;
	import subApplications.personnelAffair.skill.dto.SkillStaffDto;
	import subApplications.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillSheetDto;
	import subApplications.project.dto.ProjectBillDto;
	import subApplications.project.dto.ProjectBillItemDto;
	import subApplications.project.dto.ProjectDto;
	import subApplications.project.dto.ProjectMemberDto;
	import subApplications.project.dto.ProjectSearchDto;
	import subApplications.project.dto.ProjectSituationDto;
	import subApplications.system.dto.StaffSettingDto;
	
	import utils.CommonIcon;

 	/**
	 * IndexのLogicクラスです。


	 */
	public class IndexLogic extends Logic
	{

		// ログインした社員の情報
		public var loginStaff:StaffDto;

		// データ更新有りフラグ
		public var modified:Boolean = false;

		// 休憩時間規定
		public var recessHoursList:ArrayCollection;
		
		// 控除数既定
		public var lateDeductionList:ArrayCollection;

		// 直前のツリーメニュー選択Index
		private var _lastTreeItem:Object;
		
		// 遷移先URL
//		private var _nextUrl:String;
		private var _nextTreeItem:Object;

		// この定義は重要 http://bugs.adobe.com/jira/browse/SDK-12218
		private var _hm:HistoryManager;

	
		/** ダミー */
		// clientで使用しないと、serverで使用できないためダミーで定義する.
		private var _dummy1:StaffDto;
		private var _dummy2:StaffNameDto;
		private var _dummy3:StaffSettingDto;
		private var _dummy4:StaffDepartmentHeadDto;

		private var _dummy5:CustomerSearchDto;
		private var _dummy6:CustomerDto;
		private var _dummy7:CustomerMemberDto;

		private var _dummy8:TransportationDto;
		private var _dummy9:TransportationDetailDto;
		private var _dummy0:HistoryDto;

		private var _dummy10:ProjectSearchDto;
		private var _dummy11:ProjectDto;
		private var _dummy12:ProjectMemberDto;
		private var _dummy13:ProjectBillDto;
		private var _dummy14:ProjectBillItemDto;

		private var _dummy15:WorkingHoursMonthlyDto;
		private var _dummy16:WorkingHoursDailyDto;
		private var _dummy17:WorkingHoursHistoryDto;
		private var _dummy18:MWorkingHoursStatusDto;
		private var _dummy19:MWorkingHoursActionDto;
		private var _dummy20:StaffWorkingHoursDto;
		private var _dummy21:StaffWorkingHoursSearchDto;

		private var _dummy22:TransportationMonthlyDto;
		private var _dummy23:TransportationMonthlySearchDto;
		private var _dummy24:LabelDto;

		private var _dummy25:ProjectSituationDto;

		private var _dummy26:CommutationDto;
		private var _dummy27:CommutationDetailDto;
		private var _dummy28:CommutationItemDto;
		private var _dummy29:CommutationHistoryDto;
		private var _dummy30:CommutationSummaryDto;

		private var _dummy31:SkillStaffDto;
		private var _dummy32:StaffSkillSheetDto;
		private var _dummy33:StaffAddressMoveDateDto;

		private var _dummy34:OverheadDto;
		private var _dummy35:OverheadDetailDto;
		private var _dummy36:OverheadSearchDto;
		private var _dummy37:OverheadHistoryDto;

		private var _dummy38:CommitteeDto;
		private var _dummy39:CommitteeListDto;

		private var _dummy40:ChangeAddressApplyDto;
		private var _dummy41:StaffAddressDto;

		private var _dummy42:CommitteeListLogDto;
		private var _dummy43:MCommitteeDto;
		private var _dummy44:CommitteeNoteDto;
		private var _dummy45:SkillLabelDto;

		private var _dummy46:MPrefectureDto;
		private var _dummy47:MPrefectureListDto;

		private var _dummy48:EquipmentDto;
		private var _dummy49:ProfileDto;
		
		private var _dummy50:WorkingStaffDto;
		private var _dummy51:WorkingHoursMonthlyExtDto;
		private var _dummy52:WorkingHoursMonthlyExtListDto;
		
		private var _dummy53:ProfileDetailDto;
		
		private var _dummy54:AcademicBackgroundDto;
		private var _dummy55:BusinessCareerDto;

		private var _dummy56:DisplayItemsShowDto;

		private var _dummy57:ExclusiveOptionDto;
		private var _dummy58:MenuCategoryDto;
		private var _dummy59:MenuOrderDto;
		private var _dummy60:MenuOrderOptionDto;
		private var _dummy61:MShopAdminDto;
		private var _dummy62:MLunchShopDto;
		private var _dummy63:MMenuDto;
		private var _dummy64:MOptionKindDto;
		private var _dummy65:MOptionSetDto;
		private var _dummy66:OptionDto;
		private var _dummy67:OptionKindDto;
		private var _dummy68:OptionSetDto;
		private var _dummy69:ShopMenuDto;
		
		private var _dummy70:MStaffDto;
		private var _dummy71:MStaffSelectDto;
		
		private var _dummy72:MPayLicenceHistoryDto;
		private var _dummy73:MPayLicenceHistoryListDto;
		private var _dummy74:MManagerialAllowanceDto;
		private var _dummy75:MManagerialAllowanceLabelDto;
		private var _dummy76:MTechnicalSkillAllowanceDto;		
		private var _dummy77:MTechnicalSkillAllowanceLabelDto;		
		private var _dummy78:MHousingAllowanceDto;		
		private var _dummy79:MHousingAllowanceLabelDto;	
		private var _dummy80:MCompetentAllowanceDto;		
		private var _dummy81:MCompetentAllowanceLabelDto;
		private var _dummy82:MAuthorizedLicenceAllowanceLabelListDto;
		private var _dummy83:MBasicClassLabelDto;
		private var _dummy84:MBasicRankLabelDto;
		private var _dummy85:MInformationAllowanceDto;
		private var _dummy86:MInformationAllowanceLabelDto;
		private var _dummy88:MCompetentAllowanceListDto;
		private var _dummy89:MHousingAllowanceListDto;
		private var _dummy90:MInformationAllowanceListDto;
		private var _dummy91:MManagerialAllowanceListDto;
		private var _dummy92:MTechnicalSkillAllowanceListDto;
		
		private var _dummy93:MenuDto;
		
		private var _dummy94:MBasicClassListDto;
		private var _dummy95:MBasicClassDto;
		
		private var _dummy96:StaffDtoList;
		
		private var _dummy97:MPeriodDto;
		private var _dummy98:MPeriodListDto;
		
		private var _dummy99:MAuthorizedLicenceDto;
		private var _dummy100:MAuthorizedLicenceCategoryDto;
		
		private var _dummy101:MBasicRankDto;
		private var _dummy102:MBasicRankListDto;
		
		private var _dummy103:PositionListDto;
		private var _dummy104:CommitteeListLabelDto;
		
		private var _dummy105:AddressApplyDto;
		private var _dummy106:MStaffNameDto;
		private var _dummy107:NewMStaffDto;
		private var _dummy108:StaffDetailDto;
		private var _dummy109:StaffEntryDto;
		
		private var _dummy110:StaffAuthorizedLicenceDto;
		
		
//--------------------------------------
//  Constructor
//--------------------------------------
	    /**
	     * コンストラクタ
	     */
		public function IndexLogic()
		{
			super();
		}

//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * onCreationCompleteHandler
	     */
	    override protected function onCreationCompleteHandler(event:FlexEvent):void 
	    {
	    	// AS3では RemoteClassで定義してもマッピングされない。
	    	// →dummyとして変数宣言する or registerClassAliasで登録する。
	    	registerClassAlias("services.system.dto.TreeDto", TreeDto);
	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

        public function onCreationComplete_App(e:Event):void
        {
        	// ログインユーザ情報の取得
            view.srv.getOperation("getLoginUserInfo").send(view.parameters.i);
			// 休憩時間規定データの取得
	    	view.srv2.getOperation("getRecessHoursList").send();
			// 遅刻控除規定データの取得
	    	view.srv2.getOperation("getLateDeductionList").send();
        }

//        private function deleteTreeNodeById(treeNodes:XMLList, id:String):void
//        {
//			for(var i:Number=0; i < treeNodes.length(); i++) {
//				if( treeNodes[i].@id == id ) {
//					delete treeNodes[i];
//					return;
//				}
//			}
//
//			var children:XMLList = XMLList(treeNodes.children());
//			deleteTreeNodeById(children, id);
//        }

		/**
		 * メニューの初期化
		 * 
		 * @param e FlexEvent
		 */
        public function onInitialize_treeMenu(e:FlexEvent):void
        {
//			var tree:Tree = view.myMenu;
			var tree:Tree = (Tree)(e.currentTarget);
			tree.setStyle("defaultLeafIcon", null);
			tree.setStyle("folderOpenIcon", null);
			tree.setStyle("folderClosedIcon", null);
//			view.treeMenu.dataProvider = view._treeMenuItems;
        }
        
		/**
		 * マイメニューの初期化
		 * 
		 * @param e FlexEvent
		 */
        public function onInitialize_myTreeMenu(e:FlexEvent):void
        {
			var tree:Tree = view.myMenu;
			tree.setStyle("defaultLeafIcon", null);
			tree.setStyle("folderOpenIcon", null);
			tree.setStyle("folderClosedIcon", null);
        }
        
        /**
         * メニューの選択
         * 
         * @param e ListEvent 
         */
        public function onChange_treeMenu(e:ListEvent):void
        {
        	// メニューを選択する。
        	changeMenu(e);
        	// マイメニューの選択を解除する。
        	view.myMenu.selectedItem = null;
        }

        /**
         * マイメニューの選択
         * 
         * @param e ListEvent 
         */
        public function onChange_myMenu(e:ListEvent):void
        {
        	// メニューを選択する。
        	changeMenu(e);
        	// メニューの選択を解除する。
        	view.treeMenu.selectedItem = null;
        }
        
		/**
		 * ヘルプボタンのクリックイベント
		 *
		 * @param event FlexEvent
		 */
		public function onClick_contentsHelp(e:MouseEvent):void
		{
			// ヘルプ画面を表示する.
			var mode:String;
			switch (view.body.url) {
				case null:
					// 社員プロジェクト役職がPMのとき..
					if (loginStaff.isAuthorisationProjectEntry()) {
						mode = "indexPM";
					}
					// 社員部署長が総務部のとき.
					else if (loginStaff.isDepartmentHeadGA()){
						mode = "indexAF";
					}
					// それ以外のとき.
					else {
						mode = "underConstruction";
					}
					break;
				case "./subApplications/accounting/web/TransportRequest.swf":
					mode = "TransportRequest";
					break;
				case "./subApplications/accounting/web/TransportApproval.swf":
					mode = "TransportApproval";
					break;
				case "./subApplications/project/web/ProjectList.swf":
					// プロジェクト権限を取得・設定する.
					if (loginStaff.isAuthorisationProjectEntry())
						mode = "ProjectEntry";
					else
						mode = "ProjectRef";
					break;
				case "./subApplications/system/web/StaffSetting.swf":
					mode = "StaffSetting";
					break;
				case "./subApplications/customer/web/CustomerList.swf":
					if (loginStaff.isAuthorisationCustomerEntry())	mode = "CustomerEntry";
					else 											mode = "CustomerRef";
					break;
				default:
					mode = "UnderConstruction";
					break;
			}
			opneHelpWindow(mode);
		}

	    /**
	     * getList処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onGetLoginUserInfoResult(e:ResultEvent):void
        {
        	if (e.result != null && e.result.staffId != 0) {
	        	var df:DateFormatter = new DateFormatter();
	        	df.formatString = "YYYY年MM月DD日 (EEE)";
	        	view.todayDate.text = df.format(new Date);
        		loginStaff = e.result as StaffDto;
		        view.loginUser.text = loginStaff.staffName.fullName + " さん";
		        view.allContents.visible = true;
		        
// 2010.06.01 メニューはDBから取得　change start 
//				var children:XMLList = XMLList(view._treeMenuItems.children());
//				// 総務部長でもPMでもなければ
//				if (!loginStaff.isDepartmentHeadGA()
//					&& !loginStaff.isProjectPositionPM()) {
//					deleteTreeNodeById(children, "nodeTransportApproval");
//					deleteTreeNodeById(children, "nodeTransportTotal");
//					deleteTreeNodeById(children, "nodeWorkingHoursTotal");
//					deleteTreeNodeById(children, "nodeWorkingConditions");
//					deleteTreeNodeById(children, "nodeOverheadApproval");
//					deleteTreeNodeById(children, "nodeCommutationApproval");
//					deleteTreeNodeById(children, "nodeStaffWorkStatus");
//					deleteTreeNodeById(children, "nodeCompanyLicenseList");
//					deleteTreeNodeById(children, "nodeMaintenance");
//					deleteTreeNodeById(children, "nodePaidVacationMaintenance");
//					deleteTreeNodeById(children, "nodeChangeAddressApproval");						
//				}else{
//					deleteTreeNodeById(children, "nodeRegisterShopMenu");
//					deleteTreeNodeById(children, "nodeRegisterCategory");
//					deleteTreeNodeById(children, "nodeRegisterOptionSet");
//					deleteTreeNodeById(children, "nodeRegisterOptionKind");
//					deleteTreeNodeById(children, "nodeRegisterShopAdmin");
//				}
//					// 2009/12/10 一時的に消去！
//					deleteTreeNodeById(children, "nodeLunch");
//					deleteTreeNodeById(children, "nodeCommittee");
//					deleteTreeNodeById(children, "nodeSeminer");
//					deleteTreeNodeById(children, "nodeQualificationsAssessment");
//					
//					deleteTreeNodeById(children, "nodeWorkStatus");
//					deleteTreeNodeById(children, "nodeBelonging");
//					
//				//}
//				
//				// 総務部長でもPMでもPLでもなければ
////				if (!loginStaff.isDepartmentHeadGA()
////					&& !loginStaff.isProjectPositionPM()
////					&& !loginStaff.isProjectPositionPL()) {
////					deleteTreeNodeById(children, "nodeWorkingHoursApproval");
////				}
//	            view.treeMenu.expandChildrenOf(view._treeMenuItems, true);
//
//				// TODO:もうちょっとスマートな方法がないか？
//
//
//				view.treeMenu.selectedIndex = 0;
//				view.body.url = "./subApplications/home/web/HomePage.swf";

		    	// メニューリストの取得
		    	view.srv3.getOperation("getMenuList").send(loginStaff.staffId);
		    	
        		// マイメニュー表示ならば
        		if (this.loginStaff.staffSetting.myMenu)
        		{
			    	// マイメニューリストの取得
			    	view.srv3.getOperation("getMyMenuList").send(loginStaff.staffId);
        		}
        		else
        		{
        			// マイメニューを削除
        			view.menuArea.removeChild(view.myMenuArea);
        		}
        		view.menuArea.visible = true;   		   	
// 2010.06.01 メニューはDBから取得　change end 

        	} else {
        		Alert.show("認証に失敗しました。", "" , Alert.OK, view, null, CommonIcon.exclamationIcon);
        		var u:URLRequest = new URLRequest("https://www.sfk-carp.jp/wiz/");
        		navigateToURL(u,"_self");
        	}
        }

        /**
		  * getRecessHoursList処理の結果イベント
		  *
		  * @param e ResultEvent
		  */
	    public function onResult_getRecessHoursList(e:ResultEvent):void
	    {
	       	recessHoursList = e.result as ArrayCollection;
		}

		/**
		  * getLateDeductionList処理の結果イベント
		  *
		  * @param e ResultEvent
		  */
	    public function onResult_getLateDeductionList(e:ResultEvent):void
	    {
	       	lateDeductionList = e.result as ArrayCollection;
		}

	    /**
	     * getMenuList処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getMenuList(e:ResultEvent):void
        {
        	if (e.result != null)
        	{
        		view.treeMenu.dataProvider = e.result as ArrayCollection;
        		view.treeMenu.dataDescriptor = new TreeDescriptor();
        		view.treeMenu.validateNow();
        		
        		// 全メニュー表示ならば
        		if (this.loginStaff.staffSetting.allMenu)
        		{
        			openBranch(view.treeMenu.dataProvider, view.treeMenu);
        		}
        		
        		// マイメニュー非表示ならば
        		if (!this.loginStaff.staffSetting.myMenu)
        		{
        			view.treeMenu.selectedIndex = 0;
					showNextPage(view.treeMenu);
        		}
        	}
        }
        
	    /**
	     * getMyMenuList処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_getMyMenuList(e:ResultEvent):void
        {
        	if (e.result != null)
        	{
        		view.myMenu.dataProvider = e.result as ArrayCollection;
        		view.myMenu.dataDescriptor = new TreeDescriptor();
        		view.myMenu.validateNow();
        		
        		// マイメニュー表示ならば
        		if (this.loginStaff.staffSetting.myMenu)
        		{
	        		if (ArrayCollection(view.myMenu.dataProvider).length > 0)
	        		{
						view.myMenu.selectedIndex = 0;
						showNextPage(view.myMenu);
	        		}
        		}
        	}
        }
        
	    /**
	     * entryMyMenuList処理の結果イベント
	     *
	     * @param e ResultEvent
	     */
        public function onResult_entryMyMenuList(e:ResultEvent):void
        {
        	view.myMenu.validateNow();	
        }
        
	    /**
	     * リモート呼び出しの失敗イベント（共通）
	     *
	     * @param e FaultEvent
	     */
	    public function onFault(e:FaultEvent):void
	    {
       		Alert.show("データベースにアクセスできません。\n"+e.toString(),
       			"" , Alert.OK, view, null, CommonIcon.exclamationIcon);
	        trace(e);
	    }
	    
	    /**
	     * メニューリストのDragStartイベント. 
	     * 
	     * @param e DragEvent
	     */
	    public function onDragStart_treeMenu(e:DragEvent):void
	    {
    		// treeを取得する。
   			var tree:Tree = Tree(e.dragInitiator);
   			
	    	var items:Array = Tree(e.dragInitiator).selectedItems;
	    	for each (var item:Object in items)
	    	{
	    		// branceはdragさせない。
	    		if (tree.dataDescriptor.isBranch(item))
	    		{
	    			e.preventDefault();
	    			return;
	    		}	    		
	    	}    	
	    }
	    
	    /**
	     * メニューリストのDragEnterイベント. 
	     * 
	     * @param e DragEvent
	     */
	    public function onDragEnter_treeMenu(e:DragEvent):void
	    {
	    	// マイメニュー以外は dragをキャンセルする。
			if (e.dragInitiator != view.myMenu) 
			{
				e.preventDefault();
				return;
			}		
	    }   
	    
	    /**
	     * お気に入りメニューリストのDragDropイベント. 
	     * 
	     * @param e DragEvent
	     */
	    public function onDragDrop_myMenu(e:DragEvent):void
	    {
	    	if (e.dragSource.hasFormat("treeItems") && e.dragInitiator is Tree)
	    	{
    			// dropを中止する。
   				e.preventDefault();
    			
   				// dropフィードバックを非表示にする。
   				e.target.hideDropFeedback(e);

				// dragデータを取得する。
				var itarget:Tree = e.dragInitiator as Tree;
				var ilist:IList  = ObjectUtil.copy(itarget.dataProvider) as IList;
	    		var iindices:Array = itarget.selectedIndices;
	    		iindices.sort(Array.NUMERIC | Array.DESCENDING);
				
				// drop先を取得する。
	    		var ctarget:Tree = e.currentTarget as Tree;
	    		var clist:IList  = ctarget.dataProvider as IList;
	    		
	   			// drop先indexを取得する。
	   			var dflag:Boolean = false;
	   			var dindex:int = ctarget.calculateDropIndex(e);
	   			if (dindex < 1) 
	   			{	
	  				dindex = 1;								// 「HOME」の次に設定する。
	  				dflag = true;
	   			}					
	   			else if (dindex > clist.length - 1) 	
	   			{
	   				dindex = clist.length - 1;				// 「La!Coodaに戻る」の前に設定する。
	  				dflag = true;
	   			}	
	    			
	    		// メニューリストからDragされたとき
	    		if (Tree(e.dragInitiator).id == "treeMenu") 
	    		{
	    			// 同メニューが存在するかどうか確認する。
	    			for each (var iindex:int in iindices) 
	    			{
	    				var flag:Boolean = true;
	    				var item:Object;
		    			for each (var cobj:Object in clist) 
		    			{		    				
		    				// 同じメニューが存在したとき
		    				item = IListItemRenderer(itarget.indexToItemRenderer(iindex)).data;
							if (ObjectUtil.compare(cobj.id, item.id) == 0)
							{
								// メニューに追加しない。
								flag = false;
								break;
							}     				
		    			}
		    			
		    			// メニューに追加する。
		    			if (flag)
		    			{
		    				clist.addItemAt(item, dindex); 
		    			}
	    			}   			
	    		}
	    		// マイメニューからDragされたとき
	    		else if (Tree(e.dragInitiator).id == "myMenu")
	    		{
					// dragデータを削除する。
					var diff:int = 0;
					for each (var iindex2:int in iindices)
					{
						if (dindex > iindex2)	diff++;
						clist.removeItemAt(iindex2);
		  			}		    				    			
		  				
					// メニューに追加する。
					var cnt3:int = 0;
					iindices.sort(Array.NUMERIC);
					for each (var iindex3:int in iindices)
					{
						clist.addItemAt(ilist.getItemAt(iindex3), dindex - diff + cnt3);
						cnt3++;
	  				}		    				    			
	    		}	    		
	    	}
	    }
	    
	    /**
	     * マイメニューのDragStartイベント. 
	     * 
	     * @param e DragEvent
	     */
	    public function onDragStart_myMenu(e:DragEvent):void
	    {
	    	var items:Array = Tree(e.dragInitiator).selectedItems;
	    	for each (var item:Object in items)
	    	{
	    		// 「HOME」と「La!Coodaに戻る」は dragさせない。
	    		if (item.enabled == false)
	    		{
	    			e.preventDefault();
	    			return;
	    		}	    		
	    	}
	    }
	        
	    /**
	     * マイメニューのDragCompleteイベント. 
	     * 
	     * @param e DragEvent
	     */
	    public function onDragComplete_myMenu(e:DragEvent):void
	    {
	    	// 以下の理由により、ここでで データ削除など行う。
	    	// ・dragMoveEnabled = true で メニューに drop したとき、キャンセルしても drop される。
	    	// →なぜか dragComplete() で drop している。
	    	// ・dragMoveEnabled = false で にすると DragManager.showfeedback(…)を実行しても
	    	// 　カーソル表示制御がうまくいかない。。。
	    	
	    	// メニューに drop したとき
	    	if (e.relatedObject == view.treeMenu)
	    	{
	    		// dropを中止する。
		    	e.preventDefault();
		    	
   				// dropフィードバックを非表示にする。
   				Tree(e.dragInitiator).hideDropFeedback(e);
				Tree(e.relatedObject).hideDropFeedback(e);
				
				//// dragデータを取得する。
	    		var tree:Tree = e.dragInitiator as Tree;
	    		var list:IList = IList(tree.dataProvider);
	    		var indices:Array = tree.selectedIndices;
	    		indices.sort(Array.NUMERIC | Array.DESCENDING);
	    		for (var i:int = 0; i < indices.length; i++)
	    		{
			    	list.removeItemAt(indices[i]);
	    		}
    			return;	    		    	
	    	}
	    	// Bodyに drop したとき
	    	else if (e.relatedObject == view.rightContent)
	    	{
   				// dropフィードバックを非表示にする。
   				Tree(e.dragInitiator).hideDropFeedback(e);
				return;	    		
	    	}
	    }
	    
// 	onDragComplete_myMenu()で後処理を行うため、コメントアウトする。    
//	    /**
//	     * マイメニュー削除のDragDroptイベント. 
//	     * 
//	     * @param e DragEvent
//	     */
//	    public function onDragDrop_rightContent(e:DragEvent):void
//	    {
//	    	if (e.dragSource.hasFormat("treeItems") && e.dragInitiator is Tree)
//	    	{
//	    		// マイメニューからDragされたとき
//	    		if (Tree(e.dragInitiator).id == "myMenu")
//	    		{
//	   				// dropフィードバックを非表示にする。
//	   				Tree(e.dragInitiator).hideDropFeedback(e);
//
//	    			// dragMoveEnabled = true のため removeしなくても削除される。
//					//// dragデータを取得する。
//		    		//var tree:Tree = e.dragInitiator as Tree;
//		    		//var list:IList = IList(tree.dataProvider);
//			    	//list.removeItemAt(tree.selectedIndex);
//	    			//return;
//	    		}	    	
//	    	}
//	    	e.preventDefault();	    	
//	    }
	    
	    /**
	     * マイメニュー削除のDragEnterイベント. 
	     * 
	     * @param e DragEvent
	     */
	    public function onDragEnter_rightContent(e:DragEvent):void
	    {
	    	if (e.dragSource.hasFormat("treeItems") && e.dragInitiator is Tree)
	    	{
	    		// マイメニューからDragされたとき
	    		if (Tree(e.dragInitiator).id == "myMenu")
	    		{
	    			DragManager.acceptDragDrop(view.rightContent);  			
	    			return;
	    		}	    	
	    	}	    	
	    	e.preventDefault();	    	
	    }
	    
	    /**
	     * マイメニュー編集ボタンクリック
	     * 
	     * @param e MouseEvent
	     */
	    public function onClick_btnEdit(e:MouseEvent):void
	    {
	    	// マイメニュー編集をクリックしたとき
	    	if (view.btnEdit.selected)
	    	{	
	    		view.btnEdit.label = "マイメニュー登録終了";
	    		// メニュー
	    		view.treeMenu.dragEnabled = true;
	    		view.treeMenu.dragMoveEnabled = false;
	    		view.treeMenu.allowMultipleSelection = true;
	    		view.treeMenu.dropEnabled = true;
	    		// マイメニュー
	    		view.myMenu.dragEnabled = true;
	    		view.myMenu.dragMoveEnabled = true;
	    		view.myMenu.dropEnabled = true;
	    		view.myMenu.allowMultipleSelection = true;
		    	// マイメニュー削除
		    	view.rightContent.addEventListener(DragEvent.DRAG_ENTER, onDragEnter_rightContent, true);
//		    	view.rightContent.addEventListener(DragEvent.DRAG_DROP,  onDragDrop_rightContent);
		    	view.rightContent.enabled = false;
	    	}
	    	// マイメニュー編集終了をクリックしたとき
	    	else
	    	{
	    		// マイメニューをDBに登録する。
	    		view.srv3.getOperation("entryMyMenuList").send(loginStaff.staffId, ArrayCollection(view.myMenu.dataProvider));	
	    		
	    		view.btnEdit.label = "マイメニュー登録";
	    		// メニュー
	    		view.treeMenu.dragEnabled = false;
	    		view.treeMenu.dragMoveEnabled = false;
	    		view.treeMenu.allowMultipleSelection = false;
	    		view.treeMenu.dropEnabled = false;
	    		// マイメニュー
	    		view.myMenu.dragEnabled = false;
	    		view.myMenu.dragMoveEnabled = false;
	    		view.myMenu.dropEnabled = false;
	    		view.myMenu.allowMultipleSelection = false;
		    	// マイメニュー削除
		    	view.rightContent.removeEventListener(DragEvent.DRAG_ENTER, onDragEnter_rightContent, true);
//		    	view.rightContent.removeEventListener(DragEvent.DRAG_DROP,  onDragDrop_rightContent);
		    	view.rightContent.enabled = true;	    
		    	
		    	// メニューの選択状況を元に戻す。
	        	view.myMenu.selectedItem = null;
	    		view.treeMenu.selectedItem = null;
	    		view[_lastTreeItem.memo].selectedItem = getSelectMenu(_lastTreeItem);
	    	}
	    }
	    
//--------------------------------------
//  Function
//--------------------------------------

	    /**
	     * データ破棄 確認結果.<br>
	     *
	     * @param e CloseEvent
	     */
		private function onClose_CancelAlert(e:CloseEvent):void
		{
			// 選択したリンクボタンの処理を呼び出す.
			if (e.detail == Alert.YES) {
				//showNextPage(_nextUrl);
				showNextPage(view[_nextTreeItem.memo] as Tree);
			} else {
				//view.treeMenu.selectedItem = _lastTreeItem;
	        	view.myMenu.selectedItem = null;
	    		view.treeMenu.selectedItem = null;
	    		view[_lastTreeItem.memo].selectedItem = getSelectMenu(_lastTreeItem);
	  		}
		}

	    /**
	     * 画面遷移処理.<br>
	     *
	     */
//		private function showNextPage(nextUrl:String):void
		private function showNextPage(tree:Tree):void
		{
//			_lastTreeItem = view.treeMenu.selectedItem;
			_lastTreeItem = cnvSelectMenu(tree);
			var nextUrl:String = tree.selectedItem.url;
			var urlRef:int = tree.selectedItem.urlRef;
//			if (nextUrl.search("http") == 0) {
//       			var u:URLRequest = new URLRequest(nextUrl);
//       			navigateToURL(u,"_self");
//			}
			if (urlRef == 1) {
       			var u:URLRequest = new URLRequest(nextUrl);
       			navigateToURL(u,"_self");			
			}
			else if (urlRef == 2){				
				var winName:String = "";							// ウィンドウ名.
				var w:int  = this._view.width;
				var h:int  = this._view.height;
				var toolbar:int = 0;								// ツールバーの表示.
				var location:int = 1;								// 場所ツールバーの表示.
				var directories:int = 0;							// ユーザ設定のツールバーの表示.
				var status:int = 0;									// ステータスバーの表示.
				var menubar:int = 0;								// メニューバーの表示.
				var scrollbars:int = 1;								// スクロールバーの表示.
				var resizable:int = 1;								// リサイズ設定.
				var fullURL:String = "javascript:var myWin;" + "if(!myWin || myWin.closed)" + "{myWin = window.open('" + nextUrl + "','" + winName + "','" + "width=" + w + ",height=" + h  + ",toolbar=" + toolbar + ",location=" + location + ",directories=" + directories + ",status=" + status + ",menubar=" + menubar + ",scrollbars=" + scrollbars + ",resizable=" + resizable + ",top='+((screen.height/2)-(" + h/2 + "))+'" + ",left='+((screen.width/2)-(" + w/2 + "))+'" + "')}"
															 + "else{myWin.location.href='" + nextUrl + "';" + "myWin.focus();};void(0);";
				var u2:URLRequest = new URLRequest(fullURL);
				navigateToURL(u2,"_self");
			}
			else {
				if (nextUrl != "") {
					view.body.unloadModule();
					view.body.loadModule(nextUrl);
				} else {
					view.body.url = "";
				}
			}
			modified = false;	
		}
		
		/**
		 * Tree Branchオープン
		 * 
		 * @param tree Tree
		 * @param item Treeアイテム
		 */
		private function openBranch(list:Object, tree:Tree):void
		{
        	for each (var item:Object in list)
        	{
				// Branchをopenする。
				tree.expandItem(item, true);
			
				if (tree.dataDescriptor.isBranch(item))//ツリーが終端であった場合?
				{
					openBranch(item[(Object)(tree.dataDescriptor).blanchField], tree);
				}
			}
		}		
		
       
       /**
        * メニューの選択
        * 
        * @param e ListEvent 
        */
        private function changeMenu(e:ListEvent):void
        {
        	// マイメニュー登録中のときは 画面遷移しない。
        	if (view.btnEdit.selected)	return;
        				
			var item:Object = e.itemRenderer.data;
			var tree:Tree = e.currentTarget as Tree;
			var des:ITreeDataDescriptor = tree.dataDescriptor;
			var isBranch:Boolean = des.isBranch(item);

/*			if(isBranch){
			    var isOpen:Boolean = tree.isItemOpen(item);
			    tree.expandItem(item, !isOpen, true, true, e);
			} else {
*/
			//追加 @auther okamoto
			if(!isBranch){
				var cancel:Boolean = false;
//				_nextUrl = item.@url;
				_nextTreeItem = cnvSelectMenu(tree);
				if (modified) {
					Alert.show("データが変更されましたが保存されていません。\nデータを破棄して画面遷移してもよろしいですか？",
					 "",
					  Alert.YES | Alert.NO,
					   view,
					    onClose_CancelAlert,
					    CommonIcon.questionIcon);
				} else {
//					showNextPage(_nextUrl);
//					showNextPage(tree);

					tree.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				}
			}
        }
        
        //追加 @auther okamoto
		private function keyDownHandler(e:KeyboardEvent):void{
			var tree:Tree = e.currentTarget as Tree;
			
			if(e.keyCode == Keyboard.ENTER){
				showNextPage(tree);
			}
		}
       
        //追加 @auther okamoto
        public function itemClickHandler(e:ListEvent):void
        {
        	// マイメニュー登録中のときは 画面遷移しない。
        	if (view.btnEdit.selected)	return;
        	
			var item:Object = e.itemRenderer.data;
			var tree:Tree = e.currentTarget as Tree;
			var des:ITreeDataDescriptor = tree.dataDescriptor;
			var isBranch:Boolean = des.isBranch(item);
			
			if(isBranch){
			    var isOpen:Boolean = tree.isItemOpen(item);
			    tree.expandItem(item, !isOpen, true, true, e);
			} else {
				var cancel:Boolean = false;
				_nextTreeItem = cnvSelectMenu(tree);
				
				if (modified) {
					Alert.show("データが変更されましたが保存されていません。\nデータを破棄して画面遷移してもよろしいですか？",
					 "",
					  Alert.YES | Alert.NO,
					   view,
					    onClose_CancelAlert,
					    CommonIcon.questionIcon);
				}else{
					showNextPage(tree);
				}
			}
        }
        
        /**
         * 選択メニュー情報の設定
         * 
         * @param tree
         * @param item
         */
        private function cnvSelectMenu(tree:Tree):Object
        {
        	var item:Object = tree.selectedItem;
			item.memo = tree.id;
			return item;
        }
        
        /**
         * 選択メニュー情報の取得 
         * 
         * @param item
         */
        private function getSelectMenu(item:Object):Object
        {
        	if (!item)	return null;
        	var tree:Tree = view[item.memo] as Tree;
        	return searchSelectMenu(tree.dataProvider, tree.dataDescriptor, item.id);
        }
        private function searchSelectMenu(list:Object, descriptor:ITreeDataDescriptor, key:String):Object
        {
        	for each (var item:Object in list)
        	{
        		if (item.id == key)		return item;
        		
	        	if (descriptor.isBranch(item))
	        	{
	        		var ret:Object = searchSelectMenu(item[(Object)(descriptor).blanchField], descriptor, key);
	        		if (ret)		return ret;
	        	}
        	}
        	return null;	
        }

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:Index;

	    /**
	     * 画面を取得します。
	     */
	    public function get view():Index {
	        if (_view == null) {
	            _view = super.document as Index;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:Index):void {
	        _view = view;
	    }
	    
	    /** 
	     * 選択メニューを取得します。 
	     */
	    public function get selectedMenuItem():Object
	    {
	    	return _lastTreeItem;
	    }
	    
	}
}