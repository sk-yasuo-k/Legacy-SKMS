package services.generalAffair.address.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 社員住所変更状況種別マスタエンティティクラス
 * 
 * 
 * @author t-ito
 * 
 */
@Entity
public class MStaffAddressStatus implements Serializable{

	private static final long serialVersionUID = 1L;
	
    /** staffAddressStatusIdプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public String staffAddressStatusId;

    /** staffAddressStatusNameプロパティ */
    @Column(length = 8, nullable = true, unique = false)
    public String staffAddressStatusName;
	
}
