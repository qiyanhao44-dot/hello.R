#import "@local/modern-cug-report:0.1.3": *
#show: doc => template(doc, footer: "水文气象学", header: "Component.R")

= Component 函数说明

== 概述

`R/Component.R` 提供气候序列去季节与分段回归的基础函数。

== RemoveSeasonal

按“月日”（MMDD）分组计算季节均值，并返回去季节序列。

*参数*
- `y`：观测值向量。
- `t_mmdd`：对应的月日（MMDD）。

*返回*：列表，含 `mu`（季节均值）、`anomaly`（去季节序列）。

*示例*：`RemoveSeasonal(1:4, c(101, 101, 102, 102))`

== LS_OneBreak

单断点分段回归（同斜率、不同截距）。

*参数*
- `Y`：响应值。
- `X`：自变量。
- `Ic`：断点位置。

*返回*：列表，含 `coef`、`fitted`、`resi`、`SSE`。

*示例*：`LS_OneBreak(c(1:5, 11:15), 1:10, 5)$fitted`

== LS_MultiBreaks

多断点分段回归（同斜率、不同截距）。

*参数*
- `Y`：响应值。
- `X`：自变量。
- `Ips`：各段末尾位置，末位为序列长度。

*返回*：列表，含 `coef`、`fitted`、`resi`、`SSE`。

*示例*：`LS_MultiBreaks(c(1:5, 11:15), 1:10, c(5, 10))$fitted`
