const std = @import("std");
const math = std.math;

/// `dictionary` の長さをもとに、ビットマスクを計算します
/// > 辞書文字列の長さをそのままモジュロ計算すると、公平性(統計的バイアス)の問題が発生するため、長さをそれに近い2進数に切り上げる
pub fn calculateBitsMask(dictionary_len: usize) usize {
    if (dictionary_len <= 1) @panic("指定の辞書文字列が短すぎます。2文字以上必要です。");

    const bits: u6 = @intCast(math.log2_int_ceil(usize, dictionary_len));
    // usizeは64が最大だけど、u6は0~63なのでu7として出力されてしまうので修正

    const mask: usize = (@as(usize, 1) << bits) - 1;
    return mask;
}

/// ビットマスクをもとに、一回で生成するランダムバイト数を計算します
/// > 辞書文字列インデックス範囲外が生成されるのを考慮して、`nanoid`をもとに1.6倍することで余裕を持っておく
pub fn calculateBatchSize(dictionary_len: usize, required_len: usize, mask: usize) usize {
    if (dictionary_len <= 1) @panic("指定の辞書文字列が短すぎます。2文字以上必要です。");

    const batch_size = @ceil((1.6 * @as(f64, @floatFromInt(mask + 1)) * @as(f64, @floatFromInt(required_len))) / @as(f64, @floatFromInt(dictionary_len)));

    return @as(usize, @intFromFloat(batch_size));
}
