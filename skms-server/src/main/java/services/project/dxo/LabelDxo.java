package services.project.dxo;

import java.util.List;

import services.generalAffair.entity.MProjectPosition;
import services.generalAffair.entity.MStaffProjectPosition;

import dto.LabelDto;


/**
 * ラベルDxoです。

 *
 * @author yasuo-k
 *
 */
public interface LabelDxo {

	/**
	 * 役職エンティティリストから役職ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> 役職ラベルリスト
	 */
	public List<LabelDto> convertProjectPosition(List<MProjectPosition> src);

	/**
	 * 社員役職エンティティリストから社員役職ラベルリストへ変換.<br>
	 *
	 * @return List<LabelDto> PM役職ラベルリスト
	 */
	public List<LabelDto> convertProjectPositionPM(List<MStaffProjectPosition> src);

}
