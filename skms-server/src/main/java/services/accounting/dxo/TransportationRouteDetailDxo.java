package services.accounting.dxo;

import services.accounting.dto.RouteDetailDto;
import services.accounting.entity.TransportationRoute;
import services.accounting.entity.TransportationRouteDetail;

/**
 * 交通費申請・経路詳細保存情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface TransportationRouteDetailDxo {

	/**
	 * 経路詳細情報Dtoから経路詳細情報エンティティへ変換.
	 *
	 * @param  src 経路詳細情報Dto
	 * @return 経路詳細情報エンティティ
	 */
	public TransportationRouteDetail convertDelete(RouteDetailDto src);

	/**
	 * 経路詳細情報Dtoから経路詳細情報エンティティへ変換.
	 *
	 * @param  src    経路詳細情報Dto
	 * @param  parent 経路情報エンティティ
	 * @param  index  経路詳細Index
	 * @return 経路詳細情報エンティティ
	 */
	public TransportationRouteDetail convertUpdate(RouteDetailDto src, TransportationRoute parent, int index);

	/**
	 * 経路詳細情報Dtoから経路詳細情報エンティティへ変換.
	 *
	 * @param  src    経路詳細情報Dto
	 * @param  parent 経路情報エンティティ
	 * @param  index  経路詳細Index
	 * @return 経路詳細情報エンティティ
	 */
	public TransportationRouteDetail convertCreate(RouteDetailDto src, TransportationRoute parent, int index);
}
