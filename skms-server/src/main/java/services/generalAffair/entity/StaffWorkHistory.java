package services.generalAffair.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 社員就労履歴です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class StaffWorkHistory extends BaseStaffWorkHistory implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 更新回数です。
	 */
	@Id
	public int updateCount;


}