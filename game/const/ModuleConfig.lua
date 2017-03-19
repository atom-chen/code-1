GameStates = {}
GameStates.Login = "Login"
GameStates.Scene = "Scene"
GameStates.Battle = "Battle"
GameStates.BattleSelect = "BattleSelect"
GameStates.UpdateState = "UpdateState"
GameStates.Test = "Test"

GameProxys = {}
GameProxys.Battle = "Battle"
GameProxys.Role = "Role"
GameProxys.Chat = "Chat"
GameProxys.Dungeon = "Dungeon"
GameProxys.Rank = "Rank"
GameProxys.Lottery = "Lottery"
GameProxys.System = "System"
GameProxys.Soldier = "Soldier"
GameProxys.Item = "Item"
GameProxys.Building = "Building"
GameProxys.Equip = "Equip"
GameProxys.Parts = "Parts"
GameProxys.Friend = "Friend"  --好友相关
GameProxys.Task = "Task"  --任务
GameProxys.Skill = "Skill"  --技能
GameProxys.Setting = "Setting"  --设置
--GameProxys.Helper = "Helper"  --小助手
GameProxys.OpenServer = "OpenServer"  --开服礼包
GameProxys.Legion = "Legion"	--军团
GameProxys.Share = "Share" --分享
GameProxys.Mail = "Mail" --邮件
GameProxys.Activity = "Activity" --活动
GameProxys.Consigliere = "Consigliere" 	--军师府
GameProxys.DungeonX = "DungeonX" 		--军团副本
GameProxys.Technology = "Technology" --太学院
GameProxys.Vip = "Vip"
GameProxys.Talent = "Talent"
GameProxys.ItemBuff = "ItemBuff"
GameProxys.Arena = "Arena"
GameProxys.RedPoint = "RedPoint" -- 小红点
GameProxys.LimitExp = "LimitExp" -- 西域远征
GameProxys.VIPBox = "VIPBox" -- vip宝箱
GameProxys.VipRebate = "VipRebate" -- vip宝箱
GameProxys.EmperorAward = "EmperorAward" -- 皇帝的封赏
GameProxys.LegionHelp = "LegionHelp" --军团帮助
GameProxys.GeneralAndSoldier = "GeneralAndSoldier" --天将奇兵
GameProxys.World = "World" -- 世界
GameProxys.BattleActivity = "BattleActivity" --战斗活动代理
GameProxys.BanditDungeon = "BanditDungeon" --剿匪副本代理
GameProxys.TeamDetail = "TeamDetail" --部队详情代理
GameProxys.PopularSupport = "PopularSupport" --民心
GameProxys.Hero = "Hero" --英雄数据代理
GameProxys.HeroTreasure = "HeroTreasure" --宝具数据代理
GameProxys.ExamActivity = "ExamActivity" --科举数据代理
GameProxys.VipSupply = "VipSupply" --vip特供数据代理
GameProxys.LordCity = "LordCity" --城主战代理
GameProxys.Rebels = "Rebels"--叛军出没代理
GameProxys.Title  = "Title" -- 称号数据代理
GameProxys.RedBag = "RedBag"--红包数据代理
GameProxyMap = {}
GameProxyMap[GameProxys.Battle] = "game.proxy.BattleProxy"
GameProxyMap[GameProxys.Role] = "game.proxy.RoleProxy"
GameProxyMap[GameProxys.Chat] = "game.proxy.ChatProxy"
GameProxyMap[GameProxys.Dungeon] = "game.proxy.DungeonProxy"
GameProxyMap[GameProxys.Rank] = "game.proxy.RankProxy"
GameProxyMap[GameProxys.Lottery] = "game.proxy.LotteryProxy"
GameProxyMap[GameProxys.System] = "game.proxy.SystemProxy"
GameProxyMap[GameProxys.Soldier] = "game.proxy.SoldierProxy"
GameProxyMap[GameProxys.Item] = "game.proxy.ItemProxy"
GameProxyMap[GameProxys.Building] = "game.proxy.BuildingProxy"
GameProxyMap[GameProxys.Equip] = "game.proxy.EquipProxy"
GameProxyMap[GameProxys.Parts] = "game.proxy.PartsProxy"
GameProxyMap[GameProxys.Friend] = "game.proxy.FriendProxy"
GameProxyMap[GameProxys.Task] = "game.proxy.TaskProxy"
GameProxyMap[GameProxys.Skill] = "game.proxy.SkillProxy"
GameProxyMap[GameProxys.Setting] = "game.proxy.SettingProxy"
--GameProxyMap[GameProxys.Helper] = "game.proxy.HelperProxy"
--GameProxyMap[GameProxys.OpenServer] = "game.proxy.OpenServerProxy"
GameProxyMap[GameProxys.Legion] = "game.proxy.LegionProxy"
GameProxyMap[GameProxys.Share] = "game.proxy.ShareProxy"
GameProxyMap[GameProxys.Mail] = "game.proxy.MailProxy"
GameProxyMap[GameProxys.Activity] = "game.proxy.ActivityProxy"
GameProxyMap[GameProxys.Consigliere] = "game.proxy.ConsigliereProxy"
GameProxyMap[GameProxys.Technology] = "game.proxy.TechnologyProxy"
GameProxyMap[GameProxys.Vip] = "game.proxy.VipProxy"
GameProxyMap[GameProxys.Talent] = "game.proxy.TalentProxy"
GameProxyMap[GameProxys.ItemBuff] = "game.proxy.ItemBuffProxy"
GameProxyMap[GameProxys.Arena] = "game.proxy.ArenaProxy"
GameProxyMap[GameProxys.VipRebate] = "game.proxy.VipRebateProxy"
GameProxyMap[GameProxys.RedPoint] = "game.proxy.RedPointProxy"
GameProxyMap[GameProxys.DungeonX] = "game.proxy.DungeonXProxy"
GameProxyMap[GameProxys.VIPBox] = "game.proxy.VIPBoxProxy"
GameProxyMap[GameProxys.EmperorAward] = "game.proxy.EmperorAwardProxy"--皇帝的封赏
GameProxyMap[GameProxys.LegionHelp] = "game.proxy.LegionHelpProxy"--军团帮助
GameProxyMap[GameProxys.GeneralAndSoldier] = "game.proxy.GeneralAndSoldierProxy"--天降奇兵
GameProxyMap[GameProxys.LimitExp] = "game.proxy.LimitExpProxy"
GameProxyMap[GameProxys.World] = "game.proxy.WorldProxy"
GameProxyMap[GameProxys.BattleActivity] = "game.proxy.BattleActivityProxy"
GameProxyMap[GameProxys.Hero] = "game.proxy.HeroProxy"
GameProxyMap[GameProxys.HeroTreasure] = "game.proxy.HeroTreasureProxy"
GameProxyMap[GameProxys.ExamActivity] = "game.proxy.ExamActivityProxy"--全服活动科举（乡试殿试）
GameProxyMap[GameProxys.BanditDungeon] = "game.proxy.BanditDungeonProxy"
GameProxyMap[GameProxys.TeamDetail] = "game.proxy.TeamDetailProxy"
GameProxyMap[GameProxys.PopularSupport] = "game.proxy.PopularSupportProxy" --民心
GameProxyMap[GameProxys.VipSupply] = "game.proxy.VipSupplyProxy"  --Vip特供
GameProxyMap[GameProxys.LordCity] = "game.proxy.LordCityProxy" --城主战
GameProxyMap[GameProxys.Rebels] = "game.proxy.RebelsProxy" -- 叛军
GameProxyMap[GameProxys.Title] = "game.proxy.TitleProxy" -- 称号数据
GameProxyMap[GameProxys.RedBag] = "game.proxy.RedBagProxy" -- 抢红包

