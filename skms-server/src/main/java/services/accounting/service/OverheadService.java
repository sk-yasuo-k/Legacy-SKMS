package services.accounting.service;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.seasar.extension.jdbc.JdbcManager;
import org.seasar.extension.jdbc.where.SimpleWhere;
import org.seasar.framework.container.SingletonS2Container;
import org.seasar.framework.container.annotation.tiger.Binding;

import dto.LabelDto;
import enumerate.DepartmentId;
import enumerate.OverheadStatusId;
import enumerate.ProjectPositionId;

import services.accounting.entity.Equipment;
import services.accounting.entity.MAccountItem;
import services.accounting.entity.MCreditCard;
import services.accounting.entity.MEquipmentKind;
import services.accounting.entity.MJanre;
import services.accounting.entity.MOffice;
import services.accounting.entity.MOverheadStatus;
import services.accounting.entity.MOverheadType;
import services.accounting.entity.MPayment;
import services.accounting.entity.MPcKind;
import services.accounting.entity.Overhead;
import services.accounting.entity.OverheadDetail;
import services.accounting.entity.OverheadHistory;
import services.accounting.dto.OverheadDetailDto;
import services.accounting.dto.OverheadDto;
import services.accounting.dto.OverheadSearchDto;
import services.accounting.dxo.EquipmentDxo;
import services.accounting.dxo.LabelDxo;
import services.accounting.dxo.OverheadDetailDxo;
import services.accounting.dxo.OverheadDxo;

import services.generalAffair.entity.MStaff;
import services.generalAffair.service.StaffService;
import services.generalAffair.service.WholeBusinessService;
import services.mail.mai.MailOverheadDto;
import services.mail.mai.SkmsMai;
import services.project.entity.Project;
import services.project.entity.ProjectMember;
import services.project.service.ProjectService;


/**
 * 諸経費を扱うサービスです.
 *
 * @author yasuo-k
 *
 */
public class OverheadService {


	/**
	 * JDBCマネージャです.
	 */
	public JdbcManager jdbcManager;

	/**
	 * メール送信オブジェクト.
	 */
    public SkmsMai skmsMai;

	/**
	 * La!cooda用のJDBCマネージャです.
	 */
	@Binding("jdbcManagerB")
	public JdbcManager jdbcManagerWiz;


	/**
	 * 諸経費申請Dxoです.
	 */
	public OverheadDxo overheadDxo;

	/**
	 * 諸経費申請明細Dxoです.
	 */
	public OverheadDetailDxo overheadDetailDxo;

	/**
	 * 設備Dxoです.
	 */
	public EquipmentDxo equipmentDxo;

	/**
	 * ラベルDxoです.
	 */
	public LabelDxo labelDxo;


	/**
	 * 申請対象の諸経費申請のリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @param search 検索条件.
	 * @return 諸経費申請のリスト.
	 */
	public  List<OverheadDto> getRequestOverheads(MStaff staff, OverheadSearchDto search) throws Exception
	{
		// 未設定は Exception とする.
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_search(search);


		// 検索条件に一致する諸経費を取得する.
		List<Overhead> overheadlist = jdbcManager.from(Overhead.class)
											.innerJoin("projectE",
															new SimpleWhere().in("projectId", search.projectList.toArray()) )
											.innerJoin("overheadHistorys",
															"overheadHistorys.updateCount = (select max(H1_.update_count) from overhead_history H1_ where H1_.overhead_id = overheadId)")
											.innerJoin("overheadHistorys.overheadStatus",
															new SimpleWhere().in("overheadHistorys.overheadStatusId", search.statusList.toArray()) )
											.where(new SimpleWhere().eq("staffId", staff.staffId))
											.orderBy("overheadId")
											.getResultList();

		// 諸経費申請IDリストを作成する.
		ArrayList<Integer> overheaditems = new ArrayList<Integer>();
		overheaditems.add(-99);
		for (Overhead overhead : overheadlist) {
			overheaditems.add(overhead.overheadId);
		}

		// 諸経費リストを取得する.
		List<Overhead> list = getOverheads(overheaditems);
		// 諸経費Dtoリストに変換する.
		List<OverheadDto> overheads = new ArrayList<OverheadDto>();
		for (Overhead overhead : list) {
			OverheadDto convert = overheadDxo.convert(overhead, staff);
			overheads.add(convert);
		}
		return overheads;
	}


