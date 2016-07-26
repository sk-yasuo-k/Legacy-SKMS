package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;

import services.accounting.entity.TransportationRouteDetail;


/**
 * 交通費申請・経路詳細保存情報です。
 *
 * @author yasuo-k
 *
 */
public class RouteDetailDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * (entity)経路IDです。
	 */
	public int routeId;

	/**
	 * (entity)経路詳細連番です。
	 */
	public int routeSeq;

	/**
	 * (entity)経路情報です。
	 */
	public RouteDto routeDto;

	/**
	 * (entity)目的地です。
	 */
	public String destination;

	/**
	 * (entity)交通機関です。
	 */
	public String facilityName;

	/**
	 * (entity)発です。
	 */
	public String departure;

	/**
	 * (entity)着です。
	 */
	public String arrival;

	/**
	 * (entity)経由です。
	 */
	public String via;

	/**
	 * (entity*)往復フラグです。
	 */
	//public String roundTrip;
	public boolean roundTrip;

	/**
	 * 片道金額です。
	 */
	public String oneWayExpense;

	/**
	 * (entity*)金額です。
	 */
	public String expense;

	/**
	 * (entity)備考です。
	 */
	public String note;

	/**
	 * (entity)表示順です。
	 */
	public int sortOrder;

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
	 * 削除フラグです。
	 */
	public boolean isDelete;

	/**
	 * コンストラクタ
	 */
	public RouteDetailDto(){
		;
	}

	/**
	 * コンストラクタ TransportationRouteDetailを設定
	 */
	public RouteDetailDto(TransportationRouteDetail route){
		this.routeId          = route.transportationRouteId;
		this.routeSeq         = route.sequenceNo;
		this.destination      = route.destination;
		this.facilityName     = route.facilityName;
		this.departure        = route.departure;
		this.arrival          = route.arrival;
		this.via              = route.via;
		//this.roundTrip        = route.roundTrip ? "往復" : "片道";
		this.roundTrip        = route.roundTrip;
		this.oneWayExpense    = route.expense   == null ?
									null : (route.roundTrip ? Integer.toString(route.expense / 2) : Integer.toString(route.expense));
		this.expense          = route.expense == null ? null : Integer.toString(route.expense);
		this.note             = route.note;
		this.registrantId     = route.registrantId;
		this.registrationTime = route.registrationTime;
		this.registrationVer  = route.registrationVer;
		this.routeDto         = new RouteDto(route.transportationRoute);
	}

	/**
	 * 削除設定.
	 */
	public void setDelete() {
		this.isDelete = true;
	}

	/**
	 * 削除確認.
	 */
	public boolean isDelete() {
		if (this.isDelete && this.routeId > 0 && this.routeSeq > 0)	return true;
		return false;
	}

	/**
	 * 更新確認.
	 */
	public boolean isUpdate() {
		if (!isDelete() && this.routeId > 0 && this.routeSeq > 0 ) 	return true;
		return false;
	}

	/**
	 * 新規確認.
	 */
	public boolean isNew() {
		if (!isUpdate())	return true;
		return false;
	}

}