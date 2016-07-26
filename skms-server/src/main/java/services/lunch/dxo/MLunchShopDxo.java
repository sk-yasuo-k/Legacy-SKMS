package services.lunch.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.lunch.dto.MLunchShopDto;
import services.lunch.entity.MLunchShop;

public interface MLunchShopDxo {

	public MLunchShop convert(MLunchShopDto src);
	
	public MLunchShopDto convert(MLunchShop src);
	
	public List<MLunchShop> convertList(List<MLunchShopDto> src);
	
	@ConversionRule("prefectureName : mPrefecture.name")
	public List<MLunchShopDto> convertDtoList(List<MLunchShop> src);
}
