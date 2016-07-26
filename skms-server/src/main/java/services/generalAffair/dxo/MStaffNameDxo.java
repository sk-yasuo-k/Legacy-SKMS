package services.generalAffair.dxo;

import services.generalAffair.dto.MStaffNameDto;
import services.generalAffair.entity.MStaffName;;

/**
 * 社員名情報Dxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MStaffNameDxo {
	
	/**
	 * 個人情報(名前)Dtoから個人情報(名前)マスタエンティティへ変換.
	 *
	 * @param mStaffList 個人情報マスタエンティティ
	 * @return 
	 */
	public MStaffName convertCreate(MStaffNameDto mStaffNameList);	
}

