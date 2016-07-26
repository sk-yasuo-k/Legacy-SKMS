package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.generalAffair.dto.AcademicBackgroundDto")]
	public class AcademicBackgroundDto
	{	
		/**
		 * 社員ID
		 */
		public var staffId:int;
				
		/**
		 * 学歴連番
		 */
		public var sequenceNo:int;
				
		/**
		 * 発生日
		 */
		public var occuredDate:Date;
						
		/**
		 * 内容
		 */
		public var content:String;
		
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