package subApplications.personnelAffair.skill.dto
{
	/**
	 * 認定資格マスタDtoです。
	 *
	 * @author t-ito
	 *
	 */	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.MAuthorizedLicenceCategoryDto")]	 
	public class MAuthorizedLicenceCategoryDto
	{
		/**
		 * カテゴリIDです。
		 */
		public var categoryId:int;
		
		/**
		 * カテゴリ名です。
		 */
		public var categoryName:String;
		
	}
}