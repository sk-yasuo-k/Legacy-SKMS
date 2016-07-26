package services.project.dxo;

import services.project.dto.ProjectBillDto;
import services.project.entity.Project;
import services.project.entity.ProjectBill;


/**
 * プロジェクト請求情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface ProjectBillDxo {

	/**
	 * プロジェクト請求情報Dtoからプロジェクト請求情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求情報Dto
	 * @param parent プロジェクト情報.
	 * @return プロジェクト請求情報エンティティ.
	 */
	public ProjectBill convertCreate(ProjectBillDto src, Project parent);


	/**
	 * プロジェクト請求情報Dtoからプロジェクト請求情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求情報Dto
	 * @param parent プロジェクト情報.
	 * @return プロジェクト請求情報エンティティ.
	 */
	public ProjectBill convertUpdate(ProjectBillDto src, Project parent);


//	convertUpdate() と同じ処理のためコメントアウトする.
//	/**
//	 * プロジェクト請求情報Dtoからプロジェクト請求情報エンティティへ変換.
//	 *
//	 * @param src プロジェクト請求情報Dto
//	 * @param parent プロジェクト情報.
//	 * @return プロジェクト請求情報エンティティ.
//	 */
//	public ProjectBill convertDelete(ProjectBillDto src, Project parent);

}
