package services.accounting.dxo.impl;

import org.seasar.extension.jdbc.JdbcManager;

import services.accounting.dto.EquipmentDto;
import services.accounting.dxo.EquipmentDxo;
import services.accounting.entity.Equipment;
import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadDetail;
import services.generalAffair.entity.MStaff;


/**
 * 設備情報変換Dxo実装クラスです.
 *
 * @author yasuo-k
 *
 */
public class EquipmentDxoImpl implements EquipmentDxo {

	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;


	/**
	 * 設備情報エンティティから設備情報Dtoへ変換.<br>
	 *
	 * @param src   設備情報エンティティo.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報Dto.
	 */
	public EquipmentDto convert(Equipment src)
	{
		if (src == null)	return null;
		EquipmentDto dst = new EquipmentDto();
		dst.equipmentId 		= src.equipmentId;
		dst.managementNo 		= src.managementNo;
		dst.equipmentKindId 	= src.equipmentKindId;
		dst.maker 				= src.maker;
		dst.equipmentName 		= src.equipmentName;
		dst.equipmentNo 		= src.equipmentNo;
		dst.equipmentSerialNo 	= src.equipmentSerialNo;
		dst.pcUse 				= src.pcUse;
		dst.managementStaffId	= src.managementStaffId;
		dst.managementProjectId	= src.managementProjectId;
		dst.guaranteedDate 		= src.guaranteedDate;
		dst.purchaseDate 		= src.purchaseDate;
		dst.purchaseShop 		= src.purchaseShop;
		dst.guaranteedDate 		= src.guaranteedDate;
		dst.pcKindId 			= src.pcKindId;
		dst.monitorUse 			= src.monitorUse;

		dst.title				= src.title;
		dst.author				= src.author;
		dst.publicationYear		= src.publicationYear;
		dst.publisher			= src.publisher;
		dst.janreId				= src.janreId;
		dst.license				= src.license;
		dst.operationOs			= src.operationOs;

		dst.location 			= src.location;
		dst.note 				= src.note;
		dst.overheadId			= src.overheadId;
		dst.overheadNo			= src.overheadNo;
		dst.registrationTime	= src.registrationTime;
		dst.registrantId 		= src.registrantId;
		dst.registrationVer		= src.registrationVer;
		return dst;
	}

	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertCreate(EquipmentDto src, MStaff staff, OverheadDetail overhead, Overhead overheadParent)
	{
		Equipment dst = convert(src, staff, overhead, overheadParent);
		dst.equipmentId = nextval_serialId();
		return dst;
	}

	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertUpdate(EquipmentDto src, MStaff staff, OverheadDetail overhead, Overhead overheadParent)
	{
		Equipment dst = convert(src, staff, overhead, overheadParent);
		dst.equipmentId = src.equipmentId;
		return dst;
	}


	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertDelete(EquipmentDto src, MStaff staff)
	{
		Equipment dst = new Equipment();
		dst.equipmentId = src.equipmentId;
		dst.registrationVer = src.registrationVer;
		return dst;
	}

	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convertApprovalCancel(EquipmentDto src, MStaff staff, OverheadDetail overhead)
	{
		Equipment dst = new Equipment();
		dst.equipmentId = src.equipmentId;
		dst.registrationVer = src.registrationVer;
		// 管理番号を破棄する.
		dst.managementNo = null;
		return dst;
	}


	/**
	 * 設備情報Dtoから設備情報エンティティへ変換.<br>
	 *
	 * @param src   設備情報Dto.
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費明細.
	 * @return 設備情報エンティティ.
	 */
	public Equipment convert(EquipmentDto src, MStaff staff, OverheadDetail overhead, Overhead overheadParent)
	{
		Equipment dst = new Equipment();
		//dst.equipmentId
		dst.managementNo		= src.managementNo;
		dst.equipmentKindId		= src.equipmentKindId;
		dst.maker				= src.maker;
		dst.equipmentName		= src.equipmentName;
		dst.equipmentNo			= src.equipmentNo;
		dst.equipmentSerialNo	= src.equipmentSerialNo;
		dst.pcUse				= src.pcUse;
		dst.managementStaffId	= src.managementStaffId.intValue() == 0 ? null : src.managementStaffId;
		dst.managementProjectId	= overheadParent.projectId;
		dst.guaranteedDate		= src.guaranteedDate;
		dst.purchaseDate		= src.purchaseDate;
		dst.purchaseShop		= src.purchaseShop;
		dst.guaranteedDate		= src.guaranteedDate;
		dst.pcKindId			= src.pcKindId.intValue() == 0 ? null : src.pcKindId;
		dst.monitorUse			= src.monitorUse;

		dst.title				= src.title;
		dst.author				= src.author;
		dst.publicationYear		= src.publicationYear.intValue() == 0 ? null : src.publicationYear;
		dst.publisher			= src.publisher;
		dst.janreId				= src.janreId.intValue() == 0 ? null : src.janreId;
		dst.license				= src.license;
		dst.operationOs			= src.operationOs;

		dst.location			= src.location;
		dst.note				= src.note;
		dst.overheadId			= overhead.overheadId;
		dst.overheadNo			= overhead.overheadNo;
		dst.registrantId		= staff.staffId;
		dst.registrationTime	= src.registrationTime;
		dst.registrationVer		= src.registrationVer;
		return dst;
	}

	/**
	 * Next設備IDの発行.
	 *
	 * @return int Next設備ID
	 */
	private int nextval_serialId()
	{
		return jdbcManager.selectBySql(Integer.class, "select nextval('equipment_equipment_id_seq')").getSingleResult();
	}


}