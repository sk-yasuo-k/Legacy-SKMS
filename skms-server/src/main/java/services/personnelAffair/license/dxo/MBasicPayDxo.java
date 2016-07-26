package services.personnelAffair.license.dxo;

import java.util.List;

import services.personnelAffair.license.dto.MBasicPayDto;
import services.personnelAffair.profile.entity.MBasicPay;

/**
 * 基本給マスタDxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MBasicPayDxo {
	
	/**
	 * 基本給手当マスタエンティティクラスから技能手当Dtoへ変換.
	 *
	 * @param src 基本給マスタエンティティクラス
	 * @return 基本給Dto
	 */
	public List<MBasicPayDto> convert(List<MBasicPay> src); 
}

