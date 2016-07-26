package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;

	/**
	 * 基本給【号】ラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MBasicRankLabelDto
	{	
		private var mBasicPayRankLabel:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MBasicRankLabelDto(object:Object)
		{	
			var array:Array = new Array();
			
			for each(var mBasicRankDto:MBasicRankDto in object)
			{	
				var tmp:LabelDto = new LabelDto();
				var label:String = "" + mBasicRankDto.rankNo;	

				tmp.label = label;
				tmp.data = mBasicRankDto.classNo;
				tmp.data2 = "" + mBasicRankDto.basicPayId;
				tmp.data3 = mBasicRankDto.monthlySum;
				array.push(tmp);		
			}
			
			// DTOの型に変換したものを、リストに追加する
			mBasicPayRankLabel = new ArrayCollection(array);
		}
				
		/**
		 * リストラベル取得
		 */	
		public function get MBasicPayRankLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return mBasicPayRankLabel;
		}
	}	
}
