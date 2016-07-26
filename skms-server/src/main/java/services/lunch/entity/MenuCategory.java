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
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * MenuCategoryエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:57")
public class MenuCategory implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** categoryCodeプロパティ */
    @Column(length = 50, nullable = false, unique = false)
    public String categoryCode;

    /** categoryNameプロパティ */
    @Column(length = 100, nullable = false, unique = false)
    public String categoryName;

    /** categoryDisplayNameプロパティ */
    @Column(length = 100, nullable = true, unique = false)
    public String categoryDisplayName;

    /** registrationIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrationId;

    /** registrationDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date registrationDate;

    /** updateDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date updateDate;

    /** MMenuList関連プロパティ */
    @OneToMany(mappedBy = "menuCategory")
    public List<MMenu> mMenuList;
    
    /** MenuList関連プロパティ */
    @OneToMany(mappedBy = "menuCategory")
    public List<Menu> menuList;    
}