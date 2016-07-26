package subApplications.personnelAffair.dto
{
	import mx.collections.ArrayCollection;
	
	import subApplications.personnelAffair.skill.dto.StaffOtherLocenceDto;	

	/**
	 * 社員所持その他資格情報リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class StaffOtherLocenceListDto
	{	
		/**
		 * リスト
		 */
		private var _staffOtherLocenceList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function StaffOtherLocenceListDto(object:Object)
		{	
			var tmpArray:Array = new Array();
			for each(var tmp:StaffOtherLocenceDto in object)
			{	
					tmpArray.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			_staffOtherLocenceList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * リスト取得
		 */
		public function get StaffOtherLocenceList():ArrayCollection
		{	
			// リストを取得元に返す	
			return _staffOtherLocenceList;
		}		
	}	
}
