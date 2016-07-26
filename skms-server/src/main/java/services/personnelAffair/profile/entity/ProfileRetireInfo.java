package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * プロフィール退社情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select occured_date as retire_date" +
				",h.*" +
				" from staff_work_history as h" +
				" where (h.staff_id,h.update_count,h.work_event_id) in" +
					"(select staff_id, max(update_count), work_event_id" +
					" from staff_work_history" +
					" where work_event_id = 2" +
					" group by staff_id, work_event_id)" +
				")")
public class ProfileRetireInfo implements Serializable {

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
	 * 退社年月日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date retireDate;
}