ModuleLevel = {} -- 模块类型，用来处理模块之间的显示关系 当前打开的模块，除了高于其等级的模块全部隐藏掉
ModuleLevel.SUPER_LEVEL = 1 --模块一直显示，不会被其他模块隐藏掉
ModuleLevel.NORMAL_LEVEL = 2 --打开该模块后，会把
ModuleLevel.LOW_LEVEL = 3
ModuleLevel.FREE_LEVEL = 999 --自由等级，不影响别的模块，也不会受别的模块影响

ModuleLayer = {}
ModuleLayer.UI_1_LAYER = "uiLayer"  --地图
ModuleLayer.UI_2_LAYER = "ui2Layer"  --toolbar
ModuleLayer.UI_3_LAYER = "ui3Layer"  --UI MODULE
ModuleLayer.UI_TOP_LAYER = "uiTopLayer"
ModuleLayer.UI_POP_LAYER = "popLayer" 

ModuleLayer.UI_Z_ORDER_0 = 0
ModuleLayer.UI_Z_ORDER_1 = 1
ModuleLayer.UI_Z_ORDER_2 = 2
ModuleLayer.UI_Z_ORDER_3 = 3
ModuleLayer.UI_Z_ORDER_4 = 4
ModuleLayer.UI_Z_ORDER_5 = 5
ModuleLayer.UI_Z_ORDER_6 = 6
ModuleLayer.UI_Z_ORDER_7 = 7
ModuleLayer.UI_Z_ORDER_8 = 8
ModuleLayer.UI_Z_ORDER_9 = 9
ModuleLayer.UI_Z_ORDER_10 = 10
ModuleLayer.UI_Z_ORDER_11 = 11
ModuleLayer.UI_Z_ORDER_12 = 12

