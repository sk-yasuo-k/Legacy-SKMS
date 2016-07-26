package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	
	/**
	 * オプションセット一覧Dto
	 * @author t-ito
	 */	
	public class MOptionSetDtoList
	{
		private var _mOptionSet:ArrayCollection;		
		
		public function MOptionSetDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			var initialData:MOptionSetDto = new MOptionSetDto();
			initialData.id = 0;
			initialData.optionName = "なし"
			tmpArray.push(initialData);
			
			for each(var tmp:MOptionSetDto in obj) {
				tmpArray.push(tmp);
			}
			
			_mOptionSet = new ArrayCollection(tmpArray);			
		}
		
		public function get mOptionSetList():ArrayCollection
		{
			return _mOptionSet; 
		}
	}
}