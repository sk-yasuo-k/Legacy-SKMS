package services.accounting.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 支払種別情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MPayment implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 支払種別IDです。
	 */
	@Id
	public int paymentId;

	/**
	 * 支払種別名です。
	 */
	public String paymentName;

	/**
	 * 備考です。
	 */
	public String note;
}
