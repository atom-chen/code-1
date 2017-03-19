--[文本资源，处理多语言]--
TextWords = {}

function TextWords:getTextWord(id)
    return self[id]
end

TextWords[1] = [[]]

TextWords[11] = [[你的账号在异地登陆，请重新登陆！]]
TextWords[12] = [[你已被强制踢下线！]]
TextWords[13] = "提示：主公，您当前网络不稳定，已断开，请重新连接。"
TextWords[14] = [[你的账号已被封禁，请联系工作人员！]]
TextWords[15] = [[登录异常，请重新登录]]

--出场旁白
TextWords[20] = [[公元189年 董贼之乱]]
TextWords[21] = "十八路诸侯洛阳城下一聚"
TextWords[22] = "乱局中联军得知玉玺下落"
TextWords[23] = "联军群雄各自密谋夺玺大计"
TextWords[24] = "导致袁军中计大败，且元气大伤"
TextWords[25] = "自此，关东联军退出中华历史舞台"
TextWords[26] = "一颗星光慢慢照耀出新的时代"


-------component----------
TextWords[100] = [[确定]]
TextWords[101] = [[取消]] 
TextWords[102] = [[这操作好像有点不对劲~]]
TextWords[103] = [[数量:%d]]
TextWords[104] = [[使用]]
TextWords[105] = [[购买使用]]
TextWords[106] = "提示：购买需要花费%d元宝，是否继续？"
TextWords[107] = [[经验 +%d]]
TextWords[108] = [[战斗力 %d]]
TextWords[109] = [[搜索]]
TextWords[110] = [[名称在4到12个英文之间,中文算两个英文]]
TextWords[111] = [[驻军]]
TextWords[112] = [[新手礼包]]
TextWords[113] = "提示：结束新手引导，可以获得新手大礼包。你确定要退出吗？"
TextWords[114] = [[正在热更新->%s 文件：%.2fM 进度:%2d%%]]
TextWords[115] = [[努力获取网络数据]]
TextWords[116] = [[%s]]
TextWords[117] = [[服务器正在维护中，请稍后重登！]]
TextWords[118] = [[正在努力请求服务器列表数据，稍等片刻！]]
TextWords[119] = [[服务器将于%s开服，敬请期待!]]
TextWords[120] = [[成功购买%s]]
TextWords[121] = [[驻]]
TextWords[122] = [[系统信息]]
TextWords[123] = [[战斗]]
TextWords[124] = [[挑战]]
TextWords[125] = [[扫荡]]
TextWords[126] = [[当前没有伤兵！]]
TextWords[127] = [[未上阵]]
TextWords[128] = [[材料不足]]
TextWords[129] = [[3星通关后可扫荡]]
TextWords[130] = "提示：是否退出引导？"
TextWords[131] = [[获得物品]]

---登录-----
TextWords[201] = [[登录异常，请重新登录]]
TextWords[202] = [[请输入账号名:]]
TextWords[203] = [[请输入2-6个字]]
TextWords[204] = [[请输入角色名称]]
TextWords[205] = [[输入角色名称非法，请重新输入！]]

TextWords[206] = [[激活成功，请进入游戏！]]
TextWords[207] = [[请输入激活码]]
TextWords[208] = [[激活]]
TextWords[209] = [[请输入激活码]]

TextWords[211] = [[不存在的激活码或者该激活已经被使用了！]]
TextWords[212] = [[您已不需要激活码了]]

TextWords[219] = [[名字长度限制2~5个字或英文]]
TextWords[220] = [[正在校验激活信息，请稍等]]
TextWords[221] = [[正在激活中，请稍等]]

TextWords[281] = [[火爆]]
TextWords[282] = [[新服]]
TextWords[283] = [[维护中]]
TextWords[284] = [[即将开启]]

--toolbar
TextWords[301] = [[大营]]
TextWords[302] = [[世界]]
TextWords[303] = [[返回]]
TextWords[304] = [[提升VIP等级，才可以购买更多的建造位]]
-- TextWords[305] = [[请先在基地中建造对应的建筑]]
TextWords[305] = [[请先建造太学院]]
TextWords[306] = [[(%d,%d)]]
TextWords[307] = "提示：你要花费%d银币对该地区进行侦查吗？"
TextWords[308] = [[未知]]
TextWords[309] = "提示：你确定使用88元宝迁徙基地到(%d,%d)吗？"
TextWords[310] = "提示：你确定使用[%s]迁徙基地到(%d,%d)吗？"
TextWords[311] = [[繁荣：]]
TextWords[312] = [[/%d]]
TextWords[313] = [[坐标 (%d,%d)]]
TextWords[314] = [[侦查]]
TextWords[315] = [[世界尽头]]
TextWords[316] = [[%d里]]
TextWords[317] = [[请先建造工匠坊]]
TextWords[318] = [[%d级%s]]
TextWords[319] = [[%s]]
TextWords[350] = [[是否花费15元宝购买5个讨伐令]]
TextWords[351] = [[黄巾贼藏匿起来了，倒计时结束后才能讨伐]]
TextWords[356] = [[请先建造该类型建筑！]]
TextWords[357] = [[招兵失败，招兵队列达到上限]]
TextWords[358] = [[训练失败，训练队列达到上限]]
TextWords[359] = [[升级失败，科技研究队列达到上限]]
TextWords[360] = [[制造失败，生产队列达到上限]]

TextWords[390] = [[未任命]]
TextWords[391] = [[可任命]]
--title--
TextWords[320] = [[目标信息]]
TextWords[321] = [[物品使用]]
TextWords[322] = [[玩家信息]]
TextWords[323] = [[敌军来袭]]
TextWords[324] = [[碎片查看]]
TextWords[325] = [[军械查看]]
TextWords[326] = [[分解预览]]
TextWords[327] = [[加速生产]]
TextWords[328] = [[征召士兵]]
TextWords[329] = [[选择服务器]]
TextWords[330] = [[军]]
TextWords[331] = [[批量分解]]
TextWords[332] = [[建造加速]]
TextWords[333] = [[训练加速]]
TextWords[334] = [[科研加速]]
TextWords[335] = [[选择部队]]
TextWords[336] = [[训练士兵]]
TextWords[337] = [[元宝不足]]
TextWords[338] = [[奖励一览]]
TextWords[339] = [[选择联系人]]
TextWords[340] = [[每日登陆奖励]]

------背包-----  
TextWords[400] = [[背包]]
TextWords[495] = [[数量:%d]]
TextWords[496] = [[描述:]]
TextWords[497] = [[道具名:]]
TextWords[498] = [[数量:]]
TextWords[499] = [[所有]]
TextWords[500] = [[资源]]
TextWords[501] = [[增益]]
TextWords[502] = [[其他]]
TextWords[5033] = "提示：是否消耗1个黄巾信物开启黄巾宝藏?"
TextWords[5044] = "提示：是否消耗50元宝顶替黄巾信物开启黄巾宝藏?"
TextWords[5045] = "提示：是否消耗1个新春物件来开启新春大红包?"
TextWords[5046] = "提示：是否消耗50元宝顶替新春物件开启新春大红包?"
TextWords[5047] = "提示：当前处于[%s]状态,你确定要覆盖使用吗?"
TextWords[5048] = "提示：你确定要随机迁移主城吗?"
TextWords[5049] = [[批量使用]]
TextWords[5050] = [[使用%s成功]]
TextWords[5051] = [[该道具不能直接使用]]
TextWords[5052] = [[请输入新的同盟名称]]

-----个人信息--
TextWords[503] = [[详细]]
TextWords[504] = [[战法]]
TextWords[505] = [[建造]]
TextWords[506] = [[个人信息]]
TextWords[507] = [[是否花费%d元宝购买5个军令?]]
TextWords[508] = [[%d元宝]]
TextWords[509] = [[每天可领取%d声望值！]]
TextWords[510] = [[封赏]]
TextWords[511] = [[带兵量:]]
TextWords[512] = [[当前繁荣：]]
TextWords[513] = [[繁荣 Lv.%d]]
TextWords[514] = [[声望 Lv.%d]]
TextWords[515] = [[统率 Lv.%d]]
TextWords[516] = [[每天可封赏1次，封赏可以获得声望值]]
TextWords[517] = [[当前拥有%d个战法秘籍]]
TextWords[518] = [[已封赏]]
TextWords[519] = [[购买使用]]
TextWords[520] = [[费用:%d元宝]]
TextWords[521] = [[建造位有空闲时，自动升级建筑，持续%d个小时]]
TextWords[522] = [[自动升级]]
TextWords[523] = [[花费:%d]]
TextWords[524] = [[银币]]
TextWords[525] = [[元宝]]
TextWords[526] = [[VIP%d]]
TextWords[527] = [[战力]]
TextWords[528] = [[元宝]]
TextWords[529] = [[Lv.%d]]
TextWords[530] = [[是否花费%d元宝提升繁荣度?]]
TextWords[531] = [[统率令不足，是否花费%d元宝进行统率升级?]]
TextWords[532] = [[统率等级不可超过主公等级！]]
TextWords[533] = [[统率升级成功率太低！]]
TextWords[534] = [[当前繁荣度已满]]
TextWords[535] = [[(当前拥有:%d)]]
TextWords[536] = "提示：是否花费%d元宝重置战法?\n(重置后战法等级置0,返还全部战法秘籍)"
TextWords[537] = [[升级官职成功]]
TextWords[538] = [[修复成功]]
TextWords[539] = [[封赏成功]]
TextWords[540] = [[统率等级+1,带兵数量+%d]]
TextWords[541] = [[购买成功]]
TextWords[542] = [[%s战法等级+1]]
TextWords[543] = [[操作成功]]
TextWords[544] = [[%s加速完成,总花费%d元宝]]
TextWords[545] = "提示：购买需要花费%d元宝，是否继续？"
TextWords[546] = "提示：战法秘籍不足,是否花费%d元宝补足战法秘籍升级战法?"
TextWords[547] = [[升级官职所需的银币不足]]
TextWords[548] = [[升级官职需主公达到%d等级]]
TextWords[549] = [[你已是最高官职]]
TextWords[550] = [[高级统率可增加带兵量，消耗统率令能提升统率等级]]
TextWords[551] = [[你已达到最高统率等级]]
TextWords[552] = [[你已达到最高声望等级]]
TextWords[553] = [[声望已达最高级]]
TextWords[554] = [[提升VIP等级，开放购买更多建筑位]]
TextWords[555] = [[购买成功，获得4H自动]]
TextWords[556] = [[(已开启)]]
TextWords[557] = [[(已关闭)]]
TextWords[558] = [[(当前拥有:]]
TextWords[559] = [[)]]
TextWords[560] = "提示：需要花费%d元宝，确定继续吗？"
TextWords[561] = [[封赏成功，获得%d声望]]
TextWords[562] = [[购买军令次数上限，请提升VIP等级]]
TextWords[563] = [[仓库已经满，请前往邮件领取]]
TextWords[564] = [[购买讨伐令次数上限，请提升VIP等级]]
TextWords[565] = [[是否花费%d元宝购买5个讨伐令?]]
TextWords[566] = [[读取配置数据失败]]
TextWords[567] = [[是否花费%道具已足无需购买]]
TextWords[568] = [[金币不足]]
TextWords[569] = [[角色等级未达到探宝开放要求等级]]


--国策
TextWords[570] = [[国策]]
TextWords[571] = "是否花费500元宝重置所有天赋（返回所有升级消耗）"
TextWords[572] = "1.大天赋每层只能选择激活一个\n2.小天赋每层只能选择激活两个\n3.需要满足前置条件才能解锁天赋\n4.部分天赋需要要激活两个前置天赋才能解锁\n5.重置会返回所有消耗的战法秘籍" --%s 插入上限说明
TextWords[573] = [[等级]]
TextWords[574] = [[解锁条件]]
TextWords[575] = [[升级消耗]]
TextWords[576] = [[条件%d：]] 

TextWords[579] = ">>" --升级符号
TextWords[580] = [[升级]]
TextWords[581] = [[已满级]]
TextWords[582] = [[未解锁]]

TextWords[590] = "该排技能已达到上限"
TextWords[591] = "可用升级点不足"
TextWords[592] = [[称号]]

