package services.generalAffair.address.service;

import java.sql.Timestamp;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;

import services.generalAffair.address.dto.ChangeAddressApplyDto;
import services.generalAffair.address.dto.MPrefectureDto;
import services.generalAffair.address.dxo.ChangeAddressApplyDxo;
import services.generalAffair.address.dxo.MPrefectureDxo;
import services.generalAffair.address.entity.MPrefecture;
import services.generalAffair.address.entity.MStaffAddress;
import services.generalAffair.address.entity.StaffAddressHistory;
import services.generalAffair.entity.VCurrentStaffName;


/**
 * 住所変更サービス
 * 住所変更を扱うサービスです。
 * 
 * @author t-ito
 *
 */
public class ChangeAddressApplyService {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;
	
	/**
	 * 社員住所情報変換Dxoです。。
	 */
	public ChangeAddressApplyDxo changeAddressApplyDxo;
	
	/**
	 * 都道府県名変換Dxoです。。
	 */
	public MPrefectureDxo mPrefectureDxo;
	
	
	/**
	 * 承認済社員住所取得処理。
	 * 
	 * @return 社員住所リスト
	 */
	public List<ChangeAddressApplyDto> getStaffAddress(Integer staffId){
		/** 検索実行 */
		List<StaffAddressHistory> StaffAddressHistory =
			jdbcManager.from(StaffAddressHistory.class)
				.innerJoin("vCurrentStaffName")
				.innerJoin("mStaffAddressStatus")
				.innerJoin("mStaffAddressAction")
				.leftOuterJoin("mStaffAddress")
				.leftOuterJoin("mStaffAddress.mPrefecture")
				.where("(staffId, addressUpdateCount) in (" +
						"   select staff_id, max(address_update_count)" +
						"   from STAFF_ADDRESS_HISTORY J1" +
						"   inner join (" +
						"     select staff_id AS staff" +
						"	  , address_update_count AS address" +
						"     , max(history_update_count) AS history" +
						"     from STAFF_ADDRESS_HISTORY" +
						"     group by staff_id, address_update_count" +
						"   ) AS J2" +
						"   on (J2.staff, J2.address, J2.history)" +
						"    = (J1.staff_id, J1.address_update_count, J1.history_update_count)" +
						"   Where address_status_id = 7" +
						"   group by staff_id" +
						" ) and staffId = " + staffId + ""
				)
				.orderBy("historyUpdateCount desc")
				.getResultList();
		
		/** データの変換 */
		List<ChangeAddressApplyDto> result = changeAddressApplyDxo.convert(StaffAddressHistory);
		
		return result;
	}
	
	
	/**
	 * 承認済以外社員住所取得処理。
	 * 
	 * @return 社員住所リスト
	 */	
	public List<ChangeAddressApplyDto> getNewStaffAddress(Integer staffId) {
		/** 検索実行 */
		List<StaffAddressHistory> StaffAddressHistory =
			jdbcManager.from(StaffAddressHistory.class)
				.innerJoin("vCurrentStaffName")
				.innerJoin("mStaffAddressStatus")
				.innerJoin("mStaffAddressAction")
				.leftOuterJoin("mStaffAddress")
				.leftOuterJoin("mStaffAddress.mPrefecture")
				.where("(staffId, addressUpdateCount) in (" +
						"   select staff_id, max(address_update_count)" +
						"   from STAFF_ADDRESS_HISTORY J1" +
						"   inner join (" +
						"     select staff_id AS staff" +
						"	  , address_update_count AS address" +
						"     , max(history_update_count) AS history" +
						"     from STAFF_ADDRESS_HISTORY" +
						"     group by staff_id, address_update_count" +
						"   ) AS J2" +
						"   on (J2.staff, J2.address, J2.history)" +
						"    = (J1.staff_id, J1.address_update_count, J1.history_update_count)" +
						"   Where address_status_id <> 7" +
						"   group by staff_id" +
						" ) and staffId = " + staffId + ""
				)
				.orderBy("historyUpdateCount desc")
				.getResultList();
		
		/** データの変換 */
		List<ChangeAddressApplyDto> result = changeAddressApplyDxo.convert(StaffAddressHistory);
		
		return result;
	}
	
	
	/**
	 *提出一覧取得処理。
	 * 
	 * @return 提出一覧
	 */
	//追加 @auther okamoto
	public List<ChangeAddressApplyDto> getStaffAddressApproval(){
		/** 検索実行 */
		List<StaffAddressHistory> StaffAddressHistory =
			jdbcManager.from(StaffAddressHistory.class)
			.innerJoin("vCurrentStaffName")
			.innerJoin("mStaffAddressStatus")
			.innerJoin("mStaffAddressAction")
			.leftOuterJoin("mStaffAddress")
			.leftOuterJoin("mStaffAddress.mPrefecture")
			.leftOuterJoin("staffAddressPresentTime")
			//変更前
/*			.where("(staffId, addressUpdateCount, historyUpdateCount) in (" +
					"   select staff_id, max(address_update_count), max(history_update_count)" +
					"   from STAFF_ADDRESS_HISTORY J1" +
					"   inner join (" +
					"     select staff_id AS staff" +
					"	  , address_update_count AS address" +
					"     , max(history_update_count) AS history" +
					"     from STAFF_ADDRESS_HISTORY" +
					"     group by staff_id, address_update_count" +
					"   ) AS J2" +
					"   on (J2.staff, J2.address, J2.history)" +
					"    = (J1.staff_id, J1.address_update_count, J1.history_update_count)" +
					"	group by staff_id" +
					" )"
			)
*/							
			//住所更新回数が最大のリストを作成
			.where("(staffId, addressUpdateCount, historyUpdateCount) in (" +
						"   select staff_id, address_update_count, history_update_count" +
						"   from STAFF_ADDRESS_HISTORY J1" +
						"   inner join (" +
						"     select staff_id AS staff" +
						"	  , max(address_update_count) AS address" +
						"     from STAFF_ADDRESS_HISTORY" +
						"     group by staff_id" +
						"   ) AS J2" +
						"	on (J2.staff, J2.address) = (J1.staff_id, J1.address_update_count)" +
						"	group by staff_id, address_update_count, history_update_count" +
						" )"
			)
				.orderBy("staffId, addressUpdateCount, historyUpdateCount")
				.getResultList();
		
		/** データの変換 */
		List<ChangeAddressApplyDto> result = changeAddressApplyDxo.convert(StaffAddressHistory);
		
		//リストの最後の社員名と履歴更新回数を記憶(ループ脱出用)
		String lastName = result.get(result.size() - 1).fullName;
		int lastCount = result.get(result.size() - 1).historyUpdateCount;
		
		int i = 0;
		//履歴更新回数が最大のもの以外をリストから削除
		while(true){
			if(result.get(i).fullName == result.get(i+1).fullName){
				result.remove(i);
			}else{
				i = i + 1;
			}
			//リストの最後まできたらループから抜ける
			if(result.get(i).fullName == lastName && result.get(i).historyUpdateCount == lastCount)	break;			
		}

		return result;
	}

	
	/**
	 *都道府県名リスト取得処理。
	 * 
	 * @return 都道府県名リスト
	 */	
	public List<MPrefectureDto> getMPrefecture(){
		/** 検索実行 */
		List<MPrefecture> MPrefecture =
			jdbcManager.from(MPrefecture.class)
				.getResultList();
		
		/** データの変換 */
		List<MPrefectureDto> result = mPrefectureDxo.convert(MPrefecture);
		
		return result;
	}
	

