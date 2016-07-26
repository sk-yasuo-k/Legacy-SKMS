package services.accounting.service;

import java.util.List;


import org.seasar.extension.jdbc.where.SimpleWhere;

import services.accounting.dto.RouteDetailDto;
import services.accounting.dto.RouteDto;
import services.accounting.entity.TransportationRoute;
import services.accounting.entity.TransportationRouteDetail;
import services.generalAffair.entity.MStaff;


/**
 * 経路を扱うサービスです.
 *
 * @author yasuo-k
 *
 */
public class RouteService extends AccountingService {

	/**
	 * 経路情報リストを返す.
	 *
	 * @param  staff     ログイン社員情報.
	 * @return 経路情報のリスト.
	 */
	public List<RouteDto> getRoutes(MStaff staff) throws Exception
	{
		// 未設定は Exception とする。
		checkData_staff(staff);


		// データベースに問い合わせる.
		List<TransportationRoute> routelist = jdbcManager
											.from(TransportationRoute.class)
											.innerJoin("staff")
											.innerJoin("staff.staffName")
											.leftOuterJoin("transportationRouteDetails")
											.where(new SimpleWhere().eq("staffId", staff.staffId))
											.orderBy("sortOrder, transportationRouteDetails.sortOrder")
											.getResultList();

		// Dxoで変換する.
		return routeDxo.convertGetRoutes(routelist);
	}

	/**
	 * 経路情報を登録・更新する.
	 *
	 * @param  staff     ログイン社員情報.
	 * @param  routeList 経路情報リスト.
	 * @return 実行結果.
	 */
	public int createRoutes(MStaff staff, List<RouteDto> routeDtoList) throws Exception
	{
		// 未設定は Exception とする。
		checkData_staff(staff);
		checkData_routeDtoList(routeDtoList);


		int retnum = 0;
		// dto→entityに変換する.
		int routeSortIndex = 1;
		for (RouteDto routeDto : routeDtoList) {
			// 削除のとき.
			if (routeDto.isDelete()) {
				// transportation_routeの削除
				TransportationRoute route = routeDxo.convertDelete(routeDto, staff);
				retnum += jdbcDeleteTransportationRoute(route);
			}
			// 更新のとき.
			else if (routeDto.isUpdate()) {
				// transportation_routeの更新
				TransportationRoute updateRoute = routeDxo.convertUpdate(routeDto, staff, routeSortIndex++);
				retnum += jdbcUpdateTransportationRoute(updateRoute);

				// transportation_route_detailの追加
				int sortIndex = 1;
				for (RouteDetailDto routeDetailDto : routeDto.routeDetails) {
					TransportationRouteDetail routeDetail;

					// 削除
					if (routeDetailDto.isDelete()) {
						routeDetail = routeDetailDxo.convertDelete(routeDetailDto);
						retnum += jdbcDeleteTransportationRouteDetail(routeDetail);
						continue;
					}
					// 更新
					else if (routeDetailDto.isUpdate()) {
						routeDetail = routeDetailDxo.convertUpdate(routeDetailDto, updateRoute, sortIndex++);
						retnum += jdbcUpdateTransportationRouteDetail(routeDetail);
						continue;
					}
					// 追加
					else if (routeDetailDto.isNew()) {
						routeDetail = routeDetailDxo.convertCreate(routeDetailDto, updateRoute, sortIndex++);
						retnum += jdbcCreateTransportationRouteDetail(routeDetail);
						continue;
					}
				}
			}
			// 追加のとき.
			else if (routeDto.isNew()){
				// transportation_routeの追加
				TransportationRoute createRoute = routeDxo.convertCreate(routeDto, staff, routeSortIndex++);
				retnum += jdbcCreateTransportationRoute(createRoute);

				// transportation_route_detailの追加
				for (TransportationRouteDetail routeDetail : createRoute.transportationRouteDetails) {
					retnum += jdbcCreateTransportationRouteDetail(routeDetail);
				}
			}
		}
		return retnum;
	}

	/**
	 * 経路情報を削除する.
	 *
	 * @param  staff    ログイン社員情報.
	 * @param  routeDto 経路情報Dto.
	 * @return 削除件数.
	 */
	public int deleteRoute(MStaff staff, RouteDto routeDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_routeDto(routeDto);


		int retnum = 0;
		// transportation_routeの削除
		if (routeDto.isDelete()) {
			TransportationRoute route = routeDxo.convertDelete(routeDto, staff);
			retnum += jdbcDeleteTransportationRoute(route);
		}
		return retnum;
	}

	/**
	 * 経路詳細情報を削除する.
	 *
	 * @param  staff     ログイン社員情報.
	 * @param  routeDetailDtoList 経路詳細情報リスト.

	 * @return 削除件数.
	 */
	public int deleteRouteDetails(MStaff staff, List<RouteDetailDto> routeDetailDtoList) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_routeDetailDtoList(routeDetailDtoList);


		int retnum = 0;
		// transportation_route_detailの削除
		for (RouteDetailDto routeDetailDto : routeDetailDtoList) {
			if (routeDetailDto.isDelete()) {
				TransportationRouteDetail routeDetail = routeDetailDxo.convertDelete(routeDetailDto);
				retnum += jdbcDeleteTransportationRouteDetail(routeDetail);
			}
		}
		return retnum;
	}

	/**
	 * 経路情報を登録します.
	 *
	 * @param  entity.
	 * @return 登録件数.
	 */
	private int jdbcCreateTransportationRoute(TransportationRoute entity)
	{
		// transportation_routeの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * 経路情報を更新します.
	 *
	 * @param  entity.
	 * @return 更新件数.
	 */
	private int jdbcUpdateTransportationRoute(TransportationRoute entity)
	{
		// transportation_routeの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * 経路情報を削除します.
	 *
	 * @param  entity.
	 * @return 削除件数.
	 */
	private int jdbcDeleteTransportationRoute(TransportationRoute entity)
	{
		// transportation_routeの削除.
		return jdbcManager.delete(entity).execute();
	}

	/**
	 * 経路詳細情報を登録します.
	 *
	 * @param  entity.
	 * @return 登録件数.
	 */
	private int jdbcCreateTransportationRouteDetail(TransportationRouteDetail entity)
	{
		// transportation_route_detailの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * 経路詳細情報を更新します.
	 *
	 * @param  entity.
	 * @return 更新件数.
	 */
	private int jdbcUpdateTransportationRouteDetail(TransportationRouteDetail entity)
	{
		// transportation_route_detailの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * 経路詳細情報を削除します.
	 *
	 * @param  entity.
	 * @return 削除件数.
	 */
	private int jdbcDeleteTransportationRouteDetail(TransportationRouteDetail entity)
	{
		// transportation_route_detailの削除.
		return jdbcManager.delete(entity).execute();
	}
}
