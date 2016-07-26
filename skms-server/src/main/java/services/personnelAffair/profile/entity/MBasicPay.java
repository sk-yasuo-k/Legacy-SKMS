package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * MBasicPayエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MBasicPay implements Serializable {

    private static final long serialVersionUID = 1L;

    /** basicPayIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer basicPayId;

    /** classNoプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer classNo;

    /** rankNoプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer rankNo;

    /** monthlySumプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer monthlySum;
}