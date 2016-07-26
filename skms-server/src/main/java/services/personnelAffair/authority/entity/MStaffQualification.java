package services.personnelAffair.authority.entity;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import services.personnelAffair.license.entity.MCompetentAllowance;
import services.personnelAffair.license.entity.MManagerialAllowance;
import services.personnelAffair.license.entity.MTechnicalSkillAllowance;
import services.personnelAffair.profile.entity.MBasicPay;

/**
 * MStaffQualificationエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MStaffQualification implements Serializable {

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

    /** basicPayIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer basicPayId;

    /** technicalSkillIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer technicalSkillId;

    /** competentIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer competentId;

    /** managerialIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer managerialId;

    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;

    /** MBasicPay関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "basic_pay_id", referencedColumnName = "basic_pay_id")
    public MBasicPay MBasicPay;

//    /** MBasicPay2関連プロパティ */
//    @ManyToOne
//    @JoinColumn(name = "basic_pay_id", referencedColumnName = "basic_pay_id")
//    public MBasicPay MBasicPay2;

    /** MCompetentAllowance関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "competent_id", referencedColumnName = "competent_id")
    public MCompetentAllowance MCompetentAllowance;

//    /** MCompetentAllowance2関連プロパティ */
//    @ManyToOne
//    @JoinColumn(name = "competent_id", referencedColumnName = "competent_id")
//    public MCompetentAllowance MCompetentAllowance2;

    /** MManagerialAllowance関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "managerial_id", referencedColumnName = "managerial_id")
    public MManagerialAllowance MManagerialAllowance;

//    /** MManagerialAllowance2関連プロパティ */
//    @ManyToOne
//    @JoinColumn(name = "managerial_id", referencedColumnName = "managerial_id")
//    public MManagerialAllowance MManagerialAllowance2;

    /** MTechnicalSkillAllowance関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "technical_skill_id", referencedColumnName = "technical_skill_id")
    public MTechnicalSkillAllowance MTechnicalSkillAllowance;

//    /** MTechnicalSkillAllowance2関連プロパティ */
//    @ManyToOne
//    @JoinColumn(name = "technical_skill_id", referencedColumnName = "technical_skill_id")
//    public MTechnicalSkillAllowance MTechnicalSkillAllowance2;
}