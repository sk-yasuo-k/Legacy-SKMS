package subApplications.lunch.logic
{
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.lunch.dto.MMenuDto;
	import subApplications.lunch.dto.MMenuDtoList;
	import subApplications.lunch.dto.MOptionSetDtoList;
	import subApplications.lunch.dto.MenuCategoryDtoList;
	import subApplications.lunch.web.*;
	
	import utils.CommonIcon;

	/**
	 * メニュー登録ロジッククラス
	 * 
	 * @author t-ito
	 */				
	public class RegisterMenuLogic extends Logic
	{
		/** メニュー一覧 */
		[Bindable]
		public var _menuList:ArrayCollection;

		/** メニューカテゴリ一覧 */
		[Bindable]
		public var _menuCategory:ArrayCollection;
		
		/** オプションセット一覧 */
		[Bindable]
		public var _optionSet:ArrayCollection;							

		/** ファイル選択オブジェクト */
		private var refSelectFiles:FileReference = new FileReference();

		/** 選択メニューデータ */
		public var _mMenuDto:MMenuDto;
		
		/** 新規登録用メニューデータ */
		public var _insertData:MMenuDto = new MMenuDto();		
		
		public function RegisterMenuLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{	
			BindingUtils.bindProperty(this.view.categoryComboBox, "dataProvider", this, "_menuCategory");
			BindingUtils.bindProperty(this.view.optionSetComboBox, "dataProvider", this, "_optionSet");
			
			view.lunchService.getOperation("getMMenuList").send();
			view.lunchService.getOperation("getMenuCategory").send();
			view.lunchService.getOperation("getMOptionSetList").send();
		}

		/**
		 * 新規・写真更新ボタン有効無効処理
		 */
		public function buttonStatus(bool:Boolean):void
		{
			view.imageButton.enabled = bool;
			view.insertButton.enabled = bool;
		}
		
		/**
		 * 更新・削除ボタン有効無効処理
		 */
		public function selectButtonStatus(bool:Boolean):void
		{	
			view.deleteButton.enabled = bool;
			view.updateButton.enabled = bool;
		}
		
		/**
		 * 初期化処理
		 */
		public function initializationText():void
		{
			view.photo.source = null;
			view.photo.load();
			view.menuName.text = "";
			view.menuCode.text = "";
			view.price.text = "";
			view.comment.text = "";
		}		

		/**
		 * メニュー選択処理
		 */		
		public function onClick_menuList(e:Event):void
		{
			if(view.menuList.selectedItem != null){			
				this._mMenuDto = view.menuList.selectedItem as MMenuDto;
				view.photo.source = this._mMenuDto.photo;
				view.photo.load();
				view.categoryComboBox.selectedData = this._mMenuDto.menuCategoryId.toString();
				view.optionSetComboBox.selectedData = this._mMenuDto.mOptionSetId.toString();
				view.menuName.text = this._mMenuDto.menuName;
				if(this._mMenuDto.menuCode != null){
					view.menuCode.text = this._mMenuDto.menuCode.toString();
				}
				view.price.text = this._mMenuDto.price.toString();
				view.comment.text = this._mMenuDto.comment;
			}
			
			selectButtonStatus(true);
		}

		/**
		 * 入力データ格納処理
		 */
		public function createInputData(tmp:MMenuDto):MMenuDto
		{
			tmp.menuCode = view.menuCode.text;
			tmp.menuName = view.menuName.text;
			tmp.price = int(view.price.text);
			tmp.mOptionSetId = int(view.optionSetComboBox.selectedData);
			tmp.menuCategoryId = int(view.categoryComboBox.selectedData);
			tmp.comment = view.comment.text;
			tmp.photo = view.photo.source as ByteArray;
			tmp.registrationId = Application.application.indexLogic.loginStaff.staffId;
			
			return 	tmp;
		}
		
		/**
		 * 写真更新押下処理
		 */
		public function onClick_uploadPhotoButton(e:MouseEvent):void
		{
			// リスナー登録(ファイル選択)
			refSelectFiles.addEventListener(Event.SELECT,onSelect_staffImage);
			
			var fileFilter:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
			
			// ファイル選択のダイアログを表示
			refSelectFiles.browse([fileFilter]);
		}
		
		/**
		 * 写真更新ボタン押下処理(ファイル選択後)
		 */
		private function onSelect_staffImage(e:Event):void
		{
			// リスナー登録(ファイル選択)の解除
			refSelectFiles.removeEventListener(Event.SELECT, onSelect_staffImage);
			
			// リスナー登録(ファイル読込)
			refSelectFiles.addEventListener(Event.COMPLETE, onLoadComplete_staffImage);
			
			// ファイル読込の実施
			refSelectFiles.load();
		}
		
		/**
		 * 写真更新ボタン押下処理(ファイル読込後)
		 */
		private function onLoadComplete_staffImage(e:Event):void
		{
			// リスナー登録(ファイル読込)の解除
			refSelectFiles.removeEventListener(Event.COMPLETE, onLoadComplete_staffImage);
			
			// バイナリデータとしてデータを取得
			var staffImageRaw:ByteArray = refSelectFiles.data;
			view.photo.source = staffImageRaw;
			view.photo.load();						
		}

		/**
		 * 新規ボタン押下処理
		 */
		public function onClick_menuInsert(e:MouseEvent):void
		{	
			if(view.menuName.text == "" || view.price.text == ""){
				// 未入力ならエラーダイアログ表示
				Alert.show("未入力の項目があります。", "Error", Alert.OK, null, null, null, Alert.OK);				
			}else{	
				var dialogMessage:String = "新規登録してもよろしいですか？";
				
				createInputData(_insertData);
				
				for each(var menulist:MMenuDto in this._menuList){
					if(menulist.menuName == _insertData.menuName && menulist.menuCode == _insertData.menuCode 
						&& menulist.price == _insertData.price && menulist.menuCategoryId == _insertData.menuCategoryId 
						&& menulist.mOptionSetId == _insertData.mOptionSetId && menulist.comment == _insertData.comment 
						&& menulist.photo == _insertData.photo){
						dialogMessage = "同じ内容のデータがあります。\n新規登録してもよろしいですか？";
					}
				}
				
				Alert.show(dialogMessage, "", 3, view, menuInsert, CommonIcon.questionIcon);
			}
		}

		/**
		 * 新規登録処理
		 */
		public function menuInsert(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				// 新規登録
				view.lunchService.getOperation("insertMenuData").send(_insertData);				
			}
		}

		/**
		 * 新規登録処理成功
		 */
		public function onResult_insertMenuData(e:ResultEvent):void
		{
			trace("onResult_insertMenuData...");
			buttonStatus(false);
			selectButtonStatus(false);
			initializationText();
			onCreationCompleteHandler(null);
		}	

		/**
		 * 新規登録処理失敗
		 */
		public function onFault_insertMenuData(e:FaultEvent):void
		{
			trace("onFault_insertMenuData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("メニューの登録に失敗しました。", "Error",	Alert.OK, null, null, null, Alert.OK);
		}		

		/**
		 * 更新ボタン押下処理
		 */
		public function onClick_menuUpdate(e:MouseEvent):void
		{				
			Alert.show("更新してもよろしいですか？", "", 3, view, menuUpdate);
		}

		/**
		 * 更新処理
		 */
		public function menuUpdate(e:CloseEvent):void
		{	
			if(e.detail == Alert.YES){
				createInputData(this._mMenuDto);
				// 更新
				view.lunchService.getOperation("updateMenuData").send(this._mMenuDto);
			}
		}
		
		/**
		 * 更新処理成功
		 */
		public function onResult_updateMenuData(e:ResultEvent):void
		{
			trace("onResult_updateMenuData...");
			buttonStatus(false);
			selectButtonStatus(false);
			initializationText();
			onCreationCompleteHandler(null);
		}	

		/**
		 * 更新処理失敗
		 */
		public function onFault_updateMenuData(e:FaultEvent):void
		{
			trace("onFault_updateMenuData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("メニューの更新に失敗しました。", "Error",	Alert.OK, null, null, null, Alert.OK);
		}

		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_menuDelete(e:MouseEvent):void
		{
			Alert.show("削除してもよろしいですか？", "", 3, view, menuDelete);
		}

		/**
		 * 削除処理
		 */
		public function menuDelete(e:CloseEvent):void
		{	
			if(e.detail == Alert.YES){
				createInputData(this._mMenuDto);
				// 削除
				view.lunchService.getOperation("deleteMenuData").send(this._mMenuDto);
			}
		}

		/**
		 * 削除処理成功
		 */
		public function onResult_deleteMenuData(e:ResultEvent):void
		{
			trace("onResult_deleteMenuData...");
			
			if(e.result){
				Alert.show("メニューの削除が完了しました。", null, Alert.OK, null, null, null, Alert.OK);
				buttonStatus(false);
				selectButtonStatus(false);
				initializationText();
				onCreationCompleteHandler(null);
			}else{
				Alert.show("選択されたメニューは使用中です。", "Error", Alert.OK, null, null, CommonIcon.exclamationRedIcon, Alert.OK);
			}
		}	

		/**
		 * 削除処理失敗
		 */
		public function onFault_deleteMenuData(e:FaultEvent):void
		{
			trace("onFault_deleteMenuData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("メニューの削除に失敗しました。", "Error",	Alert.OK, null, null, null, Alert.OK);
		}

		/**
		 * メニュー一覧取得成功
		 */
		public function onResult_getMMenuList(e:ResultEvent):void
		{
			trace("onResult_getMMenuList...");
			var mMenuDtoList:MMenuDtoList = new MMenuDtoList(e.result);
			this._menuList = mMenuDtoList.mMenuList;
			BindingUtils.bindProperty(this.view.menuList, "menuArray", this, "_menuList");
			buttonStatus(true);
		}
		
		/**
		 * メニュー一覧取得失敗
		 */
		public function onFault_getMMenuList(e:FaultEvent):void
		{
			trace("onFault_getMMenuList...");
			trace(e.message);
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);
		}

		/**
		 * メニューカテゴリー取得成功
		 */
		public function onResult_getMenuCategory(e:ResultEvent):void
		{
			trace("onResult_getMenuCategory...");
			var menuCategoryList:MenuCategoryDtoList = new MenuCategoryDtoList(e.result);
			this._menuCategory = menuCategoryList.menuCategory;
			this.view.menuList.categoryArray = menuCategoryList.menuCategoryList;
		}
		
		/**
		 * メニューカテゴリー取得失敗
		 */
		public function onFault_getMenuCategory(e:FaultEvent):void
		{
			trace("onFault_getMenuCategory...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);
		}

		/**
		 * オプションセット取得成功
		 */
		public function onResult_getMOptionSetList(e:ResultEvent):void
		{
			trace("onResult_getMOptionSetList...");
			var mOptionSetList:MOptionSetDtoList = new MOptionSetDtoList(e.result);
			this._optionSet = mOptionSetList.mOptionSetList;
		}
		
		/**
		 * オプションセット取得失敗
		 */
		public function onFault_getMOptionSetList(e:FaultEvent):void
		{
			trace("onFault_getMOptionSetList...");
			trace(e.message);

			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null, null, null, Alert.OK);			
		}
		
		/** 画面 */
	    public var _view:RegisterMenu;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterMenu
	    {
	        if (_view == null) {
	            _view = super.document as RegisterMenu;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterMenu):void
	    {
	        _view = view;
	    }

	}
}