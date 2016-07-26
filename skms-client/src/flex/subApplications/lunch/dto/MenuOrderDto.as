package subApplications.lunch.dto{
	import mx.collections.ArrayCollection;
	
	
	/**
	 * MenuOrderDto
	 * 
	 */	
	[Bindable]
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** staffIdプロパティ */
	    public var staffId:int;
	
	    /** orderDateプロパティ */
	    public var orderDate:Date ;
	
	    /** shopMenuIdプロパティ */
	    public var shopMenuId:int;
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** numberプロパティ */
	    public var number:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** cancelプロパティ */
	    public var cancel:Boolean;
	
	    /** MStaff関連プロパティ 
	    public var MStaffDto:MStaffDto;*/
	    
		/** 社員名情報です。*/
		public var vCurrentStaffName:VCurrentStaffNameDto;
	
	    /** shopMenu関連プロパティ */
	    public var shopMenu:ShopMenuDto;
	
	    /** menuOrderOptionList関連プロパティ */
	    public var menuOrderOptionList:ArrayCollection;
	    	}
	    }
	}	