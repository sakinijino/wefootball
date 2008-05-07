-- MySQL dump 10.11
--
-- Host: localhost    Database: wefootball
-- ------------------------------------------------------
-- Server version	5.0.51a-community-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `football_ground_editors`
--

DROP TABLE IF EXISTS `football_ground_editors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `football_ground_editors` (
  `user_id` int(11) default NULL,
  KEY `index_football_ground_editors_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `football_ground_editors`
--

LOCK TABLES `football_ground_editors` WRITE;
/*!40000 ALTER TABLE `football_ground_editors` DISABLE KEYS */;
INSERT INTO `football_ground_editors` VALUES (1),(2),(2);
/*!40000 ALTER TABLE `football_ground_editors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `football_grounds`
--

DROP TABLE IF EXISTS `football_grounds`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `football_grounds` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `city` int(11) default '0',
  `ground_type` int(2) default '1',
  `status` int(1) default '0',
  `description` text,
  `longitude` decimal(10,0) default NULL,
  `latitude` decimal(10,0) default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `football_grounds`
--

LOCK TABLES `football_grounds` WRITE;
/*!40000 ALTER TABLE `football_grounds` DISABLE KEYS */;
INSERT INTO `football_grounds` VALUES (1,'北京大学第一体育场',9,2,1,'',NULL,NULL,1),(2,'北京大学五四体育场小场',9,3,1,'',NULL,NULL,1),(3,'北京大学五四体育场草场',9,1,1,'',NULL,NULL,1);
/*!40000 ALTER TABLE `football_grounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_invitations`
--

DROP TABLE IF EXISTS `friend_invitations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `friend_invitations` (
  `id` int(11) NOT NULL auto_increment,
  `applier_id` int(11) default NULL,
  `host_id` int(11) default NULL,
  `message` text,
  `apply_date` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `friend_invitations`
--

LOCK TABLES `friend_invitations` WRITE;
/*!40000 ALTER TABLE `friend_invitations` DISABLE KEYS */;
INSERT INTO `friend_invitations` VALUES (8,2,4,'','2008-04-24'),(21,2,21,'我是马博。。。','2008-04-25'),(26,34,33,'ct','2008-04-27'),(31,25,21,'hi','2008-04-28'),(34,39,33,'xuchunbin...','2008-04-28'),(35,1,38,'','2008-04-28'),(36,2,38,'我是马家宽:)','2008-04-28'),(37,44,31,'sb','2008-04-28'),(38,46,35,'野尘你好矬，没头像啊','2008-04-28'),(41,46,33,'哈哈哈哈哈哈哈','2008-04-28'),(42,46,44,'你不参加曼联队？','2008-04-28'),(44,47,45,'','2008-04-28'),(45,47,49,'','2008-04-29'),(46,47,41,'','2008-04-29'),(47,25,38,'','2008-04-30'),(48,34,52,'','2008-05-02');
/*!40000 ALTER TABLE `friend_invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_relations`
--

DROP TABLE IF EXISTS `friend_relations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `friend_relations` (
  `id` int(11) NOT NULL auto_increment,
  `user1_id` int(11) default NULL,
  `user2_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `friend_relations`
--

LOCK TABLES `friend_relations` WRITE;
/*!40000 ALTER TABLE `friend_relations` DISABLE KEYS */;
INSERT INTO `friend_relations` VALUES (1,2,1),(2,3,1),(3,4,1),(4,5,3),(5,11,5),(6,2,3),(7,7,2),(8,8,2),(9,9,2),(10,10,3),(11,7,1),(12,10,1),(13,14,1),(14,1,6),(15,10,2),(16,2,17),(17,2,16),(18,16,18),(19,17,19),(20,3,20),(21,17,7),(22,10,21),(23,17,1),(24,2,22),(25,1,23),(26,3,24),(27,3,26),(28,3,27),(29,3,25),(30,26,28),(31,26,29),(32,3,30),(33,2,28),(34,28,31),(35,2,32),(36,28,33),(37,28,34),(38,28,35),(39,3,36),(40,2,37),(41,34,30),(42,2,30),(43,2,25),(44,25,1),(45,30,38),(46,30,10),(47,25,10),(48,10,38),(49,28,39),(50,28,40),(51,25,41),(52,25,30),(53,3,42),(54,38,3),(55,25,43),(56,28,44),(57,25,45),(58,28,46),(59,25,47),(60,26,48),(61,46,30),(62,46,34),(63,25,49),(64,28,50),(65,47,3),(66,30,51),(67,3,52),(68,25,53),(69,25,54),(70,2,55);
/*!40000 ALTER TABLE `friend_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_invitations`
--

DROP TABLE IF EXISTS `match_invitations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `match_invitations` (
  `id` int(11) NOT NULL auto_increment,
  `start_time` datetime default NULL,
  `location` varchar(100) default NULL,
  `match_type` int(11) default NULL,
  `size` int(11) default NULL,
  `has_judge` tinyint(1) default NULL,
  `has_card` tinyint(1) default NULL,
  `has_offside` tinyint(1) default NULL,
  `win_rule` int(11) default NULL,
  `description` text,
  `half_match_length` int(11) default NULL,
  `rest_length` int(11) default NULL,
  `host_team_id` int(11) default NULL,
  `guest_team_id` int(11) default NULL,
  `edit_by_host_team` tinyint(1) default NULL,
  `new_start_time` datetime default NULL,
  `new_location` varchar(100) default NULL,
  `new_match_type` int(11) default NULL,
  `new_size` int(11) default NULL,
  `new_has_judge` tinyint(1) default NULL,
  `new_has_card` tinyint(1) default NULL,
  `new_has_offside` tinyint(1) default NULL,
  `new_win_rule` int(11) default NULL,
  `new_description` text,
  `new_half_match_length` int(11) default NULL,
  `new_rest_length` int(11) default NULL,
  `host_team_message` text,
  `guest_team_message` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `new_football_ground_id` int(11) default NULL,
  `football_ground_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `match_invitations`
--

LOCK TABLES `match_invitations` WRITE;
/*!40000 ALTER TABLE `match_invitations` DISABLE KEYS */;
/*!40000 ALTER TABLE `match_invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_joins`
--

DROP TABLE IF EXISTS `match_joins`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `match_joins` (
  `id` int(11) NOT NULL auto_increment,
  `match_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `team_id` int(11) default NULL,
  `goal` int(11) default '0',
  `yellow_card` int(11) default '0',
  `red_card` int(11) default '0',
  `position` int(11) default NULL,
  `status` int(11) default NULL,
  `comment` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `match_joins`
--

LOCK TABLES `match_joins` WRITE;
/*!40000 ALTER TABLE `match_joins` DISABLE KEYS */;
INSERT INTO `match_joins` VALUES (3,1,3,2,0,0,0,0,1,NULL,'2008-04-24 02:02:15','2008-04-24 23:10:44'),(5,1,2,1,0,0,0,23,0,NULL,'2008-04-24 02:02:15','2008-04-24 02:29:46'),(6,1,3,1,0,0,0,0,1,NULL,'2008-04-24 02:02:15','2008-04-24 02:29:46'),(7,1,4,1,0,0,0,NULL,0,NULL,'2008-04-24 02:02:15','2008-04-24 02:02:15'),(8,1,7,1,0,0,0,NULL,0,NULL,'2008-04-24 09:37:51','2008-04-24 09:37:51'),(9,1,10,2,0,0,0,18,1,NULL,'2008-04-24 12:10:24','2008-04-24 23:10:44'),(10,1,17,1,0,0,0,NULL,1,NULL,'2008-04-24 19:50:45','2008-04-25 12:15:13'),(11,1,16,1,0,0,0,NULL,0,NULL,'2008-04-25 10:24:56','2008-04-25 10:24:56'),(12,1,21,2,0,0,0,NULL,0,NULL,'2008-04-25 16:14:39','2008-04-25 16:14:39'),(13,1,22,1,0,0,0,NULL,0,NULL,'2008-04-25 23:20:21','2008-04-25 23:20:21'),(14,1,25,2,0,0,0,NULL,1,NULL,'2008-04-26 23:39:13','2008-04-28 12:26:07'),(15,1,36,1,0,0,0,NULL,1,NULL,'2008-04-28 10:18:35','2008-04-28 13:00:35'),(16,1,38,2,0,0,0,NULL,0,NULL,'2008-04-28 12:36:23','2008-04-28 12:36:23');
/*!40000 ALTER TABLE `match_joins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `matches` (
  `id` int(11) NOT NULL auto_increment,
  `start_time` datetime default NULL,
  `end_time` datetime default NULL,
  `location` varchar(100) default '',
  `match_type` int(11) default NULL,
  `size` int(11) default '5',
  `has_judge` tinyint(1) default NULL,
  `has_card` tinyint(1) default NULL,
  `has_offside` tinyint(1) default NULL,
  `win_rule` int(11) default NULL,
  `description` text,
  `half_match_length` int(11) default '0',
  `rest_length` int(11) default '0',
  `host_team_id` int(11) default NULL,
  `guest_team_id` int(11) default NULL,
  `host_team_goal_by_host` int(11) default NULL,
  `guest_team_goal_by_host` int(11) default NULL,
  `host_team_goal_by_guest` int(11) default NULL,
  `guest_team_goal_by_guest` int(11) default NULL,
  `situation_by_host` int(11) default NULL,
  `situation_by_guest` int(11) default NULL,
  `has_conflict` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `football_ground_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES (1,'2008-05-01 16:00:00','2008-05-01 17:45:00','北京大学第一体育场',1,5,0,0,0,2,'与人斗其乐无穷',45,15,2,1,NULL,NULL,NULL,NULL,NULL,NULL,0,'2008-04-24 02:02:15','2008-04-24 02:02:15',NULL);
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `sender_id` int(11) default NULL,
  `receiver_id` int(11) default NULL,
  `content` text,
  `subject` varchar(50) default NULL,
  `is_delete_by_sender` tinyint(1) default '0',
  `is_delete_by_receiver` tinyint(1) default '0',
  `is_receiver_read` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,3,5,'妹妹乖乖呀~','helloworld',0,0,1,'2008-04-24 01:43:37','2008-04-29 22:02:59'),(2,3,5,'kisssssssssss~','morning~~~',0,1,1,'2008-04-24 08:56:27','2008-04-29 22:02:53'),(3,2,3,'rt','把我也加成长江七号的管理员吧',0,0,1,'2008-04-24 13:46:24','2008-04-24 15:21:48'),(4,1,2,'rt','未读邮件提示已加',1,0,1,'2008-04-24 18:01:52','2008-04-24 18:02:43'),(5,2,16,'最后也没赶上用户测试。。。\r\n改一下头像吧，呵呵','Welcome',0,0,0,'2008-04-25 10:41:23','2008-04-25 10:41:23'),(6,3,20,'你可以在邀请的时候以我队的名义发出邀请了~~','给你加为管理员了',0,0,1,'2008-04-25 12:05:38','2008-04-25 12:05:55'),(7,1,30,'所以比赛显示不出来，现在已经好了~\r\n\r\n欢迎继续试用wefootball。\r\n\r\np.s. 另外，方便的话，可以把刚才多添加的那几次比赛取消掉~~ 多谢~~','不好意思，刚才系统出了点bug',1,0,1,'2008-04-27 16:50:39','2008-04-28 17:47:39'),(8,1,3,'是你建了许多3个一样的？取消掉重复的吧~','刚才单边现实有点问题，我改了',1,0,1,'2008-04-27 16:53:20','2008-04-27 17:22:20'),(9,3,30,'下拉菜单中列出的场地是经过系统管理员审批的，你要发现里面没有，那你可以自己填写，那个菜单下面有一句话，你点击之后就可以自己输入了哦~~','场地可以自己填写的哦',0,0,1,'2008-04-27 17:04:21','2008-04-28 09:25:48'),(10,2,30,'刚才在站务论坛中看到你说组织比赛好像不大对，可否描述的详细一些？如果有问题我们尽快改，谢谢啦:)\r\np.s.你是近十个注册用户中使用最专业的一个，我一度都已经怀疑我们这个网站灰常过于难用了。你放头像安排比赛，给了我很大希望。看来staf狂赞的牛人果然名不虚传啊。。。','可否描述一下组织比赛时候出问题的详细情况。。。',0,0,1,'2008-04-27 17:05:16','2008-04-28 09:25:57'),(11,2,8,'难道你不觉得这个绿问号很难看吗。。。','同学，放个头像吧。。。',0,0,0,'2008-04-27 17:08:08','2008-04-27 17:08:08'),(12,2,9,'有点专业精神好吗。。。','放个头像吧。。。',0,0,1,'2008-04-27 17:09:01','2008-04-27 18:13:07'),(13,2,30,'应该是前几天改代码弄乱了，我们改了一下，你再看看这次对了吗？','改了一下，你再试试看？',0,0,1,'2008-04-27 17:14:38','2008-04-28 09:26:11'),(14,2,28,'难道你能忍这个绿绿的问号。。。','换个头像吧。。。',0,0,1,'2008-04-27 17:16:37','2008-04-27 17:30:50'),(15,1,2,'模板的问题，有一个地方显示进球的时候，没check比赛是不是结束了。我都直接远程改的，回去再同步吧。','模板的问题',1,0,1,'2008-04-27 17:17:40','2008-04-27 17:22:51'),(16,2,24,'难道你不觉得这个绿绿的小问号很难看。。。','房队，换个头像吧。。。',0,0,0,'2008-04-27 17:18:08','2008-04-27 17:18:08'),(17,2,1,'http://www.wefootball.org/0000000000这个页面的wefootball图标不能点，而且左边的“返回首页”现在应该是“返回我的首页”','好，还有个问题',0,1,1,'2008-04-27 17:24:24','2008-04-28 17:47:43'),(18,2,1,'。。。','还有刚才这封信怎么全文都成链接了',0,1,1,'2008-04-27 17:25:14','2008-04-28 17:47:43'),(19,1,2,'url识别会把后面的都识别成link的参数。\r\n\r\n另外你说的是哪个链接。。。','因为你没空格',1,0,1,'2008-04-27 17:26:53','2008-04-28 17:47:39'),(20,1,2,'那个就是返回首页呀？','你说500的页面',1,0,1,'2008-04-27 17:28:22','2008-04-28 17:47:39'),(21,2,1,'不空格肯定会挂吗，咱是不是想想办法。。。\r\n我说的是那个错误页面','re',0,1,1,'2008-04-27 17:29:20','2008-04-28 17:47:43'),(22,2,1,'现在还有一个全站首页\r\n而且这个问题是hokey反映给雷指，雷指告诉我的。hokey说右边那个wefootball图标点不了，觉得很奇怪。。。','还应该是“我的首页”吧',0,1,1,'2008-04-27 17:30:47','2008-04-28 17:47:43'),(23,1,2,'回去再改吧。另外那个页面我用的静态页面，如果放我的首页的话，那个页面怎么写还要在讨论一下。\r\n\r\n链接那个应该没什么关系，现在市面上的中文网站识别link都有这个问题。因为如果不空格这个匹配没法区分url参数和下面的话。这个应该算是大家普遍接受的一个bug了。','点不了那个是bug',1,0,1,'2008-04-27 17:37:55','2008-04-28 17:47:39'),(24,2,1,'我把龙战搞定了，他应该也是个大节点:)','好，那等你回来了',0,1,1,'2008-04-27 17:51:50','2008-04-28 17:47:43'),(25,1,2,'如果你们好好搞，等我5.1回来就可以鸿宾楼了。。。','Invitation那张表的id已经到59了',1,0,1,'2008-04-27 18:02:13','2008-04-28 17:47:39'),(26,2,1,'我约了龙战，又一个大节点啊，必须搞定他了。。。','必须的',0,1,1,'2008-04-27 18:16:56','2008-04-28 17:47:43'),(27,2,34,'欢迎欢迎，你的信息填的很全啊:)\r\np.s.其实你建的那场随便踢踢，地点只要填“一体”就好了。你填的太详细，反而出来有点奇怪的。','welcome',0,0,1,'2008-04-27 21:09:06','2008-04-28 22:42:47'),(28,3,36,'你可以创建你的“队伍”（就是经常一块踢球的一群人哈~），然后把你的朋友们都加进来哦~','你可以把你的信息都填全哈~',0,0,1,'2008-04-27 22:20:02','2008-04-27 22:46:52'),(29,2,36,'刚才仔细看了一下，发现你昨天申请注册的时候确实填了一个sina的邮箱，是我们的疏忽没看到，不好意思。。。\r\n另外，为了保证你后来贴出来的gmail邮箱不会被搜索引擎抓走，我们已将那个申请注册的帖子删除\r\n欢迎没事过来逛逛:)','不好意思',0,0,1,'2008-04-28 09:54:39','2008-04-28 12:58:04'),(30,2,38,'欢迎铁卫:)\r\n你还可以在个人设置里面设置一下踢球信息，这样我们就可以把你排到阵型里面了','welcome',0,0,0,'2008-04-28 12:49:39','2008-04-28 12:49:39'),(31,36,2,'RT','谢谢细心的处理。',0,0,1,'2008-04-28 12:59:24','2008-04-28 14:58:58'),(32,2,36,'别客气。欢迎没事过来逛逛，分享踢球的信息:)','呵呵，应该的',1,0,1,'2008-04-28 14:59:36','2008-04-30 15:31:06'),(33,2,36,'别客气。有空一起踢踢球吧:)','呵呵，应该的',0,0,1,'2008-04-28 15:02:09','2008-04-30 15:31:11'),(34,2,25,'不好意思，由于我们排列图标的时候限制了一行的宽度，所以现在首页上JuventusPKU的U被截掉了一点。。。\r\n如果你们不能忍这个，可以在Juventus和PKU加一个空格，这样会折行显示所有信息。个人意见，仅供参考\r\np.s. 皇马版的命名规则是realmadrid @wm，我觉得也蛮好的','关于队名的一点小建议',0,0,1,'2008-04-28 15:15:11','2008-04-28 15:44:37'),(35,25,2,'改了。','3x',0,0,1,'2008-04-28 15:46:08','2008-04-28 15:51:18'),(36,2,25,'没事组织大家一起踢踢球吧:)','呵呵，不客气',0,0,1,'2008-04-28 15:51:51','2008-04-28 16:04:47'),(37,25,2,'不过现在人还没叫齐。','好啊',0,0,1,'2008-04-28 16:05:19','2008-04-28 16:10:07'),(38,2,25,'恩，估计这几天还有不少人出去玩。等过了五一，队员再全些，就可以多组织一些活动了:)','re',0,0,1,'2008-04-28 16:11:14','2008-04-28 16:14:08'),(39,44,31,'还什么位置都能踢\r\n球童当不','你咋这么不谦虚呢',0,0,0,'2008-04-28 17:08:01','2008-04-28 17:08:01'),(40,2,1,'主题: 关于队名的一点小建议\r\n不好意思，由于我们排列图标的时候限制了一行的宽度，所以现在首页上JuventusPKU的U被截掉了一点。。。 \r\n如果你们不能忍这个，可以在Juventus和PKU加一个空格，这样会折行显示所有信息。个人意见，仅供参考 \r\np.s. 皇马版的命名规则是realmadrid @wm，我觉得也蛮好的\r\n','转发',0,0,1,'2008-04-28 23:26:31','2008-04-28 23:27:44'),(41,1,34,'不好意思，由于我们排列图标的时候限制了一行的宽度，所以现在首页上Liverpool.BDWM的WM被截掉了一点。。。 \r\n如果你们不能忍这个，可以在Liverpool和BDWM加一个空格，这样会折行显示所有信息。个人意见，仅供参考 \r\np.s. 皇马版的命名规则是realmadrid @wm，我觉得也蛮好的 \r\n','关于队名的一点小建议 ',0,0,1,'2008-04-28 23:30:28','2008-04-29 13:55:05'),(42,34,1,'谢谢建议。。。。','好的。。。',0,0,1,'2008-04-29 13:55:27','2008-04-29 15:25:53'),(43,5,3,'wo da bu chu han zi le ya ,xiao gege','gegeguai',0,0,1,'2008-04-29 22:03:26','2008-04-29 22:46:36'),(44,3,5,'哈妹妹...我打的出来我打的出来~~','hoho~~',0,0,0,'2008-04-29 22:47:16','2008-04-29 22:47:16');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `play_joins`
--

DROP TABLE IF EXISTS `play_joins`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `play_joins` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `play_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `play_joins`
--

LOCK TABLES `play_joins` WRITE;
/*!40000 ALTER TABLE `play_joins` DISABLE KEYS */;
INSERT INTO `play_joins` VALUES (1,3,1),(2,2,1),(6,25,4),(7,3,4),(10,34,7),(11,47,4),(13,2,9),(14,3,9),(15,1,9),(16,25,10);
/*!40000 ALTER TABLE `play_joins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plays`
--

DROP TABLE IF EXISTS `plays`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `plays` (
  `id` int(11) NOT NULL auto_increment,
  `start_time` datetime default NULL,
  `end_time` datetime default NULL,
  `location` varchar(100) default '',
  `football_ground_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `plays`
--

LOCK TABLES `plays` WRITE;
/*!40000 ALTER TABLE `plays` DISABLE KEYS */;
INSERT INTO `plays` VALUES (1,'2008-05-02 15:00:00','2008-05-02 17:00:00','北京大学第一体育场',NULL),(4,'2008-04-27 09:00:00','2008-04-27 11:00:00','五四',NULL),(7,'2008-04-30 10:00:00','2008-04-30 12:00:00','去一体和KIM一起踢球',NULL),(9,'2008-04-30 15:00:00','2008-04-30 17:00:00','北京大学第一体育场',1),(10,'2008-04-30 16:00:00','2008-04-30 17:00:00','北京大学第一体育场',1);
/*!40000 ALTER TABLE `plays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `positions` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `label` int(2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
INSERT INTO `positions` VALUES (18,3,0),(19,3,1),(20,3,4),(21,3,5),(22,3,6),(23,3,8),(24,3,9),(25,3,13),(26,3,12),(27,11,8),(28,11,9),(29,11,12),(38,1,2),(39,1,5),(40,1,6),(41,1,9),(42,1,10),(43,8,0),(50,10,5),(51,10,6),(52,10,7),(53,10,8),(54,10,9),(55,10,13),(56,2,4),(57,2,8),(58,2,9),(59,2,12),(60,17,0),(61,17,2),(62,17,3),(63,17,4),(64,17,5),(65,16,0),(66,16,2),(67,16,3),(68,16,4),(69,21,3),(70,21,4),(71,21,7),(72,21,8),(73,21,9),(74,23,1),(75,23,2),(76,23,10),(77,23,0),(78,24,0),(79,24,1),(80,24,2),(81,24,3),(82,24,4),(83,24,5),(84,24,6),(85,24,7),(86,24,8),(87,24,9),(88,24,10),(89,24,13),(90,24,11),(91,24,12),(92,26,5),(93,26,7),(94,26,8),(95,26,9),(96,26,11),(98,29,1),(99,29,10),(100,29,11),(101,9,0),(102,9,2),(103,31,1),(104,31,2),(105,31,3),(106,31,4),(107,31,5),(108,31,6),(109,31,7),(110,31,8),(111,31,9),(112,31,10),(113,31,13),(114,31,11),(115,31,12),(116,34,0),(117,34,1),(118,34,2),(119,34,3),(120,34,4),(121,34,5),(122,34,6),(123,34,7),(124,34,8),(125,34,9),(126,34,10),(127,34,13),(128,34,11),(129,34,12),(130,25,5),(131,25,7),(132,25,8),(133,25,9),(134,25,11),(135,40,7),(136,40,8),(137,40,9),(138,40,13),(139,40,11),(140,40,12),(141,42,0),(142,42,3),(143,42,7),(144,42,10),(145,42,5),(146,44,4),(147,44,8),(148,44,6),(149,46,1),(150,46,2),(151,46,4),(152,46,5),(153,47,0),(154,47,1),(155,47,2),(156,47,3),(157,47,4),(158,47,5),(159,47,6),(160,47,7),(161,47,8),(162,47,9),(163,47,10),(164,47,13),(165,47,11),(166,47,12),(167,48,13),(168,48,11),(169,48,12),(170,50,1),(171,50,2),(172,50,3),(173,50,4),(174,53,2),(175,53,5);
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(100) default NULL,
  `content` text,
  `team_id` int(11) default NULL,
  `training_id` int(11) default NULL,
  `match_id` int(11) default NULL,
  `is_private` tinyint(1) default '0',
  `user_id` int(11) default NULL,
  `replies_count` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `sided_match_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,'开天辟地第一贴','就是这个了！',1,NULL,NULL,1,3,0,'2008-04-24 01:44:42','2008-04-24 01:44:42',NULL),(2,'无兄弟，不足球','这就是了~',2,NULL,NULL,0,3,0,'2008-04-24 01:57:07','2008-04-24 01:57:07',NULL),(3,'踩','不错不错！',1,NULL,NULL,0,7,0,'2008-04-24 09:46:53','2008-04-24 09:46:53',NULL),(4,'五月一号都在学校么...','怀疑...',2,NULL,NULL,1,10,5,'2008-04-24 12:20:20','2008-04-24 23:09:03',NULL),(5,'bb~~','赶紧加人啊~~把古总等人叫过来吧~~',3,NULL,NULL,0,3,4,'2008-04-25 12:04:16','2008-04-25 12:17:37',NULL),(6,'顶...支持支持...','哈哈哈，支持支持...',1,NULL,NULL,0,17,0,'2008-04-25 12:06:00','2008-04-25 12:06:00',NULL),(7,'我去看看...','我去看看..',1,NULL,1,0,17,1,'2008-04-25 12:15:43','2008-04-26 13:10:26',NULL),(8,'lobatt','扬扬怎么没加进来啊？还有dofan和嵇康他们啊~',2,NULL,NULL,1,3,0,'2008-04-25 12:22:16','2008-04-25 12:22:16',NULL),(9,'这次训练的建立是为了测试系统哈','也是为了帮助大家了解怎么使用~~',3,3,NULL,0,3,4,'2008-04-26 19:16:44','2008-04-28 15:23:06',NULL),(10,'[战报]信科杯足球赛首日战报','发信人: SxOo (Oo), 信区: EECS\r\n标  题: [战报]信科杯足球赛首日战报\r\n发信站: 北大未名站 (2008年02月28日22:13:35 星期四) , 站内信件\r\n\r\n    今早8点30分，第二届信科杯足球赛正式打响，CSG07以1：3的比分负于EE&IME05,而\r\n在下午的比赛中，07新生123班联队0：1遗憾的输给了06联队，同时进行的另一场比赛中\r\n，长江7号2：1战胜IME G1。以下是三场比赛的具体战报。\r\n    第一场比赛的对阵双方为C1的CSG07对阵C3的EE&IME05，比赛于8点35分开始，双方开\r\n\r\n场之后都有所保留，以试探对手为主，上半场比赛进行到第10分钟时，CSG07的周斌率先\r\n打破僵局，也完成了本次比赛的第一粒入球。不过在接下来的比赛中，EE&IME05则占据了\r\n\r\n场上主动权，进攻防守都做得有声有色，队中的主力前锋叶晓阳更是一人独中3元，完成\r\n了帽子戏法，帮助本队成功逆转取胜。值得一提的是，在下半场比赛中还出现了本次信科\r\n\r\n杯的第一粒点球，只可惜CSG07的队员没能把握住机会，将球打偏了，错过了扳平比分的\r\n良机。\r\n    下午进行的由07新生123班联队对阵06联队的比赛可以用波澜不惊来形容，开场后不\r\n久，06联队就利用对方两名后卫的一次失误攻入一球。此后双方各有攻守，但均再无建树\r\n\r\n，最终本场比赛以1:0的比分收场。而在旁边场地进行的另一场比赛则精彩纷呈，开场不\r\n到一分钟，IME就通过一次闪电进攻打入一球，取得领先。但在这么早就先丢一球的情况\r\n下，“长江7号”并未急躁，并有效的组织了的进攻，在上半场就完成了2：1的逆转。下\r\n半场比赛中，双方都未能再进球，但比赛却是精彩异常，“长江7号”甚至在极短的时间\r\n内连续命中3脚门柱，让对方惊出了一身冷汗。\r\n    第一比赛日队员们的表现都很不错，场面也很和气，但和气中不乏精彩，希望以后的\r\n\r\n比赛会更好。\r\n',2,NULL,NULL,0,3,0,'2008-04-26 19:19:39','2008-04-26 19:19:39',NULL),(11,'[信科杯足球赛][战报]长江七号队与IST05队携手晋级','信科学生会体育部讯  今天中午，“信科杯”足球赛结束了B组小组赛的争夺，IST 05以1：0战胜了IME G1，长江七号也以1：0战胜07级456班，双双晋级八强。07级456班获得小组第三名，获得了参加晋级附加赛的机会。\r\n',2,NULL,NULL,0,3,0,'2008-04-26 19:21:17','2008-04-26 19:21:17',NULL),(12,'信科杯战报——EE&IME 05 vs 长江七号 2：0','   今天中午12：20，信科杯足球赛四分之一比赛第三场正式打响，最终EE&IME 05以2：0战胜长江七号。\r\n   今天比赛风较大，开场双方均未能很快进入状态，直至开场15分钟，长江七号后卫将球传至对方前锋脚下，叶初阳球门右侧起脚，球应声入网，1：0。\r\n   下半场长江七号明显加强了进攻，频繁出现后场无人情形。但半场压迫式进攻未见成效，九次有效进攻均无功而返。其中11分钟时的任意球被后卫破坏，15和17分钟时两次脚\r\n球踢出底线，20分钟时获得绝佳机会，怎奈前锋在球门线前一脚踢出。\r\n   这种孤注一掷的进攻策略为后场防守留下了弊端。下半场22分钟时EE&IME 05成功防下对手一次进攻，大脚开至前场，长江七号后卫被迫将球破坏出靠近角球附近的边线，EE&IME 05队员直接将球发至球门立柱一侧，黄志远小角度破门得分，2：0。\r\n   临近终场，EE&IME 05得到两次防守反击机会，分别形成3打0和2打0的局面。但进攻队员处于越位位置，持球队员无法及时将球传出，被守门员没收。\r\n   最终比分定格在2：0，EE&IME 05成功晋级，杀入四强。\r\n',2,NULL,NULL,0,3,0,'2008-04-26 19:23:04','2008-04-26 19:23:04',NULL),(13,'信科杯出局，长江七号继续','昨天欧冠，今天大风，真不是在为失败找客观原因，呵呵\r\n过程不用多说，虽然错失了一些机会很遗憾，但是有胜利就会有失败出来混总是要还的...\r\n\r\n遇上小组赛进球最多的EE&IME 05，我们大家也做好了准备\r\n因此，今天虽然不算是最好状态，我们大家却都到齐了，翘实验室，翘实习...\r\n现在看起来，多少有些悲壮，不过也算是完整\r\n唯一的遗憾是感冒的fengjianqiao同学没能上场。\r\n\r\n感谢各位对手对我们这群老骨头的照顾，感谢组织者对我们比赛时间的选择上的宽容能够打入八强，我们已经很Happy。\r\n当然，还要感谢我们的队员，本来想逐个感谢，md劳资就不煽情了不过盒饭你永远是我们的核心，雷队你永远是长江七号的队长，兼冠名人...\r\nyangyang你虽然空门不进，但是至少过人很帅...\r\n还有赵一脚和马一炮，博士水准就是不一样！并列最佳射手\r\n\r\n最主要的是，长江七号是个很和谐，很有技术含量，兼很有冷魂的集体\r\n\r\n所以，我希望，信科杯结束了，长江七号还能继续\r\n另外，长江七号是不是一个很能腐败的集体呢？\r\n\r\n\r\n\r\n-----------------\r\nfrom  lobatt\r\n2008年04月02日17:17:59 星期三',2,NULL,NULL,0,3,1,'2008-04-26 19:25:03','2008-04-26 19:29:17',NULL),(14,'[Tips]发邀请的方法','如果你刚刚加入这个地方，又没有什么朋友和球队，是应该很想把一块踢球的朋友们叫来一起玩，那你可以给他们发一个邀请~\r\n在这里，发邀请有两种手段：\r\n1.以个人名义发邀请\r\n在“我的首页”，顶级导航条里“朋友”一项中有三个选项，点选第三个选项“邀请朋友使用wefootball”\r\n在弹出的页面中，输入朋友的邮箱以及留言说明，确定发送之后一个邀请就发出了~是不是很简单呢？\r\n收到邀请的朋友在注册及激活账号以后，就会自动地同发出邀请的人建立朋友关系，这应该是很自然的吧？hoho~~\r\n2.以球队的名义发邀请\r\n\r\n########注意########\r\n这是球队管理员才拥有的特权哦~\r\n########注意########\r\n\r\n这里要分两种情况\r\n(A)在邀请朋友以前，你们的球队还没有创建\r\n如果说你有备而来，想为球队建立有一个有序有效的管理手段，那么你就找对地方了~~\r\n在“我的首页”，顶级导航条里“球队”一项中有四个选项，点选“新建球队”，按照说明填写球队相应资料后，就可以“创建”你的球队了（这些资料都是可以更改的哦，还可以上传队标~）\r\n在球队建立好以后，按照1.中的方法进行，然后在发出邀请以前可以看到页面上已经列出了你所加入的球队，在球队图标后的复选框中选中希望朋友加入的球队后，发出邀请，这样朋友在注册和激活后，不仅能自然成为你的朋友，还可以自然加入你选择的球队~\r\n\r\n(B)邀请朋友加入已经创建的球队\r\n那就可以按照(A)中的方法，只需要略过创建球队的步骤即可~\r\n',4,NULL,NULL,0,3,0,'2008-04-26 19:55:57','2008-04-26 20:01:55',NULL),(15,'[Tips]随便踢踢，训练及比赛','随便踢踢\r\n今天天气不错，你突然有了想去踢球的想法，但是不见得能够马上找到你那些朋友，又或者他们都有事，再或者你其实想换一个心情踢踢球，那么这一项功能就是你的最好选择了\r\n\r\n在“我的首页”，顶级导航条“活动”下，选择“随便踢踢”\r\n在弹出的页面中，选择好踢球的时间（年月日小时），再选择好要去哪里踢（可以选择已由系统管理员审批通过的场地标注，也可以自己填写一个），然后就可以创建这样一个活动了\r\n你的朋友或者陌生人都可以在广播中看到这个活动，也可以通过对时间点和地点的搜索找到你的这个活动哦~\r\n\r\n\r\n\r\n训练和比赛\r\n这是球队管理的重要组成部分\r\n如果你的球队在参加某项赛事，你可以把这些比赛日程都添加到日历中，队友们可以一目了然，而且方便球队管理员统计队员们是否要去参加某次比赛。围绕着比赛还可以展开很多讨论，以及根据不同的比赛制定球队的战术和阵型~\r\n\r\n在没有比赛的日子，我们无法停止训练~你可以给自己的球队安排适时的训练，以保证你的球队拥有持续强劲的战斗力~训练的性质和创建发放跟比赛差不多，但不同的是，对手是你自己！',4,NULL,NULL,0,3,0,'2008-04-26 20:13:44','2008-04-26 20:13:44',NULL),(16,'下次比赛是什么时候呢？','哎，我想把时间安排填写了都不行~',5,NULL,NULL,0,3,0,'2008-04-26 20:16:32','2008-04-26 20:16:32',NULL),(17,'关于队标','大家有更清晰或者不同年代的队标就修改一下吧，也可以讨论一下用什么，我这个是临时用的哈~',3,NULL,NULL,0,3,0,'2008-04-26 21:31:17','2008-04-26 21:31:17',NULL),(18,'[Tips]发邀请的方法','如果你刚刚加入这个地方，又没有什么朋友和球队，是应该很想把一块踢球的朋友们叫来一起玩，那你可以给他们发一个邀请~ \r\n在这里，发邀请有两种手段： \r\n1.以个人名义发邀请 \r\n在“我的首页”，顶级导航条里“朋友”一项中有三个选项，点选第三个选项“邀请朋友使用wefootball” \r\n在弹出的页面中，输入朋友的邮箱以及留言说明，确定发送之后一个邀请就发出了~是不是很简单呢？ \r\n收到邀请的朋友在注册及激活账号以后，就会自动地同发出邀请的人建立朋友关系，这应该是很自然的吧？hoho~~ \r\n2.以球队的名义发邀请\r\n\r\n########注意######## \r\n这是球队管理员才拥有的特权哦~ \r\n########注意########\r\n\r\n这里要分两种情况 \r\n(A)在邀请朋友以前，你们的球队还没有创建 \r\n如果说你有备而来，想为球队建立有一个有序有效的管理手段，那么你就找对地方了~~ \r\n在“我的首页”，顶级导航条里“球队”一项中有四个选项，点选“新建球队”，按照说明填写球队相应资料后，就可以“创建”你的球队了（这些资料都是可以更改的哦，还可以上传队标~） \r\n在球队建立好以后，按照1.中的方法进行，然后在发出邀请以前可以看到页面上已经列出了你所加入的球队，在球队图标后的复选框中选中希望朋友加入的球队后，发出邀请，这样朋友在注册和激活后，不仅能自然成为你的朋友，还可以自然加入你选择的球队~\r\n\r\n(B)邀请朋友加入已经创建的球队 \r\n那就可以按照(A)中的方法，只需要略过创建球队的步骤即可~ \r\n\r\n',3,NULL,NULL,0,3,0,'2008-04-26 21:41:45','2008-04-26 21:41:45',NULL),(19,'[Tips]随便踢踢，训练及比赛','随便踢踢 \r\n今天天气不错，你突然有了想去踢球的想法，但是不见得能够马上找到你那些朋友，又或者他们都有事，再或者你其实想换一个心情踢踢球，那么这一项功能就是你的最好选择了\r\n\r\n在“我的首页”，顶级导航条“活动”下，选择“随便踢踢” \r\n在弹出的页面中，选择好踢球的时间（年月日小时），再选择好要去哪里踢（可以选择已由系统管理员审批通过的场地标注，也可以自己填写一个），然后就可以创建这样一个活动了 \r\n你的朋友或者陌生人都可以在广播中看到这个活动，也可以通过对时间点和地点的搜索找到你的这个活动哦~\r\n\r\n训练和比赛 \r\n这是球队管理的重要组成部分 \r\n如果你的球队在参加某项赛事，你可以把这些比赛日程都添加到日历中，队友们可以一目了然，而且方便球队管理员统计队员们是否要去参加某次比赛。围绕着比赛还可以展开很多讨论，以及根据不同的比赛制定球队的战术和阵型~\r\n\r\n在没有比赛的日子，我们无法停止训练~你可以给自己的球队安排适时的训练，以保证你的球队拥有持续强劲的战斗力~训练的性质和创建发放跟比赛差不多，但不同的是，对手是你自己！\r\n',3,NULL,NULL,0,3,0,'2008-04-26 21:43:17','2008-04-26 21:43:17',NULL),(20,'回复第一次训练','明天要去玩儿……石景山公园\r\n不如staf你也一起去吧，随便去Cappy家哈：）',3,3,NULL,1,26,3,'2008-04-26 21:45:48','2008-04-26 23:20:16',NULL),(21,'[Tips]发邀请的方法','如果你刚刚加入这个地方，又没有什么朋友和球队，是应该很想把一块踢球的朋友们叫来一起玩，那你可以给他们发一个邀请~\r\n在这里，发邀请有两种手段：\r\n1.以个人名义发邀请\r\n在“我的首页”，顶级导航条里“朋友”一项中有三个选项，点选第三个选项“邀请朋友使用wefootball”\r\n在弹出的页面中，输入朋友的邮箱以及留言说明，确定发送之后一个邀请就发出了~是不是很简单呢？\r\n收到邀请的朋友在注册及激活账号以后，就会自动地同发出邀请的人建立朋友关系，这应该是很自然的吧？hoho~~\r\n2.以球队的名义发邀请\r\n这里要分两种情况\r\n(A)在邀请朋友以前，你们的球队还没有创建\r\n如果说你有备而来，想为球队建立有一个有序有效的管理手段，那么你就找对地方了~~\r\n在“我的首页”，顶级导航条里“球队”一项中有四个选项，点选“新建球队”，按照说明填写球队相应资料后，就可以“创建”你的球队了（这些资料都是可以更改的哦，还可以上传队标~）\r\n在球队建立好以后，按照1.中的方法进行，然后在发出邀请以前可以看到页面上已经列出了你所加入的球队，在球队图标后的复选框中选中希望朋友加入的球队后，发出邀请，这样朋友在注册和激活后，不仅能自然成为你的朋友，还可以自然加入你选择的球队~\r\n\r\n(B)邀请朋友加入已经创建的球队\r\n那就可以按照(A)中的方法，只需要略过创建球队的步骤即可~\r\n\r\n\r\n',1,NULL,NULL,0,3,0,'2008-04-26 22:27:27','2008-04-26 22:27:27',NULL),(22,'[Tips]随便踢踢，训练及比赛','随便踢踢\r\n今天天气不错，你突然有了想去踢球的想法，但是不见得能够马上找到你那些朋友，又或者他们都有事，再或者你其实想换一个心情踢踢球，那么这一项功能就是你的最好选择了\r\n在“我的首页”，顶级导航条“活动”下，选择“随便踢踢”\r\n在弹出的页面中，选择好踢球的时间（年月日小时），再选择好要去哪里踢（可以选择已由系统管理员审批通过的场地标注，也可以自己填写一个），然后就可以创建这样一个活动了\r\n你的朋友或者陌生人都可以在广播中看到这个活动，也可以通过对时间点和地点的搜索找到你的这个活动哦~\r\n\r\n\r\n\r\n训练和比赛\r\n这是球队管理的重要组成部分\r\n如果你的球队在参加某项赛事，你可以把这些比赛日程都添加到日历中，队友们可以一目了然，而且方便球队管理员统计队员们是否要去参加某次比赛。围绕着比赛还可以展开很多讨论，以及根据不同的比赛制定球队的战术和阵型~\r\n在没有比赛的日子，我们无法停止训练~你可以给自己的球队安排适时的训练，以保证你的球队拥有持续强劲的战斗力~训练的性质和创建发放跟比赛差不多，但不同的是，对手是你自己！',1,NULL,NULL,0,3,0,'2008-04-26 22:28:00','2008-04-26 22:28:00',NULL),(23,'明日首战，没事都来吧','农他们。。。',5,NULL,NULL,0,2,1,'2008-04-27 17:06:45','2008-04-27 17:10:36',2),(24,'很好。。。','哈哈哈哈 ',8,NULL,NULL,0,28,0,'2008-04-27 20:42:44','2008-04-27 20:42:44',NULL),(25,'glory manutd','!!!',8,NULL,NULL,0,34,0,'2008-04-27 20:55:58','2008-04-27 20:55:58',NULL),(26,'欢迎大家提前预测出场阵容和比分','嗯那 XD\r\n\r\n如果又输给国安，我们再让nash用bg来抚慰我们脆弱的小心脏叭～',6,NULL,NULL,0,30,0,'2008-04-28 09:28:43','2008-04-28 09:28:43',4),(27,'我已经是废人了。。。','下次别叫我了。。。',5,NULL,NULL,0,1,1,'2008-04-28 15:03:48','2008-04-28 15:17:41',NULL),(28,'今天大家踢得挺不错的','在房队的领导下打出了气势\r\n加油加油，下场再接再厉~',5,NULL,NULL,0,2,2,'2008-04-28 15:16:55','2008-04-29 16:59:44',2),(29,'哦哈哈','把他们都加进来\r\n\r\n恩',7,NULL,NULL,0,28,0,'2008-04-28 17:37:01','2008-04-28 17:37:01',NULL),(30,'很好很强大','晋级决赛，恩',8,NULL,NULL,0,28,0,'2008-04-30 06:07:13','2008-04-30 06:07:13',NULL),(31,'寻找部队','今天去了，但是问了好几个队的球员都没有找到你们。希望下次能有办法更方便的找到大部队。不知能否采用留联系方式等方法？\r\n仍然谢谢热心的组织者。',1,1,NULL,1,36,0,'2008-05-01 23:55:57','2008-05-01 23:55:57',NULL);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `register_invitations`
--

DROP TABLE IF EXISTS `register_invitations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `register_invitations` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `invitation_code` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `register_invitations`
--

LOCK TABLES `register_invitations` WRITE;
/*!40000 ALTER TABLE `register_invitations` DISABLE KEYS */;
INSERT INTO `register_invitations` VALUES (8,'xzw@os.pku.edu.cn','d0a3639e566895948919b7f33822a826f6a1148e','2008-04-24 08:52:24','2008-04-24 08:52:24'),(16,'zzkktt@163.com','01eb7176500bfc8c17bbdf383d61e1207d5a27b6','2008-04-24 20:34:46','2008-04-24 20:34:46'),(19,'xuzhaowei@gmail.com','2df7a1c4966f0cfb1e5fee728a381d9738574d35','2008-04-25 09:53:31','2008-04-25 09:53:31'),(20,'149902113@qq.com','8a2f91aefdecbd301936d59be26f128eb51ea5f1','2008-04-25 11:50:48','2008-04-25 11:50:48'),(22,'hechenzhang_0@hotmail.com','f152faab58b3141bd42c27d46ebd3b924a998d45','2008-04-25 12:23:19','2008-04-25 12:23:19'),(24,'LUNACORY@GMAIL.COM','fb0786fe440c50edf42debef4c5736d8c262b807','2008-04-25 13:09:41','2008-04-25 13:09:41'),(25,'CAPPY@YAHOO.CN','ac074a36c4fb0e3b92b9ac717ea8da925feaea5d','2008-04-25 13:49:03','2008-04-25 13:49:03'),(26,'scorpioyuan@hotmail.com','3d5639b067bdc0e9ab0276ee1d0197d4c2c9c221','2008-04-25 16:04:05','2008-04-25 16:04:05'),(27,'camel_nunu@hotmail.com','40b331cafb4385a2409c6ce8e40ad973bbe1edc8','2008-04-25 16:07:04','2008-04-25 16:07:04'),(28,'TEAMOYJ@QQ.COM','8eff858d054dec747d2f89c877c730242ee6fe1f','2008-04-25 17:37:24','2008-04-25 17:37:24'),(29,'camel_nunu@hotmail.com','b48ad93fec483f0ab5ba29ea6ca60a5ce68ed087','2008-04-25 23:09:10','2008-04-25 23:09:10'),(31,'xzzhou@jdl.ac.cn','1a04881ac436ac4b1dfd5ae276df4a714b2cefd7','2008-04-26 11:57:15','2008-04-26 11:57:15'),(34,'zhouxc@pku.edu.cn','678d27756e7cece026808df99d03fad5652d24e7','2008-04-26 21:24:45','2008-04-26 21:24:45'),(37,'wangboqidi@yahoo.com.cn','2061cdc0dd6dcb6a4f7ffc53b5ab7e2a747e9512','2008-04-26 22:00:10','2008-04-26 22:00:10'),(38,'staf@pku.edu.cn','282e597169c851ec92c026742e66df1a449fd938','2008-04-26 22:01:14','2008-04-26 22:01:14'),(39,'mahongda@gmail.com','03abf80f304f6f61f9c853462c317c2e79ff07a3','2008-04-26 22:05:53','2008-04-26 22:05:53'),(40,'glorynash@gamil.com','7afde665a81004cafea14b1563626a09bbd43ff0','2008-04-26 22:06:08','2008-04-26 22:06:08'),(41,'blancozhang@gmail.com','b2adc087078afd9a9b7a38d6a090a5b16485cb7a','2008-04-26 23:01:14','2008-04-26 23:01:14'),(43,'bluetears_1987@hotmail.com','1d8dc3861df07caa38525b4e2898555acbd1fbd1','2008-04-26 23:02:41','2008-04-26 23:02:41'),(44,'blancozhang@gmail.com','21297aa82bde170eb90884c12af90da5ab43b56d','2008-04-26 23:03:40','2008-04-26 23:03:40'),(45,'wangwei13@gsm.pku.edu.cn','6318241ab1cb9ee51d4e5873cc914ad6647e5677','2008-04-26 23:03:55','2008-04-26 23:03:55'),(46,'bluetears_1987@hotmail.com','861ddab5a4ce61003e767496ce40d00f804edf80','2008-04-26 23:04:07','2008-04-26 23:04:07'),(51,'xuanshanming@hotmail.com','ecd51a22d0f4e912560e2b0896b1cdfd8b0913c4','2008-04-27 15:19:05','2008-04-27 15:19:05'),(52,'bochi1988@yahoo.com.cn','641a11a770e9f4c48c5b41d013a3f89317bd0159','2008-04-27 15:55:48','2008-04-27 15:55:48'),(53,'pku.lilin17@gmail.com','c83b20fd600b51323e696e6a686d656c6a69ab46','2008-04-27 16:22:28','2008-04-27 16:22:28'),(54,'smallsheet@gmail.com','7e1b347f86fca49169ab0fa18ab3651abb8aaca7','2008-04-27 16:39:17','2008-04-27 16:39:17'),(55,'yoann.gourcuff@gmail.com','d3083759c3196c7475dcc1a6a2a7318bdb9affae','2008-04-27 16:39:37','2008-04-27 16:39:37'),(56,'fynliang@gmail.com','a37e10cec882fc0c2f3b212132961c52cb72b7be','2008-04-27 16:39:51','2008-04-27 16:39:51'),(57,'doomking1234@163.com','3392755b5adf5a43bd7d2c8a7fb2e3148640e63f','2008-04-27 16:40:03','2008-04-27 16:40:03'),(58,'sherrymo@yeah.net','d5abe474de7051b3fb4a47f37158c178a4655948','2008-04-27 16:40:16','2008-04-27 16:40:16'),(65,'yiin17@gmail.com','1d3bf665941ce2e59b1af511e279cddf588bd53a','2008-04-27 20:27:40','2008-04-27 20:27:40'),(67,'wangle_williams@hotmail.com','1dc763b0ab28e2d9ce8581f039a14b67fd6acee1','2008-04-27 20:35:22','2008-04-27 20:35:22'),(68,'wolfyink@sina.com','f00ee30e7708f1c542ea7e5cd19bb001354f3b02','2008-04-27 21:22:32','2008-04-27 21:22:32'),(69,'baggiogrubby@163.com','0d3ad39d6b83110a831243b5c97207ab28a8f210','2008-04-27 21:22:39','2008-04-27 21:22:39'),(72,'zhaoxinglong@gmail.com','a594f7a2a7b47f7ebe5e11c3dc1c7d3759225e76','2008-04-27 22:43:30','2008-04-27 22:43:30'),(74,'xihuijinming@sina.com','b4e9df118d76115d96fdc789c61a6340f4ec2172','2008-04-27 22:43:48','2008-04-27 22:43:48'),(77,'schumacher8624@gmail.com','a3d66b58db455ab3f589a3251ae1d8117e46108d','2008-04-28 05:51:12','2008-04-28 05:51:12'),(78,'zhaoxinglong@gmail.com','291949b4b9d94173816d281252ec843eab3294cc','2008-04-28 05:51:22','2008-04-28 05:51:22'),(80,'zxc@mail.biti.edu.cn','817daeffdb151e41100abbcabb98b224ffdb0b9b','2008-04-28 13:14:31','2008-04-28 13:14:31'),(82,'tonny_liuzhe@hotmail.com','831008be66e89763f494eac76d4157648c5e601a','2008-04-28 15:02:55','2008-04-28 15:02:55'),(83,'charlyjw2001@163.com','549fd9f04d7df956c3e33b3328f366e2e67e1710','2008-04-28 15:03:32','2008-04-28 15:03:32'),(84,'gentilezoff@yahoo.com.cn','b58b98e2f828f80269e11d1dd3a726362d422ab6','2008-04-28 15:41:18','2008-04-28 15:41:18'),(88,'alessa611@163.com','e5032c61ec3ab42be314d17e1363227978a8bf05','2008-04-28 19:18:26','2008-04-28 19:18:26'),(89,'xihuijinming@sina.com','4c53c89ca5f8ef82e24d7a2cdc2691414b35d190','2008-04-28 19:29:51','2008-04-28 19:29:51'),(92,'xuanshanming@hotmail.com','b757418db1dffcb40d38586d1c7ceb2948e30878','2008-04-29 14:34:01','2008-04-29 14:34:01'),(96,'xiaofangcao@gmail.com','455cd292f0896bbac06c9d23edcd37d81e3d5389','2008-04-30 18:38:12','2008-04-30 18:38:12'),(98,'chao.shan@bdaconnect.com','d422e78044ca23a6448a0058ce2ab16fba5b9fce','2008-05-03 00:16:18','2008-05-03 00:16:18');
/*!40000 ALTER TABLE `register_invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `replies`
--

DROP TABLE IF EXISTS `replies`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `replies` (
  `id` int(11) NOT NULL auto_increment,
  `content` text,
  `post_id` int(11) default NULL,
  `team_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `replies`
--

LOCK TABLES `replies` WRITE;
/*!40000 ALTER TABLE `replies` DISABLE KEYS */;
INSERT INTO `replies` VALUES (1,'纯测试目的...我应该在',4,2,3,'2008-04-24 12:21:30','2008-04-24 12:21:30'),(2,'我在，要是大家都没啥事情的话去踢会？',4,2,2,'2008-04-24 13:28:45','2008-04-24 13:28:45'),(3,'我不在',4,2,1,'2008-04-24 13:44:40','2008-04-24 13:44:40'),(4,'楼上的,给丫送派出所去...',4,2,3,'2008-04-24 17:07:20','2008-04-24 17:07:20'),(5,'顶起...',4,2,10,'2008-04-24 23:09:03','2008-04-24 23:09:03'),(6,'orz\r\n他们知道这个地方吗，汗。。。',5,3,20,'2008-04-25 12:06:48','2008-04-25 12:06:48'),(7,'你给他们的邮箱发邀请啊\r\n要不你去版上做个邮箱的统计吧，把这事说一下\r\n以后咱版踢就方便了呢~',5,3,3,'2008-04-25 12:08:54','2008-04-25 12:08:54'),(8,'好。。。在哪发邀请？\r\n这个退出球队按钮也没有个确认？。。。一不小心点错了就退出去了。。。晕',5,3,20,'2008-04-25 12:12:58','2008-04-25 12:12:58'),(9,'哦，你是误点了的是吧？好的，这是个问题，我来修正~\r\n在你的个人页面里面，有一个朋友按钮，里面有一个邀请朋友来wefootball，里面输入别人的邮箱，然后在下面可以选择同时发出哪一个队的入队邀请，这是作为球队管理员的权限~',5,3,3,'2008-04-25 12:17:37','2008-04-25 12:17:37'),(10,'这...来踢呀~~',7,1,3,'2008-04-26 13:10:26','2008-04-26 13:10:26'),(11,'这算是遂你的愿了哈~~',13,2,3,'2008-04-26 19:29:17','2008-04-26 19:29:17'),(12,'很赞：）',9,3,26,'2008-04-26 21:40:32','2008-04-26 21:40:32'),(13,'hoho~~希望能够真的给大家带来便利~~',9,3,3,'2008-04-26 21:42:08','2008-04-26 21:42:08'),(14,'这样啊？可能去不了了呢，明天晚上6点实验室已经毕业的师姐请吃饭哈，我怕赶不及了呢~你们去好好玩吧，我在学校踢踢球就好了！Cappy真是好孩子~~',20,3,3,'2008-04-26 21:53:34','2008-04-26 21:53:34'),(15,'wuwuwu~~明天ibt的可怜candy飘过~~~~~~',20,3,27,'2008-04-26 23:12:18','2008-04-26 23:12:18'),(16,'ibt??bless~~~upupup~~\r\n一定没问题的哈~~',20,3,3,'2008-04-26 23:20:16','2008-04-26 23:20:16'),(17,'身体贼虚。。。弄p呀。。。呐喊助威了',23,5,1,'2008-04-27 17:10:36','2008-04-27 17:10:36'),(18,'z@n!!\r\n\r\n以后我常驻这里啦~~',9,3,42,'2008-04-28 15:02:12','2008-04-28 15:02:12'),(19,'下次去看包买水吧，你负责上半场我负责下半场。。。',27,5,2,'2008-04-28 15:17:41','2008-04-28 15:17:41'),(20,'好的呀~~',9,3,3,'2008-04-28 15:23:06','2008-04-28 15:23:06'),(21,'房主席是好主席~~',28,5,3,'2008-04-29 00:32:25','2008-04-29 00:32:25'),(22,'咋还不见战报？',28,5,10,'2008-04-29 16:59:44','2008-04-29 16:59:44');
/*!40000 ALTER TABLE `replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schema_info`
--

LOCK TABLES `schema_info` WRITE;
/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
INSERT INTO `schema_info` VALUES (34);
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sided_match_joins`
--

DROP TABLE IF EXISTS `sided_match_joins`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sided_match_joins` (
  `id` int(11) NOT NULL auto_increment,
  `match_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `goal` int(11) default '0',
  `yellow_card` int(11) default '0',
  `red_card` int(11) default '0',
  `position` int(11) default NULL,
  `status` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sided_match_joins`
--

LOCK TABLES `sided_match_joins` WRITE;
/*!40000 ALTER TABLE `sided_match_joins` DISABLE KEYS */;
INSERT INTO `sided_match_joins` VALUES (4,2,3,0,0,0,0,1,'2008-04-27 15:32:32','2008-05-01 20:47:35'),(5,2,24,1,0,0,18,0,'2008-04-27 15:32:32','2008-05-01 20:47:35'),(6,2,2,0,0,0,9,1,'2008-04-27 15:32:32','2008-05-01 20:47:35'),(10,4,30,0,0,0,NULL,1,'2008-04-27 16:08:18','2008-04-27 16:12:31'),(15,2,1,0,0,0,7,1,'2008-04-27 16:51:24','2008-05-01 20:47:35'),(21,4,38,0,0,0,NULL,0,'2008-04-28 12:31:38','2008-04-28 12:31:38'),(22,2,10,0,0,0,NULL,1,'2008-04-28 12:35:48','2008-05-01 20:47:35'),(23,9,3,0,0,0,NULL,0,'2008-04-28 15:43:15','2008-04-28 15:44:16'),(24,9,20,0,0,0,NULL,0,'2008-04-28 15:43:15','2008-04-28 15:43:15'),(25,9,26,0,0,0,NULL,0,'2008-04-28 15:43:15','2008-04-28 15:44:16'),(26,9,27,0,0,0,NULL,0,'2008-04-28 15:43:15','2008-04-28 15:43:15'),(27,9,42,0,0,0,NULL,0,'2008-04-28 15:43:15','2008-04-28 15:43:15'),(28,4,51,0,0,0,NULL,0,'2008-04-29 14:53:13','2008-04-29 14:53:13');
/*!40000 ALTER TABLE `sided_match_joins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sided_matches`
--

DROP TABLE IF EXISTS `sided_matches`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sided_matches` (
  `id` int(11) NOT NULL auto_increment,
  `start_time` datetime default NULL,
  `end_time` datetime default NULL,
  `location` varchar(300) default '',
  `match_type` int(11) default NULL,
  `size` int(11) default '5',
  `has_judge` tinyint(1) default NULL,
  `has_card` tinyint(1) default NULL,
  `has_offside` tinyint(1) default NULL,
  `win_rule` int(11) default NULL,
  `description` text,
  `half_match_length` int(11) default '0',
  `rest_length` int(11) default '0',
  `host_team_id` int(11) default NULL,
  `guest_team_name` varchar(15) default NULL,
  `host_team_goal` int(11) default NULL,
  `guest_team_goal` int(11) default NULL,
  `situation` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `football_ground_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sided_matches`
--

LOCK TABLES `sided_matches` WRITE;
/*!40000 ALTER TABLE `sided_matches` DISABLE KEYS */;
INSERT INTO `sided_matches` VALUES (2,'2008-04-28 13:15:00','2008-04-28 14:30:00','北京大学第一体育场',2,7,1,1,1,1,'lab杯第一场',30,15,5,'北京欢迎你',1,1,5,'2008-04-27 15:32:32','2008-05-01 20:47:35',1),(4,'2008-05-18 19:00:00','2008-05-18 20:45:00','北京市丰台体育中心',2,11,1,1,1,1,'这个比赛是真的……\r\n欢迎大家组团去丰台体育中心看球～',45,15,6,'北京国安',NULL,NULL,NULL,'2008-04-27 16:08:18','2008-04-28 09:26:58',NULL),(9,'2008-04-28 03:00:00','2008-04-28 04:45:00','伯纳乌',2,11,1,1,1,1,'2007~2008赛季西甲第34轮',45,15,3,'毕尔巴鄂竞技',3,0,3,'2008-04-28 15:43:15','2008-04-28 15:44:16',NULL);
/*!40000 ALTER TABLE `sided_matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_post_admins`
--

DROP TABLE IF EXISTS `site_post_admins`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_post_admins` (
  `user_id` int(11) default NULL,
  KEY `index_site_post_admins_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `site_post_admins`
--

LOCK TABLES `site_post_admins` WRITE;
/*!40000 ALTER TABLE `site_post_admins` DISABLE KEYS */;
INSERT INTO `site_post_admins` VALUES (1),(2),(3);
/*!40000 ALTER TABLE `site_post_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_posts`
--

DROP TABLE IF EXISTS `site_posts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_posts` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(100) default NULL,
  `content` text,
  `user_id` int(11) default NULL,
  `email` varchar(255) default NULL,
  `site_replies_count` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `site_posts`
--

LOCK TABLES `site_posts` WRITE;
/*!40000 ALTER TABLE `site_posts` DISABLE KEYS */;
INSERT INTO `site_posts` VALUES (2,'为什么大家都不放头像呢。。。','是不是个人设置那里不是很直观呢',2,NULL,9,'2008-04-27 11:57:11','2008-04-30 21:58:06'),(3,'组织比赛出了问题@_@~','具体内容显示不出来\r\n\r\n且标题被我搞的，多出来好多次>_<',30,NULL,6,'2008-04-27 16:12:20','2008-04-28 11:21:55'),(4,'申请注册','先谢谢staf等三位帅哥的贡献。希望有机会一起切磋交流。',NULL,'rxiaocheng@vip.sina.com',2,'2008-04-27 20:06:09','2008-04-27 21:25:27');
/*!40000 ALTER TABLE `site_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_replies`
--

DROP TABLE IF EXISTS `site_replies`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `site_replies` (
  `id` int(11) NOT NULL auto_increment,
  `content` text,
  `site_post_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `email` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `site_replies`
--

LOCK TABLES `site_replies` WRITE;
/*!40000 ALTER TABLE `site_replies` DISABLE KEYS */;
INSERT INTO `site_replies` VALUES (1,'我放了……',2,30,NULL,'2008-04-27 15:37:43','2008-04-27 15:37:43'),(2,'汗。。。可否描述的更清楚一些？谢谢啦~',3,3,NULL,'2008-04-27 16:53:47','2008-04-27 16:53:47'),(3,'我改了~~',3,1,NULL,'2008-04-27 16:56:09','2008-04-27 16:56:09'),(5,'@hokey: 赞。。。你觉得个人设置那里用几个tab页足够直观吗？还是大家都比较能忍那个默认的绿绿的问号。。。',2,2,NULL,'2008-04-27 16:59:18','2008-04-27 16:59:18'),(6,'@霏昀：是个什么问题，那天改乱了？你再点点别的check一下',3,2,NULL,'2008-04-27 17:12:55','2008-04-27 17:12:55'),(7,'可以点比赛详情，有个取消可以把多安排的比赛取消掉',3,3,NULL,'2008-04-27 17:17:03','2008-04-27 17:17:03'),(8,'请留一下你的邮箱，我们的邀请会发到你的邮箱中',4,2,NULL,'2008-04-27 20:12:04','2008-04-27 20:12:04'),(10,'谢谢哈~~',4,3,NULL,'2008-04-27 21:25:27','2008-04-27 21:25:27'),(11,'辛苦达人们^O^\r\n多出来的比赛已经被我咔嚓咔嚓了～\r\n谢谢各位哈～～～\r\n继续支持你们，hiahia~~~',3,30,NULL,'2008-04-28 09:31:48','2008-04-28 09:31:48'),(12,'是不是把头像扔到个人设置里面会比较麻烦哈？@.@~\r\n\r\n其实还可以塞几个球星头像谨供选择。。。这样懒人也可以有脑袋了',2,30,NULL,'2008-04-28 11:03:22','2008-04-28 11:03:22'),(13,'呵呵，谢谢你的支持:)',3,2,NULL,'2008-04-28 11:21:55','2008-04-28 11:21:55'),(14,'有道理。。。不过就怕门户不同各有所爱，到时候放谁不放谁很难决定。。。',2,2,NULL,'2008-04-28 11:25:15','2008-04-28 11:25:15'),(15,'那就放足球小子里的……\r\n\r\n大空翼宫大郎松仁石崎料，多了不放，就这几个，如果嫌少，欢迎致电站务组……\r\n\r\n我觉得选石崎料的应该挺多哈哈^^\r\n\r\n或者就08年欧洲杯吉祥物啊06年世界杯吉祥物啊……拖家带口的其实选择很多>_<',2,30,NULL,'2008-04-28 13:03:38','2008-04-28 13:03:38'),(16,'好主意，谢谢啦。我们会认真地讨论一下你的建议:)',2,2,NULL,'2008-04-28 22:12:10','2008-04-28 22:12:10'),(17,'hoho^^',2,NULL,NULL,'2008-04-29 14:31:28','2008-04-29 14:31:28'),(18,'  我是王子 ',2,NULL,'puma318puma@sina.com.cn','2008-04-30 20:30:36','2008-04-30 20:30:36'),(19,'王子，邀请已发出，请查收:)',2,2,NULL,'2008-04-30 21:58:06','2008-04-30 21:58:06');
/*!40000 ALTER TABLE `site_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_images`
--

DROP TABLE IF EXISTS `team_images`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `team_images` (
  `id` int(11) NOT NULL auto_increment,
  `filename` varchar(255) default NULL,
  `content_type` varchar(255) default NULL,
  `size` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `thumbnail` varchar(255) default NULL,
  `team_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `team_images`
--

LOCK TABLES `team_images` WRITE;
/*!40000 ALTER TABLE `team_images` DISABLE KEYS */;
INSERT INTO `team_images` VALUES (1,'00000001.jpg','image/pjpeg',23802,NULL,NULL,1),(2,'00000001_small.jpg','image/pjpeg',24165,1,'small',NULL),(3,'00000002.jpg','image/pjpeg',109397,NULL,NULL,2),(4,'00000002_small.jpg','image/pjpeg',18169,3,'small',NULL),(5,'00000003.jpg','image/pjpeg',3310,NULL,NULL,3),(6,'00000003_small.jpg','image/pjpeg',1730,5,'small',NULL),(7,'00000004.gif','image/pjpeg',42782,NULL,NULL,4),(8,'00000004_small.gif','image/pjpeg',17435,7,'small',NULL),(9,'00000006.jpg','image/pjpeg',5584,NULL,NULL,6),(10,'00000006_small.jpg','image/pjpeg',4010,9,'small',NULL),(11,'00000005.jpg','image/pjpeg',86255,NULL,NULL,5),(12,'00000005_small.jpg','image/pjpeg',34529,11,'small',NULL),(13,'00000008.jpg','image/jpeg',8404,NULL,NULL,8),(14,'00000008_small.jpg','image/jpeg',3064,13,'small',NULL),(15,'00000009.jpg','image/pjpeg',1295,NULL,NULL,9),(16,'00000009_small.jpg','image/pjpeg',1943,15,'small',NULL);
/*!40000 ALTER TABLE `team_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_join_requests`
--

DROP TABLE IF EXISTS `team_join_requests`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `team_join_requests` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `team_id` int(11) default NULL,
  `is_invitation` tinyint(1) default '0',
  `message` text,
  `apply_date` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `team_join_requests`
--

LOCK TABLES `team_join_requests` WRITE;
/*!40000 ALTER TABLE `team_join_requests` DISABLE KEYS */;
INSERT INTO `team_join_requests` VALUES (8,24,6,1,'这里这里','2008-04-27'),(9,31,7,1,'','2008-04-27'),(11,35,8,1,'','2008-04-27'),(16,40,7,0,'','2008-04-28'),(17,38,5,1,'赶紧的~~今天的比赛哈~','2008-04-28'),(18,14,1,1,'','2008-04-28'),(23,5,1,1,'~~','2008-04-29'),(24,50,8,1,'','2008-04-29'),(25,32,8,0,'zzkktt','2008-04-30'),(26,54,3,0,'','2008-04-30');
/*!40000 ALTER TABLE `team_join_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `teams` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `shortname` varchar(15) default NULL,
  `city` int(3) default '0',
  `summary` text,
  `found_time` date default NULL,
  `image_path` varchar(255) default NULL,
  `style` varchar(50) default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'','WeFootball',9,'','2008-04-23','/images/teams/00/00/00/01.jpg',''),(2,'就是长江七号','长江七号',9,'信科杯，兄弟们的球队~~','2008-04-24','/images/teams/00/00/00/02.jpg','全攻全守'),(3,'未名皇马版','realmadrid @wm',9,'未名皇马球迷的家','2008-04-24','/images/teams/00/00/00/03.jpg','全攻全守'),(4,'新人集结号','新人集结号',9,'刚来又不知道该去哪个队伍的朋友的集散地~~\r\n\r\n########################################\r\n当你已经足够熟悉网站的各种功能了，你就可以离开这个新手村了哈~~\r\n########################################','2008-04-25','/images/teams/00/00/00/04.gif',''),(5,'','没事踢踢球才是正经事',1,'老中青三代，为了lab杯而来~','2008-04-26','/images/teams/00/00/00/05.jpg','全攻全守'),(6,'未名大连实德特别行动组','大连实德',9,'05年五四小场不败球队\r\n06年“未名杯”冠军球队\r\n07年“未名杯”冠军球队\r\n08年即将解散球队……','2008-04-27','/images/teams/00/00/00/06.jpg','天花乱坠惊为天人..'),(7,'北大 CSG07','PKU-JBM',1,'','2008-04-27',NULL,''),(8,'曼联王朝','GloryManUtd',1,'','2008-04-27','/images/teams/00/00/00/08.jpg',''),(9,'北大尤文图斯','Juventus PKU',9,'','2008-04-28','/images/teams/00/00/00/09.jpg',''),(10,'利物浦@PKU','Liverpool.PKU',9,'　　26 卡森     Scott Carson                   1985-9-3      英格兰    门将\r\n\r\n　　30 伊坦杰 Charles Itandje               1982-11-2     法国      门将\r\n\r\n　　25 雷纳     Jose Manuel Reina Paez 1982-8-31     西班牙  门将\r\n\r\n　　40 马丁     David Martin                    1986-1-22     英格兰   门将\r\n\r\n　　12 奥雷里奥 Fabio Aurelio               1979-9-24    巴西    左后卫/左前卫\r\n\r\n　　6 里瑟       John.Arne.Riise               1980-9-24     挪威  左后卫/左前卫\r\n\r\n　　23 卡拉格 Jamie Carragher              1978-1-28   英格兰 中卫/左后卫/右后卫\r\n\r\n　　46 霍布斯 Jack.Hobbs                      1988-8-18 英格兰  中卫/防守中场\r\n\r\n　　5 阿格尔   Daniel Agger                    1984-12-12  丹麦  中卫/左后卫\r\n\r\n　　4 海皮亚   Sami Hyypia                      1973-10-7  芬兰  中卫\r\n\r\n　　37 斯科特尔 Martin Skrtel                1984-12-15 斯洛伐克 中卫\r\n  \r\n       3 芬南 Steve Finnan                         1976-4-20  爱尔兰 右后卫\r\n\r\n　　17 阿贝罗阿 álvaro Arbeloa              1981-1-17 西班牙 右后卫/左后卫/中卫\r\n\r\n　　39 达比   Stephen Darby                   1988-10-6  英格兰  左后卫\r\n\r\n　　11 贝纳永 Yosef Shai Benayoun      1980-5-5   以色列  右前卫/中前卫/左前卫\r\n\r\n　　33 列托  Sebastian Leto                    1986-8-30  阿根廷 左前卫/进攻中场\r\n\r\n　　7  科威尔 Harry.Kewell                      1978-9-22 澳大利亚 左边锋/进攻中场\r\n\r\n　　20 马斯切拉诺 Javier Mascherano   1984-6-8   阿根廷   防守中场\r\n\r\n　　14 阿隆索 Xabi Alonso Olano           1981-11-25 西班牙 中前卫\r\n\r\n　　8 杰拉德 Steven George Gerrard    1980-5-30 英格兰  中前卫/右前卫\r\n　　\r\n       21 卢卡斯 Lucas Pezzini Leiva          1987-1-9   巴西   防守中场\r\n\r\n　　16 彭南特 Jermaine Pennant             1983-1-15 英格兰 右边锋\r\n\r\n　　15 克劳奇 Peter Crouch                   1981-1-30 英格兰  前锋\r\n\r\n　　9 托雷斯   Fernando Jose Torres Sanz  1984-3-20 西班牙 前锋\r\n\r\n　　10 沃洛宁 Andriy Voronin                1979-7-21 乌克兰  前锋\r\n\r\n　　19 巴贝尔 Ryan Guno Babel           1986-12-19 荷兰   左边锋/前锋\r\n\r\n　　18库伊特 Dirk Kuyt                         1980-7-22   荷兰   前锋/右边锋','2008-04-28',NULL,'you will never walk alone');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training_joins`
--

DROP TABLE IF EXISTS `training_joins`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `training_joins` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `training_id` int(11) default NULL,
  `status` int(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `training_joins`
--

LOCK TABLES `training_joins` WRITE;
/*!40000 ALTER TABLE `training_joins` DISABLE KEYS */;
INSERT INTO `training_joins` VALUES (2,2,1,1),(3,3,1,1),(4,4,1,0),(8,7,1,0),(10,17,1,1),(11,16,1,0),(15,22,1,0),(18,36,1,1);
/*!40000 ALTER TABLE `training_joins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainings`
--

DROP TABLE IF EXISTS `trainings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `trainings` (
  `id` int(11) NOT NULL auto_increment,
  `start_time` datetime default NULL,
  `end_time` datetime default NULL,
  `location` varchar(100) default NULL,
  `summary` text,
  `team_id` int(11) default NULL,
  `football_ground_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `trainings`
--

LOCK TABLES `trainings` WRITE;
/*!40000 ALTER TABLE `trainings` DISABLE KEYS */;
INSERT INTO `trainings` VALUES (1,'2008-05-01 15:00:00','2008-05-01 17:00:00','北京大学第一体育场','希望能够踢一次球...',1,1),(3,'2008-04-27 13:00:00','2008-04-27 15:00:00','北京大学第一体育场','大家都来吧~~',3,1);
/*!40000 ALTER TABLE `trainings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `un_reg_friend_invs`
--

DROP TABLE IF EXISTS `un_reg_friend_invs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `un_reg_friend_invs` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `invitation_id` int(11) default NULL,
  `host_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `un_reg_friend_invs`
--

LOCK TABLES `un_reg_friend_invs` WRITE;
/*!40000 ALTER TABLE `un_reg_friend_invs` DISABLE KEYS */;
INSERT INTO `un_reg_friend_invs` VALUES (1,NULL,8,3),(5,15,NULL,10),(6,NULL,16,2),(9,NULL,19,3),(10,NULL,20,17),(12,NULL,22,20),(14,NULL,24,20),(15,NULL,25,20),(16,NULL,26,2),(17,NULL,27,2),(18,NULL,28,20),(19,NULL,29,2),(21,NULL,31,3),(24,NULL,34,3),(27,NULL,37,26),(28,NULL,38,3),(29,NULL,39,26),(30,NULL,40,26),(31,NULL,41,3),(33,NULL,43,3),(34,NULL,44,26),(35,NULL,45,26),(36,NULL,46,26),(41,NULL,51,30),(42,NULL,52,30),(43,NULL,53,30),(44,NULL,54,26),(45,NULL,55,26),(46,NULL,56,26),(47,NULL,57,26),(48,NULL,58,26),(55,NULL,65,28),(57,NULL,67,28),(58,NULL,68,28),(59,NULL,69,3),(62,NULL,72,28),(64,NULL,74,28),(67,NULL,77,28),(68,NULL,78,28),(70,NULL,80,25),(72,NULL,82,25),(73,NULL,83,25),(74,NULL,84,25),(78,NULL,88,25),(79,NULL,89,25),(82,NULL,92,30),(86,NULL,96,3),(88,NULL,98,2);
/*!40000 ALTER TABLE `un_reg_friend_invs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `un_reg_team_invs`
--

DROP TABLE IF EXISTS `un_reg_team_invs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `un_reg_team_invs` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `invitation_id` int(11) default NULL,
  `team_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `un_reg_team_invs`
--

LOCK TABLES `un_reg_team_invs` WRITE;
/*!40000 ALTER TABLE `un_reg_team_invs` DISABLE KEYS */;
INSERT INTO `un_reg_team_invs` VALUES (6,15,NULL,2),(9,NULL,19,4),(10,NULL,22,3),(12,NULL,24,3),(13,NULL,25,3),(14,NULL,27,1),(15,NULL,29,1),(17,NULL,31,2),(20,NULL,34,2),(23,NULL,41,3),(25,NULL,43,3),(26,NULL,44,3),(27,NULL,45,3),(28,NULL,46,3),(30,NULL,51,6),(31,NULL,53,6),(33,NULL,69,4),(37,NULL,77,8),(38,NULL,78,8),(40,NULL,80,9),(42,NULL,82,9),(43,NULL,83,9),(44,NULL,84,9),(48,NULL,88,9),(49,NULL,89,9),(52,NULL,92,6),(56,NULL,96,4);
/*!40000 ALTER TABLE `un_reg_team_invs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_images`
--

DROP TABLE IF EXISTS `user_images`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_images` (
  `id` int(11) NOT NULL auto_increment,
  `filename` varchar(255) default NULL,
  `content_type` varchar(255) default NULL,
  `size` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `thumbnail` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_images`
--

LOCK TABLES `user_images` WRITE;
/*!40000 ALTER TABLE `user_images` DISABLE KEYS */;
INSERT INTO `user_images` VALUES (1,'00000001.jpg','image/pjpeg',16724,NULL,NULL,1),(2,'00000001_tiny.jpg','image/pjpeg',4421,1,'tiny',NULL),(3,'00000001_small.jpg','image/pjpeg',4421,1,'small',NULL),(4,'00000002.JPG','image/pjpeg',16428,NULL,NULL,2),(5,'00000002_tiny.JPG','image/pjpeg',2592,4,'tiny',NULL),(6,'00000002_small.JPG','image/pjpeg',2592,4,'small',NULL),(7,'00000004.gif','image/gif',2811,NULL,NULL,4),(8,'00000004_tiny.gif','image/gif',2811,7,'tiny',NULL),(9,'00000004_small.gif','image/gif',2811,7,'small',NULL),(10,'00000003.JPG','image/pjpeg',338816,NULL,NULL,3),(11,'00000003_tiny.JPG','image/pjpeg',2033,10,'tiny',NULL),(12,'00000003_small.JPG','image/pjpeg',2033,10,'small',NULL),(13,'00000005.jpg','image/pjpeg',1558,NULL,NULL,5),(14,'00000005_tiny.jpg','image/pjpeg',1855,13,'tiny',NULL),(15,'00000005_small.jpg','image/pjpeg',1855,13,'small',NULL),(16,'00000011.jpg','image/pjpeg',6831,NULL,NULL,11),(17,'00000011_tiny.jpg','image/pjpeg',1525,16,'tiny',NULL),(18,'00000011_small.jpg','image/pjpeg',2960,16,'small',NULL),(19,'00000007.jpg','image/pjpeg',102160,NULL,NULL,7),(20,'00000007_tiny.jpg','image/pjpeg',37742,19,'tiny',NULL),(21,'00000007_small.jpg','image/pjpeg',37742,19,'small',NULL),(22,'00000010.jpg','image/jpg',66593,NULL,NULL,10),(23,'00000010_tiny.jpg','image/jpg',26523,22,'tiny',NULL),(24,'00000010_small.jpg','image/jpg',26523,22,'small',NULL),(25,'00000006.JPG','image/jpeg',31320,NULL,NULL,6),(26,'00000006_tiny.JPG','image/jpeg',1941,25,'tiny',NULL),(27,'00000006_small.JPG','image/jpeg',1941,25,'small',NULL),(28,'00000017.jpg','image/pjpeg',297834,NULL,NULL,17),(29,'00000017_tiny.jpg','image/pjpeg',16188,28,'tiny',NULL),(30,'00000017_small.jpg','image/pjpeg',16188,28,'small',NULL),(31,'00000022.jpg','image/jpeg',2436,NULL,NULL,22),(32,'00000022_tiny.jpg','image/jpeg',3279,31,'tiny',NULL),(33,'00000022_small.jpg','image/jpeg',3279,31,'small',NULL),(34,'00000023.jpg','image/jpeg',40832,NULL,NULL,23),(35,'00000023_tiny.jpg','image/jpeg',2156,34,'tiny',NULL),(36,'00000023_small.jpg','image/jpeg',2156,34,'small',NULL),(37,'00000030.jpg','image/pjpeg',14992,NULL,NULL,30),(38,'00000030_tiny.jpg','image/pjpeg',1606,37,'tiny',NULL),(39,'00000030_small.jpg','image/pjpeg',1606,37,'small',NULL),(40,'00000028.jpg','image/jpeg',8404,NULL,NULL,28),(41,'00000028_tiny.jpg','image/jpeg',3064,40,'tiny',NULL),(42,'00000028_small.jpg','image/jpeg',3064,40,'small',NULL),(43,'00000009.jpg','image/jpg',4445,NULL,NULL,9),(44,'00000009_tiny.jpg','image/jpg',2173,43,'tiny',NULL),(45,'00000009_small.jpg','image/jpg',2173,43,'small',NULL),(46,'00000033.jpg','image/pjpeg',2273,NULL,NULL,33),(47,'00000033_tiny.jpg','image/pjpeg',1569,46,'tiny',NULL),(48,'00000033_small.jpg','image/pjpeg',1569,46,'small',NULL),(49,'00000034.jpg','image/jpeg',28541,NULL,NULL,34),(50,'00000034_tiny.jpg','image/jpeg',18648,49,'tiny',NULL),(51,'00000034_small.jpg','image/jpeg',18648,49,'small',NULL),(52,'00000016.JPG','image/jpeg',45696,NULL,NULL,16),(53,'00000016_tiny.JPG','image/jpeg',2270,52,'tiny',NULL),(54,'00000016_small.JPG','image/jpeg',2270,52,'small',NULL),(55,'00000038.jpg','image/pjpeg',50286,NULL,NULL,38),(56,'00000038_tiny.jpg','image/pjpeg',1645,55,'tiny',NULL),(57,'00000038_small.jpg','image/pjpeg',1645,55,'small',NULL),(58,'00000040.jpg','image/jpeg',37462,NULL,NULL,40),(59,'00000040_tiny.jpg','image/jpeg',1723,58,'tiny',NULL),(60,'00000040_small.jpg','image/jpeg',1723,58,'small',NULL),(61,'00000042.jpg','image/jpeg',30868,NULL,NULL,42),(62,'00000042_tiny.jpg','image/jpeg',18273,61,'tiny',NULL),(63,'00000042_small.jpg','image/jpeg',18273,61,'small',NULL),(64,'00000044.jpg','image/pjpeg',5963,NULL,NULL,44),(65,'00000044_tiny.jpg','image/pjpeg',3879,64,'tiny',NULL),(66,'00000044_small.jpg','image/pjpeg',3879,64,'small',NULL),(67,'00000046.jpg','image/pjpeg',5085,NULL,NULL,46),(68,'00000046_tiny.jpg','image/pjpeg',1869,67,'tiny',NULL),(69,'00000046_small.jpg','image/pjpeg',1869,67,'small',NULL),(70,'00000047.JPG','image/pjpeg',3083,NULL,NULL,47),(71,'00000047_tiny.JPG','image/pjpeg',1838,70,'tiny',NULL),(72,'00000047_small.JPG','image/pjpeg',1838,70,'small',NULL),(73,'00000025.jpg','image/jpeg',40159,NULL,NULL,25),(74,'00000025_tiny.jpg','image/jpeg',3315,73,'tiny',NULL),(75,'00000025_small.jpg','image/jpeg',3315,73,'small',NULL),(76,'00000027.jpg','image/pjpeg',16772,NULL,NULL,27),(77,'00000027_tiny.jpg','image/pjpeg',1992,76,'tiny',NULL),(78,'00000027_small.jpg','image/pjpeg',1992,76,'small',NULL),(79,'00000053.JPG','image/pjpeg',8745,NULL,NULL,53),(80,'00000053_tiny.JPG','image/pjpeg',1703,79,'tiny',NULL),(81,'00000053_small.JPG','image/pjpeg',1703,79,'small',NULL);
/*!40000 ALTER TABLE `user_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_teams`
--

DROP TABLE IF EXISTS `user_teams`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_teams` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `team_id` int(11) default NULL,
  `is_admin` tinyint(1) default '0',
  `is_player` tinyint(1) default '0',
  `position` int(2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_teams`
--

LOCK TABLES `user_teams` WRITE;
/*!40000 ALTER TABLE `user_teams` DISABLE KEYS */;
INSERT INTO `user_teams` VALUES (1,1,1,1,1,18),(2,2,1,1,1,14),(3,3,1,1,1,8),(4,4,1,0,0,NULL),(5,3,2,1,1,0),(6,1,2,0,1,23),(7,2,2,1,1,15),(8,7,1,0,0,NULL),(9,10,2,1,1,17),(10,17,1,0,1,12),(11,3,3,1,1,14),(12,3,4,1,1,NULL),(13,16,1,0,1,0),(15,20,3,1,0,NULL),(16,21,2,0,1,19),(17,22,1,0,0,NULL),(18,3,5,1,1,0),(19,24,5,1,1,23),(20,26,3,1,1,18),(21,27,3,0,0,NULL),(22,25,2,0,1,11),(23,2,5,1,1,10),(24,30,6,1,0,NULL),(25,1,5,0,1,20),(26,28,7,1,0,NULL),(27,28,8,1,0,NULL),(28,33,8,0,0,NULL),(29,34,8,0,0,NULL),(30,36,4,0,0,NULL),(31,2,4,0,1,NULL),(32,1,4,0,1,NULL),(33,36,1,0,0,NULL),(34,25,9,1,1,NULL),(35,38,6,0,0,NULL),(36,10,5,0,1,13),(37,38,2,0,0,NULL),(38,40,8,0,0,NULL),(39,41,9,0,0,NULL),(40,42,3,0,0,NULL),(41,43,9,1,0,NULL),(42,44,7,0,0,NULL),(43,45,9,0,0,NULL),(44,46,8,0,0,NULL),(45,47,9,0,0,NULL),(46,48,9,0,1,NULL),(47,34,10,1,1,NULL),(48,49,9,1,0,NULL),(49,48,3,0,1,NULL),(50,51,6,0,0,NULL),(51,52,4,0,0,NULL),(52,53,9,0,0,NULL),(53,48,8,0,1,NULL),(54,50,8,0,1,NULL),(55,54,9,0,0,NULL);
/*!40000 ALTER TABLE `user_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `nickname` varchar(15) default NULL,
  `birthday` date default NULL,
  `birthday_display_type` int(1) default '0',
  `city` int(3) default '0',
  `summary` text,
  `favorite_star` varchar(200) default '',
  `favorite_team` varchar(200) default '',
  `blog` varchar(255) default '',
  `gender` int(1) default '0',
  `image_path` varchar(255) default NULL,
  `is_playable` tinyint(1) default '0',
  `height` float default NULL,
  `weight` float default NULL,
  `fitfoot` varchar(1) default NULL,
  `premier_position` int(2) default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `password_reset_code` varchar(40) default NULL,
  `unread_messages_count` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'sakinijino@gmail.com','f7b25e7d2cb2145ff9ecef937a25bf4008787c8b','bc0611f50a2010a2717109bd2e5d1cce22b28a41','2008-04-23 19:47:31','2008-04-30 14:05:15',NULL,NULL,'霏昀','1984-03-10',1,9,'','罗西基','国际米兰','sakinijino.blogbus.com',1,'/images/users/00/00/00/01.jpg',1,172,62,'R',2,'82f8d1e902b2c7ed34ad1556a40b20a5d1fae8ce','2008-04-23 19:48:02',NULL,0),(2,'jiakuan.ma@gmail.com','94359c8c10e03f4338b114c1e975fd5b0926399e','eed5252546f6e49354815b3d65ac2231b02536f1','2008-04-23 19:51:20','2008-05-03 00:05:26','a0c95570ad90dfc7f10aac16cdb97e8a4b12a06e','2008-05-16 16:05:26','Mike','1984-10-18',0,9,'','梅西','巴萨 AC米兰 阿森纳','',1,'/images/users/00/00/00/02.JPG',1,178,75,'R',8,NULL,'2008-04-23 11:51:39',NULL,0),(3,'stafipp@gmail.com','748c4463341a9d62f61603f57f8599034be59076','2acd3f1e073fa3fffe1df41be78d3707266071c1','2008-04-23 19:56:58','2008-05-01 11:29:08','bc307754077efddbdb943c36c517169bd0666490','2008-05-15 03:29:08','staf','1983-10-01',1,9,'83年的老青年\r\n喜欢足球，喜欢摄影，喜欢电影，喜欢流浪','罗纳尔多','皇家马德里','xiaonei.com/getuser.do?id=90621790',1,'/images/users/00/00/00/03.JPG',1,175,65,'R',5,NULL,'2008-04-23 11:57:46',NULL,0),(4,'hs.hanshuang@gmail.com','730007aeb68e7dcb588f1bdadd0b9d8c79170102','1345c54c37888531c623b35506fa770172b19975','2008-04-23 19:58:07','2008-04-24 17:57:42',NULL,NULL,'兔子国王','1980-01-01',0,0,'','','','',0,'/images/users/00/00/00/04.gif',0,NULL,NULL,NULL,NULL,NULL,'2008-04-23 11:58:29',NULL,0),(5,'eddiesparrow@126.com','ddeb946115d7dd89b21b92d0c6370b31de4fb2ae','57bb355b3e9644238d824c0adc4eb0ee2f5e58b9','2008-04-23 20:43:41','2008-04-29 22:47:16','1f1b1247f99ac19b281bdbd4eb722f8d7d3457e7','2008-05-13 14:01:16','eddiesparrow','1988-12-03',2,6,'','卡卡、小罗','皇家马德里','eddienever.blog.sohu.com',2,'/images/users/00/00/00/05.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-23 12:44:34',NULL,1),(6,'beckyzhao@gmail.com','9f5b18c3015534cd78560bc1882767fa3debb3c1','679f4219796db0f26ecfc9e2eb6e65ccf90f049b','2008-04-24 12:31:12','2008-04-24 17:57:42',NULL,NULL,'七七','1984-07-25',0,2,'','','','',2,'/images/users/00/00/00/06.JPG',0,NULL,NULL,NULL,NULL,'fa56f5317e61a6096b5daa41843f947345203314','2008-04-24 12:32:40',NULL,0),(7,'he.cj@pg.com','fd2da7548f2a48344e3118f0e1bbc7544073b289','ff4c52b01b9b824c3105f84012df304d7eea8711','2008-04-24 09:36:17','2008-04-24 17:57:42',NULL,NULL,'Phoebe','1985-03-02',0,320,'','Mike','','',2,'/images/users/00/00/00/07.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-24 01:37:51',NULL,0),(8,'zyypgf@163.com','c913def35039cc3716a444ca6020f6b3460ef22b','70354b987a67bbb19da81da6fa7eef8faf3773db','2008-04-24 09:46:58','2008-04-27 17:08:08',NULL,NULL,'zyypgf','1983-08-18',0,9,'','','','',1,NULL,1,NULL,NULL,'R',0,NULL,'2008-04-24 01:47:28',NULL,1),(9,'dd@geoagent.pku.edu.cn','4c7424fb0d257da1b3f56ba2c61f5d12377918cb','7df26b57207531b76455083455c7147e3ef21203','2008-04-24 12:04:34','2008-04-27 18:32:05',NULL,NULL,'dd','1984-01-22',0,6,'','','','',1,'/images/users/00/00/00/09.jpg',1,181,60,'R',0,NULL,'2008-04-24 04:04:43',NULL,0),(10,'lobatt@163.com','5e06d0ed29683075199a22117571c80114216777','cacaaa83d624599e72439f13512e9bcd0993d003','2008-04-24 12:07:20','2008-05-02 02:14:40','fdee26075b642b8f75c2d943facce00d3d089ac1','2008-05-15 18:14:40','lobatt','1983-10-01',2,9,'','','巴塞罗那','edu.perlfect.org',1,'/images/users/00/00/00/10.jpg',1,180,90,'B',9,NULL,'2008-04-24 04:10:24',NULL,0),(11,'278028716@qq.com','2a3f5952654427aa7cbfdb5f31f7f8463051f461','56da3fcbf40e977c1969cccd3caddc1878398589','2008-04-23 22:46:49','2008-04-24 17:57:42','8be85cea596ee8d2faa15086c576c055ec552db9','2008-05-07 15:06:53','Hinata','1988-01-27',0,357,'','小罗,埃托奥','巴萨','',1,'/images/users/00/00/00/11.jpg',1,167,50,'R',12,NULL,'2008-04-23 14:47:09',NULL,0),(14,'azukinana@gmail.com','0f0c98da1e8d04d1ca5f703b09bc6dcc11ca33fa','93b422212be244aab2fda90f1cf42579b86cb972','2008-04-24 12:43:23','2008-04-24 17:57:42','5ade7a00dd5ce5526ad5126a3fd29bf8c96fcfde','2008-05-08 08:35:47','千寻','1980-01-01',0,1,'什么叫挂靴','','','',2,NULL,0,NULL,NULL,NULL,NULL,'b7b1b41815f34fcbb0cd4bde411c9682e9d2fc14','2008-04-24 12:50:01',NULL,0),(15,'dlyyang@gmail.com','15a0bd4a7185e9aa2f21df62870681b195b0c033','4d712dbb750593b8e834fcd08d56196300e7fc6f','2008-04-24 14:31:32','2008-04-24 17:57:42',NULL,NULL,'dlyyang',NULL,0,0,NULL,'','','',0,NULL,0,NULL,NULL,NULL,NULL,'f173afda5464750aa1bdfec1f7cc78df4eba1ae1',NULL,NULL,0),(16,'shilei07@sei.pku.edu.cn','7c85a1241c51b15fbcb247bc38b78a5d40f1b29c','5d6429d5649c4a26fecbbac1149c597f8620c5f6','2008-04-24 18:13:41','2008-04-27 21:41:36','f678f4d6840bc52f70f064ada6e18e659fac0e35','2008-05-11 13:40:10','LoveofCSDT','1984-08-17',0,9,'这个人不会踢球……','','','',1,'/images/users/00/00/00/16.JPG',1,183,78,'R',2,NULL,'2008-04-24 16:32:56',NULL,1),(17,'150413450@qq.com','e9610b7fa0dfaf21667e7df1045cb34fc1676b88','69f40d7f22e227d5d69b0653fcf01a06abc10a31','2008-04-24 19:50:33','2008-04-25 11:50:18','24179bfa8dfcc7bdf22439cb09b9eb1550290513','2008-05-09 03:50:18','牦牛','1988-12-28',2,1,'没事来耍耍...','卡卡','AC米兰','',1,'/images/users/00/00/00/17.jpg',1,185,185,'R',5,NULL,'2008-04-24 11:50:45',NULL,0),(18,'linxh.china@gmail.com','203bfa234a031c51fec2e2f68c5b74c75bf2cc1b','6f903a582bbe8ce736b8f3ab2cfa4d3ea4eff3eb','2008-04-25 00:39:17','2008-04-25 00:39:27',NULL,NULL,'linxh.china',NULL,0,0,NULL,'','','',0,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-24 16:39:27',NULL,0),(19,'149902113@qq.com','ede6642d6f6b395c3d411f61bce7486dcb94531b','b253675293b971bf65b0c0af655f584222313b1e','2008-04-25 11:55:17','2008-04-25 11:56:13',NULL,NULL,'149902113','1988-05-12',0,6,'','','','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-25 03:55:43',NULL,0),(20,'superc_7@163.com','a8f8584ba019ee5564236f8e1f20ce7a7b44d842','55bc719721f8fa1174a7a62c4bffc91dec39ce99','2008-04-25 12:02:51','2008-04-25 17:35:46','80de6343f0808643f10e08ddb5e4afd6a1d2b4bc','2008-05-09 09:35:46','Bernabeu','1983-12-15',1,9,'','Raul','Real Madrid','www.xiaonei.com/wangyiding',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-25 04:03:17',NULL,0),(21,'jk_allthebest@163.com','8b66f882484c30b7d0a45a65f9f9b74db41f9dcc','4cbd76888ab3b0acb2761b72b3c1c30e3ae0027c','2008-04-25 16:14:07','2008-04-25 16:16:38',NULL,NULL,'kang','1985-09-18',1,230,'ms','','','',1,NULL,1,176,130,'R',8,NULL,'2008-04-25 08:14:39',NULL,0),(22,'feng.zhang.kth@gmail.com','4aa5ec5dbe3ca79d353dc237c4f793a25e280daa','55e1dfe1c6bd895ba362bd5809da7399d57eae73','2008-04-25 23:20:08','2008-04-25 23:29:52',NULL,NULL,'Feng','1984-05-12',0,650,'','巴蒂斯图塔','','',1,'/images/users/00/00/00/22.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-25 15:20:21',NULL,0),(23,'xingtianxt@sina.com','c6c759de63931abf404eb14ee8f4e447aad574ff','4ea7384879d285f1e905ef92d2733ba8f830b56f','2008-04-26 09:30:35','2008-04-26 09:40:54',NULL,NULL,'刑天','1984-08-21',3,1,'','杰拉德','巴萨、利物浦','',1,'/images/users/00/00/00/23.jpg',1,NULL,NULL,'R',0,NULL,'2008-04-26 01:31:14',NULL,0),(24,'fl@pku.edu.cn','758c385b08d5d1ca0758c08ade17e8ebb44b70b6','7eec6eaa88a563b329dac8afff57c04c992f8688','2008-04-26 19:35:27','2008-04-27 17:18:08',NULL,NULL,'fl','1986-05-24',0,9,'','','Chelsea','',1,NULL,1,187,73,'R',0,NULL,'2008-04-26 11:35:37',NULL,1),(25,'lil@cis.pku.edu.cn','bdcf856b0ba36a6c496f34e98c17e57f1f10fb61','d2cfadbcfe40e39173cc30deee152796aa5e8aa7','2008-04-26 20:49:00','2008-05-01 15:13:58',NULL,NULL,'fancyerii','1983-02-06',3,9,'','','','',1,'/images/users/00/00/00/25.jpg',1,NULL,NULL,'R',11,NULL,'2008-04-26 15:39:12',NULL,0),(26,'lunacory@gmail.com','bf6a54d04cfc8b38ce61bc3f5869f32fab116ac7','d8c0f2d7f2ec315dc398347ec38281e444894e63','2008-04-26 21:33:45','2008-04-27 16:39:01','23a333b9589ac9868dd77cdbb0524bca67747890','2008-05-11 08:39:01','xp','1986-04-18',2,9,'','Raul','Real Madrid','',1,NULL,1,174,61,'B',9,NULL,'2008-04-26 13:34:16',NULL,0),(27,'wangwei13@gsm.pku.edu.cn','704ff1dd0014aecf24930abb03b08d426dd5c84d','21cd2738edd9de83a1cd659508ba9e752029d2fc','2008-04-26 23:03:56','2008-04-29 17:12:00','1b9cf994846c2e5b66d8bf6ca6cf56f0914476c1','2008-05-10 15:18:51','Candy','1987-12-07',2,9,'','','','hi.baidu.com/素阁',2,'/images/users/00/00/00/27.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-26 15:04:32',NULL,0),(28,'LottaDragon@gmail.com','88b6a140e29f2fd164553cd6271dc7d55f175a16','cdd4e4701b61839866a3bf1d2e5171480186e260','2008-04-27 03:07:39','2008-04-28 17:36:18','1b6cc2a3378e4e89f3060dcf7e26d264f0d90cc6','2008-05-12 09:36:18','LottaDragon','1984-09-06',0,1,'','C.Ronaldo','ManUtd','',1,'/images/users/00/00/00/28.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-26 19:08:04',NULL,0),(29,'rbcfox@gmail.com','097b58d181c0982855d609982310980c742e2392','a5c04379f06390d9805663bacce3a5fa7b68de96','2008-04-27 09:38:01','2008-04-27 09:41:07',NULL,NULL,'Ella','1986-01-02',2,9,'','','','superkakauniquefox.spaces.live.com',1,NULL,1,170,73,'R',11,NULL,'2008-04-27 01:38:36',NULL,0),(30,'hokey3210@gmail.com','d7c355ce5fc203979712cc7e98b956364ab47e8d','cc8461c70b0bc97fd3b256e8daccc842c6c68918','2008-04-27 14:47:55','2008-04-30 19:30:33','9edd8a1727c163bdfb89fadfacf7a7d0c9cfcb6c','2008-05-14 11:30:33','hokey','1985-10-24',2,9,'一介鬼才，满腹鬼胎\r\n鬼头鬼脑，鬼主意多得数不上来..','卡卡','阿根廷han英格兰','cutehokey.spaces.live.com',2,'/images/users/00/00/00/30.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-27 06:48:19',NULL,0),(31,'yexin.w@gmail.com','ec78a28a4dee9dc4be359507e6cbe13ffbe7328c','db537fba35881a0fdada6691ab273759752e6c82','2008-04-27 20:10:46','2008-04-28 17:08:01',NULL,NULL,'yexin.w','1980-01-01',0,0,'','','','',0,NULL,1,185,80,'R',10,NULL,'2008-04-27 12:11:47',NULL,1),(32,'zzkktt@163.com','403340bc3e181bcf0654d9c36192d4c867e69ad3','8db397fb7727db2a460692396ccbb69e229169cd','2008-04-27 20:22:32','2008-04-27 20:22:50',NULL,NULL,'zzkktt','1980-01-01',0,0,'','','','',0,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-27 12:22:46',NULL,0),(33,'cristea7@163.com','75eea6012b1648ce53c3655ef446a531752e0005','31e8cb036cae46fae9513187da757dcb4f62df29','2008-04-27 20:36:28','2008-04-27 20:43:36','faaa65af1f6b3bea7d793713752ad60168be1b01','2008-05-11 12:42:14','cristea7','1987-02-23',1,1,'ManUtd for ever','','ManUtd!','',1,'/images/users/00/00/00/33.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-27 12:36:50',NULL,0),(34,'yiin17@gmail.com','89ebbbe719c4641202f881ff9b7a5b38374cca5b','a522159952de970337e732507ae68bde0c8c487c','2008-04-27 20:48:09','2008-05-02 22:38:20','ee32e16088ead6d3327b91e719344fd855bd1876','2008-05-16 14:38:20','yiin','1988-03-19',3,1,'我说你是人间四月天','GerrardTevezRooney','红军红魔阿根廷','yiin17.blog.sohu.com',1,'/images/users/00/00/00/34.jpg',1,NULL,NULL,'R',10,NULL,'2008-04-27 12:49:32',NULL,0),(35,'wildust1129@gmail.com','89049d298e691c36a4933e6806de921d146f9853','dc507f1cf13ad79b413ac17d1150f7e089705acb','2008-04-27 21:33:59','2008-04-27 21:35:03',NULL,NULL,'wildust1129','1985-11-29',0,0,'','','','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-27 13:34:30',NULL,0),(36,'chengzhanheng@gmail.com','d23d9fa68b32545fd230b246c6a903f7f9b2a747','1e8de76e465524275c6b7aa92aa50591e6b8d5ac','2008-04-27 22:08:17','2008-05-01 23:51:23','0cc211501d72259f4c44f245b3a3e5c2744e6fbd','2008-05-15 15:51:23','chengzhanheng','1980-01-01',0,0,'','','','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-27 14:08:40',NULL,0),(37,'scorpiusyuan@vip.qq.com','2a76be9e57486a25c18abb69748a44c8ab17f9fc','ae14a45e8713e9378efdb33be785dbb1cd1aaa48','2008-04-27 22:30:18','2008-04-27 22:32:34',NULL,NULL,'scorpiusyuan','1982-10-30',0,9,'','博格坎普','荷兰','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-27 14:30:37',NULL,0),(38,'dofanwang@gmail.com','93d076ea472d62a59cf9b002551770a89d643b3a','1c40b409e007ff9bea22222b3c84b854b40c6d44','2008-04-28 12:30:09','2008-04-28 12:49:39',NULL,NULL,'豆饭','1985-01-01',0,1,'','兰帕德','切尔西&英格兰','',1,'/images/users/00/00/00/38.jpg',0,NULL,NULL,NULL,NULL,NULL,'2008-04-28 04:31:38',NULL,1),(39,'schumacher8624@gmail.com','c83432b8f12634d7d1b03310d2d1991732ee778d','63400a1913191e39f72ad2c1e2322d0e766f052b','2008-04-28 12:38:10','2008-04-28 12:43:07',NULL,NULL,'xuchunbin','1988-02-04',1,9,'','里克尔梅','曼联','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-28 04:38:59',NULL,0),(40,'cristiano7230@sina.com','aed53f303ebf39b3423e54dce2dc7d4deefdbb9c','20ad4270d0a5be5217071e49188142d7e25fe639','2008-04-28 12:58:40','2008-04-28 13:00:50',NULL,NULL,'cristiano7230','1991-03-25',1,1,'','坎通纳 吉格斯 c罗','曼联','',1,'/images/users/00/00/00/40.jpg',1,173,58,'R',12,NULL,'2008-04-28 04:59:09',NULL,0),(41,'jianxing0302@163.com','36579499e6eb52296ce508e4dbd7ca9332c95587','70cad70e4ceaeae9acc50e351cb508aaee9ff162','2008-04-28 13:00:35','2008-04-28 13:02:47',NULL,NULL,'jianxing','1988-03-02',2,1,'','','Juventus','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-28 05:01:47',NULL,0),(42,'hechenzhang@gmail.com','0fea82d5f55a517750243b1d28739b4a6aebe4ae','3e10e8ecee71c5e84b343bbccaee948359dca078','2008-04-28 14:59:16','2008-04-28 15:09:07',NULL,NULL,'JustSoSo','1988-02-18',1,1,'','Figo','RealMadrid','',1,'/images/users/00/00/00/42.jpg',1,182,70,'L',5,NULL,'2008-04-28 07:00:34',NULL,0),(43,'tonnyliuzhe@gmail.com','cb2392efa38f7f21d6f64418d14e0a3d5dad7a03','456404b89147e34fd88bbe02636a32743ea767a9','2008-04-28 16:21:08','2008-04-28 16:22:56',NULL,NULL,'flyingknife','1980-06-06',0,6,'','','','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-28 08:22:04',NULL,0),(44,'ud_grubby@163.com','c0f4e01532d63821c5bbef4d78225609f97cd71e','232544b79db7aea7198250f806c11984ef481948','2008-04-28 16:57:17','2008-04-28 17:12:17',NULL,NULL,'ud_grubby','1985-05-11',0,9,'','罗纳尔迪尼奥','FCB','',1,'/images/users/00/00/00/44.jpg',1,173,76,'R',6,NULL,'2008-04-28 08:57:43',NULL,0),(45,'jainsc@126.com','0b33cd533bf5524170343ced911876be2d299e97','1dc5c9e5f0556228595553b17cdff141ec0b485f','2008-04-28 19:20:54','2008-04-28 19:23:08',NULL,NULL,'jainsc','1988-03-02',1,9,'','皮队','juventus','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-28 11:22:36',NULL,0),(46,'henrycui@vip.sina.com','5b47aa497d0a5fb25ab47180ce5efcebb093d985','4033d1c49038884486e7e7de0bab7f0a2b09b1cc','2008-04-28 19:24:29','2008-04-28 19:36:01',NULL,NULL,'EricCantona','1974-08-08',3,9,'我是国王，还用得着介绍么？','我自己','曼联','',1,'/images/users/00/00/00/46.jpg',1,175,70,'R',4,NULL,'2008-04-28 11:25:01',NULL,0),(47,'wolfie_liu@126.com','d9df62fc3d9bddb5ff03b6973ac375344e022771','235dc0ea3a1e5cb683e76aca5cfadc34448d5d9d','2008-04-28 19:37:45','2008-04-29 19:41:08','fecfc9fdcde8bd1f57e615b1ca9db124fb7d3efc','2008-05-13 11:41:08','wolfie','1986-05-15',0,1,'身逍遥 心自在 万事茫茫负肚外...','马斯切拉诺','尤文','',1,'/images/users/00/00/00/47.JPG',1,NULL,NULL,'R',5,NULL,'2008-04-28 11:39:56',NULL,0),(48,'xihuijinming@sina.com','6de0c63595190d8244b9a051e75d39a9dc46eeca','38a35ad8bfc6594fff3a593371f99f5042b243c4','2008-04-28 19:49:46','2008-04-28 19:51:50',NULL,NULL,'xihuijinming','1991-03-25',1,9,'','小小罗','曼联','blog.sina.com.cn/u/1267421681',1,NULL,1,178,78,'R',12,NULL,'2008-04-28 11:50:03',NULL,0),(49,'icyecho@gmail.com','4f6027d23f2c1e46c2ddcae9de4504dda7a8619f','dc0ffee789e3054d87b896b5b642ef3cbfd2ca46','2008-04-28 23:03:26','2008-04-28 23:22:23',NULL,NULL,'icyecho','1986-10-13',0,1,'','','','',2,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-28 15:03:46',NULL,0),(50,'luyb.pku@gmail.com','4bdb1ba46a598af8bf8345bb4c2476d4e444e95a','c3142d9da904648b31521cb45ced7a505fe6e5fa','2008-04-28 23:40:18','2008-04-28 23:44:13',NULL,NULL,'rikpires','1985-12-25',0,1,'Glory ManUtd!!!','Pires','曼联','rikpires.spaces.live.com',1,NULL,1,178,60,'R',2,NULL,'2008-04-28 15:40:34',NULL,0),(51,'xuanshanming@126.com','4d60bf545c5e28045d19d47c938149878ba49f12','ba2111aa0a34223ef05c428769ece945f1e2a171','2008-04-29 14:52:51','2008-04-29 14:53:13',NULL,NULL,'xuanshanming',NULL,0,0,NULL,'','','',0,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-29 06:53:13',NULL,0),(52,'liuxingyang668@163.com','b7a8241438d079133f5c8bb197da8891e253568a','9d48dcf2aa9269eb8906126c3018d4847234c82f','2008-04-29 18:01:57','2008-04-29 18:04:11',NULL,NULL,'liuxingyang668','1987-01-08',0,1,'','vanni c罗','曼联','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-29 10:03:32',NULL,0),(53,'LAS.xs@126.com','0d56ddfdf4821dca679f2a4b3658a812e153416f','b376f53f2ed66997d1eba0294e2fc0ea219779c0','2008-04-29 23:25:59','2008-04-29 23:32:17',NULL,NULL,'yipiemingren','1984-07-24',0,1,'','','','',1,'/images/users/00/00/00/53.JPG',1,178,60,'R',2,NULL,'2008-04-29 15:27:21',NULL,0),(54,'doomking1234@163.com','6b386eb424b64c9e6d8a94ceb23708e9056d890f','74ae5df64d4388355d60e6f0717de7f82817abdd','2008-04-30 07:14:06','2008-04-30 07:17:32',NULL,NULL,'dkorange','1988-11-14',1,1,'','','','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-04-29 23:15:56',NULL,0),(55,'puma318puma@sina.com.cn','e11bbfbc9af146e2cbf5d3ee5543bde29f8ace25','9a7c9d3723bb6608ecdc978217ce6b49e1907c28','2008-05-01 17:03:53','2008-05-01 17:06:59',NULL,NULL,'dogdogdog','1983-03-19',0,1,'','','','',1,NULL,0,NULL,NULL,NULL,NULL,NULL,'2008-05-01 09:06:15',NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2008-05-02 20:01:01
