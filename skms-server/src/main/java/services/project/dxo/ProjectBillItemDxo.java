package services.project.dxo;

import services.project.dto.ProjectBillItemDto;
import services.project.entity.ProjectBill;
import services.project.entity.ProjectBillItem;


/**
 * プロジェクト請求項目情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface ProjectBillItemDxo {

	/**
	 * プロジェクト請求項目情報Dtoからプロジェクト請求項目情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求項目情報Dto
	 * @param parent プロジェクト請求情報エンティティ.
	 * @param taxFlg 課税対象フラグ.
	 * @return プロジェクト請求項目情報エンティティ.
	 */
	public ProjectBillItem convertCreate(ProjectBillItemDto src, ProjectBill parent, boolean taxFlg);


	/**
	 * プロジェクト請求項目情報Dtoからプロジェクト請求項目情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求項目情報Dto
	 * @param parent プロジェクト請求情報エンティティ.
	 * @param taxFlg 課税対象フラグ.
	 * @return プロジェクト請求項目情報エンティティ.
	 */
	public ProjectBillItem convertUpdate(ProjectBillItemDto src, ProjectBill parent, boolean taxFlg);

//	convertUpdate() と同じ処理のためコメントアウトする.
//	/**
//	 * プロジェクト請求項目情報Dtoからプロジェクト請求項目情報エンティティへ変換.
//	 *
//	 * @param src プロジェクト請求項目情報Dto
//	 * @param parent プロジェクト請求情報エンティティ.
//	 * @param taxFlg 課税対象フラグ.
//	 * @return プロジェクト請求項目情報エンティティ.
//	 */
//	public ProjectBillItem convertDelete(ProjectBillItemDto src, ProjectBill parent, boolean taxFlg);
}
