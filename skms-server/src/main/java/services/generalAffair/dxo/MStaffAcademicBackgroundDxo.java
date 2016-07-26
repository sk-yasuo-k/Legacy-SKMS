package services.generalAffair.dxo;

import java.util.List;

import services.generalAffair.dto.AcademicBackgroundDto;
import services.generalAffair.entity.MStaffAcademicBackground;

/**
 * 社員学歴情報Dxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MStaffAcademicBackgroundDxo{
	
	/**
	 * 社員学歴情報Dtoから社員学歴マスタエンティティへ変換.
	 *
	 * @param src 社員学歴マスタエンティティ
	 * @return 社員学歴情報Dto
	 */
	public List<MStaffAcademicBackground> convertCreate(List<AcademicBackgroundDto> AcademicBackgroundlyList);
}

