package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * 	通勤費申請履歴DTOです。
 *
 * @author yasuo-k
 *
 */
public class CommutationSummaryDto implements Serializable {
	
	static final long serialVersionUID = 1L;
	
	
	/**
	 * 社員IDです。
	 */
	public int staffId;
	
	/**
	 * 社員名です。
	 */
	public String fullName;

	
	/**
	 * 勤務月コードです。
	 */
	public String commutationMonthCode;
	
	/**
	 * 更新回数です。
	 */
	public int updateCount;
	
	/**
	 * 通勤費手続状況IDです。
	 */
	public int commutationStatusId;
	
	/**
	 * 通勤費手続き状態種別名です。
	 */
	public String commutationStatusName;

	/**
	 * 通勤費手続き状態表示色です。
	 */
	public Integer commutationStatusColor;

	/**
	 * 通勤費手続動作IDです。
	 */
	public int commutationActionId;
	
	/**
	 * 通勤費手続き動作種別名です。
	 */
	public String commutationActionName;

	
	/**
	 * 登録日時です。

	 */
	public Date registrationTime;

	/**
	 * 登録者IDです。

	 */
	public int registrantId;

	/**
	 * 登録者氏名です。

	 */
	public String registrantName;

	/**
	 * コメントです。

	 */
	public String comment;

	
	/**
	 * 差引支給金額です。
	 */
	public Integer payment;

	/**
	 * 前月差引支給金額です。
	 */
	public Integer lastPayment;

	/**
	 * 差引支給金額表示色です。
	 */
	public Integer paymentColor;


}
