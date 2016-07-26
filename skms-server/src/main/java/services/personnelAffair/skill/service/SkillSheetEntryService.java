package services.personnelAffair.skill.service;

import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;

import services.personnelAffair.skill.dto.SkillLabelDto;
import services.personnelAffair.skill.dxo.ProjectKindDxo;
import services.personnelAffair.skill.dxo.ProjectPhaseDxo;
import services.personnelAffair.skill.dxo.ProjectPositionDxo;
import services.personnelAffair.skill.entity.MSkillSheetKind;
import services.personnelAffair.skill.entity.MSkillSheetPhase;
import services.personnelAffair.skill.entity.MSkillSheetPosition;

/**
 * スキルシート登録情報サービス。
 * スキルシート登録情報を扱うサービスです。
 *
 * @author yoshinori-t
 *
 */
public class SkillSheetEntryService {
	
	/**
	 * JDBCマネージャ
	 */
	public JdbcManager jdbcManager;
	
	/**
	 * プロジェクト区分変換Dxoです。
	 */
	public ProjectKindDxo projectKindDxo;
	
	/**
	 * 社員スキルシート作業フェーズ変換Dxoです。
	 */
	public ProjectPhaseDxo projectPhaseDxo;
	
	/**
	 * 社員スキルシート参加形態変換Dxoです。
	 */
	public ProjectPositionDxo projectPositionDxo;
	
	
	/**
	 * コンストラクタ
	 */
	public SkillSheetEntryService()
	{
		
	}
	
	/**
	 * プロジェクト区分リスト取得処理。
	 * 
	 * @return プロジェクト区分リスト
	 */
	public List<SkillLabelDto> getProjectKindList()
	{
		List<MSkillSheetKind> src = jdbcManager
						.from(MSkillSheetKind.class)		// スキルシート用区分マスタ
						.orderBy("kindId")
						.getResultList();
		List<SkillLabelDto> result = projectKindDxo.convert(src);
		return result;
	}
	
	/**
	 * 作業フェーズリスト取得処理。
	 * 
	 * @return 社員スキルシート作業フェーズリスト
	 */
	public List<SkillLabelDto> getProjectPhaseList()
	{
		List<MSkillSheetPhase> src = jdbcManager
						.from(MSkillSheetPhase.class)		// スキルシート用作業フェーズマスタ
						.orderBy("phaseId")
						.getResultList();
		List<SkillLabelDto> result = projectPhaseDxo.convert(src);
		return result;
	}
	
	/**
	 * 参加形態リスト取得処理。
	 * 
	 * @return 社員スキルシート参加形態リスト
	 */
	public List<SkillLabelDto> getProjectPositionList()
	{
		List<MSkillSheetPosition> src = jdbcManager
						.from(MSkillSheetPosition.class)	// スキルシート用参加形態マスタ
						.orderBy("positionId")
						.getResultList();
		List<SkillLabelDto> result = projectPositionDxo.convert(src);
		return result;
	}
}
