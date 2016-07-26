package services.customer.dxo;

import services.customer.dto.CustomerMemberDto;
import services.customer.entity.MCustomerMember;

/**
 * 顧客担当者情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface CustomerMemberDxo {

	/**
	 * 顧客担当者エンティティから顧客担当者Dtoへ変換.
	 *
	 * @param  src 顧客担当者エンティティ.
	 * @return 顧客担当者Dto.
	 */
	public CustomerMemberDto convert(MCustomerMember src);

	/**
	 * 顧客担当者Dtoから顧客担当者エンティティへ変換.
	 *
	 * @param  src 顧客担当者Dto.
	 * @return 顧客担当者エンティティ.
	 */
	public MCustomerMember convert(CustomerMemberDto src);
}
