package services.personnelAffair.skill.entity;


import java.io.Serializable;
import java.util.List;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * スキルシート用作業フェーズマスタエンティティクラスです。
 *
 * @author yoshinori-t
 *
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MSkillSheetPhase implements Serializable {

	private static final long serialVersionUID = 1L;
	
	/**
	 * 作業フェーズIDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = true)
	public Integer phaseId;
	
	/**
	 * 作業フェーズコードです。
	 */
	@Column(length = 8, nullable = true, unique = false)
	public String phaseCode;
	
	/**
	 * 作業フェーズ名です。
	 */
	@Column(length = 32, nullable = true, unique = false)
	public String phaseName;
	
	/**
	 * 社員スキルシート作業フェーズです。
	 */
	@OneToMany(mappedBy = "mSkillSheetPhase")
	public List<StaffSkillSheetPhase> staffSkillSheetPhaseList;

}