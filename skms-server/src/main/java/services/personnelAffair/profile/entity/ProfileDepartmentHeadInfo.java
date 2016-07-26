package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール所属部長情報エンティティクラスです。
 * 
 * @author t-ito
 * 
 */
@Entity(name="(select s.*, p.department_name" +
		" from m_staff_department_head s" +
		" inner join m_department p" +
		" on s.department_id = p.department_id" +
		" where (s.staff_id, s.update_count)" +
		" in (select staff_id, max(update_count)" +
		" from m_staff_department_head" +
		" group by staff_id)" +
		" and apply_date < now()" +
		" and cancel_date is null" +
		")")
public class ProfileDepartmentHeadInfo implements Serializable {

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
	 * 部署IDです。
	 */
    public Integer departmentId;
    
	/**
	 * 部署名です。
	 */
    public String departmentName;
}
