-- /**
--  * @Author:	  fzw
--  * @DateTime:	2016-05-30 14:04:20
--  * @Description: 全局配置性文件
--					最大值、价格等没有配表的数据，必须统一在这里配置，
-- 					减少出错机会，方便修改数据，增强可配置性。
--  */
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
GlobalConfig = {}
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
GlobalConfig.isOpenTestState = false         --是否开启测试模式(true=开启，false=关闭)


-------------------------------------------------------------------------------
GlobalConfig.moduleJumpAnimationName = "rgb-guochangyun"  --过场切换特效
GlobalConfig.moduleJumpAnimationDelay = 580  		--过场特效到达全屏的时间：毫秒

-------------------------------------------------------------------------------
-- UITeamDetailPanel 通用布阵UI的坑位缩放参数
GlobalConfig.UITeamDetailScale = 1  --整个坑位的全部东西缩放大小
GlobalConfig.UITeamDetailSoldierScale = 0.8  --坑位的佣兵单独缩放大小
GlobalConfig.UISoldierAnchorPoint = cc.p(0.5,0.42)  --坑位的佣兵图片锚点设置
-------------------------------------------------------------------------------
-- 副本地图的宝箱和匕首特效参数（region模块）
GlobalConfig.RegionBoxPos = cc.p(60, -20)   --宝箱坐标
GlobalConfig.RegionKnifePos = cc.p(58, 70)  --匕首坐标
GlobalConfig.RegionBoxScale = 0.75			--宝箱缩放
GlobalConfig.RegionKnifeScale = 1			--匕首缩放
-------------------------------------------------------------------------------
-- UI统一布局自适应的相关参数

GlobalConfig.downHeight = 25  --距离下边界高度
GlobalConfig.topTabsHeight = 0  --listview高度修正(大于0：高度减小，小于0：高度增加)
GlobalConfig.tabsHeight = 165  --界面顶部标签高度165左右
GlobalConfig.tabsMaxHeight = 814  --标签的世界坐标高度
GlobalConfig.topHeight = 886  --距离上边界高度（界面顶部高度74左右）无标签的最高高度
-- topHeight 替换成这个BasicPanel:topAdaptivePanel()

GlobalConfig.tabsAdaptive = 60  --tabsPanel标签自适应的修正高度
GlobalConfig.topAdaptive = 60  --无标签panel自适应的修正高度

-------------------------------------------------------------------------------
GlobalConfig.ResIconScale = 0.6  --资源icon缩放大小
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
GlobalConfig.playerMaxLv = 80 				--主公最高等级
GlobalConfig.commandMaxLv = 80 				--统率最高等级
GlobalConfig.boomMaxLv = 80 				--繁荣最高等级
GlobalConfig.prestigeMaxLv = 80 			--声望最高等级
GlobalConfig.skillResetPrice = 58 			--战法重置价格（元宝）
GlobalConfig.chatMinLv = 1 				--聊天和写信的最低等级限制

GlobalConfig.autoBuildPrice = 238 			--自动升级购买价格（元宝）
GlobalConfig.autoBuildTime = 4 			    --自动升级有效时长（小时）

GlobalConfig.partWarehouseMaxCount = 75+4*8	--军械最大数量=军械仓库最大值+可装备槽位最大值
GlobalConfig.pieceWarehouseMaxCount = 75	--军械仓库-碎片最大数量

GlobalConfig.dailyTaskRefreshPrice = 5 		--刷新日常任务价格（元宝）
GlobalConfig.dailyTaskResetPrice = 25		--重置日常任务次数价格（元宝）

GlobalConfig.LegionWelfareMaxLV = 30		--军团福利所最高等级
GlobalConfig.BlessEnergyMaxCount = 10		--每日可以领取好友祝福军令上限

GlobalConfig.maxRefreshPrice = 20           --民心刷新需要元宝最大值
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
GlobalConfig.worldMapScale = 0.9   			--世界地图缩放大小
GlobalConfig.worldMapBuildScale = 0.68  	    --世界地图玩家基地缩放大小
GlobalConfig.worldMapResScaleConf = {     --世界地图资源点缩放大小
	-- {01,19,0.9}
	-- 参数：01=资源点等级下限
	-- 		 19=资源点等级上限
	-- 		 0.9=缩放大小

	{01,29,0.85},{30,60,0.95}
}


GlobalConfig.WorldResTitlePos =  cc.p(0, 55)   	--资源点标题坐标
GlobalConfig.WorldPlayerTitlePos =  cc.p(0, 70)  --玩家基地标题坐标

-------------------------------------------------------------------------------
GlobalConfig.hitBuildColor = {178,178,178} --点击(主城/军团)建筑RGB颜色

-------------------------------------------------------------------------------
--主城未开启的功能建筑提示 (建筑类型)
GlobalConfig.mainSceneBuildLocked = {
	12,
	--15,  --军师府
	18,
	19,
	20,
}

--隐藏等级的建筑类型
GlobalConfig.hideLevelList = {11, 12, 13, 14, 15, 16, 17, 18, 20} 

--隐藏建筑标题+等级（type）
-- GlobalConfig.hideTitle = {19,21,22}

--隐藏可建造锤子（type）
-- GlobalConfig.hideHammer = {19,21,22}


GlobalConfig.mainSceneTouchBegan = true    --显示主城建筑标题+等级
GlobalConfig.mainSceneTouchEnd = false     --隐藏主城建筑标题+等级
GlobalConfig.mainSceneInit = false         --初始化是否显示主城建筑标题+等级
GlobalConfig.mainSceneisShowLevel = true   --是否显示建筑等级

-------------------------------------------------------------------------------
GlobalConfig.mainSceneResTitlePos = cc.p(-50,0)  --主城野外建筑等级坐标偏移

-------------------------------------------------------------------------------

GlobalConfig.centerPos  = cc.p(240, 550)    --主城初始位置坐标(像素)
-- 主城场景地图和军团场景地图共用以下配置参数
GlobalConfig.fromScale  = 2.0    			--缩放起始的值
GlobalConfig.toScale  = 0.62   			    --缩放结束的值(最终显示的缩放大小)
GlobalConfig.delay  = 0.5    				--缩放动画时长(秒)


