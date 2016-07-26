package services.generalAffair.address.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 社員住所変更動作種別マスタエンティティクラス
 * 
 * 
 * @author t-ito
 * 
 */
@Entity
public class MStaffAddressAction implements Serializable{

	private static final long serialVersionUID = 1L;
	
    /** staffAddressActionIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public String staffAddressActionId;

    /** staffAddressActionNameプロパティ */
    @Column(length = 8, nullable = true, unique = false)
    public String staffAddressActionName;
    
}
