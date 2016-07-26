package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;
import java.util.List;

/**
 * MOptionKindDtoクラス
 * 
 */
public class MOptionKindDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** optionKindNameプロパティ */
    public String optionKindName;

    /** optionKindDisplayNameプロパティ */
    public String optionKindDisplayName;
    
    /** optionKindCodeプロパティ */
    public String optionKindCode;   

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** exclusiveOptionList関連プロパティ */
    public List<ExclusiveOptionDto> exclusiveOptionList;

    /** exclusiveOptionList2関連プロパティ */
    public List<ExclusiveOptionDto> exclusiveOptionList2;

    /** optionKindList関連プロパティ */
    public List<OptionKindDto> optionKindList;

    /** optionSetList関連プロパティ */
    public List<OptionSetDto> optionSetList;
}