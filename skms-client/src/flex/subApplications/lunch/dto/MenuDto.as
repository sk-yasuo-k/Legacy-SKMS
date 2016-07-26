package subApplications.lunch.dto
{
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	
	/**
	 * MenuDto
	 * 
	 */	
	public class MenuDto
	{
	    /** menuIdプロパティ */
	    public var menuId:int;		
		
	    /** menuNameプロパティ */
	    public var menuName:String;
	    
	   	/** priceプロパティ */
	    public var price:int;
	    
	   	/** optionKindListプロパティ */
	    public var optionKindList:ArrayCollection;
	    
	    /** commentプロパティ */
	    public var comment:String;
	    
	   	/** optionsプロパティ */
	    public var options:ArrayCollection;
	    
	    /** limitプロパティ */
	    public var limit:Date;
	    
	    /** photoプロパティ */
	    public var photo:ByteArray;
	    
	    /** menuCategoryIdプロパティ */
	    public var menuCategoryId:int;
	}
}