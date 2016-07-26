package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 社員名情報です。
 * 
 * @author yasuo-k
 * 
 */
@MappedSuperclass
public class BaseStaffName implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 社員情報です。
	 */
    @ManyToOne
	@JoinColumn(name="staff_id")
    public MStaff staff;

	/**
	 * 適用開始日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date applyDate;

	/**
	 * 姓です。
	 */
	public String lastName;

	/**
	 * 名です。
	 */
	public String firstName;

	/**
	 * 姓(かな)です。
	 */
	public String lastNameKana;

	/**
	 * 名(かな)です。
	 */
	public String firstNameKana;

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