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
 * MOptionKindエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:56")
public class MOptionKind implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** optionKindNameプロパティ */
    @Column(length = 100, nullable = false, unique = false)
    public String optionKindName;

    /** optionKindDisplayNameプロパティ */
    @Column(length = 100, nullable = false, unique = false)
    public String optionKindDisplayName;

    /** optionKindCodeプロパティ */
    @Column(length = 50, nullable = true, unique = false)
    public String optionKindCode;   
    
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

    /** exclusiveOptionList関連プロパティ */
    @OneToMany(mappedBy = "mOptionKind")
    public List<ExclusiveOption> exclusiveOptionList;

    /** exclusiveOptionList2関連プロパティ */
    @OneToMany(mappedBy = "exclusiceMOptionKind")
    public List<ExclusiveOption> exclusiveOptionList2;

    /** optionKindList関連プロパティ */
    @OneToMany(mappedBy = "mOptionKind")
    public List<OptionKind> optionKindList;

    /** optionSetList関連プロパティ */
    @OneToMany(mappedBy = "mOptionKind")
    public List<OptionSet> optionSetList;
}