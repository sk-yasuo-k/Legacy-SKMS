package services.lunch.dxo;

import java.util.List;

import services.lunch.dto.MenuCategoryDto;
import services.lunch.entity.MenuCategory;

public interface MenuCategoryDxo {

	public MenuCategory convert(MenuCategoryDto src);
	
	public MenuCategoryDto convert(MenuCategory src);
	
	public List<MenuCategory> convertList(List<MenuCategoryDto> src);
	
	public List<MenuCategoryDto> convertDtoList(List<MenuCategory> src);
}
