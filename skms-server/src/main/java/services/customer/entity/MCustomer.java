package services.customer.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;


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
	 * 支払サイトです。
	 */
	public String billPayable;

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
	  * Webページです。
	  */
	public String customerHtml;

	 /**
	  * 取引開始日です。
	  */
	@Temporal(TemporalType.DATE)
	public Date customerStartDate;

	/**
	  * 取引終了日です。
	  */
	@Temporal(TemporalType.DATE)
	public Date customerFinishDate;

	 /**
	  * 代表者 姓（漢字）です。
	  */
	public String RepresentativeLastName;

	 /**
	  * 代表者 名（漢字）です。
	  */
	public String RepresentativeFirstName;

	 /**
	  * 代表者 姓（かな）です。
	  */
	public String RepresentativeLastNameKana;

	 /**
	  * 代表者 名（かな）です。
	  */
	public String RepresentativeFirstNameKana;

	/**
	 * 削除フラグです。
	 */
	public boolean deleteFlg;


	/**
	 * Join 顧客担当者リストです。
	 */
	@OneToMany(mappedBy = "customer")
	public List<MCustomerMember> customerMembers;


	/**
	 * 新規顧客設定.
	 */
	public void setNewCustomer(int newId, int regId)
	{
		this.customerId   = newId;
		this.registrantId = regId;
		this.sortOrder    = newId;
	}

	/**
	 * 顧客更新設定.
	 */
	public void setUpdateCustomer(int regId)
	{
		this.registrantId = regId;
	}

	/**
	 * 顧客削除設定.
	 */
	public void setDeleteCustomer(int regId)
	{
		this.registrantId = regId;
		this.deleteFlg    = true;
	}

	/**
	 * 表示順変更.
	 */
	public void updateSortOrder(int sortIndex)
	{
		this.sortOrder = sortIndex;
	}
}