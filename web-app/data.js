// ============================================
// 开悟个体增智智能办公套件 V1.4.1 - 内容数据
// ============================================

const FEATURES_DATA = [
    {
        icon: 'agent',
        color: 'purple',
        title: '智能体入口（待验收）',
        desc: '提供 AionUI、Hermes 和 OpenCode 安装入口；具体智能体能力需在 Windows 7 目标机验收。',
        list: ['组件安装入口', '本地工具注册', '配置文件', '执行日志']
    },
    {
        icon: 'mcp',
        color: 'blue',
        title: '本地工具注册',
        desc: '通过 JSON 注册表管理本地批处理工具的输入、输出和日志路径。',
        list: ['统一工具清单', '固定输入输出', '本地脚本调用', '执行日志']
    },
    {
        icon: 'a2a',
        color: 'amber',
        title: '本地任务编排',
        desc: '使用批处理和 PowerShell 串联搜索、OCR、笔记与状态检查。',
        list: ['OCR 转 Markdown', 'OCR 转 Obsidian', 'Git 状态报告', '系统检测修复']
    },
    {
        icon: 'knowledge',
        color: 'green',
        title: '知识管理系统',
        desc: '提供 Obsidian 本地笔记与 Markdown 模板；XMind 当前未随候选版交付。',
        list: ['双向链接知识网络', 'Markdown 文件整理', '思维导图可视化', '本地文件检索']
    },
    {
        icon: 'office',
        color: 'pink',
        title: '智能办公套件',
        desc: 'WPS Office 安装与插件配置入口已保留；AI 插件来源参考 Kaiwu，上游要求 Windows 10/11 与 WPS 12.1.0.26375+，Win7 SP1 兼容性阻断待验证。PPT workflow 仅登记为参考源，未随 V1.4.1 交付。',
        list: ['WPS 安装框架', 'Kaiwu 来源登记', 'PPT 参考源登记', 'AI 默认未启用']
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
        desc: '<strong>状态：</strong>规划场景，尚未完成 Windows 7 端到端验收；请以已验证脚本和验收记录为准。',
        steps: ['确认组件已安装', '运行对应本地脚本', '核对输出与日志', '记录验收结果'],
        tags: ['规划场景', '待实机验收']
    },
    {
        id: 'case2',
        icon: 'meeting',
        title: '会议管理场景',
        desc: '<strong>状态：</strong>规划场景，尚未完成 Windows 7 端到端验收；请以已验证脚本和验收记录为准。',
        steps: ['确认组件已安装', '运行对应本地脚本', '核对输出与日志', '记录验收结果'],
        tags: ['规划场景', '待实机验收']
    },
    {
        id: 'case3',
        icon: 'data',
        title: '数据分析场景',
        desc: '<strong>状态：</strong>规划场景，尚未完成 Windows 7 端到端验收；请以已验证脚本和验收记录为准。',
        steps: ['确认组件已安装', '运行对应本地脚本', '核对输出与日志', '记录验收结果'],
        tags: ['规划场景', '待实机验收']
    },
    {
        id: 'case4',
        icon: 'knowledge',
        title: '知识管理场景',
        desc: '<strong>状态：</strong>规划场景，尚未完成 Windows 7 端到端验收；请以已验证脚本和验收记录为准。',
        steps: ['确认组件已安装', '运行对应本地脚本', '核对输出与日志', '记录验收结果'],
        tags: ['规划场景', '待实机验收']
    },
    {
        id: 'case5',
        icon: 'search',
        title: '文件管理场景',
        desc: '<strong>状态：</strong>规划场景，尚未完成 Windows 7 端到端验收；请以已验证脚本和验收记录为准。',
        steps: ['确认组件已安装', '运行对应本地脚本', '核对输出与日志', '记录验收结果'],
        tags: ['规划场景', '待实机验收']
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
    { id: 'wps', icon: 'office', color: 'blue', title: 'WPS Office', desc: '插件待 Win7 验证' },
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
        a: ['套件目标环境为 Windows 7 SP1 64 位', 'Kaiwu 上游要求 Windows 10/11，插件需单独验收', '需要 4GB 以上内存，10GB 可用磁盘空间']
    },
    {
        q: '是否需要联网使用？',
        a: ['当前已验证脚本默认离线运行', 'Kaiwu 类 AI 插件如启用需出站 HTTPS 和模型密钥审批', '知识管理与 OCR 输出保存在本地用户目录']
    },
    {
        q: '如何更新套件版本？',
        a: ['当前不提供自动升级', '新版本必须重新校验 SHA256', '升级前请备份用户数据', '由管理员按发布说明执行']
    },
    {
        q: '数据安全如何保障？',
        a: ['本地脚本默认不上传文件', '未提供端到端加密证明', '未取得等保三级认证', '用户应按单位制度自行备份']
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
    var isTechBlue = document.documentElement.classList.contains('theme-techblue');
    if (isTechBlue) {
        return ICONS[name] || ICONS.doc;
    }
    var defaultMap = {
        agent: 'chip', mcp: 'chip', a2a: 'signal', knowledge: 'binary',
        office: 'lock', tools: 'antenna', search: 'radar', write: 'doc',
        meeting: 'signal', data: 'binary', mind: 'chip', system: 'shield',
        fix: 'antenna', check: 'shield', help: 'guide', update: 'antenna',
        case: 'shield', community: 'satellite'
    };
    return ICONS[defaultMap[name] || name] || ICONS[name];
}
