package services.customer.service;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

import org.seasar.extension.jdbc.where.SimpleWhere;

import services.customer.dto.CustomerDto;
import services.customer.dto.CustomerMemberDto;
import services.customer.dto.CustomerSearchDto;
import services.customer.entity.MCustomer;
import services.customer.entity.MCustomerMember;
import services.generalAffair.entity.MStaff;
import services.project.entity.Project;


/**
 * 客先を扱うアクションです。
 *
 * @author yasuo-k
 *
 */
public class CustomerService extends CommonService {

	/**
	 * 顧客リストを返します.
	 *
	 * @param  search 検索条件.
	 * @return 顧客のリスト.
	 */
	public List<CustomerDto> getCustomerList(CustomerSearchDto search) throws Exception
	{
		// 未設定は Exception とする.
		checkData_search(search);


		List<MCustomer> customerList = jdbcManager.from(MCustomer.class)
												.leftOuterJoin("customerMembers")
												.where(new SimpleWhere().eq("deleteFlg", false)
																		.in("customerType", search.customerTypeList!=null?search.customerTypeList.toArray():null)
																		.eq("customerType", search.customerType)
																		.starts("customerNo",   search.customerNo)
																		.contains("customerName", search.customerName)
																		.contains("customerAlias", search.customerAlias)
																		)
												.orderBy("sortOrder, customerMembers.customerMemberId")
												.getResultList();

		List<CustomerDto> retCustomerList = new ArrayList<CustomerDto>();
		for (MCustomer customer : customerList) {
			// 顧客情報を作成する.
			CustomerDto retCustomer = customerDxo.convert(customer);
			retCustomer.setCustomerCode();
			retCustomer.setRepresentative();

			// 顧客担当者情報を作成する.
			retCustomer.customerMembers = new ArrayList<CustomerMemberDto>();
			for (MCustomerMember customerMember : customer.customerMembers) {
				CustomerMemberDto retCustomerMember = customerMemberDxo.convert(customerMember);
				retCustomerMember.setFullName();
				retCustomer.customerMembers.add(retCustomerMember);
			}
			// 顧客情報を顧客リストに追加する.
			retCustomerList.add(retCustomer);
		}
		return retCustomerList;
	}

	/**
	 * 顧客コードを返します.
	 *
	 * @return 顧客番号.
	 */
	public String getCustomerCode(String customerType) throws Exception
	{
		// 未設定は Exception とする.
		checkData_customerType(customerType);

		String maxSql = "select max(customer_no) from m_customer where customer_type = '" + customerType + "'";
		String maxval = jdbcManager.selectBySql(String.class, maxSql).getSingleResult();
		String nextval = "";
		if (maxval == null) 	nextval = "01";
		else {
			int nextInt = Integer.parseInt(maxval) + 1;
			if (nextInt < 10) 	nextval = "0" + Integer.toString(nextInt);
			else 				nextval = Integer.toString(nextInt);
		}
		return customerType + nextval;
	}


	/**
	 * 顧客表示順を変更する.
	 *
	 * @param  staff        登録社員.
	 * @param  customerList 顧客情報リスト.
	 * @return 登録件数.
	 */
	public int changeCustomerSort(MStaff staff, List<CustomerDto> customerDtoList) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_customerList(customerDtoList);

