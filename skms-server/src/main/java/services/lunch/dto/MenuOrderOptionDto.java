package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;

/**
 * MenuOrderOptionDtoクラス
 * 
 */
public class MenuOrderOptionDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** menuOrderIdプロパティ */
    public Integer menuOrderId;

    /** MOptionIdプロパティ */
    public Integer mOptionId;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** menuOrder関連プロパティ */
    public MenuOrderDto menuOrder;
    
    /** option関連プロパティ */
    public OptionDto option;   
}