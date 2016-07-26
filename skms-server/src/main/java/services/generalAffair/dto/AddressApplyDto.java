package services.generalAffair.dto;

import java.sql.Date;


/**
 * 社員住所情報Dto
 * 
 * 
 * @author n-sumi
 *
 */
public class AddressApplyDto {

	/** 社員IDプロパティ */
	public Integer staffId;
	
	/** 更新回数プロパティ */
	public Integer updateCount;
	
	/** 引越日プロパティ */
	public Date moveDate;
	
	/** 郵便番号1プロパティ */
	public String postalCode1;
	
	/** 郵便番号2プロパティ */
	public String postalCode2;	
	
	/** 都道府県コードプロパティ */
	public Integer prefectureCode;
	
	/** 都道府県名プロパティ */
	public String prefectureName;
	
	/** 市区町村番地プロパティ */
	public String ward;
	
	/** 市区町村番地(カナ)プロパティ */
	public String wardKana;
	
	/** ビルプロパティ */
	public String houseNumber;
	
	/** ビル(カナ)プロパティ */
	public String houseNumberKana;
	
	/** 自宅電話番号1プロパティ */
	public String homePhoneNo1;
	
	/** 自宅電話番号2プロパティ */
	public String homePhoneNo2;
	
	/** 自宅電話番号3プロパティ */
	public String homePhoneNo3;
	
	/** 世帯主フラグプロパティ */
	public Boolean householderFlag;
	
	/** 表札名プロパティ */
	public String nameplate;
	
	/** 連絡のとりやすい社員プロパティ */
	public String associateStaff;
	
	/** 登録日時プロパティ */
	public Date registrationTime;
	
	/** 登録者IDプロパティ */
	public Integer registrantId;

}
