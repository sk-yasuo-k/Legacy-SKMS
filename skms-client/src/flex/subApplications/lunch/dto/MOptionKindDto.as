package subApplications.lunch.dto{	
	import mx.collections.ArrayCollection;
	
	
	/**
	 * MOptionKindDto
	 * 
	 */
	[Bindable]	[RemoteClass(alias="services.lunch.dto.MOptionKindDto")]			
	public class MOptionKindDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** optionKindNameプロパティ */
	    public var optionKindName:String ;
	
	    /** optionKindDisplayNameプロパティ */
	    public var optionKindDisplayName:String ;	    	    /** optionKindCodeプロパティ */	    public var optionKindCode:String ;	   
	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** updatedDateプロパティ */
	    public var updatedDate:Date ;
	
	    /** exclusiveOptionList関連プロパティ */
	    public var exclusiveOptionList:ArrayCollection;
	
	    /** exclusiveOptionList2関連プロパティ */
	    public var exclusiveOptionList2:ArrayCollection;
	
	    /** optionKindList関連プロパティ */
	    public var optionKindList:ArrayCollection;
	
	    /** optionSetList関連プロパティ */
	    public var optionSetList:ArrayCollection;	}
}