package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * プロジェクト役職情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MProjectPosition implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクト役職種別IDです。
	 */
	@Id
	@GeneratedValue
	public int projectPositionId;

	/**
	 * プロジェクト役職種別略称です。
	 */
	public String projectPositionAlias;

	/**
	 * プロジェクト役職種別名称です。
	 */
	public String projectPositionName;

}