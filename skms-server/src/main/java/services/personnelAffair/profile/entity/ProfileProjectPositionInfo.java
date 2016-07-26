package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール役職情報エンティティクラスです。
 * 
 * @author t-ito
 * 
 */
@Entity(name="(select s.*, p.project_position_alias" +
		" from m_staff_project_position s" +
		" inner join m_project_position p" +
		" on s.project_position_id = p.project_position_id" +
		" where (s.staff_id, s.update_count)" +
		" in (select staff_id, max(update_count)" +
		" from m_staff_project_position" +
		" group by staff_id)" +
		" and apply_date < now()" +
		" and cancel_date is null" +
		")")
public class ProfileProjectPositionInfo implements Serializable {
	
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
	 * 役職IDです。
	 */
    public Integer projectPositionId;
    
	/**
	 * 役職略称です。
	 */
    public String projectPositionAlias;    
}
