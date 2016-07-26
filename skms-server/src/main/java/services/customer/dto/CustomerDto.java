package services.customer.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;


/**
 * 顧客情報です。
 *
 * @author yasuo-k
 *
 */
public class CustomerDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 顧客IDです。
	 */
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
	  * 登録バージョンです。
	  */
	public int registrationVer;

	 /**
	  * Webページです。
	  */
	public String customerHtml;

	 /**
	  * 取引開始日です。
	  */
	public Date customerStartDate;

	/**
	  * 取引終了日です。
	  */
	public Date customerFinishDate;

	 /**
	  * 代表者 姓（漢字）です。
	  */
	public String representativeLastName;

	 /**
	  * 代表者 名（漢字）です。
	  */
	public String representativeFirstName;

	 /**
	  * 代表者 姓（かな）です。
	  */
	public String representativeLastNameKana;

	 /**
	  * 代表者 名（かな）です。
	  */
	public String representativeFirstNameKana;

	/**
	 * 顧客担当者リストです。
	 */
	public List<CustomerMemberDto> customerMembers;


	/**
	 * 顧客コードです。（顧客種別＋顧客番号）
	 */
	public String customerCode;

	 /**
	  * 顧客代表者です。(姓＋名)
	  */
	public String customerRepresentative;

	 /**
	  * 顧客代表者です。(姓＋名 かな)
	  */
	public String customerRepresentativeKana;


	/**
	 * 顧客コードを設定する。
	 */
	public void setCustomerCode()
	{
		this.customerCode = this.customerType + this.customerNo;
	}

	/**
	 * 顧客代表者を設定する。
	 */
	public void setRepresentative()
	{
		// 代表者を設定する.
		String lastname  = this.representativeLastName;
		String firstname = this.representativeFirstName;
		this.customerRepresentative  =  lastname != null ? lastname : "";
		this.customerRepresentative  += (lastname != null && firstname != null) ? " " : "";
		this.customerRepresentative  += firstname != null ? firstname : "";

		// 代表者（かな）を設定する.
		lastname  = this.representativeLastNameKana;
		firstname = this.representativeFirstNameKana;
		this.customerRepresentativeKana  =  lastname != null ? lastname : "";
		this.customerRepresentativeKana  += (lastname != null && firstname != null) ? " " : "";
		this.customerRepresentativeKana  += firstname != null ? firstname : "";
	}

	/**
	 * 更新確認。
	 */
	public boolean isUpdate() {
		if (this.customerId > 0)	return true;
		return false;
	}

	/**
	 * 新規登録確認。
	 */
	public boolean isNew() {
		if (!isUpdate())		return true;
		return false;
	}

}