-- TextWords[55555] = [[&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;]]
TextWords[50000] = [[当前官职　]]
TextWords[50001] = [[官职俸禄　]]
TextWords[50002] = [[<br/>下阶官职　]]
TextWords[50003] = [[下阶俸禄　]]
TextWords[50004] = [[<br/>升级需求　]]
TextWords[50005] = [[主公等级达到%d级]]
TextWords[50006] = [[　　　　　银币%d]]
TextWords[50007] = [[当前已是最高官职等级！]]
TextWords[50008] = [[提升统率等级可以增加带兵量]]
TextWords[50009] = [[下一等级　]]
TextWords[50010] = [[　成功率　]]
TextWords[50011] = [[<br/>升级需求　]]
TextWords[50012] = [[%d]]
TextWords[50013] = [[　　　　　带兵量+%d]]
TextWords[50014] = [[%d%%]]
TextWords[50015] = [[主公%d级]]
TextWords[50016] = [[　　　　　统率令x1(当前拥有%d)]]
TextWords[50017] = [[当前已是最高统率等级！]]
TextWords[50018] = [[声望等级越高，可提升的太学院科技等级越高]]
TextWords[50019] = [[获取声望值途径]]
TextWords[50020] = [[1.每天首次登录赠送(官职等级越高，赠送越多)]]
TextWords[50021] = [[2.完成主线任务]]
TextWords[50022] = [[3.封赏(每天1次,可获得大量声望值)]]
TextWords[50023] = [[当前等级　]]
TextWords[5002300] = [[<br/>当前等级　]]
TextWords[50024] = [[<br/>繁荣等级作用]]
TextWords[50025] = [[<br/>等级提升方法]]
TextWords[50026] = [[<br/>繁荣等级玩法]]
TextWords[50027] = [[繁荣%d级　繁荣要求（%d）]]
TextWords[50028] = [[　　　　　编制经验获得+%d%%]]
-- TextWords[50029] = [[增加带兵量（9级以上加成编制经验获得）]]
TextWords[50029] = [[增加带兵量]]
TextWords[50030] = [[升级建筑增加繁荣度,提升繁荣等级]]
TextWords[50031] = [[1.攻击他人基地取得胜利,能降低对方<br/>   繁荣度(VIP等级越高,扣除繁荣度越多)]]
-- TextWords[50032] = [[2.繁荣度变低会导致繁荣等级下降,<br/>   影响带兵和编制经验获得]]
TextWords[50032] = [[2.繁荣度变低会导致繁荣等级下降,<br/>   影响带兵]]
TextWords[50033] = [[3.基地变为废墟时,还会引发大惩罚：<br/>   资源减产,恢复速度变慢等]]
TextWords[50034] = [[<br/>当繁荣度低于繁荣上限时]]
TextWords[50035] = [[1.每分钟恢复1点繁荣度]]
TextWords[50036] = [[2.攻击他人可恢复繁荣度(繁荣等级越高,恢复越快)]]
TextWords[50037] = [[3.使用少量元宝恢复满繁荣]]
TextWords[50038] = [[<br/>下一等级　]]
TextWords[50039] = [[当前已是最高声望等级！]]

