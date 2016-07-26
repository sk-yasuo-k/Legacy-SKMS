package services.accounting.entity;

import java.io.Serializable;



/**
 * プロジェクト別交通費エンティティです.

 *
 * @author yasuo-k
 *
 */
public class ProjectTransportation implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです.
	 */
	public Integer projectId;

	/**
	 * プロジェクト種別です.
	 */
	public Integer projectType;

	/**
	 * プロジェクトコードです.
	 */
	public String projectCode;

	/**
	 * プロジェクト名です.
	 */
	public String projectName;

	/**
	 * 社員IDです.
	 */
	public Integer staffId;

	/**
	 * 社員名です.
	 */
	public String fullName;

	/**
	 * 社員就労状態です.
	 */
	public Integer workStatusId;

	/**
	 * 集計月です.
	 * フォーマット：yyyy/mm.
	 */
	public String yyyymm;

	/**
	 * 集計金額です.

	 */
	public int expense;
}