GlobalConfig.sunshineScale  = 1.5    		--主城阳光特效缩放大小
GlobalConfig.sunshineIsShow = false   	    --主城阳光特效显示开关(true=显示，false=隐藏)
GlobalConfig.isSunshineImgShow = false       --主城阳光图片显示开关(true=显示，false=隐藏)
-------------------------------------------------------------------------------
-- 光晕
GlobalConfig.sunshine2Url  = "images/common/sunshine.png"    		--主城光晕资源
GlobalConfig.sunshine2Scale0  = 1    		--主城光晕起始缩放大小
GlobalConfig.sunshine2Scale1  = 1.1  	    --主城光晕结束缩放大小
GlobalConfig.sunshine2Delay  = 25    		--主城光晕缩放时长(从sunshine2Scale0到sunshine2Scale1)
GlobalConfig.sunshine2IsShow  = true    	--主城光晕显示开关(true=显示，false=隐藏)
GlobalConfig.sunshine2MaxR  = 2    	        --主城光晕顺时针旋转最大角度(度)

GlobalConfig.sunshine2Fade0  = 200    		--主城光晕起始透明度
GlobalConfig.sunshine2Fade1  = 255  	    --主城光晕结束透明度
GlobalConfig.sunshine2Delay2  = 5    		--主城光晕渐变时长(从sunshine2Fade0到sunshine2Fade1)
GlobalConfig.sunshine2Pos = cc.p(890, 180)  --光晕坐标
GlobalConfig.ancPoint = cc.p(1, 1)    		--光晕锚点

-------------------------------------------------------------------------------
-- 老鹰配置参数
GlobalConfig.birdScale  = 2.0    				--主城老鹰特效缩放大小
GlobalConfig.birdWaitDelay  = 3000   			--进入主城老鹰出现前等待时间(毫秒)
GlobalConfig.birdEffect1 = "rpg-the-eagle"   	--主城老鹰特效文件名
GlobalConfig.birdEffect2 = "rpg-the-eagles"   	--主城老鹰特效文件名 滑翔
GlobalConfig.birdAudio = "yx_bird"          	--主城老鹰音效文件名

GlobalConfig.birdMaxCount = 1					--主城老鹰最大数量(最小值1)
GlobalConfig.birdBeginRandomY = {000,480}		--主城老鹰起飞Y坐标随机范围
GlobalConfig.birdEndPosX  = {2200, 3000}    	--主城老鹰终点X坐标随机范围
GlobalConfig.birdEndPosY  = {1200, 2300}    	--主城老鹰终点Y坐标随机范围
GlobalConfig.birdBeginRandomWait = {120000,150000}	--主城老鹰起飞间隔时间随机范围(毫秒)
GlobalConfig.birdFlyDelay = {20,25}    		    --主城老鹰飞行时长随机范围(秒)
GlobalConfig.birdFlyCount1 = {1,10}    		    --主城老鹰拍翅膀循环次数随机范围
GlobalConfig.birdFlyCount2 = {40,200}    		--主城老鹰滑翔循环次数随机范围


GlobalConfig.bezierPos1  = cc.p(200, 000)   	--曲线控制点1坐标
GlobalConfig.bezierPos2  = cc.p(200, 000)   	--曲线控制点2坐标

-------------------------------------------------------------------------------
-- 资源建筑特效参数
GlobalConfig.FieldBuildEffectConf = {scale = 1.0, effectName = 'rpg-the-particle'}

GlobalConfig.fieldEffPos = cc.p(00, 20)		--整体坐标值(特效+图标)
GlobalConfig.fieldEffEndDelay = 3			--播放结束间隔时间

GlobalConfig.fieldEffRotateAncle = 6		--图标晃动角度
GlobalConfig.fieldEffRotateDelay = 0.3		--图标一次晃动时间
GlobalConfig.fieldEffDelay = 0.04*40		--图标上升时间
GlobalConfig.fieldEffSca = {0, 1.5}			--图标缩放大小（起始值，终点值）

-- (先快后慢)
GlobalConfig.fieldEffMov = {-50, 20, 50}				--图标上升距离（起始Y坐标，临界点Y坐标，终点Y坐标）
GlobalConfig.fieldEffMovDelay = {0.04*20, 0.04*20}		--图标上升时间(第一段，第二段)
GlobalConfig.fieldEffMovRate = 1						--图标上升的速率


-------------------------------------------------------------------------------
-- 建筑动画 
-- buildAction[type] ： type = 22 船
GlobalConfig.buildAction = {}
GlobalConfig.buildAction[22] = {
								movY = {-5, 00}, 	--{最低点Y坐标，最高点Y坐标}
								movT = {1.5,1.5}, 	--{下降时间，上升时间}秒
								rate = 1			--速率
							}

-------------------------------------------------------------------------------
-- 世界地图资源点特效配置
-- 示例：
-- GlobalConfig.worldMapEffects[1] = {"rpg-green", cc.p(0,0)}
-- 参数：
-- worldMapEffects[1] = 资源点type=1
-- "rpg-green" = 特效文件名
-- cc.p(0,0) = 偏移坐标

GlobalConfig.worldMapEffects = {}
GlobalConfig.worldMapEffects[1] = {effectName = "rgb-yinkuang",  pos = cc.p(0,0)}  	--资源点type=1银矿
GlobalConfig.worldMapEffects[2] = {effectName = "rgb-tiekuang",   pos = cc.p(0,0)}		--资源点type=2铁
GlobalConfig.worldMapEffects[3] = {effectName = "rgb-muchang", pos = cc.p(0,0)}		--资源点type=3木
GlobalConfig.worldMapEffects[4] = {effectName = "rgb-shikuang",  pos = cc.p(0,0)}		--资源点type=4石头
GlobalConfig.worldMapEffects[5] = {effectName = "rgb-daotian", pos = cc.p(0,0)}		--资源点type=5农田


