package subApplications.personnelAffair.skill.logic
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
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.accounting.dto.TransportationDto;
	import subApplications.personnelAffair.skill.dto.SkillLabelListDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillPhaseDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillPositionDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillSheetDto;
	import subApplications.personnelAffair.skill.web.SkillSheetEntry;
	import subApplications.project.web.ProjectSelect;
	
	
	/**
	 * 業務履歴登録ロジッククラス
	 * 
	 * @author yoshinori-t
	 */
	public class SkillSheetEntryLogic extends Logic
	{
		/**
		 * プロジェクト区分
		 */
		[Bindable]
		public var kindList:ArrayCollection;
		
		/**
		 * 作業フェーズ
		 */
		[Bindable]
		public var phaseList:ArrayCollection;
		
		/**
		 * 参加形態
		 */
		[Bindable]
		public var positionList:ArrayCollection;
		
		/**
		 * 作成・変更用データ
		 */
		public var createSkillSheetData:StaffSkillSheetDto = null;
		
		/**
		 * プロジェクト検索用DTO
		 */
		public var selectedTransportDto:TransportationDto;
		
		
		/**
		 * コンストラクタ
		 */
		public function SkillSheetEntryLogic()
		{
			super();
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
		}
		
		/**
		 * 画面が呼び出されたとき最初に実行される
		 * 
		 * @param e FLEXイベント
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// プロジェクト検索用DTOの初期化
			selectedTransportDto = new TransportationDto();
			
			// 選択データを格納する変数をBind
			BindingUtils.bindProperty(view.kindList, "dataProvider", this, "kindList");
			BindingUtils.bindProperty(view.phaseList, "dataProvider", this, "phaseList");
			BindingUtils.bindProperty(view.positionList, "dataProvider", this, "positionList");
			
			// 各選択データをDBから取得
			view.skillSheetEntryService.getOperation("getProjectKindList").send();
			view.skillSheetEntryService.getOperation("getProjectPhaseList").send();
			view.skillSheetEntryService.getOperation("getProjectPositionList").send();
			
			// 作成・変更用データの初期設定
			setProperty();
		}
		
		/**
		 * 作成・変更用データの初期設定
		 * 
		 * @param dto 社員スキルシート情報Dto
		 */
		public function setProperty():void
		{
			// 作成・変更用データが設定されているかを判定する
			if (view.data && view.data.createSkillSheetData)
			{
				// 社員スキルシート情報Dtoの保持
				createSkillSheetData = view.data.createSkillSheetData;
				
				// 画面データの設定
				view.projectCode.text        = createSkillSheetData.projectCode;
				view.projectName.text        = createSkillSheetData.projectName;
				view.joinDate.selectedDate   = createSkillSheetData.joinDate;
				view.retireDate.selectedDate = createSkillSheetData.retireDate;
				view.hardware.text           = createSkillSheetData.hardware;
				view.os.text                 = createSkillSheetData.os;
				view.language.text           = createSkillSheetData.language;
				view.keyword.text            = createSkillSheetData.keyword;
				view.content.text            = createSkillSheetData.content;
			}
		}
		
	    /**
	     * プロジェクト検索ボタン押下処理
	     *
		 * @param e マウスイベント
	     */
		public function onClick_project(e:MouseEvent):void
		{
			// プロジェクト検索用DTOの準備
			var obj:Object = new Object();
			obj.transportDto = selectedTransportDto;
			
			// プロジェクト選択画面の表示
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(ProjectSelect, view, obj);
			
			// プロジェクト選択画面クローズ時イベントの登録
			pop.addEventListener(CloseEvent.CLOSE, onClose_projectSelect);
		}
		
		/**
		 * プロジェクト選択画面クローズ時イベント
		 *
	     * @param e Closeイベント.
		 */
		protected function onClose_projectSelect(e:CloseEvent):void
		{
			// プロジェクト選択画面でOKボタンを押下したとき.
			if (e.detail == PopUpWindow.ENTRY) {
				view.projectCode.text = selectedTransportDto.project.projectCode;
				view.projectName.text = selectedTransportDto.project.projectName;
			
				//追加 @auther watanuki
				if(selectedTransportDto.project.actualStartDate){
					view.joinDate.selectedDate = selectedTransportDto.project.actualStartDate;
				}else{
					view.joinDate.selectedDate = null;
				}
				if(selectedTransportDto.project.actualFinishDate){
					view.retireDate.selectedDate = selectedTransportDto.project.actualFinishDate;
				}else{
					view.retireDate.selectedDate = null;
				}
			}
		}
		
		/**
		 * 登録ボタン押下処理
		 */
		public function onClick_btnOk(e:MouseEvent):void
		{
			// エラーチェックの実施
			// プロジェクト名は必須
			if ( view.projectName.text == "" )
			{
				// エラーダイアログ表示
				Alert.show("プロジェクト名の入力は必須です。", "",
							Alert.OK, null,
							null, null, Alert.OK);
				return;
			}
			
			// 作成・変更用データが設定されているかを判定する
			if (view.data && view.data.createSkillSheetData)
			{
				
				// 以下の条件を満たす場合、プロジェクトIDも設定する
				// ・プロジェクトコードを変更した場合
				// ・プロジェクトコード検索用DTOのプロジェクトコードが存在する場合
				// ・画面のプロジェクトコードとプロジェクトコード検索用DTOのプロジェクトコードが一致する場合
				if ( createSkillSheetData.projectCode != view.projectCode.text )
				{
					if ( ( selectedTransportDto.project != null )
					  && ( view.projectCode.text == selectedTransportDto.project.projectCode ) )
					{
						createSkillSheetData.projectId = selectedTransportDto.projectId;
					}
					else
					{
						createSkillSheetData.projectId = 0;
					}
				}
				
				// 画面で設定したデータを員スキルシート情報Dtoに設定する
				createSkillSheetData.projectCode = view.projectCode.text;
				createSkillSheetData.projectName = view.projectName.text;
				createSkillSheetData.joinDate    = view.joinDate.editedDate;
				createSkillSheetData.retireDate  = view.retireDate.editedDate;
				createSkillSheetData.hardware    = view.hardware.text;
				createSkillSheetData.os          = view.os.text;
				createSkillSheetData.language    = view.language.text;
				createSkillSheetData.keyword     = view.keyword.text;
				createSkillSheetData.content     = view.content.text;
				
				// プロジェクト区分
				var kind:Object = view.kindList.selectedItem;
				createSkillSheetData.kindId      = kind.data;
				createSkillSheetData.kindName    = kind.label;
				
				// 作業フェーズ
				var phaseArray:Array = view.phaseList.selectedItems;
				var phaseList:Array = new Array();
				for each( var phase:Object in phaseArray)
				{
					var phaseDto:StaffSkillPhaseDto = new StaffSkillPhaseDto();
					phaseDto.staffId = createSkillSheetData.staffId;
					phaseDto.sequenceNo = createSkillSheetData.sequenceNo;
					phaseDto.phaseId = phase.id;
					phaseDto.phaseCode = phase.code;
					phaseDto.phaseName = phase.name;					// Dtoに変換
					phaseList.push(phaseDto);							// リストに変換
				}
				phaseList.sortOn("phaseId", Array.NUMERIC);			// 作業フェーズIDでソートを行う
				createSkillSheetData.setPhaseList(phaseList);			// 作業フェーズの更新

				// 参加形態
				var positionArray:Array = view.positionList.selectedItems;
				var positionList:Array = new Array();
				for each( var position:Object in positionArray)
				{
					var positionDto:StaffSkillPositionDto = new StaffSkillPositionDto();
					positionDto.staffId = createSkillSheetData.staffId;
					positionDto.sequenceNo = createSkillSheetData.sequenceNo;
					positionDto.positionId = position.id;
					positionDto.positionCode = position.code;
					positionDto.positionName = position.name;			// Dtoに変換
					positionList.push(positionDto);
				}
				positionList.sortOn("positionId", Array.NUMERIC);		// 参加形態IDでソートを行う
				createSkillSheetData.setPositionList(positionList);		// 参加形態の更新
			
//				// 参加形態
//				var position:Object = view.positionList.selectedItem;
//				var positionDto:StaffSkillPositionDto = new StaffSkillPositionDto();
//				positionDto.staffId = createSkillSheetData.staffId;
//				positionDto.sequenceNo = createSkillSheetData.sequenceNo;
//				positionDto.positionId = position.id;
//				positionDto.positionCode = position.code;
//				positionDto.positionName = position.name;				// Dtoに変換
//				var positionList:Array = new Array();
//				positionList.push(positionDto);							// リストに変換
//				createSkillSheetData.setPositionList(positionList);		// 参加形態の更新
				
				// 作成・変更用データの更新を行う
				view.data.createSkillSheetData = createSkillSheetData;
			}
			
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);
		}
		
		/**
		 * キャンセルボタン押下処理
		 */
		public function onClick_btnCancel(e:MouseEvent):void
		{
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
			view.dispatchEvent(ce);
		}
		
		/**
		 * ポップアップクローズ処理
		 * 登録やキャンセルボタン以外でのクローズ時に使用
		 */
		public function onClose_SkillSheetEntryDlg(e:CloseEvent):void
		{
			// 画面のクローズを行う
			PopUpManager.removePopUp(view);
		}
		
		/**
		 * プロジェクト区分取得成功イベント
		 */
		public function onResult_getProjectKindList(e:ResultEvent):void
		{
			trace("onResult_getProjectKindList...");
			
			// プロジェクト区分を更新する
			var projectKind:SkillLabelListDto = new SkillLabelListDto(e.result);
			kindList = projectKind.LabelList;
		}
		
		/**
		 * 作業フェーズ取得成功イベント
		 */
		public function onResult_getProjectPhaseList(e:ResultEvent):void
		{
			trace("onResult_getProjectPhaseList...");
			
			// 作業フェーズを更新する
			var projectPhase:SkillLabelListDto = new SkillLabelListDto(e.result);
			phaseList = projectPhase.LabelList;
		}
		
		/**
		 * 参加形態取得成功イベント
		 */
		public function onResult_getProjectPositionList(e:ResultEvent):void
		{
			trace("onResult_getProjectPositionList...");
			
			// 参加形態を更新する
			var projectPosition:SkillLabelListDto = new SkillLabelListDto(e.result);
			positionList = projectPosition.LabelList;
		}
		
		/**
		 * 業務履歴データ取得失敗イベント
		 */
		public function onFault_getInformation(e:FaultEvent):void
		{
			trace("onFault_getInformation...");
			
			// エラーダイアログ表示
			Alert.show("業務履歴データの取得に失敗しました。", "",
						Alert.OK, null,
						null, null, Alert.OK);
		}
		
		/**
		 * プロパティ変更時イベント
		 */
		private function propertyChangeHandler(e:PropertyChangeEvent):void
		{
			// プロジェクト区分が変更されたかどうかを判定する.
			if (e.property == "kindList")
			{
				// データが設定されている場合
				if ( createSkillSheetData != null )
				{
					view.kindList.selectedData = createSkillSheetData.kindId.toString();
				}
			}
			// 作業フェーズが変更されたかどうかを判定する.
			else if (e.property == "phaseList")
			{
				// データが設定されている場合
				if ( createSkillSheetData != null && createSkillSheetData.PhaseIdList != null )
				{
					view.phaseList.selectedDataArray = createSkillSheetData.PhaseIdList;
				}
			}
			// 参加形態が変更されたかどうかを判定する.
			else if (e.property == "positionList")
			{
				// データが設定されている場合
				if ( createSkillSheetData != null && createSkillSheetData.PositionIdList != null )
				{
//					view.positionList.selectedData = createSkillSheetData.PositionId;
					view.positionList.selectedDataArray = createSkillSheetData.PositionIdList;
				}
			}
		}
		
		
		/** 画面 */
	    public var _view:SkillSheetEntry;

	    /**
	     * 画面を取得します
	     */
	    public function get view():SkillSheetEntry
	    {
	        if (_view == null) {
	            _view = super.document as SkillSheetEntry;
	        }
	        return _view;
	    }
		
	    /**
	     * 画面をセットします。
	     *
	     * @param view セットする画面
	     */
	    public function set view(view:SkillSheetEntry):void
	    {
	        _view = view;
	    }
	}
}