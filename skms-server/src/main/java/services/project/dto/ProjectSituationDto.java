package services.project.dto;

import java.io.Serializable;
import java.util.Date;


/**
 * プロジェクト状況情報です。
 *
 * @author yasuo-k
 *
 */
public class ProjectSituationDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	public int projectId;

	/**
	 * プロジェクト状況連番です。
	 */
	public int situationNo;

	/**
	 * プロジェクト状況です。
	 */
	public String situation;

	/**
	 * 登録日時です。
	 */
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	public int registrationVer;

	/**
	 * 登録者名です。
	 */
	public String registrationName;

//	/**
//	 * 削除フラグです。
//	 */
//	public boolean isDelete;
//
//
	/**
	 * 削除確認.
	 */
	private boolean isDelete()
	{
		return false;
	}

	/**
	 * 更新確認.
	 */
	public boolean isUpdate()
	{
		if (!isDelete() && (this.projectId > 0 && this.situationNo > 0)) 	return true;
		return false;
	}

	/**
	 * 新規確認.
	 */
	public boolean isNew()
	{
		if (!isDelete() && !(this.projectId > 0 && this.situationNo > 0)) 	return true;
		return false;
	}
}