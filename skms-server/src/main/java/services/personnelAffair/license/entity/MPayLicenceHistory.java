package services.personnelAffair.license.entity;

import java.io.Serializable;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import services.generalAffair.entity.MStaff;

/**
 * 資格手当取得履歴エンティティクラス
 * 
 */
@Entity
public class MPayLicenceHistory implements Serializable {

    private static final long serialVersionUID = 1L;
    
    /** Idプロパティ(連番)*/
	@Id
	@GeneratedValue
    @Column(precision = 10, nullable = false, unique = true)
    public Integer Id;
    
    /** staffIdプロパティ(社員ID)*/
    @Column(precision = 10, nullable = false, unique = true)
    public Integer staffId;

    /** periodIdプロパティ(期ID)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer periodId;
    
    /** updateCountプロパティ(更新回数)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer updateCount;

    /** basicPayIdプロパティ(基本給ID)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer basicPayId;

    /** basicPayClassNoプロパティ(等級【基本給】)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer basicPayClassNo;
    
    /** basicPayClassNoNameプロパティ(等級名【基本給】)*/
    @Column(precision = 10, nullable = true, unique = false)
    public String basicPayClassNoName;

    /** basicPayRankNoプロパティ(号【基本給】)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer basicPayRankNo;
    
    /** basicPayMonthlySumプロパティ(基本給)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer basicPayMonthlySum;

    /** technicalSkillIdプロパティ(技能手当ID)*/
    public Integer technicalSkillId;
    
    /** technicalSkillClassNoプロパティ(等級【技能手当】)*/
    public Integer technicalSkillClassNo;
    
    /** technicalSkillMonthlySumプロパティ(技能手当)*/
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
    
    /** informationPayMonthlySumプロパティ(情報処理手当)*/
    public Integer informationPayMonthlySum;
    
    /** housingIdプロパティ(住宅手当ID)*/
    public Integer housingId;
    
    /** housingNameプロパティ(住宅手当名)*/
    public String housingName;
    
    /** housingPayMonthlySumプロパティ(住宅手当)*/
    public Integer housingPayMonthlySum;
    
    /** registrationTimeプロパティ(登録日時)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Timestamp registrationTime;
    
    /** registrationIdプロパティ(登録者ID)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;
    
    /** MStaff関連プロパティ(社員マスタ) */
    @ManyToOne
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    public MStaff mStaff;
    
    /** MPeriod関連プロパティ(期マスタ) */
    @ManyToOne
    @JoinColumn(name = "period_id", referencedColumnName = "period_id")
    public MPeriod mPeriod;
}