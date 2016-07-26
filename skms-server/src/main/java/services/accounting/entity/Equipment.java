package services.accounting.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import services.generalAffair.entity.MStaff;
import services.project.entity.Project;


/**
 * 設備情報です.
 *
 * @author yasuo-k
 *
 */
@Entity
public class Equipment implements Serializable {

	static final long serialVersionUID = 1L;

	/**
	 * 設備IDです.
	 */
	@Id
	public int equipmentId;

	/**
	 * 管理番号です.
	 */
	public String managementNo;

	/**
	 * 設備種別IDです.
	 */
	public int equipmentKindId;

	/**
	 * メーカです.
	 */
	public String maker;

	/**
	 * 設備名です.
	 */
	public String equipmentName;

	/**
	 * 型番です.
	 */
	public String equipmentNo;

	/**
	 * 製造番号です.
	 */
	public String equipmentSerialNo;

	/**
	 * 使用目的です.
	 */
	public String pcUse;

	/**
	 * 管理社員IDです.
	 */
	public Integer managementStaffId;

	/**
	 * 管理プロジェクトIDです.
	 */
	public Integer managementProjectId;

	/**
	 * 購入日付です.
	 */
	@Temporal(TemporalType.DATE)
	@Column(insertable=true, updatable=true)
	public Date purchaseDate;

	/**
	 * 購入店です.
	 */
	public String purchaseShop;

	/**
	 * 保証期限です.
	 */
	@Temporal(TemporalType.DATE)
	@Column(insertable=true, updatable=true)
	public Date guaranteedDate;

	/**
	 * PC種別IDです.
	 */
	public Integer pcKindId;

	/**
	 * モニタ使用です.
	 */
	public String monitorUse;


	/**
	 * タイトルです.
	 */
	public String title;

	/**
	 * 著者名です.
	 */
	public String author;

	/**
	 * 出版年です.
	 */
	public Integer publicationYear;

	/**
	 * 出版社です.
	 */
	public String publisher;

	/**
	 * ジャンルIDです.
	 */
	public Integer janreId;

	/**
	 * ライセンスです.
	 */
	public String license;

	/**
	 * 動作OSです.
	 */
	public String operationOs;


	/**
	 * 設置場所、所蔵場所です.
	 */
	public String location;

	/**
	 * 備考です.
	 */
	public String note;

	/**
	 * 諸経費IDです.
	 */
	public Integer overheadId;

	/**
	 * 諸経費明細連番です.
	 */
	public Integer overheadNo;

	/**
	 * 登録日時です.
	 */
	@Temporal(TemporalType.TIMESTAMP)
	@Column(insertable=false, updatable=false)
	public Date registrationTime;

	/**
	 * 登録者IDです.
	 */
	public int registrantId;

	/**
	 * 登録バージョンです.
	 */
	@Version
	public int registrationVer;


	/**
	 * プロジェクト情報です.
	 */
	@OneToOne
	@JoinColumn(name="management_project_id", referencedColumnName="project_id")
	public Project projectE;

	/**
	 * 社員情報です.
	 */
    @OneToOne
	@JoinColumn(name="management_staff_id", referencedColumnName="staff_id")
	public MStaff staff;

	/**
	 * 装置種別情報です.
	 */
    @OneToOne
	@JoinColumn(name="equipment_kind_id", referencedColumnName="equipment_kind_id")
	public MEquipmentKind equipmentKind;

	/**
	 * PC種別情報です.
	 */
    @OneToOne
	@JoinColumn(name="pc_kind_id", referencedColumnName="pc_kind_id")
	public MPcKind pcKind;

    /**
     * 諸経費明細情報です.
     */
    @OneToOne
    @JoinColumns({@JoinColumn(name="overhead_id", referencedColumnName="overhead_id"),
    			  @JoinColumn(name="overhead_no", referencedColumnName="overhead_no")})
    public OverheadDetail overheadDetail;

}