--二级弹窗tag
GlobalConfig.uitopWin = {}
GlobalConfig.uitopWin.UIRecharge = "UIRecharge"
GlobalConfig.uitopWin.UISoldierInfo = "UISoldierInfo"



GlobalConfig.uipopWin = {}
GlobalConfig.uipopWin.UIMessageBox = "UIMessageBox"




-------------------------------------------------------------------------------
-- 主城巡逻兵参数
-- (GlobalConfig.moveDelay + GlobalConfig.standDelay) / 0.32 最好能整除

-- 主城巡逻兵特效配表
-- 参数：
-- pos = 'pos1'  						UI对应位置(目录：mainPanel\)
-- count = 6							巡逻兵数量
-- moveDelay = 6                  		从头走到尾的时间(暂定最大值为10秒)
-- standDelay = 0.4               		走到尾站立的时间，然后隐藏
-- standScale = 1.2						缩放大小
-- effectName = 'rpg-Running water'		特效文件名

GlobalConfig.MainSceneSoldierEff = {}
GlobalConfig.MainSceneSoldierEff[1] = {pos = 'movPos1', count = 1, moveDelay = 6.08, standDelay = 0.4, standScale = 1.2, effectName = {"rpg-the-soldiers", "rpg-the-marines"}}
GlobalConfig.MainSceneSoldierEff[2] = {pos = 'movPos2', count = 1, moveDelay = 0.32*40 -0.4, standDelay = 0.4, standScale = 1.2, effectName = {"rpg-the-soldiers", "rpg-the-marines"}}


-------------------------------------------------------------------------------
-- 主城建筑信息坐标：标题OR生产图标OR升级图标的坐标
-- （即相对于建筑图锚点的偏移坐标）

-- 示例
-- GlobalConfig.buildingInfoPos["1-1"] = {title = {-30,70}, icon = {-30,70}, iconScale = 3.0}
-- ["1-1"] = 建筑类型-建筑ID
-- title = {-30,70} : 标题坐标
-- icon = {-30,70} :  图标坐标(升级/生产共用)
-- iconScale = 3 :  图标缩放大小(升级/生产共用)

GlobalConfig.keyTitle = "title"
GlobalConfig.keyIcon = "icon"
GlobalConfig.keyIconScale = "iconScale"

GlobalConfig.defIconScale = 1.0  --图标默认缩放大小，如果有配iconScale，就用iconScale大小
GlobalConfig.defTitleScale = 1.0  --建筑标题默认缩放大小

GlobalConfig.buildingInfoPos = {} 
GlobalConfig.buildingInfoPos["1-1"] = {title = {0,-100}, icon = {130,100}, iconScale = 1.2}	--官邸
GlobalConfig.buildingInfoPos["9-2"] = {title = {-150,0}, iconScale = 1.1}	--兵营1
GlobalConfig.buildingInfoPos["9-3"] = {title = {-150,0}, iconScale = 1.1}    --兵营2
GlobalConfig.buildingInfoPos["12-5"] = {title = {0,-70}}	--大军基地
GlobalConfig.buildingInfoPos["19-16"] = {title = {-100,20}}   --皇帝雕像
GlobalConfig.buildingInfoPos["13-6"] = {title = {-120,10}}	--将军府
GlobalConfig.buildingInfoPos["10-4"] = {title = {-165,10}}  --校场
GlobalConfig.buildingInfoPos["17-14"] = {title = {-128,10},icon = {13,120}, iconScale = 1.4} --军团大厅
GlobalConfig.buildingInfoPos["20-17"] = {title = {-160,10}} --军工所
GlobalConfig.buildingInfoPos["8-12"] = {title = {-120,0}}  --太学院
GlobalConfig.buildingInfoPos["18-15"] = {title = {-160,20}}  --军制所
GlobalConfig.buildingInfoPos["16-13"] = {title = {-150,0}}  --演武场
GlobalConfig.buildingInfoPos["15-8"] = {title = {-160,0}}  --军师府
GlobalConfig.buildingInfoPos["14-7"] = {title = {-115,0}}  --军械坊
GlobalConfig.buildingInfoPos["7-10"] = {title = {-85,0}}   --仓库
GlobalConfig.buildingInfoPos["7-9"] = {title = {-85,0}}   --仓库
GlobalConfig.buildingInfoPos["11-11"] = {title = {-100,0}, iconScale = 1.1}   --工匠坊



