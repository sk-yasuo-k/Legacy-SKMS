package subApplications.personnelAffair.profile.logic
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
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import subApplications.personnelAffair.profile.dto.DisplayItemsShowDataDto;
	import subApplications.personnelAffair.profile.dto.DisplayItemsShowDto;
	import subApplications.personnelAffair.profile.dto.ProfileConfigDto;
	import subApplications.personnelAffair.profile.dto.ProfileDataDto;
	import subApplications.personnelAffair.profile.dto.ProfileDto;
	import subApplications.personnelAffair.profile.dto.TotalProfileResultDto;
	import subApplications.personnelAffair.profile.web.ProfileDetail;
	import subApplications.personnelAffair.profile.web.ProfileItemSelect;
	import subApplications.personnelAffair.profile.web.ProfileList;
	
	
	/**
	 * プロフィール一覧ロジッククラス
	 * 
	 * @author yoshinori-t
	 */
	public class ProfileListLogic extends Logic
	{
		/**
		 * プロフィール情報データ
		 */
		private var profileData:ProfileDataDto;
		
		/**
		 * プロフィール情報設定データ
		 */
		private var configData:ProfileConfigDto = new ProfileConfigDto();
		
		/**
		 * プロフィールリスト
		 */
		[Bindable]
		public var profileList:ArrayCollection;

		//追加 @auther maruta
		public var profileList2:ArrayCollection;
		
		/**
		 * プロフィール詳細画面用データ
		 */
		public var createProfileData:ProfileDto;		
		
		/**
		 * コンストラクタ
		 */
		public function ProfileListLogic()
		{
			super();
		}
		
		/**
		 * 画面生成完了イベント。
		 * 画面が呼び出されたとき最初に実行される。
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// 必要な変数をバインド
			BindingUtils.bindProperty(view.profileList, "dataProvider", this, "profileList");
			
			// プロフィールリストの取得
			view.profileService.getOperation("getProfileList").send();
			
			//　初期表示項目を取得する。
			view.displayItemsShowService.getOperation("getDisplayItemsShow").send(6);
		}
		
		/**
		 * 表示項目選択ボタン押下処理
		 */
		public function onClick_itemSelectButton(e:MouseEvent):void
		{
			// データ準備
			var obj:Object = new Object();
			obj.configData = configData;	// プロフィール情報設定データ
			
			// 表示項目選択画面の表示
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(ProfileItemSelect, view, obj);
			
			// 表示項目選択画面クローズ時イベントの登録
			pop.addEventListener(CloseEvent.CLOSE, onClose_profileItemSelect);
		}
		
		/**
		 * 表示項目選択画面クローズ時イベント
		 *
		 * @param e Closeイベント.
		 */
		protected function onClose_profileItemSelect(e:CloseEvent):void
		{
			// 表示項目選択画面でOKボタンを押下したとき.
			if ( e.detail == Alert.OK )
			{
				//追加 @auther maruta
				if(configData.retirestaff == true)
				{
					profileList = profileData.ProfileList;
				}else{
					profileList = profileList2;
				}
				// 一覧表示項目更新処理
				refreshListColumn();
				
				//追加 @auther okamoto-y
				//フッタ情報更新処理
				refreshfooter();
			}
		}
		
		//追加 @auther watanuki
		/**
		 * ダブルクリックで詳細を開く
		 * */
		public function onDoubleClick_Profile(e:Event):void
		{
			var obj:Object = new Object();	//変数定義
			var dto:ProfileDto = view.profileList.selectedItem as ProfileDto;
			
			createProfileData = ObjectUtil.copy(dto) as ProfileDto;	//詳細プロフィール取得
			obj.createProfileData = createProfileData;
			
			if(createProfileData){
				var pop:IFlexDisplayObject = PopUpWindow.openWindow(ProfileDetail, view, obj);
				
				//プロフィール詳細画面クローズ時イベントの登録
				pop.addEventListener(CloseEvent.CLOSE, onClose_profileDetail);
			}
		} 
		
		/**
		 * 詳細ボタン押下処理
		 */
		public function onClick_detailButton(e:MouseEvent):void
		{
			// データ準備
			var obj:Object = new Object();
			var dto:ProfileDto = view.profileList.selectedItem as ProfileDto;
			createProfileData = ObjectUtil.copy(dto) as ProfileDto;
			obj.createProfileData = createProfileData;
			
			if(dto == null){
				// エラーダイアログ表示
				Alert.show("社員が選択されていません。", "Error", Alert.OK, null,	null, null, Alert.OK);
			}else{	
				// プロフィール詳細画面の表示
				var pop:IFlexDisplayObject = PopUpWindow.openWindow(ProfileDetail, view, obj);
	
				// プロフィール詳細画面クローズ時イベントの登録
				pop.addEventListener(CloseEvent.CLOSE, onClose_profileDetail);
			}	
		}

		public function onClose_profileDetail(e:CloseEvent):void
		{
			//onCreationCompleteHandler(null);
			//↑を消して詳細Close後も選択した表示項目を維持
			//追加 @auther okamoto-y
			refreshListColumn();
		}
		
		/**
		 * プロフィールリスト取得成功イベント
		 */
		public function onResult_getProfileList(e: ResultEvent):void
		{
			// プロフィール情報データを更新する
			profileData = new ProfileDataDto(e.result);
			
			// プロフィールリストを更新する
			//profileList = profileData.ProfileList;
			
			//追加 @atuher maruta
			if(configData.retirestaff == true)
			{
				profileList = profileData.ProfileList;
				
			}else{
				profileList2 = new ArrayCollection();
				
				for(var i:int=0; i<profileData.ProfileList.length; i++)
				{
					var d:Object = profileData.ProfileList.getItemAt(i);
					
					if(d.retireDate == null)
					{
						profileList2.addItem(d);
					}
				}
				profileList = profileList2;			
			}
			
			//フッタ情報更新処理
			refreshfooter();
/*			
			// フッタ情報を更新する
			var total:TotalProfileResultDto = profileData.TotalProfileResult;
			view.averageAge.text = total.AverageAge.toString();		// 平均年齢
			view.bloodTypeA.text = total.CountA.toString();			// A型
			view.bloodTypeB.text = total.CountB.toString();			// B型
			view.bloodTypeO.text = total.CountO.toString();			// O型
			view.bloodTypeAB.text = total.CountAB.toString();		// AB型
			//追加 @auther okamoto
			view.bloodTypeUnknown.text = total.CountUnknown.toString(); //血液型不明
*/			
		}
		
		//追加 @auther okamoto-y
		/**
		 * フッタ情報更新
		 */
		public function refreshfooter():void
		{
			var total:TotalProfileResultDto = new TotalProfileResultDto();
			//退職者の表示非表示判別
			if(configData.retirestaff == true)
			{
				total = profileData.TotalProfileResult;
			}else{
				total = profileData.TotalProfileResult_NoRetire;
			}
			
			view.averageAge.text = total.AverageAge.toString();		// 平均年齢
			view.bloodTypeA.text = total.CountA.toString();			// A型
			view.bloodTypeB.text = total.CountB.toString();			// B型
			view.bloodTypeO.text = total.CountO.toString();			// O型
			view.bloodTypeAB.text = total.CountAB.toString();		// AB型
			view.bloodTypeUnknown.text = total.CountUnknown.toString(); //血液型不明
		}
		
		/**
		 * プロフィールデータ取得失敗イベント
		 */
		public function onFault_getInformation(e: FaultEvent):void
		{
			trace("onFault_getInformation...");
			
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}

		/**
		 * 初期表示項目取得成功イベント
		 */
		public function onResult_getDisplayItemsShow(e: ResultEvent):void
		{
			// 表示項目表示可否データを更新する
			var displayItemsShowData:DisplayItemsShowDataDto = new DisplayItemsShowDataDto(e.result);
			var displayItemsShow:DisplayItemsShowDto = displayItemsShowData.DisplayItemsShowData;
			
			configData.fullName = displayItemsShow.fullname;
			configData.staffId = displayItemsShow.staffId;
			configData.sexName = displayItemsShow.sexname;
			configData.birthday = displayItemsShow.birthday;
			configData.age = displayItemsShow.age;
			configData.bloodGroupName = displayItemsShow.bloodgroupname;
			configData.joinDate = displayItemsShow.joindate;
			configData.retireDate = displayItemsShow.retiredate;
			configData.departmentName = displayItemsShow.departmentname;
			configData.projectName = displayItemsShow.projectname;
			configData.committeeName = displayItemsShow.committeename;
			configData.extensionNumber = displayItemsShow.extensionnumber;
			configData.email = displayItemsShow.email;
			configData.homePhoneNo = displayItemsShow.homephoneno;
			configData.handyPhoneNo = displayItemsShow.handyphoneno;
			configData.postalCode = displayItemsShow.postalcode;
			configData.address1 = displayItemsShow.address1;
			configData.address2 = displayItemsShow.address2;
			configData.emergencyAddress = displayItemsShow.emergencyaddress;
			configData.legalDomicileName = displayItemsShow.legaldomicilename;
			configData.beforeExperienceYears = displayItemsShow.beforeexperienceyears;
			configData.serviceYears = displayItemsShow.serviceyears;
			configData.totalExperienceYears = displayItemsShow.totalexperienceyears;
			configData.academicBackground = displayItemsShow.academicBackground;
			configData.workStatusName = displayItemsShow.workstatusname;
			configData.securityCardNo = displayItemsShow.securitycardno;
			configData.yrpCardNo = displayItemsShow.yrpcardno;
			configData.insurancePolicySymbol = displayItemsShow.insurancepolicysymbol;
			configData.insurancePolicyNo = displayItemsShow.insurancepolicyno;
			configData.pensionPocketbookNo = displayItemsShow.pensionpocketbookno;
			configData.basicClassNo = displayItemsShow.basicclassno;
			configData.basicRankNo = displayItemsShow.basicrankno;
			configData.basicMonthlySum = displayItemsShow.basicmonthlysum;
			configData.managerialMonthlySum = displayItemsShow.managerialmonthlysum;
			configData.competentMonthlySum = displayItemsShow.competentmonthlysum;
			configData.technicalSkillMonthlySum = displayItemsShow.technicalskillmonthlysum;
			configData.informationPayName = displayItemsShow.informationPayName;
			configData.housingMonthlySum = displayItemsShow.housingmonthlysum;
			configData.departmentHead = displayItemsShow.departmenthead;
			configData.projectPosition = displayItemsShow.projectposition;
			configData.managerialPosition = displayItemsShow.managerialposition;
			
			// 一覧表示項目更新処理
			refreshListColumn();			
		}

		/**
		 * 初期表示項目取得失敗イベント
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
		 * 一覧表示項目更新処理
		 */
		private function refreshListColumn():void
		{
			// プロフィール情報設定データ変換テーブル
			var convert:ArrayCollection = new ArrayCollection([
				// id:dataField名,						visible:プロフィール情報設定データ
				{id:"fullName",						visible:configData.fullName},						// 氏名
				{id:"staffId",							visible:configData.staffId},						// 社員名
				{id:"sexName",							visible:configData.sexName},						// 性別
				{id:"birthday",						visible:configData.birthday},						// 生年月日
				{id:"age",								visible:configData.age},							// 年齢			
				{id:"bloodGroupName",					visible:configData.bloodGroupName},					// 血液型
				{id:"joinDate",						visible:configData.joinDate},						// 入社年月日
				{id:"retireDate",						visible:configData.retireDate},						// 退職年月日
				{id:"departmentName",					visible:configData.departmentName},					// 所属
				{id:"projectName",						visible:configData.projectName},					// 配属部署
				{id:"committeeName",					visible:configData.committeeName},					// 委員会
				{id:"extensionNumber",				visible:configData.extensionNumber},				// 内線番号
				{id:"email",							visible:configData.email},							// メールアドレ
				{id:"homePhoneNo",						visible:configData.homePhoneNo},					// 電話番号
				{id:"handyPhoneNo",					visible:configData.handyPhoneNo},					// 携帯番号
				{id:"postalCode",						visible:configData.postalCode},						// 郵便番号
				{id:"address1",						visible:configData.address1},						// 住所１
				{id:"address2",						visible:configData.address2},						// 住所２
				{id:"emergencyAddress",				visible:configData.emergencyAddress},				// 緊急連絡先
				{id:"legalDomicileName",				visible:configData.legalDomicileName},				// 本籍地
				{id:"beforeExperienceYears",			visible:configData.beforeExperienceYears},			// 入社前経験年
				{id:"serviceYears",					visible:configData.serviceYears},					// 勤続年数
				{id:"totalExperienceYears",			visible:configData.totalExperienceYears},			// 経験年数
				{id:"academicBackground",			    visible:configData.academicBackground},			    // 最終学歴				
				{id:"workStatusName",					visible:configData.workStatusName},					// 勤務状態
				{id:"securityCardNo",					visible:configData.securityCardNo},					// セキュリティ
				{id:"yrpCardNo",						visible:configData.yrpCardNo},						// YRPカード番号
				{id:"insurancePolicySymbol",			visible:configData.insurancePolicySymbol},			// 保険証記号
				{id:"insurancePolicyNo",				visible:configData.insurancePolicyNo},				// 保険証番号
				{id:"pensionPocketbookNo",			visible:configData.pensionPocketbookNo},			// 年金手帳番号
				{id:"basicClassNo",					visible:configData.basicClassNo},					// 資格 等級
				{id:"basicRankNo",						visible:configData.basicRankNo},					// 号
				{id:"basicMonthlySum",				visible:configData.basicMonthlySum},				// 基本給
				{id:"managerialMonthlySum",			visible:configData.managerialMonthlySum},			// 職務手当
				{id:"competentMonthlySum",			visible:configData.competentMonthlySum},			// 主務手当
				{id:"technicalSkillMonthlySum",		visible:configData.technicalSkillMonthlySum},		// 技能手当
				{id:"informationPayName",         	visible:configData.informationPayName},	            // 情報処理資格保有
				{id:"housingMonthlySum",				visible:configData.housingMonthlySum},				// 住宅補助手当
				{id:"departmentHead",				    visible:configData.departmentHead},					// 所属部長
				{id:"projectPosition",				visible:configData.projectPosition},				// 役職
				{id:"managerialPosition",				visible:configData.managerialPosition}				// 経営役職
			]);
			
			// プロフィールリストの列数分ループ
			var arr:Array = view.profileList.columns;
			for ( var i:int; i < arr.length; i++ )
			{
				arr[i].visible = false;		// 一旦非表示に設定
				
				// プロフィール情報設定データ変換テーブルの内容数分ループ
				for(var j:int = 0; j < convert.length; j++)
				{
					// dataField名の一致するプロフィール情報設定データの内容を反映
					if ( arr[i].dataField == convert[j].id )
					{
						arr[i].visible = convert[j].visible;
						break;
					}
				}
			}
		}

//		// 新入社員登録画面への遷移処理
//		public function onClick_staffEntryButton(e:MouseEvent):void
//		{
//			var nextUrl:String = "./subApplications/generalAffair/web/StaffEntry.swf";
//			
//			view.body.removeAllChildren();
//			view.body.loadModule(nextUrl);
//		}		
		
		/** 画面 */
		public var _view:ProfileList;
		
		/**
		 * 画面を取得します
		 */
		public function get view():ProfileList
		{
			if (_view == null) {
				_view = super.document as ProfileList;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします。
		 *
		 * @param view セットする画面
		 */
		public function set view(view:ProfileList):void
		{
			_view = view;
		}
	}
}
