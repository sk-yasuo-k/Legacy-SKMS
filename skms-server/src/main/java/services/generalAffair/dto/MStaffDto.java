package services.generalAffair.dto;

import java.io.Serializable;
import java.sql.Time;
import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 社員情報Dto(登録)
 * 
 * @author nobuhiro-s
 * 
 */
public class MStaffDto implements Serializable {

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
	public Date birthday;
	
	/**
	 * 卒業年
	 */
	public int graduateYear;

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
	public int blood_group;
	
	/**
	 * 性別
	 */
	public int sex;
	
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
	public String experienceYears;
	
	/**
	 * 職種ID
	 */
	public int occupationalCategoryId;	
	
	/**
	 * 登録日時です。
	 */
	public Time registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	public int registrantId;
}