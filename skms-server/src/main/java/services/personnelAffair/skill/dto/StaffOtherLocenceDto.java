package services.personnelAffair.skill.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * 社員所持その他資格情報Dtoです。
 *
 * @author yoshinori-t
 *
 */
public class StaffOtherLocenceDto implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	public Integer staffId;
	
	/**
	 * 資格連番です。
	 */
	public Integer sequenceNo;
	
	/**
	 * 資格名です。
	 */
	public String licenceName;
	
	/**
	 * 取得日です。
	 */
	public Date acquisitionDate;
	
	/**
	 * 登録日時です。
	 */
	public Date registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	public Integer registrantId;

}
