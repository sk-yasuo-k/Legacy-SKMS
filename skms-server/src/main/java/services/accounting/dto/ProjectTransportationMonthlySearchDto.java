package services.accounting.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 交通費集計検索情報です.
 *
 * @author yasuo-k
 *
 */
public class ProjectTransportationMonthlySearchDto implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 集計期間 開始 です.
	 */
    public Date startDate;

	/**
	 * 集計期間 終了 です.
	 */
    public Date finishDate;

	/**
	 * 集計状態リスト です.
	 */
	public List<Integer> statusList;

	/**
	 * 集計基準日 です.
	 */
    public int baseDateType;

	/**
	 * 集計基準 プロジェクト です.
	 */
    public boolean isProjectMonthly;

    /**
     * (詳細)オブジェクトIDです.
     */
    public String objectId;

	/**
	 * (詳細)オブジェクト種別です。
	 */
	public Integer objectType;

	/**
	 * (詳細)オブジェクトコードです.
	 */
	public String objectCode;

	/**
	 * (詳細)オブジェクト名です.
	 */
	public String objectName;

	/**
	 * (詳細)集計開始日付です.
	 */
	public Date objectStartDate;

	/**
	 * (詳細)集計終了日付です.
	 */
	public Date objectFinishDate;
}