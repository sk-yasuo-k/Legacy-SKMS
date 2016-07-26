package services.project.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import services.generalAffair.entity.MProjectPosition;
import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectMemberDto;

/**
 * プロジェクトメンバー情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class ProjectMember implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	@Id
	public int projectId;

	/**
	 * プロジェクト情報です。
	 */
    @ManyToOne
	@JoinColumn(name="project_id")
    public Project project;

	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 社員情報です。
	 */
    @OneToOne
	@JoinColumn(name="staff_id")
    public MStaff staff;

	/**
	 * プロジェクト役職IDです。
	 */
	public Integer projectPositionId;

	/**
	 * 役職情報です。
	 */
    @OneToOne
	@JoinColumn(name="project_position_id")
	public MProjectPosition projectPosition;

	/**
	 * 参加開始予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date planedJoinDate;

	/**
	 * 参加終了予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date planedRetireDate;

	/**
	 * 参加開始予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date actualJoinDate;

	/**
	 * 参加終了予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date actualRetireDate;

	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	@Version
	public int registrationVer;


	/**
	 * コンストラクタ
	 */
	public ProjectMember()
	{
		;
	}

	/**
	 * コンストラクタ ProjectMemberDto・Staffを設定
	 */
	public ProjectMember(ProjectMemberDto member, int registStaffId)
	{
		this.projectId        = member.projectId;
		this.staffId          = member.staffId;
		this.planedJoinDate   = member.planedStartDate;
		this.planedRetireDate = member.planedFinishDate;
		this.actualJoinDate   = member.actualStartDate;
		this.actualRetireDate = member.actualFinishDate;
		this.projectPositionId= member.projectPositionId > 0 ? member.projectPositionId : null;
		this.registrantId     = registStaffId;
		// registrationTime はデータベースで設定する.
		this.registrationVer  = member.registrationVer;
	}
}