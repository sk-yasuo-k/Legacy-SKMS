package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * オプションリストDto
	 * @author t-ito
	 */
	public class OptionDtoList
	{
		private var _optionList:ArrayCollection;
		
		public function OptionDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:OptionDto in obj) {
				tmpArray.push(tmp);
			}
			
			_optionList = new ArrayCollection(tmpArray);			
		}
		
		public function get optionList():ArrayCollection
		{
			return _optionList; 
		}		
		
	}
}