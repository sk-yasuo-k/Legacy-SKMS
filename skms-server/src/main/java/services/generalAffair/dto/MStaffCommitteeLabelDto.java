package services.generalAffair.dto;

import java.io.Serializable;
import java.sql.Time;
import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 社員委員会所属情報(登録・削除用)です。
 * 
 * @author yasuo-k
 * 
 */
public class MStaffCommitteeLabelDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;

	/**
	 * 社員名(フル)です。
	 */
	public String fullName;
	
	/**
	 * 更新回数です。
	 */
	public int updateCount;

	/**
	 * 委員会IDです。
	 */
	public int committeeId;
	
	/**
	 * 委員会名です。
	 */
	public String committeeName;

	/**
	 * 委員会役職IDです。
	 */
	public int committeePositionId;
	
	/**
	 * 委員会役職名です。
	 */
	public String committeePositionName;
	
	/**
	 * 適用開始日です。
	 */
	public Date applyDate;
	
	/**
	 * 適用解除日です。
	 */
	public Date canceldate;
	
	/**
	 * 登録日時です。
	 */
	public Time registrationtime;
	
	/**
	 * 登録者IDです。
	 */
	public int registrantid;
		
}