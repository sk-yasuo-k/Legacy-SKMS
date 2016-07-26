package services.generalAffair.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 社員部署情報です。
 * 
 * @author yoshinori-t
 * 
 */
@Entity
public class MOccupationalCategory implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 職種IDです。
	 */
	@Id
	public int occupationalCategoryId;
	
	/**
	 * 職種名です。
	 */
	public String occupationalCategoryName;
	
}
