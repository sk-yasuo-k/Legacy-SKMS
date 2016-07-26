package services.project.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;


/**
 * プロジェクト請求情報です。
 *
 * @author yasuo-k
 *
 */
public class ProjectBillDto implements Serializable {

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
	 * 請求日です。
	 */
	public Date billDate;

	/**
	 * 振込口座IDです。
	 */
	public int accountId;

	 /**
	  * 登録バージョンです。
	  */
	public int registrationVer;

	/**
	 * プロジェクト請求項目情報リストです。
	 */
	public List<ProjectBillItemDto> projectBillItems;

	/**
	 * プロジェクトその他請求項目情報リストです。
	 */
	public List<ProjectBillItemDto> projectBillOthers;


	/**
	 * 削除フラグです。
	 */
	public boolean isDelete;


	/**
	 * 削除確認.
	 */
	public boolean isDelete()
	{
		if (this.isDelete && (this.projectId > 0 && this.billNo > 0)) 		return true;
		return false;
	}

	/**
	 * 更新確認.
	 */
	public boolean isUpdate()
	{
		if (!isDelete() && (this.projectId > 0 && this.billNo > 0)) 		return true;
		return false;
	}

	/**
	 * 新規確認.
	 */
	public boolean isNew()
	{
		if (!this.isDelete && !(this.projectId > 0 && this.billNo > 0)) 	return true;
		return false;
	}
}