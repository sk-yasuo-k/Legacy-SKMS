package services.system.entity;

import java.io.Serializable;

import javax.persistence.Entity;
//import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 社員環境設定情報です。

 *
 * @author yasuo-k
 *
 */
@Entity
public class StaffSetting implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 社員IDです。

	 */
	@Id
	//@GeneratedValue
	public int staffId;

	/**
	 * 交通費に関するメール通知の有無です。

	 */
	public boolean sendMailTransportation;

	/**
	 * 勤務管理表に関するメール通知の有無です。

	 */
	public boolean sendMailWorkingHours;

	/**
	 * 時差勤務開始時刻既定値です。
	 */
	public String defaultStaggeredStartTime;

	/**
	 * 勤務開始時刻既定値です。
	 */
	public String defaultStartTime;

	/**
	 * 勤務終了時刻既定値です。
	 */
	public String defaultQuittingTime;

	/**
	 * 時差勤務開始時刻選択肢です。
	 */
	public String staggeredStartTimeChoices;

	/**
	 * 勤務開始時刻選択肢です。
	 */
	public String startTimeChoices;

	/**
	 * 勤務終了時刻選択肢です。
	 */
	public String quittingTimeChoices;

	/**
	 * 全メニューの表示可否です。
	 */
	public boolean allMenu;
	
	/**
	 * マイメニューの表示可否です。
	 */
	public boolean myMenu;

}