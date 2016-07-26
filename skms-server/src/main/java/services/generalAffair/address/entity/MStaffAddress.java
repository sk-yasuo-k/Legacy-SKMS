package services.generalAffair.address.entity;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;

import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

/**
 * 社員住所マスタエンティティクラス
 * 
 * 
 * @author t-ito
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MStaffAddress implements Serializable {

    private static final long serialVersionUID = 1L;

    /** staffIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer staffId;

    /** updateCountプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer updateCount;

    /** moveDateプロパティ */
    @Column(nullable = false, unique = false)
    public Date moveDate;

    /** postalCode1プロパティ */
    @Column(name = "postal_code_1", length = 3, nullable = false, unique = false)
    public String postalCode1;

    /** postalCode2プロパティ */
    @Column(name = "postal_code_2", length = 4, nullable = false, unique = false)
    public String postalCode2;

    /** prefectureCodeプロパティ */
    @Column(length = 2, nullable = false, unique = false)
    public String prefectureCode;

    /** wardプロパティ */
    @Column(length = 32, nullable = false, unique = false)
    public String ward;

    /** houseNumberプロパティ */
    @Column(length = 32, nullable = false, unique = false)
    public String houseNumber;

    /** homePhoneNo1プロパティ */
    @Column(name = "home_phone_no_1", length = 4, nullable = true, unique = false)
    public String homePhoneNo1;

    /** homePhoneNo2プロパティ */
    @Column(name = "home_phone_no_2", length = 4, nullable = true, unique = false)
    public String homePhoneNo2;

    /** homePhoneNo3プロパティ */
    @Column(name = "home_phone_no_3", length = 4, nullable = true, unique = false)
    public String homePhoneNo3;

    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;
    
    /** wardKanaプロパティ */
    @Column(length = 64, nullable = false, unique = false)
    public String wardKana;
    
    /** houseNumberKanaプロパティ */
    @Column(length = 64, nullable = false, unique = false)
    public String houseNumberKana;
    
    /** householderFlagプロパティ */
    public Boolean householderFlag;
    
    /** nameplateプロパティ */
    @Column(length = 16, nullable = false, unique = false)
    public String nameplate;
    
    /** associateStaffプロパティ */
    @Column(length = 64, nullable = false, unique = false)
    public String associateStaff;
    
    /** prefectureCode関連プロパティ */
    @OneToOne
    @JoinColumn(name = "prefecture_code", referencedColumnName = "code")
    public MPrefecture mPrefecture;
    
    /** updateCount関連プロパティ */
    @OneToMany(mappedBy = "mStaffAddress")
    public List<StaffAddressHistory> staffAddressHistory;

}