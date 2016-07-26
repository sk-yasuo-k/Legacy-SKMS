package services.project.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;


/**
 * プロジェクト請求情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class ProjectBill implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	@Id
	public int projectId;

	/**
	 * 請求連番です。
	 */
	@Id
	public int billNo;

	/**
	 * 請求日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date billDate;

	/**
	 * 振込口座IDです。
	 */
	public int accountId;

	 /**
	  * 登録バージョンです。
	  */
	@Version
	public int registrationVer;


	/**
	 * プロジェクト請求項目情報リストです。
	 */
	@OneToMany(mappedBy="projectBill")
	public List<ProjectBillItem> projectBillItems;

//	/**
//	 * 振込口座情報です。
//	 */
//	@OneToOne
//	@JoinColumn(name="account_id")
//	public BankAccount bankAcount;

	/**
	 * プロジェクト情報です。
	 */
    @ManyToOne
	@JoinColumn(name="project_id")
    public Project project;
}