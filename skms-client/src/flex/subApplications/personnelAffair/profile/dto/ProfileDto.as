package subApplications.personnelAffair.profile.dto
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * プロフィール情報Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.profile.dto.ProfileDto")]
	public class ProfileDto
	{
		/**
		 * 社員IDです。
		 */
		public var staffId:int;
		
		/**
		 * 社員名です。
		 */
		public var fullName:String;
		
		/**
		 * 性別IDです。
		 */
		public var sex:int;
		
		/**
		 * 性別名称です。
		 */
		public var sexName:String;
		
		/**
		 * 生年月日です。
		 */
		public var birthday:Date;
		
		/**
		 * 年齢です。
		 */
		public var age:int;
		
		/**
		 * 血液型IDです。
		 */
		public var bloodGroup:int;
		
		/**
		 * 血液型名称です。
		 */
		public var bloodGroupName:String;
		
		/**
		 * 入社年月日です。
		 */
		public var joinDate:Date;
		
		/**
		 * 退職年月日です。
		 */
		public var retireDate:Date;
		
		/**
		 * 部署IDです。
		 */
		public var departmentId:int;
		
		/**
		 * 部署名です。
		 */
		public var departmentName:String;
		
		/**
		 * プロジェクトIDです。
		 */
		public var projectId:int;
		
		/**
		 * プロジェクトコードです。
		 */
		public var projectCode:String;
		
		/**
		 * プロジェクト名です。
		 */
		public var projectName:String;
		
		/**
		 * 委員会IDです。
		 */
		public var committeeId:int;
		
		/**
		 * 委員会名称です。
		 */
		public var committeeName:String;
		
		/**
		 * 内線番号です。
		 */
		public var extensionNumber:String;
		
		/**
		 * メールアドレスです。
		 */
		public var email:String;
		
		/**
		 * 電話番号です。
		 */
		public var homePhoneNo:String;
		
		/**
		 * 携帯番号です。
		 */
		public var handyPhoneNo:String;
		
		/**
		 * 郵便番号です。
		 */
		public var postalCode:String;
		
		/**
		 * 住所１です。
		 */
		public var address1:String;
		
		/**
		 * 住所２です。
		 */
		public var address2:String;
		
		/**
		 * 緊急連絡先です。
		 */
		public var emergencyAddress:String;
		
		/**
		 * 本籍地です。
		 */
		public var legalDomicileName:String;
		
		/**
		 * 入社前経験年数です。
		 */
		public var beforeExperienceYears:int;
		
		/**
		 * 勤続年数です。
		 */
		public var serviceYears:int;
		
		/**
		 * 経験年数です。
		 */
		public var totalExperienceYears:int;
		
		/**
		 * 勤務状態IDです。
		 */
		public var workStatusId:int;
		
		/**
		 * 勤務状態です。
		 */
		public var workStatusName:String;
		
		/**
		 * セキュリティカード番号です。
		 */
		public var securityCardNo:String = "[未設定]";
		
		/**
		 * YRPカード番号です。
		 */
		public var yrpCardNo:String = "[未設定]";
		
		/**
		 * 保険証記号です。
		 */
		public var insurancePolicySymbol:String = "[未設定]";
		
		/**
		 * 保険証番号です。
		 */
		public var insurancePolicyNo:String = "[未設定]";
		
		/**
		 * 年金手帳番号です。
		 */
		public var pensionPocketbookNo:String = "[未設定]";
		
		/**
		 * 資格（等級数）です。
		 */
		public var basicClassNo:int;
		
		/**
		 * 資格（等級名）です。
		 */
//		public var basicClassName:String;
		
		/**
		 * 資格（号）です。
		 */
		public var basicRankNo:int;
		
		/**
		 * 基本給です。
		 */
		public var basicMonthlySum:int;
		
		/**
		 * 職務等級です。
		 */
		public var managerialClassNo:int;
		
		/**
		 * 職務手当です。
		 */
		public var managerialMonthlySum:int;
		
		/**
		 * 主務等級です。
		 */
		public var competentClassNo:int;
		
		/**
		 * 主務手当です。
		 */
		public var competentMonthlySum:int;
		
		/**
		 * 技能等級です。
		 */
		public var technicalSkillClassNo:int;
		
		/**
		 * 技能手当です。
		 */
		public var technicalSkillMonthlySum:int;
		
		/**
		 * 情報処理資格保有です。
		 */
		public var informationPayName:String;
		
		/**
		 * 住宅補助手当IDです。
		 */
		public var housingId:int;
		
		/**
		 * 住宅補助手当です。
		 */
		public var housingMonthlySum:int;
		
/** プロフィール詳細用追加分(伊藤) */
		/**
		 * 姓です。
		 */
		public var lastName:String;

		/**
		 * 名です。
		 */
		public var firstName:String;
		
		/**
		 * 姓(かな)です。
		 */
		public var lastNameKana:String;

		/**
		 * 名(かな)です。
		 */
		public var firstNameKana:String;

		/**
		 * 連絡のとりやすい社員です。
		 */
		public var associateStaff:String;						

		/**
		 * 社員所持認定資格です。
		 */
		public var mStaffAuthorizedLicence:ArrayCollection;
		
		/**
		 * 社員所持その他資格です。
		 */
		public var mStaffOtherLocence:ArrayCollection;	
		
		/**
		 * 社員画像です。
		 */
		public	var staffImage:ByteArray;		

/** プロフィール詳細用追加分(伊藤) */
		
		/**
		 * 所属部長です。
		 */
		public var departmentHead:String;
		
		/**
		 * 役職です。
		 */
		public var projectPosition:String;		
		
		/**
		 * 経営役職です。
		 */
		public var managerialPosition:String;						

		/**
		 * 最終学歴です。
		 */
		public var academicBackground:String;	
				
		/**
		 * コンストラクタ。
		 */
		public function ProfileDto()
		{
		}
	}
}