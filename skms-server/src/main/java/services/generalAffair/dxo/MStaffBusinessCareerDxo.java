package services.generalAffair.dxo;

import java.util.List;

import services.generalAffair.dto.BusinessCareerDto;
import services.generalAffair.entity.MStaffBusinessCareer;

/**
 * 社員職歴情報Dxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MStaffBusinessCareerDxo{
	
	/**
	 * 社員職歴情報Dtoから社員職歴マスタエンティティへ変換.
	 *
	 * @param src 社員職歴マスタエンティティ
	 * @return 社員職歴情報Dto
	 */
	public List<MStaffBusinessCareer> convertCreate(List<BusinessCareerDto> BusinessCareerList);
}

