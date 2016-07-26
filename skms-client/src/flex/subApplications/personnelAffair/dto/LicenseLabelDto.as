package subApplications.personnelAffair.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;
	
	import subApplications.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
	
	/**
	 * 認定カテゴリ名ラベルリストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class LicenseLabelDto
	{
		private var _licenseLabel:ArrayCollection;	
		
		/**
		 * コンストラクタ
		 */
		public function LicenseLabelDto(object:Object)
		{
			var Array:Array = new Array();
			var LicenseCount:int = 1;
			
			for each(var staffAuthorizedLicenceDto:StaffAuthorizedLicenceDto in object)
			{		
				// ループが初回以外の場合	
				if(LicenseCount != 1)
				{
					var LicenseId:int = tmp.data;
				}
				
				var tmp:LabelDto = new LabelDto();
				tmp.label = staffAuthorizedLicenceDto.categoryName;
				tmp.data = staffAuthorizedLicenceDto.categoryId;			
				
				// 前回のカテゴリIDと等しくない場合
				if(LicenseId != staffAuthorizedLicenceDto.categoryId)
				{
					Array.push(tmp);
				}
					LicenseCount = LicenseCount + 1;			
			} 
			// DTOの型に変換したものを、リストに追加する
			_licenseLabel = new ArrayCollection(Array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get LicenseListLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return _licenseLabel;
		}
	}	
}
