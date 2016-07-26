package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 社員就労履歴です。
 *
 * @author yasuo-k
 *
 */
@MappedSuperclass
public class BaseStaffWorkHistory implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;

	/**
	 * 社員情報です。
	 */
    @ManyToOne
	@JoinColumn(name="staff_id")
    public MStaff staff;
    
	/**
	 * 発生日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date occuredDate;

	/**
	 * 就労イベント種別IDです。
	 */
	public int workEventId;

	/**
	 * 就労状況種別IDです。
	 */
	public int workStatusId;

	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	public int registrantId;

}