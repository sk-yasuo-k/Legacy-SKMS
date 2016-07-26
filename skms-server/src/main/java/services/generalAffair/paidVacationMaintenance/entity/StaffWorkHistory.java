package services.generalAffair.paidVacationMaintenance.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;


/**
 * 就労中社員一覧です。
 * 
 * @author t-ito
 * 
 */
@Entity(name="(select swh.staff_id" +
				" ,csn.full_name" +	
				" ,swh.update_count" +					
				" from staff_work_history as swh" +
				" inner join v_current_staff_name csn" +
				" on swh.staff_id = csn.staff_id" +
				")")
public class StaffWorkHistory implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 社員名です。
	 */
	public String fullName;

	/**
	 * 更新回数です。
	 */
	@Id
	public int updateCount;		
}	
