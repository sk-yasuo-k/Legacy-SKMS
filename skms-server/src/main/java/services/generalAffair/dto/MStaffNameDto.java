package services.generalAffair.dto;

import java.io.Serializable;
import java.sql.Time;
import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 社員名情報(登録)
 * 
 * @author nobuhiro-s
 * 
 */
public class MStaffNameDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 更新回数です。
	 */
	public int updateCount;
	
	/**
	 * 適用開始日です。
	 */
	public Date applyDate;
	
	/**
	 * 姓(漢字)です。
	 */
	public String lastName;

	/**
	 * 名(漢字)です。
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
	public Time registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	public int registrantId;
}