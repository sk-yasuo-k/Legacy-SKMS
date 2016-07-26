package subApplications.generalAffair.dto
{
	import dto.LabelDto;
	import mx.collections.ArrayCollection;
	
	/**
	 * リストラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class CommitteeListLabelDto
	{
		private var _committeeLabel:ArrayCollection;	
		
		/**
		 * コンストラクタ
		 */
		public function CommitteeListLabelDto(object:Object)
		{
			var Array:Array = new Array();
			
			for each(var committeeDto:CommitteeDto in object)
			{
				var tmp:LabelDto = new LabelDto();
				tmp.label = committeeDto.fullName;
				tmp.data = committeeDto.staffId;
				Array.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			_committeeLabel = new ArrayCollection(Array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get CommitteeListLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return _committeeLabel;
		}
	}	
}
