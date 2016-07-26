package services.personnelAffair.license.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;

import services.personnelAffair.dxo.AuthorizedLocenceLabelDxo;
import services.personnelAffair.license.dto.MBasicClassDto;
import services.personnelAffair.license.dto.MBasicPayDto;
import services.personnelAffair.license.dto.MCompetentAllowanceDto;
import services.personnelAffair.license.dto.MHousingAllowanceDto;
import services.personnelAffair.license.dto.MManagerialAllowanceDto;
import services.personnelAffair.license.dto.MPayLicenceHistoryDto;
import services.personnelAffair.license.dto.MPeriodDto;
import services.personnelAffair.license.dto.MTechnicalSkillAllowanceDto;

import services.personnelAffair.license.dxo.MBasicClassDxo;
import services.personnelAffair.license.dxo.MBasicPayDxo;
import services.personnelAffair.license.dxo.MCompetentAllowanceDxo;
import services.personnelAffair.license.dxo.MHousingAllowanceDxo;
import services.personnelAffair.license.dxo.MManagerialAllowanceDxo;
import services.personnelAffair.license.dxo.MPayLicenceHistoryDxo;
import services.personnelAffair.license.dxo.MPeriodDxo;
import services.personnelAffair.license.dxo.MTechnicalSkillAllowanceDxo;

import services.personnelAffair.profile.entity.MBasicPay;
import services.personnelAffair.skill.dto.MInformationAllowanceDto;
import services.personnelAffair.skill.dxo.MInformationAllowanceDxo;
import services.personnelAffair.skill.entity.MInformationAllowance;
import services.personnelAffair.license.entity.MBasicClass;
import services.personnelAffair.license.entity.MCompetentAllowance;
import services.personnelAffair.license.entity.MHousingAllowance;
import services.personnelAffair.license.entity.MManagerialAllowance;
import services.personnelAffair.license.entity.MPayLicenceHistory;
import services.personnelAffair.license.entity.MPeriod;
import services.personnelAffair.license.entity.MTechnicalSkillAllowance;

/**
 * 社内資格取得情報サービス
 *
 * @author n-sumi
 *
 */
public class CompanyLicenseService
{
	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;
	
	/**
	 * 基本給マスタ変換Dxoです。
	 */
	public MBasicPayDxo mBasicPayDxo;
	
	/**
	 * 職務手当マスタ変換Dxoです。
	 */
	public MManagerialAllowanceDxo mManagerialAllowanceDxo;
	
	/**
	 * 主務手当マスタ変換Dxoです。
	 */
	public MCompetentAllowanceDxo mCompetentAllowanceDxo;
	
	/**
	 * 技能手当マスタ変換Dxoです。
	 */
	public MTechnicalSkillAllowanceDxo mTechnicalSkillAllowanceDxo;
	
	/**
	 * 認定資格情報ラベルDxo
	 */
	public AuthorizedLocenceLabelDxo authorizedLocenceLabelDxo;
	
	/**
	 * 認定資格手当マスタDxo
	 */
	public MInformationAllowanceDxo mInformationAllowanceDxo;
	
	/**
	 * 住宅手当マスタ変換Dxoです。
	 */
	public MHousingAllowanceDxo mHousingAllowanceDxo;
	
	/**
	 * 資格手当取得履歴変換Dxoです。(新規作成)
	 */
	public MPayLicenceHistoryDxo mPayLicenceHistoryDxo;
	
	/**
	 * 資格手当取得履歴リスト(コピー用)
	 */
	private List<MPayLicenceHistory> mPayList = new ArrayList<MPayLicenceHistory>();
	
	/**
	 * 等級マスタDxoです。
	 */
	public MBasicClassDxo mBasicClassDxo;
	
	/**
	 * 等級マスタDxoです。
	 */
	public MPeriodDxo mPeriodDxo;
	
	/**
	 * 期マスタを取得します。
	 *
	 * @param
	 * @return 期マスタ
	 */
	public List<MPeriodDto> getPeriodList()
	{		
		// 期マスタの取得
		List<MPeriod> src = jdbcManager
			.from(MPeriod.class)
			.orderBy("id desc")
			.getResultList();
		
		// データの変換
		List<MPeriodDto> result = mPeriodDxo.convert(src);
		return result;
	}
	
