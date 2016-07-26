package services.personnelAffair.license.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 主務手当マスタDtoです。
 * 
 * @author nobuhiro-s
 * 
 */
public class MCompetentAllowanceDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 主務手当IDです。
	 */
	@Id
	@GeneratedValue
	public int competentId;

	/**
	 * 等級です。
	 */
	public int classNo;
	
	/**
	 * 月額です。
	 */
	public int monthlySum;	
}