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
	
	import subApplications.lunch.dto.OptionDto;
	import subApplications.lunch.dto.OptionDtoList;
	import subApplications.lunch.web.*;
	
	import utils.CommonIcon;

	/**
	 * オプション登録ロジッククラス
	 * 
	 * @author t-ito
	 */				
	public class RegisterOptionLogic extends Logic
	{
		/** オプションリスト */
		[Bindable]
		public var _optionList:ArrayCollection;		
		
		public function RegisterOptionLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.optionList, "dataProvider", this, "_optionList");
			
			view.lunchService.getOperation("getOptionList").send();
		}

		/**
		 * ボタン有効無効処理
		 */
		public function buttonStatus(bool:Boolean):void
		{	
			view.deleteOption.enabled = bool;
			view.updateOption.enabled = bool;
		}

		/**
		 * オプションリスト選択
		 */
		public function onClick_optionList(e:ListEvent):void
		{	
			var tmp:OptionDto = e.itemRenderer.data as OptionDto;
			view.optionName.text = tmp.optionName;
			view.displayName.text = tmp.optionDisplayName;
			view.code.text = tmp.optionCode;
			view.price.text = tmp.price.toString();
			
			buttonStatus(true);
		}

		/**
		 * 初期化処理
		 */
		public function initializationText():void
		{	
			view.optionName.text = "";
			view.displayName.text = "";
			view.code.text = "";
			view.price.text = "";
		}

		/**
		 * 検索処理
		 */
		public function optionSearch(obj:Object):Boolean
		{	
			if(view.search.length != 0){

				if( obj.optionName.indexOf(view.search.text) >= 0 ){
					return true;
				}else{
					return false;
				}					
			}
			return true;
		}

		/**
		 * 検索入力処理
		 */
		public function onChange_search():void
		{
			this._optionList.refresh();
			initializationText();
			buttonStatus(false);
		}

		/**
		 * オプションリスト取得成功
		 * */
		public function onResult_getOptionList(e:ResultEvent):void
		{
			trace("onResult_getOptionList...");
			
			var optionDtoList:OptionDtoList = new OptionDtoList(e.result);
			this._optionList = optionDtoList.optionList;
			this._optionList.filterFunction = optionSearch;
		}
		
		/**
		 * オプションリスト取得失敗
		 * */
		public function onFault_getOptionList(e:FaultEvent):void
		{
			trace("onFault_getOptionList...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);						
		}

		/**
		 * 入力データ格納処理
		 */
		public function createInputData(tmp:OptionDto):OptionDto
		{
			tmp.optionName = view.optionName.text;
			tmp.optionDisplayName = view.displayName.text;
			tmp.optionCode = view.code.text;
			tmp.price = int(view.price.text);		
			tmp.registrationId = Application.application.indexLogic.loginStaff.staffId;
			
			return 	tmp;
		}

		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_optionDelete(e:MouseEvent):void
		{						
			Alert.show("削除してもよろしいですか？", "", 3, view, optionDelete);
		}

		/**
		 * 削除処理
		 */
		public function optionDelete(e:CloseEvent):void
		{
			var tmp:OptionDto = view.optionList.selectedItem as OptionDto;
			
			if(e.detail == Alert.YES){
				view.lunchService.getOperation("deleteOptionData").send(tmp);
			}
		}

		/**
		 * 削除処理成功
		 */
		public function onResult_deleteOptionData(e:ResultEvent):void
		{
			trace("onResult_deleteOptionData...");
			onCreationCompleteHandler(null);
			initializationText();
			buttonStatus(false);
		}	

		/**
		 * 削除処理失敗
		 */
		public function onFault_deleteOptionData(e:FaultEvent):void
		{
			trace("onFault_deleteOptionData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("オプションの削除に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}

		/**
		 * 更新ボタン押下処理
		 */
		public function onClick_optionUpdate(e:MouseEvent):void
		{						
			Alert.show("更新してもよろしいですか？", "", 3, view, optionUpdate);
		}

		/**
		 * 更新処理
		 */
		public function optionUpdate(e:CloseEvent):void
		{
			var tmp:OptionDto = view.optionList.selectedItem as OptionDto;

			createInputData(tmp);
			
			if(e.detail == Alert.YES){
				view.lunchService.getOperation("updateOptionData").send(tmp);
			}
		}
		
		/**
		 * 更新処理成功
		 */
		public function onResult_updateOptionData(e:ResultEvent):void
		{
			trace("onResult_updateOptionData...");
			onCreationCompleteHandler(null);
			initializationText();
			buttonStatus(false);
		}	

		/**
		 * 更新処理失敗
		 */
		public function onFault_updateOptionData(e:FaultEvent):void
		{
			trace("onFault_updateOptionData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("オプションの登録に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}

		/**
		 * 新規ボタン押下処理
		 */
		public function onClick_optionInsert(e:MouseEvent):void
		{	
			if(view.optionName.text == "" || view.displayName.text == "" || view.price.text == ""){	
				// 未入力ならエラーダイアログ表示
				Alert.show("未入力の項目があります。", "Error", Alert.OK, null, null, null, Alert.OK);
			}else{
			
				var insertData:OptionDto = new OptionDto();
				var dialogMessage:String = "新規登録してもよろしいですか？";
				
				createInputData(insertData);
			
				for each(var optionlist:OptionDto in _optionList){
					if(optionlist.optionName == insertData.optionName && optionlist.optionDisplayName == insertData.optionDisplayName 
						&& optionlist.price == insertData.price){
							
						dialogMessage = "同じ内容のデータがあります。\n新規登録してもよろしいですか？";
					}
				}	
				
				Alert.show(dialogMessage, "", 3, view, optionInsert, CommonIcon.questionIcon);
			}
		}

		/**
		 * 新規登録処理
		 */
		public function optionInsert(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				var insertData:OptionDto = new OptionDto();
				
				createInputData(insertData);
				
				view.lunchService.getOperation("insertOptionData").send(insertData);
			}			
		}

		/**
		 * 新規登録処理成功
		 */
		public function onResult_insertOptionData(e:ResultEvent):void
		{
			trace("onResult_insertOptionData...");
			onCreationCompleteHandler(null);
			initializationText();
			buttonStatus(false);
		}	

		/**
		 * 新規登録処理失敗
		 */
		public function onFault_insertOptionData(e:FaultEvent):void
		{
			trace("onFault_insertOptionData...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("オプションの登録に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}		

	
		/** 画面 */
	    public var _view:RegisterOption;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterOption
	    {
	        if (_view == null) {
	            _view = super.document as RegisterOption;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterOption):void
	    {
	        _view = view;
	    }

	}
}