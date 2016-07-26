package services.personnelAffair.skill.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * 社員所持認定資格情報Dtoです。
 *
 * @author yoshinori-t
 *
 */
public class StaffAuthorizedLicenceDto implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	public Integer staffId;
	
	/**
	 * 資格連番です。
	 * nobuhiro-s追加(2009/11/02)
	 */
	public Integer sequenceNo;
	
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
	
	/**
	 * カテゴリ名です。
	 */
	public String categoryName;
	
	/**
	 * 情報手当IDです。
	 */
	public Integer informationPayId;
	
	/**
	 * 資格手当です。
	 */
	public Integer monthlySum;
	
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
