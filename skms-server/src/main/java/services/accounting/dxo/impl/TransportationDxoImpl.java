package services.accounting.dxo.impl;

import java.util.ArrayList;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;

import services.accounting.dto.HistoryDto;
import services.accounting.dto.TransportationDetailDto;
import services.accounting.dto.TransportationDto;
import services.accounting.dxo.TransportationDxo;
import services.accounting.entity.Transportation;
import services.accounting.entity.TransportationDetail;
import services.accounting.entity.TransportationHistory;
import services.generalAffair.entity.MStaff;

/**
 * 交通費申請情報変換Dxo実装クラスです。
 *
 * @author yasuo-k
 *
 */
public class TransportationDxoImpl implements TransportationDxo {

	/**
	 * JDBCマネージャです。
	 */
	public JdbcManager jdbcManager;

	/**
	 * 交通費申請情報Dtoから交通費申請情報エンティティへ変換.<br>
	 * 交通費申請明細情報リストの変換あり.
	 *
	 * @param src   交通費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 交通費申請情報エンティティ
	 */
	public Transportation convertCreate(TransportationDto src, MStaff staff)
	{
		// transportationを作成する。
		Transportation dst = new Transportation(src, staff);
		// 交通費申請IDは採番する。
		int nextTransId = nextval_transportationId();
		dst.transportationId= nextTransId;


		// transportation_detailを作成する。
		dst.transportationDetails = new ArrayList<TransportationDetail>();
		int index = 1;
		for (TransportationDetailDto detailDto: src.transportationDetails)
		{
			// 新規追加のものだけを追加する。
			if (!detailDto.isNew())		continue;

			TransportationDetail detail = new TransportationDetail(detailDto);

			// 交通費申請明細連番は内部で採番する。
			detail.transportationId  = nextTransId;
			detail.sequenceNo        = index;
			detail.registrantId      = dst.registrantId;
			index++;

			dst.transportationDetails.add(detail);
		}
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請情報エンティティへ変換.<br>
	 * 交通費申請明細情報リストの変換なし.
	 *
	 * @param src 交通費申請情報Dto
	 * @param staff ログイン社員情報
	 * @return Transportation 交通費申請情報エンティティ
	 */
	public Transportation convertUpdate(TransportationDto src, MStaff staff)
	{
		Transportation dst = new Transportation(src);
		dst.registrantId	= staff.staffId;
		return dst;
	}

	/**
	 * 交通費申請情報Dtoから交通費申請情報エンティティへ変換.<br>
	 * 交通費申請明細情報リストの変換なし.
	 *
	 * @param src 交通費申請情報Dto
	 * @return Transportation 交通費申請情報エンティティ
	 */
	public Transportation convertDelete(TransportationDto src)
	{
		Transportation dst = new Transportation(src);
		return dst;
	}

	/**
	 * 交通費申請情報エンティティリストから交通費申請情報Dtoリストへ変換.<br>
	 * 交通費申請明細情報リストの変換あり.
	 *
	 * @param src   交通費申請情報エンティティリスト
	 * @param staff ログイン社員情報エンティティ
	 * @return List<TransportationDto> 交通費申請情報Dtoリスト
	 */
	public List<TransportationDto> convertGetTransportations(List<Transportation> translist, int type, MStaff staff)
	{
		List<TransportationDto> dstList = new ArrayList<TransportationDto>();
		for (Transportation trans : translist) {
			dstList.add(convertGetTransportation(trans, type, staff));
		}
		return dstList;
	}

	/**
	 * 交通費申請情報エンティティから交通費申請情報Dtoへ変換.<br>
	 * 交通費申請明細情報リストの変換あり.
	 *
	 * @param src   交通費申請情報エンティティ
	 * @param staff ログイン社員情報エンティティ
	 * @return TransportationDto 交通費申請情報Dto
	 */
	public TransportationDto convertGetTransportation(Transportation src, int type, MStaff staff)
	{
		// 交通費申請情報エンティティが未設定のときは null を返す。
		if (src == null) {
			return null;
		}

		// transportationを設定する。
		TransportationDto dst = new TransportationDto(src, staff);


		// transportation_detailを設定する。
		dst.transportationDetails = new ArrayList<TransportationDetailDto>();
		int total = 0;
		for (TransportationDetail transDetail : src.transportationDetails) {
			TransportationDetailDto transDetailDto = new TransportationDetailDto(transDetail);
			dst.transportationDetails.add(transDetailDto);

			// 合計金額を計算する。
			if (transDetail.expense != null) {
				total += transDetail.expense;
			}
		}
		dst.transportationTotal = Integer.toString(total);


		// transportation_historyを設定する。
		dst.transportationHistorys = new ArrayList<HistoryDto>();
		for (TransportationHistory history : src.transportationHistorys) {
			HistoryDto historyDto = new HistoryDto(history);
			dst.transportationHistorys.add(historyDto);
		}
		if (src.transportationHistorys != null && src.transportationHistorys.size() > 0) {
			// 最新の履歴を取得する。
			TransportationHistory transHistory = src.transportationHistorys.get(0);

			// 申請状況を設定する。
			dst.setStatus(transHistory, type, staff);
		}
		return dst;
	}

	/**
	 * Next交通費申請IDの発行.
	 *
	 * @return int Next交通費申請ID
	 */
	private int nextval_transportationId() {
		return jdbcManager.selectBySql(Integer.class, "select nextval('transportation_transportation_id_seq')").getSingleResult();
	}

}