package enum
{
	public final class WorkingHoursStatusId
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
		 * 提出済です。

		 */
		public static const SUBMITTED:int = 2;

		/**
		 * TN承認済です。

		 */
		public static const TN_APPROVED:int = 3;

		/**
		 * SL承認済です。

		 */
		public static const SL_APPROVED:int = 4;

		/**
		 * PL承認済です。

		 */
		public static const PL_APPROVED:int = 5;

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