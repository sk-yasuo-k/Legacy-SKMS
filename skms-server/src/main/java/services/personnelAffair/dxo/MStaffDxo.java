package services.personnelAffair.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.dto.MStaffDto;
import services.generalAffair.entity.MStaff;

/**
 * 社員情報Dxo
 *
 * @author nobuhiro-s
 *
 */
public interface MStaffDxo {
	
	/**
	 * 社員情報マスタエンティティから社員一覧Dtoへ変換.
	 *
	 * @param src 社員情報マスタエンティティ
	 * @return 個人情報Dto
	 */
	@ConversionRule("fullName : staffName.fullName")
	public List<MStaffDto> convert(List<MStaff> src); 
}

