package services.lunch.dto;


import java.util.Date;
import java.io.Serializable;

/**
 * MLunchAdminエンティティクラス
 * 
 */
public class MShopAdminDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** staffIdプロパティ */
    public Integer staffId;
    
	/** 社員名です。*/
	public String fullName;

    /** startDateプロパティ */
    public Date startDate;
    
    /** finishDateプロパティ */
    public Date finishDate;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updateDateプロパティ */
    public Date updateDate;
}