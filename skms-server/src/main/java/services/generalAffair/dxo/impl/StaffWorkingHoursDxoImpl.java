package services.generalAffair.dxo.impl;

import java.util.ArrayList;
import java.util.List;


import services.generalAffair.dto.StaffWorkingHoursDto;
import services.generalAffair.dto.StaffWorkingHoursMonthlyDto;
import services.generalAffair.dxo.StaffWorkingHoursDxo;
import services.generalAffair.entity.StaffWorkingHours;



/**
 * 社員別勤務管理集計Dxoです。

 *
 * @author yasuo-k
 *
 */
public class StaffWorkingHoursDxoImpl implements StaffWorkingHoursDxo {

	/**
	 * 社員別勤務管理エンティティリストから社員別勤務権利Dtoリストへ変換.
	 *
	 * @param src 社員別勤務管理エンティティリスト.
	 * @return 社員別勤務権利Dtoリスト.
	 */
	public List<StaffWorkingHoursDto> convert(List<StaffWorkingHours> src)
	{
		List<StaffWorkingHoursDto> dst = new ArrayList<StaffWorkingHoursDto>();
		StaffWorkingHoursDto dto;
		for (StaffWorkingHours entity : src) {
			int index = 0;
			boolean flg = true;
			dto = null;

			// 社員別Dtoリストに staff が存在するかどうか確認する.
			for (index = 0; index < dst.size(); index++) {
				dto = dst.get(index);
				if (dto.staffId == entity.staffId) {
					flg = false;
					break;
				}
			}
			// 存在しないときは 新規に作成する.
			if (flg) {
				dto = new StaffWorkingHoursDto();
				dto.staffId      = entity.staffId;
				dto.staffName    = entity.fullName;
				dto.workStatusId = entity.workStatusId;
				dto.monthlyList  = new ArrayList<StaffWorkingHoursMonthlyDto>();
			}

			// 月別勤務時間dtoを作成する.
			StaffWorkingHoursMonthlyDto monthlydto = new StaffWorkingHoursMonthlyDto();
			monthlydto.staffId = entity.staffId;
			monthlydto.yyyymm  = entity.workingMonthCode;
			monthlydto.workingHours   = entity.workingHours;
			monthlydto.realWorkingHours = entity.realWorkingHours;
			dto.monthlyList.add(monthlydto);

			// 月別勤務時間dtoリストに追加する.
			if (flg) 	dst.add(dto);
			else		dst.set(index, dto);
		}
		return dst;
	}

}
