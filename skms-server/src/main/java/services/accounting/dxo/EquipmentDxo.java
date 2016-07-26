package services.accounting.dxo;

import services.accounting.dto.EquipmentDto;
import services.accounting.entity.Equipment;
import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadDetail;
import services.generalAffair.entity.MStaff;


/**
 * 設備情報変換Dxoです.
 *
 * @author yasuo-k
 *
 */
public interface EquipmentDxo {

	/**
	 * 設備情報エンティティから設備情報Dtoへ変換.<br>
	 *
	 * @param src   設備情報エンティティo.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報Dto.
	 */
	public EquipmentDto convert(Equipment src);

	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertCreate(EquipmentDto src, MStaff staff, OverheadDetail overhead, Overhead overheadParent);

	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertUpdate(EquipmentDto src, MStaff staff, OverheadDetail overhead, Overhead overheadParent);

	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertDelete(EquipmentDto src, MStaff staff);

	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertApprovalCancel(EquipmentDto src, MStaff staff, OverheadDetail overhead);
}
