package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.entity.VCurrentStaffName;

/**
 * プロフィール情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select extract(year from age(current_timestamp,birthday)) as age" +
				",mp_legal_domicile.name as legal_domicile_name" +
				",coalesce(s.experience_years,0) as before_experience_years" +
				",s.*" +
				" from m_staff s" +
				" left outer join m_prefecture mp_legal_domicile" +
				" on s.legal_domicile_code = mp_legal_domicile.code" +
				")")
public class ProfileInfo implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 血液型です。
	 */
	public Integer bloodGroup;
	
	/**
	 * 性別です。
	 */
	public Integer sex;
	
	/**
	 * 生年月日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date birthday;
	
	/**
	 * メールアドレスです。
	 */
	public String email;
	
	/**
	 * 緊急連絡先です。
	 */
	public String emergencyAddress;
	
	/**
	 * 本籍地(都道府県コード)です。
	 */
	public String legalDomicileCode;
	
	/**
	 * 本籍地(都道府県名)です。
	 */
	public String legalDomicileName;
	
	/**
	 * 入社前経験年数
	 */
	public Integer beforeExperienceYears;
	
	/**
	 * 年齢です。
	 */
	public Integer age;
	
	/**
	 * 内線番号です。
	 */
	public String extensionNumber;	

	/**
	 * 社員名情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public VCurrentStaffName staffName;
	
	/**
	 * プロフィール入社情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileJoinInfo profileJoinInfo;
	
	/**
	 * プロフィール退社情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileRetireInfo profileRetireInfo;
	
	/**
	 * プロフィール所属情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileDepartmentInfo profileDepartmentInfo;
	
	/**
	 * プロフィールプロジェクト情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileProjectInfo profileProjectInfo;
	
	/**
	 * プロフィール委員会情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileCommitteeInfo profileCommitteeInfo;
	
	/**
	 * プロフィール住所情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileAddressInfo profileAddressInfo;
	
	/**
	 * プロフィール携帯電話情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileHandyPhoneInfo profileHandyPhoneInfo;
	
	/**
	 * プロフィール就労状況履歴情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileWorkHistoryInfo profileWorkHistoryInfo;
	
	/**
	 * プロフィール資格情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileQualificationInfo profileQualificationInfo;
	
	/**
	 * プロフィール住宅手当情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileHousingAllowanceInfo profileHousingAllowanceInfo;
	
	/**
	 * プロフィール所属部長情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileDepartmentHeadInfo profileDepartmentHeadInfo;
	
	/**
	 * プロフィール役職情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileProjectPositionInfo profileProjecyPositionInfo;
	
	/**
	 * プロフィール経営役職情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileManagerialPositionInfo profileManagerialPositionInfo;	
	
	/**
	 * プロフィール経営役職情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileAuthorizedLicence profileAuthorizedLicence;	

	/**
	 * プロフィール最終学歴情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileAcademicBackground profileAcademicBackground;	
}
