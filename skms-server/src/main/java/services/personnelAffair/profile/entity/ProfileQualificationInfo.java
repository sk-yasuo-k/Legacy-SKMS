package services.personnelAffair.profile.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロフィール資格情報エンティティクラスです。
 * 
 * @author yoshinori-t
 * 
 */
@Entity(name="(select mb.class_no as basic_class_no" +
				",mb.rank_no as basic_rank_no" +
				",mb.monthly_sum as basic_monthly_sum" +
				",mma.class_no as managerial_class_no" +
				",mma.monthly_sum as managerial_monthly_sum" +
				",mca.class_no as competent_class_no" +
				",mca.monthly_sum as competent_monthly_sum" +
				",mta.class_no as technical_skill_class_no" +
				",mta.monthly_sum as technical_skill_monthly_sum" +
				",q.*" +
				" from m_staff_qualification as q" +
				" left outer join m_basic_pay mb" +
				" on q.basic_pay_id = mb.basic_pay_id" +
				" left outer join m_managerial_allowance mma" +
				" on q.managerial_id = mma.managerial_id" +
				" left outer join m_competent_allowance mca" +
				" on q.competent_id = mca.competent_id" +
				" left outer join m_technical_skill_allowance mta" +
				" on q.technical_skill_id = mta.technical_skill_id" +
				" where (q.staff_id,q.update_count) in" +
					"(select staff_id, max(update_count)" +
					" from m_staff_qualification" +
					" group by staff_id)" +
				")")
public class ProfileQualificationInfo implements Serializable {

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
	 * 資格（等級）です。
	 */
	public Integer basicClassNo;
	
	/**
	 * 資格（号）です。
	 */
	public Integer basicRankNo;
	
	/**
	 * 基本給です。
	 */
	public Integer basicMonthlySum;
	
	/**
	 * 職務等級です。
	 */
	public Integer managerialClassNo;
	
	/**
	 * 職務手当です。
	 */
	public Integer managerialMonthlySum;
	
	/**
	 * 主務等級です。
	 */
	public Integer competentClassNo;
	
	/**
	 * 主務手当です。
	 */
	public Integer competentMonthlySum;
	
	/**
	 * 技能等級です。
	 */
	public Integer technicalSkillClassNo;
	
	/**
	 * 技能手当です。
	 */
	public Integer technicalSkillMonthlySum;
}
