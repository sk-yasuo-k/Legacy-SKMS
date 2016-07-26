package services.lunch.service;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;


import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.parameter.Parameter;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.entity.VCurrentStaffName;
import services.generalAffair.workingConditions.dxo.MStaffDxo;
import services.lunch.dto.*;
import services.lunch.dxo.*;
import services.lunch.entity.*;

public class LunchService {
	
	/** JDBCマネージャ */
	public JdbcManager jdbcManager;
	
	/** optionDxo */
	public OptionDxo optionDxo;
	
	/** mOptionKindDxo */
	public MOptionKindDxo mOptionKindDxo;
	
	/** optionKindDxo */
	public OptionKindDxo optionKindDxo;
	
	/** optionSetDxo */
	public OptionSetDxo optionSetDxo;
	
	/** mOptionSetDxo */
	public MOptionSetDxo mOptionSetDxo;
	
	/** mMenuDxo */
	public MMenuDxo mMenuDxo;
	
	/** shopMenuDxo */
	public ShopMenuDxo shopMenuDxo;
	
	/** mShopAdminDxo */
	public MShopAdminDxo mShopAdminDxo;
	
	/** mStaffDxo */
	public MStaffDxo mStaffDxo;
	
	/** vCurrent */
	public VCurrentStaffNameDxo vCurrentStaffNameDxo;
	
	/** mLunchShopDxo */
	public MLunchShopDxo mLunchShopDxo;	
	
	/** exclusiveOptionDxo */
	public ExclusiveOptionDxo exclusiveOptionDxo;
	
	/** menuCategoryDxo */
	public MenuCategoryDxo menuCategoryDxo;
	
	/** menuOrderDxo */
	public MenuOrderDxo menuOrderDxo;
	
	/** menuOrderOptionDxo */
	public MenuOrderOptionDxo menuOrderOptionDxo;	
	
	/**
	 * オプション一覧取得
	 * @return　オプション一覧
	 */
	public List<OptionDto> getOptionList(){
		
		List<Option> src = jdbcManager
							.from(Option.class)
							.orderBy("id")
							.getResultList();
							
		List<OptionDto> result = optionDxo.convertDtoList(src);
				
		return result;
	}
	
	/**
	 * オプション種類一覧取得
	 * @return オプション種類一覧
	 */
	public List<MOptionKindDto> getMOptionKindList(){
		
		List<MOptionKind> src = jdbcManager
								.from(MOptionKind.class)
								.getResultList();
		List<MOptionKindDto> result = mOptionKindDxo.convertDtoList(src);
		
		return result;
	}
	
	/**
	 * オプション種類取得
	 * @param mOptionKindId オプション種類ID
	 * @return オプション種類で絞られたオプション一覧
	 */
	public List<OptionKindDto> getOptionKindList(Integer mOptionKindId){
		
		List<OptionKind> src = jdbcManager
								.from(OptionKind.class)
								.leftOuterJoin("option")
								.where(new SimpleWhere().eq("mOptionKindId", mOptionKindId))
								.getResultList();
		List<OptionKindDto> result = optionKindDxo.convertDtoList(src);
		
		return result;
		
	}

	/**
	 * 排他オプション種類取得
	 * @param mOptionKindId オプション種類ID
	 * @return 排他オプション種類で絞られたオプション種類一覧
	 */
	public List<ExclusiveOptionDto> getExclusiveOptionKindList(Integer mOptionKindId){
		
		List<ExclusiveOption> src = jdbcManager
								.from(ExclusiveOption.class)
								.leftOuterJoin("exclusiceMOptionKind")
								.where(new SimpleWhere().eq("mOptionKindId", mOptionKindId))
								.getResultList();
		List<ExclusiveOptionDto> result = exclusiveOptionDxo.convertDtoList(src);
		
		return result;
		
	}	
	
	/**
	 * オプションセット一覧取得
	 * @return オプションセット一覧
	 */
	public List<MOptionSetDto> getMOptionSetList(){
		
		List<MOptionSet> src = jdbcManager
									.from(MOptionSet.class)
									.orderBy("id")
									.getResultList();
		
		List<MOptionSetDto> result = mOptionSetDxo.convrtDtoList(src);
		
		return result;
	}
	
