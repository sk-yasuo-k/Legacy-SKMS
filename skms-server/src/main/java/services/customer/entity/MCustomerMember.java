package services.customer.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;


/**
 * 顧客担当者情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MCustomerMember implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * Join プロジェクト情報です。
	 */
    @ManyToOne
	@JoinColumn(name="customer_id")
    public MCustomer customer;

	/**
	 * 顧客IDです。
	 */
	@Id
	public int customerId;

	/**
	 * 顧客担当IDです。
	 */
	@Id
	public int customerMemberId;

	/**
	  * 姓（漢字）です。
	  */
	public String lastName;

	/**
	  * 名（漢字）です。
	  */
	public String firstName;

	/**
	  * 姓（かな）です。
	  */
	public String lastNameKana;

	/**
	  * 名（かな）です。
	  */
	public String firstNameKana;

	/**
	  * 部署です。
	  */
	public String department;

	/**
	  * 役職です。
	  */
	public String position;

	/**
	  * Emailです。
	  */
	public String email;

	/**
	  * 電話です。
	  */
	public String telephone;

	/**
	  * 携帯電話です。
	  */
	public String telephone2;

	/**
	  * Faxです。
	  */
	public String fax;

	/**
	  * 備考です。
	  */
	public String note;

	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(insertable=false, updatable=false)
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	public int registrantId;

	 /**
	  * 登録バージョンです。
	  */
	@Version
	public int registrationVer;

	 /**
	  * 取引開始日です。
	  */
	@Temporal(TemporalType.DATE)
	public Date startDate;

	/**
	  * 取引終了日です。
	  */
	@Temporal(TemporalType.DATE)
	public Date finishDate;

	/**
	  * 住所です。
	  */
	public String address;

	/**
	  * 郵便番号です。
	  */
	public String addressNo;


	/**
	 * 新規顧客担当設定.
	 */
	public void setNewMember(int cusId, int newId, int regId)
	{
		this.customerId       = cusId;
		this.customerMemberId = newId;
		this.registrantId     = regId;
	}

	/**
	 * 顧客担当更新設定.
	 */
	public void setUpdMember(int regId)
	{
		this.registrantId     = regId;
	}

}