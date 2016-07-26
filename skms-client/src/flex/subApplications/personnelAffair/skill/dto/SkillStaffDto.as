package subApplications.personnelAffair.skill.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 社員詳細情報Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.StaffDto")]
	public class SkillStaffDto
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
		 * 性別です。
		 */
		public var sex:String;
		
		/**
		 * 生年月日です。
		 */
		public var birthday:Date;
		
		/**
		 * 年齢です。
		 */
		public var age:int;
		
		/**
		 * 入社日です。
		 */
		public var occuredDate:Date;
		
		/**
		 * 経験年数です。
		 */
		public var experienceYears:int;
		
		/**
		 * 役職です。
		 */
		public var managerialPositionName:String;
		
		/**
		 * 職種です。
		 */
		public var occupationalCategoryName:String;
		
		/**
		 * 所属部署です。
		 */
		public var departmentName:String;
		
		/**
		 * 最終学歴です。
		 */
		public var finalAcademicBackground:String;
		
		/**
		 * 取得資格です。
		 */
		public var staffAuthorizedLicence:ArrayCollection;
		
		/**
		 * 取得免許です。
		 */
		public var staffOtherLocence:ArrayCollection;
		
		/**
		 * 取得資格取得処理
		 * 
		 * @return 取得資格の内容をカンマ区切りで分けたもの
		 */
		public function get staffAuthorizedLicenceName():String
		{
			var auth:String = new String();
			for each( var dto_auth:StaffAuthorizedLicenceDto in staffAuthorizedLicence){
				if ( auth != "" )
				{
					auth += "、"
				}
				auth += dto_auth.licenceName;
			}
			return auth;
		}
		
		/**
		 * 取得免許取得処理
		 * 
		 * @return 取得免許の内容をカンマ区切りで分けたもの
		 */
		public function get staffOtherLocenceName():String
		{
			var other:String = new String();
			for each( var dto_other:StaffOtherLocenceDto in staffOtherLocence){
				if ( other != "" )
				{
					other += "、"
				}
				other += dto_other.licenceName;
			}
			return other;
		}
		
	}
}