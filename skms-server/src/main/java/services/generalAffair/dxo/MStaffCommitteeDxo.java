package services.generalAffair.dxo;

import java.util.List;
import org.seasar.extension.dxo.annotation.ConversionRule;
import services.generalAffair.dto.MStaffCommitteeDto;
import services.generalAffair.entity.MStaffCommittee;

/**
 * 委員会所属Dxoです。

 *
 * @author nobuhiro-s
 *
 */
public interface MStaffCommitteeDxo {

	/**
	 * 委員会所属マスタエンティティから委員会所属Dtoへ変換.
	 *
	 * @param committee 委員会所属マスタエンティティ
	 * @return エンティティ委員会所属
	 */
	@ConversionRule("committeeName : mCommittee.committeeName" +
					", committeePositionName : mCommitteePosition.committeePositionName" +
					", fullName : mStaff.staffName.fullName")
	public List<MStaffCommitteeDto> convert(List<MStaffCommittee> committee); 
	
	/**
	 * 委員会所属Dtoから委員会所属マスタエンティティへ変換.
	 *
	 * @param committee 委員会所属マスタエンティティ
	 * @return エンティティ委員会所属
	 */
	public MStaffCommittee convertCreate(MStaffCommitteeDto committeeList);	
}

