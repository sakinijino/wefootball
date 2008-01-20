package com.wefootball.tests
{
	import com.wefootball.components.UserInformation;
	
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.core.UIComponent;

	public class UserInformationTest extends TestCase
	{
		public static var user:XML = 
			<User>
				<nickname>霏昀</nickname>
				<birthday>1984-03-10</birthday>
				<height>172</height>
				<weight>62</weight>
				<summary>猫 其一 
他猫各有他猫刀, 我自横爪向天喵. 
猫生自古谁无死, 只求有鱼过今朝.</summary>
				<foot>B</foot>
			</User>
		
		public static var ui:UserInformation = new UserInformation()
		
		public static function suite(app:UIComponent):TestSuite {
			ui.visible = false
			app.addChild(ui);
			var suite:TestSuite = new TestSuite;
			suite.addTest(new UserInformationTest('testBind'));
			return suite;
		}
		
		public function UserInformationTest(method:String) {
			super(method);
		}
		
		public function testBind() :void {
			ui.user = UserInformationTest.user
			Assert.assertEquals(UserInformationTest.user.nickname, ui.uname.text);
			Assert.assertEquals((new Date().fullYear - 1984).toString(), ui.uage.text);
			Assert.assertEquals(UserInformationTest.user.height+'cm', ui.uheight.text);
			Assert.assertEquals(UserInformationTest.user.weight+'kg', ui.uweight.text);
			Assert.assertEquals(UserInformationTest.user.summary, ui.usummary.text);
			Assert.assertEquals('左右开弓', ui.ufoot.text);
		}

	}
}