ModuleLayer.UI_Z_ORDER_SEC_TOP = 1999
ModuleLayer.UI_Z_ORDER_TOP = 2000

PanelLayer = {}
PanelLayer.UI_Z_ORDER_0 = 0
PanelLayer.UI_Z_ORDER_1 = 1
PanelLayer.UI_Z_ORDER_2 = 2
PanelLayer.UI_Z_ORDER_3 = 3
PanelLayer.UI_Z_ORDER_4 = 4
PanelLayer.UI_Z_ORDER_5 = 5
PanelLayer.UI_Z_ORDER_6 = 6
PanelLayer.UI_Z_ORDER_7 = 7
PanelLayer.UI_Z_ORDER_8 = 8
PanelLayer.UI_Z_ORDER_9 = 9
PanelLayer.UI_Z_ORDER_10 = 10
PanelLayer.UI_Z_ORDER_11 = 11
PanelLayer.UI_Z_ORDER_12 = 12

ModuleShowType = {}  --模块展现动画
ModuleShowType.NONE = 0 --没有动画
ModuleShowType.LEFT = 1 --从左边入场
ModuleShowType.RIGHT = 2 --从右边入场
ModuleShowType.Animation = 3 --动画

ModulePanelBgType = {} --模块面板类型
ModulePanelBgType.BACK = 1 --黑色底纹
ModulePanelBgType.WHITE = 2 --白色底纹
ModulePanelBgType.BACKR = 3 --黑色底纹R
ModulePanelBgType.BACKR_WHITER = 4 --黑边白色底纹R
ModulePanelBgType.BACKR_WHITER2 = 5 --黑边白色底纹R 半封闭 活动
ModulePanelBgType.NONE = 6 --无背景
ModulePanelBgType.BATTLE = 7 --战斗背景，带定时器
ModulePanelBgType.LOTTERY = 8 --名匠背景
ModulePanelBgType.BLACKFULL = 9 --全屏纯黑背景
-- ModulePanelBgType.GREYFULL = 10 --全屏纯色背景
-- ModulePanelBgType.LEGIONCRE = 10 --创建军团全屏背景

