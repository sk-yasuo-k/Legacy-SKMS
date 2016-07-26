package services.personnelAffair.profile.service;

import java.sql.Timestamp;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.parameter.Parameter;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.entity.MStaff;
import services.generalAffair.entity.MStaffName;
import services.generalAffair.entity.VCurrentStaffName;
import services.personnelAffair.authority.entity.MStaffQualification;
import services.personnelAffair.profile.dto.BasicPayDto;
import services.personnelAffair.profile.dto.ProfileDetailDto;
import services.personnelAffair.profile.dto.ProfileDto;
import services.personnelAffair.profile.dxo.ProfileInfoDxo;
import services.personnelAffair.profile.entity.MBasicPay;
import services.personnelAffair.profile.entity.MStaffHandyPhone;
import services.personnelAffair.profile.entity.ProfileDetail;
import services.personnelAffair.profile.entity.ProfileInfo;


/**
 * プロフィール情報サービス。
 * プロフィール情報を扱うサービスです。
 *
 * @author yoshinori-t
 *
 */
public class ProfileService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * プロフィール情報変換Dxoです。
	 */
	public ProfileInfoDxo profileInfoDxo;
	
	
	/**
	 * コンストラクタ
	 */
	public ProfileService()
	{
		
	}
	
	/**
	 * プロフィールリスト取得処理。
	 * 
	 * @return 社員リスト
	 */
	public List<ProfileDto> getProfileList()
	{
		// 検索の実行
		List<ProfileInfo> src = jdbcManager
						.from(ProfileInfo.class)						// プロフィール情報
						.innerJoin("staffName")							// 社員名情報
						.leftOuterJoin("profileJoinInfo")				// プロフィール入社情報
						.leftOuterJoin("profileRetireInfo")				// プロフィール退社情報
						.leftOuterJoin("profileDepartmentInfo")			// プロフィール所属情報
						.leftOuterJoin("profileProjectInfo")			// プロフィールプロジェクト情報
						.leftOuterJoin("profileCommitteeInfo")			// プロフィール委員会情報
						.leftOuterJoin("profileAddressInfo")			// プロフィール住所情報
						.leftOuterJoin("profileHandyPhoneInfo")			// プロフィール携帯電話情報
						.leftOuterJoin("profileWorkHistoryInfo")		// プロフィール就労状況履歴情報
						.leftOuterJoin("profileQualificationInfo")		// プロフィール資格情報
						.leftOuterJoin("profileHousingAllowanceInfo")	// プロフィール住宅手当情報
						.leftOuterJoin("profileDepartmentHeadInfo")		// プロフィール所属部長情報
						.leftOuterJoin("profileProjecyPositionInfo")	// プロフィール役職情報
						.leftOuterJoin("profileManagerialPositionInfo")	// プロフィール経営役職情報
						.leftOuterJoin("profileAuthorizedLicence")		// プロフィール認定資格情報
						.leftOuterJoin("profileAcademicBackground")		// プロフィール最終学歴情報
						.where()
						.orderBy("staffId")
						.getResultList();
		
		// データの変換
		List<ProfileDto> result = profileInfoDxo.convert(src);
		return result;
	}

	
	/**
	 * プロフィール取得処理。
	 * 
	 * @return 社員プロフィール
	 */
	public ProfileDto getProfileData(Integer staffId)
	{	
		// 検索の実行
		ProfileInfo src = jdbcManager
						.from(ProfileInfo.class)						// プロフィール情報
						.innerJoin("staffName")							// 社員名情報
						.leftOuterJoin("profileHandyPhoneInfo")			// プロフィール携帯電話情報
						.leftOuterJoin("profileQualificationInfo")		// プロフィール資格情報
						.where(new SimpleWhere().eq("staffId", staffId))
						.getSingleResult();
		
		// データの変換
		ProfileDto result = profileInfoDxo.convertData(src);
		
		return result;
	}

	
	/**
	 * 基本給マスタ取得処理。
	 * 
	 * @return 基本給マスタ情報
	 */	
	public List<BasicPayDto> getBasicPayDto()
	{
		// 検索の実行
		List<MBasicPay> src = jdbcManager
						.from(MBasicPay.class)
						.orderBy("basicPayId asc")
						.getResultList();
		
		List<BasicPayDto> result = profileInfoDxo.convertBasicPayDto(src);
		
		return result;
	}
	
	/**
	 * プロフィール詳細取得処理
	 * 
	 * @param staffId 社員ID
	 * @return プロフィール詳細
	 */
	public ProfileDetailDto getProfileDetail(Integer staffId)
	{
		// 検索の実行
		ProfileDetail src = jdbcManager
						.from(ProfileDetail.class)										// プロフィール詳細
						.leftOuterJoin("profileWorkPlace")								// プロフィール勤務地情報
						.leftOuterJoin("mStaffAuthorizedLicence")						// 社員所持認定資格マスタ
						.leftOuterJoin("mStaffAuthorizedLicence.mAuthorizedLicence")	// 認定資格マスタ
						.leftOuterJoin("mStaffOtherLocence")							// 社員所持その他資格マスタ
						.leftOuterJoin("seminarParticipant")							// セミナー受講者
						.leftOuterJoin("seminarParticipant.seminar")					// セミナー
						.where(new SimpleWhere().eq("staffId", staffId))
						.orderBy("staffId" +
								", mStaffAuthorizedLicence.acquisitionDate desc" +
								", mStaffOtherLocence.acquisitionDate desc" +
								", seminarParticipant.seminar.startTime desc")
						.getSingleResult();
		
		// データの変換
		ProfileDetailDto result = profileInfoDxo.convertProfileDetail(src);
		return result;
	}
	
	
	/**
	 * プロフィール更新処理
	 * 
	 * @param profileData プロフィール更新データ
	 * @param staffId ログイン社員ID
	 */	
	public void updateProfileData(ProfileDto profileData, Integer staffId)
	{
		// 現在時刻
		Timestamp curTimes = new Timestamp(System.currentTimeMillis());			
		// プロフィール画像更新処理
		updateProfileImage(profileData.staffId, profileData.staffImage);
		// プロフィール更新処理
		updateStaffData(profileData, staffId, curTimes);
		// 姓名更新処理
		insertStaffData(profileData, staffId, curTimes);
		// 携帯番号更新処理
		insertStaffHandyPhoneNo(profileData, staffId, curTimes);
		// 等級・号更新処理
		insertStaffQualification(profileData, staffId, curTimes);
	}

	/**
	 * プロフィール画像更新処理
	 * 
	 * @param staffId 社員ID
	 * @param staffImage プロフィール画像
	 */
	public void updateProfileImage(Integer staffId, byte[] staffImage)
	{
		// 更新の実行
		jdbcManager.updateBySql(
							"update m_staff set staff_image = ? where staff_id = ?",
							Parameter.class, Integer.class)
						.params(Parameter.lob(staffImage), staffId)
						.execute();
	}
	
	/**
	 * プロフィール更新処理
	 * 
	 * @param profileData プロフィール更新データ
	 * @param staffId ログイン社員ID
	 * @param curTimes 現在時刻
	 */
	public void updateStaffData(ProfileDto profileData, Integer staffId, Timestamp curTimes)	
	{
		// DBに登録されているデータを取得
		MStaff mStaff = 
			jdbcManager.from(MStaff.class)
			.where(new SimpleWhere().eq("staffId", profileData.staffId))
			.getSingleResult();
		
		// 登録されたデータと差分比較
		if(!(profileData.sex.equals(mStaff.sex) && profileData.bloodGroup.equals(mStaff.bloodGroup) 
				&& (mStaff.birthday.compareTo(profileData.birthday) == 0) && profileData.email.equals(mStaff.email) 
				&& profileData.extensionNumber.equals(mStaff.extensionNumber) && profileData.emergencyAddress.equals(mStaff.emergencyAddress)))
		{
			// 更新するデータの設定
			mStaff.sex              = profileData.sex;				// 性別
			mStaff.bloodGroup       = profileData.bloodGroup;		// 血液型
			mStaff.birthday         = profileData.birthday;			// 生年月日
			mStaff.extensionNumber  = profileData.extensionNumber;  // 内線番号
			mStaff.email            = profileData.email;			// メールアドレス
			mStaff.emergencyAddress = profileData.emergencyAddress;	// 緊急連絡先
			mStaff.registrantId     = staffId;						// 登録者ID
			mStaff.registrationTime = curTimes;						// 登録日時
			
			// 更新の実行
			jdbcManager.update(mStaff).execute();
		}		
	}
	
	/**
	 * 姓名更新処理
	 * 
	 * @param profileData プロフィール更新データ
	 * @param staffId ログイン社員ID
	 * @param curTimes 現在時刻
	 */
	public void insertStaffData(ProfileDto profileData, Integer staffId, Timestamp curTimes)	
	{
		// DBに登録されているデータを取得
		VCurrentStaffName vCurrentStaffName = 
			jdbcManager.from(VCurrentStaffName.class)
			.where("update_count = (select max(update_count) from m_staff_name WHERE staff_id = '" + profileData.staffId +"')" +
					" and staff_id = '" + profileData.staffId +"'")
			.getSingleResult();		
		
		// 登録されたデータと差分比較
		if(!(profileData.firstName.equals(vCurrentStaffName.firstName) && profileData.firstNameKana.equals(vCurrentStaffName.firstNameKana)
				&& profileData.lastName.equals(vCurrentStaffName.lastName) && profileData.lastNameKana.equals(vCurrentStaffName.lastNameKana)))
		{
			// 更新するデータの設定
			MStaffName mStaffName = new MStaffName();
			mStaffName.staffId          = profileData.staffId;					// 社員ID
			mStaffName.updateCount      = vCurrentStaffName.updateCount + 1;	// 更新回数
			mStaffName.applyDate        = curTimes;								// 適用開始日
			mStaffName.firstName        = profileData.firstName;				// 姓(漢字)
			mStaffName.firstNameKana    = profileData.firstNameKana;			// 名(漢字)	
			mStaffName.lastName         = profileData.lastName;					// 姓(かな)
			mStaffName.lastNameKana     = profileData.lastNameKana;				// 名(かな)
			mStaffName.registrationTime = curTimes;								// 登録日時
			mStaffName.registrantId     = staffId;								// 登録者ID

			// 更新の実行
			jdbcManager.insert(mStaffName).execute();				
		}
	}
	
	/**
	 * 携帯番号更新処理
	 * 
	 * @param profileData プロフィール更新データ
	 * @param staffId ログイン社員ID
	 * @param curTimes 現在時刻
	 */
	public void insertStaffHandyPhoneNo(ProfileDto profileData, Integer staffId, Timestamp curTimes)	
	{
		String handyPhoneNo1 = new String();
		String handyPhoneNo2 = new String();		
		String handyPhoneNo3 = new String();
		
		String[] strAry = profileData.handyPhoneNo.split("-");

		if(strAry.length == 3){
			handyPhoneNo1 = strAry[0];
			handyPhoneNo2 = strAry[1];
			handyPhoneNo3 = strAry[2];
		}else{
			handyPhoneNo1 = "";
			handyPhoneNo2 = "";
			handyPhoneNo3 = "";			
		}
		
		MStaffHandyPhone mStaffHandyPhone = 
			jdbcManager.from(MStaffHandyPhone.class)
			.where("update_count = (SELECT max(update_count) FROM m_staff_handy_phone WHERE staff_id = '" + profileData.staffId +"')" +
					" and staff_id = '" + profileData.staffId +"'")			
			.getSingleResult();
		
		if(mStaffHandyPhone == null){
			mStaffHandyPhone = new MStaffHandyPhone();
		}
		
		// 登録されたデータと差分比較
		if(!(handyPhoneNo1.equals(mStaffHandyPhone.handyPhoneNo1) 
				&& handyPhoneNo2.equals(mStaffHandyPhone.handyPhoneNo2) 
				&& handyPhoneNo3.equals(mStaffHandyPhone.handyPhoneNo3)))
		{
			mStaffHandyPhone.staffId = profileData.staffId;							// 社員ID
			
			if(mStaffHandyPhone.updateCount == null){								// 更新回数
				mStaffHandyPhone.updateCount = 1;
			}else{
				mStaffHandyPhone.updateCount = mStaffHandyPhone.updateCount + 1;
			}
			
			mStaffHandyPhone.handyPhoneNo1 = handyPhoneNo1;							// 携帯電話番号1
			mStaffHandyPhone.handyPhoneNo2 = handyPhoneNo2;							// 携帯電話番号2
			mStaffHandyPhone.handyPhoneNo3 = handyPhoneNo3;							// 携帯電話番号3
			mStaffHandyPhone.openHandyPhoneNo = true;								// 携帯電話番号公開フラグ
			mStaffHandyPhone.registrationTime = curTimes;							// 登録日時
			mStaffHandyPhone.registrantId     = staffId;							// 登録者ID
			
			// 更新の実行
			jdbcManager.insert(mStaffHandyPhone).execute();	
		}
	}
	
	/**
	 * 等級・号更新処理
	 * 
	 * @param profileData プロフィール更新データ
	 * @param staffId ログイン社員ID
	 * @param curTimes 現在時刻
	 */
	public void insertStaffQualification(ProfileDto profileData, Integer staffId, Timestamp curTimes)	
	{
		// DBに登録されているデータを取得
		MStaffQualification mStaffQualification = 
			jdbcManager.from(MStaffQualification.class)
			.where("update_count = (SELECT max(update_count) FROM m_staff_qualification WHERE staff_id = '" + profileData.staffId +"')" +
					" and staff_id = '" + profileData.staffId +"'")			
			.getSingleResult();
		
		// 等級・号から基本給IDを取得
		MBasicPay mBasicPay = 
			jdbcManager.from(MBasicPay.class)
			.where("class_no = '" + profileData.basicClassNo +"'" +
					" and rank_no = '" + profileData.basicRankNo +"'")
			.getSingleResult();	
		
		// データがなければ新規追加
		if(mStaffQualification == null){
			mStaffQualification = new MStaffQualification();
		}		
		
		if(!(mBasicPay.basicPayId.equals(mStaffQualification.basicPayId))){
			mStaffQualification.staffId = profileData.staffId;							// 社員ID
			
			if(mStaffQualification.updateCount == null){								// 更新回数
				mStaffQualification.updateCount = 1;
			}else{
				mStaffQualification.updateCount = mStaffQualification.updateCount + 1;
			}
			
			mStaffQualification.basicPayId = mBasicPay.basicPayId;						// 基本給ID
			mStaffQualification.registrationTime = curTimes;							// 登録日時
			mStaffQualification.registrantId     = staffId;								// 登録者ID
			
			// 更新の実行
			jdbcManager.insert(mStaffQualification).execute();
		}	
	}
}
