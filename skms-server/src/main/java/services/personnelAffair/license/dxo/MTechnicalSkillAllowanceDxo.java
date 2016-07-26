package services.personnelAffair.license.dxo;

import java.util.List;

import services.personnelAffair.license.dto.MTechnicalSkillAllowanceDto;
import services.personnelAffair.license.entity.MTechnicalSkillAllowance;

/**
 * 技能手当マスタDxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MTechnicalSkillAllowanceDxo {
	
	/**
	 * 技能手当マスタエンティティクラスから技能手当Dtoへ変換.
	 *
	 * @param src 技能手当マスタエンティティクラス
	 * @return 技能手当Dto
	 */
	public List<MTechnicalSkillAllowanceDto> convert(List<MTechnicalSkillAllowance> src); 
}

