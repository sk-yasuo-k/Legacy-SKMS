package services.personnelAffair.skill.dto;

import java.sql.Timestamp;

/**
 * 社員スキルシート参加形態Dtoです。
 *
 * @author yoshinori-t
 *
 */
public class StaffSkillSheetPositionDto {
	
	/**
	 * 社員IDです。
	 */
	public Integer staffId;
	
	/**
	 * スキルシート連番です。
	 */
	public Integer sequenceNo;
	
	/**
	 * 参加形態IDです。
	 */
	public Integer positionId;
	
	/**
	 * 参加形態コードです。
	 */
	public String positionCode;
	
	/**
	 * 参加形態名です。
	 */
	public String positionName;
	
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
	public StaffSkillSheetPositionDto()
	{
		
	}
}
