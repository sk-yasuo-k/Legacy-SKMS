package services.accounting.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * クレジットカード情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MCreditCard implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * クレジットカード番号です。
	 */
	@Id
	public String creditCardNo;;

	/**
	 * クレジットカード名です。
	 */
	public String creditCardName;

	/**
	 * 有効期限です。
	 */
	@Temporal(TemporalType.DATE)
	public Date goodThru;

	/**
	 * 所有者社員IDです。
	 */
	public int staffId;

}
