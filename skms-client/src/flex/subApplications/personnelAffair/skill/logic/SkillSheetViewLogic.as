package subApplications.personnelAffair.skill.logic
{
	import flash.events.*;
	import flash.net.*;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.*;
	import mx.core.Application;
	import mx.events.*;
	import mx.managers.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.states.*;
	
	import subApplications.personnelAffair.skill.dto.ExperienceYearsDto;
	import subApplications.personnelAffair.skill.dto.SkillStaffDto;
	import subApplications.personnelAffair.skill.dto.StaffListDto;
	import subApplications.personnelAffair.skill.dto.StaffSkillListDto;
	import subApplications.personnelAffair.skill.web.*;
	
	
	/**
	 * 業務履歴一覧ロジッククラス
	 * 
	 * @author yoshinori-t
	 */
	public class SkillSheetViewLogic extends Logic
	{
		/**
		 * EXCEL出力時のURL
		 */
	    private const exportURL:String = "/skms-server/skillSheetFileExport";
	    
		/**
		 * 社員ID
		 */
		[Bindable]
		public var _staffId:int;
		
		/**
		 * 社員リスト
		 */
		[Bindable]
		public var _staffList:ArrayCollection;
		
		/**
		 * 社員詳細
		 */
		[Bindable]
		public var _staffDetail:SkillStaffDto;
		
		/**
		 * 取得資格
		 */
		[Bindable]
		public var _authorizedLicence:String;
		
		/**
		 * 取得免許
		 */
		[Bindable]
		public var _otherLocence:String;
		
		/**
		 * スキルシートリストDto
		 */
		private var _staffSkillListDto:StaffSkillListDto;
		
		/**
		 * スキルシートリスト
		 */
		[Bindable]
		public var _staffSkillList:ArrayCollection;
		
		/**
		 * 経験年数(制御系)
		 */
		[Bindable]
		public var _control:Number = 0.0;
		
		/**
		 * 経験年数(業務系)
		 */
		[Bindable]
		public var _open:Number = 0.0;
		
		/**
		 * 経験年数(保守)
		 */
		[Bindable]
		public var _maintenance:Number = 0.0;
		
		
		/**
		 * コンストラクタ
		 */
		public function SkillSheetViewLogic()
		{
			super();
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
		}
		
		/**
		 * 画面が呼び出されたとき最初に実行される
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// 必要な変数をバインド
			BindingUtils.bindProperty(view.staffList, "dataProvider", this, "_staffList");
			BindingUtils.bindProperty(view.skillSheetHeader.staffDetail, "dataProvider", this, "_staffDetail");	
			BindingUtils.bindProperty(view.skillSheetHeader.authorizedLicence, "text", this, "_authorizedLicence");
			BindingUtils.bindProperty(view.skillSheetHeader.otherLocence, "text", this, "_otherLocence");
			BindingUtils.bindProperty(view.skillSheetFooter.history, "dataProvider", this, "_staffSkillList");
			BindingUtils.bindProperty(view.skillSheetFooter.control, "text", this, "_control");
			BindingUtils.bindProperty(view.skillSheetFooter.open, "text", this, "_open");
			BindingUtils.bindProperty(view.skillSheetFooter.maintenance, "text", this, "_maintenance");
			
			// 社員リストの取得
			view.skillSheetService.getOperation("getStaffList").send();
		}
		
		/**
		 * 検索ボタン押下処理
		 */
		public function onClick_searchButton(e:MouseEvent):void
		{
			// ボタンを無効にする.
			setEnabledButton(false);
			
			// 検索条件が設定されている場合
			if ( view.serachName.text.length > 0 )
			{
				_staffList.filterFunction = staffListFillter;
			}
			// 検索条件が設定されていない場合
			else
			{
				_staffList.filterFunction = null;
			}
			
			// リストの更新を行う
			_staffList.refresh();
			
			// ボタンを有効にする.
			setEnabledButton(true);
		}
		
		/**
		 * 社員名検索入力フィールドEnter押下イベント処理
		 */
		public function onEnter_shaarchName():void
		{
			// 検索ボタン押下処理を呼び出す
			onClick_searchButton(new MouseEvent(MouseEvent.CLICK));
		}
		
		/**
		 * Excel形式出力ボタン押下処理
		 */
		public function onClick_linkList_export(e:MouseEvent):void
		{
			// HTTPリクエストの準備
			var request:URLRequest = new URLRequest(exportURL);
			request.method = URLRequestMethod.POST;
			// パラメータを用意
			var variables:URLVariables = new URLVariables();
			variables.staffId = _staffId;
			request.data = variables;
			// HTTPリクエストの送信
			navigateToURL(request, "_blank");
		}
		
		/**
		 * 社員検索用関数
		 */
		public function staffListFillter(data:Object):Boolean{
			
			// 検索用正規表現を作成する(部分一致するものを抽出)
			var strSearch:String;
			strSearch = ".*" + view.serachName.text + ".*"
			
			// 検索実行
			return data.fullName.match(strSearch);
		}
		
		/**
		 * ボタン有効設定.
		 *
		 * @param enable 有効／無効.
		 */
		private function setEnabledButton(enable:Boolean):void
		{
			// 検索ボタン
			view.btnSearch.enabled = enable;
		}
		
		/**
		 * 社員リスト得成功イベント
		 */
		public function onResult_getStaffList(e: ResultEvent):void
		{
			trace("onResult_getStaffList...");
			
			// 社員リストを更新する.
			var staffListDto:StaffListDto = new StaffListDto(e.result);
			_staffList = staffListDto.StaffList;
			
			// デフォルト値としてログイン者の社員IDを設定する.
			_staffId = Application.application.indexLogic.loginStaff.staffId;
			
			// ボタンを有効にする.
			setEnabledButton(true);
		}
		
		/**
		 * スキルシートリスト得成功イベント
		 */
		public function onResult_getStaffSkillList(e : ResultEvent):void
		{
			trace("onResult_getStaffSkillList...");
			
			// スキルシートリストを更新する
			_staffSkillListDto = new StaffSkillListDto(e.result);
			_staffSkillList = _staffSkillListDto.StaffSkillList;
		}
		
		/**
		 * 業務履歴データ取得失敗イベント
		 */
		public function onFault_getInformation(e: FaultEvent):void
		{
			trace("onFault_getInformation...");
			
			// エラーダイアログ表示
			Alert.show("業務履歴データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
			
			// ボタンを有効にする.
			setEnabledButton(true);
		}
		
		/**
		 * 社員一覧クリックイベント
		 */
		public function onClick_staffList(e:ListEvent):void
		{
			// 社員IDを更新する.
			_staffId = e.itemRenderer.data.staffId;
		}
		
		/**
		 * プロパティ変更時イベント
		 */
		private function propertyChangeHandler(e:PropertyChangeEvent):void
		{
			// 社員IDが変更されたかどうかを判定する.
			if( e.property == "_staffId" )
			{
				// 変更された社員IDを持っている社員を探索する.
				for each( var dto:SkillStaffDto in _staffList )
				{
					if(dto.staffId == _staffId)
					{
						// 社員詳細を更新する.
						_staffDetail = dto;
						
						// 社員リストの選択状態も更新する
						view.staffList.selectedItem = _staffDetail;
					}
				}
				
				// スキルシートリストを取得する.
				view.skillSheetService.getOperation("getStaffSkillList").send(_staffId);
			}
			// 社員詳細が変更されたかどうかを判定する.
			else if ( e.property == "_staffDetail" )
			{
				// 取得資格
				_authorizedLicence = _staffDetail.staffAuthorizedLicenceName;
				// 取得免許
				_otherLocence = _staffDetail.staffOtherLocenceName;
			}
			// スキルシートリストが変更されたかどうかを判定する
			else if ( e.property == "_staffSkillList" )
			{
				// 経験年数(制御系/業務系/保守)
				var experienceYearsDto:ExperienceYearsDto = _staffSkillListDto.experienceYearsDto;
				_control = experienceYearsDto.control;
				_open = experienceYearsDto.open;
				_maintenance = experienceYearsDto.maintenance;
			}
		}
		
		
		/** 画面 */
		public var _view:SkillSheetView;
		
		/**
		 * 画面を取得します.
		 */
		public function get view():SkillSheetView
		{
			if (_view == null)
			{
				_view = super.document as SkillSheetView;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします.
		 *
		 * @param view セットする画面
		 */
		public function set view(view:SkillSheetView):void
		{
			_view = view;
		}
	}
}