package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール住宅手当情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select mha.monthly_sum as housing_monthly_sum" +
				",ha.*" +
				" from m_staff_housing_allowance as ha" +
				" inner join m_housing_allowance mha" +
				" on ha.housing_id = mha.housing_id" +
				" where (ha.staff_id,ha.update_count) in" +
					"(select staff_id, max(update_count)" +
					" from m_staff_housing_allowance" +
					" group by staff_id)" +
				")")
public class ProfileHousingAllowanceInfo implements Serializable {

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
	 * 住宅補助手当IDです。
	 */
	public Integer housingId;
	
	/**
	 * 住宅補助手当です。
	 */
	public Integer housingMonthlySum;
}