	/**
	 * オプションセット取得
	 * @param mOptionSetId オプションセットID
	 * @return オプションセット
	 */
	public List<OptionSetDto> getOptionSetList(Integer mOptionSetId){
		
		List<OptionSet> src = jdbcManager
								.from(OptionSet.class)
								.leftOuterJoin("mOptionSet")
								.where(new SimpleWhere().eq("mOptionSetId", mOptionSetId))
								.getResultList();
		
		List<OptionSetDto> result = optionSetDxo.convertDtoList(src);
		
		return result;
	}

	/**
	 * メニューカテゴリ取得
	 * @return メニューカテゴリ
	 */
	public List<MenuCategoryDto> getMenuCategory(){
		
		List<MenuCategory> src = jdbcManager
							.from(MenuCategory.class)
							.orderBy("id")
							.getResultList();
		
		List<MenuCategoryDto> result = menuCategoryDxo.convertDtoList(src);
		
		return result;
	}
	
	
	/**
	 * メニュー一覧取得
	 * @return メニュー一覧
	 */
	public List<MMenuDto> getMMenuList(){
		
		List<MMenu> src = jdbcManager
							.from(MMenu.class)
							.orderBy("id")
							.getResultList();
		
		List<MMenuDto> result = mMenuDxo.convertDtoList(src);
		
		return result;
	}
	
	
	/**
	 * ショップメニュー一覧取得
	 * @param mMenuId
	 * @return　ショップメニュー一覧
	 */
	public List<ShopMenuDto> getShopMenuList(Integer mMenuId){
		
		List<ShopMenu> src = jdbcManager
								.from(ShopMenu.class)								
								.leftOuterJoin("mMenu")
								.leftOuterJoin("mMenu.mOptionSet")
								.leftOuterJoin("mMenu.mOptionSet.optionSetList")
								.leftOuterJoin("mMenu.mOptionSet.optionSetList.mOptionKind")
								.leftOuterJoin("mMenu.mOptionSet.optionSetList.mOptionKind.optionKindList")
								.leftOuterJoin("mMenu.mOptionSet.optionSetList.mOptionKind.exclusiveOptionList")
								.leftOuterJoin("mMenu.mOptionSet.optionSetList.mOptionKind.optionKindList.option")
								.where(new SimpleWhere().eq("mMenuId", mMenuId))
								.orderBy("mMenuId, mMenu.mOptionSet.optionSetList.mOptionKind.optionKindList.id")
								.getResultList();
		
		List<ShopMenuDto> result = shopMenuDxo.convertDtoList(src);
		
		return result;
	}

	/**
	 * メニュー取得
	 * @param mLunchShopId
	 * @return　ショップメニュー一覧
	 */
	public List<ShopMenuDto> getMenuList(Integer mLunchShopId){
		
		Date nowDate = new Date();
		DateFormat tmpDf = new SimpleDateFormat("yyyy/MM/dd");
		
		List<ShopMenu> src = jdbcManager
								.from(ShopMenu.class)								
								.leftOuterJoin("menu")
								.where("cast('" + tmpDf.format(nowDate) + "' as date) between startDate and finishDate and mLunchShopId = " + mLunchShopId + "")
								.orderBy("mMenuId")
								.getResultList();
		
		List<ShopMenuDto> result = shopMenuDxo.convertMenuList(src);
		
		return result;
	}
	
	
	
	/**
	 * 確定前注文履歴取得
	 * @param staffId
	 * @return　確定前注文履歴一覧
	 */
	public List<MenuOrderDto> getLunchHistoryList(Integer staffId){
		
		 List<MenuOrder> src = jdbcManager 
	 							.from(MenuOrder.class)
	 							.leftOuterJoin("menuOrderOptionList")
	 							.leftOuterJoin("menuOrderOptionList.option")
	 							.leftOuterJoin("shopMenu")
	 							.leftOuterJoin("shopMenu.mMenu")
	 							.where("staffId = " + staffId + " and cancel = " + true + "")
	 							.orderBy("orderDate desc, id desc")
	 							.getResultList();
		 
		 List<MenuOrderDto> result = menuOrderDxo.convertDtoList(src);
		 
		 return result;
	}
	
