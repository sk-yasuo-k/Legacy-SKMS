package services.personnelAffair.skill.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

/**
 * 認定資格マスタエンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity
public class MAuthorizedLicence implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 資格IDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = false)
	public Integer licenceId;
	
	/**
	 * カテゴリIDです。
	 */
	@Column(precision = 10, nullable = true, unique = false)
	public Integer categoryId;
	
	/**
	 * 資格名です。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String licenceName;
	
	/**
	 * 情報処理手当IDです。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public Integer informationPayId;
	
	/**
	 * 認定資格カテゴリマスタです。
	 */
	@OneToOne
	@JoinColumn(name="category_id")
	public MAuthorizedLicenceCategory mAuthorizedLicenceCategory;
	
	/**
	 * 認定資格手当マスタです。
	 */
	@OneToOne
	@JoinColumn(name="information_pay_id")
	public MInformationAllowance mInformationAllowance;
}
