package services.personnelAffair.service;

import java.sql.Timestamp;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.entity.VCurrentStaffName;
import services.lunch.dto.VCurrentStaffNameDto;
import services.lunch.dxo.VCurrentStaffNameDxo;
import services.personnelAffair.skill.entity.MAuthorizedLicence;
import services.personnelAffair.skill.entity.MAuthorizedLicenceCategory;
import services.personnelAffair.skill.entity.MStaffAuthorizedLicence;
import services.personnelAffair.skill.entity.MStaffOtherLocence;

import services.personnelAffair.dxo.StaffAuthorizedLocenceDxo;
import services.personnelAffair.dxo.StaffOtherLocenceDxo;
import services.personnelAffair.dxo.AuthorizedLocenceLabelDxo;

import services.personnelAffair.skill.dto.MAuthorizedLicenceCategoryDto;
import services.personnelAffair.skill.dto.MAuthorizedLicenceDto;
import services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
import services.personnelAffair.skill.dto.StaffOtherLocenceDto;
import services.personnelAffair.skill.dxo.MAuthorizedLicenceCategoryDxo;
import services.personnelAffair.skill.dxo.MAuthorizedLicenceDxo;

/**
 * 取得資格情報サービス
 *
 * @author nobuhiro-s
 *
 */
public class AuthorizedLicenceService 
{
	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;
	
	/**
	 * 社員情報Dxo
	 */
	public VCurrentStaffNameDxo vCurrentStaffNameDxo;
	
	/**
	 * 社員所持認定資格情報Dxo
	 */
	public StaffAuthorizedLocenceDxo staffAuthorizedLocenceDxo;
	
	/**
	 * 社員所持その他資格情報Dxo
	 */
	public StaffOtherLocenceDxo staffOtherLocenceDxo;
	
	/**
	 * 認定資格情報ラベルDxo
	 */
	public AuthorizedLocenceLabelDxo authorizedLocenceLabelDxo;
	
	/**
	 * 認定資格カテゴリーマスタDxo
	 */
	public MAuthorizedLicenceCategoryDxo mAuthorizedLicenceCategoryDxo;	

	/**
	 * 認定資格マスタDxo
	 */
	public MAuthorizedLicenceDxo mAuthorizedLicenceDxo;		
	
	/**
	 * 社員情報を取得します。
	 *
	 * @param
	 * @return 社員情報
	 */
	public List<VCurrentStaffNameDto> getMStaffList()
	{		
		// 社員情報の取得
		List<VCurrentStaffName> src = jdbcManager
			.from(VCurrentStaffName.class)
			.orderBy("staffId asc")
			.getResultList();
		
		// データの変換
		List<VCurrentStaffNameDto> result = vCurrentStaffNameDxo.convertList(src);
		return result;
	}
	
	/**
	 * 社員所持認定資格情報を取得します。
	 *
	 * @param
	 * @return 社員所持認定資格情報
	 */
	public List<StaffAuthorizedLicenceDto> getAuthorizedLicenceList(Integer staffId)
	{		
		// 社員所持認定資格情報の取得
		List<MStaffAuthorizedLicence> src = jdbcManager
			.from(MStaffAuthorizedLicence.class)
			.leftOuterJoin("mAuthorizedLicence")
			.leftOuterJoin("mAuthorizedLicence.mAuthorizedLicenceCategory")
			.where(new SimpleWhere().eq("staffId", staffId))
			.orderBy("mAuthorizedLicence.categoryId asc,licenceId asc")
			.getResultList();
		
		// データの変換
		List<StaffAuthorizedLicenceDto> result = staffAuthorizedLocenceDxo.convert(src);
		return result;
	}
	
	/**
	 * 社員所持その他資格情報を取得します。
	 *
	 * @param
	 * @return 社員所持その他資格情報
	 */
	public List<StaffOtherLocenceDto> getOtherLicenceList(Integer staffId)
	{		
		// その他資格一覧の取得
		List<MStaffOtherLocence> src = jdbcManager
			.from(MStaffOtherLocence.class)
			.where(new SimpleWhere().eq("staffId", staffId))
			.orderBy("staffId asc,sequenceNo asc")
			.getResultList();
		
		// データの変換
		List<StaffOtherLocenceDto> result = staffOtherLocenceDxo.convert(src);
		return result;
	}
	
