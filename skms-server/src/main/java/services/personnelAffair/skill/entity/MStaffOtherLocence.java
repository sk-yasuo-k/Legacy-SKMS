package services.personnelAffair.skill.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.entity.MStaff;
import services.personnelAffair.profile.entity.ProfileDetail;

/**
 * 社員所持その他資格マスタエンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity
public class MStaffOtherLocence implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = true)
	public Integer staffId;
	
	/**
	 * 資格連番です。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = true)
	public Integer sequenceNo;
	
	/**
	 * 資格名です。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String licenceName;
	
	/**
	 * 取得日です。
	 */
	@Column(nullable = true, unique = false)
	@Temporal(TemporalType.DATE)
	public Date acquisitionDate;
	
	/**
	 * 登録日時です。
	 */
	@Column(nullable = true, unique = false)
	@Temporal(TemporalType.TIMESTAMP)
	public Date registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	@Column(precision = 10, nullable = true, unique = false)
	public Integer registrantId;
	
	/**
	 * 社員情報です。
	 */
	@ManyToOne
	@JoinColumn(name="staff_id")
	public MStaff staff;

	/**
	 * プロフィール詳細です。
	 */
	@ManyToOne
	@JoinColumn(name="staff_id")
	public ProfileDetail profileDetail;	
}
