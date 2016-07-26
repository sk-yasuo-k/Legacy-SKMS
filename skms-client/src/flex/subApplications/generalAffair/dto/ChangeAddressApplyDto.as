package subApplications.generalAffair.dto
{

	[Bindable]
	[RemoteClass(alias="services.generalAffair.address.dto.ChangeAddressApplyDto")]
	public class ChangeAddressApplyDto
	{
		/**
		 * 社員ID
		 */
		public var staffId:int;
		
		/**
		 * 社員名(フル)
		 */
		public var fullName:String;		
		
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
		 * 都道府県名
		 */
		public var prefectureName:String;
		
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
		public var registrationId:int;
		
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
		
		/**
		 * 履歴更新回数
		 */
		public var historyUpdateCount:int;
		
		/**
		 * 申請状態ID
		 */
		public var addressStatusId:int;
		
		/**
		 * 申請状態名
		 */
		public var addressStatusName:String;
		
		/**
		 * 申請動作ID
		 */
		public var addressActionId:int;
		
		/**
		 * 申請動作名
		 */
		public var addressActionName:String;
		
		/**
		 * 更新登録日時
		 */
		public var historyRegistrationTime:Date;
		
		/**
		 * 更新登録者ID
		 */
		public var historyRegistrationId:int;
		
		/**
		 * 更新コメント
		 */
		public var comment:String;
		
		/**
		 * 更新登録者氏名
		 */
		public var historyRegistrationName:String;
		
		/**
		 * 最終提出日時
		 */
		public var presentTime:Date;
		
		
	}
		
}