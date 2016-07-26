package services.lunch.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.address.entity.MPrefecture;

/**
 * MLunchShopエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:56")
public class MLunchShop implements Serializable {

    private static final long serialVersionUID = 1L;

    /** shopIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer shopId;

    /** shopNameプロパティ */
    @Column(length = 32, nullable = true, unique = false)
    public String shopName;

    /** orderLimitTimeプロパティ */
    @Column(length = 2147483647, nullable = true, unique = false)
    public String orderLimitTime;

    /** shopUrlプロパティ */
    @Column(length = 256, nullable = true, unique = false)
    public String shopUrl;

    /** sortOrderプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer sortOrder;

    /** postalCode1プロパティ */
    @Column(name = "postal_code_1", length = 3, nullable = true, unique = false)
    public String postalCode1;

    /** postalCode2プロパティ */
    @Column(name = "postal_code_2", length = 4, nullable = true, unique = false)
    public String postalCode2;

    /** prefectureCodeプロパティ */
    @Column(length = 2, nullable = true, unique = false)
    public String prefectureCode;

    /** wardプロパティ */
    @Column(length = 32, nullable = true, unique = false)
    public String ward;

    /** houseNumberプロパティ */
    @Column(length = 32, nullable = true, unique = false)
    public String houseNumber;

    /** shopPhoneNo1プロパティ */
    @Column(name = "shop_phone_no_1", length = 4, nullable = true, unique = false)
    public String shopPhoneNo1;

    /** shopPhoneNo2プロパティ */
    @Column(name = "shop_phone_no_2", length = 4, nullable = true, unique = false)
    public String shopPhoneNo2;

    /** shopPhoneNo3プロパティ */
    @Column(name = "shop_phone_no_3", length = 4, nullable = true, unique = false)
    public String shopPhoneNo3;

    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;

    /** shopMenuList関連プロパティ */
    @OneToMany(mappedBy = "mLunch")
    public List<ShopMenu> shopMenuList;
    
    /** prefectureCode関連プロパティ */
    @OneToOne
    @JoinColumn(name = "prefecture_code", referencedColumnName = "code")
    public MPrefecture mPrefecture;
}