package services.personnelAffair.license.entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 技能手当マスタエンティティクラス
 * 
 */
@Entity
public class MTechnicalSkillAllowance implements Serializable {

    private static final long serialVersionUID = 1L;

    /** technicalSkillIdプロパティ(技能手当ID)*/
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer technicalSkillId;

    /** classNoプロパティ(等級)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer classNo;

    /** monthlySumプロパティ(月額)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer monthlySum;
    
//    /** MStaffQualificationList関連プロパティ */
//    @OneToMany(mappedBy = "MTechnicalSkillAllowance")
//    public List<MStaffQualification> MStaffQualificationList;
//
//    /** MStaffQualificationList2関連プロパティ */
//    @OneToMany(mappedBy = "MTechnicalSkillAllowance2")
//    public List<MStaffQualification> MStaffQualificationList2;
}