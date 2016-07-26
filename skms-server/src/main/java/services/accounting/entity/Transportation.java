package services.accounting.entity;

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

import services.accounting.dto.TransportationDto;
import services.generalAffair.entity.MStaff;
import services.project.entity.Project;

/**
 * 交通費申請情報エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity
public class Transportation implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 交通費申請IDです。
	 */
	@Id
	public int transportationId;

	/**
	 * プロジェクトIDです。
	 */
	public int projectId;

	/**
	 * 社員IDです。
	 */
	public int staffId;

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
	 * プロジェクト情報です。
	 */
	@OneToOne
	@JoinColumn(name="project_id")
	public Project projectInfo;

	/**
	 * 社員情報です。
	 */
    @OneToOne
	@JoinColumn(name="staff_id")
	public MStaff staff;

	/**
	 * 交通費明細情報です。
	 */
	@OneToMany(mappedBy = "transportation")
	public List<TransportationDetail> transportationDetails;

	/**
	 * 交通費申請履歴情報です。
	 */
	@OneToMany(mappedBy = "transportation")
	public List<TransportationHistory> transportationHistorys;


	/**
	 * コンストラクタ
	 */
	public Transportation()
	{
		;
	}

	/**
	 * コンストラクタ TransportationDtoを設定
	 */
	public Transportation(TransportationDto trans)
	{
		this.transportationId = trans.transportationId;
		this.projectId        = trans.projectId;
		this.staffId          = trans.staffId;
		this.registrantId     = trans.registrantId;
		this.registrationTime = trans.registrationTime;
		this.registrationVer  = trans.registrationVer;
	}

	/**
	 * コンストラクタ TransportationDto・Staffを設定
	 */
	public Transportation(TransportationDto trans, MStaff staff)
	{
		this.transportationId = trans.transportationId;
		this.projectId        = trans.projectId;
		this.staffId          = staff.staffId;
		this.registrantId     = staff.staffId;
		this.registrationTime = trans.registrationTime;
		this.registrationVer  = trans.registrationVer;
	}
}