	/**
	 * 確定後注文履歴取得
	 * @param staffId
	 * @return　確定後注文履歴一覧
	 */
	public List<MenuOrderDto> getLunchHistory(Integer staffId){
		
		 List<MenuOrder> src = jdbcManager 
	 							.from(MenuOrder.class)
	 							.leftOuterJoin("menuOrderOptionList")
	 							.leftOuterJoin("menuOrderOptionList.option")
	 							.leftOuterJoin("shopMenu")
	 							.leftOuterJoin("shopMenu.mMenu")
	 							.where("staffId = " + staffId + " and cancel = " + false + "")
	 							.orderBy("orderDate desc, id desc")
	 							.getResultList();
		 
		 List<MenuOrderDto> result = menuOrderDxo.convertDtoList(src);
		 
		 return result;
	}	
	
	/**
	 * 本日の注文履歴取得
	 * 
	 * @return　本日の注文履歴一覧
	 */
	public List<MenuOrderDto> getLunchAggregateList(int shopId){
		
		Date nowDate = new Date();
		DateFormat tmpDf = new SimpleDateFormat("yyyy/MM/dd");
		
		 List<MenuOrder> src = jdbcManager 
	 							.from(MenuOrder.class)
	 							.leftOuterJoin("menuOrderOptionList")
	 							.leftOuterJoin("menuOrderOptionList.option")
	 							.leftOuterJoin("shopMenu")
	 							.leftOuterJoin("shopMenu.mMenu")
	 							.leftOuterJoin("vCurrentStaffName")
	 							.where("orderDate = cast('" + tmpDf.format(nowDate) + "' as date) and  shopMenu.mLunchShopId = " + shopId + "")
	 							.orderBy("staffId")
	 							.getResultList();
		 
		 List<MenuOrderDto> result = menuOrderDxo.convertDtoList(src);
		 
		 return result;
	}	
	
	/**
	 *　担当者一覧取得 
	 * @return 担当者一覧 
	 */
	public List<MShopAdminDto> getMShopAdminList(){
		
		List<MShopAdmin> src = jdbcManager
								.from(MShopAdmin.class)
								.leftOuterJoin("vCurrentStaffName")
								.orderBy("id")
								.getResultList();
		List<MShopAdminDto> result = mShopAdminDxo.convertDtoList(src);
		
		return result;
	}

	/**
	 *　店舗一覧取得 
	 * @return 店舗一覧 
	 */
	public List<MLunchShopDto> getShopList(){
		
		List<MLunchShop> src = jdbcManager
								.from(MLunchShop.class)
								.leftOuterJoin("mPrefecture")
								.orderBy("shopId")
								.getResultList();
		List<MLunchShopDto> result = mLunchShopDxo.convertDtoList(src);
		
		return result;
	}
	

	/**
	 * 担当者追加
	 * @param mShopAdminDto
	 * @return 追加件数
	 */
	public int insertMShopAdmin(MShopAdminDto mShopAdminDto){
		
		//最低限データがあるか
		if( this.checkMShopAdminDto(mShopAdminDto) ){
			
			mShopAdminDto.id = null;
			mShopAdminDto.registrationDate = new Date();
			mShopAdminDto.updateDate = new Date();
			MShopAdmin entity = mShopAdminDxo.convert(mShopAdminDto);				
			
			return jdbcManager.insert(entity).execute();
		}
		
		return 0;
	}
	
	/**
	 * 担当者情報更新
	 * @param mShopAdminDto
	 * @return 更新件数
	 */
	public int updateMShopAdmin(MShopAdminDto mShopAdminDto){
		
		//最低限データがあるか
		if( this.checkMShopAdminDto(mShopAdminDto) ){
			
			mShopAdminDto.updateDate = new Date();
			MShopAdmin entity = mShopAdminDxo.convert(mShopAdminDto);									
			return jdbcManager.update(entity).execute();
			
		}
		return 0;
	}

