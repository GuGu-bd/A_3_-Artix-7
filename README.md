# A_3_-Artix-7

基于 AMD Artix-7 的 FPGA 入门学习与考核作品（野火升腾系列）。

本仓库为考核「选题三：基于 AMD Artix-7 的 FPGA 入门」的提交物，包含从组合逻辑到状态机共 12 个递进式 Verilog 练习工程，
每个工程均含 RTL 设计文件、Testbench 仿真文件，以及自行绘制的 Visio 波形图。

学习视频教程前依靠 ai 自行了解了基本的数电知识，对于 RTL 视图目前并不能完全理解。
学习过程中 vivado 文件所选的板子与视频教程中一样。

## 开发环境

| 项目 | 内容 |
| --- | --- |
| FPGA 器件 | `xc7a35tfgg484-2`（Artix-7 35T，与教程所用板卡一致） |
| EDA 工具 | Vivado 2022.1 |
| 仿真工具 | Vivado 自带仿真器 xsim |
| 代码编辑器 | VS Code |
| 波形绘制 | Visio |
| 设计语言 | Verilog HDL |

> 所有选题均不需要进行硬件上板验证，核心考察 RTL 逻辑编写与 Testbench 仿真能力，
> 因此本仓库统一采用「xsim 行为仿真 + Visio 波形图比对」的方式验证功能。

## 目录结构

```
A_3_-Artix-7
├── 001_LEDlight             # 01 点亮 LED
├── 002_mux2_1               # 02 二选一多路选择器
├── 003_decoder              # 03 3-8 译码器
├── 004_half_add             # 04 半加器
├── 005_full_add             # 05 全加器（实例化半加器）
├── 006_flip_flop            # 06 D 触发器
├── 007_counter              # 07 计数器（1s 闪烁）
├── 008_divider_six          # 08 六分频器
├── 009_key_filter           # 09 按键消抖
├── 010_breath_led           # 10 呼吸灯
├── 011_simple_fsm           # 11 简单状态机（售货机）
├── 012_complex_fsm          # 12 复杂状态机（售货机 + 找零）
├── LICENSE                  # MIT License
└── README.md
```

每个工程目录内结构统一：

```
XXX_工程名
├── doc                          # 自行绘制的波形图（Visio 源文件）
│   └── xxx.vsdx
├── vivado_project               # Vivado 工程目录
│   ├── xxx.xpr                  # Vivado 工程文件
│   └── xxx.srcs
│       ├── sources_1\new        # 设计文件（RTL）
│       ├── sim_1\new            # 仿真文件（Testbench）
│       └── constrs_1\new        # 约束文件（仅 001 含 .xdc）
└── README.md
```

说明：

- `doc` 文件夹中存放绘制的波形图，`vivado_project` 文件夹作为 vivado 项目，代码的存放使用 vivado 的默认存放位置；
- 设计文件存放于 `vivado_project\xxx.srcs\sources_1\new`；
- 仿真文件存放于 `vivado_project\xxx.srcs\sim_1\new`；
- `xxx` 为项目名称，工程内的 Vivado 工程名与目录编号存在少量差异：`002_mux2_1` 内为 `mux_2_1`，
  `004_half_add` 内为 `half_sum`，`008_divider_six` 内为 `divider`，其余工程与目录名一致；
- 设计文件、仿真文件命名以工程内实际文件为准，部分文件名与内部 module 名并不完全相同（如 `tb_divider.v` 内为 `tb_divider_six`）。

## 工程一览

| 编号 | 目录 | 顶层模块 | 功能 | 验证方式 |
| --- | --- | --- | --- | --- |
| 01 | `001_LEDlight` | `led` | 按键控制 LED 亮灭 | `tb_led.v` 随机激励 + 波形图 |
| 02 | `002_mux2_1` | `mux2_1` | 二选一多路选择器 | `tb_mux2_1.v` + `$monitor` |
| 03 | `003_decoder` | `decoder` | 3-8 译码器 | `tb_decoder.v` + `$monitor` |
| 04 | `004_half_add` | `half_add` | 1 位半加器 | `tb_half_add.v` + `$monitor` |
| 05 | `005_full_add` | `full_adder` | 两个半加器级联构成全加器 | `tb_full_adder.v` + `$monitor` |
| 06 | `006_flip_flop` | `flip_flop` | 异步复位 D 触发器 | `tb_flip_flop.v`，含反复复位验证 |
| 07 | `007_counter` | `counter` | 参数化计数器，计满翻转 LED | `tb_counter.v`，`CNT_MAX` 改小 |
| 08 | `008_divider_six` | `divider_six` | 六分频，输出 `clk_flag` 脉冲 | `tb_divider.v`（`tb_divider_six`），`CNT_MAX` 改小 + 波形比对 |
| 09 | `009_key_filter` | `key_filter` | 按键消抖，计数 20ms 输出标志 | `tb_key_filter.v`，模拟抖动激励 |
| 10 | `010_breath_led` | `breath_led` | 呼吸灯，多级计数比较产生渐变 | `tb_breath_led.v`，参数改小 + 波形观察 |
| 11 | `011_simple_fsm` | `simple_fsm` | 简单状态机：投币两次出一瓶可乐 | `tb_simple_fsm.v`，随机投币 + `$monitor` |
| 12 | `012_complex_fsm` | `complex_fsm` | 复杂状态机：支持投币与找零 | `tb_complex_fsm.v`，随机投币 + 波形观察 |

## 各工程说明

