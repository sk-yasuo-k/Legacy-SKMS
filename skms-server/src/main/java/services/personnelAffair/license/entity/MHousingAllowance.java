package services.personnelAffair.license.entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 住宅手当マスタエンティティクラス
 * 
 */
@Entity
public class MHousingAllowance implements Serializable {

    private static final long serialVersionUID = 1L;

    /** housingIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer housingId;

    /** housingNameプロパティ */
    @Column(length = 32, nullable = true, unique = false)
    public String housingName;

    /** monthlySumプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer monthlySum;
//
//    /** MStaffHousingAllowanceList関連プロパティ */
//    @OneToMany(mappedBy = "MHousingAllowance")
//    public List<MStaffHousingAllowance> MStaffHousingAllowanceList;
//
//    /** MStaffHousingAllowanceList2関連プロパティ */
//    @OneToMany(mappedBy = "MHousingAllowance2")
//    public List<MStaffHousingAllowance> MStaffHousingAllowanceList2;
}