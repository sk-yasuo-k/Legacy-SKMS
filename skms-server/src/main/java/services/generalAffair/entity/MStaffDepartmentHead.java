package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 社員部署長情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MStaffDepartmentHead implements Serializable {

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
	 * 更新回数です。
	 */
	@Id
	public int updateCount;

	/**
	 * 部署IDです。
	 */
	public int departmentId;

	/**
	 * 適用開始日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date applyDate;

	/**
	 * 適用解除日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date cancelDate;

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