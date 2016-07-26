package services.personnelAffair.license.dxo;

import java.util.List;

import services.personnelAffair.license.dto.MBasicClassDto;
import services.personnelAffair.license.entity.MBasicClass;

public interface MBasicClassDxo {

	/**
	 * 等級マスタエンティティクラスから等級マスタDtoへ変換.
	 *
	 * @param src 等級マスタエンティティクラス
	 * @return 等級マスタDto
	 */
	public List<MBasicClassDto> convert(List<MBasicClass> src); 
}
