package subApplications.lunch.logic
{
	import flash.events.Event;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.dto.*;
	import subApplications.lunch.web.*;
	
	public class RegisterShopAdminLogic extends Logic
	{
		/**担当者一覧*/
		[Bindable]
		public var _mShopAdminList:ArrayCollection;
		
				
		/**社員一覧*/
		[Bindable]
		public var _allStaffList:ArrayCollection;
		
		/**担当社員情報*/
		public var _shopAdminDto:MShopAdminDto = new MShopAdminDto();		
		
		public function RegisterShopAdminLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			this.view.allStaffCombobox.dataField = "staffId";
						
			BindingUtils.bindProperty(this.view.staffList, "dataProvider", this, "_mShopAdminList");
			BindingUtils.bindProperty(this.view.allStaffCombobox, "dataProvider", this, "_allStaffList");
			BindingUtils.bindProperty(this.view.startDate, "selectedDate", this._shopAdminDto, "startDate");			
			BindingUtils.bindProperty(this.view.finishDate, "selectedDate", this._shopAdminDto, "finishDate");
			BindingUtils.bindProperty(this.view.allStaffCombobox, "selectedData", this._shopAdminDto, "staffId");
			
			//各ボタン設定
			this.setButtonEnabled();
			this.view.lunchService.getOperation("getMShopAdminList").send();
			this.view.lunchService.getOperation("getStaffList").send();			
		}
				
		/**
		 * 担当者一覧取得成功
		 * */
		public function onResult_getMShopAdminList(e:ResultEvent):void
		{
			trace("onResult_getShopAdminList...");
			
			var mShopAdminDtoList:MShopAdminDtoList = new MShopAdminDtoList(e.result);
			this._mShopAdminList = mShopAdminDtoList.staffList;
			this._mShopAdminList.filterFunction = this.staffListFillter;
					
		}
		
		/**
		 * 担当者一覧取得失敗
		 * */
		public function onFault_getMShopAdminList(e:FaultEvent):void
		{
			trace("onFault_getShopAdminList...");
			trace(e.message);
		}
		
		/**
		 * 社員一覧取得成功
		 * */
		public function onResult_getStaffList(e:ResultEvent):void
		{
			trace("onResult_getStaffList...");
			var allStaffList:StaffDtoList = new StaffDtoList(e.result);
			this._allStaffList = allStaffList.staffList;
		}
		
		/**
		 * 社員一覧取得失敗
		 * */
		public function onFault_getStaffList(e:FaultEvent):void
		{
			trace("onFault_getStaffList...");
			trace(e.message);
		}
		/**
		 * 社員一覧選択
		 * */
		public function onClick_staffList(e:ListEvent):void
		{
			var tmp:MShopAdminDto = e.itemRenderer.data as MShopAdminDto;
			this._shopAdminDto.id = tmp.id;
			this._shopAdminDto.staffId = tmp.staffId;
			this._shopAdminDto.startDate = tmp.startDate;
			this._shopAdminDto.finishDate = tmp.finishDate;
			this._shopAdminDto.registrationId = tmp.registrationId;
			this._shopAdminDto.registrationDate = tmp.registrationDate;
			this.setButtonEnabled(); 			
		}
		
		/**
		 * 担当者一覧のフィルター
		 * */
		 public function staffListFillter(obj:Object):Boolean
		 {
		 	//終了日が過去かどうか
		 	if( this.view.expiration.selected ){
		 		var nowDate:Date = new Date();		 	
		 		return obj.finishDate >= nowDate;
		 	}else{
		 		return true;
		 	} 
		 }
		 
		 /**
		 * 担当者一覧期限切れチェック
		 * */
		 public function onClickExpiration(e:Event):void
		 {
		 	this._mShopAdminList.refresh();
		 }
		  
		
		/**
		 * 担当者社員変更
		 * */
		 public function onChangeStaffName(e:Event):void
		 {
			this.view.changShopAdminButton.enabled = false;
			this._shopAdminDto.staffId = parseInt(this.view.allStaffCombobox.selectedData);
			this.setButtonEnabled();
		 }
		
		/**
		 * 開始日変更
		 * */
		public function onChangeStartDate(e:Event):void
		{
			this._shopAdminDto.startDate = this.view.startDate.selectedDate;
			this.setButtonEnabled();
		}
		
		/**
		 * 終了日変更
		 * */
		 public function onChangeFinishDate(e:Event):void
		 {
		 	this._shopAdminDto.finishDate = this.view.finishDate.selectedDate;
		 	this.setButtonEnabled();
		 }
		 
		 /**
		 * 担当者追加
		 * */
		 public function onClickAddShopAdminButton(e:Event):void
		 {
		 	_shopAdminDto.id = 0;
		 	_shopAdminDto.registrationId = Application.application.indexLogic.loginStaff.staffId;
		 	
		 	this.view.lunchService.getOperation("insertMShopAdmin").send(_shopAdminDto);
		 }
		 
		 /**
		 * 担当者追加成功
		 * */
		public function onResult_insertMShopAdmin(e:ResultEvent):void
		{
			trace("insertMShopAdmin...");
			Alert.show(e.result + "人追加しました");
			view.lunchService.getOperation("getMShopAdminList").send();		
		}
		
		/**
		 * 担当者追加失敗
		 * */
		public function onFault_insertMShopAdmin(e:FaultEvent):void
		{
			trace("insertMShopAdmin...");
			trace(e.message);
		}
		 /**
		 * 担当者更新
		 * */
		 public function onClickChangeShopAdminButton(e:Event):void
		 {
		 	_shopAdminDto.registrationId = Application.application.indexLogic.loginStaff.staffId;
		 	
		 	this.view.lunchService.getOperation("updateMShopAdmin").send(_shopAdminDto);
		 }

 		 /**
		 * 担当者更新成功
		 * */
		public function onResult_updateMShopAdmin(e:ResultEvent):void
		{
			trace("updateMShopAdmin...");
			Alert.show(e.result + "人更新しました");
			view.lunchService.getOperation("getMShopAdminList").send();		
		}
		
		/**
		 * 担当者更新失敗
		 * */
		public function onFault_updateMShopAdmin(e:FaultEvent):void
		{
			trace("updateMShopAdmin...");
			trace(e.message);
		}
		 
		 /**
		 * 担当者削除
		 * */
		 public function onClickDeleteShopAdminButton(e:Event):void
		 {		 	
		 	
		 	this.view.lunchService.getOperation("deleteMShopAdmin").send(_shopAdminDto);
		 }
		 
		 /**
		 * 担当者削除成功
		 * */
		public function onResult_deleteMShopAdmin(e:ResultEvent):void
		{
			trace("deleteMShopAdmin...");
			Alert.show(e.result + "人削除しました");			
			view.lunchService.getOperation("getMShopAdminList").send();		
		}
		
		/**
		 * 担当者更新失敗
		 * */
		public function onFault_deleteMShopAdmin(e:FaultEvent):void
		{
			trace("deleteMShopAdmin...");
			trace(e.message);
		}
		 
		 /**
		 * 画面上のボタンの押下可能かどうか
		 * */
		 private function setButtonEnabled():void
		 {
		 	this.setDeleteButton();
			this.setUpdateButtonsEnabled();
			this.setAddButtonEnabled();	
		 }
		 
		 /**
		 * 削除ボタン状態
		 * */
		 private function setDeleteButton():void
		 {
		 	//担当者一覧が未選択状態ならfalse
		 	this.view.deleteShopAdminButton.enabled = (this.view.staffList.selectedItem != null );
		 }
		 
		 /**
		 * 更新ボタンの状態
		 * */
		private function setUpdateButtonsEnabled():void
		{
			//日付が正しいか
			var value:Boolean = this.checkInputData();
			//担当者一覧が未選択かどうか
			value = value && (this.view.staffList.selectedItem != null)
			this.view.changShopAdminButton.enabled = value;
		}		
		
		/**
		 * 追加ボタンの状態
		 * */
		 private function setAddButtonEnabled():void
		 {
		 	//日付が正しいか
		 	this.view.addShopAdminButton.enabled = checkInputData();
		 }
		
		/**
		 * 日付のチェック
		 * */
		private function checkInputData():Boolean
		{	
			/**未入力でなくて、開始日が終了日より前であること*/
			return this._shopAdminDto.startDate != null && 
			this._shopAdminDto.finishDate != null && 
			this._shopAdminDto.startDate < this._shopAdminDto.finishDate;
		}
		
		/** 画面 */
	    public var _view:RegisterShopAdmin;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterShopAdmin
	    {
	        if (_view == null) {
	            _view = super.document as RegisterShopAdmin;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterShopAdmin):void
	    {
	        _view = view;
	    }
				
	}
}