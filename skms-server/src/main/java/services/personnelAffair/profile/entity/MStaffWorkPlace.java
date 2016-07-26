package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 * MStaffWorkPlaceエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MStaffWorkPlace implements Serializable {

    private static final long serialVersionUID = 1L;

    /** staffIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer staffId;

    /** updateCountプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer updateCount;

    /** applyDateプロパティ */
    @Column(nullable = true, unique = false)
    public Date applyDate;

    /** workPlaceIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer workPlaceId;

    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;

    /** MWorkPlace関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "work_place_id", referencedColumnName = "work_place_id")
    public MWorkPlace MWorkPlace;

    /** MWorkPlace2関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "work_place_id", referencedColumnName = "work_place_id")
    public MWorkPlace MWorkPlace2;
 
    /** ProfileDetail関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    public ProfileDetail ProfileDetail;    
}