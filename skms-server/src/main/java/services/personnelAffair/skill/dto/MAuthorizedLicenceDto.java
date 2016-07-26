package services.personnelAffair.skill.dto;

import java.io.Serializable;

/**
 * 認定資格マスタDtoです。
 *
 * @author t-ito
 *
 */
public class MAuthorizedLicenceDto implements Serializable {

	static final long serialVersionUID = 1L;	

	/**
	 * 資格IDです。
	 */
	public Integer licenceId;
	
	/**
	 * 資格名です。
	 */
	public String licenceName;
	
	/**
	 * カテゴリIDです。
	 */
	public Integer categoryId;
	
}
