package services.accounting.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;

import services.accounting.dto.RouteDetailDto;
import services.accounting.dto.RouteDto;
import services.accounting.dxo.TransportationRouteDxo;
import services.accounting.entity.TransportationRoute;
import services.accounting.entity.TransportationRouteDetail;
import services.generalAffair.entity.MStaff;

/**
 * 交通費申請・経路保存情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class TransportationRouteDxoImpl implements TransportationRouteDxo {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;


	/**
	 * 経路情報エンティティリストから経路情報Dtoリストへ変換.
	 *
	 * @param src 経路情報エンティティリスト
	 * @return List<RouteDto> 経路情報Dtoリスト
	 */
	public List<RouteDto> convertGetRoutes(List<TransportationRoute> src) {
		List<RouteDto> dst = new ArrayList<RouteDto>();
		for (TransportationRoute dto : src) {
			dst.add(convertGetRoute(dto));
		}
		return dst;
	}

	/**
	 * 経路情報エンティティから経路情報Dtoへ変換.
	 *
	 * @param src 経路情報エンティティ
	 * @return RouteDto 経路情報Dto
	 */
	private RouteDto convertGetRoute(TransportationRoute src)
	{
		// transportation_routeを設定する。
		RouteDto dst = new RouteDto(src);


		// transportation_route_detailを設定する。
		dst.routeDetails     = new ArrayList<RouteDetailDto>();
		for (TransportationRouteDetail detail : src.transportationRouteDetails) {
			RouteDetailDto detailDto = new RouteDetailDto(detail);
			dst.routeDetails.add(detailDto);
		}
		return dst;
	}

	/**
	 * 経路情報Dtoから経路情報エンティティへ変換.
	 * ※経路ID、経路詳細連番を採番する.
	 *
	 * @param  src 経路情報Dto
	 * @param  staff ログイン社員情報
	 * @param  index 経路Index
	 * @return 経路情報エンティティ
	 */
	public TransportationRoute convertCreate(RouteDto src, MStaff staff, int index)
	{
		// TransportationRouteの設定
		TransportationRoute dst = new TransportationRoute(src);
		// 経路IDを採番する.
		int nextRouteId = nextval_routeId();
		dst.transportationRouteId = nextRouteId;
		dst.staffId				  = staff.staffId;
		dst.registrantId		  = staff.staffId;
		dst.sortOrder			  = index;


		// TransportationRouteDetailの設定
		dst.transportationRouteDetails = new ArrayList<TransportationRouteDetail>();
		int sequenceNo = 1;
		for (RouteDetailDto dto : src.routeDetails) {
			// 詳細情報を変換する.
			TransportationRouteDetail routeDetail = new TransportationRouteDetail(dto);

			// 経路ID・経路詳細連番を採番する.
			routeDetail.transportationRouteId = nextRouteId;
			routeDetail.sequenceNo   = sequenceNo;
			routeDetail.registrantId = dst.registrantId;
			routeDetail.sortOrder    = sequenceNo;

			// 詳細情報をリストに追加する。
			dst.transportationRouteDetails.add(routeDetail);
			sequenceNo++;
		}
		return dst;
	}

	/**
	 * 経路情報Dtoから経路情報エンティティへ変換.
	 *
	 * @param  src 経路情報Dto
	 * @param  staff ログイン社員情報
	 * @param  index 経路Index
	 * @return 経路情報エンティティ
	 */
	public TransportationRoute convertUpdate(RouteDto src, MStaff staff, int index)
	{
		// TransportationRouteを作成する。
		TransportationRoute dst = new TransportationRoute(src);
		dst.registrantId        = staff.staffId;
		dst.sortOrder           = index;
		return dst;
	}

	/**
	 * 経路情報Dtoから経路情報エンティティへ変換.
	 *
	 * @param  src 経路情報Dto
	 * @param  staff ログイン社員情報
	 * @return 経路情報エンティティ
	 */
	public TransportationRoute convertDelete(RouteDto src, MStaff staff)
	{
		// TransportationRouteを作成する。
		TransportationRoute dst = new TransportationRoute(src);
		return dst;
	}

	/**
	 * Next経路IDの発行.
	 *
	 * @return Next経路ID
	 */
	private int nextval_routeId() {
		return jdbcManager.selectBySql(Integer.class, "select nextval('transportation_route_transportation_route_id_seq')").getSingleResult();
	}

}