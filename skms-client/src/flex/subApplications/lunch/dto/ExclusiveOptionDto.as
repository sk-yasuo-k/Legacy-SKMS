package subApplications.lunch.dto
{
	
	
	/**
	 * ExclusiveOptionDto
	 * 
	 */
	[Bindable]
	[RemoteClass(alias="services.lunch.dto.ExclusiveOptionDto")]
	public class ExclusiveOptionDto{
	
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** MOptionKindIdプロパティ */
	    public var mOptionKindId:int;
	
	    /** exclusiceMOptionKindIdプロパティ */
	    public var exclusiceMOptionKindId:int;
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** MOptionKind関連プロパティ */
	    public var mOptionKind:MOptionKindDto;
	
	    /** exclusiceMOptionKind関連プロパティ */
	    public var exclusiceMOptionKind:MOptionKindDto ;
	    
	    /** mOptionKindNameプロパティ */
	    public var mOptionKindName:String;	    
	}
}