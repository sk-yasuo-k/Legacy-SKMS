package services.accounting.entity;

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

import services.generalAffair.entity.VCurrentStaffName;



/**
 * 	通勤費申請履歴エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity
public class CommutationHistory implements Serializable {
	
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
	public String commutationMonthCode;
	
	/**
	 * 更新回数です。
	 */
	@Id
	public int updateCount;
	
	/**
	 * 通勤費手続状況IDです。
	 */
	public int commutationStatusId;
	
	/**
	 * 通勤費手続動作IDです。
	 */
	public int commutationActionId;
	

	/**
	 * 通勤費手続状況種別マスタ情報です。

	 */
	@OneToOne
	@JoinColumn(name="commutation_status_id")
	public MCommutationStatus commutationStatus;

	/**
	 * 通勤費手続動作種別マスタ情報です。

	 */
	@OneToOne
	@JoinColumn(name="commutation_action_id")
	public MCommutationAction commutationAction;
	
	
	
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
	 * 通勤費情報です。
	 */
    @ManyToOne
	@JoinColumns({@JoinColumn(name="staff_id", referencedColumnName="staff_id"),
		@JoinColumn(name="commutation_month_code", referencedColumnName="commutation_month_code")})
    public Commutation commutation;
	

}
