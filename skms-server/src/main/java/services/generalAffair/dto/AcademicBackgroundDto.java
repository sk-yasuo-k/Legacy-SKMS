package services.generalAffair.dto;

import java.io.Serializable;
import java.sql.Time;
import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 社員学歴情報Dtoです。
 * 
 * @author nobuhiro-s
 * 
 */
public class AcademicBackgroundDto implements Serializable {

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
	 * 発生日です。
	 */
	public Date occuredDate;
	
	/**
	 * 内容です。
	 */
	public String content;
	
	/**
	 * 登録日時です。
	 */
	public Time registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	public int registrantId;
	
}