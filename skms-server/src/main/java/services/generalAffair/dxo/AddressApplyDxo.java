package services.generalAffair.dxo;

import services.generalAffair.dto.AddressApplyDto;
import services.generalAffair.address.entity.MStaffAddress;

/**
 * 社員住所情報Dxoです。

 *
 * @author nobuhiro-s
 *
 */
public interface AddressApplyDxo {
	
	/**
	 * 社員住所情報Dtoから社員住所マスタエンティティへ変換.
	 *
	 * @param src 社員住所マスタエンティティ
	 * @return 社員住所情報Dto
	 */
	public MStaffAddress convertCreate(AddressApplyDto addressApplyList);
}

