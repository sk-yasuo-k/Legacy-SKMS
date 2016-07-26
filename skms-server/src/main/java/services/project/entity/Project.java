package services.project.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import services.generalAffair.entity.MStaff;
import services.project.dto.ProjectDto;

/**
 * プロジェクト情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class Project implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	@Id
	public int projectId;

	/**
	 * プロジェクト種別です。
	 */
	public int projectType;

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

    @OneToOne
	@JoinColumn(name="customer_id")
	/**
	 * 顧客情報です。
	 */
	public MCustomer customer;

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
	@OneToMany(mappedBy = "project")
	public List<ProjectMember> projectMembers;

	/**
	 * 開始予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date planedStartDate;

	/**
	 * 完了予定日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date planedFinishDate;

	/**
	 * 開始実績日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date actualStartDate;

	/**
	 * 完了実績日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date actualFinishDate;

	/**
	 * 備考です。
	 */
	public String note;

	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(insertable=false, updatable=false)
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
	 * 削除フラグです.
	 */
	public boolean deleteFlg;


	/**
	 * プロジェクト請求リストです。
	 */
	@OneToMany(mappedBy = "project")
	public List<ProjectBill> projectBills;

	/**
	 * プロジェクト状況リストです。
	 */
	@OneToMany(mappedBy = "project")
	public List<ProjectSituation> projectSituations;



	/**
	 * コンストラクタ
	 */
	public Project()
	{
		;
	}

	/**
	 * コンストラクタ ProjectDto・Staffを設定
	 */
	public Project(ProjectDto project, MStaff staff)
	{
		this.projectId        = project.projectId;
		this.projectCode      = project.projectCode;
		this.projectName      = project.projectName;
		this.customerId       = project.customerId;
		this.orderNo          = project.orderNo;
		this.orderName        = project.orderName;
		this.planedStartDate  = project.planedStartDate;
		this.planedFinishDate = project.planedFinishDate;
		this.actualStartDate  = project.actualStartDate;
		this.actualFinishDate = project.actualFinishDate;
		this.registrantId     = staff.staffId;
		// registrationTime はデータベースで設定する.
		this.registrationVer  = project.registrationVer;
		this.note             = project.note;
	}

	/** プロジェクト種別 プロジェクト */
	public static int PROJECT_TYPE_PROJECT = 0;
	/** プロジェクト種別 全社業務 */
	public static int PROJECT_TYPE_ALL      = 1;

}