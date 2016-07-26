package services.personnelAffair.skill.dto;

import java.sql.Timestamp;

/**
 * 社員スキルシート作業フェーズDtoです。
 *
 * @author yoshinori-t
 *
 */
public class StaffSkillSheetPhaseDto {

	/**
	 * 社員IDです。
	 */
	public Integer staffId;
	
	/**
	 * スキルシート連番です。
	 */
	public Integer sequenceNo;
	
	/**
	 * 作業フェーズIDです。
	 */
	public Integer phaseId;
	
	/**
	 * 作業フェーズコードです。
	 */
	public String phaseCode;

	/**
	 * 作業フェーズ名です。
	 */
	public String phaseName;
	
	/**
	 * 登録日時です。
	 */
	public Timestamp registrationTime;
	
	/**
	 * 登録者です。
	 */
	public Integer registrantId;
	
	
	/**
	 * コンストラクタ
	 */
	public StaffSkillSheetPhaseDto()
	{
		
	}
}