	/**
	 * 等級マスタを取得します。
	 *
	 * @param
	 * @return 等級マスタ
	 */
	public List<MBasicClassDto> getBasicClassPayList()
	{		
		// 等級マスタの取得
		List<MBasicClass> src = jdbcManager
			.from(MBasicClass.class)
			.orderBy("id asc")
			.getResultList();
		
		// データの変換
		List<MBasicClassDto> result = mBasicClassDxo.convert(src);
		return result;
	}

	/**
	 * 基本給マスタ取得処理。
	 * 
	 * @return 基本給マスタ情報
	 */	
	public List<MBasicPayDto> getBasicPayList()
	{
		// 検索の実行
		List<MBasicPay> src = jdbcManager
						.from(MBasicPay.class)
						.orderBy("basicPayId asc")
						.getResultList();
		
		// データの変換
		List<MBasicPayDto> result = mBasicPayDxo.convert(src);
		
		return result;
	}
	
	/**
	 * 職務手当マスタ取得処理。
	 * 
	 * @return 職務手当マスタ情報
	 */	
	public List<MManagerialAllowanceDto> getManagerialAllowanceList()
	{
		// 検索の実行
		List<MManagerialAllowance> src = jdbcManager
						.from(MManagerialAllowance.class)
						.orderBy("managerialId asc")
						.getResultList();

		// データの変換
		List<MManagerialAllowanceDto> result = mManagerialAllowanceDxo.convert(src);
		
		return result;
	}
	
	/**
	 * 主務手当マスタ取得処理。
	 * 
	 * @return 主務手当マスタ情報
	 */	
	public List<MCompetentAllowanceDto> getCompetentAllowanceList()
	{
		// 検索の実行
		List<MCompetentAllowance> src = jdbcManager
						.from(MCompetentAllowance.class)
						.orderBy("competentId asc")
						.getResultList();
		
		// データの変換
		List<MCompetentAllowanceDto> result = mCompetentAllowanceDxo.convert(src);
		
		return result;
	}
	
	/**
	 * 技能手当マスタ取得処理。
	 * 
	 * @return 技能手当マスタ情報
	 */	
	public List<MTechnicalSkillAllowanceDto> getMTechnicalSkillAllowanceList()
	{
		// 検索の実行
		List<MTechnicalSkillAllowance> src = jdbcManager
						.from(MTechnicalSkillAllowance.class)
						.orderBy("technicalSkillId asc")
						.getResultList();
		
		// データの変換
		List<MTechnicalSkillAllowanceDto> result = mTechnicalSkillAllowanceDxo.convert(src);
		
		return result;
	}
	
	/**
	 * 処理情報手当マスタを取得します。
	 *
	 * @param
	 * @return 認定資格手当マスタ
	 */
	public List<MInformationAllowanceDto> getMInformationAllowanceList()
	{		
		// 認定資格手当マスタの取得
		List<MInformationAllowance> src = jdbcManager
			.from(MInformationAllowance.class)
			.orderBy("informationPayId asc")
			.getResultList();
		
		// データの変換
		List<MInformationAllowanceDto> result = mInformationAllowanceDxo.convert(src);
		
		return result;
	}
	
	/**
	 * 住宅手当マスタ取得処理。
	 * 
	 * @return 住宅手当マスタ情報
	 */	
	public List<MHousingAllowanceDto> getMHousingAllowanceList()
	{
		// 検索の実行
		List<MHousingAllowance> src = jdbcManager
						.from(MHousingAllowance.class)
						.orderBy("housingId asc")
						.getResultList();
		
		// データの変換
		List<MHousingAllowanceDto> result = mHousingAllowanceDxo.convert(src);
		
		return result;
	}
	
