package services.personnelAffair.authority.service;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.personnelAffair.authority.dto.DisplayItemsShowDto;
import services.personnelAffair.authority.dxo.DisplayItemsShowDxo;
import services.personnelAffair.authority.entity.MProfileListChoices;


/**
 * 表示項目表示可否サービス。
 * 表示項目表示可否を扱うサービスです。
 *
 * @author t-ito
 *
 */
public class DisplayItemsShowService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * 表示項目表示可否変換Dxoです。。
	 */
	public DisplayItemsShowDxo authorityDxo;
	
	
	/**
	 * 表示項目表示可否データ取得処理。
	 * 
	 * @return 表示項目表示可否データ
	 */	
	public DisplayItemsShowDto getDisplayItemsShow(Integer listChoicesId){
		/** 検索実行 */
		MProfileListChoices src =jdbcManager
								.from(MProfileListChoices.class)
								.where(new SimpleWhere().eq("listChoicesId", listChoicesId))
								.getSingleResult();
			
		// データの変換
		DisplayItemsShowDto result = authorityDxo.convert(src);
		
		return result;
	}
	
	
	/**
	 * 表示項目表示可否データ処理
	 * 
	 * @param listData 表示項目表示可否更新データ
	 */	
	public void updatelistData(DisplayItemsShowDto listData)
	{
		/** Dtoからエンティティへ変換 */
		MProfileListChoices renewMProfileListChoices = authorityDxo.convertMProfileListChoices(listData);		
		
		// 更新の実行
		jdbcManager.update(renewMProfileListChoices).execute();
	}
}
