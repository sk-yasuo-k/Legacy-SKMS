package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 勤務管理表手続き動作種別情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MWorkingHoursAction implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 勤務管理表手続き動作種別IDです。
	 */
	@Id
	public int workingHoursActionId;

	/**
	 * 勤務管理表手続き動作種別名です。
	 */
	public String workingHoursActionName;

}