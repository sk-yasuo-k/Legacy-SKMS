package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 社員学歴マスタエンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity
public class MStaffAcademicBackground implements Serializable {

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
	 * 学歴連番です。
	 */
	@Id
	public int sequenceNo;
	
	/**
	 * 発生日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date occuredDate;
	
	/**
	 * 内容です。
	 */
	public String content;
	
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
