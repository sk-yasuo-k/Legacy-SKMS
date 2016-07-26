package services.personnelAffair.license.entity;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 住宅手当エンティティクラス
 * 
 */
@Entity
public class MStaffHousingAllowance implements Serializable {

    private static final long serialVersionUID = 1L;

    /** staffIdプロパティ(社員ID) */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer staffId;

    /** updateCountプロパティ(更新回数) */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer updateCount;

    /** applyDateプロパティ(適用開始日) */
    @Column(nullable = true, unique = false)
    public Date applyDate;

    /** housingIdプロパティ(住宅手当ID) */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer housingId;

    /** registrationTimeプロパティ(登録日時) */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ(登録者ID) */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;

//    /** MHousingAllowance関連プロパティ */
//    @ManyToOne
//    @JoinColumn(name = "housing_id", referencedColumnName = "housing_id")
//    public MHousingAllowance MHousingAllowance;
//
//    /** MHousingAllowance2関連プロパティ */
//    @ManyToOne
//    @JoinColumn(name = "housing_id", referencedColumnName = "housing_id")
//    public MHousingAllowance MHousingAllowance2;
}