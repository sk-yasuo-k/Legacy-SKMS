package services.accounting.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 諸経費手続き動作種別情報です.
 *
 * @author yasuo-k
 *
 */
@Entity
public class MOverheadAction implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 諸経費手続き動作種別IDです.
	 */
	@Id
	public int overheadActionId;

	/**
	 * 諸経費手続き動作種別名です.
	 */
	public String overheadActionName;

}
