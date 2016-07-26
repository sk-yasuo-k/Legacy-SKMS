package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール委員会情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select mc.committee_name" +
				",c.*" +
				" from m_staff_committee as c" +
				" inner join m_committee mc" +
				" on c.committee_id = mc.committee_id" +
				" where (c.staff_id,c.update_count) in" +
					"(select staff_id, max(update_count)" +
					" from m_staff_committee" +
					" where cancel_date is null" +
					" group by staff_id)" +
				")")
public class ProfileCommitteeInfo implements Serializable {

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
	 * 委員会IDです。
	 */
	public Integer committeeId;
	
	/**
	 * 委員会名です。
	 */
	public String committeeName;
}
