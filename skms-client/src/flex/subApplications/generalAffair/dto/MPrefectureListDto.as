package subApplications.generalAffair.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 都道府県名リストDtoです。
	 *
	 * @author t-ito
	 *
	 */
	public class MPrefectureListDto
	{
		/** 都道府県名リスト */
		private var _mPrefectureList:ArrayCollection; 
		
		/** 
		 * コンストラクタ 
		 */
		public function MPrefectureListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:MPrefectureDto in object){
				var label:LabelDto = new LabelDto();
				label.data  = tmp.code;
				label.label = tmp.name;
				tmpArray.push(label);
			} 
			_mPrefectureList = new ArrayCollection(tmpArray);
		}

		/** 
		 * 都道府県名リスト取得
		 */			
		public function get MPrefectureList():ArrayCollection
		{
			return _mPrefectureList;
		}
	}
}