package services.generalAffair.dxo;

import services.generalAffair.dto.LunchOptionChoicesDto;
import services.generalAffair.entity.MLunchOptionChoices;

/**
 * ランチオプション選択肢情報変換Dxoです。
 * 
 * @author yasuo-k
 * 
 */
public interface LunchOptionChoicesDxo {

	/**
	 * ランチオプション選択肢情報エンティティからランチオプション選択肢情報Dtoへ変換.
	 *
	 * @param src ランチオプション選択肢情報エンティティ
	 * @param dst ランチオプション選択肢情報Dto
	 */
	public void convert(MLunchOptionChoices src, LunchOptionChoicesDto dst);
}
