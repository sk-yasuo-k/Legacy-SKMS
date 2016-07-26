package services.generalAffair.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;

import services.generalAffair.dto.LunchMenuDto;
import services.generalAffair.dto.LunchOptionChoicesDto;
import services.generalAffair.dto.LunchOptionDto;
import services.generalAffair.dto.LunchOrderDto;
import services.generalAffair.dto.LunchOrderMonthDto;
import services.generalAffair.dto.LunchOrderWeekDto;
import services.generalAffair.dto.LunchShopDto;
import services.generalAffair.dxo.LunchMenuDxo;
import services.generalAffair.dxo.LunchOptionChoicesDxo;
import services.generalAffair.dxo.LunchOptionDxo;
import services.generalAffair.dxo.LunchShopDxo;
import services.generalAffair.entity.MLunchMenu;
import services.generalAffair.entity.MLunchMenuOption;
import services.generalAffair.entity.MLunchShop;

/**
 * 弁当を扱うサービスです。
 *
 * @author yasuo-k
 *
 */
public class OldLunchService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * ランチショップ情報変換Dxoです。
	 */
	public LunchShopDxo lunchShopDxo;

	/**
	 * ランチメニュー情報変換Dxoです。
	 */
	public LunchMenuDxo lunchMenuDxo;

	/**
	 * ランチオプション情報変換Dxoです。
	 */
	public LunchOptionDxo lunchOptionDxo;

	/**
	 * ランチオプション選択肢情報変換Dxoです。
	 */
	public LunchOptionChoicesDxo lunchOptionChoicesDxo;

	
	public LunchOrderMonthDto getMonthlyOrder(Date dt) {
		
		Calendar calender = Calendar.getInstance();
		calender.setTime(dt);
		
		int nWeek = calender.getActualMaximum(Calendar.WEEK_OF_MONTH);
		calender.add(Calendar.DAY_OF_MONTH, - calender.get(Calendar.DAY_OF_WEEK) + 1);

		LunchOrderMonthDto lm = new LunchOrderMonthDto();
		lm.lunchOrderWeeks = new ArrayList<LunchOrderWeekDto>();
		
		for (int i = 0; i < nWeek; i++) {
			LunchOrderWeekDto lw = new LunchOrderWeekDto();
			lw.lunchOrders = new ArrayList<LunchOrderDto>();
		
			for (int j = 0; j < 7; j++) {
				LunchOrderDto lo = new LunchOrderDto();
				lo.orderDate = calender.getTime();
				lo.staffId = 1;
				lo.staffName = "大野";
				lw.lunchOrders.add(lo);
				calender.add(Calendar.DAY_OF_MONTH, 1);
			}
			lm.lunchOrderWeeks.add(lw);
		}
		return lm;
	}

	public List<LunchShopDto> getLunchShop() {
		List<MLunchShop> lunchMenuList =
			jdbcManager.from(MLunchShop.class)
				.leftOuterJoin("lunchMenus")
				.leftOuterJoin("lunchMenus.menuOptions")
				.leftOuterJoin("lunchMenus.menuOptions.option")
				.leftOuterJoin("lunchMenus.menuOptions.option.optionChoices")
				.orderBy("sortOrder, lunchMenus.sortOrder, lunchMenus.menuOptions.sortOrder, lunchMenus.menuOptions.option.optionChoices.sortOrder")
				.getResultList();
		
		List<LunchShopDto> lsDtoList = new ArrayList<LunchShopDto>();
		
		for (MLunchShop ls : lunchMenuList) {
			LunchShopDto lsDto = new LunchShopDto();
			lsDto.menus = new ArrayList<LunchMenuDto>();
			lunchShopDxo.convert(ls, lsDto);
			for (MLunchMenu lm : ls.lunchMenus) {
				LunchMenuDto lmDto = new LunchMenuDto();
				lmDto.options = new ArrayList<LunchOptionDto>();
				lunchMenuDxo.convert(lm, lmDto);
				for (MLunchMenuOption lo : lm.menuOptions) {
					LunchOptionDto loDto = new LunchOptionDto();
					loDto.optionChoices = new ArrayList<LunchOptionChoicesDto>();
					lunchOptionDxo.convert(lo.option, loDto);
//					for (LunchOptionChoices lc : lo.option.optionChoices) {
//						LunchOptionChoicesDto lcDto = new LunchOptionChoicesDto();
//						lunchOptionChoicesDxo.convert(lc, lcDto);
//						loDto.optionChoices.add(lcDto);
//					}
					lmDto.options.add(loDto);
				}
				lsDto.menus.add(lmDto);
			}
			lsDtoList.add(lsDto);
		}
		return lsDtoList;
	}
}