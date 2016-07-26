package services.personnelAffair.skill.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.skill.dto.SkillLabelDto;
import services.personnelAffair.skill.entity.MSkillSheetPosition;

/**
 * 参加形態変換Dxoです。
 * 
 * @author yoshinori-t
 *
 */
public interface ProjectPositionDxo {

	/**
	 * 参加形態エンティティからラベルDtoへ変換.
	 *
	 * @param src 参加形態エンティティのリスト
	 * @return ラベルDtoリスト
	 */
	@ConversionRule("'data' : positionId, 'label' : positionCode + ':' + positionName, 'id' : positionId, 'code' : positionCode, 'name' : positionName")
	public List<SkillLabelDto> convert(List<MSkillSheetPosition> src);
}
