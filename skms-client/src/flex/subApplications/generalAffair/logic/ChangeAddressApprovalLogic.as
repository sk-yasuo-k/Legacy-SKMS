package subApplications.generalAffair.logic
{
	import enum.AddressActionId;
	import enum.AddressStatusId;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.dto.ChangeAddressApplyDto;
	import subApplications.generalAffair.dto.ChangeAddressApprovalDto;
	import subApplications.generalAffair.dto.StaffAddressDto;
	import subApplications.generalAffair.web.ChangeAddressApproval;
	
	
	/**
	 * 社員住所承認ロジッククラスです.
	 */	
	public class ChangeAddressApprovalLogic extends Logic
	{
		/** ログイン社員ID */
		public var loginStaffId:int = Application.application.indexLogic.loginStaff.staffId;

		/** 社員ID */
		public var _staffId:int;
		
		/** 提出一覧 */
		[Bindable]
		public var _staffAddressApproval:ArrayCollection;

		/** 住所の履歴 */
		[Bindable]
		public var getStaffAddressList:ArrayCollection;
			
		/** 状態 */	
		public var statusId:int;
		
		
	//現住所用変数
		/** 現住所の履歴 */
		[Bindable]
		public var _staffAddressList:ArrayCollection;
		
		/** 現住所の情報 */
		[Bindable]
		public var _staffAddressText:ChangeAddressApplyDto;	
						
		/** 引越日 */
		[Bindable]
		public var moveDate:String;

		/** 郵便番号1 */
		[Bindable]
		public var postalCode1:String;
		
		/** 郵便番号2 */
		[Bindable]
		public var postalCode2:String;

		/** 都道府県名 */
		[Bindable]
		public var prefectureName:String;
		
		/** 市区町村番地 */
		[Bindable]
		public var ward:String;		
		
		/** ビル */
		[Bindable]
		public var houseNumber:String;

		/** 市区町村(フリガナ) */
		[Bindable]
		public var wardKana:String;

		/** ビル(フリガナ) */
		[Bindable]
		public var houseNumberKana:String;

		/** 自宅電話番号1 */
		[Bindable]
		public var homePhoneNo1:String;

		/** 自宅電話番号2 */
		[Bindable]
		public var homePhoneNo2:String;
		
		/** 自宅電話番号3 */
		[Bindable]
		public var homePhoneNo3:String;

		/** 表札名 */
		[Bindable]
		public var nameplate:String;
		
		/** 世帯主 */
		[Bindable]
		public var householder:String;		

		/** 連絡のとりやすい社員 */
		[Bindable]
		public var associateStaff:String;
		
		
	//新住所用変数
		/** 新住所の情報 */
		[Bindable]
		public var _newStaffAddressText:ChangeAddressApplyDto;			
		
		/** 新住所の履歴 */
		[Bindable]
		public var _newStaffAddressList:ArrayCollection;
		
		/** 新住所の引越日 */
		[Bindable]
		public var newMoveDate:String;
		
		/** 新住所の郵便番号1 */
		[Bindable]
		public var newPostalCode1:String;
		
		/** 新住所の郵便番号2 */
		[Bindable]
		public var newPostalCode2:String;

		/** 新住所の都道府県名 */
		[Bindable]
		public var newPrefectureName:String;
		
		/** 新住所の市区町村番地 */
		[Bindable]
		public var newWard:String;		
		
		/** 新住所のビル */
		[Bindable]
		public var newHouseNumber:String;

		/** 新住所の市区町村(フリガナ) */
		[Bindable]
		public var newWardKana:String;

		/** 新住所のビル(フリガナ) */
		[Bindable]
		public var newHouseNumberKana:String;

		/** 新住所の自宅電話番号1 */
		[Bindable]
		public var newHomePhoneNo1:String;

		/** 新住所の自宅電話番号2 */
		[Bindable]
		public var newHomePhoneNo2:String;
		
		/** 新住所の自宅電話番号3 */
		[Bindable]
		public var newHomePhoneNo3:String;

		/** 新住所の表札名 */
		[Bindable]
		public var newNameplate:String;
		
		/** 新住所の世帯主 */
		[Bindable]
		public var newHouseholder:String;
		
		/** 新住所の連絡のとりやすい社員 */
		[Bindable]
		public var newAssociateStaff:String;
		
		/** 履歴に追加する情報 */
		public var _renewStaffAddress:ChangeAddressApplyDto = new ChangeAddressApplyDto();	

		/** 地図ボタン用変数 */	
		public var address:String;
		
		/** 提出者検索 */
		public var _serchStaffName:ArrayCollection;

		/** リストの選択状態保持 */	
		public var _selectedStaff:Object;		
		
//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */		
		public function ChangeAddressApprovalLogic()
		{
			super();
		}

//--------------------------------------
//  Initialization
//--------------------------------------
	    /**
	     * onCreationCompleteHandler
	     * 
	     */
	    override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			/** 提出者一覧表示用 */
			BindingUtils.bindProperty(view.staffAddressApprovalList, "dataProvider", this, "_staffAddressApproval");
			/** 履歴一覧表示用 */
	    	BindingUtils.bindProperty(view.staffAddressList, "dataProvider", this, "getStaffAddressList");
			/** 検索の提出者コンボボックス表示用 */
	    	BindingUtils.bindProperty(view.cmbStaff, "dataProvider", this, "_serchStaffName");
	    	
	    	/** 現住所表示用 */
	    	BindingUtils.bindProperty(view.moveDate, "text", this, "moveDate");
	 	    BindingUtils.bindProperty(view.postalCode1, "text", this, "postalCode1");   	
	    	BindingUtils.bindProperty(view.postalCode2, "text", this, "postalCode2");
	    	BindingUtils.bindProperty(view.prefectureName, "text", this, "prefectureName");
	    	BindingUtils.bindProperty(view.ward, "text", this, "ward");
	    	BindingUtils.bindProperty(view.houseNumber, "text", this, "houseNumber");
	    	BindingUtils.bindProperty(view.wardKana, "text", this, "wardKana");
	    	BindingUtils.bindProperty(view.houseNumberKana, "text", this, "houseNumberKana");
	    	BindingUtils.bindProperty(view.homePhoneNo1, "text", this, "homePhoneNo1");
	    	BindingUtils.bindProperty(view.homePhoneNo2, "text", this, "homePhoneNo2");
	    	BindingUtils.bindProperty(view.homePhoneNo3, "text", this, "homePhoneNo3");
	    	BindingUtils.bindProperty(view.nameplate, "text", this, "nameplate");
	    	BindingUtils.bindProperty(view.associateStaff, "text", this, "associateStaff");
	    	BindingUtils.bindProperty(view.householder, "text", this, "householder");

	    	/** 新住所表示用 */		    		    	
	    	BindingUtils.bindProperty(view.newMoveDate, "text", this, "newMoveDate");
	    	BindingUtils.bindProperty(view.newPostalCode1, "text", this, "newPostalCode1");
	    	BindingUtils.bindProperty(view.newPostalCode2, "text", this, "newPostalCode2");
	    	BindingUtils.bindProperty(view.newPrefectureName, "text", this, "newPrefectureName");    	    	
	    	BindingUtils.bindProperty(view.newWard, "text", this, "newWard");
	    	BindingUtils.bindProperty(view.newHouseNumber, "text", this, "newHouseNumber");
	    	BindingUtils.bindProperty(view.newWardKana, "text", this, "newWardKana");
	    	BindingUtils.bindProperty(view.newHouseNumberKana, "text", this, "newHouseNumberKana");
	    	BindingUtils.bindProperty(view.newHomePhoneNo1, "text", this, "newHomePhoneNo1");
	    	BindingUtils.bindProperty(view.newHomePhoneNo2, "text", this, "newHomePhoneNo2");
	    	BindingUtils.bindProperty(view.newHomePhoneNo3, "text", this, "newHomePhoneNo3");
	    	BindingUtils.bindProperty(view.newNameplate, "text", this, "newNameplate");
	    	BindingUtils.bindProperty(view.newAssociateStaff, "text", this, "newAssociateStaff");
			BindingUtils.bindProperty(view.newHouseholder, "text", this, "newHouseholder");
			
			/** DBデータの取得 */
	    	view.srv.getOperation("getStaffAddressApproval").send();
		}

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 検索表示ボタンの押下.
		 */
		public function onChange_swSearch(event:Event):void
		{
			changeSwSearch();
		}
		
		/**
		 * 検索表示ボタンの表示設定.
		 */
		public function changeSwSearch():void
		{
			if (view.swSearch.selected) {

				view.swSearch.label = "検索条件を隠す";
				view.searchGrid.percentWidth = 100;
				view.searchGrid.percentHeight= 100;
			}
			else {
				view.swSearch.label = "検索条件を開く";
				view.searchGrid.width = 0;
				view.searchGrid.height= 0;
			}
		}


		/**
		 * 検索ボタンの押下.
		 */
		public function onClick_search():void
		{
			_staffAddressApproval.filterFunction = staffAddressApprovalListFillter;
			_staffAddressApproval.refresh();
			initializationData();		
		}	


		/**
		 * Google地図表示ボタン1処理
		 */
		public function onClick_linkGoogleMap1(e:MouseEvent):void
		{
			address = view.prefectureName.text + view.ward.text;
			
			linkGoogleMap(address);
		}

		/**
		 * Google地図表示ボタン2処理
		 */
		public function onClick_linkGoogleMap2(e:MouseEvent):void
		{
			address = view.newPrefectureName.text + view.newWard.text;
			
			linkGoogleMap(address);
		}

		/**
		 * Google地図表示処理
		 */
		public function linkGoogleMap(address:String):void
		{
      		var req:URLRequest = new URLRequest("http://maps.google.co.jp/maps");
            req.method = URLRequestMethod.GET;
                
            var uv:URLVariables = new URLVariables();
            uv.f = "d";
			uv.hl= "ja";			
			uv.q = address;
			uv.z = "18";
            req.data = uv;
 			navigateToURL(req, "_blank");
		}


		/**
		 * 提出一覧を選択すると実行
		 */
		public function onClick_staffAddressApprovalList(e:ListEvent):void
		{
			/** 社員IDを更新する。 */
			statusId = new int();
			_staffId = e.itemRenderer.data.staffId;
			statusId = e.itemRenderer.data.statusId;
			
			getStaffData(_staffId, statusId);
		}
		
		/**
		 * 選択した社員の情報を取得
		 */		
		public function getStaffData(staffId:int, statusId:int):void
		{
			getStaffAddressList = new ArrayCollection();
			
			if(statusId == AddressStatusId.APPROVAL){
				view.srv.getOperation("getStaffAddress").send(_staffId);
			}else{
				view.srv.getOperation("getStaffAddress").send(_staffId);
				view.srv.getOperation("getNewStaffAddress").send(_staffId);
			}
			
			/** ボタンの有効/無効切り替え。 */
			buttonStatus(statusId);
		}
		
		
		/**
		 * ボタン有効/無効.
		 *
		 * @param status 履歴の最大のステータス
		 */
		public function buttonStatus(status:int):void
		{
			if(status == AddressStatusId.APPROVAL){
				view.approvalNewAddress.enabled       = false;
				view.cancelApprovalNewAddress.enabled = true;
				view.returnNewAddress.enabled         = false;
			}else if(status == AddressStatusId.APPLY){
				view.approvalNewAddress.enabled       = true;
				view.cancelApprovalNewAddress.enabled = false;
				view.returnNewAddress.enabled         = true;
			}else{
				view.approvalNewAddress.enabled       = false;
				view.cancelApprovalNewAddress.enabled = false;
				view.returnNewAddress.enabled         = false;
			}
		}


		/**
		 * リンクボタン選択 承認.
		 *
		 */
		public function onClick_approvalNewAddress():void
		{
			Alert.show("承認してもよろしいですか？", "", 3, view, onResult_approvalNewAddress);
			
		}
		
		public function onResult_approvalNewAddress(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				view.srv.getOperation("insertStaffAddressHistory").send(loginStaffId, _renewStaffAddress, AddressActionId.GA_APPROVAL, AddressStatusId.APPROVAL);
			}
			initializationData();
			buttonStatus(AddressStatusId.STILLENTER);
		}

		/**
		 * リンクボタン選択 承認前に戻す.
		 *
		 */
		public function onClick_cancelApprovalNewAddress():void
		{
			Alert.show("承認前に戻してもよろしいですか？", "", 3, view, onResult_cancelApprovalNewAddress);
			
		}
		
		public function onResult_cancelApprovalNewAddress(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				view.srv.getOperation("insertStaffAddressHistory").send(loginStaffId, _renewStaffAddress, AddressActionId.GA_APPROVAL_CANCEL, AddressStatusId.APPLY);
			}
			initializationData();
			buttonStatus(AddressStatusId.STILLENTER);
		}

		/**
		 * リンクボタン選択 提出者に差し戻す.
		 *
		 */
		public function onClick_returnNewAddress():void
		{
			Alert.show("提出者に差し戻してもよろしいですか？", "", 3, view, onResult_returnNewAddress);
			
		}
		
		public function onResult_returnNewAddress(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				view.srv.getOperation("insertStaffAddressHistory").send(loginStaffId, _renewStaffAddress, AddressActionId.GA_APPROVAL_REJECT, AddressStatusId.RETURN);
			}
			initializationData();
			buttonStatus(AddressStatusId.STILLENTER);
		}


		/**
		 * getStaffAddressApproval(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_getStaffAddressApproval(e:ResultEvent):void
		{
			trace("成功");
			var staffAddressDto:StaffAddressDto = new StaffAddressDto(e.result);
			_serchStaffName       = staffAddressDto.NewStaffName;		
			_staffAddressApproval = staffAddressDto.NewStaffAddress;
			BindingUtils.bindProperty(view.cmbStaff, "dataProvider", this, "_serchStaffName");
			
			
			/** 初期表示用検索ボタン押下処理 */
	    	onClick_search();
		}
		
		public function onFault_getStaffAddressApproval(e:FaultEvent):void
		{
			trace("onFault_getStaffAddressApproval...");
			
			// エラーダイアログ表示
			Alert.show("DBの接続に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);						
		}
		
		
		/**
		 * 検索用ファイルフィルターの条件設定.
		 *
		 * @param dto 取得したデータ1レコード分
		 */
		public function staffAddressApprovalListFillter(dto:ChangeAddressApprovalDto):Boolean
		{
			var serchFlg:Boolean = false; 
			
			/** 検索 ステータス 作成 */
			if(dto.statusId == AddressStatusId.ENTER){
				if(view.chkState1.selected){
					serchFlg = true;
				}else{
					serchFlg = false;
				}
			}
			/** 検索 ステータス 提出 */
			if(dto.statusId == AddressStatusId.APPLY){
				if(view.chkState2.selected){
					serchFlg = true;
				}else{
					serchFlg = false;
				}
			}
			/** 検索 ステータス 承認済 */
			if(dto.statusId == AddressStatusId.APPROVAL){
				if(view.chkState3.selected){
					serchFlg = true;
				}else{
					serchFlg = false;
				}
			}		
			/** 検索 ステータス 差し戻し中 */
			if(dto.statusId == AddressStatusId.RETURN){
				if(view.chkState4.selected){
					serchFlg = true;
				}else{
					serchFlg = false;
				}
			}
			/** ステータスのチェックがTrueなら、名前の絞り込みをチェック */
			if(serchFlg){
				/** 検索 提出者名 */
				if(view.chkStaff.selected){
					if(dto.fullName == view.cmbStaff.text){
						serchFlg = true;
					}else{
						serchFlg = false;
					}
				}
			}	
			/** ステータスのチェックがTrueなら、提出日の絞り込みをチェック */
			if(serchFlg){				
				/** 検索 提出日 */
				var startTime:Date = DateField.stringToDate(view.cmbDatePresentationStart.text, "YYYY/MM/DD"); 
				var finishTime:Date = DateField.stringToDate(view.cmbDatePresentationFinish.text, "YYYY/MM/DD"); 
								
				if(view.chkDatePresentation.selected){			
					if(dto.presentTime == null){
						serchFlg = false;
					}else{					
						if(finishTime < dto.presentTime){
							serchFlg = false;
						}else{
							serchFlg = true;
						}
						
						if(startTime > dto.presentTime){
							serchFlg = false;
						}else{
							serchFlg = true;
						}
					}		
				}			
			}
			return serchFlg;
		}


		/**
		 * getStaffAddress(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_getStaffAddress(e:ResultEvent):void
		{
			trace("成功");
			view.NewAddress.setVisible(false);
			var staffAddressDto:StaffAddressDto = new StaffAddressDto(e.result);
			_staffAddressText = staffAddressDto.StaffAddressText;
			_staffAddressList = staffAddressDto.StaffAddress;
			if(_staffAddressList.length > 0){
				setDto(_staffAddressText);	
											
				if (statusId == AddressStatusId.APPROVAL)
				{
					getStaffAddressList = _staffAddressList;
					/** 履歴追加用。 */
					_renewStaffAddress.staffId            = _staffAddressText.staffId;
					_renewStaffAddress.updateCount        = _staffAddressText.updateCount;
					_renewStaffAddress.historyUpdateCount = _staffAddressText.historyUpdateCount;
				}
			}				
		}

		public function onFault_getStaffAddress(e:FaultEvent):void
		{
			trace("onFault_getStaffAddress...");
			
			// エラーダイアログ表示
			Alert.show("DBの接続に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);						
		}


		/**
		 * getNewStaffAddress(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_getNewStaffAddress(e:ResultEvent):void
		{
			trace("成功");
			view.NewAddress.setVisible(true);
			var staffAddressDto:StaffAddressDto = new StaffAddressDto(e.result);
			_newStaffAddressText = staffAddressDto.StaffAddressText;
			_newStaffAddressList = staffAddressDto.StaffAddress;
			
			if(_newStaffAddressList.length > 0){
				newMoveDate        = DateField.dateToString(_newStaffAddressText.moveDate, "YYYY/MM/DD");
				newPostalCode1     = _newStaffAddressText.postalCode1;
				newPostalCode2     = _newStaffAddressText.postalCode2;
				newPrefectureName  = _newStaffAddressText.prefectureName;
				newWard            = _newStaffAddressText.ward;
				newHouseNumber     = _newStaffAddressText.houseNumber;
				newWardKana        = _newStaffAddressText.wardKana;
				newHouseNumberKana = _newStaffAddressText.houseNumberKana;
				newHomePhoneNo1    = _newStaffAddressText.homePhoneNo1;
				newHomePhoneNo2    = _newStaffAddressText.homePhoneNo2;
				newHomePhoneNo3    = _newStaffAddressText.homePhoneNo3;
				newNameplate       = _newStaffAddressText.nameplate;
				newAssociateStaff  = _newStaffAddressText.associateStaff;
	
				if(_newStaffAddressText.householderFlag == true){
					newHouseholder = "世帯主";
				}else{
					newHouseholder = "非世帯主";
				}
				getStaffAddressList = _newStaffAddressList;
				/** 履歴追加用。 */
				_renewStaffAddress.staffId            = _newStaffAddressText.staffId;
				_renewStaffAddress.updateCount        = _newStaffAddressText.updateCount;
				_renewStaffAddress.historyUpdateCount = _newStaffAddressText.historyUpdateCount;	
			}				
		}

		public function onFault_getNewStaffAddress(e:FaultEvent):void
		{
			trace("onFault_getNewStaffAddress...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("DBの接続に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);						
		}

		/**
		 * renewStaffAddressHistory(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_renewStaffAddressHistory(e:ResultEvent):void
		{
			trace("成功");
			// 画面の再表示
			onCreationCompleteHandler(null);
		}

		public function onFault_renewStaffAddressHistory(e:FaultEvent):void
		{
			trace("onFault_renewStaffAddressHistory...");
			
			// エラーダイアログ表示
			Alert.show("履歴の更新に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);			
		}
		
	
		/**
		 * 初期化処理
		 *
		 *
		 */		
		public function initializationData():void
		{
			var staffDto:ChangeAddressApplyDto = new ChangeAddressApplyDto();
			setDto(staffDto);
			
			getStaffAddressList = new ArrayCollection();
			view.NewAddress.setVisible(false);
		}
		
		
		/**
		 * バインドデータへの設定処理
		 *
		 * @param _staffAddressText Dtoで加工したデータ.
		 */
		public function setDto(_staffAddressText:ChangeAddressApplyDto):void
		{
			moveDate        = DateField.dateToString(_staffAddressText.moveDate, "YYYY/MM/DD");
			postalCode1     = _staffAddressText.postalCode1;
			postalCode2     = _staffAddressText.postalCode2;
			prefectureName  = _staffAddressText.prefectureName;
			ward            = _staffAddressText.ward;
			houseNumber     = _staffAddressText.houseNumber;
			wardKana        = _staffAddressText.wardKana;
			houseNumberKana = _staffAddressText.houseNumberKana;
			homePhoneNo1    = _staffAddressText.homePhoneNo1;
			homePhoneNo2    = _staffAddressText.homePhoneNo2;
			homePhoneNo3    = _staffAddressText.homePhoneNo3;
			nameplate       = _staffAddressText.nameplate;
			associateStaff  = _staffAddressText.associateStaff;
			
			if(_staffAddressText.householderFlag == true){
				householder = "世帯主";
			}else if(_staffAddressText.householderFlag == false){
				householder = "非世帯主";
			}else{
				householder = "";
			}	
		}
		
//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ChangeAddressApproval;

	    /**
	     * 画面を取得します
	     */
	    public function get view():ChangeAddressApproval
	    {
	        if (_view == null) {
	            _view = super.document as ChangeAddressApproval;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:ChangeAddressApproval):void
	    {
	        _view = view;
	    }
	}	    	
}