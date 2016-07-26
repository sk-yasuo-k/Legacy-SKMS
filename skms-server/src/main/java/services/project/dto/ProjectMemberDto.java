package services.project.dto;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.entity.MStaff;

/**
 * プロジェクトメンバー情報です。
 *
 * @author yasuo-k
 *
 */
public class ProjectMemberDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	public int projectId;

	/**
	 * 社員IDです。
	 */
	public int staffId;

	/**
	 * 社員名です。
	 */
	public String staffName;

	/**
	 * 姓です。
	 */
	public String lastName;

	/**
	 * 名です。
	 */
	public String firstName;

	/**
	 * 姓(かな)です。
	 */
	public String lastNameKana;

	/**
	 * 名(かな)です。
	 */
	public String firstNameKana;

	/**
	 * プロジェクト役職IDです。
	 */
	public Integer projectPositionId;

	/**
	 * プロジェクト役職種別略称です。
	 */
	public String projectPositionAlias;

	/**
	 * プロジェクト役職種別名称です。
	 */
	public String projectPositionName;

	/**
	 * 参加開始予定日です。
	 */
	public Date planedStartDate;

	/**
	 * 参加終了予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date planedFinishDate;

	/**
	 * 参加開始予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date actualStartDate;

	/**
	 * 参加終了予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date actualFinishDate;

	/**
	 * 登録バージョンです.
	 */
	public int registrationVer;

	/**
	 * 削除フラグです.
	 */
	public boolean isDelete = false;

	/**
	 * コンストラクタ.
	 */
	public ProjectMemberDto()
	{
	}

	/**
	 * コンストラクタ Staffを設定.
	 */
	public ProjectMemberDto(MStaff staff)
	{
		this.staffId = staff.staffId;
		this.staffName = staff.staffName.fullName;
	}

	/**
	 * 削除確認.
	 */
	public boolean isDelete() {
		if (this.isDelete && isConstraint()) 	return true;
		return false;
	}

	/**
	 * 更新確認.
	 */
	public boolean isUpdate() {
		if (!isDelete() && isConstraint()) 		return true;
		return false;
	}

	/**
	 * 新規確認.
	 */
	public boolean isNew() {
		if (!this.isDelete && !isConstraint()) 	return true;
		return false;
	}

	/**
	 * Constraint確認
	 */
	private boolean isConstraint() {
		if (this.projectId > 0)	return true;
		return false;
	}

}