package services.accounting.dto;

import java.io.Serializable;


/**
 * 月別交通費です.
 *
 * @author yasuo-k
 *
 */
public class ProjectTransportationMonthlyDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * オブジェクトIDです.
	 */
	public int objectId;

	/**
	 * 集計月です。
	 * フォーマット：yyyy/mm.
	 */
	public String yyyymm;

	/**
	 * 集計金額です。
	 */
	public int expense;
}