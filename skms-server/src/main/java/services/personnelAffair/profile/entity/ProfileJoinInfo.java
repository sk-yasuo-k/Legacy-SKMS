package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * プロフィール入社情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select h.occured_date as join_date" +
				",extract(year from age(current_timestamp,h.occured_date)) as service_years" +
				",h.*" +
				" from staff_work_history as h" +
				" where (h.staff_id,h.update_count,h.work_event_id) in" +
					"(select staff_id, max(update_count), work_event_id" +
					" from staff_work_history" +
					" where work_event_id = 1" +
					" group by staff_id, work_event_id)" +
				")")
public class ProfileJoinInfo implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public int staffId;
	
	/**
	 * 更新回数です。
	 */
	public Integer updateCount;
	
	/**
	 * 就労イベントIDです。
	 */
	public Integer workEventId;
	
	/**
	 * 入社年月日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date joinDate;
	
	/**
	 * 勤続年数です。
	 */
	public Integer serviceYears;
}
