package subApplications.personnelAffair.profile.dto
{
	import mx.collections.ArrayCollection;
	
	public class ProfileDetailDataDto
	{
		/**
		 * プロフィール詳細データです。
		 */
		private var profileDetailData:ProfileDetailDto;
				
		public function ProfileDetailDataDto(object:Object)
		{
			profileDetailData = object as ProfileDetailDto;
		}
		
		/**
		 * プロフィール詳細データ取得
		 * 
		 * @return プロフィールデータ詳細
		 */
		public function get ProfileDetailData():ProfileDetailDto
		{
			return profileDetailData;
		}		
	}
}