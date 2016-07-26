package services.personnelAffair.license.entity;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;

/**
 * 期エンティティクラス
 *  
 */
@Entity
public class MPeriod implements Serializable {

    private static final long serialVersionUID = 1L;
	
    /** Idプロパティ(連番)*/
    @Id
    @Column(precision = 10, nullable = false, unique = true)
    public Integer Id;
    
    /** periodIdプロパティ(期ID)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Integer periodId;
    
    /** periodNameプロパティ(期名)*/
    @Column(precision = 10, nullable = true, unique = false)
    public String periodName;
    
    /** periodStartDateプロパティ(適応開始日)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Date periodStartDate;
    
    /** periodEndDateプロパティ(適応終了日)*/
    @Column(precision = 10, nullable = true, unique = false)
    public Date periodEndDate;
    
	/**
	 * 資格手当取得履歴です。
	 */
	@OneToMany(mappedBy = "mPeriod")
	public List<MPayLicenceHistory> mPayLicenceHistory;
}
