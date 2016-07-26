package subApplications.personnelAffair.dto
{
	import mx.collections.ArrayCollection;
	
	import subApplications.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;	

	/**
	 * 社員所持認定資格情報リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class StaffAuthorizedLocenceListDto
	{	
		/**
		 * リスト
		 */
		private var _staffAuthorizedLocenceList:ArrayCollection;
		
		/**
		 * コンストラクタ
		 */
		public function StaffAuthorizedLocenceListDto(object:Object)
		{	
			var tmpArray:Array = new Array();
			
			for each(var tmp:StaffAuthorizedLicenceDto in object)
			{	
				tmpArray.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			_staffAuthorizedLocenceList = new ArrayCollection(tmpArray);
		}
		
		/**
		 * リスト取得
		 */
		public function get StaffAuthorizedLocenceList():ArrayCollection
		{	
			// リストを取得元に返す	
			return _staffAuthorizedLocenceList;
		}
	}	
}
