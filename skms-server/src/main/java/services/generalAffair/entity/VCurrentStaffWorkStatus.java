package services.generalAffair.entity;

import java.io.Serializable;
import javax.persistence.Entity;

/**
 * 現在の社員就労状況です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class VCurrentStaffWorkStatus extends BaseStaffWorkHistory implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 更新回数です。
	 */
	public int updateCount;


}