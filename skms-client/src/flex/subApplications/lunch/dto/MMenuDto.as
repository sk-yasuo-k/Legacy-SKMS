package subApplications.lunch.dto{
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * MMenuDto
	 * 
	 */
	[Bindable]
	[RemoteClass(alias="services.lunch.dto.MMenuDto")]	
	public class MMenuDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** menuCodeプロパティ */
	    public var menuCode:String ;
	
	    /** menuNameプロパティ */
	    public var menuName:String ;
	
	    /** priceプロパティ */
	    public var price:int;
	
	    /** MOptionSetIdプロパティ */
	    public var mOptionSetId:int;
	
	    /** menuCategoryIdプロパティ */
	    public var menuCategoryId:int;
	
	    /** commentプロパティ */
	    public var comment:String ;
	
	    /** photoプロパティ */
	    public var photo:ByteArray;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** MOptionSet関連プロパティ */
	    public var mOptionSet:MOptionSetDto;	    
	
	    /** menuCategory関連プロパティ */
	    public var menuCategory:MenuCategoryDto;
	
	    /** shopMenuList関連プロパティ */
	    public var shopMenuList:ArrayCollection;
	}
}