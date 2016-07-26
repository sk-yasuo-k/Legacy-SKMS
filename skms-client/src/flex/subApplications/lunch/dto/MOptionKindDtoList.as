package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * オプション種類一覧Dto
	 * @author t-ito
	 */
	public class MOptionKindDtoList
	{
		private var _optionKindList:ArrayCollection;
		private var _option:ArrayCollection;
		
		public function MOptionKindDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			var tmpOption:Array = new Array();
			
			for each(var tmp:MOptionKindDto in obj) {
				tmpArray.push(tmp);
				tmpOption.push(tmp.optionKindList);
			}
			
			_optionKindList = new ArrayCollection(tmpArray);
			_option = new ArrayCollection(tmpOption);		
		}
		
		public function get optionKindList():ArrayCollection
		{
			return _optionKindList; 
		}	
		
		public function get option():ArrayCollection
		{
			return _option; 
		}					
	}
}