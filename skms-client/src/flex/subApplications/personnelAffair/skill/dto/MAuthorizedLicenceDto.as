package subApplications.personnelAffair.skill.dto
{
	/**
	 * 認定資格マスタDtoです。
	 *
	 * @author t-ito
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.MAuthorizedLicenceDto")]	 
	public class MAuthorizedLicenceDto
	{
		/**
		 * 資格IDです。
		 */
		public var licenceId:int;
		
		/**
		 * 資格名です。
		 */
		public var licenceName:String;

		/**
		 * カテゴリIDです。
		 */
		public var categoryId:int;	
		
		/**
		 * データ無い時用Dataです。
		 */
		public var data:String = "";
	}
}