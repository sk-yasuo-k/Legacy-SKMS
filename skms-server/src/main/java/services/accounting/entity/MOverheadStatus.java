package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 諸経費手続き状態種別情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MOverheadStatus implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 諸経費手続き状態種別IDです。
	 */
	@Id
	public int overheadStatusId;

	/**
	 * 諸経費手続き状態種別名です。
	 */
	public String overheadStatusName;

	/**
	 * 諸経費手続き状態表示色です。
	 */
	public Integer overheadStatusColor;
}
