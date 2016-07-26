package services.project.dxo;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectDto;
import services.project.entity.Project;

/**
 * プロジェクト情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface ProjectDxo {

	/**
	 * プロジェクト情報エンティティからプロジェクト情報Dtoへ変換.
	 *
	 * @param src プロジェクト情報エンティティ
	 * @param dst プロジェクト情報Dto
	 */
	public void convert(Project src, ProjectDto dst);

	/**
	 * プロジェクト情報Dtoからプロジェクト情報エンティティへ変換.<br>
	 * プロジェクトメンバリストの変換あり.
	 *
	 * @param src   プロジェクト情報Dto
	 * @param staff ログイン社員情報
	 * @return プロジェクト情報エンティティ
	 */
	public Project convertCreate(ProjectDto src, MStaff staff);

	/**
	 * プロジェクト情報Dtoからプロジェクト情報エンティティへ変換.<br>
	 * プロジェクトメンバリストの変換なし.
	 *
	 * @param src   プロジェクト情報Dto
	 * @param staff ログイン社員情報
	 * @return プロジェクト情報エンティティ
	 */
	public Project convertUpdate(ProjectDto src, MStaff staff);
	
	/**
	 * プロジェクト情報Dtoからプロジェクト情報エンティティへ変換.<br>
	 * プロジェクトメンバリストの変換なし.
	 *
	 * @param src   プロジェクト情報Dto
	 * @param staff ログイン社員情報
	 * @return プロジェクト情報エンティティ
	 */
	public Project convertDelete(ProjectDto src, MStaff staff);
}
