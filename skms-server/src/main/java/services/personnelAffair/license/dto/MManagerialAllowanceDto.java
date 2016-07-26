package services.personnelAffair.license.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 職務手当マスタDtoです。
 * 
 * @author nobuhiro-s
 * 
 */
public class MManagerialAllowanceDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 職務手当IDです。
	 */
	@Id
	@GeneratedValue
	public int managerialId;

	/**
	 * 等級です。
	 */
	public int classNo;
	
	/**
	 * 月額です。
	 */
	public int monthlySum;	
}