package services.generalAffair.address.entity;

import java.io.Serializable;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 都道府県マスタエンティティクラス
 * 
 * 
 * @author t-ito
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MPrefecture implements Serializable {

    private static final long serialVersionUID = 1L;

    /** codeプロパティ */
    @Id
    @Column(length = 2, nullable = false, unique = true)
    public String code;

    /** nameプロパティ */
    @Column(length = 12, nullable = true, unique = false)
    public String name;
}