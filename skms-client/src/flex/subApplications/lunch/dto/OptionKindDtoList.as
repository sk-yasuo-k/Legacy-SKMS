package subApplications.lunch.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 選択オプション一覧Dto
	 * @author t-ito
	 */	
	public class OptionKindDtoList
	{
		private var _optiont:ArrayCollection;
		
		public function OptionKindDtoList(obj:Object)
		{
			var tmpArray:Array = new Array();
			
			for each(var tmp:OptionKindDto in obj) {
				tmpArray.push(tmp);
			}
			
			_optiont = new ArrayCollection(tmpArray);						
		}

		public function get option():ArrayCollection
		{
			return _optiont; 
		}		
	}
}