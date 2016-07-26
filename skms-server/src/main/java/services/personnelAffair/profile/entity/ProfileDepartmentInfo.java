package services.personnelAffair.profile.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * プロフィール部署情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select md.department_name" +
				", d.*" +
				" from m_staff_department as d" +
				" inner join m_department md" +
				" on d.department_id = md.department_id" +
				" where (d.staff_id,d.update_count) in" +
					"(select staff_id, max(update_count)" +
					" from m_staff_department" +
					" group by staff_id)" +
				" and apply_date < now()" +
				" and cancel_date is null" +					
				")")
public class ProfileDepartmentInfo implements Serializable {

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
	
	/**
	 * 開始実績日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date applyDate;
}
