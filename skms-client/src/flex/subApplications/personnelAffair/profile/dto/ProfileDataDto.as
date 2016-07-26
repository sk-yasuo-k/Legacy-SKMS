package subApplications.personnelAffair.profile.dto
{
	import mx.collections.ArrayCollection;
	
	/**
	 * プロフィール情報データDtoです。
	 *
	 * @author yoshinori-t
	 *
	 */
	public class ProfileDataDto
	{
		/**
		 * プロフィール情報リストです。
		 */
		private var profileList:ArrayCollection;
		private var profileData:ProfileDto;
		
		/**
		 * コンストラクタ
		 */
		public function ProfileDataDto(object:Object)
		{
			// 引数のデータ数分配列を作成
			var tmpArray:Array = new Array();
			for each(var tmp:ProfileDto in object)
			{
				if(tmp.handyPhoneNo == "--"){
					tmp.handyPhoneNo = "";
				}
				
				if(tmp.basicClassNo == 0){
					tmp.basicClassNo = 9;
				}
				
				if(tmp.basicRankNo == 0){
					tmp.basicRankNo = 1;
				}
				
				tmpArray.push(tmp);
			}
			
			// 作成した配列をフィールドのプロフィール情報リストに設定
			profileList = new ArrayCollection(tmpArray);
			profileData = object as ProfileDto;
		}

		/**
		 * プロフィール情報取得
		 * 
		 * @return プロフィール情報
		 */
		public function get ProfileData():ProfileDto
		{
			return profileData;
		}
		
		/**
		 * プロフィール情報リスト取得
		 * 
		 * @return プロフィール情報リスト
		 */
		public function get ProfileList():ArrayCollection
		{
			return profileList;
		}
		
		/**
		 * プロフィール集計結果取得
		 * 
		 * @return プロフィール集計結果
		 */
		public function get TotalProfileResult():TotalProfileResultDto
		{
			var result:TotalProfileResultDto = new TotalProfileResultDto();
			
			// プロフィール情報リスト内のデータを調査
			for each(var dto:ProfileDto in profileList)
			{
				// 社員数
				result.CountStaff++;
				
				// 合計年齢
				result.TotalAge += dto.age;
				
				// 血液型
				switch ( dto.bloodGroup )
				{
				case 1:		// A型
					result.CountA++;
					break;
				case 2:		// B型
					result.CountB++;
					break;
				case 3:		// O型
					result.CountO++;
					break;
				case 4:		// AB型
					result.CountAB++;
					break;
				
				//追加 @auther okamoto
				case 9:		// 血液型不明
					result.CountUnknown++;
					break;
				}
			}
			
			// 平均年齢
			if ( result.CountStaff > 0 )
			{
				result.AverageAge = result.TotalAge / result.CountStaff;
			}
			
			return result;
		}
		
		//追加 @auther okamoto-y
		/**
		 * プロフィール集計結果取得(退職者なし)
		 * 
		 * @return プロフィール集計結果
		 */
		 public function get TotalProfileResult_NoRetire():TotalProfileResultDto
		{
			var result:TotalProfileResultDto = new TotalProfileResultDto();
			
			// プロフィール情報リスト内のデータを調査
			for each(var dto:ProfileDto in profileList)
			{
				if(dto.retireDate == null){
					// 社員数
					result.CountStaff++;
				
					// 合計年齢
					result.TotalAge += dto.age;
				
					// 血液型
					switch ( dto.bloodGroup )
					{
					case 1:		// A型
						result.CountA++;
						break;
					case 2:		// B型
						result.CountB++;
						break;
					case 3:		// O型
						result.CountO++;
						break;
					case 4:		// AB型
						result.CountAB++;
						break;
					case 9:		// 血液型不明
						result.CountUnknown++;
						break;
					}
				}
			}
			
			// 平均年齢
			if ( result.CountStaff > 0 )
			{
				result.AverageAge = result.TotalAge / result.CountStaff;
			}
			
			return result;
		} 
	}
}