ModuleName = {}
ModuleName.VipSupplyModule = "VipSupplyModule"     --vip特供模块
ModuleName.LoginModule = "LoginModule"              --登录模块
ModuleName.ToolbarModule = "ToolbarModule"          --工具条模块
ModuleName.BagModule = "BagModule"                  --背包模块
ModuleName.MailModule = "MailModule"                --邮件模块
ModuleName.MapModule = "MapModule"                  --地图模块
ModuleName.RoleInfoModule = "RoleInfoModule"        --个人信息模块
ModuleName.PersonInfoModule = "PersonInfoModule"    --个人信息模块2
ModuleName.InstanceModule = "InstanceModule"        --关卡信息
ModuleName.BattleModule = "BattleModule"            --战斗模块
ModuleName.DungeonModule = "DungeonModule"          --副本
ModuleName.TeamModule = "TeamModule"                --部队兵种
ModuleName.BarrackModule = "BarrackModule"          --兵营
ModuleName.MainSceneModule = "MainSceneModule"      --基地
ModuleName.ScienceMuseumModule = "ScienceMuseumModule"    --科技馆
ModuleName.CreateRoleModule = "CreateRoleModule"    --角色创建
ModuleName.LoaderModule = "LoaderModule"            --加载模块
ModuleName.EquipModule = "EquipModule"              --装备模块
ModuleName.ChatModule = "ChatModule"                --聊天模块
ModuleName.WarehouseModule = "WarehouseModule"      --仓库模块
ModuleName.PartsModule = "PartsModule"              --配件模块
ModuleName.PartsWarehouseModule = "PartsWarehouseModule"     --配件仓库模块
ModuleName.FriendModule = "FriendModule"            --好友模块
ModuleName.TaskModule = "TaskModule"            	--任务模块
ModuleName.PartsStrengthenModule = "PartsStrengthenModule" --配件强化模块
ModuleName.SettingModule = "SettingModule"  --设置模块
ModuleName.RechargeModule = "RechargeModule"  		--充值模块
ModuleName.ShopModule = "ShopModule"        --商店模块
ModuleName.LotteryEquipModule = "LotteryEquipModule"  --抽装备
ModuleName.FightingCapModule = "FightingCapModule" --战斗力
ModuleName.TreasureModule = "TreasureModule"  --探宝
ModuleName.GainModule = "GainModule"  --增益
ModuleName.RankModule = "RankModule"  				--排行榜
ModuleName.ArenaModule = "ArenaModule"   --竞技场
ModuleName.LittleHelperModule = "LittleHelperModule"   --小助手
ModuleName.ArenaShopModule = "ArenaShopModule" --竞技场积分
ModuleName.OpenServerGiftModule = "OpenServerGiftModule" --开服礼包
ModuleName.ArenaMailModule = "ArenaMailModule" --竞技场战报
ModuleName.LegionWelfareModule = "LegionWelfareModule" --军团福利院
ModuleName.LegionSceneModule = "LegionSceneModule" --军团场景
ModuleName.LimitExpModule = "LimitExpModule"--极限探险
ModuleName.LegionScienceTechModule = "LegionScienceTechModule"	--军团科技
ModuleName.LegionApplyModule = "LegionApplyModule"				--军团申请
ModuleName.LegionModule = "LegionModule"						--军团管理
ModuleName.TigerMachineModule = "TigerMachineModule"			--每日登陆抽奖
ModuleName.LegionHallModule = "LegionHallModule"				--军团大厅
ModuleName.LegionShopModule = "LegionShopModule"				--军团商店
ModuleName.LegionHelpModule = "LegionHelpModule"				--军团帮助
ModuleName.ActivityModule = "ActivityModule"                    --活动模块
ModuleName.EspecialGoodsUseModule = "EspecialGoodsUseModule"    --特殊道具使用
ModuleName.StationModule = "StationModule"                      --驻军
ModuleName.CheckTeamModule = "CheckTeamModule"                  --查看驻军
ModuleName.GuideModule = "GuideModule"                          --引导模块
ModuleName.LegionAdviceModule = "LegionAdviceModule"  			--军团情报站
ModuleName.PullBarActivityModule = "PullBarActivityModule"  	--拉霸活动
ModuleName.ActivityCenterModule = "ActivityCenterModule"  		--活动中心
ModuleName.ChargeShareModule = "ChargeShareModule"  			--有福同享
ModuleName.LegionCombatCenterModule = "LegionCombatCenterModule"--军团作战所
ModuleName.ConsigliereModule = "ConsigliereModule"  			--军师府
ModuleName.ConsigliereImgModule = "ConsigliereImgModule"  		--军师图鉴
ModuleName.DungeonXModule = "DungeonXModule"  					--军团试炼场副本
ModuleName.ConsigliereRecruitModule = "ConsigliereRecruitModule"  					--军师招募
ModuleName.RedPacketModule = "RedPacketModule"  					--红包大派送
ModuleName.VipBoxModule = "VipBoxModule"                                --vip宝箱
ModuleName.VipRebateModule = "VipRebateModule"                                --vip总动员
ModuleName.GeneralAndSoldierModule = "GeneralAndSoldierModule"                    --天降奇兵
ModuleName.EmperorAwardModule = "EmperorAwardModule"                                --皇帝的封赏
ModuleName.PartsGodModule = "PartsGodModule"                                --军械神将
ModuleName.DayTurntableModule = "DayTurntableModule"                                --每日转盘
ModuleName.EquipImgModule = "EquipImgModule"                                --武将图鉴
ModuleName.EquipSoulModule = "EquipSoulModule"                                --武魂
ModuleName.ActivityRankModule = "ActivityRankModule"                                --武魂
ModuleName.WarlordsModule = "WarlordsModule"                        --群雄涿鹿报名
ModuleName.WarlordsFieldModule = "WarlordsFieldModule"              --群雄涿鹿战场
ModuleName.WarlordsRankModule = "WarlordsRankModule"                --群雄涿鹿排行榜
ModuleName.WorldBossModule = "WorldBossModule"                        --世界boss
ModuleName.DramaModule = "DramaModule"                        --开场剧情
ModuleName.RegionModule = "RegionModule"                        --关卡地图
ModuleName.PopularSupportModule = "PopularSupportModule"                        --民心
ModuleName.HeroModule = "HeroModule"                        --英雄主界面
ModuleName.HeroPokedexModule = "HeroPokedexModule"                        --英雄图鉴
ModuleName.HeroTrainModule = "HeroTrainModule"                        --英雄养成
ModuleName.HeroHallModule = "HeroHallModule"
ModuleName.HeroTreaPutModule = "HeroTreaPutModule"            --英雄宝具穿戴
ModuleName.HeroTreaTrainModule = "HeroTreaTrainModule"            --英雄宝具培养
ModuleName.HeroTreaWarehouseModule = "HeroTreaWarehouseModule"            --英雄宝具仓库
ModuleName.HeadAndPendantModule = "HeadAndPendantModule"            --头像以及挂件设置
ModuleName.SmashEggModule = "SmashEggModule"                        --金鸡恐龙蛋
ModuleName.CollectBlessModule = "CollectBlessModule"                --迎春集福
ModuleName.ProvincialExamModule = "ProvincialExamModule"            --全服活动科举乡试
ModuleName.PalaceExamModule = "PalaceExamModule"                    --全服活动科举殿试
ModuleName.SpringSquibModule = "SpringSquibModule"                    --限时春节活动_爆竹酉礼
ModuleName.MartialTeachModule = "MartialTeachModule"                    --限时活动_武学讲堂


