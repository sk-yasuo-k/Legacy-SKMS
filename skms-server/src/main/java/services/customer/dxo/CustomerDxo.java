package services.customer.dxo;

import services.customer.dto.CustomerDto;
import services.customer.entity.MCustomer;

/**
 * 顧客担当者情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface CustomerDxo {

	/**
	 * 顧客担当者エンティティから顧客担当者Dtoへ変換.
	 *
	 * @param  src 顧客担当者エンティティ.
	 * @return 顧客担当者Dto.
	 */
	public CustomerDto convert(MCustomer src);

	/**
	 * 顧客担当者Dtoから顧客担当者エンティティへ変換.
	 *
	 * @param  src 顧客担当者Dto.
	 * @return 顧客担当者Dto.
	 */
	public MCustomer convert(CustomerDto src);
}