	/**
	 * 承認対象の諸経費申請のリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @param search 検索条件.
	 * @return 諸経費申請のリスト.
	 */
	public  List<OverheadDto> getApprovalOverheads(MStaff staff, OverheadSearchDto search) throws Exception
	{
		// 未設定は Exception とする.
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_search(search);


		// 検索条件に一致する諸経費を取得する.
		List<Overhead> overheadlist;
		if (search.subordinateOnly) {
			overheadlist = jdbcManager.from(Overhead.class)
											.innerJoin("projectE",
															new SimpleWhere().in("projectId", search.projectList.toArray()) )
											.leftOuterJoin("overheadDetails")
											.innerJoin("overheadHistorys",
															"overheadHistorys.updateCount = (select max(H1_.update_count) from overhead_history H1_ where H1_.overhead_id = overheadId)")
											.innerJoin("overheadHistorys.overheadStatus",
															new SimpleWhere().in("overheadHistorys.overheadStatusId", search.statusList.toArray()) )
											.where("projectE.projectType = 0 or exists"
													+ " ("
													+ 	" select project.project_id from project, project_member"
													+	" where project_member.staff_id = staffId"
													+	" and project.project_id = project_member.project_id"
													+	" and project.delete_flg = false"
													+	" and ("
													+			"overheadDetails.overheadDate >= actual_join_date"
													+			" and (overheadDetails.overheadDate <= actual_retire_date or actual_retire_date is null)"
													+		")"
													+	" and project.project_id in "
													+ 	" ("
													+		"select project_id from project_member where staff_id = ? and project_position_id = ?"
													+	" )"
													+ " )"
												, staff.staffId
												, ProjectPositionId.PM)
											.orderBy("overheadId")
											.getResultList();
		}
		else {
			overheadlist = jdbcManager.from(Overhead.class)
											.innerJoin("projectE",
															new SimpleWhere().in("projectId", search.projectList.toArray()) )
											.leftOuterJoin("projectE.projectMembers",
															new SimpleWhere().eq("projectE.projectMembers.staffId", staff.staffId)
																			 .eq("projectE.projectMembers.projectPositionId", ProjectPositionId.PM) )
											.innerJoin("overheadHistorys",
															"overheadHistorys.updateCount = (select max(H1_.update_count) from overhead_history H1_ where H1_.overhead_id = overheadId)")
											.innerJoin("overheadHistorys.overheadStatus",
															new SimpleWhere().in("overheadHistorys.overheadStatusId", search.statusList.toArray()) )
											.orderBy("overheadId")
											.getResultList();
		}
		// 諸経費申請IDリストを作成する.
		ArrayList<Integer> overheaditems = new ArrayList<Integer>();
		overheaditems.add(-99);
		for (Overhead overhead : overheadlist) {
			overheaditems.add(overhead.overheadId);
		}

		// 諸経費リストを取得する.
		List<Overhead> list = getOverheads(overheaditems);
		// 諸経費Dtoリストに変換する.
		List<OverheadDto> overheads = new ArrayList<OverheadDto>();
		for (Overhead overhead : list) {
			OverheadDto convert = overheadDxo.convert(overhead, staff);
			overheads.add(convert);
		}
		return overheads;
	}

	/**
	 * 総務承認対象の諸経費申請のリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @param search 検索条件.
	 * @return 諸経費申請のリスト.
	 */
	public  List<OverheadDto> getApprovalAfOverheads(MStaff staff, OverheadSearchDto search) throws Exception
	{
		// 未設定は Exception とする.
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_search(search);


		// 検索条件に一致する諸経費を取得する.
		List<Overhead> overheadlist = jdbcManager.from(Overhead.class)
											.innerJoin("projectE")
											.innerJoin("overheadHistorys",
															"overheadHistorys.updateCount = (select max(H1_.update_count) from overhead_history H1_ where H1_.overhead_id = overheadId)")
											.innerJoin("overheadHistorys.overheadStatus",
															new SimpleWhere().in("overheadHistorys.overheadStatusId", search.statusList.toArray()) )
											.orderBy("overheadId")
											.getResultList();

		// 諸経費申請IDリストを作成する.
		ArrayList<Integer> overheaditems = new ArrayList<Integer>();
		overheaditems.add(-99);
		for (Overhead overhead : overheadlist) {
			overheaditems.add(overhead.overheadId);
		}

		// 諸経費リストを取得する.
		List<Overhead> list = getOverheads(overheaditems);
		// 諸経費Dtoリストに変換する.
		List<OverheadDto> overheads = new ArrayList<OverheadDto>();
		for (Overhead overhead : list) {
			OverheadDto convert = overheadDxo.convert(overhead, staff);
			overheads.add(convert);
		}
		return overheads;
	}

	/**
	 * 諸経費申請のリストを返します.
	 *
	 * @param overheaditems 諸経費申請IDリスト.
	 * @return 諸経費申請のリスト.
	 */
	private List<Overhead> getOverheads(List<Integer> overheaditems) throws Exception
	{
		List<Overhead> list = jdbcManager.from(Overhead.class)
											.innerJoin("projectE")
											.innerJoin("staff")
											.innerJoin("staff.staffName")
											.leftOuterJoin("overheadDetails")
											.leftOuterJoin("overheadDetails.payment")
											.leftOuterJoin("overheadDetails.paymentCreditCard")
											.leftOuterJoin("overheadDetails.account")
											.leftOuterJoin("overheadDetails.type")
											.leftOuterJoin("overheadDetails.equipment")
											.innerJoin("overheadHistorys")
											.innerJoin("overheadHistorys.overheadStatus")
											.where(new SimpleWhere().in("overheadId", overheaditems.toArray()))
											.orderBy("overheadId, overheadDetails.overheadNo, overheadHistorys.updateCount desc")
											.getResultList();
		return list;
	}


	/**
	 * 諸経費区分の取得.
	 *
	 * @return ラベルリスト.
	 */
	public List<LabelDto> getOverheadType() throws Exception
	{
		List<MOverheadType> list = jdbcManager.from(MOverheadType.class)
											.orderBy("overheadTypeId")
											.getResultList();

		List<LabelDto> cnvlist = labelDxo.convertOverhedType(list);
		return cnvlist;
	}

	/**
	 * 設備種別の取得.
	 *
	 * @return ラベルリスト.
	 */
	public List<LabelDto> getEquipmentKind() throws Exception
	{
		List<MEquipmentKind> list = jdbcManager.from(MEquipmentKind.class)
											.orderBy("equipmentKindId")
											.getResultList();

		List<LabelDto> cnvlist = labelDxo.convertEquipmentKind(list);
		return cnvlist;
	}

