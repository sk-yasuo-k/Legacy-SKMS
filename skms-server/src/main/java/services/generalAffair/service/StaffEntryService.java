package services.generalAffair.service;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;

import services.generalAffair.address.entity.MPrefecture;
import services.generalAffair.address.entity.MStaffAddress;
import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.MStaffName;
import services.generalAffair.entity.MStaffAcademicBackground;
import services.generalAffair.entity.MStaffBusinessCareer;
import services.generalAffair.entity.MStaffWorkHistory;

import services.generalAffair.address.dxo.MPrefectureDxo;
import services.generalAffair.dxo.AddressApplyDxo;
import services.generalAffair.dxo.MStaffDxo;
import services.generalAffair.dxo.MStaffNameDxo;
import services.generalAffair.dxo.MStaffAcademicBackgroundDxo;
import services.generalAffair.dxo.MStaffBusinessCareerDxo;

import services.generalAffair.address.dto.MPrefectureDto;
import services.generalAffair.dto.AcademicBackgroundDto;
import services.generalAffair.dto.BusinessCareerDto;
import services.generalAffair.dto.AddressApplyDto;
import services.generalAffair.dto.MStaffDto;
import services.generalAffair.dto.MStaffNameDto;
import services.personnelAffair.license.dto.MBasicClassDto;
import services.personnelAffair.license.dto.MBasicPayDto;
import services.personnelAffair.license.dto.MPayLicenceHistoryDto;
import services.personnelAffair.license.dxo.MBasicClassDxo;
import services.personnelAffair.license.dxo.MBasicPayDxo;
import services.personnelAffair.license.dxo.MPayLicenceHistoryDxo;
import services.personnelAffair.license.entity.MBasicClass;
import services.personnelAffair.license.entity.MPayLicenceHistory;
import services.personnelAffair.profile.entity.MBasicPay;
import services.system.entity.StaffSetting;

/**
 * 社員登録情報サービス
 *
 * @author nobuhiro-s
 *
 */
public class StaffEntryService 
{

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;
	
	/**
	 * 都道府県です。
	 */
	public MPrefectureDxo mPrefectureDxo;
	
	/**
	 * 社員情報です。
	 */
	public MStaffDxo mStaffDxo;
	
	/**
	 * 社員情報(名前)です。
	 */
	public MStaffNameDxo mStaffNameDxo;
	
	/**
	 * 社員住所情報です。
	 */
	public AddressApplyDxo addressApplyDxo;
	
	
	/**
	 * 社員学歴情報です。
	 */
	public MStaffAcademicBackgroundDxo mStaffAcademicBackgroundDxo;
	
	/**
	 * 社員職歴情報です。
	 */
	public MStaffBusinessCareerDxo mStaffBusinessCareerDxo;
	
	/**
	 * 社内資格取得履歴です。
	 */
	public MPayLicenceHistoryDxo mPayLicenceHistoryDxo;

	/**
	 * 基本給マスタDxoです。
	 */
	public MBasicPayDxo mBasicPayDxo;	
	
	/**
	 * 等級マスタDxoです。
	 */
	public MBasicClassDxo mBasicClassDxo;
	
	/**
	 * 基本給マスタを取得します。
	 *
	 * @param
	 * @return 基本給マスタ
	 */
	public List<MBasicPayDto> getBasicPayList()
	{		
		// 基本給マスタの取得
		List<MBasicPay> src = jdbcManager
			.from(MBasicPay.class)
			.orderBy("classNo, rankNo")
			.getResultList();
		
		// データの変換
		List<MBasicPayDto> result = mBasicPayDxo.convert(src);
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
			.orderBy("classId desc")
			.getResultList();
		
		// データの変換
		List<MBasicClassDto> result = mBasicClassDxo.convert(src);
		return result;
	}
	
	/**
	 * 都道府県一覧を取得します。
	 *
	 * @param
	 * @return 都道府県名一覧
	 */
	public List<MPrefectureDto> getContinentList()
	{		
		// 都道府県名の取得
		List<MPrefecture> src = jdbcManager
			.from(MPrefecture.class)
			.getResultList();
		
		// データの変換
		List<MPrefectureDto> result = mPrefectureDxo.convert(src);
		return result;
	}
	