	/**
	 * 認定資格マスタを取得します。
	 *
	 * @param
	 * @return 認定資格
	 */
	public List<MAuthorizedLicenceDto> getMAuthorizedLicence()
	{		
		// 認定資格ラベルの取得
		List<MAuthorizedLicence> src = jdbcManager
			.from(MAuthorizedLicence.class)
			.getResultList();
		
		// データの変換
		List<MAuthorizedLicenceDto> result = mAuthorizedLicenceDxo.convertDtoList(src);
		return result;
	}

	/**
	 * 認定資格カテゴリーマスタを取得します。
	 *
	 * @param
	 * @return 認定資格カテゴリー
	 */
	public List<MAuthorizedLicenceCategoryDto> getMAuthorizedLicenceCategory()
	{		
		// 認定資格ラベルの取得
		List<MAuthorizedLicenceCategory> src = jdbcManager
			.from(MAuthorizedLicenceCategory.class)
			.getResultList();
		
		// データの変換
		List<MAuthorizedLicenceCategoryDto> result = mAuthorizedLicenceCategoryDxo.convertDtoList(src);
		return result;
	}	

	/**
	 * 検索認定資格情報を取得します。
	 *
	 * @param
	 * @return 社員所持認定資格情報
	 */
	public List<StaffAuthorizedLicenceDto> getSearchLicenceList(String licenceId, String categoryId)
	{
		String condition = "";
		
		if(licenceId == "" && categoryId != ""){
			condition = "mAuthorizedLicence.categoryId = " + categoryId + "";
		}else if(licenceId != "" && categoryId == ""){
			condition = "licenceId = " + licenceId + "";
		}
		
		// 社員所持認定資格情報の取得
		List<MStaffAuthorizedLicence> src = jdbcManager
			.from(MStaffAuthorizedLicence.class)
			.leftOuterJoin("mAuthorizedLicence")
			.where(condition)
			.orderBy("staffId asc,sequenceNo asc")
			.getResultList();
		
		// データの変換
		List<StaffAuthorizedLicenceDto> result = staffAuthorizedLocenceDxo.convert(src);		
		return result;
	}

	/**
	 * 検索その他資格情報を取得します。
	 *
	 * @param
	 * @return 社員所持その他資格情報
	 */
	public List<StaffOtherLocenceDto> getSearchOtherLicenceList()
	{		
		// その他資格一覧の取得
		List<MStaffOtherLocence> src = jdbcManager
			.from(MStaffOtherLocence.class)
			.orderBy("staffId asc,sequenceNo asc")
			.getResultList();
		
		// データの変換
		List<StaffOtherLocenceDto> result = staffOtherLocenceDxo.convert(src);
		return result;
	}	
	
	/**
	 * 社員所持認定資格情報を新規登録します。
	 *
	 * @param  insertAuthorizedLicence 新規認定資格
	 * @return 認定資格(追加)
	 */
	public void insertAuthorizedLicence(StaffAuthorizedLicenceDto staffAuthorizedLicenceDto)
	{	
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());
		
		// Dtoからエンティティへ変換
		MStaffAuthorizedLicence AuthorizedLicence = staffAuthorizedLocenceDxo.convertCreate(staffAuthorizedLicenceDto);
		
		// 資格連番の最大値を検索する
		MStaffAuthorizedLicence src = jdbcManager
			.from(MStaffAuthorizedLicence.class)
			.where("(staffId,sequenceNo) in (select staff_id,max(sequence_no) from m_staff_authorized_licence" +
					" group by staff_id) and staffId = ?", AuthorizedLicence.staffId)
			.getSingleResult();
		
