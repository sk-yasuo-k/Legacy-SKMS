package subApplications.lunch.dto{	
	import mx.collections.ArrayCollection;
	
	
	/**
	 * MenuOrderDto
	 * 
	 */	
	[Bindable]	[RemoteClass(alias="services.lunch.dto.MenuOrderDto")]		public class MenuOrderDto{
	
	    /** idプロパティ */
	    public var id:int;
	
	    /** staffIdプロパティ */
	    public var staffId:int;
	
	    /** orderDateプロパティ */
	    public var orderDate:Date ;
	
	    /** shopMenuIdプロパティ */
	    public var shopMenuId:int;	
	    /** registrationIdプロパティ */
	    public var registrationId:int;
	
	    /** numberプロパティ */
	    public var number:int;
	
	    /** registrationDateプロパティ */
	    public var registrationDate:Date ;
	
	    /** cancelプロパティ */
	    public var cancel:Boolean;
	
	    /** MStaff関連プロパティ 
	    public var MStaffDto:MStaffDto;*/
	    
		/** 社員名情報です。*/
		public var vCurrentStaffName:VCurrentStaffNameDto;
	
	    /** shopMenu関連プロパティ */
	    public var shopMenu:ShopMenuDto;
	
	    /** menuOrderOptionList関連プロパティ */
	    public var menuOrderOptionList:ArrayCollection;	    	    /** orderMenuNameプロパティ */	    public function get orderMenuName():String	    {	    	var tmpStr:String = new String();	    	for each(var tmp:MenuOrderOptionDto in menuOrderOptionList){				tmpStr += "[" + tmp.option.optionDisplayName + "]";	    	}	    		    	return shopMenu.mMenu.menuName + tmpStr;	    }	    	    /** orderPriceプロパティ */	    public function get orderPrice():int	    {	    	var tmpPrice:int = 0;		    	for each(var tmp:MenuOrderOptionDto in menuOrderOptionList){		   			tmpPrice += tmp.option.price;		    	}	    		    	return (shopMenu.mMenu.price + tmpPrice) * number;	    }	    	    /** checkBoxプロパティ */	    public var checkBox:Boolean;	    /** orderStateプロパティ */	    public function get orderState():String	    {	    	var tmpStr:String = new String();	    	if(cancel){	    		tmpStr = "";	    	}else{	    		tmpStr = "注文済";
	    	}	    		    	return tmpStr;
	    }	    		/** staffNameプロパティ*/		public function get staffName():String		{			var tmpStr:String = new String();						tmpStr = vCurrentStaffName.fullName;						return tmpStr;		}
	}	}