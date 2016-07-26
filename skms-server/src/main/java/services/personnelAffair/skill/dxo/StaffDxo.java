package services.personnelAffair.skill.dxo;

import java.util.List;

import services.generalAffair.entity.MStaff;
import services.personnelAffair.skill.dto.StaffDto;

/**
 * 社員情報変換Dxoです。
 * 
 * @author yoshinori-t
 * 
 */
public interface StaffDxo {

	/**
	 * 社員情報エンティティから社員情報情報Dtoへ変換.
	 *
	 * @param src 社員情報エンティティ
	 * @return 社員情報Dtoリスト
	 */
	public List<StaffDto> convert(List<MStaff> src);
	
}
