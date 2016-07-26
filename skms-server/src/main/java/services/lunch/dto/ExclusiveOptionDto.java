package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;

/**
 * ExclusiveOptionDto 排他オプションDto
 * 
 */
public class ExclusiveOptionDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** MOptionKindIdプロパティ */
    public Integer mOptionKindId;

    /** exclusiceMOptionKindIdプロパティ */
    public Integer exclusiceMOptionKindId;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** MOptionKind関連プロパティ */
    public MOptionKindDto mOptionKind;

    /** exclusiceMOptionKind関連プロパティ */
    public MOptionKindDto exclusiceMOptionKind;
    
    /** mOptionKindNameプロパティ */
    public String mOptionKindName;    
}