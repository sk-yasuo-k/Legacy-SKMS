package services.project.dxo;

import java.util.List;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectMemberDto;
import services.project.entity.Project;
import services.project.entity.ProjectMember;

/**
 * プロジェクトメンバー情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface ProjectMemberDxo {

	/**
	 * 社員情報エンティティリストから社員情報Dtoリストへ変換.
	 *
	 * @param  src 社員情報エンティティリスト
	 * @return プロジェクトメンバー情報Dtoリスト
	 */
	public List<ProjectMemberDto> convert(List<MStaff> src);

	/**
	 * プロジェクトメンバーDtoからプロジェクトメンバーエンティティへ変換.
	 *
	 * @param src    プロジェクトメンバーDto
	 * @param parent プロジェクトエンティティー
	 * @return プロジェクトメンバーエンティティ
	 */
	public ProjectMember convertCreate(ProjectMemberDto src, Project parent);

	/**
	 * プロジェクトメンバーDtoからプロジェクトメンバーエンティティへ変換.
	 *
	 * @param src    プロジェクトメンバーDto
	 * @param parent プロジェクトエンティティー
	 * @return プロジェクトメンバーエンティティ
	 */
	public ProjectMember convertUpdate(ProjectMemberDto src, Project parent);

	/**
	 * プロジェクトメンバーDtoからプロジェクトメンバーエンティティへ変換.
	 *
	 * @param src    プロジェクトメンバーDto
	 * @param parent プロジェクトエンティティー
	 * @return プロジェクトメンバーエンティティ
	 */
	public ProjectMember convertDelete(ProjectMemberDto src, Project parent);
}
