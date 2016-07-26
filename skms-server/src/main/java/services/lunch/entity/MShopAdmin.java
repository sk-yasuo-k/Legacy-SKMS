package services.lunch.entity;

import java.io.Serializable;
import java.util.Date;

import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import services.generalAffair.entity.VCurrentStaffName;


/**
 * MLunchAdminエンティティクラス
 * 
 */
@Entity
@Generated(value = {"S2JDBC-Gen 2.4.39", "org.seasar.extension.jdbc.gen.internal.model.EntityModelFactoryImpl"}, date = "2009/10/29 11:34:56")
public class MShopAdmin implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(precision = 10, nullable = false, unique = true)
    public Integer id;

    /** staffIdプロパティ */
    @Column(precision = 10, nullable = false, unique = false)
    public Integer staffId;
    
	/** 社員名です。*/
	@OneToOne
	@JoinColumn(name="staff_id")
	public VCurrentStaffName vCurrentStaffName;

    /** startDateプロパティ */
    @Column(nullable = false, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date startDate;
    
    /** finishDateプロパティ */
    @Column(nullable = false, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date finishDate;

    /** registrationIdプロパティ */
    @Column(precision = 10, nullable = true, unique = false)
    public Integer registrationId;

    /** registrationDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date registrationDate;

    /** updateDateプロパティ */
    @Column(nullable = true, unique = false)
    @Temporal(TemporalType.TIMESTAMP)
    public Date updateDate;
}