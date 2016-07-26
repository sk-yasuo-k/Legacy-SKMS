package subApplications.personnelAffair.skill.dto
{
	/**
	 * 社員所持認定資格情報Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto")]
	public class StaffAuthorizedLicenceDto
	{
		/**
		 * 社員IDです。
		 */
		public var staffId:int;
		
		/**
		 * 資格連番です。
		 */
		public var sequenceNo:int;
		
		/**
		 * 資格IDです。
		 */
		public var licenceId:int;
		
		/**
		 * 資格名です。
		 */
		public var licenceName:String;
		
	   /**
	 	* 資格手当です。
	 	*/
		public var monthlySum:int;
		
		/**
		 * 情報手当IDです。
		 */
		public var informationPayId:int;
		
		/**
		 * カテゴリIDです。
		 */
		public var categoryId:int;
		
		/**
		 * カテゴリ名です。
		 */
		public var categoryName:String;
		
		/**
		 * 取得日です。
		 */
		public var acquisitionDate:Date;
		
		/**
		 * 登録日時です。
		 */
		public var registrationTime:Date;
		
		/**
		 * 登録者IDです。
		 */
		public var registrantId:int;
		
		/**
		 * コンストラクタ
		 */
		public function StaffAuthorizedLicenceDto()
		{
		}

	}
}