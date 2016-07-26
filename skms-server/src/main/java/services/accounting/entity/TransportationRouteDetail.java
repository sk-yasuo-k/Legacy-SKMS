package services.accounting.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import services.accounting.dto.RouteDetailDto;


/**
 * 交通費申請・経路詳細保存エンティティです.
 */
@Entity
public class TransportationRouteDetail implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 経路IDです.
	 */
	@Id
	public int transportationRouteId;

	/**
	 * 経路詳細連番です.
	 */
	@Id
	public int sequenceNo;

	/**
	 * 交通費申請・経路保存エンティティ
	 */
    @ManyToOne
	@JoinColumn(name="transportation_route_id")
    public TransportationRoute transportationRoute;

	/**
	 * 目的地です.
	 */
	public String destination;

	/**
	 * 交通機関です.
	 */
	public String facilityName;

	/**
	 * 出発地です.
	 */
	public String departure;

	/**
	 * 到着です.
	 */
	public String arrival;

	/**
	 * 往復フラグです.
	 */
	public boolean roundTrip;

	/**
	 * 経由です.
	 */
	public String via;

	/**
	 * 金額です.
	 */
	public Integer expense;

	/**
	 * 備考です.
	 */
	public String note;

	/**
	 * 登録日時です.
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(insertable=false, updatable=false)
	public Date registrationTime;

	/**
	 * 登録者IDです.
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	@Version
	public int registrationVer;

	/**
	 * 表示順です.
	  */
	public int sortOrder;


	/**
	 * コンストラクタ.
	 */
	public TransportationRouteDetail()
	{
		;
	}

	/**
	 * コンストラクタ RouteDetailDtoを設定.
	 */
	public TransportationRouteDetail(RouteDetailDto route)
	{
		this.transportationRouteId = route.routeId;
		this.sequenceNo       = route.routeSeq;
		this.destination      = route.destination;
		this.facilityName     = route.facilityName;
		this.departure        = route.departure;
		this.arrival          = route.arrival;
		this.via              = route.via;
		//if (route.roundTrip != null && route.roundTrip.equals("往復") ) {
		//	this.roundTrip      = true;
		//}
		this.roundTrip        = route.roundTrip;
		if (route.expense != null && route.expense.trim().length() > 0) {
			this.expense = Integer.parseInt(route.expense.trim());
		}
		this.note             = route.note;
		this.registrantId     = route.registrantId;
		this.registrationTime = route.registrationTime;
		this.registrationVer  = route.registrationVer;
	}

}