TextWords[50040] = [[　　　　　带兵量]]
TextWords[50041] = [[+%d]]
TextWords[50042] = [[繁荣]]
TextWords[50043] = [[级　繁荣要求(]]
TextWords[50044] = [[)]]
TextWords[50045] = [[　　　　　编制经验获得]]
TextWords[50046] = [[+%d&#37;]]

TextWords[50047] = [[<br/>繁荣状态　]]
TextWords[50048] = [[正常]]
TextWords[50049] = [[废墟]]
TextWords[50050] = [[　　　　　繁荣加成失败]]
TextWords[50051] = [[　　　　　所有资源基础产量减少100&#37;]]
TextWords[50052] = [[　　　　　繁荣度恢复速度减缓]]
TextWords[50053] = [[　　　　　攻击他人获得繁荣度减少]]
TextWords[50054] = [[　　繁荣　]]
TextWords[50055] = [[/%d]]
TextWords[50056] = [[(%s)]]
TextWords[50057] = [[繁荣　]]
TextWords[50058] = [[<br/>繁荣]]
TextWords[50059] = [[<br/>]]

TextWords[50060] = [[官职加成　]]
TextWords[50061] = [[战功宝箱获取经验增加%d&#37;！]]
TextWords[50062] = [[下阶加成　]]
TextWords[50063] = "每日凌晨0点重置"


TextWords[50100] = [[%s　Lv.%d]]
TextWords[50101] = [[<br/><br/>当前已是最高战法等级！<br/><br/>]]
TextWords[50102] = [[<br/>升级需求　]]
TextWords[50103] = [[主公%d级]]
TextWords[50104] = [[战法秘籍*%d(可从日常任务获得)]]


------关卡-----
TextWords[600] = [[战役]]
TextWords[601] = [[历练]]
TextWords[602] = [[限时]]
TextWords[603] = [[关卡]]
TextWords[604] = [[通过[]]
TextWords[605] = [[]开启]]
TextWords[606] = [[(战力:]]
TextWords[607] = [[)]]
TextWords[608] = [[主公等级达到]]
TextWords[609] = [[级开放]]
TextWords[610] = "提示:攻打该章节需主公官职提升至"
TextWords[611] = [[，是否前往提升官职等级]]
TextWords[612] = [[通过第一章后解锁！]]
TextWords[613] = [[主公%d级解锁]]
TextWords[614] = [[次数:%d/%d]]
TextWords[615] = [[进度:第%d关]]
TextWords[616] = [[官邸%d级开启民心系统]]

-----部队和装备---------
TextWords[700] = [[设置部队]]
TextWords[701] = [[执行任务]]
TextWords[702] = [[治疗伤兵]]
TextWords[703] = [[设置阵型]]
TextWords[704] = [[部队]]
TextWords[705] = [[防守本城]]
TextWords[706] = [[超过了士兵出战的上线!]]
TextWords[707] = [[你确认要花费]]
TextWords[708] = [[银币吗?]]
TextWords[709] = [[元宝吗?]]
TextWords[710] = [[没有士兵可以选择了]]
TextWords[711] = [[部队将领]]
TextWords[712] = [[将领府邸]]
TextWords[713] = [[+0%]]

TextWords[714] = [[仓库已经空了！]]
TextWords[732] = [[攻击]]
TextWords[733] = [[生命]]
TextWords[724] = [[命中]]
TextWords[726] = [[暴击]]
TextWords[731] = [[血量]]
TextWords[725] = [[闪避]]
TextWords[727] = [[抗暴]]
TextWords[740] = [[第]]
TextWords[741] = [[号武将穿戴中]]
TextWords[742] = [[请选择要出售的装备卡]]
TextWords[743] = [[装备升级]]
TextWords[744] = [[请选择要吞噬的装备卡]]
TextWords[745] = [[你确定要花费50个元宝增加20个容量吗?]]
TextWords[746] = [[官职等级不够]]
TextWords[747] = [[当前阵型尚无出战士兵，请点击最大战力进行设置部队]]
TextWords[748] = [[军令数为0,无法出战!]]
TextWords[749] = [[无法继续扫荡了!]]
TextWords[750] = [[10次扫荡结束,请拉动查看所得物品!]]
TextWords[751] = [[继续扫荡]]
TextWords[752] = [[停止扫荡]]
TextWords[753] = [[可出战的士兵数量为0!]]
TextWords[754] = [[升级成功]]
TextWords[755] = [[治疗伤兵成功]]
TextWords[756] = [[未拥有]]
TextWords[757] = [[套用阵型]]
TextWords[758] = [[挑战记录]]
TextWords[759] = [[连胜次数：%d]]
TextWords[760] = [[保存阵型]]
TextWords[770] = [[驻军]]
TextWords[771] = [[最大负重]]
TextWords[772] = [[主公26级开启军师上阵功能！]]

TextWords[761] = [[骑兵]]
TextWords[762] = [[步兵]]
TextWords[763] = [[枪兵]]
TextWords[764] = [[弓兵]]

TextWords[7001] = [[血量]]
TextWords[7003] = [[攻击]]
TextWords[7004] = [[命中]]
TextWords[7005] = [[闪避]]
TextWords[7006] = [[暴击]]
TextWords[7007] = [[抗暴]]
TextWords[7008] = [[穿刺]]
TextWords[7009] = [[防护]]

TextWords[7021] = [[负重]]
TextWords[7022] = [[ 即将来袭]]
TextWords[7023] = [[我方基地]]
TextWords[7024] = [[攻击目标:]]

TextWords[7042] = [[战力　　　]]
TextWords[7043] = [[先手值　　]]
TextWords[7044] = [[部队数　　]]
TextWords[7045] = [[负重　　　]]

TextWords[7046] = [[行军目标　]]
TextWords[7047] = [[行军时间　]]
TextWords[7048] = [[带兵数量　]]
TextWords[7049] = [[部队负重　]]
TextWords[7050] = [[出发]]
TextWords[7051] = [[返回]]
TextWords[7052] = [[采集中]]
TextWords[7053] = [[驻防中]]
TextWords[7054] = [[等待归队]]
TextWords[7055] = [[你确定要花费]]
TextWords[7056] = [[元宝]]
TextWords[7057] = [[级]]
TextWords[7058] = [[扫荡结果]]
TextWords[7059] = [[停止扫荡]]
TextWords[7060] = [[扫荡]]
TextWords[7061] = [[军令数量不足，已停止扫荡]]
TextWords[7062] = [[银币储备过少, 已停止扫荡]]
TextWords[7063] = [[上次战斗损失佣兵过多, 已停止扫荡]]
TextWords[7064] = [[挑战次数不足, 已停止扫荡]]
TextWords[7065] = [[第]]
TextWords[7066] = [[次扫荡]]
TextWords[7067] = [[采集未满确认要返回?]]
TextWords[7068] = [[元宝加速吗?]]
TextWords[7069] = "提示：你确定要花费%d元宝治疗全体伤兵吗？"
TextWords[7070] = "提示：你确定要花费%d元宝治疗伤兵吗？"
TextWords[7071] = "确定要返回驻军部队吗？"
TextWords[7072] = "目前仍有伤兵,无法扫荡!"
TextWords[7073] = "已达到出战队伍数量上限"
TextWords[7074] = "提示：当前没有保存任何阵型，是否现在去设置阵型？"
TextWords[7075] = "目前仍有伤兵,无法扫荡,是否前往治疗!"
TextWords[7076] = [[上次扫荡战斗挑战失败已停止扫荡，请设置强力部队]]

TextWords[7080] = "领军"
TextWords[7081] = "护军"
TextWords[7082] = "中军"
TextWords[7083] = "右军"
TextWords[7084] = "游军"
TextWords[7085] = "左军"
TextWords[7086] = "蜀国之力"
TextWords[7087] = "魏国之力"
TextWords[7088] = "吴国之力"
TextWords[7089] = ":同时上阵"
TextWords[7090] = "无"
TextWords[7091] = "级开锁"
TextWords[7092] = "号阵"
TextWords[7093] = "第"
TextWords[7094] = "部队目前没有装备穿戴"
TextWords[7095] = "提示：您要吞噬的装备中含有紫色品质的装备，是否确认消耗进行升级？"
--民心
TextWords[70101] = "领取消耗%s%s(官职越高奖励越丰厚)"
TextWords[70102] = "民心不足！"
TextWords[70103] = "民心"
TextWords[70104] = "免费刷新%d次"
TextWords[70105] = "消耗%d元宝"
TextWords[70106] = "提示：你确定要花费%d元宝吗？"

TextWords[70107] = ""
TextWords[70108] = "1.首次三星通关奖励一点民心"
TextWords[70109] = "2.每通关一章战役，民心上限值增加1"
TextWords[70110] = "3.免费刷新5次后，每次刷新需要的元\n宝数量都会递增，最高单次20元宝"
TextWords[70111] = "4.每晚0点民心值、刷新免费次数恢复到上限"


------建筑相关---------
TextWords[800] = [[兵营(Lv.%d)]]
TextWords[801] = [[建造]]
TextWords[802] = [[招兵]]
TextWords[803] = [[招兵中]]
TextWords[8004] = [[招]]
TextWords[8005] = [[制造]]
TextWords[8009] = [[兵营达到%d级]]
TextWords[80010] = [[兵营达到%d级]]
TextWords[80011] = [[需要工匠坊达到%d级]]
TextWords[80009] = [[兵营%d级]]
TextWords[800010] = [[兵营%d级]]
TextWords[800011] = [[工匠坊%d级]]
TextWords[805] = [[主公%d级]]
TextWords[806] = [[数量：%d]]
TextWords[807] = [[当前数量：%d]]
TextWords[808] = "提示：取消只返回部分资源.你确定取消吗？"
TextWords[809] = "提示：你确定要拆除该建筑吗？"
TextWords[811] = "提示：加速会消耗%d元宝，是否确定？"
TextWords[810] = [[升级]]
TextWords[812] = [[官邸]]
TextWords[813] = [[可训练数：%d]]
TextWords[814] = [[%s建造完毕]]
TextWords[815] = [[%s升到%d级]]
TextWords[816] = [[购买使用]]
TextWords[817] = [[使用]]
TextWords[818] = "提示：你确定花费%d元宝替代资源升级建筑吗？"
TextWords[819] = [[元宝升级]]
TextWords[820] = [[空地]]
TextWords[821] = [[该功能暂未开启，敬请期待！]]
TextWords[822] = [[操作失败！]]
TextWords[823] = "提示：官邸等级不足，是否前往升级官邸？"
TextWords[824] = [[当前数量：]]
TextWords[825] = [[可训练数：]]

TextWords[830] = [[官邸达到%d级才可以使用该建筑]]
TextWords[831] = [[主公等级达到%d级才开启%s玩法]]
TextWords[832] = [[主公等级达到%d级方可加入同盟]]

TextWords[891] = [[建造]]
TextWords[892] = [[招兵]]
TextWords[893] = [[招兵中]]
TextWords[8111] = [[建造]]
TextWords[8112] = [[制造]]
TextWords[8113] = [[制造中]]
TextWords[8101] = [[建造]]
TextWords[8102] = [[训练]]
TextWords[8103] = [[训练中]]
TextWords[8104] = [[科技]]
TextWords[8105] = [[道具制造]]

TextWords[8201] = [[军械]]
TextWords[8202] = [[碎片]]
TextWords[8203] = [[材料]]
TextWords[8204] = [[仓库]]
TextWords[8205] = [[军械强度: ]]
TextWords[8206] = [[强化等级: ]]
TextWords[8207] = [[改造等级: ]]
TextWords[8208] = [[成功几率: ]]
TextWords[8209] = [[  +  %.1f%%(VIP加成)]]
TextWords[8211] = [[血量加成:]]
TextWords[8212] = [[攻击加成:]]
TextWords[8213] = [[防护加成:]]
TextWords[8214] = [[穿刺加成:]] 
TextWords[8215] = [[银币不足！]]
TextWords[8216] = [[强化溶液不足！]]
TextWords[8217] = [[成功率已达100%，不需再添加强化溶液！]]
TextWords[8218] = [[改造材料不足！]]
TextWords[8219] = [[改造图纸不足！]]
TextWords[8220] = [[适用兵种:]]
TextWords[8221] = [[军械碎片合成成功！]]
TextWords[8222] = [[军械碎片分解成功！]]
TextWords[8223] = [[军械装备成功！]]
TextWords[8224] = [[军械卸下成功！]]
TextWords[8225] = [[军械分解成功！]]
TextWords[8226] = [[军械强化成功！]]
TextWords[8227] = [[军械改造成功！]]
TextWords[8228] = [[军械进阶成功！]]
TextWords[8229] = [[只有紫色军械改造等级4以上才可以进阶!]]
TextWords[8230] = [[强化等级已满]]
TextWords[8231] = [[改造等级已满]]
TextWords[8232] = [[未拥有该品质军械，请前往获取]]

TextWords[8301] = [[强化]]
TextWords[8302] = [[改造]]
TextWords[8303] = [[进阶]]
TextWords[8304] = "提示：是否花费%d元宝购买建筑位?"
TextWords[8305] = [[可购买次数已用完,不能购买建筑位]]
TextWords[8306] = [[VIP等级不够,不能再购买]]
TextWords[8307] = [[元宝不足]]
TextWords[8308] = "提示：取消只返回部分资源.你确定取消吗？"
TextWords[8309] = [[等待生产]]
TextWords[8310] = [[需要太学院达到%d级开放]]
TextWords[8311] = [[太学院]]

TextWords[8401] = [[元宝加速]]
TextWords[8402] = [[免费加速]]
TextWords[8403] = [[加速]]
TextWords[8404] = [[免费]]
TextWords[8405] = [[求助]]
TextWords[8406] = [[已向全体同盟成员求助！]]
TextWords[8407] = [[成功帮助全体同盟成员！]]
TextWords[8408] = [[帮助成功]]
TextWords[8409] = [[%s帮助你加速建造%s]]

TextWords[8500] = [[道具数量为0，无法进行使用]]
TextWords[8501] = [[当前处于免费加速状态，不需要使用加速道具]]

TextWords[8602] = [[铸币所：]]
TextWords[8603] = [[伐木场：]]
TextWords[8604] = [[铁矿场：]]
TextWords[8605] = [[采石场：]]
TextWords[8606] = [[农田：]]
TextWords[8607] = [[(已建造：%d个)]]

----------聊天----------------
TextWords[900] = [[聊天]]
TextWords[901] = [[最多输入40字]]
TextWords[902] = [[世界]]
TextWords[903] = [[<font face="fn24" color = "#e6ffe0">%s</font>]] --一般聊天内容
TextWords[904] = [[头像设置]]
TextWords[905] = [[输入想私聊的玩家进行私聊]]
TextWords[906] = [[不可重复发送消息！]]
TextWords[907] = [[同盟聊天]]
TextWords[908] = [[菜鸟指导员]]
TextWords[909] = [[指导员达人]]
TextWords[910] = [[新手导师]]
TextWords[911] = [[长期指导员]]
TextWords[912] = [[GM]]
TextWords[913] = [[聊天屏蔽列表]]
TextWords[914] = [[发言间隔5秒钟,请耐心等待]]
TextWords[915] = [[请先加入同盟]]
TextWords[916] = [[屏蔽列表]]
TextWords[917] = [[举报]]
TextWords[918] = [[点击这里输入原因，最大40个字]]
TextWords[919] = [[请输入举报说明]]
TextWords[920] = [[请勾选举报证据]]
TextWords[921] = [[举报成功！]]
TextWords[922] = [[该玩家5分钟内，无发言记录]]
TextWords[923] = "1)系统不会以任何形式透露举报人信息；\n2)举报属实，给予首名举报人奖励；\n3)根据情节轻重，给予被举报人相应惩罚。"
TextWords[924] = [[私聊]]
TextWords[925] = [[主公达到%d级才能发送聊天哦！]]

-- 仓库储备
TextWords[1000] = [[仓库]]
TextWords[1001] = [[当前可保护每种资源]]
TextWords[1002] = [[%s/小时]]
TextWords[1003] = [[容量:]]
TextWords[1004] = "[完全保护]"
TextWords[1005] = "[可被掠夺]"
TextWords[1006] = "[爆仓停产]"
TextWords[1007] = [[仓库储备]]
TextWords[1008] = [[物品使用]]
TextWords[1009] = [[数量:%d]]
TextWords[1010] = [[不被掠夺]]
TextWords[1011] = [[使用成功]]
TextWords[1012] = [[购买使用成功]]


TextWords[100000] = [[%s产量：%s/小时]]
TextWords[100001] = [[(产量显示已包括所有效果加成)<br/>]]
TextWords[100002] = [[%s：基础产量+%d&#37;　%s]]
TextWords[100003] = [[%s开采：基础产量+%d&#37;　%s]]
TextWords[100004] = [[废墟惩罚：加成产量-50&#37; %s]]


--好友
TextWords[1100] = [[社交]]
TextWords[1101] = [[好友列表]]
TextWords[1102] = [[好友祝福]]
TextWords[1103] = [[收藏列表]]
TextWords[1104] = [[请输入角色名]]
TextWords[1105] = [[加好友]]
TextWords[1106] = [[已好友]]
TextWords[1107] = [[祝福]]
TextWords[1108] = [[已祝福]]
TextWords[1109] = [[删好友]]
TextWords[1110] = [[好友数量：%d/%d]]
TextWords[1111] = [[领取]]
TextWords[1112] = [[已领取]]
TextWords[1113] = [[好友军令：%d/%d]]
TextWords[1114] = "提示：你确定要删除收藏%s吗?"
TextWords[1115] = [[%s成为新好友]]
TextWords[1116] = [[好友%s已被移除]]
TextWords[1117] = [[祝福好友成功]]
TextWords[1118] = [[领取成功]]

--邮箱
TextWords[1200] = [[邮箱]]
TextWords[1201] = [[邮箱已经是空的了]]
TextWords[1202] = [[累计获取]]
TextWords[1203] = [[姓名不能为空]]
TextWords[1204] = [[内容不能为空]]
TextWords[1205] = [[你确定要清空所有邮件?]]
TextWords[1206] = [[联系人不能为空!]]
TextWords[1207] = [[您有]]
TextWords[1208] = [[封新来的邮件哦!]]
TextWords[1209] = [[战斗]]
TextWords[1210] = [[侦察]]
TextWords[1211] = [[报告]]
TextWords[1212] = [[邮件报告有误]]
TextWords[1213] = [[防守胜利]]
TextWords[1214] = [[防守失败]]
TextWords[1215] = [[进攻胜利]]
TextWords[1216] = [[进攻失败]]
TextWords[1217] = [[战力 %s]]
TextWords[1218] = [[领取附件]]
TextWords[1219] = [[邮件]]
TextWords[1220] = [[发送]]
TextWords[1221] = [[报告]]
TextWords[1222] = [[系统]]
TextWords[1223] = [[附件还未领取,确认要删除吗?]]
TextWords[1224] = "[先手]"
TextWords[1225] = [[零损兵获胜]]
TextWords[1226] = [[攻方无战斗获胜]]
TextWords[1227] = [[无防守部队]]
TextWords[1228] = [[发件人]]
TextWords[1229] = [[收件人]]
TextWords[1230] = [[（未领取）]]
TextWords[1231] = [[（已领取）]]
TextWords[1232] = [[主题字数不能多于8个字]]
TextWords[1233] = [[最多输入8个字]]
TextWords[1234] = [[已侦查]]
TextWords[1235] = [[进攻]]
TextWords[1236] = [[的主城]]
TextWords[1237] = [[的攻击]]
TextWords[1238] = [[主公达到%d级才能发送邮件哦！]]
TextWords[1239] = [[邮件收藏成功]]
TextWords[1240] = [[的]]
TextWords[1241] = [[进攻结果:]]
TextWords[1242] = [[我攻打了]]
TextWords[1243] = [[占领的]]
TextWords[1244] = [[防守结果:]]
TextWords[1245] = [[遭到了]]
TextWords[1246] = [[先手]]
TextWords[1247] = [[后手]]
TextWords[1248] = [[已达到收藏邮件数量上限]]
TextWords[1249] = [[采集成功]]
TextWords[1250] = [[从]]
TextWords[1251] = [[采集回来]]
TextWords[1252] = [[我查看了]]
TextWords[1253] = [[据点驻军:]]
TextWords[1254] = [[侦察时间:]]
TextWords[1255] = [[我的部队从]]
TextWords[1256] = [[采集回来]]
TextWords[1257] = [[采集资源:]]
TextWords[1258] = [[可掠夺:]]
TextWords[1259] = [[标题不能为空]]
TextWords[1260] = [[邮件发送成功]]

--任务
TextWords[1300] = [[任务]]
TextWords[1301] = [[主线任务]]
TextWords[1302] = [[日常任务]]
TextWords[1303] = [[日常活跃]]
TextWords[13031] = [[战功]]
TextWords[1304] = [[基地建设]]
TextWords[1305] = [[角色任务]]
TextWords[1306] = [[资源产量]]
TextWords[1307] = [[前往]]
TextWords[1308] = [[接受]]
TextWords[1309] = [[放弃]]
TextWords[1310] = [[刷新]]
TextWords[1311] = [[未达成]]
TextWords[1312] = [[快速完成]]
TextWords[1313] = [[活跃度]]
TextWords[1314] = [[达成可领取活跃奖励]]
TextWords[1315] = [[ 进度：%d/%d]]
TextWords[1316] = [[日常任务(%d/5)]]
TextWords[1317] = [[有几率刷出5星任务]]
TextWords[1318] = [[领取奖励]]
TextWords[1319] = [[%d级开放]]
TextWords[1320] = [[重置]]
TextWords[1321] = "提示：是否花费%d元宝刷新日常任务？"
TextWords[1322] = "提示：你确定花费%d元宝增加5次任务机会吗？"
TextWords[1323] = [[达成]]
TextWords[1324] = [[ 奖励]]
TextWords[1325] = [[奖励预览]]
TextWords[1326] = [[活跃度达到%d点]]
TextWords[1327] = [[进度：%d/%d]]
TextWords[1328] = [[ 进度：%s]]
TextWords[1329] = [[未完成]]
TextWords[1330] = [[已完成]]
TextWords[1331] = "提示：是否花费%d元宝快速完成任务？"
TextWords[1332] = [[活跃+%d]]
TextWords[1333] = [[(%d/%d)]]
TextWords[1334] = [[/%d)]]
TextWords[1335] = [[已领取]]
TextWords[1336] = [[前往模块不存在,无法前往]]
TextWords[1337] = [[进度: ]]
TextWords[1338] = "您已完成当前的主线任务：%s，\n是否去领取奖励？"

-----设置------
TextWords[1400] = [[设置]]
TextWords[1401] = [[游戏设置]]
TextWords[1402] = [[头像设置]]
TextWords[1403] = [[安全设置]]
TextWords[1404] = [[切换账号]]
TextWords[1405] = [[联系客服]]
TextWords[1406] = "[已开启]"
TextWords[1407] = "[已关闭]"
TextWords[1408] = [[游戏性]]
TextWords[1409] = [[通知]]
TextWords[1410] = [[开启]]
TextWords[1411] = [[关闭]]
TextWords[1412] = [[背景音乐]]
TextWords[1413] = [[按键音效]]
TextWords[1414] = [[自动补充防御部队]]
TextWords[1415] = [[消费二次确认]]
TextWords[1416] = [[显示建筑名称]]
TextWords[1417] = "活动开启[副本/盟战]"
TextWords[1418] = [[建筑升级完成]]
TextWords[1419] = "生产完成[科技/坦克]"
TextWords[1420] = [[军令满通知]]
TextWords[1421] = [[系统头像]]
TextWords[1422] = [[头像挂件]]
TextWords[1423] = [[普通头像]]
TextWords[1424] = "VIP专用头像[VIP5以上]"
TextWords[1425] = [[普通挂件]]
TextWords[1426] = "VIP专用挂件[VIP5以上]"
TextWords[1427] = [[确定]]
TextWords[1428] = [[设置成功]]
TextWords[1429] = [[请选择一个挂饰]]
TextWords[1430] = [[头像]]
TextWords[1431] = [[挂饰]]
TextWords[1432] = [[链接地址为空！]]
TextWords[1433] = [[未获得头像]]
TextWords[1434] = [[未获得挂件]]
TextWords[1435] = [[你获得了活动头像，快去设置里看看吧！]]
TextWords[1436] = [[你获得了活动挂件，快去设置里看看吧！]]

-----充值------
TextWords[1500] = [[充值]]
TextWords[1501] = [[再充%d元宝,即可升级到]]
TextWords[1502] = [[同时享受]]
TextWords[1503] = [[至]]
TextWords[1504] = [[的所有特权]]
TextWords[1505] = [[VIP特权]]
TextWords[1506] = [[%d元]]
TextWords[1507] = [[已达到VIP最高等级]]
TextWords[1508] = [[首冲获赠双倍元宝]]
TextWords[1509] = [[还赠送价值]]
TextWords[1510] = [[首 冲 礼 包]]
TextWords[1511] = [[3888]]
TextWords[1512] = [[首冲礼包]]
TextWords[1513] = [[双倍元宝]]
TextWords[1514] = [[再充]]
TextWords[1515] = [[元宝,即可升级到]]
TextWords[1516] = [[VIP%d]]
TextWords[1517] = [[首冲获赠双倍元宝,还赠送价值3888元的首冲礼包]]

-----商城-------
TextWords[1600] = [[商城]]
TextWords[1601] = [[资源]]
TextWords[1602] = [[增益]]
TextWords[1603] = [[成长]]
TextWords[1604] = [[特殊]]
TextWords[1605] = [[购买]]
TextWords[1606] = [[批量购买]]
TextWords[1607] = [[荣誉]]
TextWords[1608] = [[道具]]

------战斗力-------
TextWords[1700] = [[战斗力]]
TextWords[1701] = [[未上榜]]
TextWords[1702] = [[主公达%d级开放]]
TextWords[1703] = [[最强制造兵:]]
TextWords[1704] = [[,还差]]
TextWords[1705] = [[个]]

------招募和探宝---
TextWords[1800] = [[招募]]
TextWords[1801] = [[次抽必出紫装]]
TextWords[1802] = [[第1]]
TextWords[1803] = [[再抽]]
TextWords[1804] = [[普通]]
TextWords[1805] = [[高级]]
TextWords[1806] = [[挑战]]
TextWords[1807] = [[设置阵型]]
TextWords[1808] = [[排名奖励]]
TextWords[1809] = [[积分兑换]]
TextWords[1810] = [[战斗]]
TextWords[1811] = [[资源]]
TextWords[1812] = [[成长]]
TextWords[1813] = [[竞技场战报]]
TextWords[1814] = [[个人]]
TextWords[1815] = [[全服]]
TextWords[1816] = [[活动]]
TextWords[1817] = "提示：你确定要花费%d元宝吗？"
TextWords[1818] = "免费点"
TextWords[1819] = "次"
TextWords[1820] = "免费次数"
TextWords[1821] = "点1次"
TextWords[1822] = "再抽"
TextWords[1823] = "次必得紫装"
TextWords[1824] = "剩余免费次数"
-- TextWords[1825] = [[当前拥有0探宝币]]
TextWords[1826] = [[点一次]]
TextWords[1827] = [[当前拥有]]
-- TextWords[1828] = [[探宝币]]
-- TextWords[1829] = [[使用%d枚探宝币即可探宝1次]]
TextWords[1830] = [[后免费]]
TextWords[1831] = [[今日免费抽取已达上限]]
TextWords[1832] = [[抽取]]
TextWords[1833] = [[十连抽]]
TextWords[1834] = [[常规]]
TextWords[1835] = [[活动中心]]

-- 武将探宝
TextWords[1836] = "主公，你正在对宝箱进行第%d次探宝，需要消耗%d个战宝币或%d元宝，确定进行探宝吗？"
TextWords[1837] = [[请继续探宝(%d/%d)]]
TextWords[1838] = [[%d秒后结束]]
TextWords[1839] = [[请点击宝箱进行探宝]]
TextWords[1840] = [[结束探宝]]
TextWords[1841] = [[开宝箱]]
TextWords[1842] = [[开始抽取]]
TextWords[1843] = [[刷新宝箱]]
TextWords[1844] = [[第一次探宝免费]]
TextWords[1845] = [[剩余%d次]]
TextWords[1846] = [[打开宝箱消耗%d个战宝币或%d元宝]]
TextWords[1847] = "还有%d秒结束探宝，是否确定放弃本次探宝并退出？"
TextWords[1848] = [[已经达到抽取次数上限]]
TextWords[1849] = [[第一次开宝箱免费]]
TextWords[1850] = [[当前拥有奇宝币:]]
TextWords[1851] = [[当前拥有神宝币:]]
TextWords[1852] = [[当前拥有战宝币:]]
TextWords[1853] = [[每次抽奖消耗%d个奇宝币或%d个元宝（优先使用奇宝币）]]
TextWords[1854] = [[每次抽奖消耗%d个神宝币或%d个元宝（优先使用神宝币）]]
TextWords[1857] = [[使用%d枚奇宝币即可探宝1次]]
TextWords[1858] = [[使用%d枚神宝币即可探宝1次]]
TextWords[1861] = [[奇宝币]]
TextWords[1862] = [[神宝币]]
TextWords[1863] = [[战宝币]]
TextWords[1864] = [[奇兵]]
TextWords[1865] = [[神兵]]
TextWords[1866] = [[战将]]
TextWords[1867] = [[主公20级开放战将探宝]]
TextWords[1868] = "还有%d秒结束探宝，是否保存本次探宝并退出？"
TextWords[1869] = [[是]]
TextWords[1870] = [[否]]
TextWords[1871] = [[请点宝箱，进行点兵开宝]]
TextWords[1872] = [[点击屏幕返回]]



------排行榜---
TextWords[1900] = [[排行榜]]
TextWords[1901] = [[战力榜]]
TextWords[1902] = [[编制榜]]
TextWords[1903] = [[关卡榜]]
TextWords[1904] = [[战绩榜]]
TextWords[1905] = [[攻击强化]]
TextWords[1906] = [[暴击强化]]
TextWords[1907] = [[闪避强化]]
TextWords[1908] = [[演武场]]
TextWords[1909] = [[成就榜]]
-- TextWords[1910] = [[%s排行榜]]
TextWords[1911] = [[我的排名]]
TextWords[1912] = [[未上榜]]
TextWords[1913] = [[排名]]
TextWords[1914] = [[玩家名称]]
TextWords[1915] = [[等级]]
TextWords[1916] = [[战斗力]]
TextWords[1917] = [[编制称号]]
TextWords[1918] = [[编制等级]]
TextWords[1919] = [[星数]]
TextWords[1920] = [[战绩]]
TextWords[1921] = [[装备等级]]
TextWords[1922] = [[攻击加成]]
TextWords[1923] = [[暴击加成]]
TextWords[1924] = [[闪避加成]]
TextWords[1925] = [[阵型战力]]
TextWords[1926] = [[成就点]]
TextWords[1927] = [[显示后20个]]

TextWords[1928] = [[战力排行榜]]
TextWords[1929] = [[编制排行榜]]
TextWords[1930] = [[关卡排行榜]]
TextWords[1931] = [[战绩排行榜]]
TextWords[1932] = [[攻击强化排行榜]]
TextWords[1933] = [[暴击强化排行榜]]
TextWords[1934] = [[闪避强化排行榜]]
TextWords[1935] = [[竞技场排行榜]]
TextWords[1936] = [[成就排行榜]]
TextWords[1937] = [[击杀数量]]


TextWords[1949] = [[征矿榜]]
TextWords[1951] = [[战力榜]]
TextWords[1952] = [[编制榜]]
TextWords[1953] = [[关卡榜]]
TextWords[1954] = [[战绩榜]]
TextWords[1955] = [[攻击强化]]
TextWords[1956] = [[暴击强化]]
TextWords[1957] = [[闪避强化]]
TextWords[1958] = [[演武场]]
TextWords[1959] = [[成就榜]]
TextWords[1962] = [[平乱榜]]

------增益---
TextWords[2000] = [[增益信息]]

--开服礼包
TextWords[2100] = [[开服礼包]]
TextWords[2101] = [[登陆第%d天]]


-----同盟相关-----------
TextWords[3000] = [[同盟列表]]
TextWords[3001] = [[创建同盟]]

TextWords[3002] = [[同盟等级3级开放]]
TextWords[3003] = [[同盟等级6级开放]]
TextWords[3004] = [[同盟等级9级开放]]
TextWords[3005] = [[设置自定义职位成功！]]
TextWords[3006] = [[互助，有爱，团结，友善！]]
TextWords[3007] = [[欢迎加入我们！]]
TextWords[3008] = [[未编辑]]
TextWords[3009] = [[该职位未编辑，请重新选择！]]
TextWords[3010] = [[拒绝成功]]
TextWords[3011] = [[没有任何请求，不能进行该操作]]
TextWords[3012] = [[有新成员加入同盟]]
TextWords[3013] = [[升职成功]]
TextWords[3014] = [[任命职位成功]]
TextWords[3015] = [[该角色不在线]]
TextWords[3016] = [[同盟全体成员]]
TextWords[3017] = [[转让盟主成功]]
TextWords[3018] = [[当前同盟只有你一个人，不能发送同盟邮件]]
TextWords[3019] = [[职位编辑]]
TextWords[3020] = [[编辑]]
TextWords[3021] = [[同盟]]
TextWords[3022] = [[成员查看]]
TextWords[3023] = [[审批]]
TextWords[3024] = [[为同盟的荣耀而战！]]
TextWords[3025] = [[搜索敌人并发起攻击]]
TextWords[3026] = [[管理你的主城]]
TextWords[3027] = [[建筑已升到最高级]]
TextWords[3028] = [[主公等级达到12级才开启同盟大厅玩法]]
TextWords[3029] = [[福利所%d~%d级奖励]]
TextWords[3030] = [[物品分配]]
TextWords[3031] = [[请先选择玩家]]
TextWords[3032] = [[道具数量不足，请重新选择]]
TextWords[3033] = [[分配成功]]
TextWords[3034] = [[只有盟主可以分配战事福利]]
TextWords[3035] = [[同盟推荐]]
TextWords[3036] = [[大厅]]
TextWords[3037] = [[成员]]
TextWords[3038] = [[同盟列表]]

TextWords[3101] = [[同盟信息]]
TextWords[3102] = [[同盟成员]]
TextWords[3103] = [[贡献排名]]
TextWords[3104] = [[同盟列表]]
TextWords[3105] = [[点击输入职位名称]]
TextWords[3106] = [[(在线)]]
TextWords[3107] = [[(离线)]]
TextWords[3108] = [[无]]
TextWords[3109] = [[等级:%d]]
TextWords[3110] = [[战斗力:%s]]
TextWords[3111] = [[申请即可加入]]
TextWords[3112] = [[申请后需审批通过]]
TextWords[3113] = [[设定职位]]
TextWords[3114] = [[升职]]
TextWords[3115] = [[您是盟主，不能再升职了！]]
TextWords[3116] = "提示：你确定要退出同盟吗？"
TextWords[3117] = "提示：你确定把盟主转让给%s吗？"
TextWords[3118] = "提示：你确定把%s踢出同盟吗？"
TextWords[3119] = [[更改同盟信息成功]]
TextWords[3120] = "提示：你确定要花费%d元宝创建同盟吗？"

TextWords[3121] = [[等级:]]
TextWords[3122] = [[战斗力:]]
TextWords[3123] = [[无]]
TextWords[3124] = [[申请]]
TextWords[3125] = [[取消申请]]
TextWords[3126] = [[同盟排名:%d]]
TextWords[3127] = [[提示：你确定要解散同盟吗？]]
TextWords[3128] = [[提示：只有同盟人数不超过5人时，才可解散同盟!]]
TextWords[3129] = [[无同盟]]
TextWords[3130] = [[解散同盟]]
TextWords[3131] = [[退出同盟]]
TextWords[3132] = [[(申请中)]]


TextWords[3135] = [[普通]]
TextWords[3136] = [[副盟主]]
TextWords[3137] = [[盟主]]

TextWords[3140] = [[请输入同盟名]]
TextWords[3141] = [[请输入同盟名]]
TextWords[3142] = [[请输入要搜索的同盟]]
TextWords[3143] = [[请选择加入条件]]
TextWords[3144] = [[请选择创建方式]]
TextWords[3145] = [[加入%s需要等级>=%d级]]
TextWords[3146] = [[加入%s需要战力>=%s]]
TextWords[3147] = [[加入%s需要等级>=%d级、战力>=%s]]
TextWords[3148] = [[申请加入同盟成功，请等待审批...]]
TextWords[3149] = [[加入同盟成功！]]
TextWords[3150] = [[取消申请成功！]]
TextWords[3151] = [[创建成功！]]
TextWords[3152] = [[搜索同盟成功！]]
TextWords[3153] = [[搜索的同盟不存在！]]
TextWords[3154] = [[请输入新的同盟名称]]
TextWords[3155] = [[申请加入]]
TextWords[3156] = [[同盟名字长度限制2~5个字或英文]]
TextWords[3157] = [[你已经加入了%s同盟]]
-----同盟科技-----------
TextWords[3200] = [[Lv.%d]]
TextWords[3201] = [[(未解锁)]]
TextWords[3202] = [[科技所Lv.%d级解锁]]
TextWords[3203] = [[科技所]]
TextWords[3204] = [[<br/>升级需求]]
TextWords[3205] = [[科技所Lv.%d]]
TextWords[3206] = [[升级经验%d]]
TextWords[3207] = [[科技捐献]]
TextWords[3208] = [[操作失败，资源不足]]
TextWords[3209] = [[同盟大厅]]
TextWords[3210] = [[该科技的等级已经达到上限，不能再升级了！]]
TextWords[3211] = "提示：确定提升科技所等级?"
TextWords[3212] = "提示：确定提升同盟大厅等级?"
TextWords[3213] = "提示：确定要捐献%d元宝吗?"
TextWords[3214] = [[　Lv.%d]]
TextWords[3215] = [[科技已升到最高级]]
TextWords[3216] = [[捐献成功，贡献+%d，%s经验+%d]]
TextWords[3217] = [[捐献成功，贡献+%d，建设度+%d]]

------同盟商店-------------
TextWords[3300] = [[同盟商店]]
TextWords[3301] = [[物品]]
TextWords[3302] = [[珍品]]
TextWords[3303] = [[贡献]]
TextWords[3304] = [[我的贡献]]
TextWords[3305] = [[兑换成功]]
TextWords[3306] = [[同盟等级%d开放]]
-- TextWords[3307] = [[级开放]]
TextWords[3308] = [[普通兑换:%d级开放]]
TextWords[3309] = [[普通兑换次数0点重置]]
TextWords[3310] = [[每天可兑换次数为括号内次数]]
TextWords[3311] = [[ ]]
TextWords[3312] = [[珍品兑换:]]
TextWords[3313] = [[每天0点、12点、18点、刷新物品]]
TextWords[3314] = [[每次刷新后同盟玩家可兑换一次]]
TextWords[3315] = [[同盟所有玩家兑换次数为括号内次数]]

-------福利所---------
TextWords[3400] = [[福利所]]
TextWords[3401] = [[日常福利]]
TextWords[3402] = [[战事福利]]
TextWords[3403] = [[同盟活跃]]
TextWords[3404] = "提示：确定提升福利所等级?"
TextWords[3405] = [[Lv.%d福利]]
TextWords[3406] = [[采集资源]]
TextWords[3407] = [[领取资源]]
TextWords[3408] = [[需福利所Lv.%d级（消耗个人贡献%d点）]]
TextWords[3409] = [[个人活跃每日0点重置]]
TextWords[3410] = [[盟主]]
TextWords[3411] = [[副盟主]]
TextWords[3412] = [[普通战士]]
TextWords[3413] = [[福利所等级提升！]]
TextWords[3414] = [[领取成功!]]
TextWords[3415] = [[活跃排行]]
TextWords[3416] = [[领取福利]]
TextWords[3417] = [[已领取]]

-------情报所-----------
TextWords[3500] = [[军情]]
TextWords[3501] = [[民情]]
TextWords[3502] = [[荣耀]]
TextWords[3503] = [[情报所]]
TextWords[3504] = [[遭到]]
TextWords[3505] = [[防守胜利]]
TextWords[3506] = [[被抢夺了]]
TextWords[3507] = [[消灭了试炼中心的:]]
TextWords[3508] = [[盟主从战事福利中分配了物品:]]
TextWords[3509] = [[给]]
TextWords[3510] = [[以资鼓励]]
TextWords[3511] = [[加入了同盟]]
TextWords[3512] = [[离开了同盟,另谋发展]]
TextWords[3513] = [[被]]
TextWords[3514] = [[踢出了同盟]]
TextWords[3515] = [[卸任盟主]]
TextWords[3516] = [[成为新的盟主]]
TextWords[3517] = [[被任命为]]
TextWords[3518] = [[分配了]]

-------同盟作战所---------
TextWords[3600] = [[试炼场]]
TextWords[3601] = [[未击杀据点　]]
TextWords[3602] = [[可领取奖励　]]
TextWords[3603] = "通关%s\n后开启"
TextWords[3604] = [[同盟攻击次数]]
TextWords[3605] = [[每天0点重置试炼次数]]
TextWords[3606] = [[功能未开启]]

-------同盟试炼场副本---------
TextWords[3700] = [[同盟试炼场]]
TextWords[3701] = [[挑战次数　]]
TextWords[3702] = [[领取成功]]
TextWords[3703] = "提示：领取此奖励需要消耗%d点贡献，确定要领取么？"
TextWords[3704] = [[此关卡的奖励已领取]]
TextWords[3705] = [[你的贡献不足，领取失败]]


-------宝具---------
TextWords[3800] = [[进阶]]
TextWords[3801] = [[洗炼]]
TextWords[3802] = [[穿戴]]
TextWords[3803] = [[宝具]]
TextWords[3804] = [[宝具培养]]
TextWords[3805] = [[仓库]]
TextWords[3806] = [[碎片]]
TextWords[3807] = [[未选择或未拥有该品质对应的宝具]]
TextWords[3808] = [[未选择或未拥有该品质对应的宝具碎片]]
TextWords[3809] = [[暂无宝具]]
TextWords[3810] = [[暂无宝具碎片]]
TextWords[3811] = [[该宝具未触发过隐藏属性]]
TextWords[3812] = [[未选择将恢复的状态]]
TextWords[3813] = [[洗炼中，请稍后~]]
TextWords[3814] = [[恢复]]
TextWords[3815] = [[该宝具没有洗练属性]]
TextWords[3816] = [[材料]]
TextWords[3817] = [[卸下成功]]
TextWords[3818] = [[穿戴成功]]
TextWords[3819] = [[恢复成功！]]
TextWords[3820] = [[分解成功！]]
TextWords[3821] = [[合成成功！]]
TextWords[3822] = [[(进阶加成)]]
TextWords[3823] = [[进阶中，请稍后~]]

TextWords[3824] = [[主公5级开放活动功能]]



-------极限探险---------
TextWords[4000] = [[第%d关奖励]]
TextWords[4001] = [[未上榜]]
TextWords[4002] = [[正在扫荡中，无法挑战关卡]]
TextWords[4003] = "提示:是否确认停止扫荡? \n(至少完成一个关卡扫荡才会有奖励获得)"
TextWords[4004] = "提示:是否从第%d关扫荡到第%d关？"
TextWords[4005] = "提示:是否消耗5个军令.从第一关开始挑战?"
TextWords[4006] = [[第%d关 %s]]
TextWords[4007] = [[扫荡]]
TextWords[4008] = [[停止扫荡]]
TextWords[4009] = [[当前没有可扫荡的关卡]]
TextWords[4099] = [[开始扫荡第%d关]]
TextWords[4100] = [[探险记事]]
TextWords[4101] = [[扫荡奖励]]
TextWords[4102] = [[(战力：%s)]]
TextWords[4103] = [[无　Lv.0]]
TextWords[4104] = [[2001-01-01 00:00]]

-- 极限探险tip内容
TextWords[40000] = [[玩法说明<br/>]]
TextWords[40001] = [[1. 每个关卡可挑战3次]]
TextWords[40002] = [[挑战次数为0后，需要重置方可挑战]]
TextWords[40003] = [[重置副本会消耗少量军令]]
TextWords[40004] = [[每天有1次重置机会，重置后可进行扫荡或挑战副本<br/>]]
TextWords[40005] = [[2. 每一关有特定的通关条件]]
TextWords[40006] = [[挑战达到通关条件后，方可获得奖励<br/>]]
TextWords[40007] = [[3. 可扫荡已通关的关卡]]
TextWords[40008] = [[每一关有固定的扫荡时间]]
TextWords[40009] = [[手动停止扫荡可立即获得扫荡奖励]]
TextWords[40010] = [[扫荡自动完成后，通过邮件发放奖励]]
TextWords[40011] = [[]]


--特殊道具使用

TextWords[4010] = [[请输入新的主公名称]]
TextWords[4011] = [[请输入主公的名称]]
TextWords[4012] = [[请输入收红包人的名称]]
TextWords[4013] = [[请输入你要发的内容（最多40个字）]]
TextWords[4014] = [[发送公告]]
TextWords[4015] = [[你还没有选择哦]]
TextWords[4016] = [[该玩家没有矿点]]
TextWords[4017] = [[您输入的主公名称有误]]
TextWords[4018] = [[对方处于免战状态,不可侦查或攻击]]
TextWords[4019] = "提示:攻击玩家会失去免战状态,是否攻击"
TextWords[40201] = [[请输入内容]]

--驻军
TextWords[4020] = [[阵型不能为空]]
TextWords[4021] = "提示:是否确认驻军"
TextWords[4022] = [[军令不足,不能驻军]]
TextWords[4023] = [[驻防中]]
TextWords[4024] = [[待]]
TextWords[4025] = [[请先加入同盟]]
TextWords[4026] = [[使用成功]]
TextWords[4027] = [[到达时间:]]
TextWords[4028] = [[取消同盟驻军防守成功]]
TextWords[4029] = [[设置同盟驻军防守成功]]
TextWords[4030] = [[待命中]]
TextWords[4031] = [[部队到达后才能查看部队详情]]
TextWords[4032] = [[不能赠送给自己]]
TextWords[4033] = [[正在路上]]
TextWords[4034] = [[是否确定召回部队]]
TextWords[4035] = [[空闲队列]]
TextWords[4036] = [[返]]

--军械tip
TextWords[11000] = [[<br/>1.军械可通过军械争夺历练关卡获得]]
TextWords[11001] = [[<br/>2.军械能够增加兵种属性：攻击、血量、穿刺和防护；]]
TextWords[11002] = [[　　穿刺：增加己方部队伤害结果]]
TextWords[11003] = [[　　防护：减少地方部队伤害结果]]
TextWords[11004] = [[<br/>3.军械可进行强化，提升军械属性数值]]
TextWords[11005] = [[<br/>4.军械可进行改造，极大提升军械属性数值]]
TextWords[11006] = [[　　改造材料可通过军械争夺历练关卡获得]]
TextWords[11007] = [[<br/>5.蓝紫色军械需要通过碎片合成获得]]
TextWords[11008] = [[<br/>6.橙色军械需通过紫色军械进阶获得]]
TextWords[11009] = [[<br/>7.无用的军械碎片可进行分解，分解获得改造材料<br/>]]

--军械进阶tip
TextWords[12000] = [[<br/>1.改造等级≥4级的紫色军械可以进阶为橙色军械]]
TextWords[12001] = [[<br/>2.进阶需消耗一定数量的万能碎片和对应兵种的晶石]]
TextWords[12002] = [[<br/>3.进阶之后的紫色军械将被消耗，强化等级及改造等<br/>　级均不保留，但会返还部分银币和全部改造材料]]

--活动
TextWords[18000] = [[已领取]]
TextWords[18001] = [[领取奖励]]
TextWords[18002] = [[前往]]
TextWords[18003] = [[不可领取]]
TextWords[18004] = [[不可领取]]
TextWords[18005] = [[立即购买]]
TextWords[18006] = [[当前排名：]]
TextWords[18007] = [[活动排名：]]
TextWords[18008] = [[请输入获取到的兑换码]]
TextWords[18009] = [[官方Q群：513530313]]


--标题
TextWords[18101] = [[guandi]]
TextWords[18102] = [[zhubisuo]]  
TextWords[18103] = [[famuchang]]  
TextWords[18104] = [[tiekuangchang]]  
TextWords[18105] = [[caishifang]]
TextWords[18106] = [[nongtian]]  
TextWords[18107] = [[cangku]]  

TextWords[18108] = [[%s,你今天登陆游戏获得%d声望]]

TextWords[18109] = [[小提示：成为VIP专享特权Buff大幅度缩减科研时间]] 
TextWords[18110] = [[小提示：成为VIP专享特权Buff大幅度缩减征召时间]]  --太学院，兵营，校场
TextWords[18111] = [[小提示：成为VIP专享特权Buff大幅度缩减训练时间]]
TextWords[18112] = [[小提示：成为VIP专享特权Buff大幅度缩减建造时间]]


TextWords[18113] = [[挑战他人可获得积分和装备升级材料]]
TextWords[18114] = [[积分可在演武场商店兑换奖励]]
TextWords[18115] = [[战斗规则：]]
TextWords[18116] = [[1.战斗不损兵]]
TextWords[18117] = [[2.先手值高的先手;先手值一致，攻方先手]]
TextWords[18118] = [[3.出战阵形为设置界面的阵形]]
TextWords[18119] = [[4.连胜次数越高，胜利可获得更多奖励]]
TextWords[18120] = [[5.次数为0可购买挑战次数，VIP等级越高，]]
TextWords[18121] = [[可购买的次数越多]]

--演武场
TextWords[19000] = [[无]]
TextWords[19001] = [[请设置阵型]]
TextWords[19002] = [[未上榜]]
TextWords[19003] = [[你确定花费]]
TextWords[19004] = [[元宝购买1次挑战次数吗?]]
TextWords[19005] = [[元宝消除挑战冷却时间吗?]]
TextWords[19006] = [[阵型不能为空]]
TextWords[19007] = [[已领取]]
TextWords[19008] = [[领取奖励]]

--演武场邮件
TextWords[200000] = "胜利"
TextWords[200001] = "失败"
TextWords[200002] = "挑战"
TextWords[200003] = "进攻胜利"
TextWords[200004] = "进攻失败"
TextWords[200005] = "我们的部队 挑战 "
TextWords[200006] = "我们的部队遭到 "
TextWords[200007] = " 的挑战"
TextWords[200008] = "防守失败"
TextWords[200009] = "防守胜利"
TextWords[200010] = "(先手)"
TextWords[200011] = "零损兵获胜"
TextWords[200012] = "攻方无战斗获胜"
TextWords[200013] = "无防守部队"
TextWords[200014] = "你确定要清空个人战报吗?"
TextWords[200015] = "我 挑战 "
TextWords[200016] = " 挑战 我 "
TextWords[200017] = "发件人:"
TextWords[200018] = "收件人:"

--副本
TextWords[200100] = "通关副本并获得3颗星才可以使用扫荡功能"
TextWords[200101] = "VIP1才可以使用扫荡功能,马上充值提升VIP等级"
TextWords[200102] = "充值"
TextWords[200103] = "军令"
TextWords[200104] = "次数"
TextWords[200105] = "是否花费"
TextWords[200106] = "元宝增加挑战次数(5次)"
TextWords[200107] = "继续挑战下一章节吧"
TextWords[200108] = [[副本奖励]]

--VIP特权宝箱
TextWords[230114] = "提示：当日此类宝箱购买次数为0,请换它类或提升VIP等级"
TextWords[230115] = "提示：是否花费%d元宝购买？"

--VIP总动员
TextWords[230121] = "  每日充值"
TextWords[230122] = "1. 每日充值奖励，每日每个档次可领取一次。"
TextWords[230123] = "2. 每日充值累计额度将于每日凌晨0点重置"
TextWords[230124] = " "
TextWords[230125] = "  累计充值"
TextWords[230126] = "1.累计充值奖励每人只能领取一次"
TextWords[230127] = "您今日充值了"
TextWords[230128] = "您累计充值了"

--vip特供
TextWords[230140] = "您当前VIP等级小于3级，奖励没有2倍效果，是否按1倍效果领取"
TextWords[230141] = "还不能领取"
TextWords[230142] = "您已经领取"
TextWords[230143] = [[已领取]]
TextWords[230144] = [[可领取]]
TextWords[230145] = "登录第%d天可领取"  --number 第N天

--皇帝的封赏
TextWords[230201] = "充值达到条件后，即可领取相应奖励"
TextWords[230202] = "点击礼盒可选择一种奖励，每个奖励只可领取一次"
TextWords[230203] = "活动每日0时重置，请及时领取您的奖励！"

--天降奇兵
TextWords[230301] = "1.征召可获取兵符和道具"
TextWords[230302] = "2.消耗一定数量兵符可以获得高阶兵种"
TextWords[230303] = "3.每天一次免费抽取次数"
TextWords[230304] = "4.活动结束后，兵符数量清零"


------------------------------------------------------------------------------
-- 金鸡砸蛋
TextWords[230401] = "1.活动期间内，"
TextWords[230402] = "2.每天最多可获取99次，次日重置"
TextWords[230403] = "3.每天最多可砸蛋99次，次日重置"
TextWords[230404] = "今日砸蛋次数上限不足"
TextWords[230405] = "没有足够的砸蛋次数，消费后可获得次数！"
TextWords[230406] = "是否一键砸开剩余的蛋"
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- 集福
TextWords[230451] = "1.收集道具可进行集福"
TextWords[230452] = "2.集福后获得珍稀宝箱放置在背包内"
TextWords[230453] = "3.宝箱可开出活动挂件头像（仅此一次获得）"
TextWords[230454] = "道具数量不足，请收集集福所需要的道具数量"
TextWords[230455] = "是否集福？"--todo
------------------------------------------------------------------------------

--有福同享
TextWords[249992] = "活动已经结束"
TextWords[249993] = "后消失"
TextWords[249994] = "领"
-- TextWords[249995] = "活动时间内充值，所在同盟中全部\n玩家均可领取一份礼物，好战友有\n福同享！"
TextWords[249995] = "活动时间内充值，所在同盟中全部玩家均可领取一份礼物，好战友有福同享！"
TextWords[249996] = "活动时间:"
TextWords[249997] = "活动说明"
TextWords[249998] = "领奖礼箱"
TextWords[249999] = "规则说明"
TextWords[250000] = "1. 使用不同档次进行充值，获得奖励内容不同。\n个人奖励直接发放到背包，充值额度不可累积。"
TextWords[250001] = "2. 礼包将发送至各自的领奖礼箱中，请抓紧\n在24小时内进行领取。"
TextWords[250002] = "3. 不在同盟中，将无法分享礼包给他人，也无法获得\n别人的礼包，请抓紧时间加入同盟一起和战友们分享吧！"
TextWords[250003] = "礼包"
TextWords[250004] = "分享人"
TextWords[250005] = "剩余时间"

TextWords[250006] = "提示：是否花费%d元宝抽%d次？"
TextWords[250007] = "主公等级未满18,不能进入军械"

TextWords[250008] = "1. 神速征召每日免费1次,\n每日凌晨0点重置免费次数。"
TextWords[250009] = "\n2. 同样的图标越多奖励越好,\n即使图标都不一样也会有奖励哦！\n奖励详情见奖励一览。"
TextWords[250010] = "\n3. 勾选10倍下注后即可使用9折的价格,\n获得10倍的收益，超值到无以复加。"
TextWords[250011] = "玩家记录"
TextWords[250012] = "获得%d银票"
TextWords[250013] = "银票"
TextWords[250014] = "购买了礼包分享红包一份，大家快来抢啊！"
TextWords[250015] = "1.活动期间，玩家可消耗银票和元宝购买礼包；\n2.购买礼包后，将会在聊天频道中分享装有银票的红\n包；\n3.每次购买礼包最多使用礼包价格的90%银票；\n4.活动开启时，玩家初始将获得1500银票；\n5.活动结束后，未使用的银票将直接被清除。"
TextWords[250016] = "活动期间，可使用元宝和银票购买礼包；\n礼包中的红包可分享到聊天频道中，让其他\n人抢夺红包，打开红包可获得银票"
TextWords[250017] = "拥有银票"
TextWords[250018] = "可用银票"
TextWords[250019] = "打造"
TextWords[250020] = "排行"
TextWords[250021] = "提示：进行这项操作需要%d个元宝，你现在拥有%d个元宝，还需要购买%d个元宝，是否购买？"
TextWords[250022] = "红包已经被人抢光了！"
TextWords[250023] = "礼包原价"
TextWords[250024] = "拥有银票"
TextWords[250025] = "购买价格"
TextWords[250026] = "活动时间："
TextWords[250027] = [[第%d名奖励]]
TextWords[250028] = [[第%d名-%d名奖励]]
TextWords[250029] = [[私聊]]

--军师府
-- TextWords[270000] = "全部"
-- TextWords[270001] = "一星"
-- TextWords[270002] = "二星"
-- TextWords[270003] = "三星"
-- TextWords[270004] = "四-五星"
-- TextWords[270005] = "将领图鉴"
-- TextWords[270006] = "军师求贤"
-- TextWords[270007] = "军师分解"
-- TextWords[270008] = "军师进阶"
TextWords[270009] = "主公等级达到24级开放军师府"
TextWords[270010] = "升星"
TextWords[270011] = "分解"
TextWords[270012] = "分享"
TextWords[270013] = "升星所需材料不足"
TextWords[270014] = "闪避"
TextWords[270015] = "升星所需材料"
TextWords[270016] = "拥有:"
TextWords[270017] = "出战:"
TextWords[270018] = "军师属性"
TextWords[270019] = "批量分解"
TextWords[270022] = "四星"
TextWords[270023] = "请选择要分解的军师品质"
TextWords[270024] = "军师分解"
-- TextWords[270025] = "分解后获得以下材料"
TextWords[270026] = "分解成功"
TextWords[270027] = "元宝升星"
-- TextWords[270028] = "升级"
-- TextWords[270029] = "返回"
TextWords[270030] = "是否确定花费%d元宝替代如下材料？"
TextWords[270031] = "  军师进阶说明\n\n  1. 6个军师可进阶为1个高一星的军师\n  2. 军师进阶需消耗进阶石，军师星级越高，需要的\n  进阶石越多\n  3. 进阶石获取途径：同盟商店兑换，商场购买"
TextWords[270032] = "进阶后随机获得一名%s品质军师"
TextWords[270033] = "自动选将"
TextWords[270034] = "一键进阶"
TextWords[270035] = "五星"
TextWords[270036] = "出战军师不可进行分解！"
TextWords[270037] = "出战军师不可进行升星！"
TextWords[270038] = "该军师不可以升星！"
TextWords[270039] = "紫色品质及以上的军师才能升星"
TextWords[270040] = "该军师已经满星！"
TextWords[270041] = "升星成功"
TextWords[270042] = "进阶所需军师数量不足！！"
TextWords[270043] = "位置不足或军师数量不足！"
TextWords[270044] = "当前没有该星数可以进阶的军师！"
TextWords[270045] = "进阶成功"
TextWords[270046] = "当前只有%d个位置可供选择"
TextWords[270047] = "没有能分解的军师"
TextWords[270048] = "进阶"
TextWords[270049] = "进阶获得"
TextWords[270050] = "求贤%d次"
TextWords[270051] = "是否花费%d元宝求贤%d次军师"
TextWords[270052] = "是否花费%d资源求贤%d次军师"
TextWords[270053] = "提示：\n\n进阶需要%d个进阶石，还差%d个，\n是否花费%d金币代替直接进阶？"
TextWords[270054] = "批量选将"
TextWords[270055] = [[内政]]
TextWords[270056] = [[军师]]
TextWords[270057] = [[求贤]]
TextWords[270058] = "%s级解锁"
TextWords[270059] = [[更换]]
TextWords[270060] = [[卸任]]
TextWords[270061] = [[任命]]
TextWords[270062] = [[任命成功]]
TextWords[270063] = [[卸任成功]]
TextWords[270064] = [[内政详情]]
TextWords[270065] = [[您没有足够的军师]]
TextWords[270066] = [[目前可以进阶后可获得%d个%s品质军师，是否消耗 [%s] 进行一键进阶]]  --%d个数    %s 阶数    %s 物品*数量 
TextWords[270067] = [[绿]]
TextWords[270068] = [[蓝]]
TextWords[270069] = [[紫]]
TextWords[270070] = [[橙]]
TextWords[270071] = [[当前品质没有可进阶的军师]]
TextWords[270072] = [[选择军师]]
TextWords[270073] = [[获得军师]]
TextWords[270074] = ""
-- TextWords[270075] = "1. 可花费银币或元宝进行求贤\n\n2. 求贤消耗随次数递增，每日0点重置\n\n3. 最高可获得蓝色品质军师（元宝求贤概率更高）"
TextWords[270076] = "空闲军师才可进行升星操作"
TextWords[270077] = "军师求贤需要花费%d元宝，确定吗"
TextWords[270078] = "军师求贤需要花费%d银币，确定吗"
TextWords[270079] = "空闲军师才可进行分解操作"
TextWords[270080] = "无空闲的军师，去求贤试试吧"

TextWords[270081] = { "1.可花费银币或元宝进行求贤", "2.求贤消耗随次数递增，每日0点重置", "3.每日有一次免费求贤的机会", "4.最高可获得蓝色品质军师（元宝求贤概率更高）" }
TextWords[270082] = "最多选六个"



--军师招募
TextWords[280000] = "十连抽"
TextWords[280001] = "抽奖次数"
TextWords[280002] = "今日累计消费"
TextWords[280003] = "1.积分大于%d且等级大于%d才能进入排行榜；\n2.排行榜最多显示%d名玩家；\n3.活动结束后，排行榜奖励都会通过邮件发送."
TextWords[280004] = "1.每日免费抽奖1次，VIP可免费抽奖2次\n2.每消费%d元宝可获得一次抽奖机会\n3.抽奖时候可获得积分，活动结束后根据积分排行榜\n获取超值大奖。\n\n\n注意：抽奖次数每日凌晨0点重置，请及时使用"
TextWords[280005] = "排名"
TextWords[280006] = "玩家名称"
TextWords[280007] = "等级"
TextWords[280008] = "积分"
TextWords[280009] = "0点重置次数"
TextWords[280010] = "正在抽奖中，请稍后！"
TextWords[280011] = "抽奖次数不够！"
TextWords[280012] = "抽中可获得积分："


--世界Boss
TextWords[280100] = "鼓舞"
TextWords[280101] = "已经满级"
TextWords[280102] = "升级需要消耗%d的元宝，确定升级吗？"
TextWords[280103] = "鼓舞成功"
TextWords[280104] = "设置阵型成功"
TextWords[280105] = "取消冷却时间成功"
TextWords[280106] = "玩法开启："
TextWords[280107] = "主公等级达到22级"
TextWords[280108] = "每周星期五晚20:50~21:30\n"
TextWords[280109] = "玩法说明："
TextWords[280110] = "1.参与战斗不损耗部队"
TextWords[280111] = "2.VIP6及其以上可设置自动战斗（请预先设置阵型）"
TextWords[280112] = "3.使用增益道具或购买祝福后，立即生效"
TextWords[280113] = "4.请在规定时间内击杀敌军，否则无法获取排名奖励\n"
TextWords[280114] = "玩法奖励："
TextWords[280115] = "1.参与奖励：每次战斗后随机获得资源奖励，伤害越高"
TextWords[280116] = "   奖励越多"
TextWords[280117] = "2.击杀奖励：击毁敌军小兵，击杀者可获得"
TextWords[280118] = "   蓝色军械箱*1，物资宝箱*1"
TextWords[280119] = "3.最后一击：击杀可获得蓝色军械箱*1，物资宝箱*2\n"
TextWords[280120] = "奖励在战斗后发送"
TextWords[280121] = "排名奖励：敌军被击杀时生效，邮件发送奖励"
TextWords[280122] = "BOSS未能成功击杀"
TextWords[280123] = "最后一击："
TextWords[280124] = "提示：\n\n  是否取消自动战斗？"
TextWords[280125] = "vip6以上才可以自动战斗"
TextWords[280126] = "请先设置阵型"
TextWords[280127] = "自动战斗中不能攻击！"
TextWords[280128] = "提示：\n\n按钮冷却中，是否花费%d元宝消除冷却时间？"
TextWords[280129] = "目前不在冷却时间内"
TextWords[280130] = "伤害"
TextWords[280131] = "活动在%s后开启"
TextWords[280132] = "%s后撤军"
TextWords[280133] = "冷却：%s"
TextWords[280134] = "设置自动挑战成功！"
TextWords[280135] = "取消自动战斗成功！"
TextWords[280136] = "主公等级不足30级，不能参与该活动！"
TextWords[280137] = "未开启"
TextWords[280138] = "开启中"
TextWords[280139] = "玩家未加入同盟！"
TextWords[280140] = "(排名：%s)"


TextWords[280141] ="  报名时间：19:30~~19:55"
TextWords[280142] ="  战场开始：20:00"
TextWords[280143] ="  报名资格：入盟24小时以上"
TextWords[280144] ="  开启条件：报名同盟满10个"
TextWords[280145] ="  其他规则："
TextWords[280146] ="  在报名截止前可取消报名"
TextWords[280147] ="  取消报名后可重新设置阵型报名"
TextWords[280148] ="  取消报名有1分钟冷却时间"
TextWords[280149] ="  战斗死亡部队无需修理"
TextWords[280150] ="  死亡部队会永久损失1%"
TextWords[280151] ="  为确保顺利参战,以及取得好的成绩,建议用最\n  大战力参战"

TextWords[280152] =" 对战规则："
TextWords[280153] =" 攻击方和防守方随机配对战斗"
TextWords[280154] =" 先手值高的先手；先手值一致，攻击方先手"
TextWords[280155] =" 战斗后胜利则剩余部队进入下次战斗"
TextWords[280156] =" 战斗后失败则淘汰"
TextWords[280157] =" 同盟所有参战玩家失败后，同盟淘汰"
TextWords[280158] =" 同盟淘汰时，结算出淘汰同盟排名"
TextWords[280159] =" 排名规则："
TextWords[280160] =" 根据连胜场次，结算玩家连胜排行榜"
TextWords[280161] =" 根据同盟淘汰时间先后，结算同盟混战同盟排行"
TextWords[280162] =" 奖励规则："
TextWords[280163] =" 连胜越高，个人奖励越丰富"
TextWords[280164] =" 战斗消耗高阶兵越多，个人奖励越丰厚"
TextWords[280165] =" 个人奖励在淘汰或同盟战结束后自动发放"
TextWords[280166] =" 个人奖励发放后会收到邮件通知"
TextWords[280167] =" 同盟奖励，同盟排名越高奖励越丰厚"
TextWords[280168] =" 同盟奖励自动发放到福利院-同盟仓库中"
TextWords[280169] =" 盟主可自由分配同盟奖励"

TextWords[280170] ="你们太弱了"
TextWords[280171] ="快来追我啊"
TextWords[280172] ="抢完粮就跑"
TextWords[280173] = "VIP6自动战斗"
TextWords[280174] = "分享成功！"
TextWords[280175] = "您已解散本同盟"
TextWords[280176] = "您所在同盟已被盟主解散"

TextWords[280177] = "连胜排名"
TextWords[280178] = "同盟排名"
--英雄模块
TextWords[290000] = "升星"
TextWords[290001] = "阵法"
TextWords[290002] = "兵法"
TextWords[290003] = "培养"
TextWords[290004] = "上阵"
TextWords[290005] = "卸下"
TextWords[290006] = "当前没有多余的空位！"
TextWords[290007] = "阶阵法"
TextWords[290008] = "级"
TextWords[290009] = "阵法已经达到最高级！"
TextWords[290010] = "阵法升级"
TextWords[290011] = "碎片"
TextWords[290012] = "提示"
TextWords[290013] = "合成"
TextWords[290014] = "获取"
TextWords[290015] = "碎"
TextWords[290016] = "提示：%s不足，是否花费%d元宝补足%s升级兵法？"
TextWords[290017] = "提示：%s不足，是否花费%d元宝补足%s升星？"
TextWords[290018] = "提示：%s不足，是否花费%d元宝补足%s升级战法？"
TextWords[290019] = "白"
TextWords[290020] = "绿"
TextWords[290021] = "蓝"
TextWords[290022] = "紫"
TextWords[290023] = "可上阵"
TextWords[290024] = "已上阵英雄不能当升级材料"
TextWords[290025] = "分解预览"
TextWords[290026] = "分解成功"
TextWords[290027] = "绿色品质以上才能分解"

TextWords[290028] = "世界玩法"
TextWords[290031] = " 1.攻击玩家可掠夺敌方【资源】，摧毁敌军部队可\n 获得【战功】"
TextWords[290032] = " 2.使用【侦查】获取敌人防守部队情报，知己知彼\n 方能百战不殆"
TextWords[290033] = " 3.【防护罩】能保护己方不被侦查和攻打，但同时\n 也无法继续攻击敌人"
TextWords[290041] = " 1.世界地图分布着不同等级的资源矿点，越靠近中心\n 点矿点等级越高；占领矿点后部队将自动进行【采集】"
TextWords[290042] = " 2.高级矿点【产量更高】，攻打获得【经验】越多，\n 同时驻守敌人也【更加强大】"
TextWords[290043] = " 3.攻打矿点会有损兵，选择与自身等级接近的矿点更\n 佳，使用【侦查】可获得驻守敌人部队情报"
TextWords[290051] = " 1.【同盟】是您的强力后盾，盟友之间通过驻守可以\n 抵御敌人的来袭"
TextWords[290052] = " 2.最多可以拥有5支候选协防部队，选择其中一只作\n 为防守部队"
TextWords[290053] = " 3.被驻防的玩家需手动选择驻守部队，在抵御敌军\n 的时候会首先出战驻守部队"
TextWords[290054] = "该功能即将开启"
TextWords[290055] = "%s级后解锁"
TextWords[290056] = "英雄卸下成功"
TextWords[290057] = "英雄上阵成功"
TextWords[290058] = "阵法升级成功！"
TextWords[290059] = "兵法升级成功!"
TextWords[290060] = "换位成功!"



-----群雄逐鹿
TextWords[330000] = [[本轮进度：]]
TextWords[330001] = [[下轮倒计时：]] 
TextWords[330002] = [[报名倒计时]]
TextWords[330003] = [[战场倒计时]]
TextWords[330004] = [[同盟已报名%d人]]
TextWords[330005] = [[下轮日期：%s]]

--------小助手
TextWords[340000] = [[主公%d级开放%s]]
TextWords[340001] = [[官邸%d级开放%s]]

--------副本信息弹窗
TextWords[350000] = [[必掉]]
TextWords[350001] = [[概率]]
TextWords[350002] = [[挑战]]
TextWords[350003] = [[击杀]]
TextWords[350004] = [[经验]]
TextWords[350005] = [[关卡信息]]
TextWords[350006] = [[该章节暂未开启]]

----------------科举乡试殿试
TextWords[360000] = [[答题]]
TextWords[360001] = [[排名]]
TextWords[360002] = [[不答题不获得积分]]
TextWords[360003] = [[正确答题越快，积分越多]]
TextWords[360004] = [[乡试总积分累计排名前200玩家可参加殿试]]
TextWords[360005] = [[答题结束]]
TextWords[360006] = [[未上榜]]
TextWords[360007] = [[奖励]]
TextWords[360008] = [[已领取奖励]]
TextWords[360009] = [[您答题太快，请认真审题]]
TextWords[360010] = [[暂无]]
TextWords[360011] = [[科举答题开启]]
TextWords[360012] = [[很遗憾您并没获得参赛资格，下次努力]]
TextWords[360013] = [[您已提交过本题案卷，请耐心等待新答卷]]
TextWords[360014] = [[您未参与殿试]]
TextWords[360015] = [[第]]
TextWords[360016] = [[名奖励]]
TextWords[360017] = [[到]]
TextWords[360018] = [[题]]
TextWords[360019] = [[正确]]
TextWords[360020] = [[错误]]
TextWords[360021] = [[漏答]]
TextWords[360022] = [[积分奖励]]
TextWords[360023] = [[积分段奖励]]

----------------科举提示
TextWords[361001] = [[【答题规则】]]
TextWords[361002] = [[1. 每次共计20题；]]
TextWords[361003] = [[2. 开启活动后，玩家有一个总答题时间，在总答题]]
TextWords[361004] = [[时间内玩家可随意进行答题]]
TextWords[361005] = [[3. 单题答题时间30秒，回答后会立即刷下一题；单题]]
TextWords[361006] = [[时间结束后也会立即刷下一题；]]
TextWords[361007] = [[4. 每题回答速度越快，连对次数越多，积分越高；]]

TextWords[362001] = [[1. 排名会在活动结束10分钟后刷新； ]]
TextWords[362002] = [[2. 每轮乡试均可根据积分领取对应的奖励；]]
TextWords[362003] = [[3. 每轮奖励会在下次活动开启前清除，请及时领取；]]
TextWords[362004] = [[4. 积分大于1才能进榜，乡试总积分排名前200的玩家]]
TextWords[362005] = [[可进入殿试，争取三甲称号；]]
TextWords[362006] = [[5. 乡试总积分每周二重置清零；]]

TextWords[363001] = [[【答题规则】]]
TextWords[363002] = [[1. 共计20题；]]
TextWords[363003] = [[2. 活动开启后有5分钟准备时间，有资格参加玩家]]
TextWords[363004] = [[可以进行答题操作]]
TextWords[363005] = [[3. 单题答题时间30秒，选择答案后需等单题倒计时]]
TextWords[363006] = [[结束才可进行下一题]]
TextWords[363007] = [[4. 每题回答速度越快，连对次数越多，积分越高；]]
TextWords[363008] = [[5. 前三名积分的玩家会获得对应的殿试称号；]]

TextWords[364001] = [[1. 殿试奖励，根据玩家排名决定；]]
TextWords[364002] = [[2. 前三名玩家可分别获得状元、榜眼、探花的称号，]]
TextWords[364003] = [[称号维持1周时间；]]
TextWords[364004] = [[3. 获得积分大于1才能上榜]]
TextWords[364005] = [[4. 奖励会在下次活动开启前清除，请及时领取；]]

------------------------------------------------------------------------------
----------------城主战
TextWords[370000] = [[未被占领]]
TextWords[370001] = [[争夺时间：周一 %s]]
TextWords[370002] = [[争夺时间：周二 %s]]
TextWords[370003] = [[争夺时间：周三 %s]]
TextWords[370004] = [[争夺时间：周四 %s]]
TextWords[370005] = [[争夺时间：周五 %s]]
TextWords[370006] = [[争夺时间：周六 %s]]
TextWords[370007] = [[争夺时间：周日 %s]]
TextWords[370008] = [[争夺剩余时间：%s]]
TextWords[370009] = [[%s同盟成功占领%s]]
TextWords[370010] = [[请点击城池设置部队进行防守]]
TextWords[370011] = [[升级需要消耗%d元宝，确认升级吗？]]
TextWords[370012] = [[成功占领]]
TextWords[370013] = [[将切换到防守方，]]
TextWords[370014] = [[倒计时　]]
TextWords[370015] = [[%s归属权被抢夺，将切换到进攻方]]
TextWords[370016] = [[恭喜%s同盟获得了%s归属权]]
TextWords[370017] = "休整中，是否使用%d元宝取消休整？"
TextWords[370018] = "如果更换阵型会进入休整时间，是否更换阵型？"
TextWords[370019] = [[下次争夺准备时间：]]
TextWords[370020] = [[下次争夺开始时间：]]
TextWords[370021] = [[(附属同盟享有60%的加成效果)]]
TextWords[370022] = [[归属同盟成员每天可以领取一次宝箱]]
TextWords[370023] = [[+%d&#37;]]
TextWords[370024] = [[资源生产]]
TextWords[370025] = [[行军速度]]
TextWords[370026] = [[采集速度]]
TextWords[370027] = [[投票]]
TextWords[370028] = [[奖励领取]]
TextWords[370029] = [[%d票]]
TextWords[370030] = [[当前未勾选任何同盟]]
TextWords[370031] = [[已领取]]
TextWords[370032] = [[领取]]
TextWords[370033] = [[鼓舞]]
TextWords[370034] = [[已投票]]
TextWords[370035] = [[进攻]]
TextWords[370036] = [[防守]]
TextWords[370037] = [[争夺战未开启，无法进入战场！]]
TextWords[370038] = [[同盟成功占领]]
TextWords[370039] = [[归属权被抢夺，将切换到进攻方]]
TextWords[370040] = [[恭喜]]
TextWords[370041] = [[同盟获得了]]
TextWords[370042] = [[归属权]]
TextWords[370043] = [[同盟占领]]
TextWords[370044] = [[未被占领]]
TextWords[370045] = [[未被占领]]
TextWords[370046] = [[保存阵型成功]]
TextWords[370047] = [[升级]]
TextWords[370048] = [[已满级]]
TextWords[370049] = [[撤回部队]]
TextWords[370050] = [[元宝不足，无法快速休整]]
TextWords[370051] = [[设置快速消除休整成功]]
TextWords[370052] = [[取消快速消除休整成功]]
TextWords[370053] = [[设置阵型]]
TextWords[370054] = [[是否撤回部队(撤回部队会进入休整)?]]
TextWords[370055] = [[争夺剩余时间：]]
TextWords[370056] = [[活动已开启]]
TextWords[370057] = [[休整时间取消成功]]
TextWords[370058] = [[当前是准备阶段，无法进攻]]
TextWords[370059] = [[争夺准备时间：%s]]
TextWords[370060] = [[因参与同盟人数不足，该轮活动不开启]]
TextWords[370061] = [[主公等级未达到20级，无法投票]]
TextWords[370062] = [[只有当前城池的归属城主才有权限]]
TextWords[370063] = [[你当前无法参与争夺战]]
TextWords[370064] = [[因参与同盟数不足，该轮活动不开启]]
TextWords[370065] = [[准备中]]
TextWords[370066] = [[争夺中]]
TextWords[370067] = [[休战中]]
TextWords[370068] = [[申请]]
TextWords[370069] = [[任命]]
TextWords[370070] = [[你已投票]]
TextWords[370071] = [[只有在准备阶段可参与投票]]
TextWords[370072] = [[投票结束]]
TextWords[370073] = [[任命成功]]
TextWords[370074] = [[倒计时未结束，无法进攻]]
TextWords[370075] = [[城墙血量：]]
TextWords[370076] = [[争夺战未开启，无法参与投票]]
TextWords[370077] = [[争夺战未开启，无法升级]]

TextWords[371001] = [[个人战报]]
TextWords[371002] = [[全服战报]]
TextWords[371003] = [[个人排行]]
TextWords[371004] = [[同盟排行]]
TextWords[371005] = [[积分]]

TextWords[372000] = "\n参战资格"
TextWords[372001] = "群雄逐鹿中，排名前16所有同盟成员\n（至少需要10个同盟才会开启城主战）"
TextWords[372002] = "（群雄逐鹿参与人数不足时候，城主战不会开启，\n仍然保留上次活动的归属权）"
TextWords[372003] = "\n竞猜系统"
TextWords[372004] = "所有玩家都能进行投票（投票成功后可以领取奖励）"
TextWords[372005] = "当投票的同盟最终获得城池拥有权时候，\n会额外获得一份邮件奖励"
TextWords[372006] = "\n准备阶段"
TextWords[372007] = "拥有城池归属权的同盟可以设置防守队伍\n（变更防守队伍会进入休整）"
TextWords[372008] = "进攻方不能进行攻击"
TextWords[372009] = "\n对战流程"
TextWords[372010] = "没有同盟防守城池时候击败BOSS将暂时获得归属权\n（BOSS最后一击）"
TextWords[372011] = "当有同盟防守的城池城墙值为0时候，归属权会转移\n（转移到给予城墙最后一击的同盟）"
TextWords[372012] = "只有防守列表里面没有任何防守玩家队伍时候，\n才会显示城墙队伍（消灭城墙部队后城墙血量减少）"
TextWords[372013] = "\n对战规则"
TextWords[372014] = "进攻方每次进攻会进入休整"
TextWords[372015] = "防守方每次变更阵型，会进入休整"
TextWords[372016] = "直到争夺时间结束后，最终拥有城池归属权的同盟\n获得胜利（归属权会持续一直到下周活动开启）"
TextWords[372017] = "\n排名奖励"
TextWords[372018] = "同盟所有玩家积分综合，结算同盟积分排行"
TextWords[372019] = "同盟奖励会直接派送到同盟福利所，盟主分配"
TextWords[372020] = "根据个人积分，结算同盟内和全服玩家个人积分排行"
TextWords[372021] = "个人积分会转换成同盟贡献度"
TextWords[372022] = "获得城池的同盟后会获得城池增益效果\n每天可以领取一份奖励\n　"


------------------------------------------------------------------------------
-- 同盟相关
TextWords[380000] = "已向全体同盟成员求助！"
TextWords[380001] = "本次同盟战结束，"
TextWords[380002] = "获得第"
TextWords[380003] = "名"
TextWords[380004] = " 被"
TextWords[380005] = " 淘汰，获得第"
TextWords[380006] = "参与同盟"
------------------------------------------------------------------------------
--限时 春节活动 爆竹酉礼
TextWords[390000] = [[活动]]
TextWords[390001] = [[奖励]]
TextWords[390002] = "点燃鞭炮，爆出好礼\n玩家每日充值指定额度即可获得点燃爆竹机会\n充值88、588、1288、2888、4888、9888元宝获得点燃爆竹机会"
TextWords[390003] = [[每次点燃鞭炮可随机获得以下一份奖励]]
TextWords[390004] = [[你去充钱嘛不充点不了的]]
TextWords[390005] = [[爆竹点燃中，请稍后]]
--抢红包
TextWords[391000] = [[还有%s秒才可以抢]]
--武学讲堂
TextWords[392000] = [[武学讲堂]]
TextWords[392001] = [[学分排行]]
TextWords[392002] = [[排行奖励]]
TextWords[392003] = [[免费学习]]
TextWords[392004] = [[学习一次]]
TextWords[392005] = "著名历史兵法阵法大师在洛阳进行军事交流！\n每天登陆可免费学习一次！\n每次学习都能让您的武将受益匪浅哦！"
TextWords[392006] = [[活动时间：]]
TextWords[392007] = "提示：是否花费%d元宝学习%d次？"
TextWords[392008] = [[——]]
TextWords[392009] = [[年]]
TextWords[392010] = [[月]]
TextWords[392011] = [[日]]

TextWords[392101] = [[1. 排行榜只显示排行前]]
TextWords[392102] = [[名]]
TextWords[392103] = [[2. 积分大于]]
TextWords[392104] = [[才能进入排行榜]]
TextWords[392105] = [[3. 等级大于]]
TextWords[392106] = [[级才能进入排行榜]]


----------------消灭叛军
TextWords[401000] = [[乱军]]
TextWords[401001] = [[排名]]
TextWords[401002] = [[奖励]]
TextWords[401004] = [[未击杀]]
TextWords[401005] = [[击杀:]]
TextWords[401006] = [[未出现]]
TextWords[401007] = [[已刷新]]
TextWords[401008] = [[已关闭]]
TextWords[401009] = [[喽啰(%d/%d)    头目(%d/%d)    首领(%d/%d)]]
TextWords[401011] = [[玩家名称]]
TextWords[401012] = [[军团名称]]
TextWords[401013] = [[头目]]
TextWords[401014] = [[首领]]
TextWords[401015] = [[%s出没:]]

TextWords[401200] = [[乱军信息]]
TextWords[401201] = [[第%d名奖励]]
TextWords[401202] = [[第%d - %d名奖励]]
TextWords[401203] = [[未上榜]]
TextWords[401204] = [[未加入军团]]
TextWords[401300] = [[%s级%s]]

TextWords[401400] = "1. 乱军来袭玩法，每天中午12:00和晚上21:00都会\n刷出一批乱军，乱军存在时间为1小时"
TextWords[401401] = "2. 乱军分为喽啰、头目和将领，每隔10分钟依次刷\n出，奖励积分也不同"
TextWords[401402] = "3. 每次活动可击杀乱军数量：5个；击杀超过这个数\n量的乱军将不会获得奖励和积分"
TextWords[401403] = "4. 进击乱军可随机获得进攻奖励，击杀乱军才能获\n得击杀奖励和积分"
TextWords[401404] = "5. 一个乱军据点可以同时被多名玩家攻击"
TextWords[401405] = "6. 1小时内击杀所有乱军可以获得全服奖励，若未能\n全部击杀则剩余乱军会逃跑"
TextWords[401406] = "7. 派出队伍攻击乱军需要消耗1个讨伐令，若抵达乱\n军地点时乱军已被击杀，则队伍自动遣返，\n同时邮件补偿1个讨伐令"
TextWords[401407] = "8. 战斗若有战损，则损兵死亡比例为1%"
TextWords[401408] = "9. 每击杀一个乱军都会获得对应的积分，每周一0点\n会结算上周的周积分排行，并可领取周排名奖励"

TextWords[401410] = "1. 个人积分≥20才能进入个人排行榜"
TextWords[401411] = "2. 军团积分≥50才能进入军团排行榜"

TextWords[401420] = "1. 奖励每周一0点刷新，领取时间持续到下周结算"
TextWords[401421] = "2. 军团奖励，需要玩家所在军团进入排名，且玩家自\n身有上周乱军积分才能领取"



----------------洛阳闹市
TextWords[410000] = [[人气商店]]
TextWords[410001] = [[特卖商店]]
TextWords[410002] = [[数量:%d]]
TextWords[410003] = [[原价:%d]]
TextWords[410004] = [[现价:%d]]
TextWords[410005] = [[%s后刷新]]
TextWords[410006] = [[商人派卷倒计时:%s]]
TextWords[410007] = [[购买]]
TextWords[410008] = [[拥有:]]
TextWords[410009] = [[优惠券:]]
