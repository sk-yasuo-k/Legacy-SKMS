package servlet.generalAffair.workingConditions;

import java.io.IOException;
import java.lang.reflect.Field;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.seasar.framework.container.SingletonS2Container;


import services.generalAffair.entity.WorkingHoursMonthly;
import services.generalAffair.workingConditions.dto.MStaffDto;
import services.generalAffair.workingConditions.dto.WorkingAllConditions;
import services.generalAffair.workingConditions.service.WorkingConditionsService;

public class WorkingConditionsCsvFileExport extends HttpServlet {
	
	static final long serialVersionUID = 1L;
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException
	{
		//送信データをparse
		WorkingAllConditions workingAllConditions =  this.createWorkingAllConditions(req);
		
		String csvString = new String();
		//該当期間のすべての社員の集計データ取得
		//1ヶ月集計かどうか
		if( workingAllConditions.isOnlyOneMonth == null){
			return;
		}if( workingAllConditions.isOnlyOneMonth ){
			csvString = this.createMonthlyCsvString(workingAllConditions);
		}else{
			//現状は1ヶ月集計以外は未実装
			return;
		}
		
		//csvファイル用stream作成
		resp.setHeader("Content-Type", "charset=UTF-8");
		resp.setHeader("Content-Disposition",
			"attachment;filename=\"csvdata.csv\"");
		resp.setContentType("application/octet-stream");
		//stream用データ作成
		byte[] downloadData = csvString.getBytes();
		//stream送信
		resp.getOutputStream().write(downloadData);
		//close stream
		resp.getOutputStream().close();
	}
	
	
	/**
	 * 送信されたデータをparse
	 * @param req
	 * @return parse結果
	 */
	private WorkingAllConditions createWorkingAllConditions(HttpServletRequest req){
		
		try{
			WorkingAllConditions workingAllConditions = new WorkingAllConditions();
			Class<?> conditions = workingAllConditions.getClass();

			Field[] fields = conditions.getFields();
			//WorkingAllConditionsの各フィールドの型に依存
			for(Field field : fields){
				if( field.getType() == boolean.class || field.getType() == Boolean.class ){
					field.set(workingAllConditions, Boolean.parseBoolean((String)req.getParameter(field.getName())));
				}else if(field.getType() == Date.class){
					//日付の型は送信元にあわせる
					DateFormat ft = new SimpleDateFormat("yyyy/MM/dd");
					field.set(workingAllConditions, ft.parse(req.getParameter(field.getName())));
				}else if(field.getType() == List.class){
					//配列の場合現状はIntegerのみ
					//他の型を使いたかったらここで判定追加
					String[] tmpList = ((String)req.getParameter(field.getName())).split(",");
					ArrayList<Integer> array = new ArrayList<Integer>();
					for( String var : tmpList ){
						array.add(Integer.parseInt(var));
					}
					field.set(workingAllConditions, array);
				}
			}
			
			return workingAllConditions;
			
		}catch (Exception e) {
			//本来無いはずだけど、へんなデータを送信された場合など
			e.printStackTrace();
			
			return new WorkingAllConditions();
		}
		
	}
	
	/**
	 * 1ヶ月集計時のcsvデータ(型)作成
	 * @param workingAllConditions
	 * @return 集計結果のcsvデータ(String型)
	 */
	private String createMonthlyCsvString(WorkingAllConditions workingAllConditions){
		
		//社員名一覧
		List<MStaffDto> staffNameList = null;
		//集計データ
		List<WorkingHoursMonthly> AggregateList;

		//勤務状況集計オブジェクト取得
		WorkingConditionsService workingConditionsService = SingletonS2Container.getComponent(WorkingConditionsService.class);
		//集計データ取得
		AggregateList = workingConditionsService.getStaffWorkingHoursMonthlyList(workingAllConditions.startDate);

		
		//出力する文字列作成
		//header部分作成
		//社員IDと社員名を出力
		String csvString = "staffid,staffFullName";
				
		//出力する項目名だけ出力
		Class<?> workingClass = workingAllConditions.getClass();
		Field[] fields = workingClass.getFields();
		//すべての出力項目名分ループ
		for(Field field : fields){
			try{
				//条件判定がbooleanの時は出力項目
				if(field.getType() == boolean.class){
					//出力フィールドが出力かつ、1ヶ月集計フラグ以外なら、フィールド名を出力
					if((Boolean)field.get(workingAllConditions)){
						csvString += "," + field.getName() ;
					}
				}
			}catch(IllegalAccessException e){
				//値取得失敗時
				e.printStackTrace();			
			}
		}
		//改行コード
		String BR = System.getProperty("line.separator");
		//改行
		csvString += BR;
		
		//内容作成
		//社員一人分のデータ格納
		String empData;
		Boolean noDate;
		//表示する人数分のループ
		for(Integer staffId : workingAllConditions.showStaffList){
			noDate = true;
			//指定された期間の集計された社員分のループ
			for(WorkingHoursMonthly staffData : AggregateList){
				//表示する社員かどうか
				if( staffData.staffId == staffId ){
					//集計データに該当データあり
					noDate = false;
					//社員IDと社員名は先に記述
					empData = Integer.toString(staffData.staffId) + "," + staffData.staffName.fullName ;
					//月別集計結果クラスのクラスを取得
					Class<?> workinghoursMonthlyClass = staffData.getClass();
					//出力項目分ループ
					for(Field field : fields){
						try{
							//フィールドがboolean型なら、出力条件1満たす
							if( field.getType() == boolean.class ){
								//フィールドの値がtrueでかつ1ヶ月集計フラグ以外なら出力条件完全一致
								if((Boolean)field.get(workingAllConditions)){
									Field f = workinghoursMonthlyClass.getField(field.getName());
									empData += "," + f.get(staffData).toString();
								}
							}
						}catch(Exception e){
							e.printStackTrace();
						}
					}
					csvString += empData + BR;
					break;
				}
			}
			//集計データにデータが無いけど、表示設定の社員用
			if( noDate ){
				empData = new String();
				if(staffNameList == null){
					//社員名一覧取得
					staffNameList = workingConditionsService.getStaffNameList();
				}

				for( MStaffDto mstaffDto : staffNameList ){
					if( mstaffDto.staffId == staffId ){
						empData = Integer.toString(mstaffDto.staffId) + "," + mstaffDto.staffFullName;
						break;
					}
				}
				//フィールドの数だけ0を作成
				for(Field field : fields){
					try{
						if( field.getType() == boolean.class ){
							if((Boolean)field.get(workingAllConditions)){
								empData += ",0" ;
							}
						}
					}catch(Exception e){
						e.printStackTrace();
					}
				}
				csvString += empData + BR;				
			}
			
		}

		
		return csvString;
	}

}
