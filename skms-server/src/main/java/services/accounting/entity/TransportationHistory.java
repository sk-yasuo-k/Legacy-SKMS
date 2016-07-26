package services.accounting.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.accounting.dto.TransportationDto;
import services.generalAffair.entity.MStaff;


/**
 * 交通費申請履歴エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity
public class TransportationHistory implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 交通費申請IDです。
	 */
	@Id
	public int transportationId;

	/**
	 * 更新回数です。
	 */
	@Id
	public int updateCount;

	/**
	 * 交通費申請状況IDです。
	 */
	public int transportationStatusId;

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
	 * コメントです。
	 */
	public String comment;

	/**
	 * 交通費申請状況種別マスタ情報です。
	 */
	@OneToOne
	@JoinColumn(name="transportation_status_id")
	public MTransportationStatus transportationStatus;

	/**
	 * 交通費申請情報です。
	 */
    @ManyToOne
	@JoinColumn(name="transportation_id")
	public Transportation transportation;

	/**
	 * コンストラクタ
	 */
	public TransportationHistory() {
	}

	/**
	 * コンストラクタ Transportationを設定
	 */
	public TransportationHistory(Transportation trans){
		this.transportationId = trans.transportationId;
		this.registrantId     = trans.registrantId;
		this.registrationTime = trans.registrationTime;
	}

	/**
	 * コンストラクタ TransportationDto・Staffを設定
	 */
	public TransportationHistory(TransportationDto transDto, MStaff staff){
		this.transportationId = transDto.transportationId;
		this.registrantId     = staff.staffId;
	}

}