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

import services.generalAffair.entity.MStaff;
import services.project.entity.Project;


/**
 * 諸経費申請情報エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity
public class Overhead implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 諸経費申請IDです。
	 */
	@Id
	public int overheadId;

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
	public Project projectE;

	/**
	 * 社員情報です。
	 */
    @OneToOne
	@JoinColumn(name="staff_id")
	public MStaff staff;

	/**
	 * 交通費明細情報です。
	 */
	@OneToMany(mappedBy = "overhead")
	public List<OverheadDetail> overheadDetails;

	/**
	 * 交通費申請履歴情報です。
	 */
	@OneToMany(mappedBy = "overhead")
	public List<OverheadHistory> overheadHistorys;


}