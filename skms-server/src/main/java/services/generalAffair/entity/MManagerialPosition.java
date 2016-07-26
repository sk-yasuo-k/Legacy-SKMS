package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 経営役職情報です。
 *
 * @author yoshinori-t
 *
 */
@Entity
public class MManagerialPosition implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 経営役職IDです。
	 */
	@Id
	public int managerialPositionId;

	/**
	 * 経営種別略称です。
	 */
	public String managerialPositionAlias;

	/**
	 * 経営種別名称です。
	 */
	public String managerialPositionName;

}