  	/**
	 * 担当者情報削除
	 * @param mShopAdminDto
	 * @return 更新件数
	 */
	public int deleteMShopAdmin(MShopAdminDto mShopAdminDto){
		
		//最低限データがあるか
		if( this.checkMShopAdminDto(mShopAdminDto) ){
			MShopAdmin entity = mShopAdminDxo.convert(mShopAdminDto);
			
			return jdbcManager.delete(entity).execute();
			
		}
		return 0;
	}

	/**
	 * MShopAdminDtoが更新できる最低限のデータがあるかどうか調べる
	 * @param src
	 * @return
	 */
	public boolean checkMShopAdminDto(MShopAdminDto src){					
		return src.startDate.before(src.finishDate);
	}
	
	/**
	 * 社員一覧取得
	 * @return
	 */
	public List<VCurrentStaffNameDto> getStaffList(){
		
		List<VCurrentStaffName> src = jdbcManager
									.from(VCurrentStaffName.class)
									.orderBy("staffId")
									.getResultList();
		List<VCurrentStaffNameDto> result =  vCurrentStaffNameDxo.convertList(src);
		
		return result;
	}


	/**
	 * ショップ新規登録処理
	 * 
	 * @param shopData 登録ショップデータ
	 */	
	public void insertShopData(MLunchShopDto shopData)
	{
		shopData.registrationTime = new Date();
		
		MLunchShop insertData =  mLunchShopDxo.convert(shopData);
		
		
		// 登録の実行
		jdbcManager.insert(insertData).execute();
	}
	
	/**
	 * ショップ更新処理
	 * 
	 * @param shopData 更新ショップデータ
	 */	
	public void updateShopData(MLunchShopDto shopData)
	{		
		// DBに登録されているデータを取得
		MLunchShop updateData = 
			jdbcManager.from(MLunchShop.class)
			.where(new SimpleWhere().eq("shopId", shopData.shopId))
			.getSingleResult();
		
		// DBのデータと差分があるか比較
		if(!(shopData.shopName.equals(updateData.shopName) && shopData.orderLimitTime.equals(updateData.orderLimitTime)
				 && shopData.shopUrl.equals(updateData.shopUrl) && shopData.postalCode1.equals(updateData.postalCode1)
				 && shopData.postalCode2.equals(updateData.postalCode2) && shopData.prefectureCode.equals(updateData.prefectureCode)
				 && shopData.ward.equals(updateData.ward) && shopData.houseNumber.equals(updateData.houseNumber)
				 && shopData.shopPhoneNo1.equals(updateData.shopPhoneNo1) && shopData.shopPhoneNo2.equals(updateData.shopPhoneNo2)
				 && shopData.shopPhoneNo3.equals(updateData.shopPhoneNo3))){
			
			updateData.shopName = shopData.shopName;
			updateData.orderLimitTime = shopData.orderLimitTime;
			updateData.shopUrl = shopData.shopUrl;
			updateData.postalCode1 = shopData.postalCode1;
			updateData.postalCode2 = shopData.postalCode2;
			updateData.prefectureCode = shopData.prefectureCode;
			updateData.ward = shopData.ward;
			updateData.houseNumber = shopData.houseNumber;
			updateData.shopPhoneNo1 = shopData.shopPhoneNo1;
			updateData.shopPhoneNo2 = shopData.shopPhoneNo2;
			updateData.shopPhoneNo3 = shopData.shopPhoneNo3;
			updateData.registrationTime = new Date();
			updateData.registrantId = shopData.registrantId;
			
			// 更新の実行
			jdbcManager.update(updateData).execute();
			
			
		}
	}
	
	/**
	 * ショップ削除処理
	 * 
	 * @param shopData 削除ショップデータ
	 */	
	public void deleteShopData(MLunchShopDto shopData)
	{
		if(shopData != null){
			MLunchShop deleteData =  mLunchShopDxo.convert(shopData);
			// 削除の実行
			jdbcManager.delete(deleteData).execute();
		}
	}

	
	/**
	 * オプション新規登録処理
	 * 
	 * @param optionData 登録ショップデータ
	 */	
	public void insertOptionData(OptionDto optionData)
	{
		optionData.registrationDate = new Date();
		
		Option insertData =  optionDxo.convert(optionData);
		
		// 登録の実行
		jdbcManager.insert(insertData).execute();
	}
	
