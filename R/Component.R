# ---- 内部工具（不导出） ----
#' @noRd
lm_solve <- function(design, response, only.SSE = FALSE, ...) {
  l <- .lm.fit(design, as.matrix(response))
  fitted <- design %*% l$coefficients
  SSE <- sum(l$residuals^2)
  if (!only.SSE) {
    list(
      coef = l$coefficients, fitted = as.vector(fitted),
      resi = l$residuals, SSE = SSE
    )
  } else {
    list(SSE = SSE)
  }
}

# ---- 去季节 ----
#' 去季节
#'
#' 按“月日”分组计算季节均值，并返回去季节序列。
#'
#' @param y 观测值向量。
#' @param t_mmdd 对应的月日（MMDD）。
#'
#' @return 列表，含 `mu`（季节均值）和 `anomaly`（去季节序列）。
#' @export
#' @examples
#' RemoveSeasonal(1:4, c(101, 101, 102, 102))
RemoveSeasonal <- function(y, t_mmdd) {
  inds <- sort(unique(t_mmdd))
  mu <- numeric(length(inds))
  anomaly <- numeric(length(y))
  for (i in seq_along(inds)) {
    ind <- which(t_mmdd == inds[i])
    mu[i] <- mean(y[ind], na.rm = TRUE)
    anomaly[ind] <- y[ind] - mu[i]
  }
  list(mu = mu, anomaly = anomaly)
}

# ---- 多断点分段回归 ----
#' 多断点分段回归（同斜率、不同截距）
#'
#' @param Y 响应值（观测序列）。
#' @param X 自变量（通常为时间序列）。
#' @param Ips 各段末尾的位置，末位为序列长度。
#' @param ... 传给 `lm_solve()`。
#'
#' @return 列表，含 `coef`、`fitted`、`resi`、`SSE`。
#' @export
#' @examples
#' x <- 1:10
#' y <- c(1:5, 11:15)
#' LS_MultiBreaks(y, x, c(5, 10))
LS_MultiBreaks <- function(Y, X, Ips, ...) {
  n_breaks <- length(Ips) - 1
  design <- cbind(1, X - mean(X))
  for (i in seq_len(n_breaks)) {
    segment <- numeric(length(Y))
    segment[(Ips[i] + 1):Ips[i + 1]] <- 1
    design <- cbind(design, segment)
  }
  lm_solve(design, Y, ...)
}

# ---- 单断点分段回归 ----
#' 单断点分段回归（同斜率、不同截距）
#'
#' @param Y 响应值。
#' @param X 自变量。
#' @param Ic 断点位置，`[1, Ic]` 与 `[Ic+1, end]` 为两段。
#' @param ... 传给 `lm_solve()`。
#'
#' @return 列表，含 `coef`、`fitted`、`resi`、`SSE`。
#' @export
#' @examples
#' x <- 1:10
#' y <- c(1:5, 11:15)
#' LS_OneBreak(y, x, 5)
LS_OneBreak <- function(Y, X, Ic, ...) {
  n <- length(Y)
  design <- cbind(1, X)
  if (!is.na(Ic)) {
    design <- cbind(design, c(rep(0, Ic), rep(1, n - Ic)))
  }
  lm_solve(design, Y, ...)
}
