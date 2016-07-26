package services.personnelAffair.license.dxo;

import java.util.List;

import services.personnelAffair.license.dto.MManagerialAllowanceDto;
import services.personnelAffair.license.entity.MManagerialAllowance;

/**
 * 職務手当マスタDxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MManagerialAllowanceDxo {
	
	/**
	 * 職務手当マスタエンティティクラスから職務手当Dtoへ変換.
	 *
	 * @param src 職務手当マスタエンティティクラス
	 * @return 職務手当Dto
	 */
	public List<MManagerialAllowanceDto> convert(List<MManagerialAllowance> src); 
}

