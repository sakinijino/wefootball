package com.wefootball.validators
{
	import mx.validators.Validator;

	public class ServerErrorValidator extends Validator {
		private var _serverErrors:ServerErrors;

		public var field:String;

		public function set serverErrors(pServerErrors:ServerErrors):void {
			_serverErrors = pServerErrors;
			validate();
		}
		public function ServerErrorValidator() {
			field = ServerErrors.BASE;//default to being on BASE
			_serverErrors = null;
			super();
		}
		override protected function doValidation(value:Object):Array {
			return _serverErrors.getErrorsForField(field);
		}
	}
}