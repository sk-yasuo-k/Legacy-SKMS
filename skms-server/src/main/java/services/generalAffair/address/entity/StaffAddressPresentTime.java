package services.generalAffair.address.entity;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 提出日時エンティティクラス
 * 
 * 
 * @author t-ito
 * 
 */
@Entity(name="(select t.staff_id ,t.address_update_count,t.history_update_count,t.address_action_id,t.registration_time" +
		" from staff_address_history t" +
		" inner join (" +
			" select staff_id,address_update_count,max(history_update_count) as history" +
			" from staff_address_history" +
			" where address_action_id = 2" +
			" group by staff_id,address_update_count" +
		") tei" +
		" on (tei.staff_id,tei.address_update_count,tei.history)" +
		" = (t.staff_id,t.address_update_count,t.history_update_count) )")
public class StaffAddressPresentTime implements Serializable {
	
	private static final long serialVersionUID = 1L;

	/** staffIdプロパティ */
	@Id
	@Column(precision = 10, nullable = false, unique = false)
	public Integer staffId;
	
    /** addressUpdateCountプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer addressUpdateCount;
    
    /** historyUpdateCountプロパティ */
    @Id
    @Column(precision = 10, nullable = false, unique = false)
    public Integer historyUpdateCount;
	
    /** addressActionIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer addressActionId;
    
    /** registrationTimeプロパティ */
    @Column(name="registration_time", nullable = true, unique = false)
    public Timestamp presentTime;
}
