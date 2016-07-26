package services.project.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import enumerate.ProjectPositionId;


/**
 * プロジェクト情報です。
 *
 * @author yasuo-k
 *
 */
public class ProjectDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	public int projectId;

	/**
	 * プロジェクトコードです。
	 */
	public String projectCode;

	/**
	 * プロジェクト名です。
	 */
	public String projectName;

	/**
	 * 顧客IDです。
	 */
	public Integer customerId;

	/**
	 * 顧客区分です。
	 */
	public String customerType;

	/**
	 * 顧客番号です。
	 */
	public String customerNo;

	/**
	 * 顧客名称です。
	 */
	public String customerName;

	/**
	 * 顧客略称です。
	 */
	public String customerAlias;

	/**
	 * 客先注文番号です。
	 */
	public String orderNo;

	/**
	 * 客先注文名称です。
	 */
	public String orderName;

	/**
	 * プロジェクトメンバー情報です。
	 */
	public List<ProjectMemberDto> projectMembers;
	
	/**
	 * 開始予定日です。
	 */
	public Date planedStartDate;

	/**
	 * 完了予定日です。
	 */
	public Date planedFinishDate;

	/**
	 * 開始実績日です。
	 */
	public Date actualStartDate;

	/**
	 * 完了実績日です。
	 */
	public Date actualFinishDate;

	/**
	 * 備考です。
	 */
	public String note;

	/**
	 * 登録バージョンです.
	 */
	public int registrationVer;

	/**
	 * プロジェクトマネージャです。
	 */
	public ProjectMemberDto projectManager;

	/**
	 * プロジェクト請求リストです。
	 */
	public List<ProjectBillDto> projectBills;

	/**
	 * プロジェクト状況リストです。
	 */
	public List<ProjectSituationDto> projectSituations;

	//追加 @auther maruta
	/**
	 * 報告日です。
	 */
	public Date reportingDate;
	
	/**
	 * プロジェクトマネージャの設定.
	 */
	public void setProjectManager()
	{
		if (this.projectMembers == null)	return;
		for (ProjectMemberDto member : this.projectMembers) {
			if (member.projectPositionId == null)	continue;
			if (member.projectPositionId == ProjectPositionId.PM) {
				this.projectManager = member;
				return;
			}
		}
	}

	/**
	 * プロジェクト情報 更新確認。
	 */
	public boolean isUpdate() {
		if (this.projectId > 0)	return true;
		return false;
	}

	/**
	 * プロジェクト情報 新規登録確認。
	 */
	public boolean isNew() {
		if (!isUpdate())		return true;
		return false;
	}

}