	/**
	 * 社員住所登録処理。
	 * 対象社員の住所を追加または更新します。
	 * 
	 * @param staffId 社員ID
	 * @param sendData 社員住所情報
	 * @param historyUpdate 履歴更新回数
	 */	
	public void renewStaffAddress(Integer staffId, ChangeAddressApplyDto sendData, Integer historyUpdate)
	{
		//////////////////////////////////////////////////
		// 引数を元にエンティティを作成
		//////////////////////////////////////////////////
		/** 現在時刻 */
		Timestamp curTimes = new Timestamp(System.currentTimeMillis());	
		
		/** Dtoからエンティティへ変換 */
		MStaffAddress renewMStaffAddress = changeAddressApplyDxo.convertMtaffAddress(sendData);

		/** 登録者 */
		renewMStaffAddress.registrantId = staffId;
		/** 登録日時 */
		renewMStaffAddress.registrationTime = curTimes;
		
		//////////////////////////////////////////////////
		// 社員住所の追加
		//////////////////////////////////////////////////
		/** 履歴更新回数が0回ならINSERT、1回以上ならUPDATE実行 */
		if(historyUpdate == 0){
			jdbcManager.insert(renewMStaffAddress).execute();
			/** 履歴の追加(作成) */
			insertStaffAddressHistory(staffId, sendData, 1, 1, curTimes);
		}else{
			jdbcManager.update(renewMStaffAddress).execute();
			/** 履歴の追加(追加) */
			insertStaffAddressHistory(staffId, sendData, 4, sendData.addressStatusId, curTimes);
		}
	}	
	

