package subApplications.personnelAffair.skill.dto
{
	/**
	 * 社員所持その他資格情報Dtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.skill.dto.StaffOtherLocenceDto")]
	public class StaffOtherLocenceDto
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
		 * 資格名です。
		 */
		public var licenceName:String;
		
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
		public function StaffOtherLocenceDto()
		{
		}

	}
}