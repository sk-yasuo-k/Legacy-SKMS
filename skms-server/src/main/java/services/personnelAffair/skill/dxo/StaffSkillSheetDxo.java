package services.personnelAffair.skill.dxo;

import java.util.List;

import services.personnelAffair.skill.dto.StaffSkillSheetDto;
import services.personnelAffair.skill.entity.StaffSkillSheet;

/**
 * 社員スキルシート情報変換Dxoです。
 * 
 * @author yoshinori-t
 * 
 */
public interface StaffSkillSheetDxo {
	
	/**
	 * 社員スキルシート情報エンティティから社員スキルシート情報Dtoへ変換.
	 *
	 * @param src 社員スキルシート情報エンティティのリスト
	 * @return 社員スキルシート情報Dtoのリスト
	 */
	public List<StaffSkillSheetDto> convert(List<StaffSkillSheet> src);
	
	/**
	 * 社員スキルシート情報Dtoから社員スキルシート情報エンティティへ変換.
	 *
	 * @param src 社員スキルシート情報Dtoのリスト
	 * @return 社員スキルシート情報エンティティのリスト
	 */
	public List<StaffSkillSheet> convertCreate(List<StaffSkillSheetDto> src);

}
