package subApplications.personnelAffair.profile.logic
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import logic.Logic;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.personnelAffair.license.dto.MBasicClassListDto;
	import subApplications.personnelAffair.license.dto.MBasicRankListDto;
	import subApplications.personnelAffair.profile.dto.ProfileDto;
	import subApplications.personnelAffair.profile.web.ProfileEntry;

	/**
	 * プロフィール登録ロジッククラス
	 * 
	 * @author yoshinori-t
	 */
	public class ProfileEntryLogic extends Logic
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
		 * ファイル選択オブジェクト
		 */
		private var refSelectFiles:FileReference = new FileReference();
		
		/**
		 * 性別コンボボックスの値
		 */		
		public var sexLabel:ArrayCollection = new ArrayCollection([{label:"男", data:"1"}, {label:"女", data:"2"}]);
		
		/**
		 * 血液型コンボボックスの値
		 */
		//追加 @auther okamoto
		public var bloodGroupLabel:ArrayCollection = new ArrayCollection([{label:"A", data:"1"}, {label:"B", data:"2"}
																			,{label:"O", data:"3"}, {label:"AB", data:"4"}
																			,{label:"不明", data:"9"} ]);

		/**
		 * 等級コンボボックスの値
		 */		
		[Bindable] 
		public var _basicClass:ArrayCollection = new ArrayCollection();
		
		/**
		 * 号コンボボックスの値
		 */				
		[Bindable] 
		public var _basicRank:ArrayCollection = new ArrayCollection();

		/**
		 * カウンター
		 */						
		public var cnt:int = 0;
		
		/**
		 * コンストラクタ
		 */
		public function ProfileEntryLogic()
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
			view.staffImage.source          = createProfileData.staffImage;											// プロフィール画像の更新
			view.staffImage.load();
			view.firstName.text             = createProfileData.firstName;											//姓
			view.lastName.text              = createProfileData.lastName;											//名
			view.firstNameKana.text         = createProfileData.firstNameKana;                                      //姓(カナ)
			view.lastNameKana.text          = createProfileData.lastNameKana;                                       //名(カナ)
			view.birthday.text              = DateField.dateToString(createProfileData.birthday, "YYYY/MM/DD");	//生年月日
			view.extensionNumber.text       = createProfileData.extensionNumber;									//内線番号
			view.email.text                 = createProfileData.email;												//メールアドレス
			view.handyPhoneNo.text          = createProfileData.handyPhoneNo;										//携帯番号
			view.emergencyAddress.text      = createProfileData.emergencyAddress;									//緊急連絡先
			//性別
			BindingUtils.bindProperty(view.sexNameList, "dataProvider", this, "sexLabel");			
			view.sexNameList.selectedData        = createProfileData.sex.toString();
			//血液型
			BindingUtils.bindProperty(view.bloodGroupNameList, "dataProvider", this, "bloodGroupLabel");
			view.bloodGroupNameList.selectedData = createProfileData.bloodGroup.toString();
			
	    	// 等級マスタの取得
	    	view.staffEntryService.getOperation("getBasicClassPayList").send();
	    	// 基本給マスタの取得
	    	view.staffEntryService.getOperation("getBasicPayList").send();
			
			BindingUtils.bindProperty(view.basicClassNo, "dataProvider", this, "_basicClass");
			BindingUtils.bindProperty(view.basicRankNo, "dataProvider", this, "_basicRank");
			
			// 権限別表示変更処理
			modifyStatus();
		}

		/**
		 * 権限別表示変更処理
		 */
		public function modifyStatus():void
		{
			var status:Boolean = Application.application.indexLogic.loginStaff.isAuthorisationProfile();
			view.staffQualification.visible = status;
		}
		
		
		/**
		 * 写真更新押下処理
		 */
		public function onClick_updateStaffImageButton(e:MouseEvent):void
		{
			// リスナー登録(ファイル選択)
			refSelectFiles.addEventListener(Event.SELECT,onSelect_staffImage);
			
			var fileFilter:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
			
			// ファイル選択のダイアログを表示
			refSelectFiles.browse([fileFilter]);
		}
		
		/**
		 * 写真更新ボタン押下処理(ファイル選択後)
		 */
		private function onSelect_staffImage(e:Event):void
		{
			// リスナー登録(ファイル選択)の解除
			refSelectFiles.removeEventListener(Event.SELECT, onSelect_staffImage);
			
			// リスナー登録(ファイル読込)
			refSelectFiles.addEventListener(Event.COMPLETE, onLoadComplete_staffImage);
			
			// ファイル読込の実施
			refSelectFiles.load();
		}
		
		/**
		 * 写真更新ボタン押下処理(ファイル読込後)
		 */
		private function onLoadComplete_staffImage(e:Event):void
		{
			// リスナー登録(ファイル読込)の解除
			refSelectFiles.removeEventListener(Event.COMPLETE, onLoadComplete_staffImage);
			
			// バイナリデータとしてデータを取得
			var staffImageRaw:ByteArray = refSelectFiles.data;
			view.staffImage.source = staffImageRaw;
			view.staffImage.load();						
		}

		/**
		 * 更新ボタン押下処理
		 */
		public function onClick_updateProfileDataButton(e:MouseEvent):void
		{
			if(handyPhoneNoCheck()){
				Alert.show("更新してもよろしいですか？", "", 3, view, onResult_updateProfileDataButton);
			}else{
				Alert.show("携帯番号の入力が正しくありません。", "Error", Alert.OK, null, null, null, Alert.OK);
			}	
		}

		public function onResult_updateProfileDataButton(e:CloseEvent):void
		{
			if(e.detail == Alert.YES){
				// ログイン者ID
				var _loginStaffId:int = Application.application.indexLogic.loginStaff.staffId;
				// 更新プロフィールデータ
				var profileData:ProfileDto = new ProfileDto();
				profileData.staffId          = _staffId;
				profileData.staffImage       = view.staffImage.source as ByteArray;
				profileData.firstName        = view.firstName.text;
				profileData.firstNameKana    = view.firstNameKana.text;
				profileData.lastName         = view.lastName.text;
				profileData.lastNameKana     = view.lastNameKana.text;
				profileData.birthday         = DateField.stringToDate(view.birthday.text, "YYYY/MM/DD");
				profileData.extensionNumber  = view.extensionNumber.text;
				profileData.email            = view.email.text;
				profileData.handyPhoneNo     = view.handyPhoneNo.text;
				profileData.emergencyAddress = view.emergencyAddress.text;
				profileData.sex              = parseInt(view.sexNameList.selectedData);
				profileData.bloodGroup       = parseInt(view.bloodGroupNameList.selectedData);	
				profileData.basicClassNo     = parseInt(view.basicClassNo.selectedData);
				profileData.basicRankNo      = parseInt(view.basicRankNo.selectedData);
										
				view.profileService.getOperation("updateProfileData").send(profileData, _loginStaffId);
			}
		}		
		
		/**
		 * プロフィール更新成功イベント
		 */
		public function onResult_updateProfileData(e:ResultEvent):void
		{
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);	
		}
		
		/**
		 * プロフィール更新失敗イベント
		 */
		public function onFault_updateProfileData(e:FaultEvent):void
		{
			trace("onFault_updateProfile...");
			trace(e.message);
			// エラーダイアログ表示
			Alert.show("プロフィールの更新に失敗しました。", "Error",
						Alert.OK, null,
						null, null, Alert.OK);
		}
		
		/**
		 * 戻るボタン押下処理
		 */
		public function onClick_returnButton(e:MouseEvent):void
		{
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
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

		/**
		 * 携帯番号チェック処理
		 */
		public function handyPhoneNoCheck():Boolean
		{
			var str:Array = view.handyPhoneNo.text.split("-");
			
			if(str.length == 3){
				var handyPhoneNo1:String = str[0];
				var handyPhoneNo2:String = str[1];		
				var handyPhoneNo3:String = str[2];
				
				if(3 <= handyPhoneNo1.length && handyPhoneNo1.length <= 4
					 && handyPhoneNo2.length == 4 && handyPhoneNo3.length == 4){
					return true;
				}
				return false;
			}else if(str.length == 1){
				if(view.handyPhoneNo.text == ""){
					return true;
				}
				return false;
			}
			return false;
		}


		/**
		 * 等級マスタ取得成功
		 * 
		 * */
		public function onResult_showBasicClassPayList(e: ResultEvent):void
		{
			trace("onResult_showBasicClassPayList...");
			var basicClassList:MBasicClassListDto = new MBasicClassListDto(e.result);
			_basicClass = basicClassList.MBasicClassList;
			view.basicClassNo.selectedData = createProfileData.basicClassNo.toString();
		}
		
		/**
		 * 基本給マスタ取得成功
		 * 
		 * */
		public function onResult_showBasicPayList(e: ResultEvent):void
		{
			trace("onResult_showBasicPayList...");
			var basicPayList:MBasicRankListDto = new MBasicRankListDto(e.result);
			_basicRank = basicPayList.MBasicRankList;
			_basicRank.filterFunction = rankNoFilter;
			_basicRank.refresh();
			view.basicRankNo.selectedData= createProfileData.basicRankNo.toString();
		}

		/**
		 * 等級リスト変更処理
		 * 
		 */
		public function onChange_BasicClassList(e:Event):void
		{
			_basicRank.refresh();
			view.basicRankNo.selectedIndex = 0;
		}

		/**
		 * 号リストフィルター処理
		 * 
		 * */
		public function rankNoFilter(basicPay:Object):Boolean
		{
			if(view.basicClassNo.selectedData == basicPay.classNo){
				return true;
			}
			return false;
		}		 
		
		/**
		 * 等級マスタ取得失敗
		 * */
		 public function onFault_remoteBasicClassPayList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("等級マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }

		/**
		 * 基本給マスタ取得失敗
		 * */
		 public function onFault_remoteBasicPayList(e: FaultEvent):void
		 {
		 	trace("DB Error");
		 	trace(e.message);
		 	Alert.show("基本給マスタ取得失敗","",Alert.OK | Alert.CANCEL,null,null,null,Alert.CANCEL);
		 }


//		/**
//		 * 基本給マスタ情報取得成功イベント
//		 */
//		public function onResult_getBasicPayDto(e:ResultEvent):void
//		{
//			var basicPayDataDto:BasicPayDataDto = new BasicPayDataDto(e.result);
//			var basicPayList:ArrayCollection = basicPayDataDto.BasicPayList;
//			basicClassList = basicPayList;
//			view.basicClassNo.selectedData = createProfileData.basicClassNo.toString();
//			setBasicRankList(view.basicClassNo.selectedItem);
//		}	
//
//
//		/**
//		 * 号リスト設定処理
//		 * 
//		 */
//		public function setBasicRankList(basicClass:Object):void
//		{
//			for each(var basicRankListData:BasicPayDataListDto in basicClassList){
//				if(basicRankListData.classData == basicClass.classData){
//					basicRankList = basicRankListData.rankData;
//				}
//			}
//			
//			// 画面作成時処理
//			if(cnt == 0){
//				// 号コンボボックスに初期値があれば設定
//				if(createProfileData.basicRankNo != 0){
//					view.basicRankNo.selectedData= createProfileData.basicRankNo.toString();
//				}	
//				cnt = cnt + 1;
//			}
//		}
//
//
//		/**
//		 * 基本給マスタ情報取得失敗イベント
//		 */
//		public function onFault_getBasicPayDto(e:FaultEvent):void
//		{
//			trace("onFault_getBasicPayDto...");
//			trace(e.message);
//			// エラーダイアログ表示
//			Alert.show("データの取得に失敗しました。", "Error", Alert.OK, null,	null, null, Alert.OK);			
//		}

		
		/** 画面 */
		public var _view:ProfileEntry;
		
		/**
		 * 画面を取得します
		 */
		public function get view():ProfileEntry
		{
			if (_view == null) {
				_view = super.document as ProfileEntry;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします。
		 *
		 * @param view セットする画面
		 */
		public function set view(view:ProfileEntry):void
		{
			_view = view;
		}
	}
}