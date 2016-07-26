package services.personnelAffair.skill.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

import services.generalAffair.entity.MStaff;

/**
 * 社員スキルシート作業フェーズエンティティクラスです。
 *
 * @author yoshinori-t
 *
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class StaffSkillSheetPhase implements Serializable {

	private static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = false)
	public Integer staffId;
	
	/**
	 * スキルシート連番です。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = false)
	public Integer sequenceNo;
	
	/**
	 * 作業フェーズIDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = false)
	public Integer phaseId;
	
	/**
	 * 登録日時です。
	 */
	@Column(nullable = true, unique = false)
	public Timestamp registrationTime;
	
	/**
	 * 登録者です。
	 */
	@Column(precision = 10, nullable = true, unique = false)
	public Integer registrantId;
	
	/**
	 * 社員マスタです。
	 */
	@ManyToOne
	@JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
	public MStaff mStaff;
	
	/**
	 * 社員スキルシートです。
	 */
	@ManyToOne
	@JoinColumns( {
		@JoinColumn(name = "staff_id", referencedColumnName = "staff_id"),
		@JoinColumn(name = "sequence_no", referencedColumnName = "sequence_no") })
	public StaffSkillSheet staffSkillSheet;
	
	/**
	 * スキルシート用作業フェーズマスタです。
	 */
	@OneToOne
	@JoinColumn(name = "phase_id", referencedColumnName = "phase_id")
	public MSkillSheetPhase mSkillSheetPhase;

}
