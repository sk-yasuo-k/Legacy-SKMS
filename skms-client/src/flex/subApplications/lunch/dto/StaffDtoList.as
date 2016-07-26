package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	public class StaffDtoList
	{
		private var _staffList:ArrayCollection;
		
		public function StaffDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:VCurrentStaffNameDto in obj){
				tmpArray.push(tmp);
			}
			staffList = new ArrayCollection(tmpArray);			
		}
		
		public function get staffList():ArrayCollection { return _staffList; }		
		public function set staffList(value:ArrayCollection):void { _staffList = value; }

	}
}