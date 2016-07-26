package services.generalAffair.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 社員名情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MStaffName extends BaseStaffName implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 更新回数です。
	 */
	@Id
	public int updateCount;


}