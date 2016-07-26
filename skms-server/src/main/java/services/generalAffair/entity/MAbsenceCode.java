package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 休憩時間規定です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MAbsenceCode implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 勤休コードです。
	 */
	@Id
	public int absenceCode;

	/**
	 * 勤休内容です。
	 */
	public String absenceName;

	/**
	 * 表示順序です。
	 */
	public int dispOrder;

	
}