ModuleName.HeroGetModule = "HeroGetModule"  --新英雄获取
ModuleName.UnlockModule = "UnlockModule"  --新功能解锁

ModuleName.ReportModule = "ReportModule" --举报模块
ModuleName.LordCityModule = "LordCityModule" --城主战
ModuleName.LordCityRankModule = "LordCityRankModule" --城主战 排行
ModuleName.LordCityRecordModule = "LordCityRecordModule" --城主战 记录
-- ModuleName.GameActivityModule = "GameActivityModule" --新活动模块
ModuleName.LegionGiftModule = "LegionGiftModule"      --同盟大礼模块
ModuleName.RebelsModule = "RebelsModule"              --叛军模块

LegionModuleList = {  --军团相关的模块列表，先写死了，用来跳转判断，后续通过配置表来处理
    ModuleName.LegionSceneModule,
    ModuleName.LegionScienceTechModule  ,
    ModuleName.LegionModule  ,
    ModuleName.TigerMachineModule  ,
    ModuleName.LegionHallModule  ,
    ModuleName.LegionShopModule ,
    ModuleName.LegionHelpModule  ,
    ModuleName.LegionAdviceModule, 
    ModuleName.DungeonXModule,
    ModuleName.StationModule,
    ModuleName.LegionWelfareModule,
    ModuleName.LegionCombatCenterModule
}

