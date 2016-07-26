package services.accounting.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 通勤費手続き動作種別情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MCommutationAction implements Serializable {
	
	static final long serialVersionUID = 1L;

	/**
	 * 通勤費手続き動作種別IDです。
	 */
	@Id
	public int commutationActionId;

	/**
	 * 通勤費手続き動作種別名です。
	 */
	public String commutationActionName;
	
	

}
