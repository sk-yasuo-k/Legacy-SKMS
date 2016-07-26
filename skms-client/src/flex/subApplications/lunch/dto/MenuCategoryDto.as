package subApplications.lunch.dto{	
	import mx.collections.ArrayCollection;
	
	
	/**
	 * MenuCategoryDto
	 * 
	 */	
	[Bindable]	[RemoteClass(alias="services.lunch.dto.MenuCategoryDto")]		public class MenuCategoryDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** categoryCodeプロパティ */
	    public var categoryCode:String ;
	
	    /** categoryNameプロパティ */
	    public var categoryName:String ;
	
	    /** categoryDisplayNameプロパティ */
	    public var categoryDisplayName:String ;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updateDateプロパティ */
	    public var updateDate:Date ;
	
	    /** MMenuList関連プロパティ */
	    public var mMenuList:ArrayCollection;
	}}