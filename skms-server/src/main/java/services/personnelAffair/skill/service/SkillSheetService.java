package services.personnelAffair.skill.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.entity.MStaff;
import services.personnelAffair.skill.dto.StaffDto;
import services.personnelAffair.skill.dto.StaffSkillSheetDto;
import services.personnelAffair.skill.dxo.StaffDxo;
import services.personnelAffair.skill.dxo.StaffSkillSheetDxo;
import services.personnelAffair.skill.entity.StaffSkillSheet;
import services.personnelAffair.skill.entity.StaffSkillSheetPhase;
import services.personnelAffair.skill.entity.StaffSkillSheetPosition;

/**
 * スキルシート情報サービス。
 * スキルシート情報を扱うサービスです。
 *
 * @author yoshinori-t
 *
 */
public class SkillSheetService {
	
	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;
	
	/**
	 * 社員一覧変換Dxoです。
	 */
	public StaffDxo staffListDxo;
	
	/**
	 * スキルシート変換Dxoです。
	 */
	public StaffSkillSheetDxo staffSkillSheetDxo;
	
	
	/**
	 * 社員リスト取得処理。
	 * 
	 * @return 社員リスト
	 */
	public List<StaffDto> getStaffList()
	{
		// 検索実行
		List<MStaff> src = jdbcManager
						.from(MStaff.class)													// 社員情報
						.innerJoin("staffName")												// 社員名情報
						.leftOuterJoin("staffWorkHistory",									// 就労状況履歴情報
								new SimpleWhere().eq("staffWorkHistory.workEventId", 1))				// 就労イベントID = [1:入社]
						.leftOuterJoin("staffManagerialPosition",							// 社員経営役職情報
								new SimpleWhere().isNull("staffManagerialPosition.cancelDate", true))	// 適用解除日 != null
						.leftOuterJoin("staffManagerialPosition.managerialPosition")		// 経営役職情報
						.leftOuterJoin("mOccupationalCategory")								// 職種マスタ
						.leftOuterJoin("staffDepartment",									// 社員部署情報
								new SimpleWhere().isNull("staffDepartment.cancelDate", true))			// 適用解除日 != null
						.leftOuterJoin("staffDepartment.mDepartment")						// 部署マスタ
						.leftOuterJoin("mStaffAcademicBackground")							// 社員学歴マスタ
						.leftOuterJoin("mStaffAuthorizedLicence")							// 社員所持認定資格マスタ
						.leftOuterJoin("mStaffAuthorizedLicence.mAuthorizedLicence")		// 認定資格マスタ
						.leftOuterJoin("mStaffOtherLocence")								// 社員所持その他資格マスタ
						.orderBy("staffId" +
								",staffWorkHistory.updateCount desc" +
								",staffDepartment.updateCount desc" +
								",mStaffAcademicBackground.occuredDate desc" +
								",mStaffAuthorizedLicence.licenceId" +
								",mStaffOtherLocence.sequenceNo")
						.getResultList();
		
		// データの変換
		List<StaffDto> result = staffListDxo.convert(src);
		return result;
	}
	
	/**
	 * 社員詳細取得処理。
	 * 
	 * @param  staffId 社員ID
	 * @return 社員詳細
	 */
	public List<StaffDto> getStaffDetail(Integer staffId)
	{
		// 検索実行
		List<MStaff> src = jdbcManager
						.from(MStaff.class)													// 社員情報
						.innerJoin("staffName")												// 社員名情報
						.leftOuterJoin("staffWorkHistory",									// 就労状況履歴情報
								new SimpleWhere().eq("staffWorkHistory.workEventId", 1))				// 就労イベントID = [1:入社]
						.leftOuterJoin("staffManagerialPosition",							// 社員経営役職情報
								new SimpleWhere().isNull("staffManagerialPosition.cancelDate", true))	// 適用解除日 != null
						.leftOuterJoin("staffManagerialPosition.managerialPosition")		// 経営役職情報
						.leftOuterJoin("mOccupationalCategory")								// 職種マスタ
						.leftOuterJoin("staffDepartment",									// 社員部署情報
								new SimpleWhere().isNull("staffDepartment.cancelDate", true))			// 適用解除日 != null
						.leftOuterJoin("staffDepartment.mDepartment")						// 部署マスタ
						.leftOuterJoin("mStaffAcademicBackground")							// 社員学歴マスタ
						.leftOuterJoin("mStaffAuthorizedLicence")							// 社員所持認定資格マスタ
						.leftOuterJoin("mStaffAuthorizedLicence.mAuthorizedLicence")		// 認定資格マスタ
						.leftOuterJoin("mStaffOtherLocence")								// 社員所持その他資格マスタ
						.where(new SimpleWhere()
								.eq("staffId", staffId))
						.orderBy("staffId" +
								",staffWorkHistory.updateCount desc" +
								",staffDepartment.updateCount desc" +
								",mStaffAcademicBackground.occuredDate desc" +
								",mStaffAuthorizedLicence.licenceId" +
								",mStaffOtherLocence.sequenceNo")
						.getResultList();

		// データの変換
		List<StaffDto> result = staffListDxo.convert(src);
		return result;
	}
	
