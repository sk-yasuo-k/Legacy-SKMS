package services.system.dxo.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import services.system.dto.TreeDto;
import services.system.dxo.TreeDxo;
import services.system.entity.MSkmsMenu;

/**
 * TreeDxoです。 *
 * @author yasuo-k
 *
 */
public abstract class TreeDxoImpl implements TreeDxo {

	/**
	 * メニューエンティティリストからメニューリストへ変換.
	 * 
	 * @param src メニューエンティティリスト
	 * @return メニューリスト
	 */
	public List<TreeDto> convertToAllMenu(List<MSkmsMenu> src)
	{
		List<TreeDto> dst = new ArrayList<TreeDto>();
		for (MSkmsMenu entity : src)
		{
			// 親メニューがnullのとき
			if (entity.parentMenuId == null) 
			{
				// 対象外とする。
				continue;
			}
			
			// 親メニューのとき
			if (entity.parentMenuId.equals(entity.skmsMenuId)) 
			{
				TreeDto dto = new TreeDto();
				dto.id = entity.skmsMenuId;
				dto.label = entity.skmsMenuName;
				dto.alias = entity.skmsMenuAlias;
				dto.url = entity.skmsMenuUrl;
				dto.sortOrder = entity.skmsMenuSortOrder;
				dto.urlRef = entity.urlRef;
				dto.children = new ArrayList<TreeDto>();
				dst.add(dto);
			}
			// 子メニューのとき
			else 
			{
				// childrenにメニューを追加する。
				addChildren(dst, entity);
			}		
		}
		
		// 表示順に並び替える。
		List<TreeDto> dmylist = new ArrayList<TreeDto>();
		TreeDto dmy = new TreeDto();
		dmy.children = dst;
		dmylist.add(dmy);
		sortOrder(dmylist);
		
		return dst;
	}

	/**
	 * branchにメニューを追加する。
	 * 
	 * @param list
	 * @param entity
	 * @return 結果
	 */
	private boolean addChildren(List<TreeDto> list, MSkmsMenu entity)
	{
		for (TreeDto m : list)
		{
			// 親メニューかどうか確認する。
			if (entity.parentMenuId.equals(m.id))
			{
				TreeDto dto = new TreeDto();
				dto.id = entity.skmsMenuId;
				dto.label = entity.skmsMenuName;
				dto.alias = entity.skmsMenuAlias;
				dto.url = entity.skmsMenuUrl;
				dto.sortOrder = entity.skmsMenuSortOrder;
				dto.urlRef = entity.urlRef;
				dto.children = new ArrayList<TreeDto>();
				m.children.add(dto);
				return true;
			}
			else 
			{
				// childrenの親メニューに追加する。
				boolean ret = addChildren(m.children, entity);
				if (ret == true)
				{
					return true;
				}
			}
		}
		
		return false;
	}

	/**
	 * sortOrder順に並べ替える。
	 * 
	 * @param list
	 */
	private void sortOrder(List<TreeDto> list)
	{
		if (list != null && list.size() > 0) 
		{
			Collections.sort(list, new Comparator<TreeDto>() {
				public int compare(TreeDto m1, TreeDto m2) 
				{
					Integer m1Value = m1.sortOrder;
					Integer m2Value = m2.sortOrder;
					return m1Value - m2Value;
				}
			});
		}
		
		for (TreeDto dto : list)
		{
			sortOrder(dto.children);
		}
	}
	
}
