package services.personnelAffair.profile.dto;

import java.io.Serializable;

/**
 * 基本給マスタDtoです。
 *
 * @author t-ito
 *
 */
public class BasicPayDto implements Serializable {
	
	static final long serialVersionUID = 1L;
	
	/**
	 * 基本給IDです。
	 */
	public Integer basicPayId;

	/**
	 * 等級です。
	 */
	public Integer classNo;
	
	/**
	 * 号です。
	 */
	public Integer rankNo;
	
	/**
	 * 月額です。
	 */
	public Integer monthlySum;
}
