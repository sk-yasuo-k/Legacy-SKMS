package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;

	/**
	 * 職務手当ラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MManagerialAllowanceLabelDto
	{
		private var mManagerialAllowanceLabel:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MManagerialAllowanceLabelDto(object:Object)
		{
			var array:Array = new Array();
			var nullFalg:Boolean = true;

			for each(var mManagerialAllowanceDto:MManagerialAllowanceDto in object)
			{				
				var tmp:LabelDto = new LabelDto();		
				var Label:String = "" + mManagerialAllowanceDto.classNo;
			
				tmp.label = Label;
				tmp.data = mManagerialAllowanceDto.managerialId;
				tmp.data3 = mManagerialAllowanceDto.monthlySum;
				
				array.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			mManagerialAllowanceLabel = new ArrayCollection(array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get MManagerialAllowanceLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return mManagerialAllowanceLabel;
		}
	}
}
