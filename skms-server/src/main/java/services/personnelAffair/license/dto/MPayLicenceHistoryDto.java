package services.personnelAffair.license.dto;

/**
 * 資格手当取得履歴Dtoです。
 *
 * @author n-sumi
 *
 */
import java.sql.Timestamp;

public class MPayLicenceHistoryDto {

    /** Idプロパティ(連番)*/
    public Integer Id;
    
    /** staffIdプロパティ(社員ID)*/
    public Integer staffId;
    
    /** staffIdプロパティ(社員名)*/
    public String fullName;

    /** periodIdプロパティ(期ID)*/
    public Integer periodId;
    
    /** periodNameプロパティ(期名)*/
    public String periodName;
    
    /** updateCountプロパティ(更新回数)*/
    public Integer updateCount;

    /** basicPayIdプロパティ(基本給ID)*/
    public Integer basicPayId;    

    /** basicPayClassNoプロパティ(等級ID【基本給】)*/
    public Integer basicPayClassNo;
    
    /** basicPayClassNoNameプロパティ(等級名【基本給】)*/
    public String basicPayClassNoName;

    /** basicPayRankNoプロパティ(号【基本給】)*/
    public Integer basicPayRankNo;
    
    /** basicPayMonthlySumプロパティ(基本給)*/
    public Integer basicPayMonthlySum;

    /** technicalSkillIdプロパティ(技能手当ID)*/
    public Integer technicalSkillId;
    
    /** technicalClassNoプロパティ(等級【技能手当】)*/
    public Integer technicalSkillClassNo;
    
    /** technicalMonthlySumプロパティ(技能手当)*/
    public Integer technicalSkillMonthlySum;
    
    /** competentIdプロパティ(主務手当ID)*/
    public Integer competentId;
    
    /** competentClassNoプロパティ(等級【主務手当】)*/
    public Integer competentClassNo;
    
    /** competentMonthlySumプロパティ(主務手当)*/
    public Integer competentMonthlySum;
    
    /** managerialIdプロパティ(職務手当ID)*/
    public Integer managerialId;
    
    /** managerialClassNoプロパティ(等級【職務手当】)*/
    public Integer managerialClassNo;
    
    /** managerialMonthlySumプロパティ(職務手当)*/
    public Integer managerialMonthlySum;
    
    /** informationPayIdプロパティ(情報処理手当ID)*/
    public Integer informationPayId;
    
    /** informationPayIdプロパティ(情報処理手当名)*/
    public String informationPayName;
    
    /** informationMonthlySumプロパティ(情報処理手当)*/
    public Integer informationPayMonthlySum;
    
    /** housingIdプロパティ(住宅手当ID)*/
    public Integer housingId;
    
    /** housingNameプロパティ(住宅手当名)*/
    public String housingName;
    
    /** housingPayMonthlySumプロパティ(住宅手当)*/
    public Integer housingPayMonthlySum;
    
    /** registrationIdプロパティ(登録者ID)*/
    public Integer registrantId;
    
    /** registrationTimeプロパティ(登録日時)*/
    public Timestamp registrationTime;
}
