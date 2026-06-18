// ============================================
// 开悟个体增智智能办公套件 V1.0 - 内容数据
// ============================================

const FEATURES_DATA = [
    {
        icon: 'agent',
        color: 'purple',
        title: 'AI Agent 智能代理',
        desc: '基于大语言模型的智能代理系统，能够理解自然语言指令，自动执行复杂任务链，支持多轮对话与上下文记忆。',
        list: ['自然语言理解与执行', '多步骤任务自动编排', '上下文记忆与学习', '工具调用与结果解析']
    },
    {
        icon: 'mcp',
        color: 'blue',
        title: 'MCP 协议中枢',
        desc: 'Model Context Protocol 实现，提供标准化的 AI 模型与外部工具连接协议，让不同 AI 组件无缝协作。',
        list: ['标准化工具接口', '跨模型协作能力', '安全沙箱执行环境', '实时状态同步']
    },
    {
        icon: 'a2a',
        color: 'amber',
        title: 'A2A 通信协议',
        desc: 'Agent-to-Agent 协议实现，支持多个 AI 代理之间的自主通信与任务分配，构建分布式智能网络。',
        list: ['代理间自主通信', '分布式任务调度', '负载均衡与容错', '联邦学习支持']
    },
    {
        icon: 'knowledge',
        color: 'green',
        title: '知识管理系统',
        desc: '集成 Obsidian 双向链接笔记与 XMind 思维导图，构建个人知识图谱，AI 自动整理与关联知识。',
        list: ['双向链接知识网络', 'AI 自动标签分类', '思维导图可视化', '知识检索与推荐']
    },
    {
        icon: 'office',
        color: 'pink',
        title: '智能办公套件',
        desc: 'WPS Office 深度集成 AI 能力，支持文档智能生成、表格数据分析、PPT 自动排版，效率提升 300%。',
        list: ['AI 文档自动生成', '智能表格分析', 'PPT 一键排版', '多格式互转']
    },
    {
        icon: 'tools',
        color: 'cyan',
        title: '效率工具集',
        desc: 'OCR 文字识别、Everything 全局搜索、系统检测修复等实用工具，覆盖办公全流程需求。',
        list: ['OCR 多语言识别', '毫秒级文件搜索', '系统健康检测', '一键自动修复']
    }
];

const CASES_DATA = [
    {
        id: 'case1',
        icon: 'write',
        title: '公文写作场景',
        desc: '<strong>痛点：</strong>传统公文写作耗时耗力，格式规范难以把握，政策引用容易遗漏。<br><br><strong>方案：</strong>AI Agent 深度理解公文写作规范，结合知识库自动检索相关政策法规，智能生成符合党政机关标准的公文初稿，支持一键格式校验与修改建议。<br><br><strong>价值：</strong>公文写作时间从平均 2 小时缩短至 15 分钟，格式规范率提升至 99.5%，政策引用准确率达 100%。',
        steps: ['选择公文类型（通知/报告/请示等）', '输入核心要点与关键信息', 'AI 自动检索相关政策法规', '生成符合规范的公文初稿', '一键校验格式与内容'],
        tags: ['AI 写作', '格式自动校验', '政策智能检索', '效率提升 800%']
    },
    {
        id: 'case2',
        icon: 'meeting',
        title: '会议管理场景',
        desc: '<strong>痛点：</strong>会议记录繁琐，纪要整理耗时，任务分配难以追踪，跨部门协作效率低。<br><br><strong>方案：</strong>AI 实时转录会议语音，自动生成结构化会议纪要，智能提取待办事项并分配到人，通过 A2A 协议同步至各协作系统。<br><br><strong>价值：</strong>会议纪要生成时间从 1 小时缩短至 5 分钟，任务完成率提升 60%，跨部门协作效率提升 200%。',
        steps: ['一键开启会议录音', 'AI 实时语音转文字', '自动生成结构化纪要', '智能提取待办事项', '任务自动分配与追踪'],
        tags: ['语音转录', '智能纪要', '任务追踪', '协作效率提升 200%']
    },
    {
        id: 'case3',
        icon: 'data',
        title: '数据分析场景',
        desc: '<strong>痛点：</strong>Excel 数据处理复杂，报表制作耗时，数据分析需要专业技能，数据可视化困难。<br><br><strong>方案：</strong>WPS AI 智能分析表格数据，自动生成可视化图表，支持自然语言查询数据，一键生成专业分析报告。<br><br><strong>价值：</strong>数据分析时间从半天缩短至 10 分钟，报表制作效率提升 500%，非专业人员也能完成专业分析。',
        steps: ['导入 Excel/CSV 数据文件', 'AI 自动识别数据结构', '自然语言描述分析需求', '智能生成图表与报告', '一键导出多种格式'],
        tags: ['智能分析', '自动可视化', '自然语言查询', '报表效率提升 500%']
    },
    {
        id: 'case4',
        icon: 'knowledge',
        title: '知识管理场景',
        desc: '<strong>痛点：</strong>知识碎片化严重，文档散落各处，检索困难，知识传承断层。<br><br><strong>方案：</strong>Obsidian 构建双向链接知识网络，AI 自动整理文档、打标签、建关联，形成可检索的个人知识图谱。<br><br><strong>价值：</strong>知识检索时间从 30 分钟缩短至 10 秒，知识复用率提升 400%，新人培训周期缩短 60%。',
        steps: ['导入现有文档与笔记', 'AI 自动分析内容结构', '智能建立知识关联', '构建双向链接网络', '自然语言知识检索'],
        tags: ['知识图谱', '双向链接', 'AI 自动整理', '知识复用率提升 400%']
    },
    {
        id: 'case5',
        icon: 'search',
        title: '文件管理场景',
        desc: '<strong>痛点：</strong>文件散乱难以查找，版本管理混乱，共享协作困难，存储空间不足。<br><br><strong>方案：</strong>Everything 毫秒级全局搜索，结合 AI 智能分类与标签，支持模糊搜索与语义理解，快速定位任意文件。<br><br><strong>价值：</strong>文件查找时间从 5 分钟缩短至 1 秒，文件管理效率提升 300%，存储空间优化 40%。',
        steps: ['输入文件名或关键词', 'AI 智能匹配与排序', '预览文件内容摘要', '一键打开或分享', '自动归档与标签'],
        tags: ['毫秒搜索', '语义理解', '智能分类', '管理效率提升 300%']
    }
];

