package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.entity.MOccupationalCategory;
import services.personnelAffair.license.entity.MPayLicenceHistory;
import services.personnelAffair.skill.entity.MStaffAuthorizedLicence;
import services.personnelAffair.skill.entity.MStaffOtherLocence;
import services.system.entity.StaffSetting;

/**
 * 社員情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MStaff implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * ログイン名です。
	 */
	public String loginName;

	/**
	 * メールアドレスです。
	 */
	public String email;

	/**
	 * 誕生日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date birthday;

	/**
	 * 卒業年
	 */
	public Integer graduateYear;
	
	/**
	 * 出身校
	 */
	public String school;
	
	/**
	 * 学部
	 */
	public String department;
	
	/**
	 * 学科 
	 */
	public String course;
	
	/**
	 * 血液型
	 */
	public Integer bloodGroup;
	
	/**
	 * 性別
	 */
	public Integer sex;
	
	/**
	 * 緊急連絡先
	 */
	public String emergencyAddress;
	
	/**
	 * 本籍地(都道府県コード)
	 */
	public String legalDomicileCode;
	
	/**
	 * 入社前経験年数
	 */
	public Integer experienceYears;
	
	/**
	 * 職種ID
	 */
	public Integer occupationalCategoryId;

	/**
	 * 職種マスタです。
	 */
	@OneToOne
	@JoinColumn(name="occupational_category_id")
	public MOccupationalCategory mOccupationalCategory;

	/**
	 * 社員名情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public VCurrentStaffName staffName;
	
	/**
	 * 社員部署情報です。
	 */
	@OneToMany(mappedBy = "staff")
	public List<MStaffDepartment> staffDepartment;

	/**
	 * 社員部署長情報です。
	 */
	@OneToMany(mappedBy = "staff")
	public List<MStaffDepartmentHead> staffDepartmentHead;

	/**
	 * 社員経営役職情報です。
	 */
	@OneToMany(mappedBy = "staff")
	public List<MStaffManagerialPosition> staffManagerialPosition;

	/**
	 * 社員プロジェクト役職情報です。
	 */
	@OneToMany(mappedBy = "staff")
	public List<MStaffProjectPosition> staffProjectPosition;

	/**
	 * 現在の就労状況です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public VCurrentStaffWorkStatus currentStaffWorkStatus;

	/**
	 * 社員環境設定情報です。
	 */
    @OneToOne
	@JoinColumn(name="staff_id")
	public StaffSetting staffSetting;

	/**
	 * 就労状況履歴情報です。
	 */
	@OneToMany(mappedBy = "staff")
	public List<StaffWorkHistory> staffWorkHistory;

	/**
	 * 社員学歴マスタです。
	 */
	@OneToMany(mappedBy = "staff")
	public List<MStaffAcademicBackground> mStaffAcademicBackground;
	
//	/**
//	 * 社員職歴マスタです。
//	 */
//	@OneToMany(mappedBy = "staff")
//	public List<MStaffBusinessCareer> mStaffBusinessCareer;
	
	/**
	 * 社員所持認定資格マスタです。
	 */
	@OneToMany(mappedBy = "staff")
	public List<MStaffAuthorizedLicence> mStaffAuthorizedLicence;

	/**
	 * 社員所持その他資格マスタです。
	 */
	@OneToMany(mappedBy = "staff")
	public List<MStaffOtherLocence> mStaffOtherLocence;
	
	/**
	 * 委員会所属情報です。
	 */
	@OneToMany(mappedBy = "mStaff")
	public List<MStaffCommittee> mStaffCommittee;
	
	/**
	 * 資格手当取得履歴です。
	 */
	@OneToMany(mappedBy = "mStaff")
	public List<MPayLicenceHistory> mPayLicenceHistory;
	
	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	public int registrantId;

	/**
	 * 社員画像です。
	 */
	@Lob
	public byte[] staffImage;
	
	/**
	 * 内線番号です。
	 */
	public String extensionNumber;		
}