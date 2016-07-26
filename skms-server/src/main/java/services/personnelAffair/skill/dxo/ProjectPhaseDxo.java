package services.personnelAffair.skill.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.skill.dto.SkillLabelDto;
import services.personnelAffair.skill.entity.MSkillSheetPhase;

/**
 * 作業フェーズ変換Dxoです。
 * 
 * @author yoshinori-t
 *
 */
public interface ProjectPhaseDxo {

	/**
	 * 作業フェーズエンティティからラベルDtoへ変換.
	 *
	 * @param src 作業フェーズエンティティのリスト
	 * @return ラベルDtoリスト
	 */
	@ConversionRule("'data' : phaseId, 'label' : phaseCode + ':' + phaseName, 'id' : phaseId, 'code' : phaseCode, 'name' : phaseName")
	public List<SkillLabelDto> convert(List<MSkillSheetPhase> src);
}
