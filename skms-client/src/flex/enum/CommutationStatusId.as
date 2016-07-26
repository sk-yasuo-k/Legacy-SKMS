package enum
{
	public final class CommutationStatusId
	{

		/**
		 * 未作成です。

		 */
		public static const NONE:int = 0;

		/**
		 * 作成済です。

		 */
		public static const ENTERED:int = 1;

		/**
		 * 申請済です。

		 */
		public static const APPLIED:int = 2;

		/**
		 * PM承認済です。

		 */
		public static const PM_APPROVED:int = 6;

		/**
		 * 総務確認済です。

		 */
		public static const GA_APPROVED:int = 7;

		/**
		 * 差し戻し中です。

		 */
		public static const REJECTED:int = -1;


	}
}