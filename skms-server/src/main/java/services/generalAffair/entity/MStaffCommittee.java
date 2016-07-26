package services.generalAffair.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import java.sql.Date;

/**
 *委員会所属マスタです。
 * 
 */
@Entity
public class MStaffCommittee implements Serializable {

    private static final long serialVersionUID = 1L;

    /** staffIdプロパティ(社員ID) */
    @Id
    public Integer staffId;
    
    /** updateCountプロパティ(更新回数) */
    @Id
    public Integer updateCount;
    
    /** committeeIdプロパティ(委員会ID) */
    public Integer committeeId;
    
    /** committeePositionIdプロパティ(委員会役職ID) */
    public Integer committeePositionId;
    
    /** applyDateプロパティ(適用開始日) */
    public Date applyDate;
    
    /** cancelDateプロパティ(適用解除日) */
    public Date cancelDate;
    
    /** registrationTimeプロパティ(登録日時) */
    public Timestamp registrationTime;

    /** registrantIdプロパティ(登録者ID)  */
    public Integer registrantId;

    /** MStaff関連プロパティ(社員マスタ) */
    @ManyToOne
    @JoinColumn(name = "staff_id", referencedColumnName = "staff_id")
    public MStaff mStaff;
    
    /** MCommittee関連プロパティ(委員会マスタ) */
    @OneToOne
    @JoinColumn(name = "committee_id", referencedColumnName = "committee_id")
    public MCommittee mCommittee;
    
    /** MCommitteePosition関連プロパティ(委員会役職マスタ)  */
    @OneToOne
    @JoinColumn(name = "committee_position_id", referencedColumnName = "committee_position_id")
    public MCommitteePosition mCommitteePosition;
}