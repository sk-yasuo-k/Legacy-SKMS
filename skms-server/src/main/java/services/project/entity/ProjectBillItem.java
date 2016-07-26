package services.project.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;


/**
 * プロジェクト請求情報です。
 *
 * @author yasuo-k
 *
 */
@Entity
public class ProjectBillItem implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * プロジェクトIDです。
	 */
	@Id
	public int projectId;

	/**
	 * 請求連番です。
	 */
	@Id
	public int billNo;

	/**
	 * 請求項目連番です。
	 */
	@Id
	public int itemNo;

	/**
	 * 注文Noです。
	 */
	public String orderNo;

	/**
	 * 件名です。
	 */
	public String title;

	/**
	 * 請求額です。
	 */
	public Long billAmount;

	/**
	 * 課税対象フラグです。
	 */
	public boolean taxFlg;


	/**
	 * プロジェクト請求情報です。
	 */
    @ManyToOne
	@JoinColumns({@JoinColumn(name="project_id", referencedColumnName="project_id"),
				  @JoinColumn(name="bill_no", referencedColumnName="bill_no")})
    public ProjectBill projectBill;
}