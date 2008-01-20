package com.wefootball.validators
{
	import mx.validators.Validator;
	import mx.validators.ValidationResult;

	public class PasswordConfirmationValidator extends Validator {
		public var password:String;
		public function PasswordConfirmationValidator() {
			super();
		}
		override protected function doValidation(passwordConfirmation:Object):Array {
			var results:Array = super.doValidation(passwordConfirmation);// Compare password and passwordConfirmation fields.
			if (password != passwordConfirmation) {
				results.push(new ValidationResult(true, "password_confirmation", "passwordDoesNotMatchConfirmation", "The password does not match the confirmation."));
			}
			return results;
		}
	}
}