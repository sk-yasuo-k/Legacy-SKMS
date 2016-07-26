package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import services.accounting.entity.TransportationRoute;
import services.generalAffair.entity.MStaff;



/**
 * 交通費申請・経路保存情報です。
 *
 * @author yasuo-k
 *
 */
public class RouteDto implements Serializable {

	static final long serialVersionUID = 1L;
	/**
	 * (entity)経路IDです。
	 */
	public int routeId;

	/**
	 * (entity)経路名です。
	 */
	public String routeName;

	/**
	 * (entity)社員IDです。
	 */
	public int staffId;

	/**
	 * (entity)登録日時です。
	 */
	public Date registrationTime;

	/**
	 * (entity)登録者IDです。
	 */
	public int registrantId;

	/**
	 * (entity)登録バージョンです。
	 */
	public int registrationVer;

	/**
	 * (entity)表示順です。
	 */
	public int sortOrder;


	/**
	 * 社員情報です。
	 */
	public MStaff staff;

	/**
	 * 経路詳細情報です。
	 */
	public List<RouteDetailDto> routeDetails;

	/**
	 * 削除フラグです。
	 */
	public boolean isDelete;


	/**
	 * コンストラクタ
	 */
	public RouteDto(){
		;
	}

	/**
	 * コンストラクタ TransportationRouteを設定
	 */
	public RouteDto(TransportationRoute route)
	{
		this.routeId          = route.transportationRouteId;
		this.routeName        = route.transportationRouteName;
		this.staffId          = route.staffId;
		this.staff            = route.staff;
		this.registrantId     = route.registrantId;
		this.registrationTime = route.registrationTime;
		this.registrationVer  = route.registrationVer;
	}


	/**
	 * 経路情報 削除確認。
	 */
	public boolean isDelete() {
		if (this.isDelete && this.routeId > 0)		return true;
		return false;
	}

	/**
	 * 経路情報 更新確認。
	 */
	public boolean isUpdate() {
		if (!this.isDelete && this.routeId > 0)		return true;
		return false;
	}

	/**
	 * 経路情報 新規登録確認。
	 */
	public boolean isNew() {
		if (!this.isDelete && !(this.routeId > 0))	return true;
		return false;
	}
}