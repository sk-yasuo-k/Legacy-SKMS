package subApplications.generalAffair.dto
{
	import subApplications.generalAffair.dto.MCommitteeDto;
	
	/**
	 * 委員会概要Dtoです。
	 *
	 * @author nobuhiro-s
	 *
	 */
	public class CommitteeNoteDto
	{
		private var _committeeNote:MCommitteeDto;
		
		public function CommitteeNoteDto(object:Object)
		{
			for each(var tmp:MCommitteeDto in object)
			{
				tmp;
			} 
			_committeeNote = tmp;
		}
		
		/**
		 * 概要取得
		 */			
		public function get MCommitteeNote():MCommitteeDto
		{
			// DTOを取得元に返す	
			return _committeeNote;
		}
	}
}