**01 `001_LEDlight` —— 点亮 LED**
通过按键实现 LED 的亮灭，`led_out = ~key_in`。要点是跑通 Vivado 工程建立、添加约束文件
（`led.xdc`：`key_in`→V17，`led_out`→M21，LVCMOS33）、综合实现与仿真的完整流程。波形图：`doc/led.vsdx`。

**02 `002_mux2_1` —— 二选一多路选择器**
`sel` 为 1 时输出 `in_1`，否则输出 `in_2`。选择了使用 `if else` 语句完成的方法。波形图：`doc/mux2_1.vsdx`。

**03 `003_decoder` —— 3-8 译码器**
将 3 位输入 `{in_1,in_2,in_3}` 译码为 8 位独热输出。先以 `if/else if` 写出全部 8 种情况（代码中注释保留），
再改写为 `case` 语句，对比两种写法。波形图：`doc/decoder.vsdx`。

**04 `004_half_add` —— 半加器**
1 位半加器，`{count,sum} = in_1 + in_2`，练习位拼接与位宽扩展。波形图：`doc/half_add.vsdx`。

**05 `005_full_add` —— 全加器**
由两个半加器加一个或门构成，首次使用模块实例化与端口名关联（`.port(signal)`），
把 `half_add.v` 一并加入 sources，练习层次化设计。波形图：`doc/full_add.vsdx`。

**06 `006_flip_flop` —— D 触发器**
`sys_clk` 上升沿锁存 `key_in` 到 `led_out`，`sys_rst_n` 低电平异步复位。
理解时序逻辑模板、非阻塞赋值与复位优先级；Testbench 中刻意反复拉低复位以观察复位行为。波形图：`doc/flip_flop.vsdx`。

**07 `007_counter` —— 计数器（1s 闪烁）**
`CNT_MAX = 25'd24_999_999`（50MHz 下 0.5s），计满后翻转 `led_out`，实现约 1s 周期的闪烁。
掌握参数化设计（`#(parameter ...)`），Testbench 中把 `CNT_MAX` 改小为 `25'd24` 以快速仿真。波形图：`doc/counter.vsdx`。

**08 `008_divider_six` —— 六分频**
对 `sys_clk` 六分频输出 `clk_flag` 标志脉冲（而非门控时钟）。
由于使用`clk_flag`降频的方式，所以奇偶都可以使用。波形图：`doc/divider_six.vsdx`。

**09 `009_key_filter` —— 按键消抖**
`CNT_MAX = 20'd999_999`（50MHz 下约 20ms），按键保持低电平超过该时长后输出 `key_flag` 脉冲。
Testbench 用 `tb_cnt` 分段在 `key_in` 上模拟抖动段与稳定按下段。波形图：`doc/key_filter.vsdx`。

**10 `010_breath_led` —— 呼吸灯**
通过 1us / 1ms / 1s 三级计数产生 `cnt_en` 方向标志，比较 `cnt_1ms` 与 `cnt_1s` 改变 `led_out` 占空比，
实现由暗到亮、再由亮到暗的呼吸效果。练习多级计数器级联使能与参数化。波形图：`doc/breath_led.vsdx`。

**11 `011_simple_fsm` —— 简单状态机（售货机）**
可乐 2 元，每次投币 1 元；`IDLE → ONE → TWO` 三状态，在 `TWO` 状态下再投币一次输出 `po_cola` 脉冲并回到 `IDLE`。
首次编写状态机，采用独热码编码；Testbench 通过层次化引用 `simple_fsm_inst.state` 把内部状态引出到 `$monitor`
观察跳转。波形图：`doc/simple_fsm.vsdx`。

**12 `012_complex_fsm` —— 复杂状态机（售货机 + 找零）**
可乐 2.5 元，支持 0.5 元与 1 元投币；`IDLE / HALF / ONE / ONE_HALF / TWO` 五状态，
满足金额后 `po_cola` 出可乐，投入 3 元时 `po_money` 输出找零。要点是五状态独热码编码、
把两路投币合并为 `pi_money = {pi_money_one, pi_money_half}` 后统一判断、状态转移与输出逻辑分块编写。
Testbench 用 `$random` 轮流产生两路随机投币序列。波形图：`doc/complex_fsm.vsdx`。

## 仿真与波形查看方式

1. 用 Vivado 2022.1 打开对应工程的 `vivado_project\xxx.xpr`；
2. 在 Flow Navigator 中运行 **Simulation → Run Behavioral Simulation**；
   07/08/09/10 等工程已在 Testbench 内覆盖计数阈值参数，仿真时间很短；
3. 在波形窗口观察结果，与 `doc\xxx.vsdx` 中自行绘制的预期波形对照；
4. 02/03/04/05/07/11 的 Testbench 还使用 `$monitor` 打印信号变化，可在 Tcl Console 中直接查看。

## 学习过程与自评

- 学习视频教程前依靠 ai 自行了解了基本的数电知识，对于 RTL 视图目前并不能完全理解，仍在持续学习中；
- 学习过程中 vivado 文件所选的板子与视频教程中一样；
- 008 分频器以后的项目由于已经大概了解了FPGA的开发过程，因此采用先观看教程中的波形图了解需要做出的功能后，自行完成设计、仿真、对比波形的过程，依靠 ai 进行修正，最后再对照视频补齐功能的步骤；
- 全程未进行上板验证，所有功能均以行为仿真波形为准。

## License

本项目基于 [MIT License](LICENSE) 开源，Copyright (c) 2026 GuGu_bd。