--场景模块配置
SceneModuleMap = {}
SceneModuleMap[ModuleName.VipSupplyModule] = {url = "modules.vipSupply.VipSupplyModule"}
SceneModuleMap[ModuleName.ToolbarModule] = {url = "modules.toolbar.ToolbarModule"}
SceneModuleMap[ModuleName.BagModule] = {url = "modules.bag.BagModule"}
SceneModuleMap[ModuleName.MapModule] = {url = "modules.map.MapModule"}--,isExtras = 12}
SceneModuleMap[ModuleName.MailModule] = {url = "modules.mail.MailModule"}
SceneModuleMap[ModuleName.RoleInfoModule] = {url = "modules.roleInfo.RoleInfoModule"}
SceneModuleMap[ModuleName.PersonInfoModule] = {url = "modules.personInfo.PersonInfoModule"}
SceneModuleMap[ModuleName.InstanceModule] = {url = "modules.instance.InstanceModule"}
SceneModuleMap[ModuleName.BattleModule] = {url = "modules.battle.BattleModule"}
SceneModuleMap[ModuleName.DungeonModule] = {url = "modules.dungeon.DungeonModule"}
SceneModuleMap[ModuleName.TeamModule] = {url = "modules.team.TeamModule"}
SceneModuleMap[ModuleName.BarrackModule] = {url = "modules.barrack.BarrackModule"}
SceneModuleMap[ModuleName.MainSceneModule] = {url = "modules.mainScene.MainSceneModule"}
SceneModuleMap[ModuleName.ScienceMuseumModule] = {url = "modules.scienceMuseum.ScienceMuseumModule"}
SceneModuleMap[ModuleName.CreateRoleModule] = {url = "modules.createRole.CreateRoleModule"}
SceneModuleMap[ModuleName.LoaderModule] = {url = "modules.loader.LoaderModule"}
SceneModuleMap[ModuleName.EquipModule] = {url = "modules.equip.EquipModule"}
SceneModuleMap[ModuleName.ChatModule] = {url = "modules.chat.ChatModule"}
SceneModuleMap[ModuleName.WarehouseModule] = {url = "modules.warehouse.WarehouseModule"}
SceneModuleMap[ModuleName.PartsModule] = {url = "modules.parts.PartsModule",isExtras = 2}
SceneModuleMap[ModuleName.PartsWarehouseModule] = {url = "modules.partsWarehouse.PartsWarehouseModule",isExtras = 2}
SceneModuleMap[ModuleName.PartsStrengthenModule] = {url = "modules.partsStrengthen.PartsStrengthenModule",isExtras = 2}
SceneModuleMap[ModuleName.FriendModule] = {url = "modules.friend.FriendModule"}
SceneModuleMap[ModuleName.TaskModule] = {url = "modules.task.TaskModule"}
SceneModuleMap[ModuleName.SettingModule] = {url = "modules.setting.SettingModule" ,isExtras = 15}
SceneModuleMap[ModuleName.RechargeModule] = {url = "modules.recharge.RechargeModule"}
SceneModuleMap[ModuleName.ShopModule] = {url = "modules.shop.ShopModule"}
SceneModuleMap[ModuleName.LotteryEquipModule] = {url = "modules.lotteryEquip.LotteryEquipModule"}
SceneModuleMap[ModuleName.FightingCapModule] = {url = "modules.fightingCap.FightingCapModule"}
SceneModuleMap[ModuleName.TreasureModule] = {url = "modules.treasure.TreasureModule"}
SceneModuleMap[ModuleName.GainModule] = {url = "modules.gain.GainModule"}
SceneModuleMap[ModuleName.RankModule] = {url = "modules.rank.RankModule"}
SceneModuleMap[ModuleName.VipRebateModule] = {url = "modules.vipRebate.VipRebateModule"}--皇帝的封赏
SceneModuleMap[ModuleName.GeneralAndSoldierModule] = {url = "modules.generalAndSoldier.GeneralAndSoldierModule"}--天将奇兵
SceneModuleMap[ModuleName.EmperorAwardModule] = {url = "modules.emperorAward.EmperorAwardModule"}
SceneModuleMap[ModuleName.VipBoxModule] = {url = "modules.vipBox.VipBoxModule"}
SceneModuleMap[ModuleName.ArenaModule] = {url = "modules.arena.ArenaModule"}
SceneModuleMap[ModuleName.LittleHelperModule] = {url = "modules.littleHelper.LittleHelperModule"}
SceneModuleMap[ModuleName.ArenaShopModule] = {url = "modules.arenaShop.ArenaShopModule"}
SceneModuleMap[ModuleName.OpenServerGiftModule] = {url = "modules.openServerGift.OpenServerGiftModule"}
SceneModuleMap[ModuleName.ArenaMailModule] = {url = "modules.arenaMail.ArenaMailModule"}
SceneModuleMap[ModuleName.LegionWelfareModule] = {url = "modules.legionWelfare.LegionWelfareModule",isExtras = 1}
SceneModuleMap[ModuleName.LegionSceneModule] = {url = "modules.legionScene.LegionSceneModule",isExtras = 1}
SceneModuleMap[ModuleName.LimitExpModule] = {url = "modules.limitExp.LimitExpModule"}
SceneModuleMap[ModuleName.LegionScienceTechModule] = {url = "modules.legionScienceTech.LegionScienceTechModule",isExtras = 1}
SceneModuleMap[ModuleName.LegionApplyModule] = {url = "modules.legionApply.LegionApplyModule",isExtras = 1}
SceneModuleMap[ModuleName.LegionModule] = {url = "modules.legion.LegionModule",isExtras = 1}
SceneModuleMap[ModuleName.TigerMachineModule] = {url = "modules.tigerMachine.TigerMachineModule"}
SceneModuleMap[ModuleName.LegionHallModule] = {url = "modules.legionHall.LegionHallModule",isExtras = 1}
SceneModuleMap[ModuleName.LegionShopModule] = {url = "modules.legionShop.LegionShopModule",isExtras = 1}
SceneModuleMap[ModuleName.LegionHelpModule] = {url = "modules.legionHelp.LegionHelpModule"}
SceneModuleMap[ModuleName.ActivityModule] = {url = "modules.activity.ActivityModule"}
SceneModuleMap[ModuleName.EspecialGoodsUseModule] = {url = "modules.especialGoodsUse.EspecialGoodsUseModule"}
SceneModuleMap[ModuleName.StationModule] = {url = "modules.station.StationModule"}
SceneModuleMap[ModuleName.CheckTeamModule] = {url = "modules.checkTeam.CheckTeamModule"}
SceneModuleMap[ModuleName.GuideModule] = {url = "modules.guide.GuideModule"}
SceneModuleMap[ModuleName.LegionAdviceModule] = {url = "modules.legionAdvice.LegionAdviceModule",isExtras = 1}

