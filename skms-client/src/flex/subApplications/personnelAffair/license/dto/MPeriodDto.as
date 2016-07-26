package subApplications.personnelAffair.license.dto
{	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MPeriodDto")]
	public class MPeriodDto
	{		
		/**
		 * Id(連番)
		 */
	    public var id:int;
	    
	    /**
		 * periodId(期ID)
		 */
	    public var periodId:int;
	    
	    /**
		 * periodName(期名)
		 */
		public var periodName:String;

	    /**
		 * periodStartDate(適応開始日)
		 */
		public var periodStartDate:Date;

	    /**
		 * periodEndDate(適応終了日)
		 */
		public var periodEndDate:Date;		
	}
}