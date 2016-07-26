package services.personnelAffair.skill.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 認定資格手当マスタエンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity
public class MInformationAllowance implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 情報処理手当IDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = false)
	public Integer informationPayId;
	
	/**
	 * 資格名です。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String informationPayName;
	
	/**
	 * 月額です。
	 */
	@Column(precision = 10, nullable = true, unique = false)
	public Integer monthlySum;
	
	/**
	 * 備考です。
	 */
	@Column(precision = 10, nullable = true, unique = false)
	public String note;
}
