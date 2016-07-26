package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 社員部署情報です。
 * 
 * @author yoshinori-t
 * 
 */
@Entity
public class MDepartment implements Serializable {
	
	static final long serialVersionUID = 1L;

	/**
	 * 部署IDです。
	 */
	@Id
	@GeneratedValue
	public int departmentId;

	/**
	 * 部署名です。
	 */
	public String departmentName;

	/**
	 * 表示順です。
	 */
	public int sortOrder;

}