	/**
	 * オプション更新処理
	 * 
	 * @param optionData 更新オプションデータ
	 */	
	public void updateOptionData(OptionDto optionData)
	{		
		// DBに登録されているデータを取得
		Option updateData = 
			jdbcManager.from(Option.class)
			.where(new SimpleWhere().eq("id", optionData.id))
			.getSingleResult();		
		
		// DBのデータと差分があるか比較
		if(!(optionData.optionCode.equals(updateData.optionCode) && optionData.optionName.equals(updateData.optionName)	
				&& optionData.optionDisplayName.equals(updateData.optionDisplayName) && optionData.price.equals(updateData.price))){
			
			updateData.optionCode = optionData.optionCode;
			updateData.optionName = optionData.optionName;
			updateData.optionDisplayName = optionData.optionDisplayName;
			updateData.price = optionData.price;
			updateData.registrationId = optionData.registrationId;
			updateData.updatedDate = new Date();
			
			// 更新の実行
			jdbcManager.update(updateData).execute();
		}
	}
	
	/**
	 * オプション削除処理
	 * 
	 * @param optionData 削除オプションデータ
	 */	
	public void deleteOptionData(OptionDto optionData)
	{
		if(optionData != null){
			Option deleteData =  optionDxo.convert(optionData);
			// 削除の実行
			jdbcManager.delete(deleteData).execute();
		}
	}
	
	/**
	 * オプション種類削除処理
	 * 
	 * @param optionData 削除オプションデータ
	 */	
	public void deleteOptionKind(MOptionKindDto optionKind, List<OptionKindDto> option, List<ExclusiveOptionDto> exclusiveOption)
	{
		if(option != null){
			List<OptionKind> deleteOption = optionKindDxo.convertList(option);
			// 削除の実行
			jdbcManager.deleteBatch(deleteOption).execute();			
		}				

		if(exclusiveOption != null){
			List<ExclusiveOption> deleteExclusiveOption = exclusiveOptionDxo.convertList(exclusiveOption);
			// 削除の実行
			jdbcManager.deleteBatch(deleteExclusiveOption).execute();						
		}		
		
		if(optionKind != null){
			MOptionKind deleteOptionKind = mOptionKindDxo.convert(optionKind);
			// 削除の実行
			jdbcManager.delete(deleteOptionKind).execute();
		}		
	}
	
	/**
	 * オーダー登録処理
	 * 
	 * @param insertData 登録ショップデータ
	 */	
	public boolean insertOrder(MenuOrderDto orderData, List<MenuOrderOptionDto> orderOption, String limitTime)
	{
		Date nowDate = new Date();
	
		DateFormat tmpDf = new SimpleDateFormat("yyyy/MM/dd");
		String orderDate = tmpDf.format(orderData.orderDate) + " " + limitTime;
		
		try{
	        DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm");
			Date limitDate = df.parse(orderDate);
		
			if(limitDate.compareTo(nowDate) < 0){
				return false;
			}else{
				orderData.registrationDate = nowDate;
				MenuOrder insertOrder = menuOrderDxo.convert(orderData);
				
				// 登録の実行
				jdbcManager.insert(insertOrder).execute();

				
				Boolean bool = true;
				
				for(MenuOrderOptionDto tmp : orderOption){
					tmp.menuOrderId = insertOrder.id;
					if(tmp.mOptionId == 0){
						bool = false;
					}
				}
				
				if(bool){
					List<MenuOrderOption> insertOption = menuOrderOptionDxo.convertList(orderOption);
					// 登録の実行
					jdbcManager.insertBatch(insertOption).execute();
				}	
				
				return true;				
			}		
		}catch(ParseException e){
			return false;
		}		
	}
	
	/**
	 * オーダー削除処理
	 * 
	 * @param menuOrder 削除データ
	 */	
	public void deleteOrder(List<MenuOrderDto> menuOrder, List<MenuOrderOptionDto> menuOrderOption)
	{	
		for(MenuOrderOptionDto tmp : menuOrderOption){
			if(tmp.mOptionId > 0){
				MenuOrderOption deleteOption = menuOrderOptionDxo.convert(tmp);
				// 削除の実行
				jdbcManager.deleteBatch(deleteOption).execute();							
			}			
		}
		
		if(menuOrder != null){
			List<MenuOrder> deleteOrder = menuOrderDxo.convertList(menuOrder);
			// 削除の実行
			jdbcManager.deleteBatch(deleteOrder).execute();			
		}
	}
	
