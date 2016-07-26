package services.generalAffair.entity;

import java.io.Serializable;
import javax.annotation.Generated;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 委員会マスタです。
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MCommittee implements Serializable {

    private static final long serialVersionUID = 1L;

    /** committeeIdプロパティ(委員会ID) */
    @Id
    public Integer committeeId;
    
    /** committeeNameプロパティ(委員会名) */
    public String committeeName;
    
    /** noteプロパティ(備考) */
    public String note;
   
}