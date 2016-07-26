package services.accounting.dxo;

import java.util.List;

import services.accounting.dto.RouteDto;
import services.accounting.entity.TransportationRoute;
import services.generalAffair.entity.MStaff;

/**
 * 交通費申請・経路保存情報変換Dxoです。
 *
 * @author yasuo-k
 *
 */
public interface TransportationRouteDxo {

	/**
	 * 経路情報エンティティリストから経路情報Dtoリストへ変換.
	 *
	 * @param src 経路情報エンティティリスト
	 * @return 経路情報Dtoリスト
	 */
	public List<RouteDto> convertGetRoutes(List<TransportationRoute> src);

	/**
	 * 経路情報Dtoから経路情報エンティティへ変換.
	 *
	 * @param  src 経路情報Dto
	 * @param  staff ログイン社員情報
	 * @param  index 経路Index
	 * @return 経路情報エンティティ
	 */
	public TransportationRoute convertCreate(RouteDto src, MStaff staff, int index);

	/**
	 * 経路情報Dtoから経路情報エンティティへ変換.
	 *
	 * @param  src 経路情報Dto
	 * @param  staff ログイン社員情報
	 * @param  index 経路Index
	 * @return 経路情報エンティティ
	 */
	public TransportationRoute convertUpdate(RouteDto src, MStaff staff, int index);

	/**
	 * 経路情報Dtoから経路情報エンティティへ変換.
	 *
	 * @param  src 経路情報Dto
	 * @param  staff ログイン社員情報
	 * @return 経路情報エンティティ
	 */
	public TransportationRoute convertDelete(RouteDto src, MStaff staff);

}