	/**
	 * 支払方法の取得.
	 *
	 * @return ラベルリスト.
	 */
	public List<LabelDto> getPayment() throws Exception
	{
		List<MPayment> list = jdbcManager.from(MPayment.class)
											.orderBy("paymentId")
											.getResultList();

		List<LabelDto> cnvlist = labelDxo.convertPayment(list);
		return cnvlist;
	}

	/**
	 * 勘定科目の取得.
	 *
	 * @return ラベルリスト.
	 */
	public List<LabelDto> getAccountItem() throws Exception
	{
		List<MAccountItem> list = jdbcManager.from(MAccountItem.class)
											.orderBy("accountItemId")
											.getResultList();

		List<LabelDto> cnvlist = labelDxo.convertAccountItem(list);
		return cnvlist;
	}

	/**
	 * PC種別の取得.
	 *
	 * @return ラベルリスト.
	 */
	public List<LabelDto> getPcKind() throws Exception
	{
		List<MPcKind> list = jdbcManager.from(MPcKind.class)
											.orderBy("pcKindId")
											.getResultList();

		List<LabelDto> cnvlist = labelDxo.convertPckind(list);
		return cnvlist;
	}

	/**
	 * 社員の取得.
	 *
	 * @return ラベルリスト.
	 */
	public List<LabelDto> getStaff() throws Exception
	{
		// ProjectServiceに問い合わせる.
		ProjectService prjService = SingletonS2Container.getComponent(ProjectService.class);
		List<MStaff> list = prjService.getStaffList();

		List<LabelDto> cnvlist = labelDxo.convertStaff(list);
		return cnvlist;
	}

	/**
	 * 設置場所の取得.
	 *
	 * @return ラベルリスト.
	 */
	public List<LabelDto> getInstallationLocation() throws Exception
	{
		List<MOffice> list = jdbcManager.from(MOffice.class)
											.orderBy("officeId")
											.getResultList();

		List<LabelDto> cnvlist = labelDxo.convertInstallationLocation(list);
		return cnvlist;
	}

	/**
	 * クレジットカードの取得.
	 *
	 * @param ラベルリスト.
	 */
	public List<LabelDto> getCreditCard() throws Exception
	{
		List<MCreditCard> list = jdbcManager.from(MCreditCard.class)
											.orderBy("goodThru")
											.getResultList();

		List<LabelDto> cnvlist= labelDxo.convertCreditCard(list);
		return cnvlist;
	}

	/**
	 * ジャンルの取得.
	 *
	 * @param ラベルリスト.
	 */
	public List<LabelDto> getJanre() throws Exception
	{
		List<MJanre> list = jdbcManager.from(MJanre.class)
											.orderBy("sortOrder")
											.getResultList();

		List<LabelDto> cnvlist= labelDxo.convertJanre(list);
		return cnvlist;
	}


	/**
	 * 諸経費申請を登録する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @return 登録件数.
	 */
	public int createOverhead(MStaff staff, OverheadDto src) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead;
		OverheadDetail overheadD = null;
		int seqNo = 1;
		if (src.isUpdate()) {
			// 諸経費を更新する.
			overhead = overheadDxo.convertUpdate(src, staff);
			retnum += jdbcManager.update(overhead).execute();

			// 明細を削除→登録する.
			for (OverheadDetailDto detaildto : src.overheadDetails) {
				// 明細を削除する.
				if (detaildto.isUpdate() || detaildto.isDelete()) {
					overheadD = overheadDetailDxo.convertUpdate(detaildto, overhead);
					retnum += jdbcManager.delete(overheadD).execute();
				}

				// 設備情報を削除する.
				if (detaildto.equipment == null)	continue;
				if (detaildto.equipment.isUpdate() || detaildto.equipment.isDelete()) {
					Equipment equip = equipmentDxo.convertDelete(detaildto.equipment, staff);
					retnum += jdbcManager.delete(equip).execute();
				}
			}
			for (OverheadDetailDto detaildto : src.overheadDetails) {
				// 明細を登録する.
				if (detaildto.isUpdate() || detaildto.isNew()) {
					overheadD = overheadDetailDxo.convertCreate(detaildto, overhead, seqNo);
					retnum += jdbcManager.insert(overheadD).execute();
					seqNo++;
				}

				// 設備情報を登録する.
				if (detaildto.equipment == null)	continue;
				if (detaildto.equipment.isNew() || detaildto.equipment.isUpdate()) {
					Equipment equip = equipmentDxo.convertCreate(detaildto.equipment, staff, overheadD, overhead);
					retnum += jdbcManager.insert(equip).execute();
				}
			}
		}
		else if (src.isNew()) {
			// 諸経費を登録する.
			overhead = overheadDxo.convertCreate(src, staff);
			retnum += jdbcManager.insert(overhead).execute();

			// 明細を登録する.
			for (OverheadDetailDto detaildto : src.overheadDetails) {
				if (detaildto.isNew()) {
					overheadD = overheadDetailDxo.convertCreate(detaildto, overhead, seqNo);
					retnum += jdbcManager.insert(overheadD).execute();
					seqNo++;

					// 設備情報を登録する.
					retnum += createEquipment(detaildto, overheadD, overhead, staff);
				}
			}

			// 履歴を登録する.
			OverheadHistory history = overheadDxo.convertHistoryMake(overhead);
			retnum += jdbcManager.insert(history).execute();
		}
		return retnum;
	}

	/**
	 * 諸経費申請を削除する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @return 削除件数.
	 */
	public int deleteOverhead(MStaff staff, OverheadDto src) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertUpdate(src, staff);
		retnum += jdbcManager.delete(overhead).execute();
		for (OverheadDetailDto detaildto : src.overheadDetails) {
			OverheadDetail overheadD = overheadDetailDxo.convertUpdate(detaildto, overhead);

			// 設備情報を削除する.
			retnum += deleteEquipment(detaildto, overheadD, staff);
		}
		return retnum;
	}

