package services.generalAffair.dxo;

import java.util.List;

import services.generalAffair.entity.MWorkingHoursStatus;

import dto.LabelDto;

/**
 * ラベルDxoです。

 *
 * @author yasuo-k
 *
 */
public interface LabelDxo {

	/**
	 * 勤務管理表手続状態エンティティリストから勤務管理表手続状態ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 勤務管理表手続状態ラベルリスト

	 */
	public List<LabelDto> convertStatus(List<MWorkingHoursStatus> src);

}
