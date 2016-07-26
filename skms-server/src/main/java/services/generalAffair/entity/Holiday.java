package services.generalAffair.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 休日一定義です。
 * La!coodaのHolidayテーブルに対応します。
 * 
 * @author yasuo-k
 * 
 */
@Entity
public class Holiday implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 休日日付です。
	 */
	@Id
	@Temporal(TemporalType.DATE)
	public Date hdate;

	/**
	 * 休日名称です。
	 */
	public String hname;

	/**
	 * オリジナルフラグです。
	 */
	public Boolean flgorgin;

}