	/**
	 * スキルシートリスト取得処理。
	 * 
	 * @param  staffId 社員ID
	 * @return スキルシートリスト
	 */
	public List<StaffSkillSheetDto> getStaffSkillList(Integer staffId)
	{
		// 検索実行
		List<StaffSkillSheet> src = jdbcManager
						.from(StaffSkillSheet.class)										// 社員スキルシート情報
						.leftOuterJoin("mSkillSheetKind")									// スキルシート用区分マスタ
						.leftOuterJoin("staffSkillSheetPhaseList")							// 社員スキルシート作業フェーズ
						.leftOuterJoin("staffSkillSheetPhaseList.mSkillSheetPhase")			// スキルシート用作業フェーズマスタ
						.leftOuterJoin("staffSkillSheetPositionList")						// 社員スキルシート参加形態
						.leftOuterJoin("staffSkillSheetPositionList.mSkillSheetPosition")	// スキルシート用参加形態マスタ
						.where(new SimpleWhere()
								.eq("staffId", staffId))
						.orderBy("sequenceNo" +
								",staffSkillSheetPhaseList.phaseId" +
								",staffSkillSheetPositionList.positionId")
						.getResultList();
		
		// データの変換
		List<StaffSkillSheetDto> result = staffSkillSheetDxo.convert(src);
		return result;
	}
	
	/**
	 * スキルシート更新処理。
	 * 対象社員のスキルシートを一括削除後に追加します。
	 * 
	 * @param staffId 社員ID
	 * @param sendData スキルシート
	 */
	public void updateSkillSheetList(Integer staffId, List<StaffSkillSheetDto> sendData)
	{
		this.updateSkillSheetList(staffId, sendData, staffId);
	}
	
	/**
	 * スキルシート更新処理。
	 * 対象社員のスキルシートを一括削除後に追加します。
	 * 
	 * @param staffId 社員ID
	 * @param sendData スキルシート
	 * @param registrationStaffId 登録社員ID(省略時は社員IDを設定)
	 */
	public void updateSkillSheetList(Integer staffId, List<StaffSkillSheetDto> sendData, Integer registrationStaffId)
	{
		// スキルシート削除処理
		this.deleteSkillSheet(staffId);
		
		// スキルシート登録処理
		this.insertSkillSheet(registrationStaffId, sendData);
	}
	
	/**
	 * スキルシート削除処理。
	 * 
	 * @param staffId 社員ID
	 */
	private int deleteSkillSheet(Integer staffId)
	{
		int deleteNum = 0;	// 削除件数
		int[] result;		// 削除結果

		//////////////////////////////////////////////////
		// 社員スキルシート参加形態の削除
		//////////////////////////////////////////////////
		// DBからデータの取得
		List<StaffSkillSheetPosition> curSkillSheetListPosition = jdbcManager
						.from(StaffSkillSheetPosition.class)		// 社員スキルシート参加形態
						.where(new SimpleWhere().eq("staffId", staffId))
						.getResultList();
		// 削除の実行
		if ( curSkillSheetListPosition.size() > 0 )
		{
			result = jdbcManager.deleteBatch(curSkillSheetListPosition).execute();
			// 削除件数の更新
			for ( int i = 0; i < result.length; i++ )	deleteNum += result[i];
		}
		
		//////////////////////////////////////////////////
		// 社員スキルシート作業フェーズの削除
		//////////////////////////////////////////////////
		// DBからデータの取得
		List<StaffSkillSheetPhase> curSkillSheetListPhase = jdbcManager
						.from(StaffSkillSheetPhase.class)			// 社員スキルシート作業フェーズ
						.where(new SimpleWhere().eq("staffId", staffId))
						.getResultList();
		// 削除の実行
		if ( curSkillSheetListPhase.size() > 0 )
		{
			result = jdbcManager.deleteBatch(curSkillSheetListPhase).execute();
			// 削除件数の更新
			for ( int i = 0; i < result.length; i++ )	deleteNum += result[i];
		}
		
		//////////////////////////////////////////////////
		// 社員スキルシートの削除
		//////////////////////////////////////////////////
		// DBからデータの取得
		List<StaffSkillSheet> curSkillSheetList = jdbcManager
						.from(StaffSkillSheet.class)				// 社員スキルシート情報
						.where(new SimpleWhere().eq("staffId", staffId))
						.getResultList();
		// 削除の実行
		if ( curSkillSheetList.size() > 0 )
		{
			result = jdbcManager.deleteBatch(curSkillSheetList).execute();
			// 削除件数の更新
			for ( int i = 0; i < result.length; i++ )	deleteNum += result[i];
		}
		
		return deleteNum;
	}
	
