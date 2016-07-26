package services.personnelAffair.dto;

import java.io.Serializable;
//import java.util.List;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

//import services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
//import services.personnelAffair.skill.dto.StaffOtherLocenceDto;

/**
 * 社員情報Dto
 * 
 * @author nobuhiro-s
 * 
 */
public class MStaffDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 社員名(フル)です。
	 */
	public String fullName;
	
//	/**
//	 * 社員所持認定資格マスタです。
//	 */
//	public List<StaffAuthorizedLicenceDto> mStaffAuthorizedLicence;
//	
//	/**
//	 * 社員所持その他資格です。
//	 */
//	public List<StaffOtherLocenceDto> mStaffOtherLocence;
}