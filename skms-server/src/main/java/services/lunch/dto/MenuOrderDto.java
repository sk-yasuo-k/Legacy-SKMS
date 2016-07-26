package services.lunch.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import services.generalAffair.dto.MStaffDto;

/**
 * MenuOrderDtoクラス
 * 
 */
public class MenuOrderDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** staffIdプロパティ */
    public Integer staffId;

    /** orderDateプロパティ */
    public Date orderDate;

    /** shopMenuIdプロパティ */
    public Integer shopMenuId;
    
    /** registrationIdプロパティ */
    public Integer registrationId;

    /** numberプロパティ */
    public Integer number;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** cancelプロパティ */
    public Boolean cancel;

    /** MStaff関連プロパティ */
    public MStaffDto mStaff;
    
	/** 社員名です。*/
	public VCurrentStaffNameDto vCurrentStaffName;

    /** shopMenu関連プロパティ */
    public ShopMenuDto shopMenu;

    /** menuOrderOptionList関連プロパティ */
    public List<MenuOrderOptionDto> menuOrderOptionList;
}