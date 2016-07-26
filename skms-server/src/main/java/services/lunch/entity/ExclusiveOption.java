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
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * ExclusiveOptionエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/28 9:58:56")
public class ExclusiveOption implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** MOptionKindIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer mOptionKindId;

    /** exclusiceMOptionKindIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer exclusiceMOptionKindId;

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

    /** MOptionKind関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "m_option_kind_id", referencedColumnName = "id")
    public MOptionKind mOptionKind;

    /** exclusiceMOptionKind関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "exclusice_m_option_kind_id", referencedColumnName = "id")
    public MOptionKind exclusiceMOptionKind;
}