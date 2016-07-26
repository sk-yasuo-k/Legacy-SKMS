package subApplications.personnelAffair.profile.dto
{
	public class DisplayItemsShowDataDto
	{
		/**
		 * 表示項目表示可否データです。
		 */
		public var displayItemsShowData:DisplayItemsShowDto;
		
		public function DisplayItemsShowDataDto(object:Object)
		{
			displayItemsShowData = object as DisplayItemsShowDto;
			
		}

		/**
		 * 表示項目表示可否データ取得
		 * 
		 * @return 表示項目表示可否データ
		 */
		public function get DisplayItemsShowData():DisplayItemsShowDto
		{
			return displayItemsShowData;
		}		
	}
}