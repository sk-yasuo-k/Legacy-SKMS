package services.generalAffair.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import dto.LabelDto;

import services.generalAffair.dxo.LabelDxo;
import services.generalAffair.entity.MWorkingHoursStatus;

/**
 * ラベルDxoです。

 *
 * @author yasuo-k
 *
 */
public class LabelDxoImpl implements LabelDxo {

	/**
	 * 交通費申請状況エンティティリストから交通費申請状況ラベルリストへ変換.<br>
	 *
	 * @param src 交通費申請状況エンティティリスト
	 * @return List<LabelDto> 交通費申請状況ラベルリスト
	 */
	public List<LabelDto> convertStatus(List<MWorkingHoursStatus> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MWorkingHoursStatus status : src) {
			LabelDto dto = new LabelDto();
			dto.data  = status.workingHoursStatusId;
			dto.label = status.workingHoursStatusName;
			dto.selected = true;
			dst.add(dto);
		}
		return dst;
	}

}
