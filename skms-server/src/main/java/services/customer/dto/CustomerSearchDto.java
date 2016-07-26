package services.customer.dto;

import java.io.Serializable;
import java.util.List;

/**
 * 顧客検索情報です.
 *
 * @author yasuo-k
 *
 */
public class CustomerSearchDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 顧客区分リストです。
	 */
    public List<String> customerTypeList;

	/**
	 * 顧客区分リストです。
	 */
    public String customerType;

	/**
	 * 顧客番号です。
	 */
	public String customerNo;

	/**
	 * 顧客名称です。
	 */
	public String customerName;

	/**
	 * 顧客略称です。
	 */
	public String customerAlias;

	/**
	 * 顧客コードです。（顧客種別＋顧客番号）
	 */
	public String customerCode;
}