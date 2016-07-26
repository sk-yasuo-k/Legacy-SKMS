package subApplications.lunch.dto{

	/**
	 * OptionKindDto
	 * 
	 */
	[Bindable]
	[RemoteClass(alias="services.lunch.dto.OptionKindDto")]
	public class OptionKindDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** MOptionKindIdプロパティ */
	    public var mOptionKindId:int;
	
	    /** optionIdプロパティ */
	    public var optionId:int;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** MOptionKind関連プロパティ */
	    public var mOptionKind:MOptionKindDto;
	
	    /** option関連プロパティ */
	    public var option:OptionDto;
	    
	   	/** optionNameプロパティ */
	    public var optionName:String; 
	}
}