package services.lunch.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * MMenuエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:56")
public class MMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public int id;

    /** menuCodeプロパティ */
    @Column(length = 50, nullable = true, unique = false)
    public String menuCode;

    /** menuNameプロパティ */
    @Column(length = 100, nullable = false, unique = false)
    public String menuName;

    /** priceプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer price;

    /** MOptionSetIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer mOptionSetId;

    /** menuCategoryIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer menuCategoryId;

    /** commentプロパティ */
    @Column(length = 2147483647, nullable = false, unique = false)
    public String comment;

    /** photoプロパティ */
    @Lob
    @Column(precision = 10, nullable = false, unique = false)
    public byte[] photo;

    /** registrationIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrationId;

    /** registrationDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date registrationDate;

    /** updatedDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date updatedDate;

    /** MOptionSet関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "m_option_set_id", referencedColumnName = "id")
    public MOptionSet mOptionSet;

    /** menuCategory関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "menu_category_id", referencedColumnName = "id")
    public MenuCategory menuCategory;

    /** shopMenuList関連プロパティ */
    @OneToMany(mappedBy = "mMenu")
    public List<ShopMenu> shopMenuList;
}