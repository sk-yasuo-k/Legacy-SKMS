package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 排他オプション種類一覧Dto
	 * @author t-ito
	 */		
	public class ExclusiveOptionDtoList
	{
		private var _eclusiveOption:ArrayCollection;
		
		public function ExclusiveOptionDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:ExclusiveOptionDto in obj) {
				tmpArray.push(tmp);
			}
			
			_eclusiveOption = new ArrayCollection(tmpArray);		
		}

		public function get exclusiveOption():ArrayCollection
		{
			return _eclusiveOption; 
		}		
	}
}