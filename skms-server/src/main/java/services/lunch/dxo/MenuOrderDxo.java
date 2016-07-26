package services.lunch.dxo;

import java.util.List;


import services.lunch.dto.MenuOrderDto;
import services.lunch.entity.MenuOrder;

public interface MenuOrderDxo {

	public MenuOrder convert(MenuOrderDto src);
	
	public MenuOrderDto convert(MenuOrder src);
	
	public List<MenuOrder> convertList(List<MenuOrderDto> src);
	
	public List<MenuOrderDto> convertDtoList(List<MenuOrder> src);
}
