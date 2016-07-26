package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.MStaffCommitteeDto")]
	public class CommitteeDto
	{
		/**
		 * 社員ID
		 */
		public var staffId:int;
		
		/**
		 * 社員名
		 */
		public var name:String;
		
		/**
		 * 社員名(フル)です。
		 */
		public var fullName:String;
		
		/**
		 * 更新回数
		 */
		public var updateCount:int;
				
		/**
		 * 委員会ID
		 */
		public var committeeId:int;
				
		/**
		 * 委員会名
		 */
		public var committeeName:String;
						
		/**
		 * 委員会役員ID
		 */
		public var committeePositionId:int;
				
		/**
		 * 委員会役員名
		 */
		public var committeePositionName:String;
		
		/**
		 * 適用開始日
		 */
		public var applyDate:Date;
		
		/**
		 * 適用解除日
		 */
		public var cancelDate:Date;		

		/**
		 * 登録日時
		 */
		public var registrationTime:Date;
		
		/**
		 * 登録ID
		 */
		public var registrantId:int;
		
		/**
		 * 経営役職ID
		 */
		public var managerialPositionId:int;
		
		/**
		 * 委員所属者名です。
		 */
		public var committeeFullName:String;
		
		/**
		 * 期間
		 */
		public var periodDate:String;
		
		/**
		 * 役職期間
		 */
		public var periodNameDate:String;
		
		//追加 @auther okamoto-y
		/**
		 * 日付設定用
		 */
		public var edfcommitteeDate:Date; 
		
		//追加 @auther maruta
		/**
		 * 入会日
		 */
//		public var edfenrollmentDate:Date;
		
		/**
		 * 退会日
		 */
//		public var edfwithdrawalDate:Date;
		
		/**
		 * 委員長任命日
		 */
//		public var edfjoinheadDate:Date;  
		
		/**
		 * 委員長退任日
		 */
//		public var edfretireheadDate:Date;
		
		/**
		 * 副委員長任命日
		 */
//		public var edfjoinsubheadDate:Date;
		
		/**
		 * 副委員長退任日
		 */
//		public var edfretiresubheadDate:Date;
		//
	}
}