const GUIDE_DATA = [
    {
        num: '01',
        title: '环境检测',
        items: ['运行系统检测工具', '检查 Windows 7+ 环境', '验证硬件配置要求', '确认网络连接状态']
    },
    {
        num: '02',
        title: '一键安装',
        items: ['下载套件安装包', '运行自动安装脚本', '等待组件部署完成', '安装完成提示']
    },
    {
        num: '03',
        title: '功能配置',
        items: ['配置 AI 模型参数', '设置知识库路径', '调整界面偏好', '连接外部服务']
    },
    {
        num: '04',
        title: '开始使用',
        items: ['浏览功能介绍', '尝试场景案例', '查阅使用文档', '加入用户社区']
    }
];

const ENTRY_DATA = [
    { id: 'aionui', icon: 'agent', color: 'purple', title: 'AionUI Agent', desc: 'AI 代理界面' },
    { id: 'wps', icon: 'office', color: 'blue', title: 'WPS Office', desc: '智能办公套件' },
    { id: 'obsidian', icon: 'knowledge', color: 'green', title: 'Obsidian', desc: '知识管理工具' },
    { id: 'xmind', icon: 'mind', color: 'amber', title: 'XMind', desc: '思维导图工具' },
    { id: 'everything', icon: 'search', color: 'cyan', title: 'Everything', desc: '极速文件搜索' },
    { id: 'ocr', icon: 'tools', color: 'pink', title: 'OCR 识别', desc: '文字识别工具' },
    { id: 'check', icon: 'system', color: 'green', title: '系统检测', desc: '环境健康检查' },
    { id: 'repair', icon: 'fix', color: 'amber', title: '系统修复', desc: '一键问题修复' }
];

const FAQ_DATA = [
    {
        q: '套件支持哪些操作系统？',
        a: ['支持 Windows 7 及以上操作系统', '推荐 Windows 10/11 获得最佳体验', '需要 4GB 以上内存，2GB 可用磁盘空间']
    },
    {
        q: '是否需要联网使用？',
        a: ['AI 功能需要联网调用云端模型', '基础办公功能支持离线使用', '知识管理模块完全离线可用']
    },
    {
        q: '如何更新套件版本？',
        a: ['运行系统检测工具检查更新', '一键下载最新版本', '自动完成组件升级', '更新过程不影响现有数据']
    },
    {
        q: '数据安全如何保障？',
        a: ['所有数据本地存储，不上传云端', '支持端到端加密', '符合等保 2.0 三级要求', '定期自动备份数据']
    },
    {
        q: '遇到问题如何获取帮助？',
        a: ['查阅内置帮助文档', '运行系统诊断工具', '联系技术支持团队', '加入用户社区交流']
    }
];

const DOCS_DATA = [
    { file: '00_环境检查报告.md', icon: 'check', title: '环境检查报告', desc: '系统环境检测与诊断结果' },
    { file: '01_安装手册.md', icon: 'doc', title: '安装手册', desc: '详细安装步骤与配置指南' },
    { file: '02_用户使用手册.md', icon: 'user', title: '用户使用手册', desc: '功能操作与使用技巧详解' },
    { file: '03_管理员维护手册.md', icon: 'tools', title: '管理员维护手册', desc: '系统维护与管理员操作指南' },
    { file: '04_场景案例手册.md', icon: 'case', title: '场景案例手册', desc: '典型应用场景与实战案例' },
    { file: '05_常见问题FAQ.md', icon: 'help', title: '常见问题 FAQ', desc: '问题解答与故障排除指南' },
    { file: '06_版本清单与依赖说明.md', icon: 'update', title: '版本清单与依赖', desc: '组件版本与依赖关系说明' },
    { file: '07_安全与合规说明.md', icon: 'guide', title: '安全与合规说明', desc: '安全策略与合规性文档' }
];

