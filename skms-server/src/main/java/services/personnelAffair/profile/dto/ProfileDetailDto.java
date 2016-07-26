package services.personnelAffair.profile.dto;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Lob;

import services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
import services.personnelAffair.skill.dto.StaffOtherLocenceDto;

/**
 * プロフィール詳細Dtoです。
 *
 * @author t-ito
 *
 */
public class ProfileDetailDto implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	public Integer staffId;

	/**
	 * 社員画像です。
	 */
	@Lob
	public byte[] staffImage;
	
	/**
	 * 勤務地名です。
	 */
	public String workPlaseName;		
	
	/**
	 * 社員所持認定資格マスタです。
	 */
	public List<StaffAuthorizedLicenceDto> mStaffAuthorizedLicence;
	
	/**
	 * 社員所持その他資格です。
	 */
	public List<StaffOtherLocenceDto> mStaffOtherLocence;

	/**
	 * セミナー受講履歴です。
	 */
	public List<SeminarParticipantDto> seminarParticipant;
}
	