	/**
	 * 資格手当取得処理
	 * 
	 * @return 資格手当取得処理(年間)
	 */	
	public List<MPayLicenceHistoryDto> getMPayLicenceList(int nowPeriod)
	{	
		// 検索の実行
		List<MPayLicenceHistory> tmp = jdbcManager
						.from(MPayLicenceHistory.class)
						.leftOuterJoin("mStaff")
						.leftOuterJoin("mStaff.staffName")
						.leftOuterJoin("mPeriod")
						.where("periodId =?",nowPeriod)
						.orderBy(" staffId asc,updateCount desc")
						.getResultList();
		
		boolean countFlag = false;
		int copyStaffId = 0;
		
		// 各社員IDの更新回数が最大回数のレコードを取得する
		for(MPayLicenceHistory editing : tmp)
		{	
			// 初回のみ社員ID格納
			if(countFlag == false)
			{	
				countFlag = true;
				
				// レコードを追加する
				mPayList.add(editing);
				
				copyStaffId = editing.staffId;
			}
			
			// 社員ID(保持)と社員IDが違う場合
			if(copyStaffId != editing.staffId)
			{
				// レコードを追加する
				mPayList.add(editing);
				
				// 社員IDを格納する
				copyStaffId = editing.staffId;
			}
		}

		// データの変換
		List<MPayLicenceHistoryDto> result = mPayLicenceHistoryDxo.convert(mPayList);
		
		return result;
	}
	
	/**
	 * 資格手当取得処理(比較用)。
	 * 
	 * @return 資格手当取得処理(年間)
	 */	
	public List<MPayLicenceHistoryDto> getSeveMPayLicenceList(int nowPeriod)
	{	
		// 検索の実行
		List<MPayLicenceHistory> tmp = jdbcManager
						.from(MPayLicenceHistory.class)
						.leftOuterJoin("mStaff")
						.leftOuterJoin("mStaff.staffName")
						.leftOuterJoin("mPeriod")
						.where("periodId =?",nowPeriod)
						.orderBy(" staffId asc,updateCount desc")
						.getResultList();
		
		boolean countFlag = false;
		int copyStaffId = 0;
		
		// 各社員IDの更新回数が最大回数のレコードを取得する
		for(MPayLicenceHistory editing : tmp)
		{	
			// 初回のみ社員ID格納
			if(countFlag == false)
			{	
				countFlag = true;
				
				// レコードを追加する
				mPayList.add(editing);
				
				copyStaffId = editing.staffId;
			}
			
			// 社員ID(保持)と社員IDが違う場合
			if(copyStaffId != editing.staffId)
			{
				// レコードを追加する
				mPayList.add(editing);
				
				// 社員IDを格納する
				copyStaffId = editing.staffId;
			}
		}

		// データの変換
		List<MPayLicenceHistoryDto> result = mPayLicenceHistoryDxo.convert(mPayList);
		
		return result;
	}
	
	/**
	 * 資格手当取得処理(複製)。
	 * 
	 * @return 資格手当取得処理(年間)
	 */	
	public List<MPayLicenceHistoryDto> getCopyMPayLicenceList(int nowPeriod)
	{	
		// 検索の実行
		List<MPayLicenceHistory> tmp = jdbcManager
						.from(MPayLicenceHistory.class)
						.leftOuterJoin("mStaff")
						.leftOuterJoin("mStaff.staffName")
						.leftOuterJoin("mPeriod")
						.where("periodId =?",nowPeriod)
						.orderBy(" staffId asc,updateCount desc")
						.getResultList();
		
		boolean countFlag = false;
		int copyStaffId = 0;
		
		// 各社員IDの更新回数が最大回数のレコードを取得する
		for(MPayLicenceHistory editing : tmp)
		{	
			// 初回のみ社員ID格納
			if(countFlag == false)
			{	
				countFlag = true;
				
				// レコードを追加する
				mPayList.add(editing);
				
				copyStaffId = editing.staffId;
			}
			
			// 社員ID(保持)と社員IDが違う場合
			if(copyStaffId != editing.staffId)
			{
				// レコードを追加する
				mPayList.add(editing);
				
				// 社員IDを格納する
				copyStaffId = editing.staffId;
			}
		}

		// データの変換
		List<MPayLicenceHistoryDto> result = mPayLicenceHistoryDxo.convert(mPayList);
		
		return result;
	}

	/**
	 * 資格手当取得履歴処理(個人用)。
	 * 
	 * @return 資格手当取得履歴処理
	 */	
	public List<MPayLicenceHistoryDto> getPrivateMPayLicenceList(int staffId)
	{
		
		// 検索の実行
		List<MPayLicenceHistory> src = jdbcManager
						.from(MPayLicenceHistory.class)
						.leftOuterJoin("mStaff")
						.leftOuterJoin("mStaff.staffName")
						.leftOuterJoin("mPeriod")
						.where("staffId =?",staffId)
						.orderBy("registrationTime desc")
						.getResultList();

		// データの変換
		List<MPayLicenceHistoryDto> result = mPayLicenceHistoryDxo.convert(src);
		
		return result;	
	}
		
