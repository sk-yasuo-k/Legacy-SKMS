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
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.VCurrentStaffName;

/**
 * MenuOrderエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:57")
public class MenuOrder implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** staffIdプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer staffId;

    /** orderDateプロパティ */
    @Column(nullable = false, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date orderDate;

    /** shopMenuIdプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer shopMenuId;

    /** registrationIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrationId;

    /** numberプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer number;

    /** registrationDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date registrationDate;

    /** cancelプロパティ */
    @Column(length = 1, nullable = false, unique = false)
    public Boolean cancel;

    /** MStaff関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    public MStaff mStaff;
    
	/** 社員名です。*/
	@OneToOne
	@JoinColumn(name="staff_id")
	public VCurrentStaffName vCurrentStaffName;

    /** shopMenu関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "shop_menu_id", referencedColumnName = "id")
    public ShopMenu shopMenu;

    /** menuOrderOptionList関連プロパティ */
    @OneToMany(mappedBy = "menuOrder")
    public List<MenuOrderOption> menuOrderOptionList;
}