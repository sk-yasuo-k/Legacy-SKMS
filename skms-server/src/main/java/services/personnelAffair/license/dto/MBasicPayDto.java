package services.personnelAffair.license.dto;

import java.io.Serializable;

/**
 * 基本給マスタDtoです。
 *
 * @author n-sumi
 *
 */
public class MBasicPayDto implements Serializable {
	
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
