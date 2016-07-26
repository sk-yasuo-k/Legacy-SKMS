package services.personnelAffair.skill.dto;

import java.io.Serializable;
import java.util.Date;
import java.sql.Timestamp;
import java.util.List;

/**
 * 社員スキルシート情報Dtoです。
 *
 * @author yoshinori-t
 *
 */
public class StaffSkillSheetDto implements Serializable{

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	public Integer staffId;
	
	/**
	 * スキルシート連番です。
	 */
	public Integer sequenceNo;
	
	/**
	 * プロジェクトIDです。
	 */
	public Integer projectId;
	
	/**
	 * プロジェクトコードです。
	 */
	public String projectCode;
	
	/**
	 * プロジェクト名です。
	 */
	public String projectName;
	
	/**
	 * 件名です。
	 */
	public String title;
	
	/**
	 * 区分IDです。
	 */
	public Integer kindId;
	
	/**
	 * 区分名です。
	 */
	public String kindName;
	
	/**
	 * 期間開始日です。
	 */
	public Date joinDate;
	
	/**
	 * 期間終了日です。
	 */
	public Date retireDate;
	
	/**
	 * ハードウェアです。
	 */
	public String hardware;
	
	/**
	 * OSです。
	 */
	public String os;
	
	/**
	 * 言語です。
	 */
	public String language;
	
	/**
	 * キーワードです。
	 */
	public String keyword;
	
	/**
	 * 担当した内容です。
	 */
	public String content;
	
	/**
	 * 登録日時です。
	 */
	public Timestamp registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	public Integer registrantId;
	
	/**
	 * 社員スキルシート作業フェーズ
	 */
	public List<StaffSkillSheetPhaseDto> staffSkillSheetPhaseList;
	
	/**
	 * 社員スキルシート参加形態
	 */
	public List<StaffSkillSheetPositionDto> staffSkillSheetPositionList;
	
	
	/**
	 * コンストラクタ
	 */
	public StaffSkillSheetDto()
	{
		
	}
}
