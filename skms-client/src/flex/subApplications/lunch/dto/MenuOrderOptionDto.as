package subApplications.lunch.dto{

	/**
	 * MenuOrderOptionDto
	 * 
	 */	
	[Bindable]
	[RemoteClass(alias="services.lunch.dto.MenuOrderOptionDto")]	
	public class MenuOrderOptionDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** menuOrderIdプロパティ */
	    public var menuOrderId:int;
	
	    /** MOptionIdプロパティ */
	    public var mOptionId:int;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** menuOrder関連プロパティ */
	    public var menuOrder:MenuOrderDto;
	    
	    /** option関連プロパティ */
	    public var option:OptionDto;
	}
}