SceneModuleMap[ModuleName.ChargeShareModule] = {url = "modules.chargeShare.ChargeShareModule"}
SceneModuleMap[ModuleName.PullBarActivityModule] = {url = "modules.pullBarActivity.PullBarActivityModule"}
SceneModuleMap[ModuleName.ActivityCenterModule] = {url = "modules.activityCenter.ActivityCenterModule",isExtras = 11}
SceneModuleMap[ModuleName.ConsigliereImgModule] = {url = "modules.consigliereImg.ConsigliereImgModule",isExtras = 3}
SceneModuleMap[ModuleName.LegionCombatCenterModule] = {url = "modules.legionCombatCenter.LegionCombatCenterModule",isExtras = 1}
SceneModuleMap[ModuleName.ConsigliereModule] = {url = "modules.consigliere.ConsigliereModule",isExtras = 3}
SceneModuleMap[ModuleName.DungeonXModule] = {url = "modules.dungeonX.DungeonXModule",isExtras = 1}
SceneModuleMap[ModuleName.ConsigliereRecruitModule] = {url = "modules.consigliereRecruit.ConsigliereRecruitModule",isExtras = 3}
SceneModuleMap[ModuleName.PartsGodModule] = {url = "modules.partsGod.PartsGodModule"}
SceneModuleMap[ModuleName.RedPacketModule] = {url = "modules.redPacket.RedPacketModule"}
SceneModuleMap[ModuleName.DayTurntableModule] = {url = "modules.dayTurntable.DayTurntableModule"}
SceneModuleMap[ModuleName.EquipImgModule] = {url = "modules.equipImg.EquipImgModule"}
SceneModuleMap[ModuleName.EquipSoulModule] = {url = "modules.equipSoul.EquipSoulModule"}
SceneModuleMap[ModuleName.ActivityRankModule] = {url = "modules.activityRank.ActivityRankModule"}
SceneModuleMap[ModuleName.WarlordsModule] = {url = "modules.warlords.WarlordsModule",isExtras = 18}
SceneModuleMap[ModuleName.WarlordsFieldModule] = {url = "modules.warlordsField.WarlordsFieldModule",isExtras = 18}
SceneModuleMap[ModuleName.WarlordsRankModule] = {url = "modules.warlordsRank.WarlordsRankModule",isExtras = 18}
SceneModuleMap[ModuleName.WorldBossModule] = {url = "modules.worldBoss.WorldBossModule",isExtras = 17}
SceneModuleMap[ModuleName.DramaModule] = {url = "modules.drama.DramaModule"}
SceneModuleMap[ModuleName.RegionModule] = {url = "modules.region.RegionModule"}
SceneModuleMap[ModuleName.PopularSupportModule] = {url = "modules.popularSupport.PopularSupportModule"}
SceneModuleMap[ModuleName.HeroModule] = {url = "modules.hero.HeroModule"}
SceneModuleMap[ModuleName.HeroTrainModule] = {url = "modules.heroTrain.HeroTrainModule"}
SceneModuleMap[ModuleName.HeroPokedexModule] = {url = "modules.heroPokedex.HeroPokedexModule", isExtras = 16}
SceneModuleMap[ModuleName.HeroHallModule] = {url = "modules.heroHall.HeroHallModule"}
SceneModuleMap[ModuleName.HeroTreaPutModule] = {url = "modules.heroTreaPut.HeroTreaPutModule", isExtras = 19}
SceneModuleMap[ModuleName.HeroTreaTrainModule] = {url = "modules.heroTreaTrain.HeroTreaTrainModule", isExtras = 19}
SceneModuleMap[ModuleName.HeroTreaWarehouseModule] = {url = "modules.heroTreaWarehouse.HeroTreaWarehouseModule", isExtras = 19}
SceneModuleMap[ModuleName.HeadAndPendantModule] = {url = "modules.headAndPendant.HeadAndPendantModule"}
SceneModuleMap[ModuleName.SmashEggModule] = {url = "modules.smashEgg.SmashEggModule", isExtras = 22}
SceneModuleMap[ModuleName.CollectBlessModule] = {url = "modules.collectBless.CollectBlessModule", isExtras = 23}
SceneModuleMap[ModuleName.ProvincialExamModule] = {url = "modules.provincialExam.ProvincialExamModule", isExtras = 21}
SceneModuleMap[ModuleName.PalaceExamModule] = {url = "modules.palaceExam.PalaceExamModule", isExtras = 21}
SceneModuleMap[ModuleName.SpringSquibModule] = {url = "modules.springSquib.SpringSquibModule", isExtras = 22}
SceneModuleMap[ModuleName.MartialTeachModule] = {url = "modules.martialTeach.MartialTeachModule"}



SceneModuleMap[ModuleName.HeroGetModule] = {url = "modules.heroGet.HeroGetModule"}
SceneModuleMap[ModuleName.UnlockModule] = {url = "modules.unlock.UnlockModule"}

