package services.personnelAffair.skill.entity;

import java.io.Serializable;
import java.util.Date;
import java.sql.Timestamp;
import java.util.List;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.entity.MStaff;

/**
 * 社員スキルシート情報エンティティクラスです。
 *
 * @author yoshinori-t
 *
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class StaffSkillSheet implements Serializable {

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
	 * プロジェクトIDです。
	 */
	@Column(precision = 10, nullable = true, unique = false)
	public Integer projectId;
	
	/**
	 * プロジェクトコードです。
	 */
	@Column(length = 12, nullable = true, unique = false)
	public String projectCode;
	
	/**
	 * プロジェクト名です。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String projectName;
	
	/**
	 * 件名です。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String title;
	
	/**
	 * 区分IDです。
	 */
	@Column(precision = 10, nullable = true, unique = false)
	public Integer kindId;
	
	/**
	 * 期間開始日です。
	 */
	@Column(nullable = true, unique = false)
	@Temporal(TemporalType.TIMESTAMP)
	public Date joinDate;
	
	/**
	 * 期間終了日です。
	 */
	@Column(nullable = true, unique = false)
	@Temporal(TemporalType.TIMESTAMP)
	public Date retireDate;
	
	/**
	 * ハードウェアです。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String hardware;
	
	/**
	 * OSです。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String os;
	
	/**
	 * 言語です。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String language;
	
	/**
	 * キーワードです。
	 */
	@Column(length = 128, nullable = true, unique = false)
	public String keyword;
	
	/**
	 * 担当した内容です。
	 */
	@Column(columnDefinition ="text", nullable = true, unique = false)
	public String content;
	
	/**
	 * 登録日時です。
	 */
	@Column(nullable = true, unique = false)
	public Timestamp registrationTime;
	
	/**
	 * 登録者IDです。
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
	 * スキルシート用区分マスタです。
	 */
	@ManyToOne
	@JoinColumn(name = "kind_id", referencedColumnName = "kind_id")
	public MSkillSheetKind mSkillSheetKind;
	
	/**
	 * 社員スキルシート作業フェーズ
	 */
	@OneToMany(mappedBy = "staffSkillSheet")
	public List<StaffSkillSheetPhase> staffSkillSheetPhaseList;
	
	/**
	 * 社員スキルシート参加形態です。
	 */
	@OneToMany(mappedBy = "staffSkillSheet")
	public List<StaffSkillSheetPosition> staffSkillSheetPositionList;

}
