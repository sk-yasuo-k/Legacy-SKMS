package subApplications.personnelAffair.authority.logic
{
	import enum.AuthorityId;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.personnelAffair.authority.dto.AuthorityProfileItemSelectDto;
	import subApplications.personnelAffair.authority.web.AuthorityProfileItemSelect;
	import subApplications.personnelAffair.profile.dto.DisplayItemsShowDto;
	
	public class AuthorityProfileItemSelectLogic extends Logic
	{
		/**
		 * 役職リストの値
		 */		
		public var positionList:ArrayCollection = new ArrayCollection([{label:"役員", data:AuthorityId.OFFICERS}, {label:"総務部長", data:AuthorityId.GENERAL_AFFAIRS_MANAGER}
																			, {label:"PM", data:AuthorityId.PM},{label:"PL", data:AuthorityId.PL}, {label:"一般社員", data:AuthorityId.STAFF} ]);

		/**
		 * 表示項目リストの値
		 */
		[Bindable] 		
		public var trueList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 非表示項目リストの値
		 */	
		[Bindable]	
		public var falseList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 表示可否リストの値
		 */	
		public var authorityProfileItemList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 登録用リストの値
		 */			
		public var itemSelectListData:ArrayCollection = new ArrayCollection();
		
		/**
		 * DB登録リストDtoの値
		 */	
		public var authorityProfileItemData:DisplayItemsShowDto = new DisplayItemsShowDto();

		/**
		 *登録用 DB登録リストDtoの値
		 */	
		public var listData:DisplayItemsShowDto = new DisplayItemsShowDto();
		
		/**
		 * 選択中の役職IDの値
		 */			
		public var authorityId:int;

		/**
		 * 選択中の役職名の値
		 */			
		public var authorityName:String;
		
		/**
		 * コンストラクタ
		 */
		public function AuthorityProfileItemSelectLogic()
		{
			super();
		}

		
		/**
		 * 画面生成完了イベント。
		 * 画面が呼び出されたとき最初に実行される。
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{	
			// 役職リストに値を設定する。
			BindingUtils.bindProperty(view.positionList, "dataProvider", this, "positionList");
			
			// 表示項目リストに双方向バインドを設定する。
			BindingUtils.bindProperty(view.trueList, "dataProvider", this, "trueList");	
			BindingUtils.bindProperty(this, "trueList", view.trueList, "dataProvider");			

			// 非表示項目リストに双方向バインドを設定する。
			BindingUtils.bindProperty(view.falseList, "dataProvider", this, "falseList");
			BindingUtils.bindProperty(this, "falseList", view.falseList, "dataProvider");
		}		


		/**
		 * リストにデータをセットする
		 */
		public function listDataSet():void
		{
			trueList = new ArrayCollection();
			falseList = new ArrayCollection();			
			for(var i:int; i < authorityProfileItemList.length; i++){
				if(authorityProfileItemList[i].bool){
					trueList.addItem(authorityProfileItemList[i]);
				}else if(!(authorityProfileItemList[i].bool)){
					falseList.addItem(authorityProfileItemList[i]);
				}
			}
		}


		/**
		 * 役職一覧を選択すると実行
		 */
		public function onClick_positionList(e:ListEvent):void
		{
			authorityId = e.itemRenderer.data.data;
			authorityName =  e.itemRenderer.data.label;
			
			// 表示項目表示可否データを取得する。
			view.displayItemsShowService.getOperation("getDisplayItemsShow").send(authorityId);
			// データ変更時の処理
			setModifiedStatus(false);
		}


		/**
		 * 取り消しボタン押下処理
		 */
		public function onClick_cancel(e:MouseEvent):void
		{
			listDataSet();
			// データ変更時の処理
			setModifiedStatus(false);
		}

		/**
		 * 適用ボタン押下処理
		 */
		public function onClick_apply(e:MouseEvent):void
		{			
		    if(applyDtoGet()){
		    	Alert.show("更新してもよろしいですか？", "", 3, view, onResult_applyButton);
			}else{
				Alert.show("データが変更されていません。", "", Alert.OK, view, null);
			}			
		}
		
		
		/**
		 * 設定更新処理
		 */
		public function onResult_applyButton(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				view.displayItemsShowService.getOperation("updatelistData").send(listData);
			}
		}

		/**
		 * 更新処理成功イベント
		 */
		public function onResult_updatelistData(e: ResultEvent):void
		{
			authorityProfileItemList = itemSelectListData;
			listDataSet();
			// データ変更時の処理
			setModifiedStatus(false);			
		}

		/**
		 * 更新処理失敗イベント
		 */
		public function onFault_updatelistData(e: FaultEvent):void
		{
			trace("onFault_getDisplayItemsShow...");
			trace(e.message);
			// エラーダイアログ表示
			Alert.show("データの保存に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);			
		}	
		
		/**
		 * 登録用リスト作成処理
		 */
		public function applyDtoGet():Boolean
		{
			listData = new DisplayItemsShowDto();
			var itemSelectList:AuthorityProfileItemSelectDto = new AuthorityProfileItemSelectDto(listData);
			itemSelectListData = itemSelectList.displayItemsList;
			for(var i:int = 0; i < itemSelectListData.length; i++){
				for(var j:int = 0; j < trueList.length; j++){
					if(itemSelectListData[i].label == trueList[j].label){
						itemSelectListData[i].bool = true;
					}
				}
			}
		
			listData.listChoicesId = authorityId;
			listData.positionName = authorityName;
			listData.staffId                     = itemSelectListData[0].bool;	// 社員コード
			listData.fullname                    = itemSelectListData[1].bool;	// 氏名
			listData.sexname                     = itemSelectListData[2].bool;	// 性別
			listData.birthday                    = itemSelectListData[3].bool;	// 生年月日
			listData.age                         = itemSelectListData[4].bool;	// 年齢
			listData.bloodgroupname              = itemSelectListData[5].bool;	// 血液型
			listData.postalcode                  = itemSelectListData[6].bool;	// 郵便番号
			listData.address1                    = itemSelectListData[7].bool;	// 住所１
			listData.address2                    = itemSelectListData[8].bool;	// 住所２	
			listData.homephoneno                 = itemSelectListData[9].bool;	// 電話番号
			listData.handyphoneno                = itemSelectListData[10].bool;	// 携帯番号１					
			listData.joindate                    = itemSelectListData[11].bool;	// 入社年月日
			listData.retiredate                  = itemSelectListData[12].bool;	// 退職年月日
			listData.departmentname              = itemSelectListData[13].bool;	// 所属
			listData.projectname                 = itemSelectListData[14].bool;	// 配属部署
			listData.committeename               = itemSelectListData[15].bool;	// 委員会
			listData.extensionnumber             = itemSelectListData[16].bool;	// 内線番号
			listData.email                       = itemSelectListData[17].bool;	// メールアドレス
			listData.emergencyaddress            = itemSelectListData[18].bool;	// 緊急連絡先
			listData.legaldomicilename           = itemSelectListData[19].bool;	// 本籍地
			listData.beforeexperienceyears       = itemSelectListData[20].bool;	// 入社前経験年数
			listData.serviceyears                = itemSelectListData[21].bool;	// 勤続年数
			listData.totalexperienceyears        = itemSelectListData[22].bool;	// 経験年数
			listData.academicBackground          = itemSelectListData[23].bool;	// 最終学歴
			listData.workstatusname              = itemSelectListData[24].bool;	// 勤務状態
			listData.securitycardno              = itemSelectListData[25].bool;	// セキュリティカード番号
			listData.yrpcardno                   = itemSelectListData[26].bool;	// YRPカード番号
			listData.insurancepolicysymbol       = itemSelectListData[27].bool;	// 保険証記号
			listData.insurancepolicyno           = itemSelectListData[28].bool;	// 保険証番号
			listData.pensionpocketbookno         = itemSelectListData[29].bool;	// 年金手帳番号
			listData.basicclassno                = itemSelectListData[30].bool;	// 資格 等級
			listData.basicrankno                 = itemSelectListData[31].bool;	// 号
			listData.basicmonthlysum             = itemSelectListData[32].bool;	// 基本給
			listData.managerialmonthlysum        = itemSelectListData[33].bool;	// 職務手当
			listData.competentmonthlysum         = itemSelectListData[34].bool;	// 主務手当
			listData.technicalskillmonthlysum    = itemSelectListData[35].bool;	// 技能手当
			listData.informationPayName          = itemSelectListData[36].bool;	// 情報処理資格保有
			listData.housingmonthlysum           = itemSelectListData[37].bool;	// 住宅補助手当
			listData.projectposition             = itemSelectListData[38].bool;	// 役職
			listData.departmenthead              = itemSelectListData[39].bool;	// 所属部長
			listData.managerialposition          = itemSelectListData[40].bool;	// 経営役職
			
			return listDataCheck(itemSelectListData);
		}

		/**
		 * リストデータ変更チェック処理
		 */
		public function listDataCheck(itemSelectListData:ArrayCollection):Boolean
		{
			for(var i:int = 0; i < itemSelectListData.length; i++){
				if(itemSelectListData[i].bool != authorityProfileItemList[i].bool){
					return true;
				}
			}
			return false;
		}


		/**
		 * >ボタン押下処理
		 */
		public function onClick_toFalse(e:MouseEvent):void
		{
			var selectData:Array = view.trueList.selectedItems;
			if(selectData.length != 0){
				for(var i:int = selectData.length-1; i >= 0; i--){
					falseList.addItem(selectData[i]);
					for(var j:int = 0; j < trueList.length; j++){
						if(trueList[j] == selectData[i]){
							trueList.removeItemAt(j);
						}
					}
				}
				// データ変更時の処理
				setModifiedStatus(true);
			}	
		}
		
		/**
		 * <ボタン押下処理
		 */
		public function onClick_toTrue(e:MouseEvent):void
		{
			var selectData:Array = view.falseList.selectedItems;
			if(selectData.length != 0){
				for(var i:int = selectData.length-1; i >= 0; i--){
					trueList.addItem(selectData[i]);
					for(var j:int = 0; j < falseList.length; j++){
						if(falseList[j] == selectData[i]){
							falseList.removeItemAt(j);
						}
					}	
				}
				// データ変更時の処理
				setModifiedStatus(true);
			}
		}


		/**
		 * 表示項目表示可否データ取得成功イベント
		 */
		public function onResult_getDisplayItemsShow(e: ResultEvent):void
		{
			// 表示項目表示可否データを更新する
			authorityProfileItemData = e.result as DisplayItemsShowDto;
			var authorityProfileItemSelectDto:AuthorityProfileItemSelectDto = new AuthorityProfileItemSelectDto(authorityProfileItemData);
			authorityProfileItemList = authorityProfileItemSelectDto.AuthorityProfileItemSelectData;
			
			listDataSet();
		}

		/**
		 * 表示項目表示可否データ取得失敗イベント
		 */
		public function onFault_getDisplayItemsShow(e: FaultEvent):void
		{
			trace("onFault_getDisplayItemsShow...");
			trace(e.message);
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}


		/**
		 * 表示項目リスト DragEnter イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_trueListChoices(e:DragEvent):void
		{	
			// コピー操作不可
			if(e.dragInitiator == view.trueList){
				e.ctrlKey = false;
			}													
		}
			
		/**
		 * 非表示項目リスト DragEnter イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragEnter_falseListChoices(e:DragEvent):void
		{
			// コピー操作不可
			if(e.dragInitiator == view.falseList){
				e.ctrlKey = false;
			}		
		}
		
		/**
		 * リスト DragOver イベント.
		 *
		 * @param e DragEvent
		 */
		public function onDragOver_listChoices(e:DragEvent):void
		{
			// コピー操作不可
			e.ctrlKey = false;
		}

		/**
		 * リスト DragDrop イベント.
		 *
		 * @param e ListEvent
		 */
		public function onDragDrop_listChoices(e:Event):void
		{
			// データ変更時の処理
			setModifiedStatus(true);
		}

		/**
		 * データ変更状態設定.
		 *
		 */
		private function setModifiedStatus(modifiedStatus:Boolean):void
		{
			// 「適用する」ボタン、「取り消し」ボタンの有効無効状態セット
			view.cancel.enabled = modifiedStatus;
			view.apply.enabled = modifiedStatus;
		}
		
		
		/** 画面 */
		public var _view:AuthorityProfileItemSelect;
		
		/**
		 * 画面を取得します
		 */
		public function get view():AuthorityProfileItemSelect
		{
			if (_view == null) {
				_view = super.document as AuthorityProfileItemSelect;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします。
		 *
		 * @param view セットする画面
		 */
		public function set view(view:AuthorityProfileItemSelect):void
		{
			_view = view;
		}
	}
}