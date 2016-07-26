package subApplications.personnelAffair.profile.dto
{
	/**
	 * プロフィール情報設定Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	public class ProfileConfigDto
	{
		/**
		 * 社員IDです。
		 */
		public var staffId:Boolean;
		
		/**
		 * 社員名です。
		 */
		public var fullName:Boolean;
		
		/**
		 * 性別IDです。
		 */
		public var sex:Boolean;
		
		/**
		 * 性別です。
		 */
		public var sexName:Boolean;
		
		/**
		 * 生年月日です。
		 */
		public var birthday:Boolean;
		
		/**
		 * 年齢です。
		 */
		public var age:Boolean;
		
		/**
		 * 血液型IDです。
		 */
		public var bloodGroup:Boolean;
		
		/**
		 * 血液型名称です。
		 */
		public var bloodGroupName:Boolean;
		
		/**
		 * 入社年月日です。
		 */
		public var joinDate:Boolean;
		
		/**
		 * 退職年月日です。
		 */
		public var retireDate:Boolean;
		
		/**
		 * 部署IDです。
		 */
		public var departmentId:Boolean;
		
		/**
		 * 部署名です。
		 */
		public var departmentName:Boolean;
		
		/**
		 * プロジェクトIDです。
		 */
		public var projectId:Boolean;
		
		/**
		 * プロジェクトコードです。
		 */
		public var projectCode:Boolean;
		
		/**
		 * プロジェクト名です。
		 */
		public var projectName:Boolean;
		
		/**
		 * 委員会IDです。
		 */
		public var committeeId:Boolean;
		
		/**
		 * 委員会名称です。
		 */
		public var committeeName:Boolean;
		
		/**
		 * 内線番号です。
		 */
		public var extensionNumber:Boolean;
		
		/**
		 * メールアドレスです。
		 */
		public var email:Boolean;
		
		/**
		 * 電話番号です。
		 */
		public var homePhoneNo:Boolean;
		
		/**
		 * 携帯番号です。
		 */
		public var handyPhoneNo:Boolean;
		
		/**
		 * 携帯番号２です。
		 */
		public var handyPhoneNo2:Boolean;
		
		/**
		 * 郵便番号です。
		 */
		public var postalCode:Boolean;
		
		/**
		 * 住所１です。
		 */
		public var address1:Boolean;
		
		/**
		 * 住所２です。
		 */
		public var address2:Boolean;
		
		/**
		 * 緊急連絡先です。
		 */
		public var emergencyAddress:Boolean;
		
		/**
		 * 本籍地です。
		 */
		public var legalDomicileName:Boolean;
		
		/**
		 * 入社前経験年数です。
		 */
		public var beforeExperienceYears:Boolean;
		
		/**
		 * 勤続年数です。
		 */
		public var serviceYears:Boolean;
		
		/**
		 * 経験年数です。
		 */
		public var totalExperienceYears:Boolean;
		
		/**
		 * 勤務状態IDです。
		 */
		public var workStatusId:Boolean;
		
		/**
		 * 勤務状態です。
		 */
		public var workStatusName:Boolean;
		
		/**
		 * セキュリティカード番号です。
		 */
		public var securityCardNo:Boolean;
		
		/**
		 * YRPカード番号です。
		 */
		public var yrpCardNo:Boolean;
		
		/**
		 * 保険証記号です。
		 */
		public var insurancePolicySymbol:Boolean;
		
		/**
		 * 保険証番号です。
		 */
		public var insurancePolicyNo:Boolean;
		
		/**
		 * 年金手帳番号です。
		 */
		public var pensionPocketbookNo:Boolean;
		
		/**
		 * 資格（等級数）です。
		 */
		public var basicClassNo:Boolean;
		
		/**
		 * 資格（等級名）です。
		 */
//		public var basicClassName:Boolean;
		
		/**
		 * 資格（号）です。
		 */
		public var basicRankNo:Boolean;
		
		/**
		 * 基本給です。
		 */
		public var basicMonthlySum:Boolean;
		
		/**
		 * 職務等級です。
		 */
		public var managerialClassNo:Boolean;
		
		/**
		 * 職務手当です。
		 */
		public var managerialMonthlySum:Boolean;
		
		/**
		 * 主務等級です。
		 */
		public var competentClassNo:Boolean;
		
		/**
		 * 主務手当です。
		 */
		public var competentMonthlySum:Boolean;
		
		/**
		 * 技能等級です。
		 */
		public var technicalSkillClassNo:Boolean;
		
		/**
		 * 技能手当です。
		 */
		public var technicalSkillMonthlySum:Boolean;
		
		/**
		 * 情報処理資格保有です。
		 */
		public var informationPayName:Boolean;
		
		/**
		 * 住宅補助手当IDです。
		 */
		public var housingId:Boolean;
		
		/**
		 * 住宅補助手当です。
		 */
		public var housingMonthlySum:Boolean;
		
		/**
		 * 所属部長です。
		 */
		public var departmentHead:Boolean;

		/**
		 * 役職です。
		 */
		public var projectPosition:Boolean;

		/**
		 * 経営役職です。
		 */
		public var managerialPosition:Boolean;

		/**
		 * 最終学歴です。
		 */
		public var academicBackground:Boolean;	

		//追加 @auther maruta
		/**
		 * 
		 * 退職者です。
		 */
		public var retirestaff:Boolean;
		 
		/**
		 * コンストラクタ。
		 */
		public function ProfileConfigDto()
		{
		}
	}
}