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
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * ShopMenuエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:57")
public class ShopMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** MLunchShopIdプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer mLunchShopId;

    /** MMenuIdプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer mMenuId;

    /** startDateプロパティ */
    @Column(nullable = false, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date startDate;

    /** finishDateプロパティ */
    @Column(nullable = false, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date finishDate;

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

    /** menuOrderList関連プロパティ */
    @OneToMany(mappedBy = "shopMenu")
    public List<MenuOrder> menuOrderList;

    /** MLunch関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "m_lunch_shop_id", referencedColumnName = "shop_id")
    public MLunchShop mLunch;

    /** MMenu関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "m_menu_id", referencedColumnName = "id")
    public MMenu mMenu;
    
    /** Menu関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "m_menu_id", referencedColumnName = "id")
    public Menu menu;    
}