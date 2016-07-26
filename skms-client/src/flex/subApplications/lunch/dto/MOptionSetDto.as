package subApplications.lunch.dto{	
	import mx.collections.ArrayCollection;
	
	
	/**
	 * MOptionSetDto
	 * 
	 */
	[Bindable]	[RemoteClass(alias="services.lunch.dto.MOptionSetDto")]	
	public class MOptionSetDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** optionNameプロパティ */
	    public var optionName:String ;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** MMenuList関連プロパティ */
	    public var mMenuList:ArrayCollection;
	
	    /** optionSetList関連プロパティ */
	    public var optionSetList:ArrayCollection;
	}}