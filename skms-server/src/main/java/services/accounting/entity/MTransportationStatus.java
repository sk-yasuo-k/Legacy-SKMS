package services.accounting.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


/**
 * 交通費申請状況種別マスタ情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class MTransportationStatus implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 交通費申請状況種別IDです。
	 */
	@Id
	@GeneratedValue
	public int transportationStatusId;

	/**
	 * 交通費申請状況種別名です。
	 */
	public String transportationStatusName;

}