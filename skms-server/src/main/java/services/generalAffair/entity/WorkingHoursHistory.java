package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 勤務管理表手続き履歴情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class WorkingHoursHistory implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 社員名です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public VCurrentStaffName staffName;

	/**
	 * 勤務月コードです。
	 */
	@Id
	public String workingMonthCode;

	/**
	 * 更新回数です。
	 */
	@Id
	public int updateCount;

	/**
	 * 勤務管理表手続状況IDです。
	 */
	public int workingHoursStatusId;

	/**
	 * 勤務管理表手続動作IDです。
	 */
	public int workingHoursActionId;

	/**
	 * 勤務管理表手続状況種別マスタ情報です。

	 */
	@OneToOne
	@JoinColumn(name="working_hours_status_id")
	public MWorkingHoursStatus workingHoursStatus;

	/**
	 * 勤務管理表手続動作種別マスタ情報です。

	 */
	@OneToOne
	@JoinColumn(name="working_hours_action_id")
	public MWorkingHoursAction workingHoursAction;

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
	 * 登録者氏名です。

	 */
	public String registrantName;

	/**
	 * コメントです。

	 */
	public String comment;

	/**
	 * 勤務時間(月別)情報です。
	 */
    @ManyToOne
	@JoinColumns({@JoinColumn(name="staff_id", referencedColumnName="staff_id"),
		@JoinColumn(name="working_month_code", referencedColumnName="working_month_code")})
    public WorkingHoursMonthly workingHoursMonthly;
	
}