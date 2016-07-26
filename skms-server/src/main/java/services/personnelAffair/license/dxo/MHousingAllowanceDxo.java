package services.personnelAffair.license.dxo;

import java.util.List;

import services.personnelAffair.license.dto.MHousingAllowanceDto;
import services.personnelAffair.license.entity.MHousingAllowance;

/**
 * 住宅手当マスタDxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MHousingAllowanceDxo {
	
	/**
	 * 住宅手当マスタエンティティから住宅手当Dtoへ変換.
	 *
	 * @param src 住宅手当マスタエンティティ
	 * @return 住宅手当Dto
	 */
	public List<MHousingAllowanceDto> convert(List<MHousingAllowance> src); 
	
	/**
	 * 住宅手当Dtoから住宅手当マスタエンティティへ変換.
	 *
	 * @param src 住宅手当Dto
	 * @return 住宅手当マスタエンティティ
	 */
	public List<MHousingAllowance> convertCreate(List<MHousingAllowanceDto> src);
}

