package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;

	/**
	 * 主務手当ラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MCompetentAllowanceLabelDto
	{
		private var mCompetentAllowanceLabel:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MCompetentAllowanceLabelDto(object:Object)
		{
			var array:Array = new Array();
			var nullFalg:Boolean = true;

			for each(var mCompetentAllowanceDto:MCompetentAllowanceDto in object)
			{	
				var tmp:LabelDto = new LabelDto();
			
				var Label:String = "" + mCompetentAllowanceDto.classNo;				
				tmp.label = Label;
				tmp.data = mCompetentAllowanceDto.competentId;
				tmp.data3 = mCompetentAllowanceDto.monthlySum;
				
				array.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			mCompetentAllowanceLabel = new ArrayCollection(array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get MCompetentAllowanceLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return mCompetentAllowanceLabel;
		}
	}
}
