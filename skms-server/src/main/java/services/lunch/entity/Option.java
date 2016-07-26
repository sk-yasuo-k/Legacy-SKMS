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
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Optionエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:57")
public class Option implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** codeプロパティ */
    @Column(length = 50, nullable = true, unique = false)
    public String optionCode;

    /** optionNameプロパティ */
    @Column(length = 100, nullable = false, unique = false)
    public String optionName;

    /** optionDisplayNameプロパティ */
    @Column(length = 100, nullable = false, unique = false)
    public String optionDisplayName;

    /** priceプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer price;

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

    /** optionKindList関連プロパティ */
    @OneToMany(mappedBy = "option")
    public List<OptionKind> optionKindList;
    
    /** menuOrderOption関連プロパティ */
    @OneToOne
    @JoinColumn(name = "id", referencedColumnName = "m_option_id")
    public MenuOrderOption menuOrderOption;
}