package services.project.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import services.generalAffair.entity.MProjectPosition;
import services.generalAffair.entity.MStaffProjectPosition;
import services.project.dxo.LabelDxo;

import dto.LabelDto;


/**
 * ラベルDxoです。

 *
 * @author yasuo-k
 *
 */
public class LabelDxoImpl implements LabelDxo {

	/**
	 * 役職エンティティリストから役職ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 役職ラベルリスト
	 */
	public List<LabelDto> convertProjectPosition(List<MProjectPosition> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MProjectPosition pos : src) {
			LabelDto dto = new LabelDto();
			dto.data  = pos.projectPositionId;
			dto.label = pos.projectPositionAlias;
			dst.add(dto);
		}
		return dst;
	}

	/**
	 * 社員役職エンティティリストから社員役職ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> PM役職ラベルリスト
	 */
	public List<LabelDto> convertProjectPositionPM(List<MStaffProjectPosition> src)
	{
		List<LabelDto> dst = new ArrayList<LabelDto>();
		for (MStaffProjectPosition staff : src) {
			LabelDto dto = new LabelDto();
			dto.data  = staff.staffId;
			dto.label = staff.staff.staffName.fullName;
			dst.add(dto);
		}
		return dst;
	}
}
