package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;

	/**
	 * 認定資格手当ラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MInformationAllowanceLabelDto
	{
		private var mInformationAllowanceLabel:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MInformationAllowanceLabelDto(object:Object)
		{	
			var array:Array = new Array();
			var nullFalg:Boolean = true;

			for each(var mInformationAllowanceDto:Object in object)
			{	
				var tmp:LabelDto = new LabelDto();			
				var Label:String = mInformationAllowanceDto.informationPayName;	
						
				tmp.label = Label;
				tmp.data = mInformationAllowanceDto.informationPayId;
				tmp.data3 = mInformationAllowanceDto.monthlySum;	

				array.push(tmp);
			}
			
			// DTOの型に変換したものを、リストに追加する
			mInformationAllowanceLabel = new ArrayCollection(array);
		}
		
		/**
		 * ラベル取得
		 */	
		public function get MInformationAllowanceLabel():ArrayCollection
		{
			// ラベルを取得元に返す	
			return mInformationAllowanceLabel;
		}
	}	
}
