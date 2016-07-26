package services.accounting.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 勘定科目情報です.
 *
 * @author yasuo-k
 *
 */
@Entity
public class MAccountItem implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 勘定科目IDです.
	 */
	@Id
	public int accountItemId;

	/**
	 * 勘定科目名です.
	 */
	public String accountItemName;

}
