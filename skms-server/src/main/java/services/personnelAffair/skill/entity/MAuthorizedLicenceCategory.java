package services.personnelAffair.skill.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 認定資格カテゴリマスタエンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity
public class MAuthorizedLicenceCategory implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * カテゴリIDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = false)
	public Integer categoryId;
	
	/**
	 * カテゴリ名です。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String categoryName;
}
