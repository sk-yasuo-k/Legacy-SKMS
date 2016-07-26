package services.personnelAffair.skill.entity;

import java.io.Serializable;
import java.util.List;
import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * スキルシート用区分マスタエンティティクラスです。
 *
 * @author yoshinori-t
 *
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.38", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/07/21 17:17:02")
public class MSkillSheetKind implements Serializable {

	private static final long serialVersionUID = 1L;
	
	/**
	 * 区分IDです。
	 */
	@Id
	@Column(precision = 10, nullable = false, unique = true)
	public Integer kindId;
	
	/**
	 * 区分コードです。
	 */
	@Column(length = 8, nullable = true, unique = false)
	public String kindCode;
	
	/**
	 * 区分名です。
	 */
	@Column(length = 32, nullable = true, unique = false)
	public String kindName;
	
	/**
	 * 社員スキルシートです。
	 */
	@OneToMany(mappedBy = "mSkillSheetKind")
	public List<StaffSkillSheet> staffSkillSheetList;

}