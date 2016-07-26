package services.generalAffair.dxo;

import java.util.List;

import services.generalAffair.dto.MStaffDto;
import services.generalAffair.entity.MStaff;

/**
 * 社員情報Dxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MStaffDxo {
	
	/**
	 * 個人情報マスタエンティティから個人情報Dtoへ変換.
	 *
	 * @param src 個人情報マスタエンティティ
	 * @return 個人情報Dto
	 */
	public List<MStaffDto> convert(List<MStaff> src); 
	
	/**
	 * 個人情報Dtoから個人情報マスタエンティティへ変換.
	 *
	 * @param mStaffList 個人情報マスタエンティティ
	 * @return 
	 */
	public MStaff convertCreate(MStaffDto mStaffList);	
}

