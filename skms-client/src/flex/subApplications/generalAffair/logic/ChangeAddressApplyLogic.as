package subApplications.generalAffair.logic
{
	import components.PopUpWindow;
	
	import enum.AddressActionId;
	import enum.AddressStatusId;
	
	import flash.display.DisplayObject;
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
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.dto.ChangeAddressApplyDto;
	import subApplications.generalAffair.dto.MPrefectureListDto;
	import subApplications.generalAffair.dto.StaffAddressDto;
	import subApplications.generalAffair.web.ChangeAddressApply;
	import subApplications.generalAffair.web.PreserveNewAddress;
	
	
	/**
	 * 社員住所作成・提出ロジッククラスです.
	 */	
	public class ChangeAddressApplyLogic extends Logic
	{

		/** 住所変更申請  リンクボタンリスト */
		private const RP_LINKLIST:ArrayCollection
			= new ArrayCollection([
				{label:"現住所のコピー"
					,	func:"onClick_linkList_copy_address"
					,	enabled:true
					,	enabledCheck:""},
				{label:"保存"
					,	func:"onClick_linkList_preserve"
					,	enabled:true
					,	enabledCheck:""},
				{label:"提出"
					,	func:"onClick_linkList_present_confirm"
					,	enabled:false
					,	enabledCheck:""},
				{label:"提出取り消し"
					,	func:"onClick_linkList_cancel_confirm"
					,	enabled:false
					,	enabledCheck:""},
			]);

		/** 選択されたリンクバー */
		private var _selectedLinkObject:Object;
		
		/** ログイン者ID */
		public var _staffId:int = Application.application.indexLogic.loginStaff.staffId;
		
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
		public var prefectureCode:int;

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
		
		/** 現住所の履歴 */
		[Bindable]
		public var _staffAddressList:ArrayCollection;
		
		/** 現住所の情報 */
		[Bindable]
		public var _staffAddressText:ChangeAddressApplyDto;
		
		
		/** 都道府県名のリスト */
		[Bindable]
		public var _mPrefectureList:ArrayCollection;
		
		/** 新住所の履歴の取得 */
		public var getNewStaffAddressList:ArrayCollection;	
		
		/** 新住所の情報 */
		[Bindable]
		public var _newStaffAddressText:ChangeAddressApplyDto;			
		
		/** 新住所の履歴 */
		[Bindable]
		public var _newStaffAddressList:ArrayCollection;
		
		/** 新住所の引越日 */
		[Bindable]
		public var newMoveDate:String = "";
		
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
		public var newHouseholder:Boolean;
		
		/** 新住所の連絡のとりやすい社員 */
		[Bindable]
		public var newAssociateStaff:String;
		
		/** 新住所のステータスID */
		public var newStatusID:int;

		/** 保存する情報 */
		public var _renewStaffAddress:ChangeAddressApplyDto = new ChangeAddressApplyDto();
		
		/** 現在の住所の履歴カウント */
		public var _updateCount:int = 0;
		/** 新住所の履歴カウント */
		public var _newUpdateCount:int = 0;
		
//--------------------------------------
//  Constructor
//--------------------------------------
		/**
		 * コンストラクタ.
		 */
		public function ChangeAddressApplyLogic()
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
	    	/** DBデータの取得 */
			view.srv.getOperation("getMPrefecture").send();
			view.srv.getOperation("getStaffAddress").send(_staffId);
			view.srv.getOperation("getNewStaffAddress").send(_staffId);
			
			BindingUtils.bindProperty(view.staffAddressList, "dataProvider", this, "_staffAddressList");//現住所の履歴
			BindingUtils.bindProperty(view.newPrefectureList, "dataProvider", this, "_mPrefectureList");//新住所の都道府県名コンボボックス
			BindingUtils.bindProperty(view.newStaffAddressList, "dataProvider", this, "_newStaffAddressList");//新住所の履歴

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
	    	
	    	BindingUtils.bindProperty(view.newMoveDate, "text", this, "newMoveDate");
	    	BindingUtils.bindProperty(view.newPostalCode1, "text", this, "newPostalCode1");
	    	BindingUtils.bindProperty(view.newPostalCode2, "text", this, "newPostalCode2");    	
	    	BindingUtils.bindProperty(view.newWard, "text", this, "newWard");
	    	BindingUtils.bindProperty(view.newHouseNumber, "text", this, "newHouseNumber");
	    	BindingUtils.bindProperty(view.newWardKana, "text", this, "newWardKana");
	    	BindingUtils.bindProperty(view.newHouseNumberKana, "text", this, "newHouseNumberKana");
	    	BindingUtils.bindProperty(view.newHomePhoneNo1, "text", this, "newHomePhoneNo1");
	    	BindingUtils.bindProperty(view.newHomePhoneNo2, "text", this, "newHomePhoneNo2");
	    	BindingUtils.bindProperty(view.newHomePhoneNo3, "text", this, "newHomePhoneNo3");
	    	BindingUtils.bindProperty(view.newNameplate, "text", this, "newNameplate");
	    	BindingUtils.bindProperty(view.newAssociateStaff, "text", this, "newAssociateStaff");
			BindingUtils.bindProperty(view.newHouseholder, "selected", this, "newHouseholder");

	    }

//--------------------------------------
//  UI Event Handler
//--------------------------------------

		/**
		 * 変更ボタン処理
		 * 
		 */
		public function onClick_linkList_change(e:MouseEvent):void
		{ 
			view.NewAddressArea.setVisible(true);
			view.ChangeLinkButton.enabled = false;
		}


		/**
		 * ボタン有効/無効.
		 *
		 * @param status 新住所の現在のステータス
		 */
		public function buttonStatus(status:int):void
		{
			/** 作成 */
			if(status == AddressStatusId.ENTER){
				view.preserve.enabled       = true;
				view.presentConfirm.enabled = true;
				view.cancelConfirm.enabled  = false;
			/** 提出 */
			}else if(status == AddressStatusId.APPLY){
				view.preserve.enabled       = false;
				view.presentConfirm.enabled = false;
				view.cancelConfirm.enabled  = true;
			/** 差し戻し中 */
			}else if(status == AddressStatusId.RETURN){
				view.preserve.enabled       = true;
				view.presentConfirm.enabled = true;
				view.cancelConfirm.enabled  = false;
			}
		}


		/**
		 * リンクボタン選択 現住所のコピー.
		 *
		 */
		public function onClick_linkList_copy_address():void
		{
			// 現住所をコピーする.

			view.newMoveDate.text               = this.moveDate;
			view.newPostalCode1.text            = this.postalCode1;
			view.newPostalCode2.text            = this.postalCode2;
			view.newPrefectureList.selectedData = this.prefectureCode.toString();
			view.newWard.text                   = this.ward;
			view.newHouseNumber.text            = this.houseNumber;
			view.newWardKana.text               = this.wardKana;
			view.newHouseNumberKana.text        = this.houseNumberKana;
			view.newHomePhoneNo1.text           = this.homePhoneNo1;
			view.newHomePhoneNo2.text           = this.homePhoneNo2;
			view.newHomePhoneNo3.text           = this.homePhoneNo3;
			view.newNameplate.text              = this.nameplate;
			view.newAssociateStaff.text         = this.associateStaff;
			
			if(_staffAddressText.householderFlag == true){
				view.newHouseholder.selected = true;
			}else{
				view.newHouseholder.selected = false;
			}
		}		
		
		
		/**
		 * リンクボタン選択 保存.
		 *
		 */
		public function onClick_linkList_preserve():void
		{
			/** データ準備 */
			var obj:Object = new Object();
			obj.moveDate        = view.newMoveDate.text;
			obj.postalCode1     = view.newPostalCode1.text;
			obj.postalCode2	    = view.newPostalCode2.text;	
			obj.prefectureName  = view.newPrefectureList.text;		
			obj.ward	        = view.newWard.text;		
			obj.houseNumber	    = view.newHouseNumber.text; 	
			obj.wardKana	    = view.newWardKana.text;		
			obj.houseNumberKana = view.newHouseNumberKana.text;			
			obj.homePhoneNo1	= view.newHomePhoneNo1.text;		
			obj.homePhoneNo2	= view.newHomePhoneNo2.text;				
			obj.homePhoneNo3	= view.newHomePhoneNo3.text;			
			obj.nameplate		= view.newNameplate.text;	
			obj.associateStaff	= view.newAssociateStaff.text;					
			
			if(view.newHouseholder.selected == true){
				obj.householder = "世帯主";
			}else{
				obj.householder = "非世帯主";
			}
			
			if(obj.moveDate == "" || obj.postalCode1 == "" || obj.postalCode2 == "" || obj.prefectureName == "" || obj.ward == ""){
				Alert.show("未入力の項目があります。", "Error", Alert.OK, null, null, null, Alert.OK);	
			}else{
				/** 保存画面の表示 */
				var pop:IFlexDisplayObject = PopUpWindow.openWindow(PreserveNewAddress, view.parentApplication as DisplayObject, obj);
				/**	closeイベントを監視する. */
				pop.addEventListener(CloseEvent.CLOSE, onApprovalCancelPopUpClose);	
			}
		}		
		
		/**
		 * 保存処理.
		 *
		 * @param _renewStaffAddress.historyUpdateCount = 7:総務承認済
		 */		
		private function onApprovalCancelPopUpClose(e:CloseEvent):void
		{	
			/** 保存ダイアログでOKが押されたかどうか判別 */
			if(e.detail == Alert.OK){
				/** 住所登録用データ */
				_renewStaffAddress.moveDate         = DateField.stringToDate(view.newMoveDate.text, "YYYY/MM/DD");
				_renewStaffAddress.postalCode1      = view.newPostalCode1.text;
				_renewStaffAddress.postalCode2      = view.newPostalCode2.text;
				_renewStaffAddress.prefectureCode   = view.newPrefectureList.selectedItem.data;
				_renewStaffAddress.ward             = view.newWard.text;
				_renewStaffAddress.houseNumber      = view.newHouseNumber.text;
				_renewStaffAddress.homePhoneNo1     = view.newHomePhoneNo1.text;
				_renewStaffAddress.homePhoneNo2     = view.newHomePhoneNo2.text;
				_renewStaffAddress.homePhoneNo3     = view.newHomePhoneNo3.text;
				_renewStaffAddress.wardKana         = view.newWardKana.text;
				_renewStaffAddress.houseNumberKana  = view.newHouseNumberKana.text;
				_renewStaffAddress.householderFlag  = view.newHouseholder.selected;
				_renewStaffAddress.nameplate        = view.newNameplate.text;
				_renewStaffAddress.associateStaff   = view.newAssociateStaff.text;
				_renewStaffAddress.staffId          = _staffId;
				_renewStaffAddress.addressStatusId  = newStatusID;
				
				if(_updateCount < _newUpdateCount){//現在の住所の履歴カウント < 新住所の履歴カウント
					view.srv.getOperation("renewStaffAddress").send(_staffId, _renewStaffAddress, _renewStaffAddress.historyUpdateCount);
				}else{
//					_renewStaffAddress.updateCount  = _renewStaffAddress.updateCount + 1;
					_newStaffAddressText.updateCount = _staffAddressText.updateCount + 1;
					_renewStaffAddress.updateCount  = _newStaffAddressText.updateCount;
					view.srv.getOperation("renewStaffAddress").send(_staffId, _renewStaffAddress, _renewStaffAddress.historyUpdateCount);
				}
				
			}
		}		
		
		
		/**
		 * リンクボタン選択 提出確認.
		 *
		 */
		public function onClick_linkList_present_confirm():void
		{
			Alert.show("提出してもよろしいですか？", "", 3, view, onResult_present_confirm);
			
		}
		
		public function onResult_present_confirm(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				view.srv.getOperation("insertStaffAddressHistory").send(_staffId, _renewStaffAddress, AddressActionId.APPLY, AddressStatusId.APPLY);                  
			}
		}


		/**
		 * リンクボタン選択 提出取り消し確認.
		 *
		 */
		public function onClick_linkList_cancel_confirm():void
		{
			Alert.show("提出を取り消してもよろしいですか？", "", 3, view, onResult_cancel_confirm);
		}
		
		public function onResult_cancel_confirm(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				view.srv.getOperation("insertStaffAddressHistory").send(_staffId, _renewStaffAddress, AddressActionId.APPLY_CANCEL, AddressStatusId.ENTER);
			}
		}

		
		/** 
		 * Google地図表字ボタン処理
		 * 
		 */
		public function onClick_linkGoogleMap(e:MouseEvent):void
		{
      		var req:URLRequest = new URLRequest("http://maps.google.co.jp/maps");
            req.method = URLRequestMethod.GET;   
                
            var uv:URLVariables = new URLVariables();
            uv.f = "d";
			uv.hl= "ja";
			uv.q = view.newPrefectureList.text + view.newWard.text;
			uv.z = "18";
            req.data = uv;
 			navigateToURL(req, "_blank");
		}			
		
		/**
		 * 検索ボタン押下処理
		 * 
		 */
		public function  onClick_linkPostalCode(e:MouseEvent):void
		{
			//追加(削除) @auther okamoto
/*			view.newPrefectureList.text  = "";
			view.newWard.text            = "";
			view.newHouseNumber.text     = "";
			view.newWardKana.text        = "";
			view.newHouseNumberKana.text = "";			
*/		
			view.zip_service.send();
		}
		
		/**
		 * 郵便番号の自動取得の結果受信
		 * 
		 */
		public function zip_service_onResult(event:ResultEvent):void
		{
		    var zipResult:XML = view.zip_service.lastResult as XML;
		    
		    //if文 else内 追加 @auther okamoto
		    if(zipResult.ADDRESS_value.value.@city != ""){	
				for(var i:int = 0; i < _mPrefectureList.length; i ++){
					if(_mPrefectureList[i].label == zipResult.ADDRESS_value.value.@state){
						view.newPrefectureList.selectedData = _mPrefectureList[i].data;
					}
				}
		    
		   		view.newWard.text = zipResult.ADDRESS_value.value.@city +
		      					   	zipResult.ADDRESS_value.value.@address;
		    	/*
		    	view.newWardKana.text = zipResult.ADDRESS_value.value.@city_kana[1] + 
		                               zipResult.ADDRESS_value.value.@address_kana;
		    	*/
		    	//追加 @auther maruta
		    	view.newWardKana.text = zipResult.ADDRESS_value.value.@city_kana[0] +
		    							zipResult.ADDRESS_value.value.@address_kana;
		    	//
		    							
		    }else{
		    	// エラーダイアログ表示
				Alert.show("郵便番号が存在しません。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		    }
		}
		
		public function zip_service_onFault(event:FaultEvent):void
		{
			trace("zip_service_onFault...");
			
			// エラーダイアログ表示
			Alert.show("住所検索に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);			
		}
		

		/**
		 * getMPrefecture(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_getMPrefecture(e:ResultEvent):void
		{
			trace("成功");
			var mPrefectureListDto:MPrefectureListDto = new MPrefectureListDto(e.result);
			_mPrefectureList = mPrefectureListDto.MPrefectureList;
		}

		public function onFault_getMPrefecture(e:FaultEvent):void
		{
			trace("onFault_getMPrefecture...");
			
			// エラーダイアログ表示
			Alert.show("DB接続に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}

		/**
		 * getStaffAddress(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		 //現住所の表示
		public function onResult_getStaffAddress(e:ResultEvent):void
		{
			trace("成功");
			var staffAddressDto:StaffAddressDto = new StaffAddressDto(e.result);
			_staffAddressText = staffAddressDto.StaffAddressText;//現住所格納変数に住所データを代入
			_staffAddressList = staffAddressDto.StaffAddress;//現住所の履歴格納変数に住所の履歴リスト
			
			if(_staffAddressList.length > 0){//住所の履歴があれば
				view.copyAddress.enabled = true;
				_updateCount = _staffAddressText.updateCount;
				moveDate            = DateField.dateToString(_staffAddressText.moveDate, "YYYY/MM/DD");
				postalCode1         = _staffAddressText.postalCode1;
				postalCode2         = _staffAddressText.postalCode2;
				prefectureCode      = _staffAddressText.prefectureCode;
				prefectureName      = _staffAddressText.prefectureName;
				ward                = _staffAddressText.ward;
				houseNumber         = _staffAddressText.houseNumber;
				wardKana            = _staffAddressText.wardKana;
				houseNumberKana     = _staffAddressText.houseNumberKana;
				homePhoneNo1        = _staffAddressText.homePhoneNo1;
				homePhoneNo2        = _staffAddressText.homePhoneNo2;
				homePhoneNo3        = _staffAddressText.homePhoneNo3;
				nameplate           = _staffAddressText.nameplate;
				associateStaff      = _staffAddressText.associateStaff;
				
				if(_staffAddressText.householderFlag == true){
					householder = "世帯主";
				}else{
					householder = "非世帯主";
				}
				_renewStaffAddress.staffId            = _staffAddressText.staffId;//保存用変数に社員IDを代入
				_renewStaffAddress.updateCount        = _staffAddressText.updateCount;//保存用変数に現住所の履歴カウントを代入
				_renewStaffAddress.historyUpdateCount = 0;//保存用の履歴更新カウント変数に0を代入
			}
			
		}

		public function onFault_getStaffAddress(e:FaultEvent):void
		{
			trace("onFault_getStaffAddress...");
			
			// エラーダイアログ表示
			Alert.show("DB接続に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}

		/**
		 * getNewStaffAddress(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		 //新住所の申請
		public function onResult_getNewStaffAddress(e:ResultEvent):void
		{
			trace("成功");
			var staffAddressDto:StaffAddressDto = new StaffAddressDto(e.result);
			_newStaffAddressText = staffAddressDto.StaffAddressText;//新住所格納変数に住所データを代入
			getNewStaffAddressList = staffAddressDto.StaffAddress;//新住所の履歴格納変数に住所の履歴リストを代入
			if(staffAddressDto.StaffAddress.length == 0){//初めて住所変更する場合
				_newStaffAddressText = new ChangeAddressApplyDto();
			}else{
				_newUpdateCount = _newStaffAddressText.updateCount;
				//_newUpdateCount = _staffAddressText.updateCount;
			}
			
			if(_updateCount < _newUpdateCount){//_staffAddressText.updateCount < _newStaffAddressText.updateCount
				view.NewAddressArea.setVisible(true);//常時新住所入力項目表示
				view.ChangeLinkButton.enabled = false;//変更ボタン押せない
				_newStaffAddressList = getNewStaffAddressList;
				
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
				newHouseholder     = _newStaffAddressText.householderFlag;
				newStatusID        = _newStaffAddressText.addressStatusId;
				view.newPrefectureList.selectedData = _newStaffAddressText.prefectureCode.toString();
				
				_renewStaffAddress.staffId            = _newStaffAddressText.staffId;
				_renewStaffAddress.updateCount        = _newStaffAddressText.updateCount;
				_renewStaffAddress.historyUpdateCount = _newStaffAddressText.historyUpdateCount;
				
				buttonStatus(_newStaffAddressText.addressStatusId);
			}
		}

		public function onFault_getNewStaffAddress(e:FaultEvent):void
		{
			trace("onFault_getNewStaffAddress...");
			
			// エラーダイアログ表示
			Alert.show("DB接続に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}

		/**
		 * renewStaffAddress(RemoteObject)の結果受信.
		 *
		 * @param e RPCの結果イベント.
		 */
		public function onResult_renewStaffAddress(e:ResultEvent):void
		{
			// 確認ダイアログ表示
			Alert.show("保存に成功しました。", "",
						Alert.OK, null,
						null, null, Alert.OK);	

			// 画面の再表示
			onCreationCompleteHandler(null);
		}

		public function onFault_renewStaffAddress(e:FaultEvent):void
		{
			trace("onFault_updateStaffAddress...");
			
			// エラーダイアログ表示
			Alert.show("保存に失敗しました。", "Error",
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

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:ChangeAddressApply;

	    /**
	     * 画面を取得します

	     */
	    public function get view():ChangeAddressApply
	    {
	        if (_view == null) {
	            _view = super.document as ChangeAddressApply;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。

	     *
	     * @param view セットする画面
	     */
	    public function set view(view:ChangeAddressApply):void
	    {
	        _view = view;
	    }
	}
}