package services.personnelAffair.license.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.personnelAffair.license.dto.MPayLicenceHistoryDto;
import services.personnelAffair.license.entity.MPayLicenceHistory;

/**
 * 社内資格取得履歴Dxoです。
 *
 * @author nobuhiro-s
 *
 */
public interface MPayLicenceHistoryDxo {

	/**
	 * 社内資格取得履歴エンティティクラスから社内資格取得履歴Dtoへ変換.
	 *
	 * @param src 社内資格取得履歴エンティティクラス
	 * @return 社内資格取得履歴Dto
	 */
	@ConversionRule("periodName : MPeriod.periodName" +
					", fullName : mStaff.staffName.fullName")
	public List<MPayLicenceHistoryDto> convert(List<MPayLicenceHistory> src); 
	
	/**
	 * 社内資格取得履歴Dtoから社内資格取得履歴エンティティクラスへ変換.
	 *
	 * @param src 社内資格取得履歴Dto
	 * @return 社内資格取得履歴エンティティクラス
	 */
	public List<MPayLicenceHistory> convertCreate(List<MPayLicenceHistoryDto> src);
	
	/**
	 * 社内資格取得履歴Dtoから社内資格取得履歴エンティティクラスへ変換.
	 *
	 * @param src 社内資格取得履歴Dto
	 * @return 社内資格取得履歴エンティティクラス
	 */
	public MPayLicenceHistory convertCreate(MPayLicenceHistoryDto src);
}
