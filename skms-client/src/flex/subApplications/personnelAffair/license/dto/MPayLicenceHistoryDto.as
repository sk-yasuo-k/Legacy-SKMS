package subApplications.personnelAffair.license.dto
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="services.personnelAffair.license.dto.MPayLicenceHistoryDto")]
	public class MPayLicenceHistoryDto
	{	
		/**
		 * 連番
		 */
    	public var Id:int;
    	
		/**
		 * 社員ID
		 */
	    public var staffId:int;
	    
	    /**
		 * 社員名
		 */
	    public var fullName:String;
	    
	    /**
		 * 期ID
		 */
    	public var periodId:int;
    	
    	/**
		 * 期名
		 */
    	public var periodName:String;
	
		/**
		 * 更新回数
		 */
	    public var updateCount:int;
	
		/**
		 * 基本給ID
		 */
	    public var basicPayId:int;
	
	    /**
		 * 等級ID(基本給)
		 */
	    public var basicPayClassNo:int;
	    
	    /**
		 * 等級名(基本給)
		 */
	    public var basicPayClassNoName:String;
	
	    /**
		 * 号(基本給)
		 */
	    public var basicPayRankNo:String;
	    
	    /**
		 * 基本給
		 */
	    public var basicPayMonthlySum:int;
	    
	    /**
		 * 基本給(ComboBox変更時)
		 */
	    public function get BasicPayMonthlySum():int
		{	
			var basicClass:String = null; 
			for each(var src:Object in this.mBasicClassList)
			{
				if(src.label == this.basicPayClassNoName)
				{
					basicClass = src.data3;
					
					for each(var tmp:Object in this.mBasicRankList)
					{				
						if((tmp.label == this.basicPayRankNo)&&(tmp.data == basicClass))
						{
							return tmp.data3;
						}
					}
				}
			}
			return 0;
		}
		
		/**
		 * 技能手当ID
		 */
	    public var technicalSkillId:int;
	    
	    /**
		 * 技能手当【等級】
		 */
	    public var technicalSkillClassNo:int;
	    
	    /**
		 * 技能手当
		 */
	    public var technicalSkillMonthlySum:int;
	    
	    /**
		 * 技能手当(ComboBox変更時)
		 */
	    public function get TechnicalSkillMonthlySum():int
		{				
			for each(var tmp:Object in this.mTechnicalSkillAllowance)
			{
				if(tmp.label == this.technicalSkillClassNo)
				{
					return tmp.data3;
				}
			}		 
			 return 0;
		}
	    
	    /**
		 * 主務手当ID
		 */
	    public var competentId:int;
	    
	    /**
		 * 主務手当【等級】
		 */
	    public var competentClassNo:int;
	    
	    /**
		 * 主務手当
		 */
	    public var competentMonthlySum:int;
	    
	    /**
		 * 主務手当(ComboBox変更時)
		 */
	    public function get CompetentMonthlySum():int
		{		
			for each(var tmp:Object in this.mCompetentAllowance)
			{
				if(tmp.label == this.competentClassNo)
				{
					return tmp.data3;
				}
			}			 
			 return 0;
		}
	    
	    /**
		 * 職務手当ID
		 */
	    public var managerialId:int;
	    
	    /**
		 * 職務手当【等級】
		 */
	    public var managerialClassNo:int;
	    
	    /**
		 * 職務手当
		 */
	    public var managerialMonthlySum:int;
	    
	    /**
		 * 職務手当(ComboBox変更時)
		 */
	    public function get ManagerialMonthlySum():int
		{				
			for each(var tmp:Object in this.mManagerialAllowance)
			{
				if(tmp.label == this.managerialClassNo)
				{
					return tmp.data3;
				}
			}
			 return 0;
		} 
	    
	    /**
		 * 処理情報手当ID
		 */
	    public var informationPayId:int;
	    
	    /**
		 * 資格手当名
		 */
	    public var informationPayName:String;
	    
	    /**
		 * 認定資格手当
		 */
	    public var informationPayMonthlySum:int;
	    
	    /**
		 * 認定資格手当(ComboBox変更時)
		 */
	    public function get InformationPayMonthlySum():int
		{				
			for each(var tmp:Object in this.mAuthorizedLicenceAllowance)
			{
				if(tmp.label == this.informationPayName)
				{
					return tmp.data3;
				}
			}			 
			 return 0;
		} 
	    
	    /**
		 * 住宅手当ID
		 */
	    public var housingId:int;
	    
	    /**
		 * 住宅手当名
		 */
	    public var housingName:String;
	    
	    /**
		 * 住宅手当
		 */
	    public var housingPayMonthlySum:int;
	    
	    /**
		 * 住宅手当(ComboBox変更時)
		 */
	    public function get HousingPayMonthlySum():int
		{				
			for each(var tmp:Object in this.mHousingAllowance)
			{
				if(tmp.label == this.housingName)
				{
					return tmp.data3;
				}
			}
			 return 0;
		}
		
		/**
		 * 超過勤務手当
		 */
	    public var exceedServiceSalary:int;

	    /**
		 * 超過勤務手当(ComboBox変更時)
		 */
	    public function get ExceedServiceSalary():int
		{	
			var basicClass:String = null;
			
			
			for each(var src:Object in this.mBasicClassList)
			{
				if(src.label == this.basicPayClassNoName)
				{
					basicClass = "" + src.data3;
					
					for each(var tmp:Object in this.mBasicRankList)
					{				
						if((tmp.label == this.basicPayRankNo)&&(tmp.data == basicClass))
						{	
							var exceedServiceSalarySum:int = (tmp.data3*35)/100;
							
							// 給与総額算出
							TotalAllowance = BasicPayMonthlySum + ManagerialMonthlySum + CompetentMonthlySum + TechnicalSkillMonthlySum + InformationPayMonthlySum + HousingPayMonthlySum + exceedServiceSalarySum;
							return exceedServiceSalarySum;
						}
					}	
				}
			}

			// 給与総額算出
			TotalAllowance = BasicPayMonthlySum + ManagerialMonthlySum + CompetentMonthlySum + TechnicalSkillMonthlySum + InformationPayMonthlySum + HousingPayMonthlySum;
			 return 0;			
		}
	    
	    /**
		 * 総額給与
		 */
	    public var totalAllowance:int;
	    
	    /**
		 * 総額給与(ComboBox変更)
		 */
	    public var TotalAllowance:int;
	    
	    /**
		 * 登録日時
		 */
	    public var registrationTime:Date;
	    
	    /**
		 * 基本給【等級】マスタ
		 */
	    public var mBasicClassList:ArrayCollection;
	    
	    /**
		 * 基本給【号】マスタ
		 */
	    public var mBasicRankList:ArrayCollection;
	    
	    /**
		 * 職務手当マスタ
		 */
	    public var mManagerialAllowance:ArrayCollection;
	    
	    /**
		 * 主務手当マスタ
		 */
	    public var mCompetentAllowance:ArrayCollection;
	    
	    /**
		 * 技能手当マスタ
		 */
	    public var mTechnicalSkillAllowance:ArrayCollection;
	    
	    /**
		 * 認定資格手当マスタ
		 */
	    public var mAuthorizedLicenceAllowance:ArrayCollection;
	    
	    /**
		 * 住宅手当マスタ
		 */
	    public var mHousingAllowance:ArrayCollection;
	}
}