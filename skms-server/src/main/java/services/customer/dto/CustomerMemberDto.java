package services.customer.dto;

import java.io.Serializable;
import java.util.Date;


/**
 * 顧客担当者情報です。
 *
 * @author yasuo-k
 *
 */
public class CustomerMemberDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 顧客IDです。
	 */
	public int customerId;

	/**
	 * 顧客担当IDです。
	 */
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
	  * 登録バージョンです。
	  */
	public int registrationVer;

	 /**
	  * 取引開始日です。
	  */
	public Date startDate;

	/**
	  * 取引終了日です。
	  */
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
	 * 削除フラグです.
	 */
	public boolean isDelete = false;


	/**
	 * 氏名です。（姓＋名）
	 */
	public String fullName;

	/**
	 * 氏名です。（姓＋名 かな）
	 */
	public String fullNameKana;


	/**
	 * 氏名を設定する。
	 */
	public void setFullName()
	{
		// 氏名を設定する.
		String lastname  = this.lastName;
		String firstname = this.firstName;
		this.fullName  =  lastname != null ? lastname : "";
		this.fullName  += (lastname != null && firstname != null) ? " " : "";
		this.fullName  += firstname != null ? firstname : "";

		// 氏名（かな）を設定する.
		lastname  = this.lastNameKana;
		firstname = this.firstNameKana;
		this.fullNameKana  =  lastname != null ? lastname : "";
		this.fullNameKana  += (lastname != null && firstname != null) ? " " : "";
		this.fullNameKana  += firstname != null ? firstname : "";
	}

	/**
	 * 更新確認。
	 */
	public boolean isUpdate() {
		if (!this.isDelete && this.customerId > 0 && this.customerMemberId > 0)		return true;
		return false;
	}

	/**
	 * 新規登録確認。
	 */
	public boolean isNew() {
		if (!this.isDelete && !(this.customerId > 0 && this.customerMemberId > 0))	return true;
		return false;
	}

	/**
	 * 削除確認。
	 */
	public boolean isDelete() {
		if (this.isDelete && this.customerId > 0 && this.customerMemberId > 0)	return true;
		return false;
	}
}