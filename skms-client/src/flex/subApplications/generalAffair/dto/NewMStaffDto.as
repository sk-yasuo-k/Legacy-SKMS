package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.MStaffDto")]
	public class NewMStaffDto
	{
		/**
		 * 社員ID
		 */
		public var staffId:int;
		
		/**
		 * ログイン名
		 */
		public var loginName:String;
		
		/**
		 * メールアドレス
		 */
		public var email:String;
		
		/**
		 * 誕生日
		 */
		public var birthday:Date;
				
		/**
		 * 卒業年
		 */
		public var graduateYear:int;
				
		/**
		 * 出身校
		 */
		public var school:String;
						
		/**
		 * 学部
		 */
		public var department:String;
				
		/**
		 * 学科
		 */
		public var course:String;
		
		/**
		 * 血液型
		 */
		public var blood_group:int;
		
		/**
		 * 性別
		 */
		public var sex:int;
					
		/**
		 * 緊急連絡先
		 */
		public var emergencyAddress:String;
		
		/**
		 * 本籍地(都道府県コード)
		 */
		public var legalDomicileCode:String;
		
		/**
		 * 入社前経験年数
		 */
		public var experienceYears:String;
		
		/**
		 * 職種ID
		 */
		public var occupationalCategoryId:int;	

		/**
		 * 登録日時
		 */
		public var registrationTime:Date;
		
		/**
		 * 登録ID
		 */
		public var registrantId:int;	
	}
}