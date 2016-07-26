package services.accounting.entity;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import services.accounting.dto.RouteDto;
import services.generalAffair.entity.MStaff;


/**
 * 交通費申請・経路保存エンティティです.
 *
 */
@Entity
public class TransportationRoute implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 経路IDです.
	 */
	@Id
	public int transportationRouteId;

	/**
	 * 経路名です.
	 */
	public String transportationRouteName;

	/**
	 * 社員IDです.
	 */
	public int staffId;

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
	 * 社員情報です.
	 */
    @OneToOne
	@JoinColumn(name="staff_id")
	public MStaff staff;

	/**
	 * 経路詳細情報です.
	 */
    @OneToMany(mappedBy = "transportationRoute")
	public List<TransportationRouteDetail> transportationRouteDetails;


	/**
	 * コンストラクタ.
	 */
	public TransportationRoute()
	{
		;
	}

	/**
	 * コンストラクタ RouteDtoを設定.
	 */
	public TransportationRoute(RouteDto route)
	{
		this.transportationRouteId   = route.routeId;
		this.transportationRouteName = route.routeName;
		this.staffId                 = route.staffId;
		this.registrationTime        = route.registrationTime;
		this.registrantId            = route.registrantId;
		this.registrationVer         = route.registrationVer;
		if (this.transportationRouteName == null || !(this.transportationRouteName.trim().length() > 0)) {
			Calendar cal = Calendar.getInstance();
			this.transportationRouteName = "経路_"
											+ String.format("%04d", cal.get(Calendar.YEAR))
											+ String.format("%02d", cal.get(Calendar.MONTH) + 1)
											+ String.format("%02d", cal.get(Calendar.DATE));
		}
	}

}