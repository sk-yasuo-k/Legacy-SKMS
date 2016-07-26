package services.accounting.entity;


import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;

/**
 * 通勤費詳細情報です。

 *
 * @author yasuo-k
 *
 */
@Entity

public class CommutationItem implements Serializable {
	
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
	 * 通勤費詳細連番です。

	 */
	@Id
	public int detailNo;
	
	/**
	 * 通勤費項目連番です。

	 */
	@Id
	public int itemNo;

	/**
	 * 目的地です。
	 */
	public String destination;

	/**
	 * 交通機関です。
	 */
	public String facilityName;
	
	/**
	 * 交通機関(会社名)です。
	 */
	public String facilityCmpName;

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
	 * 金額です。
	 */
	public Integer expense;



	/**
	 * 通勤費詳細情報です。
	 */
    @ManyToOne
	@JoinColumns({@JoinColumn(name="staff_id", referencedColumnName="staff_id"),
		@JoinColumn(name="commutation_month_code", referencedColumnName="commutation_month_code"),
		@JoinColumn(name="detail_no", referencedColumnName="detail_no")})
    public CommutationDetail commutationDetail;


}
