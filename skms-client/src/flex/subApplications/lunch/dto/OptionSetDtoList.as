package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * オプションセット一覧Dto
	 * @author t-ito
	 */			
	public class OptionSetDtoList
	{
		private var _optionSetList:ArrayCollection;
		private var _optionKindList:ArrayCollection;
		
		public function OptionSetDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			var tmpOptionKind:Array = new Array();
			
			if(obj != null){
				for each(var tmp:OptionSetDto in obj) {
					tmpArray.push(tmp);
					tmpOptionKind.push(tmp.mOptionKind);
				}
			}
			
			_optionSetList = new ArrayCollection(tmpArray);
			_optionKindList = new ArrayCollection(tmpOptionKind);
		}

		public function get optionSetList():ArrayCollection
		{
			return _optionSetList; 
		}
		
		public function get optionKindList():ArrayCollection
		{
			return _optionKindList; 
		}		
	}
}