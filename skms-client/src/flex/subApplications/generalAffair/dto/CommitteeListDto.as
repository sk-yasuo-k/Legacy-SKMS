package subApplications.generalAffair.dto
{
	import mx.collections.ArrayCollection;
	import subApplications.generalAffair.dto.CommitteeDto;	

	/**
	 * リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class CommitteeListDto
	{	
		/**
		 * リスト
		 */
		private var _committeeList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function CommitteeListDto(object:Object)
		{	
			var tmpArray:Array = new Array();
			for each(var tmp:CommitteeDto in object)
			{
				tmpArray.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			_committeeList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * リスト取得
		 */
		public function get CommitteeList():ArrayCollection
		{	
			// リストを取得元に返す	
			return _committeeList;
		}		
	}	
}
