package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;

	/**
	 * 基本給【等級】ラベルDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MBasicClassLabelDto
	{
		private var mBasicPayClassLabel:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function MBasicClassLabelDto(object:Object)
		{
			var array:Array = new Array();
			
			for each(var mBasicClassDto:MBasicClassDto in object)
			{
				var tmp:LabelDto = new LabelDto();
				
				tmp.label = mBasicClassDto.className;
				tmp.data = mBasicClassDto.id;
				tmp.data3 = mBasicClassDto.classId;
				
				array.push(tmp);		
			} 
			// DTOの型に変換したものを、リストに追加する
			mBasicPayClassLabel = new ArrayCollection(array);
		}
		
		/**
		 * 等級リストラベル取得
		 */	
		public function get MBasicPayClassLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return mBasicPayClassLabel;
		}
	}	
}
