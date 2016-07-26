package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール就労状況履歴情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select mws.work_status_name" +
				",wh.*" +
				" from staff_work_history as wh" +
				" inner join m_work_status mws" +
				" on wh.work_status_id = mws.work_status_id" +
				" where (wh.staff_id,wh.update_count) in" +
					"(select staff_id, max(update_count)" +
					" from staff_work_history" +
					" group by staff_id)" +
				")")
public class ProfileWorkHistoryInfo implements Serializable {

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
	 * 就労状況種別IDです。
	 */
	public Integer workStatusId;
	
	/**
	 * 就労状況種別名です。
	 */
	public String workStatusName;
}
