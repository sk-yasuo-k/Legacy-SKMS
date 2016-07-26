package services.generalAffair.entity;

import java.io.Serializable;
import javax.annotation.Generated;
import javax.persistence.Entity;

/**
 * 委員会役職マスタです。
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MCommitteePosition implements Serializable {

    private static final long serialVersionUID = 1L;

    /** committeeIdプロパティ(委員会役職ID) */
    public Integer committeePositionId;
    
    /** committeeNameプロパティ(委員会役職名) */
    public String committeePositionName;
   
}