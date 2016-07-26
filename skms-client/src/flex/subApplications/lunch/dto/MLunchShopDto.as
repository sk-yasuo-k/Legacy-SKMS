package subApplications.lunch.dto{
	
	import mx.collections.ArrayCollection;
	
	/**
	 * MLunchShopDto
	 * 
	 */
	[Bindable]
	[RemoteClass(alias="services.lunch.dto.MLunchShopDto")]	
	public class MLunchShopDto{
	
	    /** shopIdプロパティ */
	    public var shopId:int;
	
	    /** shopNameプロパティ */
	    public var shopName:String ;
	
	    /** orderLimitTimeプロパティ */
	    public var orderLimitTime:String ;
	
	    /** shopUrlプロパティ */
	    public var shopUrl:String ;
	
	    /** sortOrderプロパティ */
	    public var sortOrder:int;
	
	    /** postalCode1プロパティ */
	    public var postalCode1:String ;
	
	    /** postalCode2プロパティ */
	    public var postalCode2:String ;
	
	    /** prefectureCodeプロパティ */
	    public var prefectureCode:String ;

		/** 都道府県名プロパティ */
		public var prefectureName:String ;
		
	    /** wardプロパティ */
	    public var ward:String ;
	
	    /** houseNumberプロパティ */
	    public var houseNumber:String ;
	
	    /** shopPhoneNo1プロパティ */
	    public var shopPhoneNo1:String ;
	
	    /** shopPhoneNo2プロパティ */
	    public var shopPhoneNo2:String ;
	
	    /** shopPhoneNo3プロパティ */
	    public var shopPhoneNo3:String ;
	
	    /** registrationTimeプロパティ */
	    public var registrationTime:Date ;
	
	    /** registrantIdプロパティ */
	    public var registrantId:int;
	
	    /** shopMenuList関連プロパティ */
	    public var shopMenuList:ArrayCollection;
	}
}