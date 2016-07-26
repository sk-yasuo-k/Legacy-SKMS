package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import services.accounting.entity.OverheadHistory;


/**
 * 諸経費情報のDTOです.
 *
 */
public class OverheadDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 諸経費申請IDです.
	 */
	public int overheadId;

	/**
	 * プロジェクトIDです.
	 */
	public int projectId;

	/**
	 * プロジェクト名です.
	 */
	public String projectName;

	/**
	 * プロジェクトコードです.
	 */
	public String projectCode;

//	/**
//	 * プロジェクト情報です.
//	 */
//	public ProjectDto project;

	/**
	 * 社員IDです.
	 */
	public int staffId;

	/**
	 * 社員名です.
	 */
	public String staffName;

//	/**
//	 * 社員情報です.
//	 */
//	public MStaff staff;

	/**
	 * 諸経費申請状態IDです.
	 */
	public int overheadStatusId;

	/**
	 * 諸経費申請状態名です.
	 */
	public String overheadStatusName;

	/**
	 * 諸経費申請履歴情報です.
	 */
	public List<OverheadHistory> overheadHistorys;


//	/**
//	 * 諸経費申請動作IDです.
//	 */
//	public int overheadActionId;
//
	/**
	 * 諸経費申請実行可否リストです.
	 */
	public List<Integer> overheadNextActions;


//	/**
//	 * 諸経費申請状態名です.
//	 */
//	public String overheadActionName;
//
//	/**
//	 * 諸経費申請履歴情報です.
//	 */
//	public List<OverheadHistory> overheadHistorys;

	/**
	 * 諸経費明細情報です.
	 */
	public List<OverheadDetailDto> overheadDetails;

	/**
	 * 登録日時です.
	 */
	public Date registrationTime;

	/**
	 * 登録者IDです.
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	public int registrationVer;


	/**
	 * 交通費申請情報 削除確認.
	 */
	public boolean isDelete() {
		return isUpdate();
	}

	/**
	 * 交通費申請情報 更新確認.
	 */
	public boolean isUpdate() {
		if (this.overheadId > 0)	return true;
		return false;
	}

	/**
	 * 交通費申請情報 新規登録確認.
	 */
	public boolean isNew() {
		if (!isUpdate())		return true;
		return false;
	}
}