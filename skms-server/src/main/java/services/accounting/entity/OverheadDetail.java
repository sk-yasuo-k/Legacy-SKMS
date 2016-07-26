package services.accounting.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;


/**
 * 諸経費申請明細情報エンティティです.
 *
 * @author yasuo-k
 *
 */
@Entity
public class OverheadDetail implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 諸経費申請IDです.
	 */
	@Id
	public int overheadId;

	/**
	 * 諸経費申請明細連番です.
	 */
	@Id
	public int overheadNo;

	/**
	 * 諸経費申請区分IDです.
	 */
	public Integer overheadTypeId;

	/**
	 * 諸経費申請内訳です.
	 */
	public String content;

//	/**
//	 * 設備IDです.
//	 */
//	public Integer equipmentId;

    /**
	 * 諸経費発生日です.
	 */
	@Temporal(TemporalType.DATE)
	public Date overheadDate;

	/**
	 * 勘定科目IDです.
	 */
	public Integer accountItemId;

	/**
	 * 支払方法IDです.
	 */
	public Integer paymentId;

	/**
	 * 支払クレジットカード番号です.
	 */
	public String paymentCreditCardNo;

	/**
	 * 金額です.
	 */
	public Integer expense;

	/**
	 * 領収書番号です.
	 */
	public String receiptNo;

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
	 * 諸経費申請内訳要素その1です.
	 */
	public String contentA;

	/**
	 * 諸経費申請内訳要素その2です.
	 */
	public String contentB;

	/**
	 * 諸経費申請内訳要素その3です.
	 */
	public String contentC;


	/**
	 * 諸経費申請情報です.
	 */
    @ManyToOne
	@JoinColumn(name="overhead_id")
    public Overhead overhead;

	/**
	 * 諸経費申請区分情報です.
	 */
	@OneToOne
	@JoinColumns({@JoinColumn(name="overhead_type_id", referencedColumnName="overhead_type_id")})
	public MOverheadType type;

	/**
	 * 勘定科目情報です.
	 */
	@OneToOne
	@JoinColumns({@JoinColumn(name="account_item_id", referencedColumnName="account_item_id")})
	public MAccountItem account;

	/**
	 * 支払種別情報です.
	 */
	@OneToOne
	@JoinColumns({@JoinColumn(name="payment_id", referencedColumnName="payment_id")})
	public MPayment payment;

	/**
	 * 支払クレジットカード情報です.
	 */
	@OneToOne
	@JoinColumn(name="payment_credit_card_no", referencedColumnName="credit_card_no")
	public MCreditCard paymentCreditCard;

	/**
	 * 設備情報です.
	 */
	@OneToOne(mappedBy="overheadDetail")
    public Equipment equipment;

}