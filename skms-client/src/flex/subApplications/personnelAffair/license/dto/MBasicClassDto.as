package subApplications.personnelAffair.license.dto
{	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MBasicClassDto")]
	public class MBasicClassDto
	{			
		/**
		 * Id(連番)
		 */
		public var id:int;
	    
		/**
		 * 等級ID
		 */
		public var classId:int;
		
		/**
		 * 等級名
		 */
		public var className:String;
	}
}