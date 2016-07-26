package services.lunch.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * MLunchShopDtoクラス
 * 
 */
public class MLunchShopDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** shopIdプロパティ */
    public Integer shopId;

    /** shopNameプロパティ */
    public String shopName;

    /** orderLimitTimeプロパティ */
    public String orderLimitTime;

    /** shopUrlプロパティ */
    public String shopUrl;

    /** sortOrderプロパティ */
    public Integer sortOrder;

    /** postalCode1プロパティ */
    public String postalCode1;

    /** postalCode2プロパティ */
    public String postalCode2;

    /** prefectureCodeプロパティ */
    public String prefectureCode;

	/** 都道府県名プロパティ */
	public String prefectureName;
	
    /** wardプロパティ */
    public String ward;

    /** houseNumberプロパティ */
    public String houseNumber;

    /** shopPhoneNo1プロパティ */
    public String shopPhoneNo1;

    /** shopPhoneNo2プロパティ */
    public String shopPhoneNo2;

    /** shopPhoneNo3プロパティ */
    public String shopPhoneNo3;

    /** registrationTimeプロパティ */
    public Date registrationTime;

    /** registrantIdプロパティ */
    public Integer registrantId;

    /** shopMenuList関連プロパティ */
    public List<ShopMenuDto> shopMenuList;
}