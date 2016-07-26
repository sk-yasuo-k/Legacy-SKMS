package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * MStaffHandyPhoneエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MStaffHandyPhone implements Serializable {

    private static final long serialVersionUID = 1L;

    /** staffIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer staffId;

    /** updateCountプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer updateCount;

    /** handyPhoneNo1プロパティ */
    @Column(name = "handy_phone_no_1", length = 4, nullable = true, unique = false)
    public String handyPhoneNo1;

    /** handyPhoneNo2プロパティ */
    @Column(name = "handy_phone_no_2", length = 4, nullable = true, unique = false)
    public String handyPhoneNo2;

    /** handyPhoneNo3プロパティ */
    @Column(name = "handy_phone_no_3", length = 4, nullable = true, unique = false)
    public String handyPhoneNo3;

    /** handyPhoneEmailプロパティ */
    @Column(length = 64, nullable = true, unique = false)
    public String handyPhoneEmail;

    /** openHandyPhoneNoプロパティ */
    @Column(length = 1, nullable = true, unique = false)
    public Boolean openHandyPhoneNo;

    /** openHandyPhoneEmailプロパティ */
    @Column(length = 1, nullable = true, unique = false)
    public Boolean openHandyPhoneEmail;

    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;
}