	/**
	 * スキルシート登録処理。
	 * 
	 * @param staffId 登録社員ID
	 * @param insertData 登録データ
	 */
	private int insertSkillSheet(Integer staffId, List<StaffSkillSheetDto> insertData)
	{
		int insertNum = 0;	// 追加件数
		int[] result;		// 追加結果
		
		//////////////////////////////////////////////////
		// 引数を元にエンティティを作成
		//////////////////////////////////////////////////
		int seqNo = 1;													// スキルシート連番
		Timestamp curTime = new Timestamp(System.currentTimeMillis());	// 現在時刻
		
		// Dtoからエンティティへ変換
		List<StaffSkillSheet> insertSkillSheetList					= staffSkillSheetDxo.convertCreate(insertData);
		List<StaffSkillSheetPhase> insertSkillSheetListPhase		= new ArrayList<StaffSkillSheetPhase>();
		List<StaffSkillSheetPosition> insertSkillSheetListPosition	= new ArrayList<StaffSkillSheetPosition>();
		
		// スキルシート連番、登録日時、登録者IDの更新
		for ( StaffSkillSheet entity : insertSkillSheetList)
		{
			entity.sequenceNo		= seqNo;	// スキルシート連番
			entity.registrationTime	= curTime;	// 登録日時
			entity.registrantId		= staffId;	// 登録者ID
			
			// 社員スキルシート作業フェーズ
			if ( entity.staffSkillSheetPhaseList != null )
			{
				for ( StaffSkillSheetPhase entityPhase : entity.staffSkillSheetPhaseList)
				{
					entityPhase.sequenceNo			= seqNo;	// スキルシート連番
					entityPhase.registrationTime	= curTime;	// 登録日時
					entityPhase.registrantId		= staffId;	// 登録者ID
				}
				insertSkillSheetListPhase.addAll(entity.staffSkillSheetPhaseList);
			}

			// 社員スキルシート参加形態
			if ( entity.staffSkillSheetPositionList != null )
			{
				for ( StaffSkillSheetPosition entityPosition : entity.staffSkillSheetPositionList)
				{
					entityPosition.sequenceNo		= seqNo;	// スキルシート連番
					entityPosition.registrationTime	= curTime;	// 登録日時
					entityPosition.registrantId		= staffId;	// 登録者ID
				}
				insertSkillSheetListPosition.addAll(entity.staffSkillSheetPositionList);
			}
			
			// スキルシート連番のインクリメント
			seqNo++;
		}
		
		//////////////////////////////////////////////////
		// 社員スキルシートの追加
		//////////////////////////////////////////////////
		if ( insertSkillSheetList.size() > 0 )
		{
			result = jdbcManager.insertBatch(insertSkillSheetList).execute();
			// 追加件数の更新
			for( int i = 0; i < result.length; i++ )	insertNum += result[i];
		}
		
		//////////////////////////////////////////////////
		// 社員スキルシート作業フェーズの追加
		//////////////////////////////////////////////////
		if ( insertSkillSheetListPhase.size() > 0 )
		{
			result = jdbcManager.insertBatch(insertSkillSheetListPhase).execute();
			// 追加件数の更新
			for( int i = 0; i < result.length; i++ )	insertNum += result[i];
		}
		
		//////////////////////////////////////////////////
		// 社員スキルシート参加形態の追加
		//////////////////////////////////////////////////
		if ( insertSkillSheetListPosition.size() > 0 )
		{
			result = jdbcManager.insertBatch(insertSkillSheetListPosition).execute();
			// 追加件数の更新
			for( int i = 0; i < result.length; i++ )	insertNum += result[i];
		}
		
		return insertNum;
	}
}

