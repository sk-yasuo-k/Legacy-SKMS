package subApplications.lunch.dto{	
	import mx.collections.ArrayCollection;
	
	
	/**
	 * OptionDto
	 * 
	 */
	[Bindable]	[RemoteClass(alias="services.lunch.dto.OptionDto")]	public class OptionDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** codeプロパティ */
	    public var optionCode:String ;
	
	    /** optionNameプロパティ */
	    public var optionName:String ;
	
	    /** optionDisplayNameプロパティ */
	    public var optionDisplayName:String ;
	
	    /** priceプロパティ */
	    public var price:int;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** optionKindList関連プロパティ */
	    public var optionKindList:ArrayCollection;	}
}