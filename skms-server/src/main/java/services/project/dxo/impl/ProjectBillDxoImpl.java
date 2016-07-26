package services.project.dxo.impl;

import org.seasar.extension.jdbc.JdbcManager;

import services.project.dto.ProjectBillDto;
import services.project.dxo.ProjectBillDxo;
import services.project.entity.Project;
import services.project.entity.ProjectBill;


/**
 * プロジェクト請求情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class ProjectBillDxoImpl implements ProjectBillDxo {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * プロジェクト請求情報Dtoからプロジェクト請求情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求情報Dto
	 * @param parent プロジェクト情報.
	 * @return プロジェクト請求情報エンティティ.
	 */
	public ProjectBill convertCreate(ProjectBillDto src, Project parent)
	{
		ProjectBill dst = new ProjectBill();
		dst.projectId = parent.projectId;
		dst.billNo    = nextval_billNo(dst.projectId);
		dst.billDate  = src.billDate;
		dst.accountId = src.accountId;
		dst.registrationVer = src.registrationVer;
		return dst;
	}

	/**
	 * プロジェクト請求情報Dtoからプロジェクト請求情報エンティティへ変換.
	 *
	 * @param src プロジェクト請求情報Dto
	 * @param parent プロジェクト情報.
	 * @return プロジェクト請求情報エンティティ.
	 */
	public ProjectBill convertUpdate(ProjectBillDto src, Project parent)
	{
		ProjectBill dst = new ProjectBill();
		dst.projectId = src.projectId;
		dst.billNo    = src.billNo;
		dst.billDate  = src.billDate;
		dst.accountId = src.accountId;
		dst.registrationVer = src.registrationVer;
		return dst;
	}

//	convertUpdate() と同じ処理のためコメントアウトする.
//	/**
//	 * プロジェクト請求情報Dtoからプロジェクト請求情報エンティティへ変換.
//	 *
//	 * @param src プロジェクト請求情報Dto
//	 * @param parent プロジェクト情報.
//	 * @return プロジェクト請求情報エンティティ.
//	 */
//	public ProjectBill convertDelete(ProjectBillDto src, Project parent)
//	{
//		ProjectBill dst = new ProjectBill();
//		dst.projectId = src.projectId;
//		dst.billNo    = src.billNo;
//		dst.billDate  = src.billDate;
//		dst.accountId = src.accountId;
//		dst.registrationVer = src.registrationVer;
//		return dst;
//	}


	/**
	 * Next請求連番の発行.
	 *
	 * @param  projectId プロジェクトID.
	 * @return 請求連番.
	 */
	private int nextval_billNo(int projectId)
	{
		String maxSql = "select max(bill_no) from project_bill where project_id =" + projectId;
		Integer currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		return currval == null ? 1 : currval + 1;
	}
}