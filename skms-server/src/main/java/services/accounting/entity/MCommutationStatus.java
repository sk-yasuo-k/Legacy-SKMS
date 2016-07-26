package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 *通勤費手続き状態種別情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MCommutationStatus implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 通勤費手続き状態種別IDです。
	 */
	@Id
	public int commutationStatusId;

	/**
	 * 通勤費手続き状態種別名です。
	 */
	public String commutationStatusName;

	/**
	 * 通勤費手続き状態表示色です。
	 */
	public Integer commutationStatusColor;
}
