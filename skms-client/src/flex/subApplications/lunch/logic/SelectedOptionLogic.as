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
	
	import subApplications.lunch.dto.OptionDto;
	import subApplications.lunch.dto.OptionKindDto;
	import subApplications.lunch.web.SelectedOption;
	
	public class SelectedOptionLogic extends Logic
	{
		/**
		 * 選択中オプションリストデータ
		 */	
	    [Bindable] 
		public var _option:ArrayCollection = new ArrayCollection();

		/**
		 * オプションリストデータ
		 */	
	    [Bindable] 
		public var _optionList:ArrayCollection = new ArrayCollection();
				
		public function SelectedOptionLogic()
		{
			super();
		}

		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			BindingUtils.bindProperty(this.view.option, "dataProvider", this, "_option");
			BindingUtils.bindProperty(this.view.optionList, "dataProvider", this, "_optionList");
				
			_option = view.data._option;
			_optionList = view.data._optionList;
			_optionList.filterFunction = optionDuplicateCheck;
			_optionList.refresh();
		}

		/**
		 * オプションリストチェック処理
		 */
		public function optionDuplicateCheck(obj:Object):Boolean
		{
			for each(var option:OptionKindDto in _option){
				if(option.optionId == obj.id){
					return false;
				}
			}
			return true;
		}

		/**
		 * 追加ボタン押下処理
		 */
		public function onClick_selectedOption(e:MouseEvent):void
		{
			var tmp:OptionKindDto = new OptionKindDto();
			var selectOption:OptionDto = view.optionList.selectedItem as OptionDto;
			
			if(selectOption != null){
				tmp.optionId = selectOption.id;
				tmp.optionName = selectOption.optionName;
				
				_option.addItem(tmp);
				_optionList.refresh();
			}
		}

		/**
		 * 削除ボタン押下処理
		 */
		public function onClick_deleteOption(e:MouseEvent):void
		{
			if(view.option.selectedIndex != -1){
				_option.removeItemAt(view.option.selectedIndex);
			}
			_optionList.refresh();
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
	    public var _view:SelectedOption;

	    /**
	     * 画面を取得します
	     */
	    public function get view():SelectedOption
	    {
	        if (_view == null) {
	            _view = super.document as SelectedOption;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:SelectedOption):void
	    {
	        _view = view;
	    }
	}
}