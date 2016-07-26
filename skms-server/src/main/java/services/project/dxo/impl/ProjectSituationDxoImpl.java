package services.project.dxo.impl;

import org.seasar.extension.jdbc.JdbcManager;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectSituationDto;
import services.project.dxo.ProjectSituationDxo;
import services.project.entity.ProjectSituation;


/**
 * プロジェクト状況情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class ProjectSituationDxoImpl implements ProjectSituationDxo {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * プロジェクト状況情報Dtoからプロジェクト状況情報エンティティへ変換.
	 *
	 * @param src プロジェクト状況情報Dto
	 * @param staff 社員情報.
	 * @return プロジェクト状況情報エンティティ.
	 */
	public ProjectSituation convertCreate(ProjectSituationDto src, MStaff staff)
	{
		ProjectSituation dst = new ProjectSituation();
		dst.projectId    = src.projectId;
		dst.situationNo  = nextval_situationNo(dst.projectId);
		dst.situation    = src.situation;
		dst.registrantId = staff.staffId;
		return dst;
	}


	/**
	 * プロジェクト状況情報Dtoからプロジェクト状況情報エンティティへ変換.
	 *
	 * @param src プロジェクト状況情報Dto
	 * @param staff 社員情報.
	 * @return プロジェクト状況情報エンティティ.
	 */
	public ProjectSituation convertUpdate(ProjectSituationDto src, MStaff staff)
	{
		ProjectSituation dst = new ProjectSituation();
		dst.projectId    = src.projectId;
		dst.situationNo  = src.situationNo;
		dst.situation    = src.situation;
		dst.registrantId = src.registrantId;
		dst.registrationVer=src.registrationVer;
		return dst;
	}


	/**
	 * Next状況連番の発行.
	 *
	 * @param  projectId プロジェクトID.
	 * @return 状況連番.
	 */
	private int nextval_situationNo(int projectId)
	{
		String maxSql = "select max(situation_no) from project_situation where project_id =" + projectId;
		Integer currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		return currval == null ? 1 : currval + 1;
	}
}