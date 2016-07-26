package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;
import java.util.List;

/**
 * MenuCategoryDtoクラス
 * 
 */
public class MenuCategoryDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** categoryCodeプロパティ */
    public String categoryCode;

    /** categoryNameプロパティ */
    public String categoryName;

    /** categoryDisplayNameプロパティ */
    public String categoryDisplayName;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updateDateプロパティ */
    public Date updateDate;

    /** MMenuList関連プロパティ */
    public List<MMenuDto> mMenuList;
}