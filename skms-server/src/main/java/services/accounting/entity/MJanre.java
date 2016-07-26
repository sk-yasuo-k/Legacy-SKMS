package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * ジャンル情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MJanre implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * ジャンルIDです。
	 */
	@Id
	public int janreId;

	/**
	 * ジャンル名です。
	 */
	public String janreName;

	/**
	 * ソート順です。
	 */
	public Integer sortOrder;
}
