package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * オフィス情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MOffice implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * オフィスIDです。
	 */
	@Id
	public int officeId;

	/**
	 * オフィス名です。
	 */
	public String officeName;
}
