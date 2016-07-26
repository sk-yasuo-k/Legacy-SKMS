package services.personnelAffair.license.entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 主務手当マスタエンティティクラス
 * 
 */
@Entity
public class MCompetentAllowance implements Serializable {

    private static final long serialVersionUID = 1L;

    /** competentIdプロパティ(主務手当ID)*/
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer competentId;

    /** classNoプロパティ(等級)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer classNo;

    /** monthlySumプロパティ(月額)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer monthlySum;
    
//    /** MStaffQualificationList関連プロパティ */
//    @OneToMany(mappedBy = "MCompetentAllowance")
//    public List<MStaffQualification> MStaffQualificationList;
//
//    /** MStaffQualificationList2関連プロパティ */
//    @OneToMany(mappedBy = "MCompetentAllowance2")
//    public List<MStaffQualification> MStaffQualificationList2;
}