	/**
	 * オーダー更新処理
	 * 
	 * @param insertData 登録ショップデータ
	 */	
	public void upDateOrder(List<MenuOrderDto> orderData)
	{
		if(orderData != null){
			List<MenuOrder> updateOrder = menuOrderDxo.convertList(orderData);
			
			// 更新の実行
			jdbcManager.updateBatch(updateOrder).execute();
		}
	}
	
	/**
	 * メニュー更新処理
	 * 
	 * @param menuData メニューデータ
	 */	
	public void updateMenuData(MMenuDto menuData)
	{
		// メニュー画像更新処理
		updateMenuImage(menuData.id, menuData.photo);			
		
		if(menuData.mOptionSetId == 0){
			menuData.mOptionSetId = null;
		}
		
		// DBに登録されているデータを取得
		MMenu updateData = 
			jdbcManager.from(MMenu.class)
			.where(new SimpleWhere().eq("id", menuData.id))
			.getSingleResult();

		Boolean bool = checkNull(updateData, menuData);
		
		if(!(menuData.menuCode.equals(updateData.menuCode) && menuData.menuName.equals(updateData.menuName) 
				&& menuData.price.equals(updateData.price) && bool 
				&& menuData.menuCategoryId.equals(updateData.menuCategoryId) && menuData.comment.equals(updateData.comment))){
			
			updateData.menuCode = menuData.menuCode;
			updateData.menuName = menuData.menuName;
			updateData.price = menuData.price;
			updateData.mOptionSetId = menuData.mOptionSetId;
			updateData.menuCategoryId = menuData.menuCategoryId;
			updateData.comment = menuData.comment;
			updateData.registrationId = menuData.registrationId;
			updateData.updatedDate = new Date();	
			
			// 更新の実行
			jdbcManager.update(updateData).execute();
		}
	}
	
	
	/**
	 * メニュー画像更新処理
	 * 
	 * @param id メニューID
	 * @param photo メニュー画像
	 */
	public void updateMenuImage(Integer id, byte[] photo)
	{
		// 更新の実行
		jdbcManager.updateBySql(
							"update m_menu set photo = ? where id = ?",
							Parameter.class, Integer.class)
						.params(Parameter.lob(photo), id)
						.execute();
	}

	/**
	 * 更新時Nullチェック処理
	 * 
	 * @param updateData 登録中メニューデータ
	 * @param menuData 更新予定メニューデータ
	 */
	public Boolean checkNull(MMenu updateData, MMenuDto menuData)
	{
		if(updateData.mOptionSetId == null){
			if(menuData.mOptionSetId == null){
				return true;
			}else{
				return false;
			}
		}else{
			if(menuData.mOptionSetId == null){
				return false;
			}else if(menuData.mOptionSetId.equals(updateData.mOptionSetId)){
				return true;
			}else{
				return false;
			}
		}		
	}
	
	/**
	 * メニュー新規登録処理
	 * 
	 * @param menuData メニューデータ
	 */	
	public void insertMenuData(MMenuDto menuData)
	{
		if(menuData.mOptionSetId == 0){
			menuData.mOptionSetId = null;
		}
		
		menuData.registrationDate = new Date();
		
		MMenu insertData =  mMenuDxo.convert(menuData);
		
		// 登録の実行
		jdbcManager.insert(insertData).execute();
	}	
	
	/**
	 * メニュー削除処理
	 * 
	 * @param menuData メニューデータ
	 */	
	public Boolean deleteMenuData(MMenuDto menuData)	
	{
		Long menuCount = 
			jdbcManager.from(ShopMenu.class)
			.where(new SimpleWhere().eq("mMenuId", menuData.id))
			.getCount();
		
		if(menuCount == 0){
			MMenu deleteData =  mMenuDxo.convert(menuData);		
			// 削除の実行
			jdbcManager.delete(deleteData).execute();
			
			return true;
		}else{
			return false;
		}
	}
}