package subApplications.lunch.dto{
	import mx.collections.ArrayCollection;
	
	
	/**
	 * ShopMenuDto
	 * 
	 */
	[Bindable]	[RemoteClass(alias="services.lunch.dto.ShopMenuDto")]	public class ShopMenuDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** MLunchShopIdプロパティ */
	    public var mLunchShopId:int;
	
	    /** MMenuIdプロパティ */
	    public var mMenuId:int;
	
	    /** startDateプロパティ */
	    public var startDate:Date ;
	
	    /** finishDateプロパティ */
	    public var finishDate:Date ;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** menuOrderList関連プロパティ */
	    public var menuOrderList:ArrayCollection;
	
	    /** MLunch関連プロパティ */
	    public var mLunch:MLunchShopDto;
	
	    /** MMenu関連プロパティ */
	    public var mMenu:MMenuDto;
	}}