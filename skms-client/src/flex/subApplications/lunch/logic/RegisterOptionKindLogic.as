package subApplications.lunch.logic
{
	import components.PopUpWindow;
	
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import subApplications.lunch.dto.ExclusiveOptionDtoList;
	import subApplications.lunch.dto.MOptionKindDto;
	import subApplications.lunch.dto.MOptionKindDtoList;
	import subApplications.lunch.dto.OptionDtoList;
	import subApplications.lunch.dto.OptionKindDtoList;
	import subApplications.lunch.web.*;
	
	public class RegisterOptionKindLogic extends Logic
	{
		/** オプション種類リスト */
		[Bindable]
		public var _optionKindList:ArrayCollection = new ArrayCollection();
		
		/** オプションリスト */
		[Bindable]
		public var _optionList:ArrayCollection = new ArrayCollection();			

		/** 選択オプション */
		[Bindable]
		public var _option:ArrayCollection = new ArrayCollection();
		
		/** 排他オプション種類 */
		[Bindable]
		public var _exclusiveOption:ArrayCollection = new ArrayCollection();
						
		public function RegisterOptionKindLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.optionKindList, "dataProvider", this, "_optionKindList");
			BindingUtils.bindProperty(this.view.option, "dataProvider", this, "_option");
			BindingUtils.bindProperty(this.view.exclusiveOptionList, "dataProvider", this, "_exclusiveOption");
			
			view.lunchService.getOperation("getMOptionKindList").send();
			view.lunchService.getOperation("getOptionList").send();
		}

		/**
		 * ボタン有効無効処理
		 */
		public function buttonStatus(bool:Boolean):void
		{	
			view.deleteOptionKind.enabled = bool;
			view.updateOptionKind.enabled = bool;
		}

		/**
		 * 初期化処理
		 */
		public function initializationText():void
		{	
			view.optionKindName.text = "";
			view.displayName.text = "";
			view.code.text = "";
			_option = new ArrayCollection();
			_exclusiveOption = new ArrayCollection();
		}

		/**
		 * 検索入力処理
		 */
		public function onChange_search():void
		{
			this._optionKindList.refresh();
			initializationText();
			buttonStatus(false);
		}

		/**
		 * 検索処理
		 */
		public function optionKindSearch(obj:Object):Boolean
		{	
			if(view.search.length != 0){

				if( obj.optionKindName.indexOf(view.search.text) >= 0 ){
					return true;
				}else{
					return false;
				}					
			}
			return true;
		}
		
		/**
		 * オプション種類一覧取得成功
		 */
		public function onResult_getMOptionKindList(e:ResultEvent):void
		{
			trace("onResult_getMOptionKindList...");
			var optionKindList:MOptionKindDtoList = new MOptionKindDtoList(e.result);
			this._optionKindList = optionKindList.optionKindList;
			this._optionKindList.filterFunction = optionKindSearch;
		}
		
		/**
		 * オプション種類一覧取得失敗
		 */
		public function onFault_getMOptionKindList(e:FaultEvent):void
		{
			trace("onFault_getMOptionKindList...");
			trace(e.message);
		}

		/**
		 * オプションリスト取得成功
		 */
		public function onResult_getOptionList(e:ResultEvent):void
		{
			trace("onResult_getOptionList...");			
			var optionDtoList:OptionDtoList = new OptionDtoList(e.result);
			this._optionList = optionDtoList.optionList;
		}
		
		/**
		 * オプションリスト取得失敗
		 */
		public function onFault_getOptionList(e:FaultEvent):void
		{
			trace("onFault_getOptionList...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null,	null, null, Alert.OK);						
		}

		/**
		 * オプション種類一覧選択
		 */
		public function onClick_optionKindList(e:ListEvent):void
		{	
			var tmp:MOptionKindDto = e.itemRenderer.data as MOptionKindDto;
			view.optionKindName.text = tmp.optionKindName;
			view.displayName.text = tmp.optionKindDisplayName;
			view.code.text = tmp.optionKindCode;
			
			view.lunchService.getOperation("getOptionKindList").send(tmp.id);
			view.lunchService.getOperation("getExclusiveOptionKindList").send(tmp.id);
			buttonStatus(true);
		}
		
		/**
		 * 選択オプション一覧取得成功
		 */
		public function onResult_getOptionKind(e:ResultEvent):void
		{
			trace("onResult_getOptionKind...");
			var option:OptionKindDtoList = new OptionKindDtoList(e.result);
			this._option = option.option;
		}
		
		/**
		 * 選択オプション一覧取得失敗
		 */
		public function onFault_getOptionKind(e:FaultEvent):void
		{
			trace("onFault_getOptionKind...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null,	null, null, Alert.OK);				
		}
		
		/**
		 * 排他オプション種類一覧取得成功
		 */
		public function onResult_getExclusiveOptionKindList(e:ResultEvent):void
		{
			trace("onResult_getExclusiveOptionKindList...");
			var exclusiveOption:ExclusiveOptionDtoList = new ExclusiveOptionDtoList(e.result);
			this._exclusiveOption = exclusiveOption.exclusiveOption;
		}
		
		/**
		 * 排他オプション種類一覧取得失敗
		 */
		public function onFault_getExclusiveOptionKindList(e:FaultEvent):void
		{
			trace("onFault_getExclusiveOptionKindList...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null,	null, null, Alert.OK);				
		}		

		/**
		 * オプション選択ボタン押下処理
		 */
		public function onClick_selectedOption(e:MouseEvent):void
		{
			// データ準備
			var obj:Object = new Object();
			obj._option = _option;
			obj._optionList = ObjectUtil.copy(_optionList) as ArrayCollection;
			
			// 表示項目選択画面の表示
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(SelectedOption, view, obj);
			///closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onSelectedOptionPopUpClose);							
		}

		/**
		 * 排他オプション種類選択ボタン押下処理
		 */
		public function onClick_selectedOptionKind(e:MouseEvent):void
		{
			// データ準備
			var obj:Object = new Object();		
			obj._optionKind = _exclusiveOption;
			obj._optionKindList = ObjectUtil.copy(_optionKindList) as ArrayCollection;
			obj._selectedOptionKind = view.optionKindList.selectedIndex as int;
			
			// 表示項目選択画面の表示
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(SelectedOptionKind, view, obj);
			///closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onSelectedOptionPopUpClose);											
		}

		/**
		 * 更新されたデータを表示
		 */
		public function onSelectedOptionPopUpClose(e:CloseEvent):void
		{
			if(e.detail == Alert.OK){
				_option.refresh();
				_exclusiveOption.refresh();
			}
		}

		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_optionKindDelete(e:MouseEvent):void
		{						
			Alert.show("削除してもよろしいですか？", "", 3, view, optionKindDelete);
		}

		/**
		 * 削除処理
		 */
		public function optionKindDelete(e:CloseEvent):void
		{
			var tmp:MOptionKindDto = view.optionKindList.selectedItem as MOptionKindDto;
			
			if(e.detail == Alert.YES){
				view.lunchService.getOperation("deleteOptionKind").send(tmp, _option, _exclusiveOption);
			}			
		}

		/**
		 * 削除処理成功
		 */
		public function onResult_deleteOptionKind(e:ResultEvent):void
		{
			trace("onResult_deleteOptionKind...");
			onCreationCompleteHandler(null);
			initializationText();
			buttonStatus(false);
		}	

		/**
		 * 削除処理失敗
		 */
		public function onFault_deleteOptionKind(e:FaultEvent):void
		{
			trace("onFault_deleteOptionKind...");
			trace(e.message);
			
			// エラーダイアログ表示
			Alert.show("オプションの削除に失敗しました。", "Error", Alert.OK, null,	null, null, Alert.OK);
		}
		
		
		/** 画面 */
	    public var _view:RegisterOptionKind;

	    /**
	     * 画面を取得します
	     */
	    public function get view():RegisterOptionKind
	    {
	        if (_view == null) {
	            _view = super.document as RegisterOptionKind;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:RegisterOptionKind):void
	    {
	        _view = view;
	    }

	}
}