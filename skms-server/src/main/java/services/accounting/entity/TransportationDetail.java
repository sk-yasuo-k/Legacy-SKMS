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

import services.accounting.dto.TransportationDetailDto;

/**
 * 交通費申請明細情報エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity
public class TransportationDetail implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 交通費申請IDです。
	 */
	@Id
	public int transportationId;

	/**
	 * 交通費申請明細連番です。
	 */
	@Id
	public int sequenceNo;

	/**
	 * 交通費申請情報です。
	 */
    @ManyToOne
	@JoinColumn(name="transportation_id")
    public Transportation transportation;

    /**
	 * 交通費発生日です。
	 */
	@Temporal(TemporalType.DATE)
	public Date transportationDate;

	/**
	 * 業務です。
	 */
	public String task;

	/**
	 * 目的地です。
	 */
	public String destination;

	/**
	 * 交通機関です。
	 */
	public String facilityName;

	/**
	 * 発です。
	 */
	public String departure;

	/**
	 * 着です。
	 */
	public String arrival;

	/**
	 * 経由です。
	 */
	public String via;

	/**
	 * 往復フラグです。
	 */
	public boolean roundTrip;

	/**
	 * 金額です。
	 */
	public Integer expense;

	/**
	 * 備考です。
	 */
	public String note;

	/**
	 * 領収書番号です。
	 */
	public Integer receiptNo;

	/**
	 * 登録日時です。
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(insertable=false, updatable=false)
	public Date registrationTime;

	/**
	 * 登録者IDです。
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	@Version
	public int registrationVer;


	/**
	 * コンストラクタ
	 */
	public TransportationDetail()
	{
		;
	}

	/**
	 * コンストラクタ TransportationDetailDtoを設定
	 */
	public TransportationDetail(TransportationDetailDto trans)
	{
		this.transportationId   = trans.transportationId;
		this.sequenceNo         = trans.transportationSeq;
		this.transportationDate = trans.transportationDate;
		this.task               = trans.task;
		this.destination        = trans.destination;
		this.facilityName       = trans.facilityName;
		this.departure          = trans.departure;
		this.arrival            = trans.arrival;
		this.via                = trans.via;
		//if (trans.roundTrip != null && trans.roundTrip.equals("往復") ) {
		//	this.roundTrip      = true;
		//}
		this.roundTrip          = trans.roundTrip;
		if (trans.expense != null && trans.expense.trim().length() > 0) {
			this.expense        = Integer.parseInt(trans.expense.trim());
		}
		this.note               = trans.note;
		if (trans.receiptNo != null && trans.receiptNo.trim().length() > 0) {
			this.receiptNo      = Integer.parseInt(trans.receiptNo);
		}
		this.registrantId       = trans.registrantId;
		this.registrationTime   = trans.registrationTime;
		this.registrationVer    = trans.registrationVer;
	}

}