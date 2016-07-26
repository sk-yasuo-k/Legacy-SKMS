package services.personnelAffair.license.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 技能手当マスタDtoです。
 * 
 * @author nobuhiro-s
 * 
 */
public class MTechnicalSkillAllowanceDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 技能手当IDです。
	 */
	@Id
	@GeneratedValue
	public int technicalSkillId;

	/**
	 * 等級です。
	 */
	public int classNo;
	
	/**
	 * 月額です。
	 */
	public int monthlySum;
}