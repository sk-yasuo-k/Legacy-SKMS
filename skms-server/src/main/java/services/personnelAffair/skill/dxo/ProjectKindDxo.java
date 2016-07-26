package services.personnelAffair.skill.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.skill.dto.SkillLabelDto;
import services.personnelAffair.skill.entity.MSkillSheetKind;

/**
 * プロジェクト区分変換Dxoです。
 * 
 * @author yoshinori-t
 *
 */
public interface ProjectKindDxo { 
	
	/**
	 * プロジェクト区分エンティティからラベルDtoへ変換.
	 *
	 * @param src プロジェクト区分エンティティのリスト
	 * @return ラベルDtoリスト
	 */
	@ConversionRule("'data' : kindId, 'label' : kindName, 'id' : kindId, 'code' : kindCode, 'name' : kindName")
	public List<SkillLabelDto> convert(List<MSkillSheetKind> src);
}
