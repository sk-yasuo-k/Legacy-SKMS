package services.lunch.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * Menuエンティティクラス
 * 
 */
@Entity
@Table(name="m_menu")
public class Menu implements Serializable {

    private static final long serialVersionUID = 1L;
    
    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public int id;
    
    /** menuNameプロパティ */
    @Column(length = 100, nullable = false, unique = false)
    public String menuName;    
    
    /** priceプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer price;
    
    /** menuCategoryIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer menuCategoryId;

    /** menuCategory関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "menu_category_id", referencedColumnName = "id")
    public MenuCategory menuCategory;

    /** shopMenuList関連プロパティ */
    @OneToMany(mappedBy = "menu")
    public List<ShopMenu> shopMenuList;
    
}
