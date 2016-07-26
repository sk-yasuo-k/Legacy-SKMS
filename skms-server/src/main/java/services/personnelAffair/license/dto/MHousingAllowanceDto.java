package services.personnelAffair.license.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 住宅手当マスタDtoです。
 * 
 * @author nobuhiro-s
 * 
 */
public class MHousingAllowanceDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 住宅手当IDです。
	 */
	@Id
	@GeneratedValue
	public int housingId;

	/**
	 * 住宅手当名です。
	 */
	public String housingName;
	
	/**
	 * 月額です。
	 */
	public int monthlySum;
}