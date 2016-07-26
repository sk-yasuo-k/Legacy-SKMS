package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import services.generalAffair.entity.MStaff;

/**
 * SeminarApplicantエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class SeminarApplicant implements Serializable {

    private static final long serialVersionUID = 1L;

    /** seminarIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer seminarId;

    /** staffIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer staffId;

    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;

    /** MStaff関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    public MStaff MStaff;

    /** MStaff2関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    public MStaff MStaff2;

    /** seminar関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "seminar_id", referencedColumnName = "seminar_id")
    public Seminar seminar;

    /** seminar2関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "seminar_id", referencedColumnName = "seminar_id")
    public Seminar seminar2;
}