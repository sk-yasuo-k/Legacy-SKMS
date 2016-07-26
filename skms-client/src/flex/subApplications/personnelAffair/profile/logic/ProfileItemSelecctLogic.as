package subApplications.personnelAffair.profile.logic
{
	import enum.AuthorityId;
	
	import flash.events.MouseEvent;
	
	import logic.Logic;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import subApplications.personnelAffair.profile.dto.DisplayItemsShowDataDto;
	import subApplications.personnelAffair.profile.dto.DisplayItemsShowDto;
	import subApplications.personnelAffair.profile.dto.ProfileConfigDto;
	import subApplications.personnelAffair.profile.web.ProfileItemSelect;
	
	
	/**
	 * プロフィール一覧表示項目選択ロジッククラス
	 * 
	 * @author yoshinori-t
	 */
	public class ProfileItemSelecctLogic extends Logic
	{
		/**
		 * 権限ID
		 */
		private var authorityId:int = Application.application.indexLogic.loginStaff.isDisplayItemsShow();
		
		/**
		 * コンストラクタ
		 */
		public function ProfileItemSelecctLogic()
		{
			super();
		}
		
		/**
		 * 画面生成完了イベント。
		 * 画面が呼び出されたとき最初に実行される。
		 */
		override protected function onCreationCompleteHandler(e:FlexEvent):void
		{
			// プロフィール情報設定データの初期設定
			setProperty();

			//　保存ボタン表示可否
			if(authorityId == AuthorityId.OFFICERS || authorityId == AuthorityId.GENERAL_AFFAIRS_MANAGER){
				view.storage.visible = true;
			}	
			
			//　表示項目表示可否データを取得する。
			view.displayItemsShowService.getOperation("getDisplayItemsShow").send(authorityId);
		}
		
		/**
		 * プロフィール情報設定データの初期設定
		 */
		private function setProperty():void
		{
			// プロフィール情報設定データが設定されているかを判定する
			if (view.data && view.data.configData)
			{
				var configData:ProfileConfigDto = view.data.configData;
				
				// 画面データの設定
				view.staffId.selected						= configData.staffId;						// 社員コード
				view.fullname.selected						= configData.fullName;						// 氏名				
				view.sexName.selected						= configData.sexName;						// 性別
				view.birthday.selected						= configData.birthday;						// 生年月日
				view.age.selected						    = configData.age;						    // 年齢
				view.bloodGroupName.selected				= configData.bloodGroupName;				// 血液型
				view.joinDate.selected						= configData.joinDate;						// 入社年月日
				view.retireDate.selected					= configData.retireDate;					// 退職年月日
				view.departmentName.selected				= configData.departmentName;				// 所属
				view.projectName.selected					= configData.projectName;					// 配属部署
				view.committeeName.selected					= configData.committeeName;					// 委員会
				view.extensionNumber.selected				= configData.extensionNumber;				// 内線番号
				view.email.selected							= configData.email;							// メールアドレス
				view.homePhoneNo.selected					= configData.homePhoneNo;					// 電話番号
				view.handyPhoneNo.selected					= configData.handyPhoneNo;					// 携帯番号１
				view.postalCode.selected					= configData.postalCode;					// 郵便番号
				view.address1.selected						= configData.address1;						// 住所１
				view.address2.selected						= configData.address2;						// 住所２
				view.emergencyAddress.selected				= configData.emergencyAddress;				// 緊急連絡先
				view.legalDomicileName.selected				= configData.legalDomicileName;				// 本籍地
				view.beforeExperienceYears.selected			= configData.beforeExperienceYears;			// 入社前経験年数
				view.serviceYears.selected					= configData.serviceYears;					// 勤続年数
				view.totalExperienceYears.selected			= configData.totalExperienceYears;			// 経験年数
				view.academicBackground.selected			= configData.academicBackground;			// 最終学歴
				view.workStatusName.selected				= configData.workStatusName;				// 勤務状態
				view.securityCardNo.selected				= configData.securityCardNo;				// セキュリティカード番号
				view.yrpCardNo.selected						= configData.yrpCardNo;						// YRPカード番号
				view.insurancePolicySymbol.selected			= configData.insurancePolicySymbol;			// 保険証記号
				view.insurancePolicyNo.selected				= configData.insurancePolicyNo;				// 保険証番号
				view.pensionPocketbookNo.selected			= configData.pensionPocketbookNo;			// 年金手帳番号
				view.basicClassNo.selected			    	= configData.basicClassNo;			    	// 資格 等級
				view.basicRankNo.selected					= configData.basicRankNo;					// 号
				view.basicMonthlySum.selected				= configData.basicMonthlySum;				// 基本給
				view.managerialMonthlySum.selected			= configData.managerialMonthlySum;			// 職務手当
				view.competentMonthlySum.selected			= configData.competentMonthlySum;			// 主務手当
				view.technicalSkillMonthlySum.selected		= configData.technicalSkillMonthlySum;		// 技能手当
				view.informationPayName.selected			= configData.informationPayName;			// 情報処理資格保有
				view.housingMonthlySum.selected				= configData.housingMonthlySum;				// 住宅補助手当
				view.departmentHead.selected                = configData.departmentHead;				// 所属部長
				view.projectPosition.selected               = configData.projectPosition;               // 役職
				view.managerialPosition.selected            = configData.managerialPosition;            // 経営役職		
				//追加 @auther maruta
				view.retirestaff.selected					= configData.retirestaff;					// 退職者
			}
		}
		
		/**
		 * プロフィール情報設定データの更新処理
		 */
		private function updateProperty():void
		{
			// プロフィール情報設定データが設定されているかを判定する
			if (view.data && view.data.configData)
			{
				var configData:ProfileConfigDto = view.data.configData;
				
				// 画面で設定したデータをプロフィール情報設定データに設定する
				configData.staffId						= view.staffId.selected;						// 社員コード
				configData.fullName						= view.fullname.selected;						// 氏名
				configData.sexName						= view.sexName.selected;						// 性別
				configData.birthday						= view.birthday.selected;						// 生年月日
				configData.age					    	= view.age.selected;				    		// 年齢
				configData.bloodGroupName				= view.bloodGroupName.selected;					// 血液型
				configData.joinDate						= view.joinDate.selected;						// 入社年月日
				configData.retireDate					= view.retireDate.selected;						// 退職年月日
				configData.departmentName				= view.departmentName.selected;					// 所属
				configData.projectName					= view.projectName.selected;					// 配属部署
				configData.committeeName				= view.committeeName.selected;					// 委員会
				configData.extensionNumber				= view.extensionNumber.selected;				// 内線番号
				configData.email						= view.email.selected;							// メールアドレス
				configData.homePhoneNo					= view.homePhoneNo.selected;					// 電話番号
				configData.handyPhoneNo					= view.handyPhoneNo.selected;					// 携帯番号１
				configData.postalCode					= view.postalCode.selected;						// 郵便番号
				configData.address1						= view.address1.selected;						// 住所１
				configData.address2						= view.address2.selected;						// 住所２
				configData.emergencyAddress				= view.emergencyAddress.selected;				// 緊急連絡先
				configData.legalDomicileName			= view.legalDomicileName.selected;				// 本籍地
				configData.beforeExperienceYears		= view.beforeExperienceYears.selected;			// 入社前経験年数
				configData.serviceYears					= view.serviceYears.selected;					// 勤続年数
				configData.totalExperienceYears			= view.totalExperienceYears.selected;			// 経験年数
				configData.academicBackground			= view.academicBackground.selected;	    		// 最終学歴
				configData.workStatusName				= view.workStatusName.selected;					// 勤務状態
				configData.securityCardNo				= view.securityCardNo.selected;					// セキュリティカード番号
				configData.yrpCardNo					= view.yrpCardNo.selected;						// YRPカード番号
				configData.insurancePolicySymbol		= view.insurancePolicySymbol.selected;			// 保険証記号
				configData.insurancePolicyNo			= view.insurancePolicyNo.selected;				// 保険証番号
				configData.pensionPocketbookNo			= view.pensionPocketbookNo.selected;			// 年金手帳番号
				configData.basicClassNo			    	= view.basicClassNo.selected;					// 資格 等級
				configData.basicRankNo					= view.basicRankNo.selected;					// 号
				configData.basicMonthlySum				= view.basicMonthlySum.selected;				// 基本給
				configData.managerialMonthlySum			= view.managerialMonthlySum.selected;			// 職務手当
				configData.competentMonthlySum			= view.competentMonthlySum.selected;			// 主務手当
				configData.technicalSkillMonthlySum		= view.technicalSkillMonthlySum.selected;		// 技能手当
				configData.informationPayName			= view.informationPayName.selected;				// 情報処理資格保有
				configData.housingMonthlySum			= view.housingMonthlySum.selected;				// 住宅補助手当
				configData.departmentHead               = view.departmentHead.selected;					// 所属部長
				configData.projectPosition              = view.projectPosition.selected;                // 役職
				configData.managerialPosition           = view.managerialPosition.selected;             // 経営役職
				//追加 @auther maruta
				configData.retirestaff					= view.retirestaff.selected;					// 退職者
			}
		}
		
		/**
		 * OKボタン押下処理
		 */
		public function onOk(e:MouseEvent):void
		{
			// プロフィール情報設定データの更新処理
			updateProperty();
			
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK);
			view.dispatchEvent(ce);
		}
		
		/**
		 * キャンセルボタン押下処理
		 */
		public function onCancel(e:MouseEvent):void
		{
			// 画面のクローズを行う
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, Alert.CANCEL);
			view.dispatchEvent(ce);
		}

		/**
		 * 保存ボタン押下処理
		 */
		public function onStorage(e:MouseEvent):void
		{
			var listData:DisplayItemsShowDto = new DisplayItemsShowDto();

			listData.listChoicesId = 6;
			listData.positionName = "初期選択";
			listData.staffId						= view.staffId.selected;						// 社員コード
			listData.fullname						= view.fullname.selected;						// 氏名
			listData.sexname						= view.sexName.selected;						// 性別
			listData.birthday						= view.birthday.selected;						// 生年月日
			listData.age					    	= view.age.selected;				    		// 年齢
			listData.bloodgroupname					= view.bloodGroupName.selected;					// 血液型
			listData.joindate						= view.joinDate.selected;						// 入社年月日
			listData.retiredate						= view.retireDate.selected;						// 退職年月日
			listData.departmentname					= view.departmentName.selected;					// 所属
			listData.projectname					= view.projectName.selected;					// 配属部署
			listData.committeename					= view.committeeName.selected;					// 委員会
			listData.extensionnumber				= view.extensionNumber.selected;				// 内線番号
			listData.email							= view.email.selected;							// メールアドレス
			listData.homephoneno					= view.homePhoneNo.selected;					// 電話番号
			listData.handyphoneno					= view.handyPhoneNo.selected;					// 携帯番号１
			listData.postalcode						= view.postalCode.selected;						// 郵便番号
			listData.address1						= view.address1.selected;						// 住所１
			listData.address2						= view.address2.selected;						// 住所２
			listData.emergencyaddress				= view.emergencyAddress.selected;				// 緊急連絡先
			listData.legaldomicilename				= view.legalDomicileName.selected;				// 本籍地
			listData.beforeexperienceyears			= view.beforeExperienceYears.selected;			// 入社前経験年数
			listData.serviceyears					= view.serviceYears.selected;					// 勤続年数
			listData.totalexperienceyears			= view.totalExperienceYears.selected;			// 経験年数
			listData.academicBackground				= view.academicBackground.selected;	    		// 最終学歴
			listData.workstatusname					= view.workStatusName.selected;					// 勤務状態
			listData.securitycardno					= view.securityCardNo.selected;					// セキュリティカード番号
			listData.yrpcardno						= view.yrpCardNo.selected;						// YRPカード番号
			listData.insurancepolicysymbol			= view.insurancePolicySymbol.selected;			// 保険証記号
			listData.insurancepolicyno				= view.insurancePolicyNo.selected;				// 保険証番号
			listData.pensionpocketbookno			= view.pensionPocketbookNo.selected;			// 年金手帳番号
			listData.basicclassno			    	= view.basicClassNo.selected;					// 資格 等級
			listData.basicrankno					= view.basicRankNo.selected;					// 号
			listData.basicmonthlysum				= view.basicMonthlySum.selected;				// 基本給
			listData.managerialmonthlysum			= view.managerialMonthlySum.selected;			// 職務手当
			listData.competentmonthlysum			= view.competentMonthlySum.selected;			// 主務手当
			listData.technicalskillmonthlysum		= view.technicalSkillMonthlySum.selected;		// 技能手当
			listData.informationPayName				= view.informationPayName.selected;				// 情報処理資格保有
			listData.housingmonthlysum				= view.housingMonthlySum.selected;				// 住宅補助手当
			listData.departmenthead             	= view.departmentHead.selected;					// 所属部長
			listData.projectposition            	= view.projectPosition.selected;                // 役職
			listData.managerialposition        		= view.managerialPosition.selected;             // 経営役職			
			
			view.displayItemsShowService.getOperation("updatelistData").send(listData);
		}

		/**
		 * 初期表示項目保存成功イベント
		 */
		public function onResult_updatelistData(e: ResultEvent):void
		{
			Alert.show("初期表示項目を保存しました。", "", Alert.OK, view, null);
		}

		/**
		 * 初期表示項目保存失敗イベント
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
		 * ポップアップクローズ処理
		 * 登録やキャンセルボタン以外でのクローズ時に使用
		 */
		public function onClose(e:CloseEvent):void
		{
			// 画面のクローズを行う
			PopUpManager.removePopUp(view);
		}


		/**
		 * 表示項目表示可否データ取得成功イベント
		 */
		public function onResult_getDisplayItemsShow(e: ResultEvent):void
		{
			// 表示項目表示可否データを更新する
			var displayItemsShowData:DisplayItemsShowDataDto = new DisplayItemsShowDataDto(e.result);
			var displayItemsShow:DisplayItemsShowDto = displayItemsShowData.DisplayItemsShowData;
			
			// 表示項目表示可否
			if(!(displayItemsShow.staffId)) view.check.removeChild(view.staffId);											// 社員コード
			if(!(displayItemsShow.fullname)) view.check.removeChild(view.fullname);											// 氏名
			if(!(displayItemsShow.sexname)) view.check.removeChild(view.sexName);											// 性別					
			if(!(displayItemsShow.birthday)) view.check.removeChild(view.birthday);											// 生年月日
			if(!(displayItemsShow.age)) view.check.removeChild(view.age);										        	// 年齢
			if(!(displayItemsShow.bloodgroupname)) view.check.removeChild(view.bloodGroupName);								// 血液型
			if(!(displayItemsShow.joindate)) view.check.removeChild(view.joinDate);											// 入社年月日
			if(!(displayItemsShow.retiredate)) view.check.removeChild(view.retireDate);										// 退職年月日
			if(!(displayItemsShow.departmentname)) view.check.removeChild(view.departmentName);								// 所属
			if(!(displayItemsShow.projectname)) view.check.removeChild(view.projectName);									// 配属部署
			if(!(displayItemsShow.committeename)) view.check.removeChild(view.committeeName);								// 委員会
			if(!(displayItemsShow.extensionnumber)) view.check.removeChild(view.extensionNumber);							// 内線番号
			if(!(displayItemsShow.email)) view.check.removeChild(view.email);												// メールアドレス
			if(!(displayItemsShow.homephoneno)) view.check.removeChild(view.homePhoneNo);									// 電話番号
			if(!(displayItemsShow.handyphoneno)) view.check.removeChild(view.handyPhoneNo);									// 携帯番号
			if(!(displayItemsShow.postalcode)) view.check.removeChild(view.postalCode);										// 郵便番号
			if(!(displayItemsShow.address1)) view.check.removeChild(view.address1);											// 住所１
			if(!(displayItemsShow.address2)) view.check.removeChild(view.address2);											// 住所２
			if(!(displayItemsShow.emergencyaddress)) view.check.removeChild(view.emergencyAddress);							// 緊急連絡先
			if(!(displayItemsShow.legaldomicilename)) view.check.removeChild(view.legalDomicileName);						// 本籍地
			if(!(displayItemsShow.beforeexperienceyears)) view.check.removeChild(view.beforeExperienceYears);				// 入社前経験年数
			if(!(displayItemsShow.serviceyears)) view.check.removeChild(view.serviceYears);									// 勤続年数
			if(!(displayItemsShow.totalexperienceyears)) view.check.removeChild(view.totalExperienceYears);					// 経験年数
			if(!(displayItemsShow.academicBackground)) view.check.removeChild(view.academicBackground);				    	// 最終学歴
			if(!(displayItemsShow.workstatusname)) view.check.removeChild(view.workStatusName);								// 勤務状態
			if(!(displayItemsShow.securitycardno)) view.check.removeChild(view.securityCardNo);								// セキュリティカード番号
			if(!(displayItemsShow.yrpcardno)) view.check.removeChild(view.yrpCardNo);										// YRPカード番号
			if(!(displayItemsShow.insurancepolicysymbol)) view.check.removeChild(view.insurancePolicySymbol);				// 保険証記号
			if(!(displayItemsShow.insurancepolicyno)) view.check.removeChild(view.insurancePolicyNo);						// 保険証番号
			if(!(displayItemsShow.pensionpocketbookno)) view.check.removeChild(view.pensionPocketbookNo);					// 年金手帳番号
			if(!(displayItemsShow.basicclassno)) view.check.removeChild(view.basicClassNo);				       				// 資格 等級
			if(!(displayItemsShow.basicrankno)) view.check.removeChild(view.basicRankNo);									// 号
			if(!(displayItemsShow.basicmonthlysum)) view.check.removeChild(view.basicMonthlySum);							// 基本給
			if(!(displayItemsShow.managerialmonthlysum)) view.check.removeChild(view.managerialMonthlySum);					// 職務手当
			if(!(displayItemsShow.competentmonthlysum)) view.check.removeChild(view.competentMonthlySum);					// 主務手当
			if(!(displayItemsShow.technicalskillmonthlysum)) view.check.removeChild(view.technicalSkillMonthlySum);			// 技能手当
			if(!(displayItemsShow.informationPayName)) view.check.removeChild(view.informationPayName);	                                    // 情報処理資格保有
			if(!(displayItemsShow.housingmonthlysum)) view.check.removeChild(view.housingMonthlySum);						// 住宅補助手当
			if(!(displayItemsShow.departmenthead)) view.check.removeChild(view.departmentHead);						        // 所属部長	
			if(!(displayItemsShow.projectposition)) view.check.removeChild(view.projectPosition);						    // 役職		
			if(!(displayItemsShow.managerialposition)) view.check.removeChild(view.managerialPosition);						// 経営役職
			
			//追加 @auther okamoto-y
			//一般社員,PM,PLには退職者のチェックボックスを表示しない
			if(authorityId == AuthorityId.STAFF || authorityId == AuthorityId.PM || authorityId == AuthorityId.PL) view.check.removeChild(view.retirestaff);			
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

		
		/** 画面 */
		public var _view:ProfileItemSelect;
		
		/**
		 * 画面を取得します
		 */
		public function get view():ProfileItemSelect
		{
			if (_view == null) {
				_view = super.document as ProfileItemSelect;
			}
			return _view;
		}
		
		/**
		 * 画面をセットします。
		 *
		 * @param view セットする画面
		 */
		public function set view(view:ProfileItemSelect):void
		{
			_view = view;
		}
	}
}
