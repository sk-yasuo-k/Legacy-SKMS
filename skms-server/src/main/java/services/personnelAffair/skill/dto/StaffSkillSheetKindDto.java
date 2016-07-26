package services.personnelAffair.skill.dto;

import java.io.Serializable;

/**
 * スキルシート用区分マスタDtoです。
 *
 * @author yoshinori-t
 *
 */
public class StaffSkillSheetKindDto implements Serializable{

	static final long serialVersionUID = 1L;
	
	/**
	 * 区分IDです。
	 */
	public Integer kindId;
	
	/**
	 * 区分コードです。
	 */
	public String kindCode;
	
	/**
	 * 区分名です。
	 */
	public String kindName;
	
	/**
	 * コンストラクタ
	 */
	public StaffSkillSheetKindDto()
	{
		
	}
}
