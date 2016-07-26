package services.personnelAffair.skill.dxo;

import java.util.List;

import services.personnelAffair.skill.dto.MInformationAllowanceDto;
import services.personnelAffair.skill.entity.MInformationAllowance;

/**
 * 認定資格手当マスタDxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MInformationAllowanceDxo{
	
	/**
	 * 認定資格手当マスタエンティティクラスから認定資格手当Dtoへ変換.
	 *
	 * @param src 認定資格手当マスタエンティティクラス
	 * @return 認定資格手当マスタDto
	 */
	public List<MInformationAllowanceDto> convert(List<MInformationAllowance> src); 
}

