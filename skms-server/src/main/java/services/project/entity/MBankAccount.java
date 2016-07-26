package services.project.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;


/**
 * 銀行口座マスタ情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MBankAccount implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 振込口座IDです。
	 */
	@Id
	public int accountId;

	/**
	 * 銀行名です。
	 */
	public String bankName;

	/**
	 * 金融機関コードです。
	 */
	public String bankCode;

	/**
	 * 支店名です。
	 */
	public String branchName;

	/**
	 * 支店コードです。
	 */
	public String branchCode;

	/**
	 * 口座種類です。
	 */
	public String accountType;

	/**
	 * 口座番号です。
	 */
	public String accountNo;

	/**
	 * 口座名です。
	 */
	public String accountName;
}