-------------------------------------------------------------------------------
-- 登陆游戏预加载特效配表
-- 要在这里配一下主城的特效文件名
GlobalConfig.ScenePreEffects = {}
GlobalConfig.ScenePreEffects[1] = "rpg-levelup"
--GlobalConfig.ScenePreEffects[2] = "rpg-time"   --VipBoxPanel.lua
--GlobalConfig.ScenePreEffects[3] = "rpg-Criticalpoint"
-- GlobalConfig.ScenePreEffects[4] = "rpg-sidelight"
-- GlobalConfig.ScenePreEffects[5] = "rpg-Positivelight"  --已废弃
GlobalConfig.ScenePreEffects[6] = "rpg-Running-water"
--GlobalConfig.ScenePreEffects[7] = "rpg-horizontal"
GlobalConfig.ScenePreEffects[8] = "rpg-drainage"
GlobalConfig.ScenePreEffects[9] = "rpg-a-horizontal-plane"
--GlobalConfig.ScenePreEffects[10] = "rpg-horizontal-plane"
GlobalConfig.ScenePreEffects[11] = "rpg-the-sun"     --roleInfo模块
--GlobalConfig.ScenePreEffects[12] = "rpg-marines"
GlobalConfig.ScenePreEffects[13] = "rpg-generals"
GlobalConfig.ScenePreEffects[14] = "rpg-gear"
GlobalConfig.ScenePreEffects[15] = "rpg-tap"
GlobalConfig.ScenePreEffects[16] = "rpg-gears"
GlobalConfig.ScenePreEffects[17] = "rpg-light"
GlobalConfig.ScenePreEffects[18] = "rpg-the-fire"
GlobalConfig.ScenePreEffects[19] = "rpg-the-ball"
GlobalConfig.ScenePreEffects[20] = "rpg-water-wheel"
GlobalConfig.ScenePreEffects[21] = "rpg-gossip"
GlobalConfig.ScenePreEffects[22] = "rpg-lava"
GlobalConfig.ScenePreEffects[23] = "rpg-the-flags"
--GlobalConfig.ScenePreEffects[24] = "rpg-flow-time"
--GlobalConfig.ScenePreEffects[25] = "rpg-flags"
GlobalConfig.ScenePreEffects[26] = "rpg-smoke"
GlobalConfig.ScenePreEffects[27] = "rpg-the-flagss"
GlobalConfig.ScenePreEffects[28] = "rpg-the-eagle"
GlobalConfig.ScenePreEffects[29] = "rpg-the-eagles"
GlobalConfig.ScenePreEffects[30] = "rpg-marinesxil"
--GlobalConfig.ScenePreEffects[31] = "rpg-blasting"  --equipUp
-- GlobalConfig.ScenePreEffects[32] = "rpg-small-fire"
GlobalConfig.ScenePreEffects[33] = "rpg-green"
GlobalConfig.ScenePreEffects[34] = "rpg-orange"
GlobalConfig.ScenePreEffects[35] = "rpg-blue"
GlobalConfig.ScenePreEffects[36] = "rpg-purple"
GlobalConfig.ScenePreEffects[37] = "rpg-Acompass"
GlobalConfig.ScenePreEffects[38] = "rpg-the-marines"
GlobalConfig.ScenePreEffects[39] = "rpg-the-soldiers"
GlobalConfig.ScenePreEffects[40] = "rpg-The-waterfall"