SceneModuleMap[ModuleName.ReportModule] = {url = "modules.report.ReportModule"}
SceneModuleMap[ModuleName.LordCityModule] = {url = "modules.lordCity.LordCityModule", isExtras = 20}
SceneModuleMap[ModuleName.LordCityRankModule] = {url = "modules.lordCityRank.LordCityRankModule", isExtras = 20}
SceneModuleMap[ModuleName.LordCityRecordModule] = {url = "modules.lordCityRecord.LordCityRecordModule", isExtras = 20}
-- SceneModuleMap[ModuleName.GameActivityModule] = {url = "modules.gameActivity.GameActivityModule"}
SceneModuleMap[ModuleName.LegionGiftModule] = {url = "modules.legionGift.LegionGiftModule"}
SceneModuleMap[ModuleName.RebelsModule] = {url = "modules.rebels.RebelsModule"}

--模块加载相关数据
--打开模块会判断这里的资源，进行预加载资源
--如果有关闭释放的话，则释放掉配置的资源
--有预加载就有释放

ModuleLoadMap = {}
-- ModuleLoadMap[ModuleName.MapModule] = {
-- 	textures = {"ui/map_ui_resouce_big_0.webp", "bg/map/map_bg.webp", "bg/map/map-alpha.webp"},
-- 	plists = {"ui/map_ui_resouce_big_0.plist"},
-- 	time = 10
-- }

-- ModuleLoadMap[ModuleName.ActivityCenterModule] = {
-- 	textures = {"effect/frame/rpg-texturecycle.pvr.ccz","effect/frame/rpg-handlescycle.pvr.ccz",
-- 	"effect/frame/rpg-handles.pvr.ccz","effect/frame/rpg-flash.png",
-- 	"effect/frame/rpg-Criticalpoint.pvr.ccz","effect/frame/rpg-lights.png",
-- 	"effect/frame/rpg-lamp.png","effect/frame/rpg-listof.png",
-- 	"effect/frame/rpg-lightspot.png","effect/frame/rpg-mars.png"},

-- 	plists = {"effect/frame/rpg-texturecycle.plist","effect/frame/rpg-handlescycle.plist",
-- 	"effect/frame/rpg-handles.plist","effect/frame/rpg-flash.plist","effect/frame/rpg-Criticalpoint.plist",
-- 	"effect/frame/rpg-lights.plist","effect/frame/rpg-lamp.plist","effect/frame/rpg-listof.plist",
-- 	"effect/frame/rpg-lightspot.plist","effect/frame/rpg-mars.plist"},
-- 	time = 100
-- }

-- ModuleLoadMap[ModuleName.OpenServerGiftModule] = {
-- 	textures = {},
-- 	plists = {},
-- 	time = 1000000
-- }

--ModuleLoadMap[ModuleName.DungeonModule] = {
--	textures = {"bg/dungeon/dungeon_bg.webp","ui/dungeon_ui_resouce_big_0.webp"},
--	plists = {"ui/dungeon_ui_resouce_big_0.plist"}
--}

--ModuleLoadMap[ModuleName.InstanceModule] = {
--	textures = {"ui/instance_ui_resouce_big_0.webp"},
--	plists = {"ui/instance_ui_resouce_big_0.plist"}
--}

-- ModuleLoadMap[ModuleName.ActivityModule] = {
--  	textures = {"ui/activity_ui_resouce_big_0.webp"},
--  	plists = {"ui/activity_ui_resouce_big_0.plist"},
--  	time = 100
--  }

--ModuleLoadMap[ModuleName.RoleInfoModule] = {
--	textures = {"ui/roleInfo_ui_resouce_big_0.webp"},
--	plists = {"ui/roleInfo_ui_resouce_big_0.plist"}
--}

-- ModuleLoadMap[ModuleName.TreasureModule] = {
-- 	textures = {"ui/treasure_ui_resouce_big_0.webp"},
-- 	plists = {"ui/treasure_ui_resouce_big_0.plist"},
-- 	time = 100
-- }

-- ModuleLoadMap[ModuleName.LotteryEquipModule] = {
--  	textures = {"ui/lotteryEquip_ui_resouce_big_0.webp"},
--  	plists = {"ui/lotteryEquip_ui_resouce_big_0.plist"},
--  	time = 100
--  }

--会影响到引导
-- ModuleLoadMap[ModuleName.EquipModule] = {
-- 	textures = {"ui/equip_ui_resouce_big_0.webp"},
-- 	plists = {"ui/equip_ui_resouce_big_0.plist"}
-- }

--一直存在的模块
ModulePersistMap = {}

ModulePersistMap[ModuleName.MainSceneModule] = {}
ModulePersistMap[ModuleName.RoleInfoModule] = {}
ModulePersistMap[ModuleName.ToolbarModule] = {}
ModulePersistMap[ModuleName.ActivityModule] = {}
ModulePersistMap[ModuleName.ChatModule] = {}
ModulePersistMap[ModuleName.BarrackModule] = {}  --TODO 要看一下这个模块
ModulePersistMap[ModuleName.ScienceMuseumModule] = {}