		// 資格連番がnulの場合
		if(src == null)
		{	
			// 資格連番は「1」とする
			AuthorizedLicence.sequenceNo = 1;
		}
		else
		{
			// 資格連番は「最大値+1」とする
			AuthorizedLicence.sequenceNo = src.sequenceNo + 1;
		}
	
		// 登録日時を設定する
		AuthorizedLicence.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.insert(AuthorizedLicence).execute();
	}
	
	/**
	 * 社員所持認定資格情報を変更します。
	 *
	 * @param  updateAuthorizedLicence 変更認定資格
	 * @return 認定資格(変更)
	 */
	public void updateAuthorizedLicence(StaffAuthorizedLicenceDto staffAuthorizedLicenceDto)
	{	
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());
		
		// Dtoからエンティティへ変換
		MStaffAuthorizedLicence AuthorizedLicence = staffAuthorizedLocenceDxo.convertCreate(staffAuthorizedLicenceDto);
	
		// 登録日時を設定する
		AuthorizedLicence.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.update(AuthorizedLicence).execute();
	}
	
	/**
	 * 社員所持認定資格情報を削除します。
	 *
	 * @param  deleteAuthorizedLicence 削除認定資格
	 * @return 認定資格(変更)
	 */
	public void deleteAuthorizedLicence(StaffAuthorizedLicenceDto staffAuthorizedLicenceDto)
	{	
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());
		
		// Dtoからエンティティへ変換
		MStaffAuthorizedLicence AuthorizedLicence = staffAuthorizedLocenceDxo.convertCreate(staffAuthorizedLicenceDto);
	
		// 登録日時を設定する
		AuthorizedLicence.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.delete(AuthorizedLicence).execute();
	}
	
	/**
	 * 社員所持その他資格情報を新規登録します。
	 *
	 * @param  staffOtherLocenceDto 新規その他資格
	 * @return その他資格(追加)
	 */
	public void insertOtherLicence(StaffOtherLocenceDto staffOtherLocenceDto)
	{	
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());
		
		// Dtoからエンティティへ変換
		MStaffOtherLocence OtherLocence = staffOtherLocenceDxo.convertCreate(staffOtherLocenceDto);
		
		// 資格連番の最大値を検索する
		MStaffOtherLocence src = jdbcManager
			.from(MStaffOtherLocence.class)
			.where("(staffId,sequenceNo) in (select staff_id,max(sequence_no) from m_staff_other_locence" +
					" group by staff_id) and staffId = ?", OtherLocence.staffId)
			.getSingleResult();
		
		// 資格連番がnulの場合
		if(src == null)
		{	
			// 資格連番は「1」とする
			OtherLocence.sequenceNo = 1;
		}
		else
		{
			// 資格連番は「最大値+1」とする
			OtherLocence.sequenceNo = src.sequenceNo + 1;
		}
	
		// 登録日時を設定する
		OtherLocence.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.insert(OtherLocence).execute();
	}
	
	/**
	 * 社員所持その他資格情報を変更します。
	 *
	 * @param  updateOtherLicence 変更その他資格
	 * @return その他資格(変更)
	 */
	public void updateOtherLicence(StaffOtherLocenceDto staffOtherLocenceDto)
	{	
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());
		
		// Dtoからエンティティへ変換
		MStaffOtherLocence OtherLocence = staffOtherLocenceDxo.convertCreate(staffOtherLocenceDto);
	
		// 登録日時を設定する
		OtherLocence.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.update(OtherLocence).execute();
	}
	
	/**
	 * 社員所持その他資格情報を削除します。
	 *
	 * @param  deleteOtherLocence 削除その他資格
	 * @return その他資格(削除)
	 */
	public void deleteOtherLocence(StaffOtherLocenceDto staffOtherLocenceDto)
	{	
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());
		
		// Dtoからエンティティへ変換
		MStaffOtherLocence OtherLocence = staffOtherLocenceDxo.convertCreate(staffOtherLocenceDto);
	
		// 登録日時を設定する
		OtherLocence.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.delete(OtherLocence).execute();
	}
}
	
	