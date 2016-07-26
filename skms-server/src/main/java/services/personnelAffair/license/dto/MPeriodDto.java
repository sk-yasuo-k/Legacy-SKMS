package services.personnelAffair.license.dto;

import java.sql.Date;

/**
 * 期マスタDtです。
 *
 * @author n-sumi
 *
 */
public class MPeriodDto {

    /** Idプロパティ(連番)*/
    public Integer Id;
    
    /** periodIdプロパティ(期ID)*/
    public Integer periodId;
    
    /** periodNameプロパティ(期名)*/
    public String periodName;
    
    /** periodStartDateプロパティ(適応開始日)*/
    public Date periodStartDate;
    
    /** periodEndDateプロパティ(適応終了日)*/
    public Date periodEndDate;
}
