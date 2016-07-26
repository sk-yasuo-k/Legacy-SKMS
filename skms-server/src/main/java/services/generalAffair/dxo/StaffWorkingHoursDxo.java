package services.generalAffair.dxo;

import java.util.List;

import services.generalAffair.dto.StaffWorkingHoursDto;
import services.generalAffair.entity.StaffWorkingHours;


/**
 * 社員別勤務管理集計Dxoです。

 *
 * @author yasuo-k
 *
 */
public interface StaffWorkingHoursDxo {

	/**
	 * 社員別勤務管理エンティティリストから社員別勤務権利Dtoリストへ変換.
	 *
	 * @param src 社員別勤務管理エンティティリスト.
	 * @return 社員別勤務権利Dtoリスト.
	 */
	public List<StaffWorkingHoursDto> convert(List<StaffWorkingHours> src);

}
