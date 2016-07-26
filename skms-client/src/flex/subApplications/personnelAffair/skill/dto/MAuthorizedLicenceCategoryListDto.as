package subApplications.personnelAffair.skill.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 認定資格カテゴリーマスタリストDtoです。
	 *
	 * @author t-ito
	 *
	 */	
	public class MAuthorizedLicenceCategoryListDto
	{
		/** 認定資格カテゴリーマスタリスト */
		private var _mAuthorizedLicenceCategoryList:ArrayCollection;		
		
		public function MAuthorizedLicenceCategoryListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:MAuthorizedLicenceCategoryDto in object){
				tmpArray.push(tmp);
			} 
			_mAuthorizedLicenceCategoryList = new ArrayCollection(tmpArray);						
		}
		
		/**
		 * 認定資格カテゴリーマスタリスト取得
		 */
		public function get mAuthorizedLicenceCategoryList():ArrayCollection
		{
			return _mAuthorizedLicenceCategoryList;
		}		
	}
}