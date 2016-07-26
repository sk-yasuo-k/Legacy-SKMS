package subApplications.personnelAffair.license.dto
{
	import dto.LabelDto;
	
	import mx.collections.ArrayCollection;
	
	import subApplications.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;

	/**
	 * 認定資格ラベルリストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MAuthorizedLicenceAllowanceLabelListDto
	{
		private var mAuthorizedLicenceAllowanceLabel:ArrayCollection;	
		
		/**
		 * コンストラクタ
		 */
		public function MAuthorizedLicenceAllowanceLabelListDto(object:Object)
		{
			var array:Array = new Array();

			for each(var mAuthorizedLicenceAllowanceLabelDto:StaffAuthorizedLicenceDto in object)
			{				
				var tmp:LabelDto = new LabelDto();
				tmp.label = "" + mAuthorizedLicenceAllowanceLabelDto.informationPayId;
				tmp.data = mAuthorizedLicenceAllowanceLabelDto.categoryId;
				tmp.data3 = mAuthorizedLicenceAllowanceLabelDto.monthlySum;	

				array.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			mAuthorizedLicenceAllowanceLabel = new ArrayCollection(array);
		}
		
		/**
		 * リストラベル取得
		 */	
		public function get MAuthorizedLicenceAllowanceLabel():ArrayCollection
		{
			// リストを取得元に返す	
			return mAuthorizedLicenceAllowanceLabel;
		}
	}	
}
