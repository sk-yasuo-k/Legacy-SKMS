package services.generalAffair.dxo;

import java.util.List;
import org.seasar.extension.dxo.annotation.ConversionRule;
import services.generalAffair.dto.MStaffCommitteeDto;
import services.generalAffair.entity.MStaff;

/**
 * 社員一覧(委員会未登録)Dxoです
 * 社員一覧マスタエンティティから社員一覧(委員会未登録)Dtoへ変換.
 * @author nobuhiro-s
 *
 */
public interface MStaffCommitteeLabelDxo {
	@ConversionRule("fullName : staffName.fullName")
	public List<MStaffCommitteeDto> convert(List<MStaff> committee); 
}

