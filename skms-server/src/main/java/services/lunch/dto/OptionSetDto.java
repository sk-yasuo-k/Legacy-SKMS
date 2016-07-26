package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;

/**
 * OptionSetDtoクラス
 * 
 */
public class OptionSetDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** MOptionSetIdプロパティ */
    public Integer mOptionSetId;

    /** MOptionKindIdプロパティ */
    public Integer mOptionKindId;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** MOptionKind関連プロパティ */
    public MOptionKindDto mOptionKind;

    /** MOptionSet関連プロパティ */
    public MOptionSetDto mOptionSet;
}