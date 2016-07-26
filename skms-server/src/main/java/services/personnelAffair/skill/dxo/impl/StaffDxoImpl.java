package services.personnelAffair.skill.dxo.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import services.generalAffair.entity.MStaff;
import services.personnelAffair.skill.dto.StaffAuthorizedLicenceDto;
import services.personnelAffair.skill.dto.StaffDto;
import services.personnelAffair.skill.dto.StaffOtherLocenceDto;
import services.personnelAffair.skill.dxo.StaffDxo;
import services.personnelAffair.skill.entity.MStaffAuthorizedLicence;
import services.personnelAffair.skill.entity.MStaffOtherLocence;

/**
 * 社員情報変換Dxo実装クラスです。
 * 
 * @author yoshinori-t
 * 
 */
public class StaffDxoImpl implements StaffDxo {

	/**
	 * 社員情報エンティティから社員情報情報Dtoへ変換.
	 *
	 * @param src 社員情報エンティティのリスト
	 * @return 社員情報Dtoリスト
	 */
	public List<StaffDto> convert(List<MStaff> src)
	{
		List<StaffDto> dst = new ArrayList<StaffDto>();
		for (MStaff pos : src)
		{
			StaffDto dto = new StaffDto();
			// 社員ID
			dto.staffId  = pos.staffId;
			
			// 社員名
			dto.fullName = pos.staffName.fullName;

			// 性別
			if( pos.sex != null )
			{
				if( pos.sex == 1 )
				{
					dto.sex = "男";
				}
				else if( pos.sex == 2 )
				{
					dto.sex = "女";
				}
			}

			// 生年月日
			dto.birthday = pos.birthday;

			// 年齢
			dto.age = diffYear(dto.birthday);
			
			// 入社日
			if( pos.staffWorkHistory != null && pos.staffWorkHistory.size() > 0 )
			{
				dto.occuredDate = pos.staffWorkHistory.get(0).occuredDate;
			}
			
			// 経験年数
			dto.experienceYears = diffYear(dto.occuredDate);
			
			// ※入社前経験年数を加算
			if( pos.experienceYears != null )
			{
				dto.experienceYears += pos.experienceYears;
			}

			// 役職
			if( pos.staffManagerialPosition != null && pos.staffManagerialPosition.size() > 0 )
			{
				// 経営種別略称を設定する
				dto.managerialPositionName = pos.staffManagerialPosition.get(0).managerialPosition.managerialPositionAlias;
			}
			
			// 職種
			if( pos.mOccupationalCategory != null )
			{
				dto.occupationalCategoryName = pos.mOccupationalCategory.occupationalCategoryName;
			}
			
			// 所属部署
			if( pos.staffDepartment != null && pos.staffDepartment.size() > 0 )
			{
				dto.departmentName = pos.staffDepartment.get(0).mDepartment.departmentName;
			}
			
			// 最終学歴
			if( pos.mStaffAcademicBackground != null && pos.mStaffAcademicBackground.size() > 0 )
			{
				dto.finalAcademicBackground = pos.mStaffAcademicBackground.get(0).content;
			}
			
			// 社員所持認定資格
			if ( pos.mStaffAuthorizedLicence.size() > 0 )
			{
				List<StaffAuthorizedLicenceDto> list_auth = new ArrayList<StaffAuthorizedLicenceDto>();
				for (MStaffAuthorizedLicence pos_auth : pos.mStaffAuthorizedLicence)
				{
					StaffAuthorizedLicenceDto auth = new StaffAuthorizedLicenceDto();
					auth.staffId = pos_auth.staffId;
					auth.licenceId = pos_auth.licenceId;
					auth.licenceName = pos_auth.mAuthorizedLicence.licenceName;
					auth.acquisitionDate = pos_auth.acquisitionDate;
					auth.registrationTime = pos_auth.registrationTime;
					auth.registrantId = pos_auth.registrantId;
					list_auth.add(auth);
				}
				dto.staffAuthorizedLicence = list_auth;
			}

			// 社員所持その他資格
			if ( pos.mStaffOtherLocence.size() > 0 )
			{
				List<StaffOtherLocenceDto> list_other = new ArrayList<StaffOtherLocenceDto>();
				for (MStaffOtherLocence pos_auth : pos.mStaffOtherLocence)
				{
					StaffOtherLocenceDto other = new StaffOtherLocenceDto();
					other.staffId = pos_auth.staffId;
					other.sequenceNo = pos_auth.sequenceNo;
					other.licenceName = pos_auth.licenceName;
					other.acquisitionDate = pos_auth.acquisitionDate;
					other.registrationTime = pos_auth.registrationTime;
					other.registrantId = pos_auth.registrantId;
					list_other.add(other);
				}
				dto.staffOtherLocence = list_other;
			}
			
			dst.add(dto);
		}
		return dst;
	}
	
	/**
	 * 経過年数計算処理。
	 * 指定した日付から現在日付までの年数を計算。
	 *
	 * @param src 日付
	 * @return 現在日付までの年数
	 */
	private int diffYear(Date src)
	{
		int diffYear = 0;		// 指定した日付からの年数
		
		// 指定した日付がnull以外の場合に計算を実行
		if ( src != null )
		{
			// 指定した日付をCalendarクラスに変換
			Calendar culSrcDate = Calendar.getInstance();
			culSrcDate.setTime(src);
			
			// 現在日付の取得
			Calendar culCurDate = Calendar.getInstance();
			
			// 指定した日付からの年数を計算
			diffYear = culCurDate.get(Calendar.YEAR) - culSrcDate.get(Calendar.YEAR);
			
			// 入社日に入社日からの年数を加算
			culSrcDate.add(Calendar.YEAR, diffYear);
			
			// 現在日付よりも前の日付の場合は年数を1つ少なくする
			if ( culCurDate.compareTo(culSrcDate) < 0 )
			{
				diffYear--;
			}
		}
		
		return diffYear;
	}
}
