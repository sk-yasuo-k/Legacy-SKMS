package subApplications.lunch.logic
{
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.generalAffair.dto.MPrefectureListDto;
	import subApplications.lunch.dto.MLunchShopDto;
	import subApplications.lunch.dto.MLunchShopDtoList;
	import subApplications.lunch.web.*;
	
	import utils.CommonIcon;

	/**
	 * 店舗登録ロジッククラス
	 * 
	 * @author t-ito
	 */			
	public class RegisterShopLogic extends Logic
	{
		/**店舗一覧*/
		[Bindable]
		public var _shopList:ArrayCollection;		

		/** 都道府県名のリスト */
		[Bindable]
		public var _mPrefectureList:ArrayCollection;	
				
		public function RegisterShopLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.shopList, "dataProvider", this, "_shopList");
			BindingUtils.bindProperty(this.view.prefectureList, "dataProvider", this, "_mPrefectureList");		
			
			view.lunchService.getOperation("getShopList").send();
			view.srv.getOperation("getMPrefecture").send();
			
			// TextInputの初期化処理
			initializationTextInput();
		}
		
				
		/**
		 * 店舗一覧取得成功
		 */
		public function onResult_getShopList(e:ResultEvent):void
		{
			trace("onResult_getShopList...");
			
			var mLunchShopDtoList:MLunchShopDtoList = new MLunchShopDtoList(e.result);
			this._shopList = mLunchShopDtoList.shopList;
		}
		
		/**
		 * 店舗一覧取得失敗
		 */
		public function onFault_getShopList(e:FaultEvent):void
		{
			trace("onFault_getShopList...");
			trace(e.message);

			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);			
		}


		/**
		 * 都道府県名のリスト取得成功
		 */
		public function onResult_getMPrefecture(e:ResultEvent):void
		{
			trace("onResult_getMPrefecture...");
			var mPrefectureListDto:MPrefectureListDto = new MPrefectureListDto(e.result);
			this._mPrefectureList = mPrefectureListDto.MPrefectureList;
		}

		/**
		 * 都道府県名のリスト取得失敗
		 */
		public function onFault_getMPrefecture(e:FaultEvent):void
		{
			trace("onFault_getMPrefecture...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}


		/**
		 * 店舗一覧選択
		 */
		public function onClick_shopList(e:ListEvent):void
		{	
			var tmp:MLunchShopDto = e.itemRenderer.data as MLunchShopDto;
			view.shopName.text = tmp.shopName;
			view.orderLimitTime.text = tmp.orderLimitTime;
			view.shopUrl.text = tmp.shopUrl;
			view.postalCode1.text = tmp.postalCode1;
			view.postalCode2.text = tmp.postalCode2;
			view.ward.text = tmp.ward;
			view.houseNumber.text = tmp.houseNumber;
			view.shopPhoneNo1.text = tmp.shopPhoneNo1;
			view.shopPhoneNo2.text = tmp.shopPhoneNo2;
			view.shopPhoneNo3.text = tmp.shopPhoneNo3;
			
			view.prefectureList.selectedData = tmp.prefectureCode;
			
			view.shopDeleteButton.enabled = true;
			view.shopUpdateButton.enabled = true;
		}


		/**
		 * 初期化処理
		 */
		public function initializationTextInput():void
		{
			view.shopName.text = "";
			view.orderLimitTime.text = "";
			view.shopUrl.text = "";
			view.postalCode1.text = "";
			view.postalCode2.text = "";
			view.ward.text = "";
			view.houseNumber.text = "";
			view.shopPhoneNo1.text = "";
			view.shopPhoneNo2.text = "";
			view.shopPhoneNo3.text = "";
		}
		
		/**
		 * 入力データ格納処理
		 */
		public function createInputData(tmp:MLunchShopDto):MLunchShopDto
		{
			tmp.shopName = view.shopName.text;
			tmp.orderLimitTime = view.orderLimitTime.text;
			tmp.shopUrl = view.shopUrl.text;
			tmp.postalCode1 = view.postalCode1.text;
			tmp.postalCode2 = view.postalCode2.text;
			tmp.prefectureCode = view.prefectureList.selectedData;
			tmp.ward = view.ward.text;
			tmp.houseNumber = view.houseNumber.text;
			tmp.shopPhoneNo1 = view.shopPhoneNo1.text;
			tmp.shopPhoneNo2 = view.shopPhoneNo2.text;
			tmp.shopPhoneNo3 = view.shopPhoneNo3.text;
			tmp.registrantId = Application.application.indexLogic.loginStaff.staffId;
			
			return 	tmp;
		}
		
		
		/**
		 * 検索ボタン押下処理
		 */
		public function  onClick_linkPostalCode(e:MouseEvent):void
		{
			// 住所関係のテキストを初期化する。
			view.prefectureList.text  = "";
			view.ward.text            = "";
			view.houseNumber.text     = "";		
			
			view.zip_service.send();
		}
				
		/**
		 * 住所検索成功
		 */
		public function zip_service_onResult(e:ResultEvent):void
		{
		    var zipResult:XML = view.zip_service.lastResult as XML;
		    
			for(var i:int = 0; i < _mPrefectureList.length; i ++){
				if(_mPrefectureList[i].label == zipResult.ADDRESS_value.value.@state){
					view.prefectureList.selectedData = _mPrefectureList[i].data;
				}
			}
		    
		    view.ward.text = zipResult.ADDRESS_value.value.@city +
		      					   zipResult.ADDRESS_value.value.@address;
		}
		
		/**
		 * 住所検索失敗
		 */
		public function zip_service_onFault(e:FaultEvent):void
		{
			trace("zip_service_onFault...");
			
			// エラーダイアログ表示
			Alert.show("住所検索に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);			
		}

		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_shopDelete(e:MouseEvent):void
		{						
			Alert.show("削除してもよろしいですか？", "", 3, view, shopDelete);
		}

		/**
		 * 削除処理
		 */
		public function shopDelete(e:CloseEvent):void
		{
			var tmp:MLunchShopDto = view.shopList.selectedItem as MLunchShopDto;
			
			if(e.detail == Alert.YES){
				view.lunchService.getOperation("deleteShopData").send(tmp);
			}
		}

		/**
		 * 削除処理成功
		 */
		public function onResult_deleteShopData(e:ResultEvent):void
		{
			trace("onResult_deleteShopData...");
			onCreationCompleteHandler(null);
			view.shopDeleteButton.enabled = false;
			view.shopUpdateButton.enabled = false;
		}	

		/**
		 * 削除処理失敗
		 */
		public function onFault_deleteShopData(e:FaultEvent):void
		{
			trace("onFault_deleteShopData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("店舗の削除に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}


		/**
		 * 更新ボタン押下処理
		 */
		public function onClick_shopUpdate(e:MouseEvent):void
		{						
			Alert.show("更新してもよろしいですか？", "", 3, view, shopUpdate);
		}

		/**
		 * 更新処理
		 */
		public function shopUpdate(e:CloseEvent):void
		{
			var tmp:MLunchShopDto = view.shopList.selectedItem as MLunchShopDto;

			createInputData(tmp);
			
			if(e.detail == Alert.YES){
				view.lunchService.getOperation("updateShopData").send(tmp);
			}
		}

		/**
		 * 更新処理成功
		 */
		public function onResult_updateShopData(e:ResultEvent):void
		{
			trace("onResult_updateShopData...");
			onCreationCompleteHandler(null);
			view.shopDeleteButton.enabled = false;
			view.shopUpdateButton.enabled = false;
		}	

		/**
		 * 更新処理失敗
		 */
		public function onFault_updateShopData(e:FaultEvent):void
		{
			trace("onFault_updateShopData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("店舗の登録に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}


		/**
		 * 新規ボタン押下処理
		 */
		public function onClick_shopInsert(e:MouseEvent):void
		{	
			if(view.shopName.text == "" || view.orderLimitTime.text == "" || view.shopPhoneNo1.text == "" 
				|| view.shopPhoneNo2.text == "" || view.shopPhoneNo3.text == ""){	
				// 未入力ならエラーダイアログ表示
				Alert.show("未入力の項目があります。", "Error", Alert.OK, null, null, null, Alert.OK);
			}else{
			
				var insertData:MLunchShopDto = new MLunchShopDto();
				var dialogMessage:String = "新規登録してもよろしいですか？"
				
				createInputData(insertData);
			
				for each(var shoplist:MLunchShopDto in _shopList){
					if(shoplist.shopName == insertData.shopName && shoplist.orderLimitTime == insertData.orderLimitTime 
						&& shoplist.shopUrl == insertData.shopUrl && shoplist.postalCode1 == insertData.postalCode1 
						&& shoplist.postalCode2 == insertData.postalCode2 && shoplist.prefectureCode == insertData.prefectureCode 
						&& shoplist.ward == insertData.ward && shoplist.houseNumber == insertData.houseNumber 
						&& shoplist.shopPhoneNo1 == insertData.shopPhoneNo1 && shoplist.shopPhoneNo2 == insertData.shopPhoneNo2 
						&& shoplist.shopPhoneNo3 == insertData.shopPhoneNo3){
							
							dialogMessage = "同じ内容のデータがあります。\n新規登録してもよろしいですか？"
					}
				}	
				
				Alert.show(dialogMessage, "", 3, view, shopInsert,CommonIcon.questionIcon);
			}
		}

		/**
		 * 新規登録処理
		 */
		public function shopInsert(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				var insertData:MLunchShopDto = new MLunchShopDto();
				
				createInputData(insertData);
				
				view.lunchService.getOperation("insertShopData").send(insertData);
			}			
		}

		/**
		 * 新規登録処理成功
		 */
		public function onResult_insertShopData(e:ResultEvent):void
		{
			trace("onResult_insertShopData...");
			onCreationCompleteHandler(null);
		}	

		/**
		 * 新規登録処理失敗
		 */
		public function onFault_insertShopData(e:FaultEvent):void
		{
			trace("onFault_insertShopData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("店舗の登録に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}		

				
		/** 画面 */
	    public var _view:RegisterShop;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterShop
	    {
	        if (_view == null) {
	            _view = super.document as RegisterShop;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterShop):void
	    {
	        _view = view;
	    }

	}
}