package services.accounting.dxo.impl;

import org.seasar.extension.jdbc.JdbcManager;

import services.accounting.dto.RouteDetailDto;
import services.accounting.dxo.TransportationRouteDetailDxo;
import services.accounting.entity.TransportationRoute;
import services.accounting.entity.TransportationRouteDetail;

/**
 * 交通費申請・経路詳細保存情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class TransportationRouteDetailDxoImpl implements TransportationRouteDetailDxo {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * 連番の初期値です。
	 */
	public static final int INIT_SEQNO = 1;


	/**
	 * 経路詳細情報Dtoから経路詳細情報エンティティへ変換.
	 *
	 * @param  src 経路詳細情報Dto
	 * @return 経路詳細情報エンティティ
	 */
	public TransportationRouteDetail convertDelete(RouteDetailDto src) {
		TransportationRouteDetail dst = new TransportationRouteDetail(src);
		return dst;
	}

	/**
	 * 経路詳細情報Dtoから経路詳細情報エンティティへ変換.
	 *
	 * @param  src    経路詳細情報Dto
	 * @param  parent 経路情報エンティティ
	 * @param  index  経路詳細Index
	 * @return 経路詳細情報エンティティ
	 */
	public TransportationRouteDetail convertUpdate(RouteDetailDto src, TransportationRoute parent, int index)
	{
		TransportationRouteDetail dst = new TransportationRouteDetail(src);
		dst.registrantId = parent.registrantId;
		dst.sortOrder    = index;
		return dst;
	}

	/**
	 * 経路詳細情報Dtoから経路詳細情報エンティティへ変換.
	 * 経路連番採番あり。※経路連番を採番する.
	 *
	 * @param  src    経路詳細情報Dto
	 * @param  parent 経路情報エンティティ
	 * @param  index  経路詳細Index
	 * @return 経路詳細情報エンティティ
	 */
	public TransportationRouteDetail convertCreate(RouteDetailDto src, TransportationRoute parent, int index) {
		TransportationRouteDetail dst = new TransportationRouteDetail(src);
		dst.transportationRouteId = parent.transportationRouteId;
		dst.sequenceNo   = nextval_routeSeq(dst.transportationRouteId);
		dst.registrantId = parent.registrantId;
		dst.sortOrder    = index;
		return dst;
	}


	/**
	 * Next経路詳細連番の発行.
	 *
	 * @param  routeId 経路ID
	 * @return Next経路詳細連番
	 */
	private int nextval_routeSeq(int routeId) {
		// 経路詳細連番のレコード数を取得する。
		long cnt = jdbcManager.from(TransportationRouteDetail.class)
								.where("transportation_route_id = ?", routeId).getCount();
		if (!(cnt > 0))		return INIT_SEQNO;

		// 採番済みの経路詳細連番を取得する。
		String maxSql = "select max(sequence_no) from transportation_route_detail where transportation_route_id =" + routeId;
		int currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		return (currval + 1);
	}

}