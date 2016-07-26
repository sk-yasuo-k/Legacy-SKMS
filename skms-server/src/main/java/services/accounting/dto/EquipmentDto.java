package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;



/**
 * 設備情報です.
 *
 * @author yasuo-k
 *
 */
public class EquipmentDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 設備IDです.
	 */
	public int equipmentId;

	/**
	 * 管理番号です.
	 */
	public String managementNo;

	/**
	 * 設備種別IDです.
	 */
	public int equipmentKindId;

	/**
	 * メーカです.
	 */
	public String maker;

	/**
	 * 設備名です.
	 */
	public String equipmentName;

	/**
	 * 型番です.
	 */
	public String equipmentNo;

	/**
	 * 製造番号です.
	 */
	public String equipmentSerialNo;

	/**
	 * PC使用目的です.
	 */
	public String pcUse;

	/**
	 * 管理社員IDです.
	 */
	public Integer managementStaffId;

	/**
	 * 管理プロジェクトIDです.
	 */
	public Integer managementProjectId;

	/**
	 * 購入日付です.
	 */
	public Date purchaseDate;

	/**
	 * 購入店です.
	 */
	public String purchaseShop;

	/**
	 * 保証期限です.
	 */
	public Date guaranteedDate;

	/**
	 * PC種別IDです.
	 */
	public Integer pcKindId;

	/**
	 * PC種別名です.
	 */
	public String pcKindName;

	/**
	 * モニタ使用です.
	 */
	public String monitorUse;


	/**
	 * タイトルです.
	 */
	public String title;

	/**
	 * 著者名です.
	 */
	public String author;

	/**
	 * 出版年です.
	 */
	public Integer publicationYear;

	/**
	 * 出版社です.
	 */
	public String publisher;

	/**
	 * ジャンルIDです.
	 */
	public Integer janreId;

	/**
	 * ライセンスです.
	 */
	public String license;

	/**
	 * 動作OSです.
	 */
	public String operationOs;


	/**
	 * 設置場所 / 所蔵場所です.
	 */
	public String location;

	/**
	 * 備考です.
	 */
	public String note;

	/**
	 * 諸経費IDです.
	 */
	public Integer overheadId;

	/**
	 * 諸経費明細連番です.
	 */
	public Integer overheadNo;

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
	 * 削除フラグです.
	 */
	public boolean isDelete = false;


	/**
	 * 設備情報 削除確認.
	 */
	public boolean isDelete() {
		if (this.isDelete && this.equipmentId > 0)			return true;
		return false;
	}

	/**
	 * 設備情報 更新確認.
	 */
	public boolean isUpdate() {
		if (!this.isDelete && this.equipmentId > 0)			return true;
		return false;
	}

	/**
	 * 設備情報 新規登録確認.
	 */
	public boolean isNew() {
		if (!this.isDelete && !(this.equipmentId > 0))		return true;
		return false;
	}

}