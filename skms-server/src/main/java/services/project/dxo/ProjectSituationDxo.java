package services.project.dxo;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectSituationDto;
import services.project.entity.ProjectSituation;


/**
 * プロジェクト状況情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface ProjectSituationDxo {


	/**
	 * プロジェクト状況情報Dtoからプロジェクト状況情報エンティティへ変換.
	 *
	 * @param src プロジェクト状況情報Dto
	 * @param staff 社員情報.
	 * @return プロジェクト状況情報エンティティ.
	 */
	public ProjectSituation convertCreate(ProjectSituationDto src, MStaff staff);


	/**
	 * プロジェクト状況情報Dtoからプロジェクト状況情報エンティティへ変換.
	 *
	 * @param src プロジェクト状況情報Dto
	 * @param staff 社員情報.
	 * @return プロジェクト状況情報エンティティ.
	 */
	public ProjectSituation convertUpdate(ProjectSituationDto src, MStaff staff);

}
