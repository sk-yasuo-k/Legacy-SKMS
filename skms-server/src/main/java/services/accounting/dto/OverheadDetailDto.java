package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;


/**
 * 交通費申請明細情報です.
 *
 * @author yasuo-k
 *
 */
public class OverheadDetailDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 諸経費申請IDです.
	 */
	public int overheadId;

	/**
	 * 諸経費申請明細連番です.
	 */
	public int overheadNo;

    /**
	 * 諸経費発生日です.
	 */
	public Date overheadDate;

	/**
	 * 諸経費区分IDです.
	 */
	public Integer overheadTypeId;

	/**
	 * 諸経費区分です.
	 */
	public String overheadTypeName;

	/**
	 * 内訳です.
	 */
	public String content;

	/**
	 * 内訳要素その1です.
	 */
	public String contentA;

	/**
	 * 内訳要素その2です.
	 */
	public String contentB;

	/**
	 * 内訳要素その3です.
	 */
	public String contentC;

	/**
	 * 勘定科目IDです.
	 */
	public int accountItemId;

	/**
	 * 勘定科目名です.
	 */
	public String accountItemName;

	/**
	 * 支払IDです.
	 */
	public int paymentId;

	/**
	 * 支払名です.
	 */
	public String paymentName;

	/**
	 * 支払情報です.
	 */
	public String paymentInfo;

	/**
	 * 金額です.
	 */
	public String expense;

	/**
	 * 領収書番号です.
	 */
	public String receiptNo;

	/**
	 * 備考です.
	 */
	public String note;

	/**
	 * 登録日時です.
	 */
	public Date registrationTime;

	/**
	 * 登録者IDです.
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	public int registrationVer;


	/**
	 * 設備情報です.
	 */
	public EquipmentDto equipment;

	/**
	 * 削除フラグです.
	 */
	public boolean isDelete = false;




	/**
	 * 削除設定.
	 */
	public void setDelete() {
		this.isDelete = true;
	}

	/**
	 * 削除確認.
	 */
	public boolean isDelete() {
		if (this.isDelete && isConstraint()) 	return true;
		return false;
	}

	/**
	 * 更新確認.
	 */
	public boolean isUpdate() {
		if (!isDelete() && isConstraint()) 		return true;
		return false;
	}

	/**
	 * 新規確認.
	 */
	public boolean isNew() {
		if (!this.isDelete && !isConstraint()) 	return true;
		return false;
	}

	/**
	 * Constraint確認.
	 */
	private boolean isConstraint() {
		if (this.overheadId > 0 && this.overheadNo > 0)	return true;
		return false;
	}

}