		int index = 1;
		List<MCustomer> customerList = new ArrayList<MCustomer>();
		for (CustomerDto customerDto : customerDtoList) {
			MCustomer customer = customerDxo.convert(customerDto);
			customer.setUpdateCustomer(staff.staffId);
			customer.updateSortOrder(index);
			customerList.add(customer);
			index++;
		}
		return jdbcUpdateCustomerSort(customerList);
	}


	/**
	 * 顧客を登録する.
	 *
	 * @param  staff       登録社員.
	 * @param  customerDto 顧客情報.
	 * @return 登録件数.
	 */
	public int createCustomer(MStaff staff, CustomerDto customerDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_customer(customerDto);


		int retnum = 0;
		// エンティティに変換する.
		MCustomer customer = customerDxo.convert(customerDto);
		// 新規登録のとき.
		if (customerDto.isNew()) {
			// 顧客を登録する.
			int newId = jdbcNewCustomerId();
			customer.setNewCustomer(newId, staff.staffId);
			retnum += jdbcInsertCustomer(customer);

			// 顧客担当者を登録する.
			retnum += createCustomerMembers(staff, customerDto.customerMembers, newId);
		}
		// 更新のとき.
		else if (customerDto.isUpdate()) {
			// 顧客を更新する.
			customer.setUpdateCustomer(staff.staffId);
			retnum += jdbcUpdateCustomer(customer);

			// 顧客担当者を登録・更新する.
			retnum += createCustomerMembers(staff, customerDto.customerMembers, customer.customerId);
		}
		// 顧客コードの重複登録を確認する.
		checkExistData_customerCode(customer);
		return retnum;
	}

	/**
	 * 顧客担当者を登録する.
	 *
	 * @param  staff      登録社員.
	 * @param  memberList 顧客担当者リスト.
	 * @param  customerId 顧客ID.
	 * @return 登録件数.
	 */
	private int createCustomerMembers(MStaff staff, List<CustomerMemberDto> memberList, int customerId) throws Exception
	{
		int retnum = 0;
		for (CustomerMemberDto memberDto : memberList) {
			// エンティティに変換する.
			MCustomerMember member = customerMemberDxo.convert(memberDto);
			// 新規登録のとき.
			if (memberDto.isNew()) {
				int newId = jdbcCustomerNewMemberId(customerId);
				member.setNewMember(customerId, newId, staff.staffId);
				retnum += jdbcInsertCustomerMember(member);
			}
			// 更新のとき.
			else if (memberDto.isUpdate()) {
				member.setUpdMember(staff.staffId);
				retnum += jdbcUpdateCustomerMember(member);
			}
			// 削除のとき.
			else if (memberDto.isDelete()) {
				retnum += jdbcDeleteCustomerMember(member);
			}
		}
		return retnum;
	}

	/**
	 * 顧客を削除する.
	 *
	 * @param  staff       登録社員.
	 * @param  customerDto 顧客情報.
	 * @return 更新件数.
	 */
	public int deleteCustomer(MStaff staff, CustomerDto customerDto) throws Exception
	{
		// 未設定は Exception とする.
		checkData_staff(staff);
		checkData_customer(customerDto);


		// 削除フラグをONにする.
		int retnum = 0;
		MCustomer customer = customerDxo.convert(customerDto);
		customer.setDeleteCustomer(staff.staffId);
		// 関連データチェックをする。データがあるときは Exception とする.
		checkRelatedData_customer(customer);
		retnum += jdbcUpdateCustomer(customer);
		return retnum;
	}

	/**
	 * 顧客を登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcInsertCustomer(MCustomer entity)
	{
		// customerの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * 顧客を更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateCustomer(MCustomer entity)
	{
		// customerの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * 顧客表示順を更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateCustomerSort(List<MCustomer> entityList)
	{
		// customerの更新.
		int[] retArray = jdbcManager.updateBatch(entityList).includes("sortOrder").execute();
		return retArray == null ? 0 : retArray.length;
	}

	/**
	 * 顧客担当を登録します.
	 *
	 * @param  entity
	 * @return 登録件数.
	 */
	private int jdbcInsertCustomerMember(MCustomerMember entity)
	{
		// customer_memberの追加.
		return jdbcManager.insert(entity).execute();
	}

	/**
	 * 顧客担当を更新します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcUpdateCustomerMember(MCustomerMember entity)
	{
		// customer_memberの更新.
		return jdbcManager.update(entity).execute();
	}

	/**
	 * 顧客担当を削除します.
	 *
	 * @param  entity
	 * @return 更新件数.
	 */
	private int jdbcDeleteCustomerMember(MCustomerMember entity)
	{
		// customer_memberの削除.
		return jdbcManager.delete(entity).execute();
	}

	/**
	 * 新顧客IDを採番します.
	 *
	 * @return 新顧客ID.
	 */
	private int jdbcNewCustomerId()
	{
		return jdbcManager.selectBySql(Integer.class, "select nextval('m_customer_customer_id_seq')").getSingleResult();
	}

	/**
	 * 新顧客担当IDを採番します.
	 *
	 * @param  customerId 顧客ID
	 * @return 新顧客担当ID.
	 */
	private int jdbcCustomerNewMemberId(int customerId)
	{
		// 採番済みの新顧客担当IDを取得する.
		String maxSql = "select max(customer_member_id) from m_customer_member where customer_id =" + customerId;
		Integer currval = jdbcManager.selectBySql(Integer.class, maxSql).getSingleResult();
		Integer nextval = currval == null ? 1 : currval + 1;
		return nextval;
	}

	/**
	 * 指定顧客に関連するデータの有無を確認する.
	 *
	 * @param  entity
	 * @return 確認結果.
	 */
	private boolean checkRelatedData_customer(MCustomer entity) throws Exception
	{
		// プロジェクトを問い合わせる.
		List<Project> projectList = jdbcManager
											.from(Project.class)
											.leftOuterJoin("customer")
											.where(new SimpleWhere().eq("deleteFlg", false)
																	.eq("customer.customerId", entity.customerId))
											.getResultList();
		// プロジェクトを取得する.
		TreeMap<Integer, String> map = new TreeMap<Integer, String>();
		for (Project project : projectList) {
			map.put(project.projectId, project.projectCode + " " + project.projectName);
		}
		if (map.size() > 0)		throw createDeleteExceptionProject(map);
		return false;
	}

	/**
	 * 顧客コードが1件以上登録されているかどうか確認する.
	 *
	 * @param  entity
	 * @return 確認結果.
	 */
	private boolean checkExistData_customerCode(MCustomer entity) throws Exception
	{
		long count = jdbcManager.from(MCustomer.class)
								.where(new SimpleWhere().eq("customerType", entity.customerType)
														.eq("customerNo",   entity.customerNo))
											.getCount();
		if (count > 1) {
			String cCode = getCustomerCode(entity.customerType);
			throw createExistDataException_customerCode(cCode);
		}
		return false;
	}
}