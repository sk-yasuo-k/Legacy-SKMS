package services.lunch.dxo;


import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.lunch.dto.MShopAdminDto;
import services.lunch.entity.MShopAdmin;

public interface MShopAdminDxo {

	public MShopAdmin convert(MShopAdminDto src);
	
	@ConversionRule("'fullName' : vCurrentStaffName.staffName" )
	public MShopAdminDto convert(MShopAdmin src);
	
	public List<MShopAdmin> convertList(List<MShopAdminDto> src);
	
	public List<MShopAdminDto> convertDtoList(List<MShopAdmin> src);
}
