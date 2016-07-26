package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;
import java.util.List;

/**
 * MOptionSetDtoクラス
 * 
 */
public class MOptionSetDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** optionNameプロパティ */
    public String optionName;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** MMenuList関連プロパティ */
    public List<MMenuDto> mMenuList;

    /** optionSetList関連プロパティ */
    public List<OptionSetDto> optionSetList;
}