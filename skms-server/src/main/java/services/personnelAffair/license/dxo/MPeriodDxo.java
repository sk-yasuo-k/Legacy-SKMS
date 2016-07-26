package services.personnelAffair.license.dxo;

import java.util.List;

import services.personnelAffair.license.dto.MPeriodDto;
import services.personnelAffair.license.entity.MPeriod;

public interface MPeriodDxo {

	/**
	 * 期マスタエンティティクラスから期マスタDtoへ変換.
	 *
	 * @param src 期マスタエンティティクラス
	 * @return 期マスタDto
	 */
	public List<MPeriodDto> convert(List<MPeriod> src); 
}
