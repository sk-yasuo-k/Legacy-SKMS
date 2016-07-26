package services.lunch.dto;

import java.util.Date;
import java.io.Serializable;
import java.util.List;

/**
 * OptionDtoクラス
 * 
 */
public class OptionDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** idプロパティ */
    public Integer id;

    /** codeプロパティ */
    public String optionCode;

    /** optionNameプロパティ */
    public String optionName;

    /** optionDisplayNameプロパティ */
    public String optionDisplayName;

    /** priceプロパティ */
    public Integer price;

    /** registrationIdプロパティ */
    public Integer registrationId;

    /** registrationDateプロパティ */
    public Date registrationDate;

    /** updatedDateプロパティ */
    public Date updatedDate;

    /** optionKindList関連プロパティ */
    public List<OptionKindDto> optionKindList;
    
    /** menuOrderOptionプロパティ */
    public MenuOrderOptionDto menuOrderOption;   
}