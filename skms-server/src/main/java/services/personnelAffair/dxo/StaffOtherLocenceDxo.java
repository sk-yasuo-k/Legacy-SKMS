package services.personnelAffair.dxo;

import java.util.List;

import services.personnelAffair.skill.dto.StaffOtherLocenceDto;
import services.personnelAffair.skill.entity.MStaffOtherLocence;

/**
 * 社員所持その他資格情報Dxo
 *
 * @author nobuhiro-s
 *
 */
public interface StaffOtherLocenceDxo {
	
	/**
	 * 社員所持その他資格情報マスタエンティティから社員所持その他資格情報Dtoへ変換.
	 *
	 * @param src 社員所持その他資格情報マスタエンティティ
	 * @return 社員所持その他資格情報Dto
	 */
	public List<StaffOtherLocenceDto> convert(List<MStaffOtherLocence> src);
	
	/**
	 * 社員所持その他資格情報Dtoから社員所持その他資格情報マスタエンティティへ変換.
	 *
	 * @param src 社員所持その他資格情報Dto 
	 * @return 社員所持その他資格情報マスタエンティティ
	 */
	public MStaffOtherLocence convertCreate(StaffOtherLocenceDto src);	
}

