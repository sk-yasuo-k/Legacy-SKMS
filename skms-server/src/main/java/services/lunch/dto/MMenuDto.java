package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;
import java.util.List;

import javax.persistence.Lob;

/**
 * MMenuDtoクラス
 * 
 */
public class MMenuDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** menuCodeプロパティ */
    public String menuCode;

    /** menuNameプロパティ */
    public String menuName;

    /** priceプロパティ */
    public Integer price;

    /** MOptionSetIdプロパティ */
    public Integer mOptionSetId;

    /** menuCategoryIdプロパティ */
    public Integer menuCategoryId;

    /** commentプロパティ */
    public String comment;

    /** photoプロパティ */
	@Lob
    public byte[] photo;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** MOptionSet関連プロパティ */
    public MOptionSetDto mOptionSet;

    /** menuCategory関連プロパティ */
    public MenuCategoryDto menuCategory;

    /** shopMenuList関連プロパティ */
    public List<ShopMenuDto> shopMenuList;
}