	/**
	 * 手当資格履歴を登録します。
	 *
	 * @param  
	 * @return 履歴(追加)
	 */
	public void insertMPayLicenceList(int inStaffId,int nowPeriod,List<MPayLicenceHistoryDto> mPayLicenceHistory)
	{
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());

		// Dtoからエンティティへ変換
		List<MPayLicenceHistory> mPayLicenceHistoryList = mPayLicenceHistoryDxo.convertCreate(mPayLicenceHistory); 			
		
		// 検索の実行
		List<MPayLicenceHistory> tmp = jdbcManager
						.from(MPayLicenceHistory.class)
						.where("periodId =?",nowPeriod)
						.orderBy(" staffId asc,updateCount desc")
						.getResultList();
		
		boolean countFlag = false;
		int copyStaffId = 0;
		int nowUpdateCount = 0;
		
		// 各社員IDの更新回数が最大回数のレコードを取得する
		for(MPayLicenceHistory editing : tmp)
		{	
			// 初回のみ社員ID格納
			if(countFlag == false)
			{	
				countFlag = true;
				
				// レコードを追加する
				mPayList.add(editing);
				
				copyStaffId = editing.staffId;
			}
			
			// 社員ID(保持)と社員IDが違う場合
			if(copyStaffId != editing.staffId)
			{
				// レコードを追加する
				mPayList.add(editing);
				
				// 社員IDを格納する
				copyStaffId = editing.staffId;
			}
		}
		
		// 更新した社内資格取得履歴レコードをinsertを行う
		for(MPayLicenceHistory insertMPayLicenceHistory : mPayLicenceHistoryList)
		{						
			// 期を格納する
			insertMPayLicenceHistory.periodId = nowPeriod;
			
			for(MPayLicenceHistory maxUpdataList : mPayList)
			{
				if(insertMPayLicenceHistory.staffId.equals(maxUpdataList.staffId))
				{
					nowUpdateCount = maxUpdataList.updateCount;
				}
			}
			
			// 更新回数が0の場合
			if(nowUpdateCount == 0)
			{
				// 更新回数は「1」とする
				insertMPayLicenceHistory.updateCount = 1;
			}
			else
			{
				// 更新回数は「最大値+1」とする
				insertMPayLicenceHistory.updateCount = nowUpdateCount + 1;							
			}
			
			// null処理(職務手当ID)
			if(insertMPayLicenceHistory.managerialId == 0)
			{
				insertMPayLicenceHistory.managerialId = null;
				insertMPayLicenceHistory.managerialClassNo = null;
				insertMPayLicenceHistory.managerialMonthlySum = null;
			}
			// null処理(主務手当ID)
			if(insertMPayLicenceHistory.competentId == 0)
			{
				insertMPayLicenceHistory.competentId = null;
				insertMPayLicenceHistory.competentClassNo = null;
				insertMPayLicenceHistory.competentMonthlySum = null;
			}
			// null処理(技能手当ID)
			if(insertMPayLicenceHistory.technicalSkillId == 0)
			{
				insertMPayLicenceHistory.technicalSkillId = null;
				insertMPayLicenceHistory.technicalSkillClassNo = null;
				insertMPayLicenceHistory.technicalSkillMonthlySum = null;
			}
			// null処理(情報処理手当ID)
			if(insertMPayLicenceHistory.informationPayId == 0)
			{
				insertMPayLicenceHistory.informationPayId = null;
				insertMPayLicenceHistory.informationPayName = "未選択";
				insertMPayLicenceHistory.informationPayMonthlySum = null;
			}
			// null処理(住宅手当ID)
			if(insertMPayLicenceHistory.housingId == 0)
			{
				insertMPayLicenceHistory.housingId = null;
				insertMPayLicenceHistory.housingName = "未選択";
				insertMPayLicenceHistory.housingPayMonthlySum = null;
			}
			
			// 登録日時を設定する
			insertMPayLicenceHistory.registrationTime = curTime;
			
			// 登録者IDを設定する
			insertMPayLicenceHistory.registrantId = inStaffId;
			
			// entityからDB対して、insertを行う
			jdbcManager.insert(insertMPayLicenceHistory).execute();
		}
	}	
}