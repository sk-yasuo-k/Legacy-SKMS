package subApplications.lunch.logic
{
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import subApplications.lunch.dto.ExclusiveOptionDto;
	import subApplications.lunch.dto.MOptionKindDto;
	import subApplications.lunch.web.SelectedOptionKind;
	
	public class SelectedOptionKindLogic extends Logic
	{
		/**
		 * 選択中排他オプション種類リストデータ
		 */	
	    [Bindable] 
		public var _optionKind:ArrayCollection = new ArrayCollection();

		/**
		 * オプション種類リストデータ
		 */	
	    [Bindable] 
		public var _optionKindList:ArrayCollection = new ArrayCollection();
				
		public function SelectedOptionKindLogic()
		{
			super();
		}
		
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.optionKind, "dataProvider", this, "_optionKind");
			BindingUtils.bindProperty(this.view.optionKindList, "dataProvider", this, "_optionKindList");
			
			_optionKind = view.data._optionKind;
			_optionKindList = view.data._optionKindList;
			if(view.data._selectedOptionKind != -1){
				_optionKindList.removeItemAt(view.data._selectedOptionKind);
			}
			_optionKindList.filterFunction = optionKindDuplicateCheck;
			_optionKindList.refresh();
		}

		/**
		 * オプション種類リストチェック処理
		 */
		public function optionKindDuplicateCheck(obj:Object):Boolean
		{
			for each(var optionKind:ExclusiveOptionDto in _optionKind){				
				if(optionKind.exclusiceMOptionKindId == obj.id){
					return false;
				}
				if(optionKind.id == obj.id){
					return false;
				}				
			}
			return true;
		}

		/**
		 * 追加ボタン押下処理
		 */
		public function onClick_selectedOptionKind(e:MouseEvent):void
		{
			var tmp:ExclusiveOptionDto = new ExclusiveOptionDto();
			var selectOptionKind:MOptionKindDto = view.optionKindList.selectedItem as MOptionKindDto;

			if(selectOptionKind != null){
				tmp.exclusiceMOptionKindId = selectOptionKind.id;
				tmp.mOptionKindName = selectOptionKind.optionKindName;
				
				_optionKind.addItem(tmp);
				_optionKindList.refresh();
			}
			selectOptionKind = new MOptionKindDto();
		}

		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_deleteOptionKind(e:MouseEvent):void
		{
			if(view.optionKind.selectedIndex != -1){
				_optionKind.removeItemAt(view.optionKind.selectedIndex);
			}
			_optionKindList.refresh();
		}

		/**
		 * 閉じるボタン押下処理
		 */
		public function onClick_close(e:MouseEvent):void
		{
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);
		}

		/**
		 * ポップアップクローズ処理
		 */
		public function onClose(e:CloseEvent):void
		{
			// 画面のクローズを行う
			PopUpManager.removePopUp(view);
		}
				
		/** 画面 */
	    public var _view:SelectedOptionKind;

	    /**
	     * 画面を取得します
	     */
	    public function get view():SelectedOptionKind
	    {
	        if (_view == null) {
	            _view = super.document as SelectedOptionKind;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:SelectedOptionKind):void
	    {
	        _view = view;
	    }		
	}
}