-------------------------------------------------------------------------------
-- 主城流水特效配表
-- 参数：
-- pos = 'pos1'  						UI对应位置(目录：mainPanel\movieChipPos_water\rpg-Running_water\)
-- scale = '2.0'  						缩放大小
-- effectName = 'rpg-Running water'		特效文件名
GlobalConfig.isTrueWaterPos = true
GlobalConfig.MainSceneEffectPos = {}
--GlobalConfig.MainSceneEffectPos[0] = {pos = 'pos0', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[1] = {pos = 'pos1', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[2] = {pos = 'pos2', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[3] = {pos = 'pos3', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[4] = {pos = 'pos4', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[5] = {pos = 'pos5', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[6] = {pos = 'pos6', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[7] = {pos = 'pos7', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[8] = {pos = 'pos8', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[9] = {pos = 'pos9', scale = '2.0', effectName = 'rpg-Running-water'}
--GlobalConfig.MainSceneEffectPos[10] = {pos = 'pos10', scale = '2.0', effectName = 'rpg-horizontal'}
--GlobalConfig.MainSceneEffectPos[11] = {pos = 'pos11', scale = '2.0', effectName = 'rpg-drainage'}
--GlobalConfig.MainSceneEffectPos[12] = {pos = 'pos12', scale = '2.0', effectName = 'rpg-drainage'}
--GlobalConfig.MainSceneEffectPos[13] = {pos = 'pos13', scale = '2.0', effectName = 'rpg-drainage'}
--GlobalConfig.MainSceneEffectPos[14] = {pos = 'pos14', scale = '2.0', effectName = 'rpg-drainage'}
--GlobalConfig.MainSceneEffectPos[15] = {pos = 'pos15', scale = '2.0', effectName = 'rpg-a-horizontal-plane'}
-- GlobalConfig.MainSceneEffectPos[16] = {pos = 'pos16', scale = '2.0', effectName = 'rpg-a-horizontal-plane'} -- 水波纹
--GlobalConfig.MainSceneEffectPos[17] = {pos = 'pos17', scale = '2.0', effectName = 'rpg-a-horizontal-plane'}
--GlobalConfig.MainSceneEffectPos[18] = {pos = 'pos18', scale = '2.0', effectName = 'rpg-a-horizontal-plane'}
--GlobalConfig.MainSceneEffectPos[19] = {pos = 'pos19', scale = '2.0', effectName = 'rpg-horizontal-plane'}
--GlobalConfig.MainSceneEffectPos[20] = {pos = 'pos20', scale = '2.0', effectName = 'rpg-horizontal-planes'}
GlobalConfig.MainSceneEffectPos[21] = {pos = 'pos21', scale = '1.2', effectName = 'rpg-marinesxi'}
--GlobalConfig.MainSceneEffectPos[22] = {pos = 'pos22', scale = '1.2', effectName = 'rpg-Running-water'}
GlobalConfig.MainSceneEffectPos[23] = {pos = 'pos23', scale = '1.2', effectName = 'rpg-marinesxi'}
GlobalConfig.MainSceneEffectPos[24] = {pos = 'pos24', scale = '1.2', effectName = 'rpg-marinesxi'}
--GlobalConfig.MainSceneEffectPos[25] = {pos = 'pos25', scale = '1.2', effectName = 'rpg-marinesxi'}
GlobalConfig.MainSceneEffectPos[26] = {pos = 'pos26', scale = '1.2', effectName = 'rpg-marinesxi'}
GlobalConfig.MainSceneEffectPos[27] = {pos = 'pos27', scale = '1.2', effectName = 'rpg-marinesxi'}
GlobalConfig.MainSceneEffectPos[28] = {pos = 'pos28', scale = '1.2', effectName = 'rpg-marinesxi'}
GlobalConfig.MainSceneEffectPos[29] = {pos = 'pos29', scale = '1.2', effectName = 'rpg-marinesxi'}
--GlobalConfig.MainSceneEffectPos[30] = {pos = 'pos30', scale = '1.2', effectName = 'rpg-marinesxi'}
GlobalConfig.MainSceneEffectPos[31] = {pos = 'pos31', scale = '1.2', effectName = 'rpg-marinesxi'}
GlobalConfig.MainSceneEffectPos[32] = {pos = 'pos32', scale = '1.2', effectName = 'rpg-marinesxi'}
--GlobalConfig.MainSceneEffectPos[33] = {pos = 'pos33', scale = '1', effectName = 'rpg-Runningwaters'} --瀑布效果1
--GlobalConfig.MainSceneEffectPos[34] = {pos = 'pos34', scale = '1', effectName = 'rpg-The-waterfall'} --瀑布效果2


-------------------------------------------------------------------------------
-- 真·流水特效信息配置表
-- 参数：
-- pos = 'pos1'  						UI对应位置
-- scale = '2.0'  						缩放大小
-- effectName = 'rpg-Running water'		特效文件名
GlobalConfig.MainSceneWaterPos = {}
-- 城门的四个，位置从左到右
GlobalConfig.MainSceneWaterPos[1] = {pos = 'pos1', scale = '1.0', effectName = 'rgb-city-flow'}
GlobalConfig.MainSceneWaterPos[3] = {pos = 'pos3', scale = '1.0', effectName = 'rgb-city-flow'}
GlobalConfig.MainSceneWaterPos[5] = {pos = 'pos5', scale = '1.0', effectName = 'rgb-city-flow'}
GlobalConfig.MainSceneWaterPos[6] = {pos = 'pos6', scale = '1.0', effectName = 'rgb-city-flow'}
-- 中间的两个，位置从左到右
GlobalConfig.MainSceneWaterPos[11] = {pos = 'pos11', scale = '1.0', effectName = 'rgb-city-tivers'}
GlobalConfig.MainSceneWaterPos[12] = {pos = 'pos12', scale = '1.0', effectName = 'rgb-city-tivers'}
GlobalConfig.MainSceneWaterPos[13] = {pos = 'pos13', scale = '1.0', effectName = 'rgb-city-tivers'}
GlobalConfig.MainSceneWaterPos[14] = {pos = 'pos14', scale = '1.0', effectName = 'rgb-city-tivers'}
--最大的瀑布
GlobalConfig.MainSceneWaterPos[34] = {pos = 'pos34', scale = '1', effectName = 'rgb-fall'} --瀑布效果2





-------------------------------------------------------------------------------
-- 主城建筑特效配表
-- 参数：
-- pos = 'pos1'  						UI对应位置(目录：mainPanel\buildingPanelx_x)
-- scale = '2.0'  						缩放大小
-- effectName = 'rpg-Running water'		特效文件名

GlobalConfig.MainSceneBuildEffectPos = {}
GlobalConfig.MainSceneBuildEffectPos["13-6"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-generals'}}
GlobalConfig.MainSceneBuildEffectPos["20-17"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-gear'},
                                                {pos = 'pos2', scale = 1.0, effectName = 'rpg-tap'}}
GlobalConfig.MainSceneBuildEffectPos["11-11"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-gears'},
                                                {pos = 'pos2', scale = 1.0, effectName = 'rpg-light'}}
GlobalConfig.MainSceneBuildEffectPos["17-14"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-the-fire'}}
GlobalConfig.MainSceneBuildEffectPos["8-12"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-the-ball'},
                                                {pos = 'pos2', scale = 1.0, effectName = 'rpg-water-wheel'}}
GlobalConfig.MainSceneBuildEffectPos["15-8"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-gossip'}}
GlobalConfig.MainSceneBuildEffectPos["14-7"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-lava'},
                                                 {pos = 'pos2', scale = 1.0, effectName = 'rpg-the-flags'}}
--GlobalConfig.MainSceneBuildEffectPos["18-15"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-flow-time'},
                                                 --{pos = 'pos2', scale = 1.0, effectName = 'rpg-flags'}}
GlobalConfig.MainSceneBuildEffectPos["10-4"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-smoke'}}
GlobalConfig.MainSceneBuildEffectPos["10-4"] = { {pos = 'pos1', scale = 1.0, effectName = 'rpg-the-flagss'}}


-- GlobalConfig.MainSceneBuildEffectPos["3-8"] = { {pos = 'pos1', scale = 2.0, effectName = 'rpg-the-flagss'},
-- 												{pos = 'pos2', scale = 2.0, effectName = 'rpg-the-flagss'}}

GlobalConfig.rersistResMap = {}  --持久，不释放的纹理资源
--是否为不释放的资源
function GlobalConfig:isRersistRes(key)
	return self.rersistResMap[key] ~= nil
end

--全局，预加载完毕后，才能进入场景
GlobalConfig.preLoadComplete = false
--全局预加载图片资源
function GlobalConfig:preLoadImage()

    if GameConfig.targetPlatform ~= cc.PLATFORM_OS_WINDOWS then
    	AudioManager:clearAudioCache()  --加载的时候，做一下清除缓存
    end
	

    --异步加载，不采用加载条了，直接后台加载，加快进入游戏
    --预加载plist
    local maxPlistNum = 0
    local curPlistNum = 0
    local startPlistProgree = 60
    local function addSpriteFrames(objm, plist)
    	logger:info("~~资%s", plist)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
        curPlistNum = curPlistNum + 1
        if curPlistNum >= maxPlistNum then
--            if completeCallback ~= nil then
--                -- completeCallback()
--            end
        end
    end

    local maxNum = 0
    local curNum = 0
    local startProgree = 20
    local plistList = {}
    local function imageLoaded(texture)
--        print("======preLoadImage==========", texture)
        curNum = curNum + 1
        local progree = startProgree + (curNum / maxNum) * 40
        -- self:setLoadProgress(progree)
        if curNum >= maxNum then
             GlobalConfig.preLoadComplete = true
            local index = 1
            for _, plist in pairs(plistList) do  --TODO 需要优化 场景切换时，会断掉定时器，导致后面的plish没有加载上
                local tmp = {}
                TimerManager:addOnce(100 * index, addSpriteFrames, tmp, plist ) 
                index = index + 1
            end
            maxPlistNum = #plistList
--            if completeCallback ~= nil then
--                completeCallback()
--            end
        end
    end
    
    local file_type = TextureManager.file_type
    local preLoadUrlList = {}

    table.insert(preLoadUrlList, "ui/gui_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/guiNew_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/common_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/guiScale9_ui_resouce_big_0" .. file_type)

    table.insert(preLoadUrlList, "ui/roleInfo_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/toolbar_ui_resouce_big_0" .. file_type)

    --TextureManager.bg_type
    for index=1, 10 do
        local url = string.format("bg/scene/1_%02d" .. ".pvr.ccz", index)
        table.insert(preLoadUrlList, url)
    end

    table.insert(preLoadUrlList, "ui/mainScene_ui_resouce_big_0" .. file_type)
    -- for k,v in pairs(GlobalConfig.ScenePreEffects) do
    --     url = "effect/frame/" .. v .. ".png"
    --     table.insert(preLoadUrlList, url)  --无脑设置，png或者pvr通杀
    --     url = "effect/frame/" .. v .. ".pvr.ccz"
    --     table.insert(preLoadUrlList, url)
    -- end



    -- table.insert(preLoadUrlList, "bg/dungeon/dungeon_bg" .. TextureManager.bg_type )
    table.insert(preLoadUrlList, "bg/dungeon/1/dungeon_bg1.jpg")
    table.insert(preLoadUrlList, "bg/dungeon/1/dungeon_bg2.jpg")

    table.insert(preLoadUrlList, "bg/region/bg_map.jpg")
    table.insert(preLoadUrlList, "bg/region/bg_map2.jpg")
    
    -- table.insert(preLoadUrlList, "bg/battle/101/bg.pvr.ccz")  -- .. TextureManager.bg_type
    -- table.insert(preLoadUrlList, "bg/battle/102/bg" .. TextureManager.bg_type)
    -- table.insert(preLoadUrlList, "bg/battle/103/bg" .. TextureManager.bg_type)
    -- table.insert(preLoadUrlList, "bg/battle/104/bg" .. TextureManager.bg_type)

    table.insert(preLoadUrlList, "bg/map/map_bg.webp")
    table.insert(preLoadUrlList, "bg/map/map-alpha.webp")

    table.insert(preLoadUrlList, "bg/ui/Bg_teamset.pvr.ccz")
    
    
    -- for index=1, 4 do
    --     local url = string.format("bg/legion/1_%02d" .. TextureManager.bg_type, index)
    --     table.insert(preLoadUrlList, url)
    -- end
    
    
    table.insert(preLoadUrlList, "ui/component_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/titleIcon_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/otherIcon_ui_resouce_big_0" .. file_type)
    -- table.insert(preLoadUrlList, "ui/dungeonIcon_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/region_ui_resouce_big_0" .. file_type)
--    table.insert(preLoadUrlList, "ui/activity_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/itemIcon_ui_resouce_big_0" .. file_type)
    -- table.insert(preLoadUrlList, "ui/map_ui_resouce_big_0" .. file_type)      
    table.insert(preLoadUrlList, "ui/otherIcon_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/skillIcon_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/soldierIcon_ui_resouce_big_0" .. file_type)
--    table.insert(preLoadUrlList, "ui/counsellorIcon_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/barrack2Icon_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/barrackIcon_ui_resouce_big_0" .. file_type)
    --table.insert(preLoadUrlList, "ui/treasure_ui_resouce_big_0" .. file_type)
    --table.insert(preLoadUrlList, "ui/activity_ui_resouce_big_0" .. file_type)
--    table.insert(preLoadUrlList, "ui/lotteryEquip_ui_resouce_big_0" .. file_type)
    table.insert(preLoadUrlList, "ui/productIcon_ui_resouce_big_0" .. file_type)  --主城生产图标
    -- table.insert(preLoadUrlList, "ui/equip_ui_resouce_big_0" .. file_type)  --新增武将资源加载
     table.insert(preLoadUrlList, "ui/headIcon_ui_resouce_big_0" .. file_type) 

     table.insert(preLoadUrlList, "ui/building2Icon_ui_resouce_big_0" .. file_type) 
     table.insert(preLoadUrlList, "ui/buildingIcon_ui_resouce_big_0" .. file_type)
     table.insert(preLoadUrlList, "ui/heroIcon_ui_resouce_big_0" .. file_type)
     table.insert(preLoadUrlList, "ui/littleIcon_ui_resouce_big_0" .. file_type)
     
     --table.insert(preLoadUrlList, "ui/personInfoTalentIcon_ui_resouce_big_0" .. file_type) --国策兵法图标


     self.rersistResMap["ui/barrack2Icon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/building2Icon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/barrackIcon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/littleIcon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/itemIcon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/soldierIcon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/titleIcon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/otherIcon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/productIcon_ui_resouce_big_0" .. file_type] = true
     self.rersistResMap["ui/consigliereIcon_ui_resouce_big_0" .. file_type] = true


    -- table.insert(preLoadUrlList, "ui/hero_ui_resouce_big_0" .. file_type)
--     table.insert(preLoadUrlList, "ui/heroPortrait_ui_resouce_big_0" .. file_type)
--     table.insert(preLoadUrlList, "ui/heroPortrait_ui_resouce_big_1" .. file_type)
--     table.insert(preLoadUrlList, "ui/heroPortrait_ui_resouce_big_2" .. file_type)

    
    -- table.insert(preLoadUrlList, "effect/spine/xuli_blue/skeleton.pvr.ccz")
    
    -- table.insert(preLoadUrlList, "effect/spine/qiang01_hit/skeleton.pvr.ccz")
    
    -- table.insert(preLoadUrlList, "effect/spine/qiang01_atk/skeleton.png")
    -- table.insert(preLoadUrlList, "effect/spine/gong01_hit/skeleton.png")
    -- table.insert(preLoadUrlList, "effect/spine/gong01_atk/skeleton.png")

    -- table.insert(preLoadUrlList, "effect/spine/bu01_hit/skeleton.pvr.ccz")
    -- table.insert(preLoadUrlList, "effect/spine/bu01_hit/skeleton2.pvr.ccz")
    
    -- table.insert(preLoadUrlList, "effect/spine/qi01_atk/skeleton.pvr.ccz")
    -- table.insert(preLoadUrlList, "effect/spine/qi01_atk/skeleton2.pvr.ccz")


    -- local isfirstLogin = LocalDBManager:getValueForKey("firstLogin")
    -- if isfirstLogin == nil then
    --     table.insert(preLoadUrlList, "ui/task_ui_resouce_big_0" .. file_type)
    -- end

    -- local localVerion = cc.UserDefault:getInstance():getIntegerForKey(ModuleName.MapModule,-10000)
    -- if localVerion ~= -10000 then
    --     table.insert(preLoadUrlList, "ui/map_ui_resouce_big_0" .. file_type)
    --     table.insert(plistList, "ui/map_ui_resouce_big_0.plist")
    -- end
    
    maxNum = #preLoadUrlList
    -- maxNum = maxNum - table.size(GlobalConfig.ScenePreEffects) --这里重复一份了，要减掉，避免不加载plist
    
    table.insert(plistList, "ui/gui_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/guiNew_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/common_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/mainScene_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/roleInfo_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/toolbar_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/component_ui_resouce_big_0.plist")
    
    -- for k,v in pairs(GlobalConfig.ScenePreEffects) do
    --     url = "effect/frame/" .. v .. ".plist"
    --     table.insert(plistList, url)
    -- end

    table.insert(plistList, "ui/titleIcon_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/otherIcon_ui_resouce_big_0.plist")
    -- table.insert(plistList, "ui/dungeonIcon_ui_resouce_big_0.plist")
    -- table.insert(plistList, "ui/region_ui_resouce_big_0.plist")
    
--    table.insert(plistList, "ui/counsellorIcon_ui_resouce_big_0.plist")
    
    table.insert(plistList, "ui/itemIcon_ui_resouce_big_0.plist")
    -- table.insert(plistList, "ui/map_ui_resouce_big_0.plist")     
    table.insert(plistList, "ui/otherIcon_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/skillIcon_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/soldierIcon_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/barrack2Icon_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/barrackIcon_ui_resouce_big_0.plist")
    table.insert(plistList, "ui/productIcon_ui_resouce_big_0.plist")--主城生产图标

    table.insert(plistList, "ui/building2Icon_ui_resouce_big_0.plist") 
     table.insert(plistList, "ui/buildingIcon_ui_resouce_big_0.plist")
     table.insert(plistList, "ui/heroIcon_ui_resouce_big_0.plist")
     table.insert(plistList, "ui/littleIcon_ui_resouce_big_0.plist" )

--    table.insert(plistList, "ui/heroPortrait_ui_resouce_big_0.plist" )
--     table.insert(plistList, "ui/heroPortrait_ui_resouce_big_1.plist" )
--     table.insert(plistList, "ui/heroPortrait_ui_resouce_big_2.plist" )
    -- table.insert(plistList, "ui/hero_ui_resouce_big_0.plist")

    -- if isfirstLogin == nil then
    --     table.insert(plistList, "ui/task_ui_resouce_big_0.plist")
    -- end

    for _, url in pairs(preLoadUrlList) do
        cc.Director:getInstance():getTextureCache():addImageAsync(url, imageLoaded)
    end
    
--    completeCallback()
end



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------分包的功能-------
GlobalConfig.Subcontract = {}

--军团 10个模块
GlobalConfig.Subcontract[1] = {}
GlobalConfig.Subcontract[1].modules = {"LegionWelfareModule","LegionSceneModule","LegionScienceTechModule",
	"LegionApplyModule","LegionModule","LegionHallModule","LegionShopModule","LegionAdviceModule",
	"LegionCombatCenterModule","DungeonXModule"}
GlobalConfig.Subcontract[1].moduleName = "LegionModule"
GlobalConfig.Subcontract[1].finish = false

--军械 3个模块
GlobalConfig.Subcontract[2] = {}
GlobalConfig.Subcontract[2].modules = {"PartsModule","PartsWarehouseModule","PartsStrengthenModule"}
GlobalConfig.Subcontract[2].moduleName = "PartsModule"
GlobalConfig.Subcontract[2].finish = false

--军师3个模块
GlobalConfig.Subcontract[3] = {}
GlobalConfig.Subcontract[3].modules = {"ConsigliereModule","ConsigliereImgModule","ConsigliereRecruitModule"} 
GlobalConfig.Subcontract[3].moduleName = "ConsigliereModule"
GlobalConfig.Subcontract[3].finish = false

--限时活动7个活动
-- GlobalConfig.Subcontract[4] = {}
-- GlobalConfig.Subcontract[4].modules = {"PullBarActivityModule"}
-- GlobalConfig.Subcontract[4].finish = false

-- GlobalConfig.Subcontract[5] = {}
-- GlobalConfig.Subcontract[5].modules = {"ChargeShareModule"}
-- GlobalConfig.Subcontract[5].finish = false

-- GlobalConfig.Subcontract[6] = {}
-- GlobalConfig.Subcontract[6].modules = {"RedPacketModule"}
-- GlobalConfig.Subcontract[6].finish = false

-- GlobalConfig.Subcontract[7] = {}
-- GlobalConfig.Subcontract[7].modules = {"VipBoxModule"}
-- GlobalConfig.Subcontract[7].finish = false

-- GlobalConfig.Subcontract[8] = {}
-- GlobalConfig.Subcontract[8].modules = {"PartsGodModule"}
-- GlobalConfig.Subcontract[8].finish = false

-- GlobalConfig.Subcontract[9] = {}
-- GlobalConfig.Subcontract[9].modules = {"VipRebateModule"}
-- GlobalConfig.Subcontract[9].finish = false

-- GlobalConfig.Subcontract[10] = {}
-- GlobalConfig.Subcontract[10].modules = {"DayTurntableModule"}
-- GlobalConfig.Subcontract[10].finish = false

GlobalConfig.Subcontract[11] = {}  --特效
GlobalConfig.Subcontract[11].modules = {"ActivityCenterModule","ActivityModule"}
GlobalConfig.Subcontract[11].moduleName = "ActivityCenterModule"
GlobalConfig.Subcontract[11].finish = false

-- GlobalConfig.Subcontract[12] = {}  --模型
-- GlobalConfig.Subcontract[12].modules = {"MapModule"}
-- GlobalConfig.Subcontract[12].finish = false

--GlobalConfig.Subcontract[13] = {}  --装备 强化的时候加载
--GlobalConfig.Subcontract[13].modules = {"EquipModule"}
--GlobalConfig.Subcontract[13].finish = false

-- GlobalConfig.Subcontract[14] = {} 
-- GlobalConfig.Subcontract[14].modules = {"ActivityModule"}
-- GlobalConfig.Subcontract[14].finish = false

GlobalConfig.Subcontract[15] = {} 
GlobalConfig.Subcontract[15].modules = {"SettingModule"}
GlobalConfig.Subcontract[15].moduleName = "SettingModule"
GlobalConfig.Subcontract[15].finish = false


--英雄模块，只分包图鉴
GlobalConfig.Subcontract[16] = {} 
GlobalConfig.Subcontract[16].modules = {"HeroPokedexModule"}
GlobalConfig.Subcontract[16].moduleName = "HeroModule"
GlobalConfig.Subcontract[16].finish = false

--世界boss讨伐物资
GlobalConfig.Subcontract[17] = {} 
GlobalConfig.Subcontract[17].modules = {"WorldBossModule"}
GlobalConfig.Subcontract[17].moduleName = "WorldBossModule"
GlobalConfig.Subcontract[17].finish = false

--群雄逐鹿
GlobalConfig.Subcontract[18] = {} 
GlobalConfig.Subcontract[18].modules = {"WarlordsModule", "WarlordsFieldModule", "WarlordsRankModule"}
GlobalConfig.Subcontract[18].moduleName = "WarlordsModule"
GlobalConfig.Subcontract[18].finish = false

--宝具
GlobalConfig.Subcontract[19] = {} 
GlobalConfig.Subcontract[19].modules = {"HeroTreaPutModule", "HeroTreaTrainModule", "HeroTreaWarehouseModule"}
GlobalConfig.Subcontract[19].moduleName = "HeroTreaModule"
GlobalConfig.Subcontract[19].finish = false

--城主战
GlobalConfig.Subcontract[20] = {} 
GlobalConfig.Subcontract[20].modules = {"LordCityModule", "LordCityRankModule", "LordCityRecordModule"}
GlobalConfig.Subcontract[20].moduleName = "LordCityModule"
GlobalConfig.Subcontract[20].finish = false

--科举乡试
GlobalConfig.Subcontract[21] = {} 
GlobalConfig.Subcontract[21].modules = {"ProvincialExamModule", "PalaceExamModule"}
GlobalConfig.Subcontract[21].moduleName = "ProvincialExamModule"
GlobalConfig.Subcontract[21].finish = false

--科举殿试
-- GlobalConfig.Subcontract[22] = {} 
-- GlobalConfig.Subcontract[22].modules = {"PalaceExamModule"}
-- GlobalConfig.Subcontract[22].moduleName = "PalaceExamModule"
-- GlobalConfig.Subcontract[22].finish = false
-------------------------------------------------------------------------------
--场景切换协议
--message M30105{
GlobalConfig.Scene = {}
GlobalConfig.Scene[1] = 1  --世界boss
GlobalConfig.Scene[2] = 2  --群雄涿鹿

-------------------------------------------------------------------------------
-- 探宝竖屏滚屏富文本动画的参数
-- 动画分成2段：第一段渐显，第二段渐隐
GlobalConfig.RichTxt_FontSize = 24			--字体大小
GlobalConfig.RichTxt_LineDelay = 3		--每行出现的间隔时间，控制行间距
GlobalConfig.RichTxt_FadeInDelay = 1		--渐渐出现的时间
GlobalConfig.RichTxt_FadeOutDelay = 1		--渐渐消失的时间
GlobalConfig.RichTxt_MoveToDelay = 6		--每一段上升的时间
GlobalConfig.RichTxt_MoveInitY = 300        --起始高度：相对屏幕中点向下的偏移值
GlobalConfig.RichTxt_MoveDstY1 = 200		--第一段上升高度
GlobalConfig.RichTxt_MoveDstY2 = 400		--第二段上升高度
GlobalConfig.RichTxt_NameColor = "#eebf00"	--玩家名字颜色
GlobalConfig.RichTxt_InfoColor = "#ffffff"  --'获得'颜色
-------------------------------------------------------------------------------
-- 探宝横屏滚屏富文本动画的参数
GlobalConfig.RichTxt_X_FontSize = 24			--字体大小
GlobalConfig.RichTxt_X_LineDelay = 3			--每行出现的间隔时间，控制行间距
GlobalConfig.RichTxt_X_MoveToDelay = 6.5		--水平移动的时间
GlobalConfig.RichTxt_X_MoveInitY = 435        	--起始高度：相对屏幕中点向下的偏移值
GlobalConfig.RichTxt_X_NameColor = "#eebf00"	--玩家名字颜色
GlobalConfig.RichTxt_X_InfoColor = "#ffffff"  	--'获得'颜色
-- GlobalConfig.RichTxt_X_FadeInDelay = 1		--渐渐出现的时间
-- GlobalConfig.RichTxt_X_FadeOutDelay = 1		--渐渐消失的时间
-- GlobalConfig.RichTxt_X_MoveDstY1 = 200		--第一段上升高度
-- GlobalConfig.RichTxt_X_MoveDstY2 = 400		--第二段上升高度
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
GlobalConfig.dungeonTargetIconScale = 1    --通用副本地图据点建筑缩放大小
-------------------------------------------------------------------------------
GlobalConfig.littleHelperHideLV = 19    --小助手消失时主公等级
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
