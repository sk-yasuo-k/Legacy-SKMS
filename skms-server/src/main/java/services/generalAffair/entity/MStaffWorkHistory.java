package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 社員就労履歴です。
 *
 * @author t-ito
 *
 */
@Entity(name = "StaffWorkHistory")
public class MStaffWorkHistory implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 更新回数です。
	 */
	@Id
	public int updateCount;	
	
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
