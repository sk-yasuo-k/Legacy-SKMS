package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 勤務管理表手続き状態種別情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class MWorkingHoursStatus implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 勤務管理表手続き状態種別IDです。
	 */
	@Id
	public int workingHoursStatusId;

	/**
	 * 勤務管理表手続き状態種別名です。
	 */
	public String workingHoursStatusName;

	/**
	 * 勤務管理表手続き状態表示色です。
	 */
	public Integer workingHoursStatusColor;
	
}