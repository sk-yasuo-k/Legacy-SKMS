package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import services.personnelAffair.skill.entity.MStaffAuthorizedLicence;
import services.personnelAffair.skill.entity.MStaffOtherLocence;


/**
 * プロフィール詳細エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select s.*" +
				" from m_staff s" +
				")")
public class ProfileDetail implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 社員画像です。
	 */
	@Lob
	public byte[] staffImage;
	
	/**
	 * プロフィール勤務地情報です。
	 */
	@OneToOne
	@JoinColumn(name="staff_id")
	public ProfileWorkPlace profileWorkPlace;
	
    /** 
     * 社員所持認定資格マスタです。
     */
    @OneToMany(mappedBy = "profileDetail")
    public List<MStaffAuthorizedLicence> mStaffAuthorizedLicence;
    
    /** 
     * 社員所持その他資格マスタです。
     */
    @OneToMany(mappedBy = "profileDetail")
    public List<MStaffOtherLocence> mStaffOtherLocence;
    
    /** 
     * セミナー受講者です。
     */
    @OneToMany(mappedBy = "profileDetail")
    public List<SeminarParticipant> seminarParticipant;    
}
