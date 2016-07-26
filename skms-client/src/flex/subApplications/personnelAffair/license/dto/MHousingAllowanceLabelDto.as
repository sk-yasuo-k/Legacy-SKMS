package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;

	import mx.collections.ArrayCollection;

	/**
	 * 住宅手当ラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MHousingAllowanceLabelDto
	{
		private var mHousingAllowanceLabel:ArrayCollection;	
		
		/**
		 * コンストラクタ
		 */
		public function MHousingAllowanceLabelDto(object:Object)
		{
			var array:Array = new Array();
			var nullFalg:Boolean = true;

			for each(var mHousingAllowanceDto:MHousingAllowanceDto in object)
			{
				var tmp:LabelDto = new LabelDto();			
				var Label:String = mHousingAllowanceDto.housingName;
						
				tmp.label = Label;
				tmp.data = mHousingAllowanceDto.housingId;
				tmp.data3 = mHousingAllowanceDto.monthlySum;

				array.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			mHousingAllowanceLabel = new ArrayCollection(array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get MHousingAllowanceLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return mHousingAllowanceLabel;
		}
	}	
}
