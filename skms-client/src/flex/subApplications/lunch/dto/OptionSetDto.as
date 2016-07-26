package subApplications.lunch.dto
{

	/**
	 * OptionSetDto
	 * 
	 */
	[Bindable]
	[RemoteClass(alias="services.lunch.dto.OptionSetDto")]	
	public class OptionSetDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** MOptionSetIdプロパティ */
	    public var mOptionSetId:int;
	
	    /** MOptionKindIdプロパティ */
	    public var mOptionKindId:int;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** MOptionKind関連プロパティ */
	    public var mOptionKind:MOptionKindDto;
	
	    /** MOptionSet関連プロパティ */
	    public var mOptionSet:MOptionSetDto;
	
	}
}