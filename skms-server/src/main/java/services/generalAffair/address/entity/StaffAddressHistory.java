package services.generalAffair.address.entity;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

import services.generalAffair.entity.VCurrentStaffName;

/**
 * 住所変更申請履歴エンティティクラス
 * 
 * 
 * @author t-ito
 * 
 */
@Entity
public class StaffAddressHistory implements Serializable {
	
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
	
    /** addressStatusIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer addressStatusId;

    /** addressActionIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer addressActionId;
    
    /** registrationTimeプロパティ */
    @Column(nullable = true, unique = false)
    public Timestamp registrationTime;

    /** registrantIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrantId;

    /** commentプロパティ */
    @Column(length = 1024, nullable = true, unique = false)
    public String comment;
    
    /** registrantNameプロパティ */
    @Column(length = 31, nullable = true, unique = false)
    public String registrantName;
    
    /** addressStatusId関連プロパティ */
    @OneToOne
    @JoinColumn(name = "address_status_id", referencedColumnName = "staff_address_status_id")
    public MStaffAddressStatus mStaffAddressStatus;
    
    /** addressActionId関連プロパティ */
    @OneToOne
    @JoinColumn(name = "address_action_id", referencedColumnName = "staff_address_action_id")
    public MStaffAddressAction mStaffAddressAction;
    
    /** mStaffAddress関連プロパティ */
    @ManyToOne
    @JoinColumns( {
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id"),
    @JoinColumn(name = "address_update_count", referencedColumnName = "update_count") })
    public  MStaffAddress mStaffAddress;
    
    /** presentTime関連プロパティ */
    @ManyToOne
    @JoinColumns( {
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id"),
    @JoinColumn(name = "address_update_count", referencedColumnName = "address_update_count")})
    public  StaffAddressPresentTime staffAddressPresentTime;

    /** staffId関連プロパティ */
    @ManyToOne
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    public VCurrentStaffName vCurrentStaffName;    
    
}
