package services.generalAffair.address.entity;

import java.io.Serializable;
import java.sql.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
/**
 * 社員住所情報です。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class VStaffAddressMoveDate implements Serializable {
	
	static final long serialVersionUID = 1L;

    /** staffIdプロパティ */
    public Integer staffId;
    
    /** moveDateプロパティ */
    public Date moveDate;

    /** postalCode1プロパティ */
    @Column(name = "postal_code_1")
    public String postalCode1;

    /** postalCode2プロパティ */
    @Column(name = "postal_code_2")
    public String postalCode2;

    /** prefectureNameプロパティ */
    public String prefectureName;

    /** wardプロパティ */
    public String ward;

    /** houseNumberプロパティ */
    public String houseNumber;	
	
    /** addressStatusIdプロパティ */
    public Integer addressStatusId;

}