	/**
	 * 履歴更新処理。
	 * 住所の履歴を更新します。
	 * 
	 * @param staffId 履歴更新社員ID
	 * @param sendData 社員住所情報
	 * @param actionId 登録動作種別
	 * @param statusId 登録状況種別
	 * @param curTimes 登録日時(住所登録時間と時間を合わせるため)
	 */	
	public void insertStaffAddressHistory(Integer staffId, ChangeAddressApplyDto sendData, Integer actionId, Integer statusId, Timestamp curTimes)
	{
		//////////////////////////////////////////////////
		// 引数を元にエンティティを作成
		//////////////////////////////////////////////////
		/** Dtoからエンティティへ変換 */	
		StaffAddressHistory insertStaffAddressHistory = changeAddressApplyDxo.convertStaffAddressHistory(sendData);
		MStaffAddress insertMStaffAddress = changeAddressApplyDxo.convertMtaffAddress(sendData);
		/** 登録者氏名 */
		VCurrentStaffName vCurrentStaffName =
			jdbcManager.from(VCurrentStaffName.class)
			.where(new SimpleWhere().eq("staffId", insertStaffAddressHistory.staffId))
			.getSingleResult();
		
		/** 履歴に登録する各情報 */
		insertStaffAddressHistory.addressUpdateCount = insertMStaffAddress.updateCount;
		insertStaffAddressHistory.historyUpdateCount = insertStaffAddressHistory.historyUpdateCount + 1;
		insertStaffAddressHistory.addressActionId    = actionId;
		insertStaffAddressHistory.addressStatusId    = statusId;
		insertStaffAddressHistory.registrantId       = staffId;
		insertStaffAddressHistory.registrationTime   = curTimes;
		insertStaffAddressHistory.registrantName     = vCurrentStaffName.fullName;

		//////////////////////////////////////////////////
		// 履歴の追加
		//////////////////////////////////////////////////
		jdbcManager.insert(insertStaffAddressHistory).execute();		
	}
	
	/**
	 * 履歴更新処理。
	 * 住所の履歴を更新します。
	 * 
	 * @param staffId 履歴更新社員ID
	 * @param sendData 社員住所情報
	 * @param actionId 登録動作種別
	 * @param statusId 登録状況種別
	 */	
	public void insertStaffAddressHistory(Integer staffId, ChangeAddressApplyDto sendData, Integer actionId, Integer statusId)
	{
		//////////////////////////////////////////////////
		// 履歴更新処理をオーバーロードする
		//////////////////////////////////////////////////
		insertStaffAddressHistory(staffId, sendData, actionId, statusId, new Timestamp(System.currentTimeMillis()));
	}
}
