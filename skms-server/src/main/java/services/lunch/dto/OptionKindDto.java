package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;

/**
 * OptionKindDtoクラス
 * 
 */
public class OptionKindDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** MOptionKindIdプロパティ */
    public Integer mOptionKindId;

    /** optionIdプロパティ */
    public Integer optionId;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** MOptionKind関連プロパティ */
    public MOptionKindDto mOptionKind;

    /** option関連プロパティ */
    public OptionDto option;
    
    /** optionNameプロパティ */
    public String optionName;
}