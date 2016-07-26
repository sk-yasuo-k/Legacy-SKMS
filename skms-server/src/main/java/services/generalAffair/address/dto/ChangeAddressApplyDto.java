package services.generalAffair.address.dto;

import java.sql.Date;


/**
 * 社員住所情報変換Dto
 * 
 * 
 * @author t-ito
 *
 */
public class ChangeAddressApplyDto {

	/** 社員IDプロパティ */
	public Integer staffId;
	
	/** 社員名(フル)プロパティ */
	public String fullName;	
	
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
	
	/** 履歴更新回数プロパティ */
	public Integer historyUpdateCount;
	
	/** 申請状態IDプロパティ */
	public Integer addressStatusId;
	
	/** 申請状態名プロパティ */
	public String addressStatusName;
	
	/** 申請動作IDプロパティ */
	public Integer addressActionId;
	
	/** 申請動作名プロパティ */
	public String addressActionName;
	
	/** 更新登録日時プロパティ */
	public Date historyRegistrationTime;
	
	/** 更新登録者IDプロパティ */
	public Integer historyRegistrantId;
	
	/** 更新コメントプロパティ */
	public String comment;
	
	/** 更新登録者氏名プロパティ */
	public String historyRegistrantName;
	
	/** 最終提出日時プロパティ */
	public Date presentTime;	
}
