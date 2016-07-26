package services.lunch.dxo;

import java.util.List;

import org.seasar.extension.dxo.annotation.ConversionRule;

import services.lunch.dto.ShopMenuDto;
import services.lunch.entity.ShopMenu;

public interface ShopMenuDxo {
	
	public ShopMenu convert(ShopMenuDto src);
	
	public ShopMenuDto convert(ShopMenu src);	
	
	public List<ShopMenu> convertList(List<ShopMenuDto> src);
	
	public List<ShopMenuDto> convertDtoList(List<ShopMenu> src);
	
	@ConversionRule("'mMenu' : menu")
	public List<ShopMenuDto> convertMenuList(List<ShopMenu> src);
}
