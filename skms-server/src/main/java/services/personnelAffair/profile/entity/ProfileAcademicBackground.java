package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール最終学歴情報エンティティクラスです。
 * 
 * @author t-ito
 * 
 */

@Entity(name="(select sab.staff_id, sab.sequence_no,content " +
				"from m_staff_academic_background as sab " +
				"where (sab.staff_id, sab.sequence_no) in " +
					"(select staff_id, max(sequence_no) " +
					"from m_staff_academic_background " +
					"group by staff_id " +
				"))")
public class ProfileAcademicBackground implements Serializable {
	
	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 学歴連番です。
	 */
	public int sequenceNo;
	
	/**
	 * 内容です。
	 */
	public String content;	
}