//	/**
//	 * 諸経費申請を複製する.
//	 *
//	 * @param staff ログイン社員情報.
//	 * @param src 諸経費.
//	 * @return 削除件数.
//	 */
//	public int copyOverhead(MStaff staff, OverheadDto src) throws Exception
//	{
//		AccountingUtil.checkData_staff(staff);
//		AccountingUtil.checkData_overhead(src);
//
//		Overhead overhead = overheadDxo.convertCopy(src, staff);
//		return jdbcManager.delete(overhead).execute();
//	}

	/**
	 * 諸経費申請を申請する.
	 * →領収書Noを発行する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @return 更新件数.
	 */
	public int applyOverhead(MStaff staff, OverheadDto src) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertUpdate(src, staff);
		for (OverheadDetailDto detaildto : src.overheadDetails) {
			OverheadDetail overheadD = overheadDetailDxo.convertApply(detaildto, overhead);
			retnum += jdbcManager.update(overheadD).execute();

			// 設備情報を登録する.
			retnum += createEquipment(detaildto, overheadD, overhead, staff);
		}
		OverheadHistory history = overheadDxo.convertHistoryApply(overhead);
		retnum += createHistory(staff, overhead, history);

		// 諸経費申請時メール通知.
		sendMailOverheadApply(src, "", "applyOverhead");

		return retnum;
	}

	/**
	 * 諸経費申請を承認する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @return 更新件数.
	 */
	public int approvalOverhead(MStaff staff, OverheadDto src) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertUpdate(src, staff);
		for (OverheadDetailDto detaildto : src.overheadDetails) {
			OverheadDetail overheadD = overheadDetailDxo.convertApproval(detaildto, overhead);
			retnum += jdbcManager.update(overheadD).execute();

			// 設備情報を登録する.
			retnum += createEquipment(detaildto, overheadD, overhead, staff);
		}
		OverheadHistory history = overheadDxo.convertHistoryApproval(overhead, staff);
		retnum +=createHistory(staff, overhead, history);

		// 諸経費承認時メール通知.
		sendMailOverheadApproval(staff, src, "", "approvalOverhead");

		return retnum;
	}

	/**
	 * 諸経費申請を総務承認する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @return 更新件数.
	 */
	public int approvalAfOverhead(MStaff staff, OverheadDto src) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertUpdate(src, staff);
		for (OverheadDetailDto detaildto : src.overheadDetails) {
			OverheadDetail overheadD = overheadDetailDxo.convertApproval(detaildto, overhead);
			retnum += jdbcManager.update(overheadD).execute();

			// 設備情報を登録する.
			retnum += createEquipment(detaildto, overheadD, overhead, staff);
		}
		OverheadHistory history = overheadDxo.convertHistoryApprovalAf(overhead, staff);
		retnum += createHistory(staff, overhead, history);

		// 諸経費承認時メール通知.
		sendMailOverheadApproval(staff, src, "", "approvalOverhead");

		return retnum;
	}

	/**
	 * 諸経費申請の支払をする.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @return 更新件数.
	 */
	public int paymentOverhead(MStaff staff, OverheadDto src) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		Overhead overhead = overheadDxo.convertUpdate(src, staff);
		OverheadHistory history = overheadDxo.convertHistoryPayment(overhead, staff);

		// 諸経費支払時メール通知.
		sendMailOverheadPayment(staff, src, "", "paymentOverhead");

		return createHistory(staff, overhead, history);
	}

	/**
	 * 諸経費申請を受領する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @return 更新件数.
	 */
	public int acceptOverhead(MStaff staff, OverheadDto src) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		Overhead overhead = overheadDxo.convertUpdate(src, staff);
		OverheadHistory history = overheadDxo.convertHistoryAccept(overhead);
		// 諸経費受領時メール通知.
		sendMailOverheadAccept(src, "", "acceptOverhead");
		return createHistory(staff, overhead, history);
	}

	/**
	 * 諸経費申請履歴を登録する.
	 *
	 * @param staff ログイン社員情報.
	 * @param overhead 諸経費.
	 * @param history  履歴.
	 * @return 更新件数.
	 */
	private int createHistory(MStaff staff, Overhead overhead, OverheadHistory history) throws Exception
	{
		int retnum = 0;
		retnum += jdbcManager.update(overhead).excludes("overheadId", "projectId", "staffId").execute();
		retnum += jdbcManager.insert(history).execute();
		return retnum;
	}

	/**
	 * 諸経費申請の申請取り下げる.
	 * →領収書No.を破棄する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @param reason 理由.
	 * @return 更新件数.
	 */
	public int applyWithdrawOverhead(MStaff staff, OverheadDto src, String reason) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertUpdate(src, staff);
		for (OverheadDetailDto detaildto : src.overheadDetails) {
			OverheadDetail overheadD = overheadDetailDxo.convertApplyWithdraw(detaildto, overhead);
			retnum += jdbcManager.update(overheadD).includes("registrationVer", "receiptNo").execute();
		}
		OverheadHistory history = overheadDxo.convertHistoryApplyWithdraw(overhead, reason);
		retnum += createHistory(staff, overhead, history);

		// 諸経費申請取り下げ時メール通知.
		sendMailOverheadApply(src, reason, "applyWithdrawOverhead");

		return retnum;
	}

	/**
	 * 諸経費申請を承認を取り消す.
	 * →申請状態に戻るならば、管理番号破棄する.
	 *   承認状態に戻るならば、状態だけ変更する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @param reason 理由.
	 * @return 更新件数.
	 */
	public int approvalCancelOverhead(MStaff staff, OverheadDto src, String reason) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertWithdraw(src, staff);
		OverheadHistory history = overheadDxo.convertHistoryApprovalCancel(overhead, reason, staff);
		retnum += createHistory(staff, overhead, history);

		// 申請済みかどうか確認する.
		String applied = jdbcManager.selectBySql(String.class,
													"select vs_.staff_id || ',' || COALESCE(msp_.project_position_id, '-1') || ',' || COALESCE(msd_.department_id, '-1') as applied_csv, oh_.overhead_id, os_.overhead_status_id from overhead oh_" +
													" inner join v_current_overhead_status os_ on os_.overhead_id = oh_.overhead_id" +
													" inner join v_current_staff_name vs_ on vs_.staff_id = oh_.staff_id" +
													" left join m_staff_project_position msp_ on msp_.staff_id = vs_.staff_id and msp_.update_count = (select max(hp.update_count) from m_staff_project_position hp where hp.staff_id = msp_.staff_id)" +
													" left join m_staff_department_head msd_ on msd_.staff_id = vs_.staff_id and msd_.update_count = (select max(hd.update_count) from m_staff_department_head hd where hd.staff_id = msd_.staff_id)" +
													" where oh_.overhead_id = ? and os_.overhead_status_id = ? ",
													overhead.overheadId, OverheadStatusId.APPLIED)
													.getSingleResult();
		if (applied != null) {
			String items[] = applied.split(",");
			for (OverheadDetailDto detaildto : src.overheadDetails) {
				OverheadDetail overheadD = overheadDetailDxo.convertApprovalCancel(detaildto, overhead);
				if (Integer.parseInt(items[1]) != ProjectPositionId.PM  &&
					Integer.parseInt(items[2]) != DepartmentId.GENERAL_AFFAIR) {
					// 申請者が PM でも総務でもないとき.
					retnum += jdbcManager.update(overheadD).includes("registrationVer", "accountItemId").execute();
				}
				retnum += approvalCancelEquipment(detaildto, overheadD, staff);
			}
		}

		// 諸経費承認時メール通知.
		sendMailOverheadApproval(staff, src, reason, "approvalCancelOverhead");

		return retnum;
	}

	/**
	 * 諸経費申請を承認を取り消す.
	 * →領収書No、管理番号破棄する.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @param reason 理由.
	 * @return 更新件数.
	 */
	public int approvalWithdrawOverhead(MStaff staff, OverheadDto src, String reason) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertWithdraw(src, staff);
		OverheadHistory history = overheadDxo.convertHistoryApprovalWithdraw(overhead, reason, staff);
		retnum += createHistory(staff, overhead, history);

		// 申請者の役職を確認する.
		String position = jdbcManager.selectBySql(String.class,
													"select vs_.staff_id || ',' || COALESCE(msp_.project_position_id, '-1') || ',' || COALESCE(msd_.department_id, '-1') as applied_csv, oh_.overhead_id, os_.overhead_status_id from overhead oh_" +
													" inner join v_current_overhead_status os_ on os_.overhead_id = oh_.overhead_id" +
													" inner join v_current_staff_name vs_ on vs_.staff_id = oh_.staff_id" +
													" left join m_staff_project_position msp_ on msp_.staff_id = vs_.staff_id and msp_.update_count = (select max(hp.update_count) from m_staff_project_position hp where hp.staff_id = msp_.staff_id)" +
													" left join m_staff_department_head msd_ on msd_.staff_id = vs_.staff_id and msd_.update_count = (select max(hd.update_count) from m_staff_department_head hd where hd.staff_id = msd_.staff_id)" +
													" where oh_.overhead_id = ? ",
													overhead.overheadId)
													.getSingleResult();

		for (OverheadDetailDto detaildto : src.overheadDetails) {
			String items[] = position.split(",");
			OverheadDetail overheadD = overheadDetailDxo.convertApprovalWithdraw(detaildto, overhead);
			if (Integer.parseInt(items[1]) != ProjectPositionId.PM  &&
				Integer.parseInt(items[2]) != DepartmentId.GENERAL_AFFAIR) {
				// 申請者が PM でも総務でもないとき.
				retnum += jdbcManager.update(overheadD).includes("registrationVer", "receiptNo", "accountItemId").execute();
			}
			else {
				// 申請者が PM でも総務のとき.
				retnum += jdbcManager.update(overheadD).includes("registrationVer", "receiptNo").execute();
			}
			retnum += approvalWithdrawEquipment(detaildto, overheadD, staff);
		}

		// 諸経費承認時メール通知.
		sendMailOverheadApproval(staff, src, reason, "approvalWithdrawOverhead");

		return retnum;
	}

	/**
	 * 諸経費申請を支払を取り消す.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @param reason 理由.
	 * @return 更新件数.
	 */
	public int paymentCancelOverhead(MStaff staff, OverheadDto src, String reason) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertWithdraw(src, staff);
		OverheadHistory history = overheadDxo.convertHistoryPaymentCancel(overhead, reason, staff);
		retnum += createHistory(staff, overhead, history);
		// 諸経費支払時メール通知.
		sendMailOverheadPayment(staff, src, reason, "paymentCancelOverhead");
		return retnum;
	}

	/**
	 * 諸経費申請を受領を取り消す.
	 *
	 * @param staff ログイン社員情報.
	 * @param src 諸経費.
	 * @param reason 理由.
	 * @return 更新件数.
	 */
	public int acceptCancelOverhead(MStaff staff, OverheadDto src, String reason) throws Exception
	{
		AccountingUtil.checkData_staff(staff);
		AccountingUtil.checkData_overhead(src);

		int retnum = 0;
		Overhead overhead = overheadDxo.convertWithdraw(src, staff);
		OverheadHistory history = overheadDxo.convertHistoryAcceptCancel(overhead, reason, staff);
		retnum += createHistory(staff, overhead, history);
		// 諸経費受領時メール通知.
		sendMailOverheadAccept(src, reason, "acceptCancelOverhead");
		return retnum;
	}


	/**
	 * 設備を登録する.
	 *
	 * @param overheadDDto 諸経費詳細情報.
	 * @param overheadD    諸経費詳細情報.
	 * @param staff ログイン社員情報.
	 * @return 登録件数.
	 */
	protected int createEquipment(OverheadDetailDto overheadDDto, OverheadDetail overheadD, Overhead overheadParent, MStaff staff) throws Exception
	{
		if (overheadDDto.equipment == null)		return 0;

		int retnum = 0;
		if (overheadDDto.equipment.isNew()) {
			Equipment equip = equipmentDxo.convertCreate(overheadDDto.equipment, staff, overheadD, overheadParent);
			retnum += jdbcManager.insert(equip).execute();
		}
		else if (overheadDDto.equipment.isUpdate()) {
			Equipment equip = equipmentDxo.convertUpdate(overheadDDto.equipment, staff, overheadD, overheadParent);
			retnum += jdbcManager.update(equip).execute();
		}
		else if (overheadDDto.equipment.isDelete()){
			Equipment equip = equipmentDxo.convertDelete(overheadDDto.equipment, staff);
			retnum += jdbcManager.delete(equip).execute();
		}
		return retnum;
	}

	/**
	 * 設備を削除する.
	 *
	 * @param overheadDDto 諸経費詳細情報.
	 * @param overheadD    諸経費詳細情報.
	 * @param staff ログイン社員情報.
	 * @return 登録件数.
	 */
	protected int deleteEquipment(OverheadDetailDto overheadDDto, OverheadDetail overheadD, MStaff staff) throws Exception
	{
		if (overheadDDto.equipment == null)		return 0;

		if (overheadDDto.equipment.isUpdate() || overheadDDto.equipment.isDelete()) {
			Equipment equip = equipmentDxo.convertDelete(overheadDDto.equipment, staff);
			return jdbcManager.delete(equip).execute();
		}
		else {
			return 0;
		}
	}

	/**
	 * 設備の管理番号を破棄する.
	 *
	 * @param overheadDDto 諸経費詳細情報.
	 * @param overheadD    諸経費詳細情報.
	 * @param staff ログイン社員情報.
	 * @return 登録件数.
	 */
	protected int approvalCancelEquipment(OverheadDetailDto overheadDDto, OverheadDetail overheadD, MStaff staff) throws Exception
	{
		if (overheadDDto.equipment == null)		return 0;

		int retnum = 0;
		if (overheadDDto.equipment.isUpdate()) {
			Equipment equip = equipmentDxo.convertApprovalCancel(overheadDDto.equipment, staff, overheadD);
			retnum += jdbcManager.update(equip).includes("registrationVer", "managementNo").execute();
		}
		return retnum;
	}

	/**
	 * 設備の管理番号を破棄する.
	 *
	 * @param overheadDDto 諸経費詳細情報.
	 * @param overheadD    諸経費詳細情報.
	 * @param staff ログイン社員情報.
	 * @return 登録件数.
	 */
	protected int approvalWithdrawEquipment(OverheadDetailDto overheadDDto, OverheadDetail overheadD, MStaff staff) throws Exception
	{
		return approvalCancelEquipment(overheadDDto, overheadD, staff);
	}


	/**
	 * 検索条件 申請状態リストを返します.
	 *
	 * @return 申請状態リスト.
	 */
	public List<LabelDto> getRequestStatus() throws Exception
	{
		List<MOverheadStatus> list = getStatus();
		return labelDxo.convertOverheadRequestStatus(list);
	}

	/**
	 * 検索条件 申請状態リストを返します.
	 *
	 * @return 申請状態リスト.
	 */
	public List<LabelDto> getApprovalStatus() throws Exception
	{
		List<MOverheadStatus> list = getStatus();
		return labelDxo.convertOverheadApprovalStatus(list);
	}

	/**
	 * 検索条件 申請状態リストを返します.
	 *
	 * @return 申請状態リスト.
	 */
	public List<LabelDto> getApprovalAfStatus() throws Exception
	{
		List<MOverheadStatus> list = getStatus();
		return labelDxo.convertOverheadApprovalStatus(list);
	}

	/**
	 * 検索条件 申請状態リストを返します.
	 *
	 * @return 申請状態リスト.
	 */
	private List<MOverheadStatus> getStatus() throws Exception
	{
		List<MOverheadStatus> list = jdbcManager.from(MOverheadStatus.class)
											.orderBy("overheadStatusId")
											.getResultList();
		return list;
	}


	/**
	 * 検索条件 プロジェクトリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @return プロジェクトリスト.
	 */
	public List<LabelDto> getRequestProject(MStaff staff) throws Exception
	{
		// TransportationServiceに問い合わせる.
		TransportationService transService = SingletonS2Container.getComponent(TransportationService.class);
		return transService.getRequestProjectList(staff);
	}

	/**
	 * 検索条件 プロジェクトリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @return プロジェクトリスト.
	 */
	public List<LabelDto> getApprovalProject(MStaff staff) throws Exception
	{
		// TransportationServiceに問い合わせる.
		TransportationService transService = SingletonS2Container.getComponent(TransportationService.class);
		return transService.getApprovalProjectList(staff);
	}

	/**
	 * 検索条件 プロジェクトリストを返します.
	 *
	 * @param staff ログイン社員情報.
	 * @return プロジェクトリスト.
	 */
	public List<LabelDto> getApprovalAfProject(MStaff staff) throws Exception
	{
		// TransportationServiceに問い合わせる.
		TransportationService transService = SingletonS2Container.getComponent(TransportationService.class);
		return transService.getApprovalProjectList_AF(staff);
	}

	/**
	 * 検索条件 全社業務リストを返します.
	 *
	 * @return 全社業務リスト.
	 */
	public List<LabelDto> getAllBusiness() throws Exception
	{
		// WholeBusinessServiceに問い合わせる.
		WholeBusinessService wholeService = SingletonS2Container.getComponent(WholeBusinessService.class);
		List<Project> list = wholeService.getWholeBusinessList();
		return labelDxo.convertAllBusiness(list);
	}



	/**
	 * 諸経費申請時のメール通知を行う.
	 *
	 * @param  overDto		諸経費情報Dto.
	 * @param  reason		理由(申請取り下げ時のみ使用).
	 * @param  methodName	メール送信メソッド名.
	 */
	public void sendMailOverheadApply(OverheadDto overDto, String reason, String methodName) throws Exception
	{
		// 諸経費の取得.
		Overhead overhead = getOverhead(overDto);

		// メール送信メソッドの取得.
		Method method = skmsMai.getClass().getMethod(methodName, MailOverheadDto.class);
		// 諸経費メール送信用DTO生成.
		MailOverheadDto dto = new MailOverheadDto(overhead);
		// 理由のセット.
		dto.setReason(reason);

		// プロジェクト情報の取得.
//		ProjectService projectService = SingletonS2Container.getComponent(ProjectService.class);
//		Project project = projectService.getProjectInfo(overDto.projectId);
		Project project = overhead.projectE;
		// プロジェクト諸経費ならば.
		if (project.projectType == Project.PROJECT_TYPE_PROJECT) {
			for (ProjectMember member : project.projectMembers) {
				// PMかつメール通知有りならば.
				if (member.projectPositionId != null
					&& member.projectPositionId == ProjectPositionId.PM
					&& member.staff.staffSetting != null
					&& Boolean.TRUE.equals(member.staff.staffSetting.sendMailTransportation)) {
					// 諸経費申請時メール通知
					dto.setTo(member.staff.email);
					dto.setToName(member.staff.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
		// 全社的業務諸経費ならば.
		} else {
			// 総務部長一覧の取得.
			StaffService staffService = SingletonS2Container.getComponent(StaffService.class);
			List<MStaff> accountingManagerList
				= staffService.getDepartmentHeadList(DepartmentId.GENERAL_AFFAIR);
			for (MStaff accountingManager : accountingManagerList) {
				// メール通知有りならば.
				if (accountingManager.staffSetting != null
					&& Boolean.TRUE.equals(accountingManager.staffSetting.sendMailTransportation)) {
					// 諸経費申請時メール通知.
					dto.setTo(accountingManager.email);
					dto.setToName(accountingManager.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
		}
	}

	/**
	 * 諸経費承認時のメール通知を行う.
	 *
	 * @param  staff		承認者情報.
	 * @param  oversDto		諸経費情報Dto.
	 * @param  reason		理由(承認取り消し、差し戻し時のみ使用).
	 * @param  methodName	メール送信メソッド名.
	 */
	public void sendMailOverheadApproval(MStaff staff, OverheadDto overDto, String reason, String methodName) throws Exception
	{
		// 諸経費の取得.
		Overhead overhead = getOverhead(overDto);

		// メール送信メソッドの取得.
		Method method = skmsMai.getClass().getMethod(methodName, MailOverheadDto.class);
		// 諸経費メール送信用DTO生成.
		MailOverheadDto dto = new MailOverheadDto(overhead);
		// 理由のセット.
		dto.setReason(reason);

		// 承認種別のセット.
		if (staff.staffProjectPosition != null
				&& staff.staffProjectPosition.size() > 0
				&& staff.staffProjectPosition.get(0).projectPositionId == ProjectPositionId.PM) {
			dto.setApprovalType("PM");
		} else {
			dto.setApprovalType("総務");
		}
		// 承認者のセット.
		dto.setApprovalName(staff.staffName.fullName);

		// 申請者の環境設定取得.
//		SystemService systemService = SingletonS2Container.getComponent( SystemService.class );
//		StaffSetting staffSetting = systemService.getStaffSetting(overDto.staffId);
		MStaff applicant = overhead.staff;
		// 申請者に対するメール送信.
		if (Boolean.TRUE.equals(applicant.staffSetting.sendMailTransportation)) {
			// 諸経費承認時メール通知.
			dto.setTo(applicant.email);
			dto.setToName(applicant.staffName.fullName);
			method.invoke(skmsMai, dto);
		}

		// PM承認ならば.
		if (staff.staffProjectPosition != null
				&& staff.staffProjectPosition.size() > 0
				&& staff.staffProjectPosition.get(0).projectPositionId == ProjectPositionId.PM) {

			// 総務部長一覧の取得.
			StaffService staffService = SingletonS2Container.getComponent( StaffService.class );
			List<MStaff> accountingManagerList
				= staffService.getDepartmentHeadList(DepartmentId.GENERAL_AFFAIR);

			// 総務部長に対してメール通知.
			for (MStaff accountingManager : accountingManagerList) {
				// メール通知有りならば.
				if (accountingManager.staffSetting != null
					&& Boolean.TRUE.equals(accountingManager.staffSetting.sendMailTransportation)) {
					// 諸経費承認時メール通知.
					dto.setTo(accountingManager.email);
					dto.setToName(accountingManager.staffName.fullName);
					method.invoke(skmsMai, dto);
				}
			}
		}

	}

	/**
	 * 諸経費支払時のメール通知を行う.
	 *
	 * @param  staff		支払者情報.
	 * @param  oversDto		諸経費情報Dto.
	 * @param  reason		理由(支払取り消し時のみ使用).
	 * @param  methodName	メール送信メソッド名.
	 */
	public void sendMailOverheadPayment(MStaff staff, OverheadDto overDto, String reason, String methodName) throws Exception
	{
		// 諸経費の取得.
		Overhead overhead = getOverhead(overDto);

		// メール送信メソッドの取得.
		Method method = skmsMai.getClass().getMethod(methodName, MailOverheadDto.class);
		// 諸経費メール送信用DTO生成.
		MailOverheadDto dto = new MailOverheadDto(overhead);
		// 理由のセット.
		dto.setReason(reason);
		// 承認者のセット.
		dto.setApprovalName(staff.staffName.fullName);

		// 申請者の環境設定取得.
//		SystemService systemService = SingletonS2Container.getComponent( SystemService.class );
//		StaffSetting staffSetting = systemService.getStaffSetting(overDto.staffId);
		MStaff applicant = overhead.staff;
		// 申請者に対するメール送信.
		if (Boolean.TRUE.equals(applicant.staffSetting.sendMailTransportation)) {
			// 諸経費支払時メール通知.
			dto.setTo(applicant.email);
			dto.setToName(applicant.staffName.fullName);
			method.invoke(skmsMai, dto);
		}
	}

	/**
	 * 諸経費受領時のメール通知を行う.
	 *
	 * @param  overDto		諸経費情報Dto.
	 * @param  reason		理由(受領取り消し時のみ使用).
	 * @param  methodName	メール送信メソッド名.
	 */
	public void sendMailOverheadAccept(OverheadDto overDto, String reason, String methodName) throws Exception
	{
		// 諸経費の取得.
		Overhead overhead = getOverhead(overDto);

		// メール送信メソッドの取得.
		Method method = skmsMai.getClass().getMethod(methodName, MailOverheadDto.class);
		// 諸経費メール送信用DTO生成.
		MailOverheadDto dto = new MailOverheadDto(overhead);
		// 理由のセット.
		dto.setReason(reason);

		// 総務部長一覧の取得.
		StaffService staffService = SingletonS2Container.getComponent( StaffService.class );
		List<MStaff> accountingManagerList
			= staffService.getDepartmentHeadList(DepartmentId.GENERAL_AFFAIR);

		// 総務部長に対してメール通知.
		for (MStaff accountingManager : accountingManagerList) {
			// メール通知有りならば.
			if (accountingManager.staffSetting != null
				&& Boolean.TRUE.equals(accountingManager.staffSetting.sendMailTransportation)) {
				// 諸経費受領時メール通知.
				dto.setTo(accountingManager.email);
				dto.setToName(accountingManager.staffName.fullName);
				method.invoke(skmsMai, dto);
			}
		}
	}

	/**
	 * 諸経費申請を取得する.
	 *
	 * @param  overDto		諸経費情報Dto.
	 * @return 諸経費情報.
	 */
	private Overhead getOverhead(OverheadDto overDto) throws Exception
	{
		Overhead overhead = jdbcManager.from(Overhead.class)
											.innerJoin("projectE")
											.leftOuterJoin("projectE.projectMembers")
											.leftOuterJoin("projectE.projectMembers.staff")
											.leftOuterJoin("projectE.projectMembers.projectPosition")
											.leftOuterJoin("projectE.projectMembers.staff.staffName")
											.leftOuterJoin("projectE.projectMembers.staff.staffSetting")
											.innerJoin("staff")
											.innerJoin("staff.staffName")
											.innerJoin("staff.staffSetting")
											.leftOuterJoin("overheadDetails")
											.id(overDto.overheadId)
											.getSingleResult();
		return overhead;
	}
}
