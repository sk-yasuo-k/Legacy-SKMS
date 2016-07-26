package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	import dto.StaffDto;

	[Bindable]
	[RemoteClass(alias="services.generalAffair.address.entity.VStaffAddressMoveDate")]
	
	public class StaffAddressMoveDateDto
	{
		public function StaffAddressMoveDateDto()
		{
		}
		
		/**
		 * 社員IDです.
		 */
		public var staffId:int;
		
		/**
		 * 転居日です.
		 */
		public var moveDate:Date;

		/**
		 * 郵便番号1です.
		 */
	    public var postalCode1:String;
	
		/**
		 * 郵便番号2です.
		 */
	    public var postalCode2:String;
	
		/**
		 * 都道府県名です.
		 */
	    public var prefectureName:String;
	
		/**
		 * 市区町村名です.
		 */
	    public var ward:String;
	
		/**
		 * 番地・ビル名です.
		 */
	    public var houseNumber:String;
		
		/**
		 * 住所変更手続き状態IDです.
		 */
	    public var addressStatusId:int;
		

	}
}