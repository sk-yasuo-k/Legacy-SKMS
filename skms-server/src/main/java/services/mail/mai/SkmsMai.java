package services.mail.mai;

import services.mail.mai.MailTransportationDto;

public interface SkmsMai {
	/**
	 * 交通費申請時メール通知
	 */
    void applyTransportation(MailTransportationDto dto);

	/**
	 * 交通費申請取り下げ時メール通知
	 */
    void applyWithdrawTransportation(MailTransportationDto dto);

	/**
	 * 交通費承認時メール通知
	 */
    void approvalTransportation(MailTransportationDto dto);

	/**
	 * 交通費承認取り消し時メール通知
	 */
    void approvalCancelTransportation(MailTransportationDto dto);

	/**
	 * 交通費差し戻し時メール通知
	 */
    void approvalWithdrawTransportation(MailTransportationDto dto);

	/**
	 * 交通費支払時メール通知
	 */
    void paymentTransportation(MailTransportationDto dto);

	/**
	 * 交通費支払取り消し時メール通知
	 */
    void paymentCancelTransportation(MailTransportationDto dto);

	/**
	 * 交通費受領時メール通知
	 */
    void acceptTransportation(MailTransportationDto dto);

	/**
	 * 交通費受領取り消し時メール通知
	 */
    void acceptCancelTransportation(MailTransportationDto dto);

	/**
	 * 勤務管理表提出時メール通知
	 */
    void submitWorkingHours(MailWorkingHoursDto dto);

	/**
	 * 勤務管理表提出取り消し時メール通知
	 */
    void submitCancelWorkingHours(MailWorkingHoursDto dto);

	/**
	 * 勤務管理表承認時メール通知
	 */
    void approvalWorkingHours(MailWorkingHoursDto dto);

	/**
	 * 勤務管理表承認取り消し時メール通知
	 */
    void approvalCancelWorkingHours(MailWorkingHoursDto dto);

	/**
	 * 勤務管理表差し戻し時メール通知
	 */
    void approvalRejectWorkingHours(MailWorkingHoursDto dto);

	/**
	 * 通勤費申請時メール通知
	 */
    void applyCommutation(MailCommutationDto dto);

	/**
	 * 通勤費申請取り消し時メール通知
	 */
    void applyCancelCommutation(MailCommutationDto dto);

	/**
	 * 通勤費承認時メール通知
	 */
    void approvalCommutation(MailCommutationDto dto);

	/**
	 * 通勤費承認取り消し時メール通知
	 */
    void approvalCancelCommutation(MailCommutationDto dto);

	/**
	 * 通勤費差し戻し時メール通知
	 */
    void approvalRejectCommutation(MailCommutationDto dto);


	/**
	 * 諸経費申請時メール通知
	 */
    void applyOverhead(MailOverheadDto dto);

	/**
	 * 諸経費申請取り下げ時メール通知
	 */
    void applyWithdrawOverhead(MailOverheadDto dto);

	/**
	 * 諸経費承認時メール通知
	 */
    void approvalOverhead(MailOverheadDto dto);

	/**
	 * 諸経費承認取り消し時メール通知
	 */
    void approvalCancelOverhead(MailOverheadDto dto);

	/**
	 * 諸経費差し戻し時メール通知
	 */
    void approvalWithdrawOverhead(MailOverheadDto dto);

	/**
	 * 諸経費支払時メール通知
	 */
    void paymentOverhead(MailOverheadDto dto);

	/**
	 * 諸経費支払取り消し時メール通知
	 */
    void paymentCancelOverhead(MailOverheadDto dto);

	/**
	 * 諸経費受領時メール通知
	 */
    void acceptOverhead(MailOverheadDto dto);

	/**
	 * 諸経費受領取り消し時メール通知
	 */
    void acceptCancelOverhead(MailOverheadDto dto);

}
