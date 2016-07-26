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


/**
 * 	諸経費申請履歴エンティティです.
 *
 * @author yasuo-k
 */
@Entity
public class OverheadHistory implements Serializable {

	static final long serialVersionUID = 1L;


	/**
	 * 諸経費IDです.
	 */
	@Id
	public int overheadId;

	/**
	 * 更新回数です.
	 */
	@Id
	public int updateCount;

	/**
	 * 諸経費手続状況IDです.
	 */
	public int overheadStatusId;

//	/**
//	 * 諸経費費手続動作IDです.
//	 */
//	public int overheadActionId;
//
	/**
	 * コメントです.
	 */
	public String comment;

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
	 * 諸経費費情報です.
	 */
    @ManyToOne
	@JoinColumns({@JoinColumn(name="overhead_id", referencedColumnName="overhead_id")})
    public Overhead overhead;

	/**
	 * 諸経費手続状況種別マスタ情報です.
	 */
	@OneToOne
	@JoinColumn(name="overhead_status_id")
	public MOverheadStatus overheadStatus;

//	/**
//	 * 諸経費手続動作種別マスタ情報です.
//	 */
//	@OneToOne
//	@JoinColumn(name="overhead_action_id")
//	public MOverheadAction overheadAction;

}
