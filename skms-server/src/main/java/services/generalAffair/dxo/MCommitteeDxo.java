package services.generalAffair.dxo;

import java.util.List;
import services.generalAffair.dto.MCommitteeDto;
import services.generalAffair.entity.MCommittee;

/**
 * 委員会マスタDxoです。

 *
 * @author nobuhiro-s
 *
 */
public interface MCommitteeDxo {
	
	/**
	 * 委員会マスタエンティティから委員会Dtoへ変換.
	 *
	 * @param src 委員会マスタエンティティ
	 * @return 委員会Dto
	 */
	public List<MCommitteeDto> convert(List<MCommittee> committee); 
	
	/**
	 * 委員会Dtoから委員会マスタエンティティへ変換.
	 *
	 * @param src 委員会Dto
	 * @return 委員会マスタエンティティ
	 */
	public MCommittee convertCreate(MCommitteeDto committeeNoteList);
}

