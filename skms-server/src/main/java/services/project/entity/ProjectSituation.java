package services.project.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import services.generalAffair.entity.MStaff;


/**
 * プロジェクト状況情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class ProjectSituation implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	@Id
	public int projectId;

	/**
	 * プロジェクト状況連番です。
	 */
	@Id
	public int situationNo;

	/**
	 * プロジェクト状況です。
	 */
	public String situation;

	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(insertable=false, updatable=false)
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	@Column(updatable=false)
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	@Version
	public int registrationVer;

	/**
	 * 社員情報です。
	 */
    @OneToOne
	@JoinColumn(name="registrant_id", referencedColumnName="staff_id")
    public MStaff staff;


	/**
	 * プロジェクト情報です。
	 */
    @ManyToOne
	@JoinColumn(name="project_id")
    public Project project;
}