	/**
	 * 新入社員を登録します。
	 *
	 * @param  mStaffList 新入社員登録リスト
	 * @return 新入社員(追加)
	 */
	public void insertLinkMStaff(MStaffDto mStaffList,MStaffNameDto mStaffNameList,AddressApplyDto addressApplyList
			,List<AcademicBackgroundDto> academicBackgroundList,List<BusinessCareerDto> businessCareerList,MPayLicenceHistoryDto mPayLicenceHistoryList
			,int nowPeriod, Date enterday)
	{	
		// 現在時刻取得
		Timestamp curTime = new Timestamp(System.currentTimeMillis());
		
		// ■■■■■■■■■■■■
		// ■　　　個人情報　　　■
		// ■■■■■■■■■■■■
		
		// Dtoからエンティティへ変換
		MStaff MStaffList = mStaffDxo.convertCreate(mStaffList);
		
		// 登録日時を設定する
		MStaffList.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.insert(MStaffList).execute();
		
		// ■■■■■■■■■■■■
		// ■　個人情報(名前)　　■
		// ■■■■■■■■■■■■
		
		// Dtoからエンティティへ変換
		MStaffName MStaffNameList = mStaffNameDxo.convertCreate(mStaffNameList); 		
		
		// 社員IDを設定する
		MStaffNameList.staffId = MStaffList.staffId;
		
		// 適用日を設定する
		MStaffNameList.applyDate = curTime;
		
		// 登録日時を設定する
		MStaffNameList.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.insert(MStaffNameList).execute();

		// ■■■■■■■■■■■■
		// ■　　　　住所　　　　■
		// ■■■■■■■■■■■■
		
		// Dtoからエンティティへ変換
		MStaffAddress AddressApplyList = addressApplyDxo.convertCreate(addressApplyList); 		
		
		// 社員IDを設定する
		AddressApplyList.staffId = MStaffList.staffId;
		
		// 登録日時を設定する
		AddressApplyList.registrationTime = curTime;
		
		// entityからDB対して、insertを行う
		jdbcManager.insert(AddressApplyList).execute();
			
		// ■■■■■■■■■■■■
		// ■　　　　学歴　　　　■
		// ■■■■■■■■■■■■
		
		// 学歴情報が0件でない場合
		if(academicBackgroundList.size() != 0)
		{
			// Dtoからエンティティへ変換
			List<MStaffAcademicBackground> AcademicBackgroundList = mStaffAcademicBackgroundDxo.convertCreate(academicBackgroundList); 		
			
			// 社員ID・登録日時を設定する
			for( MStaffAcademicBackground tmp:AcademicBackgroundList)
			{
				tmp.staffId = MStaffList.staffId;
				tmp.registrationTime = curTime;
			}
			
			// entityからDB対して、insertを行う		
			jdbcManager.insertBatch(AcademicBackgroundList).execute();
		}
			
		// ■■■■■■■■■■■■
		// ■　　　　職歴　　　　■
		// ■■■■■■■■■■■■
		
		// 職歴情報が0件でない場合
		if(businessCareerList.size() != 0)
		{
			// Dtoからエンティティへ変換
			List<MStaffBusinessCareer> BusinessCareerList = mStaffBusinessCareerDxo.convertCreate(businessCareerList); 		
			
			// 社員ID・登録日時を設定する
			for( MStaffBusinessCareer tmp:BusinessCareerList)
			{
				tmp.staffId = MStaffList.staffId;
				tmp.registrationTime = curTime;
			}
			
			// entityからDB対して、insertを行う		
			jdbcManager.insertBatch(BusinessCareerList).execute();
		}
		
		// ■■■■■■■■■■■■
		// ■　　　社内資格　　　■
		// ■■■■■■■■■■■■
		
		// Dtoからエンティティへ変換
		MPayLicenceHistory mPayLicenceHistory = mPayLicenceHistoryDxo.convertCreate(mPayLicenceHistoryList);
		
		// 社員IDを設定する
		mPayLicenceHistory.staffId = MStaffList.staffId;
		
		// 更新回数は「1」とする
		mPayLicenceHistory.updateCount = 1;

		// null処理(職務手当ID)
		mPayLicenceHistory.managerialId = null;
		mPayLicenceHistory.managerialClassNo = null;
		mPayLicenceHistory.managerialMonthlySum = null;

		// null処理(主務手当ID)
		mPayLicenceHistory.competentId = null;
		mPayLicenceHistory.competentClassNo = null;
		mPayLicenceHistory.competentMonthlySum = null;

		// null処理(技能手当ID)
		mPayLicenceHistory.technicalSkillId = null;
		mPayLicenceHistory.technicalSkillClassNo = null;
		mPayLicenceHistory.technicalSkillMonthlySum = null;

		// null処理(情報処理手当ID)
		mPayLicenceHistory.informationPayId = null;
		mPayLicenceHistory.informationPayName = "未選択";
		mPayLicenceHistory.informationPayMonthlySum = null;

		// null処理(住宅手当ID)
		mPayLicenceHistory.housingId = null;
		mPayLicenceHistory.housingName = "未選択";
		mPayLicenceHistory.housingPayMonthlySum = null;
		
		// 登録日時を設定する
		mPayLicenceHistory.registrationTime = curTime;
		
		// 登録者IDを設定する
		mPayLicenceHistory.registrantId = MStaffList.registrantId;
		
		// 社内資格取得履歴の取得
		List<MPayLicenceHistory> src = jdbcManager
			.from(MPayLicenceHistory.class)
			.orderBy("periodId")
			.getResultList();
		
		// 現在期(検索期)を格納する
		int searchPeriod = mPayLicenceHistory.periodId;
		
		// 格納完了フラグ
		Boolean storehouseFlag = false;
		
		// 存在する期にレコードをinsertを行う(現行期以前は対象外)
		for( MPayLicenceHistory tmp:src)
		{
			if(tmp.periodId == searchPeriod)
			{	
				// 現在期を格納する
				mPayLicenceHistory.periodId = searchPeriod;
				
				// entityからDB対して、insertを行う
				jdbcManager.insert(mPayLicenceHistory).execute();
				
				// 現在期「+1」を格納する
				searchPeriod = searchPeriod + 1;
				
				// 格納完了フラグにtrueを格納する
				storehouseFlag = true;
			}
		}
		
		// 社内資格取得履歴にレコードが存在しない場合、現在期のみinsertを行う
		// ※期の初期登録回避処理
		if(storehouseFlag == false)
		{
			// 現在期を格納する
			mPayLicenceHistory.periodId = nowPeriod;
			
			// entityからDB対して、insertを行う
			jdbcManager.insert(mPayLicenceHistory).execute();
		}
		
		// 就労ステータスの新規登録
		Date nowDate = new Date();
		
		MStaffWorkHistory staffWorkHistory = new MStaffWorkHistory();
		
		staffWorkHistory.staffId = MStaffList.staffId;
		staffWorkHistory.updateCount = 1;
		staffWorkHistory.occuredDate = enterday;
		
		DateFormat tmpDf = new SimpleDateFormat("yyyy/MM/dd");
		
		String a = tmpDf.format(nowDate);
		String b = tmpDf.format(enterday);
		
		if(b.compareTo(a) < 0){
			staffWorkHistory.workStatusId = 0;
		}else{
			staffWorkHistory.workStatusId = 1;
		}
		staffWorkHistory.registrationTime = curTime;
		staffWorkHistory.registrantId = MStaffList.registrantId;
		staffWorkHistory.workEventId = 1;
		
		// entityからDB対して、insertを行う
		jdbcManager.insert(staffWorkHistory).execute();	

		// ■■■■■■■■■■■■
		// ■　　　環境設定　　　■
		// ■■■■■■■■■■■■
		
		StaffSetting staffSetting = new StaffSetting();
		staffSetting.staffId = MStaffList.staffId;
		
		jdbcManager.insert(staffSetting).execute();	
	}
}
	
	