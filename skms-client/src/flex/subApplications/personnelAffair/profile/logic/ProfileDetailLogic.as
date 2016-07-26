package subApplications.personnelAffair.profile.logic
{
	import components.PopUpWindow;
	
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import subApplications.personnelAffair.profile.dto.ProfileDataDto;
	import subApplications.personnelAffair.profile.dto.ProfileDetailDataDto;
	import subApplications.personnelAffair.profile.dto.ProfileDetailDto;
	import subApplications.personnelAffair.profile.dto.ProfileDto;
	import subApplications.personnelAffair.profile.web.ProfileDetail;
	import subApplications.personnelAffair.profile.web.ProfileEntry;

	/**
	 * プロフィール詳細ロジッククラス
	 * 
	 * @author yoshinori-t
	 */
	public class ProfileDetailLogic extends Logic
	{
		
		/**
		 * プロフィール詳細画面用データ
		 */
		public var createProfileData:ProfileDto;		
		
		/**
		 * 社員ID
		 */
		public var _staffId:int;

		/**
		 * 姓
		 */
		[Bindable]
		public var _firstName:String;
		
		/**
		 * 名
		 */
		[Bindable] 
		public var _lastName:String;

		/**
		 * 性別
		 */
		[Bindable] 
		public var _sexName:String;

		/**
		 * 血液型
		 */
		[Bindable] 
		public var _bloodGroupName:String;
		
		/**
		 * 生年月日
		 */
		[Bindable] 
		public var _birthday:String;
		
		/**
		 * 年齢
		 */
		[Bindable] 
		public var _age:String;				

		/**
		 * 内線番号
		 */
		[Bindable] 
		public var _extensionNumber:String;				

		/**
		 * メールアドレス
		 */
		[Bindable] 
		public var _email:String;	

		/**
		 * 携帯番号
		 */
		[Bindable] 
		public var _handyPhoneNo:String;

		/**
		 * 緊急連絡先
		 */
		[Bindable] 
		public var _emergencyAddress:String;
		
		/**
		 * 等級
		 */
		[Bindable] 
		public var _basicClassNo:String;		
		
		/**
		 * 号
		 */
		[Bindable] 
		public var _basicRankNo:String;		
		
		/**
		 * プロフィール詳細データ
		 */
		public var profileDetailDto:ProfileDetailDto;

		/**
		 * コンストラクタ
		 */
		public function ProfileDetailLogic()
		{
			super();
		}
		
		/**
		 * 画面生成完了イベント。
		 * 画面が呼び出されたとき最初に実行される。
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// 社員情報の取得	
			createProfileData = view.data.createProfileData;
			// 社員IDの更新
			_staffId = createProfileData.staffId;
			// 初期データを格納
			profileDataSet(createProfileData);
			view.joinDate.text              = DateField.dateToString(createProfileData.joinDate, "YYYY/MM/DD");	//入社年月日
			view.serviceYears.text          = createProfileData.serviceYears.toString();							//勤続年数
			view.beforeExperienceYears.text = createProfileData.beforeExperienceYears.toString();					//入社前経験年数
			view.totalExperienceYears.text  = createProfileData.totalExperienceYears.toString();					//経験年数
			view.departmentName.text        = createProfileData.departmentName;										//部署
			view.projectName.text           = createProfileData.projectName;										//配属先
			view.committeeName.text         = createProfileData.committeeName;										//委員会
			view.homePhoneNo.text           = createProfileData.homePhoneNo;										//電話番号
			view.postalCode.text            = createProfileData.postalCode;											//郵便番号
			view.address1.text              = createProfileData.address1;											//住所1
			view.address2.text              = createProfileData.address2;											//住所2
			view.legalDomicileName.text     = createProfileData.legalDomicileName;									//本籍地
			view.associateStaff.text        = createProfileData.associateStaff;										//連絡のとりやすい社員

	    	BindingUtils.bindProperty(view.firstName, "text", this, "_firstName");					//姓
	 	    BindingUtils.bindProperty(view.lastName, "text", this, "_lastName");   					//名
	    	BindingUtils.bindProperty(view.sexName, "text", this, "_sexName");						//性別
	    	BindingUtils.bindProperty(view.bloodGroupName, "text", this, "_bloodGroupName");			//血液型
	    	BindingUtils.bindProperty(view.birthday, "text", this, "_birthday");						//生年月日
	 	    BindingUtils.bindProperty(view.age, "text", this, "_age");   								//年齢
	    	BindingUtils.bindProperty(view.extensionNumber, "text", this, "_extensionNumber");		//内線番号
	    	BindingUtils.bindProperty(view.email, "text", this, "_email");		    				//メールアドレス
	    	BindingUtils.bindProperty(view.handyPhoneNo, "text", this, "_handyPhoneNo");				//携帯番号
	    	BindingUtils.bindProperty(view.emergencyAddress, "text", this, "_emergencyAddress");	//緊急連絡先
	    	BindingUtils.bindProperty(view.basicClassNo, "text", this, "_basicClassNo");				//等級
	    	BindingUtils.bindProperty(view.basicRankNo, "text", this, "_basicRankNo");				//号 		    	
			
			// プロフィール詳細取得
			profileDetailData();
			// 等級・号表示有効/無効
			view.staffQualification.visible = modifyButtonStatus();
		}
		
		/**
		 * 更新ボタン有効/無効
		 */
		public function modifyButtonStatus():Boolean
		{
			var staffId:int = Application.application.indexLogic.loginStaff.staffId;
			var button:Boolean = Application.application.indexLogic.loginStaff.isAuthorisationProfile();
			if(_staffId != staffId){
				return button;
			}else{
				return true;
			}
		}

		/**
		 * バインドデータ設定
		 */
		public function profileDataSet(createProfileData:ProfileDto):void
		{
			_firstName        = createProfileData.firstName;										//姓
			_lastName         = createProfileData.lastName;											//名
			_sexName          = createProfileData.sexName;											//性別
			_bloodGroupName   = createProfileData.bloodGroupName;									//血液型
			_birthday         = DateField.dateToString(createProfileData.birthday, "YYYY/MM/DD");	//生年月日
			_age              = createProfileData.age.toString();									//年齢
			_extensionNumber  = createProfileData.extensionNumber;									//内線番号
			_email            = createProfileData.email;											//メールアドレス
			if(createProfileData.handyPhoneNo == "--"){
				createProfileData.handyPhoneNo = "";
			}
			_handyPhoneNo     = createProfileData.handyPhoneNo;										//携帯番号
			_emergencyAddress = createProfileData.emergencyAddress;									//緊急連絡先
			_basicClassNo     = createProfileData.basicClassNo.toString();							//等級
			_basicRankNo      = createProfileData.basicRankNo.toString();							//号
		}

		/**
		 * プロフィール詳細取得メソッド
		 */
		public function profileDetailData():void
		{
			// プロフィール詳細取得
			view.profileService.getOperation("getProfileDetail").send(_staffId);
		}
		
		/**
		 * プロフィール詳細取得成功イベント
		 */
		public function onResult_getProfileDetail(e:ResultEvent):void
		{
			var profileDetailDataDto:ProfileDetailDataDto = new ProfileDetailDataDto(e.result);
			profileDetailDto = profileDetailDataDto.ProfileDetailData;
			// 初期データを格納
			view.staffImage.source = profileDetailDto.staffImage;						// プロフィール画像の更新
			view.staffImage.load();
			
			view.workPlaseName.text = profileDetailDto.workPlaseName;					//所属
			
			view.licenceList.dataProvider = profileDetailDto.mStaffAuthorizedLicence;	//技術関連資格リスト
			view.otherLicenceList.dataProvider = profileDetailDto.mStaffOtherLocence;	//その他の資格リスト
			view.seminarParticipant.dataProvider = profileDetailDto.seminarParticipant;	//セミナー受講履歴
			// 更新ボタン有効/無効
			view.modifyButton.enabled = modifyButtonStatus();
		}
		
		/**
		 * 更新ボタン押下処理
		 */
		public function onClick_modifyButton(e:MouseEvent):void
		{
			// データ準備
			var obj:Object = new Object();
			var data:ProfileDto = createProfileData;
			
			data.staffImage = profileDetailDto.staffImage;
			
			createProfileData = ObjectUtil.copy(data) as ProfileDto;
			obj.createProfileData = createProfileData;

			
			// 表示項目選択画面の表示
			var pop:IFlexDisplayObject = PopUpWindow.openWindow(ProfileEntry, view, obj);
			///closeイベントを監視する.
			pop.addEventListener(CloseEvent.CLOSE, onProfileEntryPopUpClose);				
		}

		/**
		 * 更新されたデータを表示
		 */
		public function onProfileEntryPopUpClose(e:CloseEvent):void
		{
			if(e.detail == Alert.OK){
				// プロフィールリストの取得
				view.profileService.getOperation("getProfileData").send(_staffId);
				
				// プロフィール詳細取得
				profileDetailData();					
			}
		}

		/**
		 * プロフィール取得成功イベント
		 */
		public function onResult_getProfileData(e:ResultEvent):void
		{
			var profileDataDto:ProfileDataDto = new ProfileDataDto(e.result);
			createProfileData = profileDataDto.ProfileData;
			profileDataSet(createProfileData);
		}		
		
		/**
		 * 戻るボタン押下処理
		 */
		public function onClick_returnButton(e:MouseEvent):void
		{
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);
		}
		
		/**
		 * ポップアップクローズ処理
		 * 登録やキャンセルボタン以外でのクローズ時に使用
		 */
		public function onClose(e:CloseEvent):void
		{
			// 画面のクローズを行う
			PopUpManager.removePopUp(view);
		}
		
		/**
		 * プロフィールデータ取得失敗イベント
		 */
		public function onFault_getProfileDetail(e:FaultEvent):void
		{
			trace("onFault_getInformation...");
			trace(e.message);
			// エラーダイアログ表示
			Alert.show("データの取得に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}
		
		
		/** 画面 */
		public var _view:ProfileDetail;
		
		/**
		 * 画面を取得します
		 */
		public function get view():ProfileDetail
		{
			if (_view == null) {
				_view = super.document as ProfileDetail;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします。
		 *
		 * @param view セットする画面
		 */
		public function set view(view:ProfileDetail):void
		{
			_view = view;
		}
	}
}