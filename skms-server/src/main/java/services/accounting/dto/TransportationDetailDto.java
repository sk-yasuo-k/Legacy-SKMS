package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;

import services.accounting.entity.TransportationDetail;


/**
 * 交通費申請明細情報です。
 *
 * @author yasuo-k
 *
 */
public class TransportationDetailDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * (entity)交通費申請IDです。
	 */
	public int transportationId;

	/**
	 * (entity)交通費申請明細連番です。
	 */
	public int transportationSeq;

    /**
	 * (entity)交通費発生日です。
	 */
	public Date transportationDate;

	/**
	 * (entity)業務です。
	 */
	public String task;

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
	 * (entity)領収書番号です。
	 */
	public String receiptNo;

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

//	/**
//	 * 交通費申請情報です。
//	 */
//	public TransportationDto transportationDto;

	/**
	 * 削除フラグです。
	 */
	public boolean isDelete = false;


	/**
	 * コンストラクタ
	 */
	public TransportationDetailDto(){
		;
	}

	/**
	 * コンストラクタ TransportationDetailを設定
	 */
	public TransportationDetailDto(TransportationDetail trans)
	{
		this.transportationId   = trans.transportationId;
		this.transportationSeq  = trans.sequenceNo;
		this.transportationDate = trans.transportationDate;
		this.task               = trans.task;
		this.destination        = trans.destination;
		this.facilityName       = trans.facilityName;
		this.departure          = trans.departure;
		this.arrival            = trans.arrival;
		this.via                = trans.via;
		//this.roundTrip          = trans.roundTrip ? "往復" : "片道";
		this.roundTrip          = trans.roundTrip;
		this.oneWayExpense      = trans.expense   == null ?
									null : (trans.roundTrip ? Integer.toString(trans.expense / 2) : Integer.toString(trans.expense));
		this.expense            = trans.expense   == null ? null : Integer.toString(trans.expense);
		this.note               = trans.note;
		this.receiptNo          = trans.receiptNo == null ? null : Integer.toString(trans.receiptNo);
		this.registrantId       = trans.registrantId;
		this.registrationTime   = trans.registrationTime;
		this.registrationVer    = trans.registrationVer;
//		this.transportationDto  = new TransportationDto(trans.transportation);
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
		if (this.isDelete && isConstraint()) 	return true;
		return false;
	}

	/**
	 * 更新確認.
	 */
	public boolean isUpdate() {
		if (!isDelete() && isConstraint()) 		return true;
		return false;
	}

	/**
	 * 新規確認.
	 */
	public boolean isNew() {
		if (!this.isDelete && !isConstraint()) 	return true;
		return false;
	}

	/**
	 * Constraint確認
	 */
	private boolean isConstraint() {
		if (this.transportationId > 0 && this.transportationSeq > 0)	return true;
		return false;
	}

}