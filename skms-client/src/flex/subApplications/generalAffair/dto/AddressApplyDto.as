package subApplications.generalAffair.dto
{

	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.AddressApplyDto")]
	public class AddressApplyDto
	{
		/**
		 * 社員ID
		 */
		public var staffId:int;	
		
		/**
		 * 更新回数
		 */
		public var updateCount:int;
		
		/**
		 * 引越日
		 */
		public var moveDate:Date;
		
		/**
		 * 郵便番号1
		 */
		public var postalCode1:String;		

		/**
		 * 郵便番号2
		 */
		public var postalCode2:String;
		
		/**
		 * 都道府県コード
		 */
		public var prefectureCode:int;
		
		/**
		 * 市区町村番地
		 */
		public var ward:String;
		
		/**
		 * 市区町村番地(カナ)
		 */
		public var wardKana:String;
		
		/**
		 * ビル
		 */
		public var houseNumber:String;

		/**
		 * ビル(カナ)
		 */
		public var houseNumberKana:String;
				
		/**
		 * 自宅電話番号1
		 */
		public var homePhoneNo1:String;
		
		/**
		 * 自宅電話番号2
		 */
		public var homePhoneNo2:String;
		
		/**
		 * 自宅電話番号3
		 */
		public var homePhoneNo3:String;
		
		/**
		 * 登録日時
		 */
		public var registrationTime:Date;
		
		/**
		 * 登録者ID
		 */
		public var registrantId:int;
		
		/**
		 * 世帯主フラグ
		 */
		public var householderFlag:Boolean;		
		
		/**
		 * 表札名
		 */
		public var nameplate:String;		
		
		/**
		 * 連絡のとりやすい社員
		 */
		public var associateStaff:String;
	}
		
}