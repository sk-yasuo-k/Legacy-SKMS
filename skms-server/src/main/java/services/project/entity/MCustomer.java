package services.project.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 顧客情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MCustomer implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 顧客IDです。
	 */
	@Id
	public int customerId;

	/**
	 * 顧客種別です。
	 */
	public String customerType;

	/**
	 * 顧客番号です。
	 */
	public String customerNo;

	/**
	 * 顧客名です。
	 */
	public String customerName;

	/**
	 * 顧客略称です。
	 */
	public String customerAlias;

	/**
	 * 表示順序です。
	 */
	public int sortOrder;

	/**
	 * 削除フラグです。
	 */
	public boolean deleteFlg;

}