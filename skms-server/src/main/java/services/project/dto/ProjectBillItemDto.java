package services.project.dto;

import java.io.Serializable;


/**
 * プロジェクト請求項目情報です。
 *
 * @author yasuo-k
 *
 */
public class ProjectBillItemDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	public int projectId;

	/**
	 * 請求連番です。
	 */
	public int billNo;

	/**
	 * 請求項目連番です。
	 */
	public int itemNo;

	/**
	 * 注文Noです。
	 */
	public String orderNo;

	/**
	 * 件名です。
	 */
	public String title;

	/**
	 * 請求額です。
	 */
	public String billAmount;


	/**
	 * 削除フラグです。
	 */
	public boolean isDelete;


	/**
	 * 削除確認.
	 */
	public boolean isDelete()
	{
		if (this.isDelete && (this.projectId > 0 && this.billNo > 0 && this.itemNo > 0)) 		return true;
		return false;
	}

	/**
	 * 更新確認.
	 */
	public boolean isUpdate()
	{
		if (!isDelete() && (this.projectId > 0 && this.billNo > 0 && this.itemNo > 0)) 			return true;
		return false;
	}

	/**
	 * 新規確認.
	 */
	public boolean isNew()
	{
		if (!this.isDelete && !(this.projectId > 0 && this.billNo > 0 && this.itemNo > 0)) 		return true;
		return false;
	}

}