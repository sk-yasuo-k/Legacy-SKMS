package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 諸経費申請区分情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MOverheadType implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 諸経費申請区分IDです。
	 */
	@Id
	public int overheadTypeId;

	/**
	 * 諸経費申請区分名です。
	 */
	public String overheadTypeName;

}
