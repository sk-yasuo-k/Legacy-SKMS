package subApplications.personnelAffair.profile.dto
{
	
	/**
	 * 表示項目表示可否Dtoです。
	 *
	 * @author t-ito
	 *
	 */	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.authority.dto.DisplayItemsShowDto")]	
	public class DisplayItemsShowDto
	{
		/**
		 * 表示可否リスト番号です。
		 */
		public var listChoicesId:int;
		
		/**
		 * 権限種別名
		 */
		public var positionName:String;	

		/**
		 * 社員ID
		 */
		public var staffId:Boolean = new Boolean(false);	
		
		/**
		 * 氏名
		 */
		public var fullname:Boolean = new Boolean(false);	
		
		/**
		 * 性別
		 */
		public var sexname:Boolean = new Boolean(false);	
		
		/**
		 * 生年月日
		 */
		public var birthday:Boolean = new Boolean(false);	
		
		/**
		 * 年齢
		 */
		public var age:Boolean = new Boolean(false);
				
		/**
		 * 血液型
		 */
		public var bloodgroupname:Boolean = new Boolean(false);	
		
		/**
		 * 入社年月日
		 */
		public var joindate:Boolean = new Boolean(false);	
		
		/**
		 * 退職年月日
		 */
		public var retiredate:Boolean = new Boolean(false);	
		
		/**
		 * 所属
		 */
		public var departmentname:Boolean = new Boolean(false);	
		
		/**
		 * 配属部署
		 */
		public var projectname:Boolean = new Boolean(false);	
		
		/**
		 * 委員会
		 */
		public var committeename:Boolean = new Boolean(false);	
		
		/**
		 * 内線番号
		 */
		public var extensionnumber:Boolean = new Boolean(false);	
		
		/**
		 * メールアドレス
		 */
		public var email:Boolean = new Boolean(false);	
		
		/**
		 * 電話番号
		 */
		public var homephoneno:Boolean = new Boolean(false);	
		
		/**
		 * 携帯番号
		 */
		public var handyphoneno:Boolean = new Boolean(false);	
		
		/**
		 * 郵便番号
		 */
		public var postalcode:Boolean = new Boolean(false);	
		
		/**
		 * 住所１
		 */
		public var address1:Boolean = new Boolean(false);	
		
		/**
		 * 住所２
		 */
		public var address2:Boolean = new Boolean(false);	
		
		/**
		 * 緊急連絡先
		 */
		public var emergencyaddress:Boolean = new Boolean(false);	
		
		/**
		 * 本籍地
		 */
		public var legaldomicilename:Boolean = new Boolean(false);	
		
		/**
		 * 入社前経験年
		 */
		public var beforeexperienceyears:Boolean = new Boolean(false);
		
		/**
		 * 勤続年数
		 */
		public var serviceyears:Boolean = new Boolean(false);	
		
		/**
		 * 経験年数
		 */
		public var totalexperienceyears:Boolean = new Boolean(false);	

		/**
		 * 最終学歴
		 */
		public var academicBackground:Boolean = new Boolean(false);	
		
		/**
		 * 勤務状態
		 */
		public var workstatusname:Boolean = new Boolean(false);	
		
		/**
		 * セキュリティ
		 */
		public var securitycardno:Boolean = new Boolean(false);	
		
		/**
		 * YRPカード番号
		 */
		public var yrpcardno:Boolean = new Boolean(false);	
		
		/**
		 * 保険証記号
		 */
		public var insurancepolicysymbol:Boolean = new Boolean(false);	
		
		/**
		 * 保険証番号
		 */
		public var insurancepolicyno:Boolean = new Boolean(false);	
		
		/**
		 * 年金手帳番号
		 */
		public var pensionpocketbookno:Boolean = new Boolean(false);	
		
		/**
		 * 資格 等級
		 */
		public var basicclassno:Boolean = new Boolean(false);	
		
		/**
		 * 号
		 */
		public var basicrankno:Boolean = new Boolean(false);	
		
		/**
		 * 基本給
		 */
		public var basicmonthlysum:Boolean = new Boolean(false);	
		
		/**
		 * 職務手当
		 */
		public var managerialmonthlysum:Boolean = new Boolean(false);	
		
		/**
		 * 主務手当
		 */
		public var competentmonthlysum:Boolean = new Boolean(false);	
		
		/**
		 * 技能手当
		 */
		public var technicalskillmonthlysum:Boolean = new Boolean(false);	
		
		/**
		 * 情報処理資格保有
		 */
		public var informationPayName:Boolean = new Boolean(false);	
		
		/**
		 * 住宅補助手当
		 */
		public var housingmonthlysum:Boolean = new Boolean(false);	

		/**
		 * 所属部長
		 */
		public var departmenthead:Boolean = new Boolean(false);	

		/**
		 * 役職
		 */
		public var projectposition:Boolean = new Boolean(false);	

		/**
		 * 経営役職
		 */
		public var managerialposition:Boolean = new Boolean(false);	
					
		/**
		 * コンストラクタ。
		 */
		public function DisplayItemsShowDto()
		{
		}

	}
}