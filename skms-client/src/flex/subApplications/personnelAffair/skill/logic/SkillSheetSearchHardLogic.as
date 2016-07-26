package subApplications.personnelAffair.skill.logic
{
	import components.PopUpWindow;
	
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.collections.XMLListCollection;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.accounting.dto.TransportationDto;
	import subApplications.personnelAffair.skill.dto.SkillLabelDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillHardDto;
	import subApplications.personnelAffair.skill.web.SkillSheetSearchHard;

	public class SkillSheetSearchHardLogic extends Logic
	{
		/** ハード */
		[Bindable]
		public var _xmlList:XMLList;

		/** 選択項目 */
		private var _selectedItems:Array;

		/** 業務履歴登録ロジッククラス */
		//	データ取得失敗イベント用
		private var _skillSheetEntryLogic : SkillSheetEntryLogic = new SkillSheetEntryLogic();

		/**
		 * コンストラクタ
		 */
		public function SkillSheetSearchHardLogic()
		{
			this._selectedItems = new Array();
		}

		/**
		 * 画面が呼び出されたとき最初に実行される
		 * 
		 * @param e FLEXイベント
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// データをDBから取得
			view.skillSheetEntryService.getOperation("getProjectHardList").send();
		}

		/**
		 * データ取得成功イベント
		 */
		public function onResult_getProjectHardList(e:ResultEvent):void
		{
			trace("onResult_getProjectHardList...");

			var xmlList:XMLList		= new XMLList();
			var categoryId:String;
			var categoryXml:XML;
			var leafCount:int		= 0;

			//	DBから取得したデータをツリーに反映する
			for each (var hardDto : SkillLabelDto in e.result) {

				//	カテゴリ単位でXMLを追加する
				if (hardDto.categoryId != categoryId) {
					if (categoryXml != null) {
						xmlList += categoryXml;
					}
					categoryXml = 
						<category id={hardDto.categoryId} label={hardDto.categoryName}/>;
					categoryId	= hardDto.categoryId;
				}

				//	カテゴリに項目を追加する
				categoryXml.appendChild(
					<hard id={hardDto.id} label={hardDto.name}/>
				);

				leafCount++;
			}
			_xmlList = xmlList;

			//	ツリー/ 子画面のサイズを調整する
	    	view.treeHard.height	=	view.treeHard.rowHeight * (_xmlList.length() + leafCount);
	    	view.height				=	view.treeHard.height + 80;

			//	子要素まで展開した状態で表示する
	    	view.treeHard.validateNow();
	    	for each (var category:XML in _xmlList) {
	    		view.treeHard.expandChildrenOf(category, true);
	    	}
	    	
	    	var xmlArray : Array = new Array();

	    	//	業務履歴登録画面から渡されたハードを選択状態にする
	    	var transDtoArray 	: Array	= view.data.transportDto.hard as Array;
	    	var selectedArray	: Array	= new Array();
	    	
	    	//	渡された選択中ハードごとにループ
	    	for each( var transDto : StaffSkillHardDto in transDtoArray)
	    	{
	    		var dataProviderXmlListCollection	: XMLListCollection	= this.view.treeHard.dataProvider	as XMLListCollection;
				var index							: int				= 0;
				var findFlag						: Boolean			= false;

				//	ツリーに表示するカテゴリごとにループ
				for each (var dataProviderCategoryXml : XML in dataProviderXmlListCollection) {
					index++;
					var dataProviderHardXmlList	: XMLList	= dataProviderCategoryXml.children();
					
					//	ツリーに表示するハードごとにループ
					for each (var dataProviderHardXml	: XML	in dataProviderHardXmlList) {
						
						//	選択中ハードとツリー表示ハードが一致したら、選択中状態とする
						if (dataProviderHardXml.@id == transDto.hardId) {
							selectedArray.push(index);
							findFlag	= true;
							break;						
						}
						index++;
					}

					if (findFlag) {
						break;
					}
				}
	    	}
	    	this.view.treeHard.selectedIndices = selectedArray;
		}

		/**
		 * 業務履歴データ取得失敗イベント
		 */
		public function onFault_getInformation(e:FaultEvent):void
		{
			//	業務履歴登録ロジッククラスの取得失敗イベントを呼び出す
			_skillSheetEntryLogic.onFault_getInformation(e);
		}

		/**
		 * 選択ボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onClick_btnSelect(e:MouseEvent)	: void
		{
			//	ツリーで選択中の項目を呼び出し元画面に戻す
	    	for each (var selectedItem : XML in view.treeHard.selectedItems) {
	    		if ("hard" != selectedItem.name()) {
	    			continue;
	    		}
				var hardDto:StaffSkillHardDto = new StaffSkillHardDto();
				hardDto.hardId = selectedItem.@id;
				hardDto.hardName = selectedItem.@label;
				this._selectedItems.push(hardDto);
	    	}

			if (view.data && view.data.transportDto) {
				var trans:TransportationDto = view.data.transportDto;
				if (trans.hard == null) {
					trans.hard = new Array();
				}
				
				trans.hard	=	this._selectedItems;
			}
			// PopUpをCloseする.
			view.closeWindow(PopUpWindow.ENTRY);
		}

		/**
		 * キャンセルボタンの押下.
		 *
		 * @param e イベント.
		 */
		public function onClick_btnCancel(e:MouseEvent):void
		{
			view.closeWindow();
		}

//--------------------------------------
//  View-Logic Binding
//--------------------------------------
	    /** 画面 */
	    public var _view:SkillSheetSearchHard;

	    /**
	     * 画面を取得します
	     */
	    public function get view():SkillSheetSearchHard
	    {
	        if (_view == null) {
	            _view = super.document as SkillSheetSearchHard;
	        }
	        return _view;
	    }

	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:SkillSheetSearchHard):void
	    {
	        _view = view;
	    }
	}
}