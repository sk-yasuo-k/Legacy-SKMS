package services.personnelAffair.skill.dto;

import java.io.Serializable;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 認定資格手当Dtoです。
 *
 * @author yoshinori-t
 *
 */
public class MInformationAllowanceDto implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 情報処理手当IDです。
	 */
	@Id
	@GeneratedValue
	public Integer informationPayId;
	
	/**
	 * 資格手当名です。
	 */
	public String informationPayName;
	
	/**
	 * 月額です。
	 */
	public Integer monthlySum;
	
	/**
	 * 備考です。
	 */
	public String note;
}
