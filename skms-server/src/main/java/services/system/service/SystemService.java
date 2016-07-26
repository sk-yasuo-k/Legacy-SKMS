package services.system.service;

import java.util.ArrayList;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.SqlBatchUpdate;
import org.seasar.extension.jdbc.where.SimpleWhere;

import enumerate.AuthorityLevel;
import enumerate.DepartmentId;
import enumerate.ProjectPositionId;

import services.system.dto.TreeDto;
import services.system.dxo.TreeDxo;
import services.system.entity.MSkmsMenu;
import services.system.entity.StaffSetting;

/**
 * システムを扱うサービスです。
 *
 * @author yasuo-k
 *
 */
public class SystemService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * TreeDxoです。
	 */
	public TreeDxo treeDxo;
	
	/**
	 * 社員の環境設定を取得します。
	 *
	 * @param  staffId 
	 * @return 環境変数
	 */
	public StaffSetting getStaffSetting(int staffId)
	{
		
		// 社員の環境設定取得
		StaffSetting staffSetting = jdbcManager
			.from(StaffSetting.class)
			.where(new SimpleWhere().eq("staffId", staffId) )
			.getSingleResult();
		
		return staffSetting;
	}

	/**
	 * 社員の環境設定を登録します。
	 *
	 * @param  staffId 
	 * @return 環境変数
	 */
	public void updateStaffSetting(StaffSetting staffSetting)
	{
		jdbcUpdateStaffSetting(staffSetting);
	}

	/**
	 * 環境設定を登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcUpdateStaffSetting(StaffSetting staffSetting)
	{
		// staffSettingの更新.
		return jdbcManager.update(staffSetting).execute();
	}

	/**
	 * メニューリストを取得します。
	 * 
	 * @param staffId
	 * @return メニューリスト
	 */
	public List<TreeDto> getMenuList(int staffId)
	{
		// 権限レベルを取得する。
		int iAuth = getAuthorityLevel(staffId);
		
		// 環境設定状況によりメニュー取得条件を変更する。
		List<MSkmsMenu> list;
		Boolean flag = jdbcManager.selectBySql(Boolean.class, 
												"select my_menu from staff_setting where staff_id = " + staffId)
												.getSingleResult();
		if (Boolean.TRUE == flag)
		{
			// 「Home」と「La!Coodaに戻る」は表示しない。
			// →表示順は treeDxo.convertToAllMenu で並べ替える。
			list = jdbcManager.from(MSkmsMenu.class)
												.where(new SimpleWhere().gt("skmsMenuId", 0))
												.orderBy("skmsMenuId")
												.getResultList();
		}
		else 
		{
			list = jdbcManager.from(MSkmsMenu.class)
												.orderBy("skmsMenuId")
												.getResultList();
		}
		
		
		// 権限がないものはメニューリストから削除する。
		List<MSkmsMenu> list2 = new ArrayList<MSkmsMenu>();
		for (MSkmsMenu entity : list)
		{
			if ((entity.authority & iAuth) > 0)
			{
				list2.add(entity);
			}
		}
		
		// メニューリストをClientで使用するtree構造に変換する。
		List<TreeDto> menuLit = treeDxo.convertToAllMenu(list2);
		return menuLit;
	}
	
	/**
	 * マイメニューリストを取得します。
	 * 
	 * @param staffId
	 * @return メニューリスト
	 */
	public List<TreeDto> getMyMenuList(int staffId)
	{
		// 権限レベルを取得する。
		int iAuth = getAuthorityLevel(staffId);
		
		// 「Home」と「La!Coodaに戻る」は常に表示する。
		// →SQLで表示順にデータを取得する。
		List<MSkmsMenu> listx = jdbcManager.from(MSkmsMenu.class)
											.where(new SimpleWhere().lt("skmsMenuId", 0))
											.orderBy("skms_menu_sort_order")
											.getResultList();
		List<MSkmsMenu> list = jdbcManager.selectBySql(MSkmsMenu.class
												, "select m_.* from m_skms_menu m_ " 
												 + "inner join staff_setting_menu s_ on s_.skms_menu_id = m_.skms_menu_id and s_.staff_id = " + staffId + " "
												 + "order by s_.skms_menu_sort_order "
												 )
											.getResultList();

		// メニューを結合する。
		for (MSkmsMenu x : listx)
		{
			if (x.skmsMenuSortOrder < 0) 
			{
				list.add(0, x);
			}
			else 
			{
				list.add(x);
			}
			
		}
		
		// 権限がないものはメニューリストから削除する。
		List<MSkmsMenu> list2 = new ArrayList<MSkmsMenu>();
		for (MSkmsMenu entity : list)
		{
			if ((entity.authority & iAuth) > 0)
			{
				list2.add(entity);
			}
		}
		
		// メニューリストをClientで使用するtree構造に変換する。
		List<TreeDto> menuLit = treeDxo.convertToMyMenu(list2);
		return menuLit;
	}
	
	/**
	 * 権限レベルを取得します。
	 * 
	 * @param staffId
	 * @return 権限レベル
	 */
	private int getAuthorityLevel(int staffId)
	{
		//boolean bAuthSf = true;
		boolean bAuthPm = getAuthorityPm(staffId);
		boolean bAuthGa = getAuthorityGa(staffId);
		
		int iAuthSf = AuthorityLevel.STAFF;
		int iAuthPm = bAuthPm ? AuthorityLevel.PM : 0;
		int iAuthGa = bAuthGa ? AuthorityLevel.GA : 0;
		
		return iAuthSf + iAuthPm + iAuthGa;
	}
	
	/**
	 * 総務権限の有無を取得します。
	 * 
	 * @param staffId
	 * @return 権限
	 */
	private boolean getAuthorityGa(int staffId)
	{
		Integer cnt = jdbcManager
							.selectBySql(Integer.class, 
										"select count(*) from v_current_staff_department_head "
											+ " where staff_id = " + staffId
											+ "  and department_id = " + DepartmentId.GENERAL_AFFAIR
										)
							.getSingleResult();
		return cnt == 1 ? true : false;
	}
	
	/**
	 * PM権限の有無を取得します。
	 * 
	 * @param staffId
	 * @return 権限
	 */
	private boolean getAuthorityPm(int staffId)
	{
		Integer cnt = jdbcManager
							.selectBySql(Integer.class, 
										"select count(*) from v_current_staff_project_position "
											+ " where staff_id = " + staffId
											+ "  and project_position_id = " + ProjectPositionId.PM
										  )
							.getSingleResult();
		return cnt == 1 ? true : false;
	}
	
	/**
	 * マイメニューを登録します。
	 * 
	 * @param list
	 */
	public void entryMyMenuList(int staffId, List<TreeDto> list)
	{
		// 登録済みのメニューを削除する。
		SqlBatchUpdate batchDel = jdbcManager
									.updateBatchBySql("delete from staff_setting_menu where staff_id = ?", 
														Integer.class);
		batchDel.params(staffId);
		batchDel.execute();
		
		// 新規メニューを登録する。
		SqlBatchUpdate batchUpd = jdbcManager
									.updateBatchBySql("insert into staff_setting_menu values( ?, ?, ? )", 
														Integer.class, Integer.class, Integer.class);
		int index = 1;
		for (TreeDto dto : list)
		{
			// 「Home」と「La!Coodaに戻る」は登録しない。
			if (dto.id > 0) 
			{
				batchUpd.params(staffId, dto.id, index++);
			}
		}
		batchUpd.execute();														
		return;
	}
}