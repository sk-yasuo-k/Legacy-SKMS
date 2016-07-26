package services.personnelAffair.license.dxo;

import java.util.List;

import services.personnelAffair.license.dto.MCompetentAllowanceDto;
import services.personnelAffair.license.entity.MCompetentAllowance;

/**
 * 主務手当マスタDxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MCompetentAllowanceDxo {
	
	/**
	 * 主務手当マスタエンティティクラスから主務手当Dtoへ変換.
	 *
	 * @param src 主務手当マスタエンティティクラス
	 * @return 主務手当Dto
	 */
	public List<MCompetentAllowanceDto> convert(List<MCompetentAllowance> src); 
}

