package services.accounting.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;


/**
 * 通勤費費申請情報エンティティです。
 *
 * @author yasuo-k
 *
 */
@Entity
public class Commutation implements Serializable {

	static final long serialVersionUID = 1L;

	
	/**
	 * 社員IDです。
	 */
	@Id
	public int staffId;

	/**
	 * 勤務月コードです。
	 */
	@Id
	public String commutationMonthCode;
	
	
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
	 * 合計金額です。
	 */
	public Integer expenseTotal;
	
	/**
	 * 払戻金額です。
	 */
	public Integer repayment;

	/**
	 * 差引支給金額です。
	 */
	public Integer payment;

	/**
	 * 備考です。
	 */
	public String note;

	/**
	 * 担当者備考です。
	 */
	public String noteCharge;

	
	/**
	 * 通勤費詳細リストです。
	 */
	@OneToMany(mappedBy = "commutation")
	public List<CommutationDetail> commutationDetails;
	
	
	/**
	 * 通勤費手続き履歴情報です。
	 */
	@OneToMany(mappedBy = "commutation")
	public List<CommutationHistory> commutationHistories;
	
	
	/**
	 * コンストラクタ
	 */
	public Commutation()
	{
		;
	}
	
	

}
