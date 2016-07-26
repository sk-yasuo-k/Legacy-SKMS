package services.generalAffair.service;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.entity.MStaffCommittee;
import services.generalAffair.entity.MCommittee;
import services.generalAffair.entity.MStaff;

import services.generalAffair.dxo.MCommitteeDxo;
import services.generalAffair.dxo.MStaffCommitteeDxo;
import services.generalAffair.dxo.MStaffCommitteeLabelDxo;

import services.generalAffair.dto.MCommitteeDto;
import services.generalAffair.dto.MStaffCommitteeDto;

/**
 * 委員会履歴サービスです。
 *
 * @author nobuhiro-s
 *
 */
public class CommitteeService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;
	
	/**
	 * 社員一覧です。
	 */
	public MStaffCommitteeDxo MStaffCommitteeDxo;
	
	/**
	 * 委員会概要です。
	 */
	public MCommitteeDxo MCommitteeDxo;

	/**
	 * 社員一覧(委員会未登録)です。
	 */
	public MStaffCommitteeLabelDxo MStaffCommitteeLabelDxo;
	
	/**
	 * 委員会所属一覧を取得します。
	 *
	 * @param  committee_Id 委員会ID
	 * @return 委員会所属一覧
	 */
	public List<MStaffCommitteeDto> getCommitteeList(Integer committeeId)
	{		
		// 委員会所属の取得
		List<MStaffCommittee> committee = jdbcManager
			.from(MStaffCommittee.class)
			.leftOuterJoin("mCommitteePosition")
			.leftOuterJoin("mStaff")
			.leftOuterJoin("mStaff.staffName")
			.innerJoin("mCommittee", new SimpleWhere().eq("committeeId", committeeId))
			.where("(staffId,updateCount) in ( select staff_id, max(update_count) from m_staff_committee where cancel_date is null group by staff_id)")
			.orderBy("mCommitteePosition.committeePositionId asc")
			.getResultList();
		
		// データの変換
		List<MStaffCommitteeDto> result = MStaffCommitteeDxo.convert(committee);
		return result;
	}
	
	/**
	 * 委員会所属履歴を取得します。
	 *
	 * @param  committee_Id 委員会ID
	 * @return 委員会所属履歴
	 */
	public List<MStaffCommitteeDto> getCommitteeListLog(Integer committeeId)
	{		
		// 社員委員会所属履歴の取得
		List<MStaffCommittee> committee = jdbcManager
			.from(MStaffCommittee.class)
			.leftOuterJoin("mCommitteePosition")
			.leftOuterJoin("mStaff")
			.leftOuterJoin("mStaff.staffName")
			.innerJoin("mCommittee", new SimpleWhere().eq("committeeId", committeeId))
			.orderBy("mStaff.staffId asc,updateCount asc")
			.getResultList();
		
		// データの変換
		List<MStaffCommitteeDto> result = MStaffCommitteeDxo.convert(committee);
		return result;
	}
	
	/**
	 * 委員会概要を取得します。
	 *
	 * @param  committee_Id 委員会ID
	 * @return 委員会概要
	 */
	public List<MCommitteeDto> getMCommitteeList(Integer committeeId)
	{		
		// 委員会概要の取得
		List<MCommittee> committee = jdbcManager
			.from(MCommittee.class)
			.where(new SimpleWhere()
			.eq("committeeId", committeeId))
			.getResultList();
		
		// データの変換
		List<MCommitteeDto> result = MCommitteeDxo.convert(committee);
		return result;
	}
	
	/**
	 * 社員一覧(委員会未登録)を取得します。
	 *
	 *
	 * @return 社員一覧(委員会未登録)
	 */
	public List<MStaffCommitteeDto> getCommitteeLabel()
	{		
		// 社員一覧(委員会未登録)の取得
		List<MStaff> committee = jdbcManager
			.from(MStaff.class)
			.leftOuterJoin("staffName")
			.leftOuterJoin("mStaffCommittee")
			.where("(mStaffCommittee.committeeId is null) or (staffId in " +
					"(select staff_id from m_staff_committee where (staff_Id,update_count)" +
					"in (select staff_Id,max(update_count) from m_staff_committee where not staff_Id" +
					" in ( select staff_Id from m_staff_committee where cancel_date is null)" +
					"group by staff_id)))")
			.orderBy("staffId asc")
			.getResultList();
		
		// データの変換
		List<MStaffCommitteeDto> result = MStaffCommitteeLabelDxo.convert(committee);
		return result;
	}
	
	/**
	 * 社員一覧(経営役職)を取得します。
	 *
	 * @param  inStaffId 社員ID(ログイン)
	 * @return 社員一覧(経営役職)
	 */
	public List<MStaffCommitteeDto> getMPositionList(Integer inStaffId)
	{		
		// 社員一覧(経営役職)の取得
		List<MStaff> committee = jdbcManager
			.from(MStaff.class)
			.leftOuterJoin("staffManagerialPosition", new SimpleWhere().eq("staffId", inStaffId))
			.leftOuterJoin("staffDepartmentHead", new SimpleWhere().eq("staffId", inStaffId))
			.where("((staffId,staffDepartmentHead.updateCount) in " +
					"(select staff_id,max(update_count) from m_staff_department_head " +
					"where cancel_date is null and department_id = 2 group by staff_id)) or" +
					"((staffId,staffManagerialPosition.updateCount) in " +
					"(select staff_id,max(update_count) from m_staff_managerial_position " +
					"where cancel_date is null group by staff_id))")
			.orderBy("staffId asc")
			.getResultList();
		
		// データの変換
		List<MStaffCommitteeDto> result = MStaffCommitteeLabelDxo.convert(committee);
		return result;
	}
	/**
	 * 委員会概要を更新します。
	 *
	 * @param  committeeNoteList 委員会リスト
	 * @return 委員会概要(更新)
	 */
	public void insertMCommitteeList(MCommitteeDto committeeNoteList)
	{
		
		// Dtoからエンティティへ変換
		MCommittee CommitteeNoteList = MCommitteeDxo.convertCreate(committeeNoteList);
		
		// entityからDB対して、updateを行う
		MCommittee entity = CommitteeNoteList;
		jdbcManager.update(entity).execute();
	}
	
	/**
	 * 入会を追加します。insertLinkJoinHeadCommittee
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 委員会所属(追加)
	 */
	public void insertJoinCommittee(MStaffCommitteeDto committeeList)
	{	
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// 入会対象の現在のupdate_Countの最大値(MAX)を検索する
		MStaffCommittee committee = jdbcManager
			.from(MStaffCommittee.class)
			.where("(staffId,updateCount) in (select staff_id,max(update_count) from m_staff_committee group by staff_id) and " +
				"staffId = ?", CommitteeList.staffId)
			.getSingleResult();
		
		// 委員会役職に初期値nullを入れる
		CommitteeList.committeePositionId = null;
		
		// 適用開始日に日付(現在)を入れる
		//CommitteeList.applyDate = nowDate2;
		
		//追加 @auther maruta
		if(CommitteeList.applyDate == null)
		{
			CommitteeList.applyDate = nowDate2;
		}
		
		// 初めて委員会に入る場合(nullの場合)
		if(committee == null)
		{
			// 更新回数は「1」とする
			CommitteeList.updateCount = 1;
		}
		else 
		{
			// 更新回数は「現在の値+1」とする
			CommitteeList.updateCount = committee.updateCount + 1;
		}
		
		// 登録日時
		CommitteeList.registrationTime = new Timestamp(System.currentTimeMillis());
		
		// entityからDB対して、insertを行う
		MStaffCommittee entity = CommitteeList;
		jdbcManager.insert(entity).execute();
	}
	
	/**
	 * 退会を更新します。
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 委員会所属(更新)
	 */
	public void updateLinkRetireCommittee(MStaffCommitteeDto committeeList)
	{	
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// 入会者の現在のcancelDateを検索する
		MStaffCommittee withdraw  = jdbcManager
			.from(MStaffCommittee.class)
			.where("(cancel_date is null) and staffId = ?", CommitteeList.staffId)
			.getSingleResult();
		
		// 委員会役職に初期値nullを入れる
		CommitteeList.committeePositionId = null;
		
		// 更新回数は「適用終了日」がnullものとする
		CommitteeList.updateCount = withdraw.updateCount;
		
		// 適用開始日に、更新回数が最大に該当するものを入れる
		CommitteeList.applyDate = withdraw.applyDate;
		
		// 適用終了日をサーバから取得
		//CommitteeList.cancelDate = nowDate2;
		
		//追加 @auther maruta
		if(CommitteeList.cancelDate == null)
		{
			CommitteeList.cancelDate = nowDate2;
		}
		//
		// 登録日時
		CommitteeList.registrationTime = new Timestamp(System.currentTimeMillis());
		
		// entityからDB対して、updateを行う
		MStaffCommittee entity = CommitteeList;
		jdbcManager.update(entity).execute();
	}
	
	/**
	 * 委員長に任命します。
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 委員会所属(追加)
	 */
	public void insertLinkJoinHeadCommittee(MStaffCommitteeDto committeeList)
	{	
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// 入会者の現在のupdate_Countの最大値(MAX)を検索する
		MStaffCommittee committee = jdbcManager
			.from(MStaffCommittee.class)
			.where("(staffId,updateCount) in (select staff_id,max(update_count) " +
					"from m_staff_committee group by staff_id) and " +
					"staffId = ?", CommitteeList.staffId)
			.getSingleResult();
		
		// 委員会役職に「委員長 = 1」を入れる
		CommitteeList.committeePositionId = 1;
		
		// 更新回数は「現在の値+1」とする
		CommitteeList.updateCount = committee.updateCount +1;
		
		// 適用開始日をサーバから取得
		//CommitteeList.applyDate = nowDate2;
		
		//追加 @auther maruta
		if(CommitteeList.applyDate == null)
		{
			CommitteeList.applyDate = nowDate2;
		}
		//
		
		// 適用終了日に初期値nullを入れる
		CommitteeList.cancelDate = null;
		
		// 登録日時
		CommitteeList.registrationTime = new Timestamp(System.currentTimeMillis());
		
		// entityからDB対して、insertを行う
		MStaffCommittee entity = CommitteeList;
		jdbcManager.insert(entity).execute();
	}
	
	/**
	 * 委員長を退任します。
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 委員会所属(更新)
	 */
	public void updateLinkRetireHeadCommittee(MStaffCommitteeDto committeeList)
	{	
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// 委員長のupdate_Countの最大値(MAX),適用開始日を検索する
		MStaffCommittee committee = jdbcManager
		.from(MStaffCommittee.class)
		.where("(staffId,updateCount) in (select staff_id,max(update_count) " +
				"from m_staff_committee group by staff_id order by staff_id) and " +
				"staffId = ?", CommitteeList.staffId)
		.getSingleResult();
		
		// 委員会役職に「委員長 = 1」を入れる
		CommitteeList.committeePositionId = 1;
		
		// 更新回数は「現在の値」とする
		CommitteeList.updateCount = committee.updateCount;
		
		// 適用開始日に、更新回数が最大に該当するものを入れる
		CommitteeList.applyDate = committee.applyDate;
		
		// 適応終了日をサーバから取得
		//CommitteeList.cancelDate = nowDate2;
		
		//追加 @auther maruta
		if(CommitteeList.cancelDate == null)
		{
			CommitteeList.cancelDate = nowDate2;
		}
		//
		
		// 登録日時
		CommitteeList.registrationTime = new Timestamp(System.currentTimeMillis());
		
		// entityからDB対して、updateを行う
		MStaffCommittee entity = CommitteeList;
		jdbcManager.update(entity).execute();
	}
	
	/**
	 * 副委員長に任命します。
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 委員会所属(追加)
	 */
	public void insertLinkJoinSubHeadCommittee(MStaffCommitteeDto committeeList)
	{	
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// 入会者の現在のupdate_Countの最大値(MAX)を検索する
		MStaffCommittee committee = jdbcManager
			.from(MStaffCommittee.class)
			.where("(staffId,updateCount) in (select staff_id,max(update_count) " +
					"from m_staff_committee group by staff_id) and " +
					"staffId = ?", CommitteeList.staffId)
			.getSingleResult();
		
		// 委員会役職に「副委員長 = 2」を入れる
		CommitteeList.committeePositionId = 2;
		
		// 更新回数は「現在の値+1」とする
		CommitteeList.updateCount = committee.updateCount +1;
		
		// 適用開始日をサーバから取得
		//CommitteeList.applyDate = nowDate2;
		
		//追加 @auther maruta
		if(CommitteeList.applyDate == null)
		{
			CommitteeList.applyDate = nowDate2;
		}
		//
		
		// 適用終了日に初期値nullを入れる
		CommitteeList.cancelDate = null;
		
		// 登録日時
		CommitteeList.registrationTime = new Timestamp(System.currentTimeMillis());
		
		// entityからDB対して、insertを行う
		MStaffCommittee entity = CommitteeList;
		jdbcManager.insert(entity).execute();
	}
	
	/**
	 * 副委員長を退任します。
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 委員会所属(更新)
	 */
	public void updateLinkRetireSubHeadCommittee(MStaffCommitteeDto committeeList)
	{	
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// 委員長のupdate_Countの最大値(MAX),適用開始日を検索する
		MStaffCommittee committee = jdbcManager
			.from(MStaffCommittee.class)
			.where("(staffId,updateCount) in (select staff_id,max(update_count) " +
					"from m_staff_committee group by staff_id order by staff_id) and " +
					"staffId = ?", CommitteeList.staffId)
			.getSingleResult();
		
		// 委員会役職に「副委員長 = 2」を入れる
		CommitteeList.committeePositionId = 2;
		
		// 更新回数は「現在の値」とする
		CommitteeList.updateCount = committee.updateCount;
		
		// 適用開始日に、更新回数が最大に該当するものを入れる
		CommitteeList.applyDate = committee.applyDate;
		
		// 適応終了日をサーバから取得
		//CommitteeList.cancelDate = nowDate2;
		
		//追加 @auther maruta
		if(CommitteeList.cancelDate == null)
		{
			CommitteeList.cancelDate = nowDate2;
		}
		//
		
		// 登録日時
		CommitteeList.registrationTime = new Timestamp(System.currentTimeMillis());
		
		// entityからDB対して、updateを行う
		MStaffCommittee entity = CommitteeList;
		jdbcManager.update(entity).execute();
	}
	
	//追加 @auther okamoto-y
	/**
	 * 役職退任日の判定 
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 任命日より退任日の方が早い　 > 0,
	 * 		   任命日より退任日の方が遅い　< 0
	 */
	public Integer compareRetireDate(MStaffCommitteeDto committeeList)
	{
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// update_Countの最大値(MAX),適用開始日を検索する
		MStaffCommittee committee = jdbcManager
			.from(MStaffCommittee.class)
			.where("(staffId,updateCount) in (select staff_id,max(update_count) " +
					"from m_staff_committee group by staff_id order by staff_id) and " +
					"staffId = ?", CommitteeList.staffId)
			.getSingleResult();
		
		if(CommitteeList.cancelDate == null)
		{
			CommitteeList.cancelDate = nowDate2;
		}
		
		//入力されたcancelDateとすでに入力されているapplyDateを比較
		int cmp = committee.applyDate.compareTo(CommitteeList.cancelDate);
		
		return cmp;
	}
	
	//追加 @auther okamoto-y
	/**
	 * 委員会退会日の判定 
	 *
	 * @param  committeeList 委員会所属リスト
	 * @return 入会日or役職退任日より退会日の方が早い　 > 0,
	 * 		   入会日or役職退任日より退会日の方が遅い　 < 0
	 */
	public Integer compareWithdrawalDate(MStaffCommitteeDto committeeList)
	{
		// 現在時刻取得(Date型)		
		java.util.Date nowDate = new Date();
		java.sql.Date nowDate2 = new java.sql.Date(nowDate.getTime());
		
		// Dtoからエンティティへ変換
		MStaffCommittee CommitteeList = MStaffCommitteeDxo.convertCreate(committeeList);
		
		// update_Countの最大値(MAX),適用終了日を検索する
		MStaffCommittee committee = jdbcManager
			.from(MStaffCommittee.class)
			.where("(staffId,updateCount) in (select staff_id,max(update_count) " +
					"from m_staff_committee group by staff_id order by staff_id) and " +
					"staffId = ?", CommitteeList.staffId)
			.getSingleResult();
		
		if(CommitteeList.cancelDate == null)
		{
			CommitteeList.cancelDate = nowDate2;
		}
	
		if(committee.cancelDate == null){
			//どの役職にも就かずに退会する場合
			int cmp = committee.applyDate.compareTo(CommitteeList.cancelDate);
			
			return cmp;
		}else{
			//どれかの役職に就いていた場合
			//入力されたcancelDateとすでに入力されているcancelDateを比較
			int cmp = committee.cancelDate.compareTo(CommitteeList.cancelDate);
		
			return cmp;
		}
	}

}

