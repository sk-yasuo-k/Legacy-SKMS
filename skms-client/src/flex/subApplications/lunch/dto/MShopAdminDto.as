package subApplications.lunch.dto{
	import subApplications.lunch.dto.VCurrentStaffNameDto;
	
	
	/**
	 * MLunchAdminDto
	 * 
	 */	
	[Bindable]
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** staffIdプロパティ */
	    public var staffId:int;
	    
		/** 社員名です。*/
		public var fullName:String;
	
	    /** startDateプロパティ */
	    public var startDate:Date ;
	    
	    /** finishDateプロパティ */
	    public var finishDate:Date ;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updateDateプロパティ */
	    public var updateDate:Date ;
	}