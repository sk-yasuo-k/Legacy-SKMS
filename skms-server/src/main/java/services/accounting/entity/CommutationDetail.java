package services.accounting.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


/**
 * 通勤費詳細情報です。

 *
 * @author yasuo-k
 *
 */
@Entity
public class CommutationDetail implements Serializable {
	
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
	 * 通勤開始日です。

	 */
	@Temporal(TemporalType.DATE)
	public Date commutationStartDate;

	
	/**
	 * 通勤費項目リストです。
	 */
	@OneToMany(mappedBy = "commutationDetail")
	public List<CommutationItem> commutationItems;

	
	
	/**
	 * 通勤費情報です。
	 */
    @ManyToOne
	@JoinColumns({@JoinColumn(name="staff_id", referencedColumnName="staff_id"),
		@JoinColumn(name="commutation_month_code", referencedColumnName="commutation_month_code")})
    public Commutation commutation;
	
	


}
