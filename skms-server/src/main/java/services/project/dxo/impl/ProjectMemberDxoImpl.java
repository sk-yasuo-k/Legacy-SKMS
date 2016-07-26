package services.project.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectMemberDto;
import services.project.dxo.ProjectMemberDxo;
import services.project.entity.Project;
import services.project.entity.ProjectMember;

/**
 * プロジェクトメンバー情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class ProjectMemberDxoImpl implements ProjectMemberDxo {

	/**
	 * 社員情報エンティティリストから社員情報Dtoリストへ変換.
	 *
	 * @param  src 社員情報エンティティリスト
	 * @return プロジェクトメンバー情報Dtoリスト
	 */
	public List<ProjectMemberDto> convert(List<MStaff> src)
	{
		if (src == null)	return null;

		List <ProjectMemberDto> dst = new ArrayList<ProjectMemberDto>();
		for (MStaff staff : src ) {
			ProjectMemberDto projectStaff = new ProjectMemberDto(staff);
			dst.add(projectStaff);
		}
		return dst;
	}

	/**
	 * プロジェクトメンバーDtoからプロジェクトメンバーエンティティへ変換.
	 *
	 * @param src    プロジェクトメンバーDto
	 * @param parent プロジェクトエンティティー
	 * @return プロジェクトメンバーエンティティ
	 */
	public ProjectMember convertCreate(ProjectMemberDto src, Project parent)
	{
		ProjectMember dst = new ProjectMember(src, parent.registrantId);
		dst.projectId     = parent.projectId;
		return dst;
	}

	/**
	 * プロジェクトメンバーDtoからプロジェクトメンバーエンティティへ変換.
	 *
	 * @param src    プロジェクトメンバーDto
	 * @param parent プロジェクトエンティティー
	 * @return プロジェクトメンバーエンティティ
	 */
	public ProjectMember convertUpdate(ProjectMemberDto src, Project parent)
	{
		ProjectMember dst = new ProjectMember(src, parent.registrantId);
		return dst;
	}

	/**
	 * プロジェクトメンバーDtoからプロジェクトメンバーエンティティへ変換.
	 *
	 * @param src    プロジェクトメンバーDto
	 * @param parent プロジェクトエンティティー
	 * @return プロジェクトメンバーエンティティ
	 */
	public ProjectMember convertDelete(ProjectMemberDto src, Project parent)
	{
		ProjectMember dst = new ProjectMember(src, parent.registrantId);
		return dst;
	}
}