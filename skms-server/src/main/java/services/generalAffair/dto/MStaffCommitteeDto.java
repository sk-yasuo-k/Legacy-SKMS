package services.generalAffair.dto;

import java.io.Serializable;
import java.sql.Time;
import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 社員委員会所属情報です。
 * 
 * @author yasuo-k
 * 
 */
public class MStaffCommitteeDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;

	/**
	 * 社員名です。
	 */
	public String name;
	
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
	public String committeePositionId;
	
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
	public Date cancelDate;
	
	/**
	 * 登録日時です。
	 */
	public Time registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	public int registrantId;
	
	/**
	 * 経営役職IDです。
	 */
	public int managerialPositionId;
	
	//追加 @auther okamoto-y
	/**
	 * 日付設定用変数です。
	 */
	public Date edfcommitteeDate;
	
	//追加 @auther maruta
	/**
	 * 入会日です。
	 */ 
//	public Date edfenrollmentDate;
	
	/**
	 * 退会日です。
	 */ 
//	public Date edfwithdrawalDate;
	
	/**
	 * 委員長任命日です。
	 */ 
//	public Date edfjoinheadDate;
	
	/**
	 * 委員長退任日です。
	 */ 
//	public Date edfretireheadDate;
	
	/**
	 * 副委員長任命日です。
	 */ 
//	public Date edfjoinsubheadDate;
	
	/**
	 * 副委員長退任日です。
	 */ 
//	public Date edfretiresubheadDate;
	//
}