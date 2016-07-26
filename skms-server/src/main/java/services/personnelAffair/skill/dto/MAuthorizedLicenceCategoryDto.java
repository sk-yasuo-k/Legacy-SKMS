package services.personnelAffair.skill.dto;

import java.io.Serializable;

/**
 * 認定資格カテゴリーマスタDtoです。
 *
 * @author t-ito
 *
 */
public class MAuthorizedLicenceCategoryDto implements Serializable {
	
	static final long serialVersionUID = 1L;

	/**
	 * カテゴリIDです。
	 */
	public Integer categoryId;
	
	/**
	 * カテゴリ名です。
	 */
	public String categoryName;
	
}
