package services.personnelAffair.profile.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * セミナー受講履歴Dtoです。
 *
 * @author t-ito
 *
 */
public class SeminarParticipantDto implements Serializable {

	static final long serialVersionUID = 1L;
	
	/**
	 * 社員IDです。
	 */
	public Integer staffId;

	/**
	 * セミナーIDです。
	 */
	public Integer seminarId;	

	/**
	 * セミナータイトルです。
	 */
	public String seminarTitle;	

	/**
	 * 開始日時です。
	 */
	public Date startTime;
	
	/**
	 * 登録日時です。
	 */
	public Date registrationTime;
	
	/**
	 * 登録者IDです。
	 */
	public Integer registrantId;	
}
