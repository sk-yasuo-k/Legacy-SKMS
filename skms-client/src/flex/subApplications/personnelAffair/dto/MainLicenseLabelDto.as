package subApplications.personnelAffair.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;
	
	import subApplications.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
	
	/**
	 * 認定資格名ラベルリストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MainLicenseLabelDto
	{
		private var _mainLicenseLabel:ArrayCollection;	
		
		/**
		 * コンストラクタ
		 */
		public function MainLicenseLabelDto(object:Object)
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
				tmp.label = staffAuthorizedLicenceDto.licenceName;
				tmp.data = staffAuthorizedLicenceDto.licenceId;
				tmp.data2 = staffAuthorizedLicenceDto.categoryId.toString();
				
				// 前回の資格IDと等しくない場合
				if(LicenseId != staffAuthorizedLicenceDto.licenceId)
				{	
						Array.push(tmp);
				}
					LicenseCount = LicenseCount + 1;			
			} 
			// DTOの型に変換したものを、リストに追加する
			_mainLicenseLabel = new ArrayCollection(Array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get MainLicenseListLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return _mainLicenseLabel;
		}
	}	
}
