package services.lunch.entity;

import java.io.Serializable;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * MenuOrderOptionエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:57")
public class MenuOrderOption implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** menuOrderIdプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer menuOrderId;

    /** MOptionIdプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer mOptionId;

    /** registrationIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrationId;

    /** registrationDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date registrationDate;

    /** menuOrder関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "menu_order_id", referencedColumnName = "id")
    public MenuOrder menuOrder;
    
    /** option関連プロパティ */
    @OneToOne
    @JoinColumn(name = "m_option_id", referencedColumnName = "id")
    public Option option;
}