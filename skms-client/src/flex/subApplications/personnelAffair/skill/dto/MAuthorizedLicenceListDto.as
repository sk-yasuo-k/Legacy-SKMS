package subApplications.personnelAffair.skill.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 認定資格マスタリストDtoです。
	 *
	 * @author t-ito
	 *
	 */
	public class MAuthorizedLicenceListDto
	{
		/** 認定資格マスタリスト */
		private var _mAuthorizedLicenceList:ArrayCollection;		

		/**
		 * コンストラクタ
		 */		
		public function MAuthorizedLicenceListDto(object:Object)
		{
			var tmpArray:Array = new Array();
			for each(var tmp:MAuthorizedLicenceDto in object){
				tmpArray.push(tmp);
			} 
			_mAuthorizedLicenceList = new ArrayCollection(tmpArray);			
		}

		/**
		 * 認定資格マスタリスト取得
		 */
		public function get mAuthorizedLicenceList():ArrayCollection
		{
			return _mAuthorizedLicenceList;
		}
	}
}