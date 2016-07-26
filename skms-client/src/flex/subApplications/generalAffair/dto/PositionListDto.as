package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	import subApplications.generalAffair.dto.CommitteeDto;	

	public class PositionListDto
	{
		private var _positionList:ArrayCollection;	
		
		public function PositionListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:CommitteeDto in object){
				tmpArray.push(tmp);
			} 
			_positionList = new ArrayCollection(tmpArray);
		}
			
		public function get PositionList():ArrayCollection
		{
			return _positionList;
		}
	}	
}
