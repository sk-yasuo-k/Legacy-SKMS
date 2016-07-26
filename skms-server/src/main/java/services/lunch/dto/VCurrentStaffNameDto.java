package services.lunch.dto;

import java.io.Serializable;

public class VCurrentStaffNameDto implements Serializable{

	static final long serialVersionUID = 1L;
	
	/** 社員IDです。*/
	public int staffId;	
	
	/** 姓です。*/
	public String lastName;

	/** 名です。*/
	public String firstName;

	/** 姓(かな)です。*/
	public String lastNameKana;

	/** 名(かな)です。*/
	public String firstNameKana;
	
	/** 姓名です。*/
	public String fullName;

	/** 姓名(かな)です。*/
	public String fullNameKana;	
	
}
