package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;

/**
 * 現在の社員名情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class VCurrentStaffName extends BaseStaffName implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 更新回数です。
	 */
	public int updateCount;	
	
	/**
	 * 姓名です。
	 */
	public String fullName;

	/**
	 * 姓名(かな)です。
	 */
	public String fullNameKana;	
}

