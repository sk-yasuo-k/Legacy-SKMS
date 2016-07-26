package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;	

	/**
	 * 資格手当取得履歴リストDtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class MPayLicenceHistoryListDto
	{	
		/**
		 * リスト
		 */
		private var mPayLicenceHistoryList:ArrayCollection;
		
		/**
		 * 配列格納フラグ
		 */
		private var resultRecordCountFlag:Boolean = false;
		
		/**
		 * コンストラクタ
		 */
		public function MPayLicenceHistoryListDto(object:Object ,mBasicClassList:ArrayCollection ,mBasicRankList:ArrayCollection ,mManagerialAllowance:ArrayCollection ,mCompetentAllowance:ArrayCollection ,mTechnicalSkillAllowance:ArrayCollection ,mAuthorizedLicenceAllowance:ArrayCollection ,mHousingAllowance:ArrayCollection)
		{	
			var tmpArray:Array = new Array();
			for each(var tmp:MPayLicenceHistoryDto in object)
			{				
				// 基本給が存在している場合
				if(tmp.basicPayMonthlySum != 0)
				{
					// 超過勤務手当計算(基本給×0.35)
					tmp.exceedServiceSalary = (tmp.basicPayMonthlySum*0.35);
				}
				else
				{
					// 超過勤務手当計算(null対策)
					tmp.exceedServiceSalary = 0;
				}
				
				// 総額給与(基本給 + 職務手当 + 主務手当 + 技能手当 + 認定資格手当 + 住宅手当 + 超過勤務手当)
				tmp.totalAllowance = (tmp.basicPayMonthlySum + tmp.managerialMonthlySum + tmp.competentMonthlySum + tmp.technicalSkillMonthlySum + tmp.informationPayMonthlySum + tmp.housingPayMonthlySum + tmp.exceedServiceSalary);
					
				// 総額給与【ComboBox変更】(基本給 + 職務手当 + 主務手当 + 技能手当 + 資格手当 + 住宅手当 + 超過勤務手当)
				tmp.TotalAllowance = (tmp.BasicPayMonthlySum + tmp.ManagerialMonthlySum + tmp.CompetentMonthlySum + tmp.TechnicalSkillMonthlySum + tmp.InformationPayMonthlySum + tmp.HousingPayMonthlySum + tmp.ExceedServiceSalary);

				// 基本給【等級】マスタ				
				tmp.mBasicClassList = mBasicClassList;

				// 基本給【号】マスタ				
				tmp.mBasicRankList = mBasicRankList;				
				
				// 職務手当マスタ
				tmp.mManagerialAllowance = mManagerialAllowance;
				
				// 主務手当マスタ
				tmp.mCompetentAllowance = mCompetentAllowance;
				
				// 技能手当マスタ
				tmp.mTechnicalSkillAllowance = mTechnicalSkillAllowance;

				// 認定資格手当マスタ			
				tmp.mAuthorizedLicenceAllowance = mAuthorizedLicenceAllowance;
				
				// 住宅手当マスタ			
				tmp.mHousingAllowance = mHousingAllowance;
				
				tmpArray.push(tmp);
			} 
			// DTOの型に変換したものを、リストに追加する
			mPayLicenceHistoryList = new ArrayCollection(tmpArray);	
			
			// 表示するレコードが無い場合
			if(mPayLicenceHistoryList.length == 0)
			{
				resultRecordCountFlag = true;
			}
		}
		
		/**
		 * リスト取得
		 */
		public function get MPayLicenceHistoryList():ArrayCollection
		{	
			// リストを取得元に返す	
			return mPayLicenceHistoryList;
		}
		
		/**
		 * フラグ取得
		 */
		public function get ResultRecordCountFlag():Boolean
		{	
			// フラグを取得元に返す	
			return resultRecordCountFlag;
		}							
	}	
}
