package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;
import java.util.List;

/**
 * ShopMenuDtoクラス
 * 
 */
public class ShopMenuDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** MLunchShopIdプロパティ */
    public Integer mLunchShopId;

    /** MMenuIdプロパティ */
    public Integer mMenuId;

    /** startDateプロパティ */
    public Date startDate;

    /** finishDateプロパティ */
    public Date finishDate;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** menuOrderList関連プロパティ */
    public List<MenuOrderDto> menuOrderList;

    /** MLunch関連プロパティ */
    public MLunchShopDto mLunch;

    /** MMenu関連プロパティ */
    public MMenuDto mMenu;
}