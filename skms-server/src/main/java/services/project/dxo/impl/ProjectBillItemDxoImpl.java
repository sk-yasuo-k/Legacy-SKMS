package services.project.dxo.impl;

import org.seasar.extension.jdbc.JdbcManager;

import services.project.dto.ProjectBillItemDto;
import services.project.dxo.ProjectBillItemDxo;
import services.project.entity.ProjectBill;
import services.project.entity.ProjectBillItem;


/**
 * プロジェクト請求項目情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class ProjectBillItemDxoImpl implements ProjectBillItemDxo {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * プロジェクト請求項目情報Dtoからプロジェクト請求項目情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求項目情報Dto
	 * @param parent プロジェクト請求情報エンティティ.
	 * @param taxFlg 課税対象フラグ.
	 * @return プロジェクト請求項目情報エンティティ.
	 */
	public ProjectBillItem convertCreate(ProjectBillItemDto src, ProjectBill parent, boolean taxFlg)
	{
		ProjectBillItem dst = new ProjectBillItem();
		dst.projectId = parent.projectId;
		dst.billNo    = parent.billNo;;
		dst.itemNo    = nextval_itemNo(dst.projectId, dst.billNo);
		dst.orderNo   = src.orderNo;
		dst.title     = src.title;
		dst.billAmount= (src.billAmount != null && src.billAmount.trim().length() > 0) ? Long.parseLong(src.billAmount) : null;
		dst.taxFlg    = taxFlg;
		return dst;
	}

	/**
	 * プロジェクト請求項目情報Dtoからプロジェクト請求項目情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求項目情報Dto
	 * @param parent プロジェクト請求情報エンティティ.
	 * @param taxFlg 課税対象フラグ.
	 * @return プロジェクト請求項目情報エンティティ.
	 */
	public ProjectBillItem convertUpdate(ProjectBillItemDto src, ProjectBill parent, boolean taxFlg)
	{
		ProjectBillItem dst = new ProjectBillItem();
		dst.projectId = parent.projectId;
		dst.billNo    = parent.billNo;;
		dst.itemNo    = src.itemNo;
		dst.orderNo   = src.orderNo;
		dst.title     = src.title;
		dst.billAmount= (src.billAmount != null && src.billAmount.trim().length() > 0) ? Long.parseLong(src.billAmount) : null;
		dst.taxFlg    = taxFlg;
		return dst;
	}

//	convertUpdate() と同じ処理のためコメントアウトする.
//	/**
//	 * プロジェクト請求項目情報Dtoからプロジェクト請求項目情報エンティティへ変換.
//	 *
//	 * @param src プロジェクト請求項目情報Dto
//	 * @param parent プロジェクト請求情報エンティティ.
//	 * @param taxFlg 課税対象フラグ.
//	 * @return プロジェクト請求項目情報エンティティ.
//	 */
//	public ProjectBillItem convertDelete(ProjectBillItemDto src, ProjectBill parent, boolean taxFlg)
//	{
//		ProjectBillItem dst = new ProjectBillItem();
//		dst.projectId = parent.projectId;
//		dst.billNo    = parent.billNo;;
//		dst.itemNo    = src.itemNo;
//		dst.orderNo   = src.orderNo;
//		dst.title     = src.title;
//		dst.billAmount= (src.billAmount != null && src.billAmount.trim().length() > 0) ? Long.parseLong(src.billAmount) : null;
//		dst.taxFlg    = taxFlg;
//		return dst;
//	}

	/**
	 * Next請求項目連番の発行.
	 *
	 * @param  projectId プロジェクトID.
	 * @param  billNo    プロジェクト請求連番.
	 * @return 請求項目連番.
	 */
	private int nextval_itemNo(int projectId, int billNo)
	{
		String maxSql = "select max(item_no) from project_bill_item where project_id =" + projectId + " and bill_no = " + billNo;
		Integer currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		return currval == null ? 1 : currval + 1;
	}
}