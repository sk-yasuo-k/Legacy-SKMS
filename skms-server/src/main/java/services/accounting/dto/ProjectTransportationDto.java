package services.accounting.dto;

import java.io.Serializable;
import java.util.List;


/**
 * プロジェクト別交通費です.
 *
 * @author yasuo-k
 *
 */
public class ProjectTransportationDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * オブジェクトIDです.
	 */
	public Integer objectId;

	/**
	 * オブジェクト種別です。
	 */
	public Integer objectType;

	/**
	 * オブジェクトコードです.
	 */
	public String objectCode;

	/**
	 * オブジェクト名です.
	 */
	public String objectName;


	/**
	 * 集計リストです.
	 */
	public List<ProjectTransportationMonthlyDto> monthyList;
}