// SVG Icons
var ICONS = {
    agent: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M12 2a4 4 0 014 4v2a4 4 0 01-8 0V6a4 4 0 014-4z"/><path d="M16 14H8a6 6 0 00-6 6v1h20v-1a6 6 0 00-6-6z"/><circle cx="9" cy="8" r="1" fill="currentColor"/><circle cx="15" cy="8" r="1" fill="currentColor"/></svg>',
    mcp: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8"/><path d="M12 17v4"/><path d="M7 8h10"/><path d="M7 11h6"/></svg>',
    a2a: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="5" cy="12" r="3"/><circle cx="19" cy="12" r="3"/><path d="M8 12h8"/><path d="M13 9l3 3-3 3"/></svg>',
    knowledge: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M4 19V5a2 2 0 012-2h8l6 6v10a2 2 0 01-2 2H6a2 2 0 01-2-2z"/><path d="M9 12h6"/><path d="M9 15h4"/><path d="M14 3v6h6"/></svg>',
    office: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 10h18"/><path d="M8 4v6"/><path d="M16 4v6"/></svg>',
    tools: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z"/></svg>',
    search: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>',
    write: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>',
    meeting: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>',
    data: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M18 20V10"/><path d="M12 20V4"/><path d="M6 20v-6"/></svg>',
    mind: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M12 8v8"/><path d="M8 12h8"/></svg>',
    system: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8"/><path d="M12 17v4"/></svg>',
    fix: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z"/></svg>',
    doc: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><path d="M14 2v6h6"/><path d="M16 13H8"/><path d="M16 17H8"/><path d="M10 9H8"/></svg>',
    user: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>',
    code: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><polyline points="16,18 22,12 16,6"/><polyline points="8,6 2,12 8,18"/></svg>',
    help: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3"/><path d="M12 17h.01"/></svg>',
    update: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="17,8 12,3 7,8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>',
    guide: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M2 3h6a4 4 0 014 4v14a3 3 0 00-3-3H2z"/><path d="M22 3h-6a4 4 0 00-4 4v14a3 3 0 013-3h7z"/></svg>',
    case: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v2"/></svg>',
    community: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>',
    check: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22,4 12,14.01 9,11.01"/></svg>',
    // CETC-specific icons
    shield: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M9 12l2 2 4-4"/></svg>',
    radar: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/><path d="M12 2v4"/><path d="M12 18v4"/><path d="M2 12h4"/><path d="M18 12h4"/></svg>',
    satellite: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="3"/><path d="M3 15l4-4"/><path d="M7 11l-4-4"/><path d="M17 7l4 4"/><path d="M21 11l-4 4"/><path d="M3 9l4 4"/><path d="M7 13l-4 4"/></svg>',
    signal: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M2 20h.01"/><path d="M7 20v-4"/><path d="M12 20v-8"/><path d="M17 20V8"/><path d="M22 20V4"/></svg>',
    chip: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="4" y="4" width="16" height="16" rx="2"/><rect x="9" y="9" width="6" height="6"/><path d="M15 2v2"/><path d="M15 20v2"/><path d="M2 15h2"/><path d="M2 9h2"/><path d="M20 15h2"/><path d="M20 9h2"/><path d="M9 2v2"/><path d="M9 20v2"/></svg>',
    lock: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>',
    antenna: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M12 2v8"/><path d="M8 6l4-4 4 4"/><circle cx="12" cy="14" r="4"/><path d="M12 18v4"/><path d="M8 22h8"/></svg>',
    binary: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M4 6h2"/><path d="M4 10h2"/><path d="M4 14h2"/><path d="M4 18h2"/><path d="M10 4v16"/><path d="M16 6h4"/><path d="M16 10h4"/><path d="M16 14h4"/><path d="M16 18h4"/></svg>'
};

function getIcon(name) {
    var isCetc = document.documentElement.classList.contains('theme-cetc');
    if (isCetc) {
        var cetcMap = {
            agent: 'chip', mcp: 'chip', a2a: 'signal', knowledge: 'binary',
            office: 'lock', tools: 'antenna', search: 'radar', write: 'doc',
            meeting: 'signal', data: 'binary', mind: 'chip', system: 'shield',
            fix: 'antenna', check: 'shield', help: 'guide', update: 'antenna',
            case: 'shield', community: 'satellite'
        };
        return ICONS[cetcMap[name] || name] || ICONS[name];
    }
    return ICONS[name] || ICONS.doc;
}
