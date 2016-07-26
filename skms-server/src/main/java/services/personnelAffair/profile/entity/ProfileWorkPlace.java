package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール勤務地情報エンティティクラスです。
 * 
 * @author t-ito
 * 
 */
@Entity(name="(select s.*, p.work_plase_name" +
		" from m_staff_work_place s" +
		" inner join m_work_place p" +
		" on s.work_place_id = p.work_place_id" +
		" where (s.staff_id, s.update_count)" +
		" in (select staff_id, max(update_count)" +
		" from m_staff_work_place" +
		" group by staff_id)" +
		")")
public class ProfileWorkPlace implements Serializable {
	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。
	 */
	@Id
	@GeneratedValue
	public Integer staffId;
	
	/**
	 * 更新回数です。
	 */
	public Integer updateCount;	

	/**
	 * 勤務地IDです。
	 */
	public Integer workPlaceId;

	/**
	 * 勤務地名です。
	 */
	public String workPlaseName;	
	
}
